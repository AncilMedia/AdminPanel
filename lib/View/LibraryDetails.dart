import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Controller/Media_analytics_controller.dart';

class _ChartData {
  final String date; // x-axis: date
  final double views;
  final Color color;
  final String device;

  _ChartData(this.date, this.views, this.color, this.device);
}

class LibraryDetails extends StatefulWidget {
  final String mediaitemid;

  const LibraryDetails({super.key, required this.mediaitemid});

  @override
  State<LibraryDetails> createState() => _LibraryDetailsState();
}

class _LibraryDetailsState extends State<LibraryDetails> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _speakerController = TextEditingController();
  final TextEditingController _scriptureController = TextEditingController();
  final TextEditingController _topicsController = TextEditingController();

  bool isLoading = true;
  String? error;
  late TooltipBehavior _tooltipBehavior;
  int totalViews = 0;
  int peakViews = 0;

  final AnalyticsService analyticsService = AnalyticsService();
  List<_ChartData> chartData = [];
  Map<String, dynamic>? analyticsData;

  // Example tag lists
  final List<String> speakers = ["Speaker 1", "Speaker 2", "Speaker 3", "Speaker 4"];
  final List<String> scriptures = ["Scripture 1", "Scripture 2", "Scripture 3"];
  final List<String> topics = ["Topic 1", "Topic 2", "Topic 3"];

  // Device color map
  final Map<String, Color> deviceColors = {
    "ios": Colors.amber,
    "android": Colors.blue,
    "appleTv": Colors.purple,
    "roku": Colors.orange,
    "webApp": Colors.green,
    "webEmbed": Colors.teal,
    "other": Colors.grey,
  };

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      color: Colors.blueAccent.withOpacity(0.9),
      textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      format: 'point.x : point.y views',
    );
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await analyticsService.getSingleMediaAnalytics(widget.mediaitemid);

      final Map<String, dynamic> devicesByDate = Map<String, dynamic>.from(data['devices'] ?? {});

      List<_ChartData> tempChart = [];
      int maxViews = 0;
      int total = 0;

      devicesByDate.forEach((date, deviceMap) {
        final Map<String, dynamic> dMap = Map<String, dynamic>.from(deviceMap);
        dMap.forEach((device, value) {
          double views = (value ?? 0).toDouble();
          if (views > 0) { // ✅ Only include data > 0
            tempChart.add(_ChartData(date, views, deviceColors[device]!, device));
            total += views.toInt();
            if (views > maxViews) maxViews = views.toInt();
          }
        });
      });

      setState(() {
        analyticsData = data;
        chartData = tempChart;
        totalViews = total;
        peakViews = maxViews;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _showSideSheet({
    required BuildContext context,
    required String title,
    required List<String> items,
    List<String>? preSelected,
    required Function(List<String>) onSelected,
  }) {
    List<String> filteredItems = List.from(items);
    List<String> selected = preSelected != null ? List.from(preSelected) : [];
    final TextEditingController newItemController = TextEditingController();
    final TextEditingController searchController = TextEditingController();

    showGeneralDialog(
      context: context,
      barrierLabel: "SideSheet",
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.8,
                padding: const EdgeInsets.all(16),
                child: StatefulBuilder(
                  builder: (context, setSheetState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: newItemController,
                                decoration: const InputDecoration(
                                  hintText: "Add new item",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                final newItem = newItemController.text.trim();
                                if (newItem.isNotEmpty && !items.contains(newItem)) {
                                  setSheetState(() {
                                    items.add(newItem);
                                    filteredItems.add(newItem);
                                    selected.add(newItem);
                                    newItemController.clear();
                                  });
                                }
                              },
                              child: const Text("Add"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Search...",
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setSheetState(() {
                                  searchController.clear();
                                  filteredItems = List.from(items);
                                });
                              },
                            )
                                : null,
                          ),
                          onChanged: (val) {
                            setSheetState(() {
                              filteredItems = items.where((e) => e.toLowerCase().contains(val.toLowerCase())).toList();
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final isSelected = selected.contains(item);
                              return ListTile(
                                title: Text(item),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle, color: Colors.blue)
                                    : const Icon(Icons.circle_outlined),
                                onTap: () {
                                  setSheetState(() {
                                    if (isSelected) {
                                      selected.remove(item);
                                    } else {
                                      selected.add(item);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            onSelected(selected);
                            Navigator.pop(context);
                          },
                          child: const Text("Done"),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(anim1),
          child: child,
        );
      },
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black26),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
            ],
          ),
        ],
      ),
    ),
  );

  InputDecoration _inputDecoration({String? hint, IconData? icon}) => InputDecoration(
    hintText: hint,
    suffixIcon: icon != null ? Icon(icon) : null,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black12),
      borderRadius: BorderRadius.circular(6),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blueAccent),
      borderRadius: BorderRadius.circular(6),
    ),
  );

  Widget _buildInputField({String? hint, int maxLines = 1, TextEditingController? controller}) =>
      TextFormField(controller: controller, maxLines: maxLines, decoration: _inputDecoration(hint: hint));

  Widget _buildSelectableField({required TextEditingController controller, required String hint, required VoidCallback onTap}) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(6),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  controller.clear();
                  setState(() {});
                },
              ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaBox(double height) => Container(
    height: height,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.black12),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double boxWidth = size.width * 0.85;

    // Group chartData by device for stacked column chart
    Map<String, List<_ChartData>> seriesMap = {};
    for (var d in chartData) {
      seriesMap.putIfAbsent(d.device, () => []).add(d);
    }

    List<StackedColumnSeries<_ChartData, String>> chartSeries = seriesMap.entries.map((entry) {
      return StackedColumnSeries<_ChartData, String>(
        dataSource: entry.value,
        xValueMapper: (d, _) => d.date,
        yValueMapper: (d, _) => d.views,
        name: entry.key,
        pointColorMapper: (d, _) => d.color,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        width: 0.3,
      );
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text("Error: $error"))
          : Column(
        children: [
          // Chart Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.075),
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.35,
                    child: SfCartesianChart(
                      title: ChartTitle(text: 'Analytics: ${widget.mediaitemid}'),
                      primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Date'), labelRotation: 45),
                      primaryYAxis: NumericAxis(title: AxisTitle(text: 'Views')),
                      legend: Legend(isVisible: true, position: LegendPosition.bottom),
                      tooltipBehavior: _tooltipBehavior,
                      series: chartSeries,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatCard(Icons.remove_red_eye, '$totalViews', 'Total Plays'),
                      const SizedBox(width: 12),
                      _buildStatCard(Icons.bar_chart, '$peakViews', 'Peak Views'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Form Section
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: boxWidth,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Basic Details", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    _buildInputField(hint: "Enter title"),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildInputField(hint: "Enter author")),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            decoration: _inputDecoration(hint: "Select date", icon: Iconsax.calendar_1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(hint: "Enter description", maxLines: 4),
                    const SizedBox(height: 24),
                    Text("Tags", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    _buildSelectableField(
                      controller: _speakerController,
                      hint: "Select Speakers",
                      onTap: () => _showSideSheet(
                        context: context,
                        title: "Select Speakers",
                        items: speakers,
                        preSelected: _speakerController.text.isEmpty ? [] : _speakerController.text.split(", "),
                        onSelected: (selected) => setState(() => _speakerController.text = selected.join(", ")),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSelectableField(
                      controller: _scriptureController,
                      hint: "Select Scripture",
                      onTap: () => _showSideSheet(
                        context: context,
                        title: "Select Scripture",
                        items: scriptures,
                        preSelected: _scriptureController.text.isEmpty ? [] : _scriptureController.text.split(", "),
                        onSelected: (selected) => setState(() => _scriptureController.text = selected.join(", ")),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSelectableField(
                      controller: _topicsController,
                      hint: "Select Topics",
                      onTap: () => _showSideSheet(
                        context: context,
                        title: "Select Topics",
                        items: topics,
                        preSelected: _topicsController.text.isEmpty ? [] : _topicsController.text.split(", "),
                        onSelected: (selected) => setState(() => _topicsController.text = selected.join(", ")),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text("Video", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(width: boxWidth, child: _buildMediaBox(size.height * 0.2)),
                    const SizedBox(height: 16),
                    Text("Audio", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(width: boxWidth, child: _buildMediaBox(size.height * 0.1)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
