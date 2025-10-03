import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import '../Controller/Media_analytics_controller.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  Map<String, dynamic>? analyticsData;
  bool isLoading = true;
  String? error;
  late TooltipBehavior _tooltipBehavior;

  // Pagination & Sorting
  int limit = 50;
  String sortField = "date";
  String sortOrder = "desc";

  // Filters
  DateTime? startDate;
  DateTime? endDate;
  Map<String, dynamic>? selectedMediaItem;

  List<Map<String, dynamic>> allMediaList = []; // Full list for dropdown
  final AnalyticsService analyticsService = AnalyticsService();

  // Dropdown controller
  late SingleSelectController<String?> mediaController;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    mediaController = SingleSelectController<String?>(null);
    fetchAnalytics();
  }

  Future<void> fetchAnalytics({bool filtered = false}) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      String? mediaItemIdValue;
      if (filtered &&
          selectedMediaItem != null &&
          mediaController.value != "All Media") {
        mediaItemIdValue = selectedMediaItem!['id'] as String?;
      }

      final data = await analyticsService.getAllMediaAnalytics(
        limit: limit,
        sortField: sortField,
        sortOrder: sortOrder,
        mediaItemId: mediaItemIdValue,
        startDate: startDate,
        endDate: endDate,
      );

      final chartDataRaw = List<Map<String, dynamic>>.from(
        data['chartData'] ?? [],
      );

      // ✅ Parse backend months only (no extras)
      final df = DateFormat("MMM yyyy");
      final chartData = chartDataRaw.map((d) {
        return {...d, 'dateObj': df.parse(d['month'])};
      }).toList();

      // ✅ Sort by actual date so they’re sequential
      chartData.sort(
        (a, b) =>
            (a['dateObj'] as DateTime).compareTo(b['dateObj'] as DateTime),
      );

      setState(() {
        analyticsData = {...data, 'chartData': chartData};
        allMediaList = List<Map<String, dynamic>>.from(data['mediaList'] ?? []);
        isLoading = false;
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

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => startDate = picked);
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => endDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text("📊 Media Analytics"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: fetchAnalytics,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          : buildDashboard(),
    );
  }

  Widget buildDashboard() {
    final chartData = List<Map<String, dynamic>>.from(
      analyticsData?['chartData'] ?? [],
    );
    final mediaItems = List<Map<String, dynamic>>.from(
      analyticsData?['mediaList'] ?? [],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filters
          Row(
            children: [
              const Text("Start Date:"),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _selectStartDate,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.purpleAccent.withOpacity(0.1)
                    ),
                    height: MediaQuery.of(context).size.height * .0400,
                    width: MediaQuery.of(context).size.width * .0500,
                    child: Center(
                      child: Text(
                        startDate != null
                            ? DateFormat("dd MMM yyyy").format(startDate!)
                            : "Select",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w400,color: Colors.purple),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text("End Date:"),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _selectEndDate,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purpleAccent.withOpacity(0.1)
                    ),
                    height: MediaQuery.of(context).size.height * .0400,
                    width: MediaQuery.of(context).size.width * .0500,
                    child: Center(
                      child: Text(
                        endDate != null
                            ? DateFormat("dd MMM yyyy").format(endDate!)
                            : "Select",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w400,color: Colors.purple),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // ElevatedButton(
              //   onPressed: () => fetchAnalytics(filtered: true),
              //   child: const Text("Apply Filters"),
              // ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: ()=>fetchAnalytics(filtered: true),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purpleAccent.withOpacity(0.1)
                    ),
                    height: MediaQuery.of(context).size.height * .0400,
                    width: MediaQuery.of(context).size.width * .0700,
                    child:  Center(
                      child: Text("Apply Filters",style: GoogleFonts.poppins(
                        color: Colors.purple
                      ),),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: clearFilters,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purpleAccent.withOpacity(0.1)
                    ),
                    height: MediaQuery.of(context).size.height * .0400,
                    width: MediaQuery.of(context).size.width * .0700,
                    child: Center(
                      child: Text("Clear Filters",style: GoogleFonts.poppins(
                        color: Colors.purple
                      ),),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 16),

          // Chart
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            shadowColor: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "📅 Monthly Device Usage Overview",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 350,
                    child: SfCartesianChart(
                      primaryXAxis: const CategoryAxis(
                        title: AxisTitle(text: 'Month'),
                        labelRotation: -45,
                        majorGridLines: MajorGridLines(width: 0),
                      ),
                      primaryYAxis: const NumericAxis(
                        title: AxisTitle(text: 'Plays'),
                      ),
                      legend: const Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                      ),
                      tooltipBehavior: _tooltipBehavior,
                      series: <CartesianSeries>[
                        _buildStackedSeries(
                          chartData,
                          'ios',
                          'iOS',
                          Colors.amber,
                        ),
                        _buildStackedSeries(
                          chartData,
                          'android',
                          'Android',
                          Colors.blue,
                        ),
                        _buildStackedSeries(
                          chartData,
                          'webApp',
                          'Web App',
                          Colors.green,
                        ),
                        _buildStackedSeries(
                          chartData,
                          'appleTv',
                          'Apple TV',
                          Colors.purple,
                        ),
                        _buildStackedSeries(
                          chartData,
                          'roku',
                          'Roku',
                          Colors.orange,
                        ),
                        _buildStackedSeries(
                          chartData,
                          'webEmbed',
                          'Web Embed',
                          Colors.teal,
                        ),
                        _buildStackedSeries(
                          chartData,
                          'other',
                          'Other',
                          Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Media Table
          Text(
            "🎬 Media Performance",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              children: [
                SizedBox(width: 60, child: Text("Thumbnail")),
                SizedBox(width: 12),
                Expanded(flex: 4, child: Text("Title")),
                Expanded(flex: 2, child: Text("Plays")),
                Expanded(flex: 2, child: Text("Viewers")),
                Expanded(flex: 3, child: Text("Avg Duration")),
                Expanded(flex: 3, child: Text("Total Time")),
              ],
            ),
          ),
          const SizedBox(height: 6),
          ...mediaItems.map((item) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      item['thumbnailUrl'] ?? "",
                      width: 60,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 40,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] ?? "",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (item['date'] != null)
                          Text(
                            DateFormat("dd MMM yyyy").format(
                              DateTime.tryParse(item['date']) ?? DateTime.now(),
                            ),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(flex: 2, child: Text(item['plays'].toString())),
                  Expanded(
                    flex: 2,
                    child: Text(item['uniqueViewers'].toString()),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(item['avgDuration'].toString()),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(item['totalPlayTime'].toString()),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// 🔹 Build aligned stacked columns (CategoryAxis)
  StackedColumnSeries<Map<String, dynamic>, String> _buildStackedSeries(
    List<Map<String, dynamic>> data,
    String key,
    String name,
    Color color,
  ) {
    return StackedColumnSeries<Map<String, dynamic>, String>(
      dataSource: data,
      xValueMapper: (d, _) => d['month'],
      yValueMapper: (d, _) => d[key] ?? 0,
      name: name,
      color: color,
      width: 0.1,
      dataLabelSettings: const DataLabelSettings(isVisible: false),
    );
  }
}
