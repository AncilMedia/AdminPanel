import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Controller/Media_Item_controller.dart';
import '../Controller/Media_analytics_controller.dart';

class _ChartData {
  final String date;
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
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

  File? selectedVideo;
  File? selectedAudio;

  // Example tag lists with backend IDs
  final List<Map<String, dynamic>> speakers = [
    {"_id": "650c8f2a4a3b1a23b4d5c6e7", "name": "Speaker 1"},
    {"_id": "650c8f2a4a3b1a23b4d5c6e8", "name": "Speaker 2"},
  ];
  final List<Map<String, dynamic>> scriptures = [
    {"_id": "650c8f2a4a3b1a23b4d5c6f1", "name": "Scripture 1"},
    {"_id": "650c8f2a4a3b1a23b4d5c6f2", "name": "Scripture 2"},
  ];
  final List<Map<String, dynamic>> topics = [
    {"_id": "650c8f2a4a3b1a23b4d5c701", "name": "Topic 1"},
    {"_id": "650c8f2a4a3b1a23b4d5c702", "name": "Topic 2"},
  ];

  List<String> selectedSpeakerIds = [];
  List<String> selectedScriptureIds = [];
  List<String> selectedTopicIds = [];

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
          if (views > 0) {
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

  Future<void> _pickFile({required bool isVideo}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: isVideo ? FileType.video : FileType.audio,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        if (isVideo) {
          selectedVideo = File(result.files.single.path!);
        } else {
          selectedAudio = File(result.files.single.path!);
        }
      });
    }
  }

  Future<void> _saveMediaItem() async {
    if (_titleController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Title and Description are required")),
      );
      return;
    }

    if (selectedVideo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Please select a video file")),
      );
      return;
    }

    try {
      final result = await MediaItemService().createMediaItem(
        file: selectedVideo!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        // date: _dateController.text.isNotEmpty ? _dateController.text : null,
        speakers: selectedSpeakerIds,
        scriptures: selectedScriptureIds,
        topics: selectedTopicIds,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Media Item created successfully!")),
      );

      // Clear all fields
      _titleController.clear();
      _descriptionController.clear();
      _dateController.clear();
      _speakerController.clear();
      _scriptureController.clear();
      _topicsController.clear();
      setState(() {
        selectedVideo = null;
        selectedAudio = null;
        selectedSpeakerIds = [];
        selectedScriptureIds = [];
        selectedTopicIds = [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed: $e")),
      );
    }
  }

  void _showSideSheet({
    required BuildContext context,
    required String title,
    required List<Map<String, dynamic>> items,
    List<String>? preSelected,
    required Function(List<String>) onSelected,
  }) {
    List<Map<String, dynamic>> filteredItems = List.from(items);
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
                              filteredItems = items.where((e) => e['name'].toLowerCase().contains(val.toLowerCase())).toList();
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final isSelected = selected.contains(item['_id']);
                              return ListTile(
                                title: Text(item['name']),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle, color: Colors.blue)
                                    : const Icon(Icons.circle_outlined),
                                onTap: () {
                                  setSheetState(() {
                                    if (isSelected) {
                                      selected.remove(item['_id']);
                                    } else {
                                      selected.add(item['_id']);
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

  Widget _buildMediaBox(double height, {bool isVideo = true}) => GestureDetector(
    onTap: () => _pickFile(isVideo: isVideo),
    child: Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: Center(
        child: Text(
          isVideo ? (selectedVideo != null ? "Selected Video" : "Pick Video") : (selectedAudio != null ? "Selected Audio" : "Pick Audio"),
          style: const TextStyle(color: Colors.black54),
        ),
      ),
    ),
  );

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double boxWidth = size.width * 0.85;

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
        dataLabelSettings: const DataLabelSettings(isVisible: false),
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
                    _buildInputField(hint: "Enter title", controller: _titleController),
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
                    _buildInputField(hint: "Enter description", maxLines: 3, controller: _descriptionController),
                    const SizedBox(height: 16),
                    _buildSelectableField(
                      controller: _speakerController,
                      hint: "Select Speakers",
                      onTap: () => _showSideSheet(
                        context: context,
                        title: "Speakers",
                        items: speakers,
                        preSelected: selectedSpeakerIds,
                        onSelected: (ids) {
                          setState(() {
                            selectedSpeakerIds = ids;
                            _speakerController.text =
                                speakers.where((s) => ids.contains(s['_id'])).map((s) => s['name']).join(', ');
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSelectableField(
                      controller: _scriptureController,
                      hint: "Select Scriptures",
                      onTap: () => _showSideSheet(
                        context: context,
                        title: "Scriptures",
                        items: scriptures,
                        preSelected: selectedScriptureIds,
                        onSelected: (ids) {
                          setState(() {
                            selectedScriptureIds = ids;
                            _scriptureController.text =
                                scriptures.where((s) => ids.contains(s['_id'])).map((s) => s['name']).join(', ');
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSelectableField(
                      controller: _topicsController,
                      hint: "Select Topics",
                      onTap: () => _showSideSheet(
                        context: context,
                        title: "Topics",
                        items: topics,
                        preSelected: selectedTopicIds,
                        onSelected: (ids) {
                          setState(() {
                            selectedTopicIds = ids;
                            _topicsController.text =
                                topics.where((s) => ids.contains(s['_id'])).map((s) => s['name']).join(', ');
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMediaBox(100, isVideo: true),
                    const SizedBox(height: 16),
                    _buildMediaBox(80, isVideo: false),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveMediaItem,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Save Media Item"),
                      ),
                    ),
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
