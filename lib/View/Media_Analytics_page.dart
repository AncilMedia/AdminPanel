import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import '../Controller/Media_analytics_controller.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> with TickerProviderStateMixin {
  Map<String, dynamic>? analyticsData;
  bool isLoading = true;
  String? error;
  late TooltipBehavior _tooltipBehavior;
  late AnimationController _contentController;

  // Pagination & Sorting
  int limit = 50;
  String sortField = "date";
  String sortOrder = "desc";

  // Filters
  DateTime? startDate;
  DateTime? endDate;
  Map<String, dynamic>? selectedMediaItem;
  List<Map<String, dynamic>> allMediaList = [];

  final AnalyticsService analyticsService = AnalyticsService();
  late SingleSelectController<String?> mediaController;
  final TextStyle baseStyle = GoogleFonts.poppins();

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    mediaController = SingleSelectController<String?>(null);
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    fetchAnalytics();
  }

  @override
  void dispose() {
    _contentController.dispose();
    mediaController.dispose();
    super.dispose();
  }

  Future<void> fetchAnalytics({bool filtered = false}) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      String? mediaItemIdValue;
      if (filtered && selectedMediaItem != null && mediaController.value != "All Media") {
        mediaItemIdValue = selectedMediaItem!['id'] as String?;
      }

      final data = await analyticsService.getAllMediaAnalyticsByOrganization(
        limit: limit,
        sortField: sortField,
        sortOrder: sortOrder,
        // mediaItemId: mediaItemIdValue,
        startDate: startDate,
        endDate: endDate,
      );

      final chartDataRaw = List<Map<String, dynamic>>.from(data['chartData'] ?? []);
      final df = DateFormat("MMM yyyy");

      final chartData = chartDataRaw.map((d) => {...d, 'dateObj': df.parse(d['month'])}).toList();
      chartData.sort((a, b) => (a['dateObj'] as DateTime).compareTo(b['dateObj'] as DateTime));

      setState(() {
        analyticsData = {...data, 'chartData': chartData};
        allMediaList = List<Map<String, dynamic>>.from(data['mediaList'] ?? []);
        isLoading = false;
        _contentController.forward(from: 0);
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void clearFilters() {
    setState(() {
      startDate = null;
      endDate = null;
      selectedMediaItem = null;
      mediaController.value = null;
    });
    fetchAnalytics(filtered: false);
  }

  // --- UI BUILDER ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text("Media Analytics", style: baseStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.blueGrey.shade900,
        actions: [
          IconButton(onPressed: fetchAnalytics, icon: const Icon(Iconsax.refresh, size: 20)),
          const SizedBox(width: 16),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? _buildErrorState()
          : _buildDashboardBody(),
    );
  }

  Widget _buildDashboardBody() {
    final chartData = List<Map<String, dynamic>>.from(analyticsData?['chartData'] ?? []);
    final mediaItems = List<Map<String, dynamic>>.from(analyticsData?['mediaList'] ?? []);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _staggeredEntry(0.0, 0.4, child: _buildFilterBar()),
          const SizedBox(height: 32),
          _staggeredEntry(0.1, 0.5, child: _buildQuickStats(mediaItems)),
          const SizedBox(height: 32),
          _staggeredEntry(0.2, 0.6, child: _buildChartSection(chartData)),
          const SizedBox(height: 32),
          _staggeredEntry(0.3, 0.7, child: _buildMediaTable(mediaItems)),
        ],
      ),
    );
  }

  // --- DASHBOARD COMPONENTS ---

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _buildDateButton("Start Date", startDate, _selectStartDate),
          _buildDateButton("End Date", endDate, _selectEndDate),
          _buildActionButton("Apply Filters", Iconsax.filter_edit, Colors.indigo, () => fetchAnalytics(filtered: true)),
          _buildActionButton("Clear", Iconsax.refresh, Colors.blueGrey, clearFilters),
        ],
      ),
    );
  }

  Widget _buildQuickStats(List mediaItems) {
    int totalPlays = mediaItems.fold(0, (sum, item) => sum + (item['plays'] as int));
    int totalViewers = mediaItems.fold(0, (sum, item) => sum + (item['uniqueViewers'] as int));

    return Row(
      children: [
        _statCard("Total Plays", _fmt(totalPlays), Iconsax.play_circle, Colors.blue),
        const SizedBox(width: 20),
        _statCard("Reach", _fmt(totalViewers), Iconsax.personalcard, Colors.purple),
        const SizedBox(width: 20),
        _statCard("Media Items", mediaItems.length.toString(), Iconsax.video_octagon, Colors.orange),
      ],
    );
  }

  Widget _buildChartSection(List<Map<String, dynamic>> chartData) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Platform Distribution", style: baseStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),

          SizedBox(
            height: 350,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                labelStyle: baseStyle.copyWith(fontSize: 11),
              ),
              primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                labelStyle: baseStyle.copyWith(fontSize: 11),
              ),
              legend: Legend(isVisible: true, position: LegendPosition.bottom, textStyle: baseStyle.copyWith(fontSize: 12)),
              tooltipBehavior: _tooltipBehavior,
              series: <CartesianSeries>[
                _buildStackedSeries(chartData, 'ios', 'iOS', Colors.amber),
                _buildStackedSeries(chartData, 'android', 'Android', Colors.blue),
                _buildStackedSeries(chartData, 'webApp', 'Web App', Colors.green),
                _buildStackedSeries(chartData, 'appleTv', 'Apple TV', Colors.purple),
                _buildStackedSeries(chartData, 'roku', 'Roku', Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaTable(List mediaItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Content Performance", style: baseStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mediaItems.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade50),
            itemBuilder: (context, index) {
              final item = mediaItems[index];
              return ListTile(
                contentPadding: const EdgeInsets.all(20),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(item['thumbnailUrl'] ?? "", width: 90, height: 50, fit: BoxFit.cover,
                      errorBuilder: (_,__,___) => Container(width: 90, height: 50, color: Colors.grey.shade100, child: const Icon(Iconsax.image))),
                ),
                title: Text(item['title'] ?? "Untitled Content", style: baseStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text("Views: ${item['plays']}  •  Unique: ${item['uniqueViewers']}",
                    style: baseStyle.copyWith(fontSize: 12, color: Colors.blueGrey.shade400)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(item['totalPlayTime'].toString(), style: baseStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.indigo)),
                    Text("Total Time", style: baseStyle.copyWith(fontSize: 10, color: Colors.grey.shade400)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- HELPERS ---

  Widget _staggeredEntry(double start, double end, {required Widget child}) {
    final animation = CurvedAnimation(parent: _contentController, curve: Interval(start, end, curve: Curves.easeOutQuart));
    return FadeTransition(opacity: animation, child: SlideTransition(position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(animation), child: child));
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: baseStyle.copyWith(fontSize: 12, color: Colors.blueGrey.shade300)),
              Text(value, style: baseStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade900)),
            ]),
          ],
        ),
      ),
    );
  }

  StackedColumnSeries<Map<String, dynamic>, String> _buildStackedSeries(List<Map<String, dynamic>> data, String key, String name, Color color) {
    return StackedColumnSeries<Map<String, dynamic>, String>(
      dataSource: data,
      xValueMapper: (d, _) => d['month'],
      yValueMapper: (d, _) => d[key] ?? 0,
      name: name,
      color: color,
      width: 0.3,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
    );
  }

  String _fmt(int value) => NumberFormat.compact().format(value);

  Widget _buildDateButton(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade100)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Iconsax.calendar, size: 16, color: Colors.indigo),
          const SizedBox(width: 10),
          Text(date != null ? DateFormat("dd MMM yyyy").format(date) : label, style: baseStyle.copyWith(fontSize: 13, color: Colors.blueGrey)),
        ]),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: Colors.white),
      label: Text(label, style: baseStyle.copyWith(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
      style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 0),
    );
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(context: context, initialDate: startDate ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now());
    if (picked != null) setState(() => startDate = picked);
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(context: context, initialDate: endDate ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now());
    if (picked != null) setState(() => endDate = picked);
  }

  Widget _buildErrorState() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(error!), const SizedBox(height: 16), ElevatedButton(onPressed: fetchAnalytics, child: const Text("Retry"))]));
}