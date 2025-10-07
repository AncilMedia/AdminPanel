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

  // SingleSelectControllers must be initialized with null
  final SingleSelectController<String> _speakerController = SingleSelectController<String>(null);
  final SingleSelectController<String> _topicsController = SingleSelectController<String>(null);
  final SingleSelectController<String> _scriptureController = SingleSelectController<String>(null);

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

  List<Map<String, dynamic>> speakers = [];
  List<Map<String, dynamic>> topics = [];
  List<Map<String, dynamic>> scriptures = [];

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

  late MediaItemService mediaDataController;

  @override
  void initState() {
    super.initState();
    mediaDataController = MediaItemService();

    _tooltipBehavior = TooltipBehavior(
      enable: true,
      color: Colors.blueAccent.withOpacity(0.9),
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      format: 'point.x : point.y views',
    );

    fetchInitialData();
    fetchAnalytics();
  }

  Future<void> fetchInitialData() async {
    try {
      final sp = await mediaDataController.fetchSpeakers();
      final tp = await mediaDataController.fetchTopics();
      final sc = await mediaDataController.fetchScriptures();

      setState(() {
        speakers = sp;
        topics = tp;
        scriptures = sc;
      });
    } catch (e) {
      print("Error fetching initial data: $e");
    }
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
            tempChart.add(
              _ChartData(date, views, deviceColors[device] ?? Colors.grey, device),
            );
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
        const SnackBar(content: Text("Title and Description are required")),
      );
      return;
    }

    if (selectedVideo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a video file")),
      );
      return;
    }

    DateTime? selectedDate;
    if (_dateController.text.isNotEmpty) {
      selectedDate = DateTime.tryParse(_dateController.text);
    }

    try {
      await mediaDataController.createMediaItem(
        file: selectedVideo!,
        thumbnailFile: selectedAudio,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        selectedDate: selectedDate,
        speakers: selectedSpeakerIds,
        topics: selectedTopicIds,
        scriptures: selectedScriptureIds,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Media Item created successfully!")),
      );

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed: $e")));
    }
  }

  InputDecoration _inputDecoration({String? hint, IconData? icon}) =>
      InputDecoration(
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
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: _inputDecoration(hint: hint),
      );

  Widget _buildMediaBox(double height, {bool isVideo = true}) =>
      GestureDetector(
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
              isVideo
                  ? (selectedVideo != null ? "Selected Video" : "Pick Video")
                  : (selectedAudio != null ? "Selected Audio" : "Pick Audio"),
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

    List<StackedColumnSeries<_ChartData, String>> chartSeries = seriesMap.entries
        .map((entry) => StackedColumnSeries<_ChartData, String>(
      dataSource: entry.value,
      xValueMapper: (d, _) => d.date,
      yValueMapper: (d, _) => d.views,
      name: entry.key,
      pointColorMapper: (d, _) => d.color,
      dataLabelSettings: const DataLabelSettings(isVisible: false),
      width: 0.3,
    )).toList();

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
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                ],
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
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                  ],
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

                    // 🔹 Speakers Dropdown with Add New
                    Text("Speakers", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child:CustomDropdown.search(
                            hintText: 'Select a speaker...',
                            controller: _speakerController,
                            items: [
                              // If input text is non-empty and not in the list, show "+ Add" at the top
                              if (_speakerController.value != null &&
                                  _speakerController.value!.isNotEmpty &&
                                  !speakers.any((e) => e['name'] == _speakerController.value))
                                '+ Add "${_speakerController.value}"',
                              // Existing speakers
                              ...speakers.map((e) => e['name'] as String),
                            ],
                            onChanged: (val) {
                              if (val != null && val.startsWith('+ Add "')) {
                                // Extract the new speaker name
                                String newName = val.substring(7, val.length - 1);
                                final newSpeaker = {
                                  '_id': DateTime.now().millisecondsSinceEpoch.toString(),
                                  'name': newName,
                                };
                                setState(() {
                                  speakers.insert(0, newSpeaker); // add at the top
                                  _speakerController.value = newName;
                                  selectedSpeakerIds = [newSpeaker['_id'] as String];
                                });
                              } else {
                                // Existing speaker selected
                                final existing = speakers.firstWhere((e) => e['name'] == val, orElse: () => {});
                                if (existing.isNotEmpty) {
                                  setState(() {
                                    selectedSpeakerIds = [existing['_id'] as String];
                                  });
                                }
                              }
                            },
                            decoration: CustomDropdownDecoration(
                              closedBorder: Border.all(color: Colors.black12),
                              expandedBorder: Border.all(color: Colors.blueAccent),
                              closedFillColor: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.blueAccent),
                          onPressed: () async {
                            String? newSpeakerName = await showDialog<String>(
                              context: context,
                              builder: (context) {
                                final TextEditingController newController = TextEditingController();
                                return AlertDialog(
                                  title: const Text("Add New Speaker"),
                                  content: TextField(
                                    controller: newController,
                                    decoration: const InputDecoration(hintText: "Enter speaker name"),
                                  ),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (newController.text.trim().isNotEmpty) {
                                          Navigator.pop(context, newController.text.trim());
                                        }
                                      },
                                      child: const Text("Add"),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (newSpeakerName != null && newSpeakerName.isNotEmpty) {
                              final newSpeaker = {
                                '_id': DateTime.now().millisecondsSinceEpoch.toString(),
                                'name': newSpeakerName,
                              };
                              setState(() {
                                speakers.add(newSpeaker);
                                selectedSpeakerIds = [newSpeaker['_id'] as String];
                                _speakerController.value = newSpeakerName;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Topics Dropdown
                    Text("Topics", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    CustomDropdown.search(
                      hintText: 'Select a topic...',
                      controller: _topicsController,
                      items: topics.map((e) => e['name'] as String).toList(),
                      onChanged: (val) {
                        final selected = topics.firstWhere((e) => e['name'] == val);
                        setState(() {
                          selectedTopicIds = [selected['_id'] as String];
                        });
                      },
                      decoration: CustomDropdownDecoration(
                        closedBorder: Border.all(color: Colors.black12),
                        expandedBorder: Border.all(color: Colors.blueAccent),
                        closedFillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Scriptures Dropdown
                    Text("Scriptures", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    CustomDropdown.search(
                      hintText: 'Select a scripture...',
                      controller: _scriptureController,
                      items: scriptures.map((e) => e['name'] as String).toList(),
                      onChanged: (val) {
                        final selected = scriptures.firstWhere((e) => e['name'] == val);
                        setState(() {
                          selectedScriptureIds = [selected['_id'] as String];
                        });
                      },
                      decoration: CustomDropdownDecoration(
                        closedBorder: Border.all(color: Colors.black12),
                        expandedBorder: Border.all(color: Colors.blueAccent),
                        closedFillColor: Colors.white,
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
