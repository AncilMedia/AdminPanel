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
import '../View_model/Custom_snackbar.dart';
import 'Scripture_Selector.dart';

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
  final TextEditingController _scriptureController = TextEditingController();

  final SingleSelectController<String> _speakerController = SingleSelectController<String>(null);
  final SingleSelectController<String> _topicsController = SingleSelectController<String>(null);

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
  List<String> selectedSpeakerIds = [];
  List<String> selectedTopicIds = [];
  List<String> selectedScriptureIds = [];

  final Map<String, Color> deviceColors = {
    "ios": Colors.amber, "android": Colors.blue, "appleTv": Colors.purple,
    "roku": Colors.orange, "webApp": Colors.green, "webEmbed": Colors.teal, "other": Colors.grey,
  };

  late MediaItemService mediaDataController;

  @override
  void initState() {
    super.initState();
    mediaDataController = MediaItemService();
    _tooltipBehavior = TooltipBehavior(enable: true);
    fetchInitialData();
    fetchAnalytics();
  }

  /// 🔹 Fetches Speakers and Topics and validates controllers to prevent crashes
  Future<void> fetchInitialData() async {
    try {
      final sp = await mediaDataController.fetchSpeakers();
      final tp = await mediaDataController.fetchTopics();
      setState(() {
        speakers = sp;
        topics = tp;
      });
      _validateDropdownControllers();
    } catch (e) {
      debugPrint("Error fetching initial data: $e");
    }
  }

  /// 🛡️ Prevents the "Controller value must match" assertion error
  void _validateDropdownControllers() {
    final speakerNames = speakers.map((e) => e['name'] as String).toList();
    final topicNames = topics.map((e) => e['name'] as String).toList();

    if (_speakerController.value != null && !speakerNames.contains(_speakerController.value)) {
      _speakerController.value = null;
    }
    if (_topicsController.value != null && !topicNames.contains(_topicsController.value)) {
      _topicsController.value = null;
    }
  }

  Future<void> fetchAnalytics() async {
    setState(() => isLoading = true);
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
            tempChart.add(_ChartData(date, views, deviceColors[device] ?? Colors.grey, device));
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
      setState(() { error = e.toString(); isLoading = false; });
    }
  }

  Future<void> _saveMediaItem() async {
    if (_titleController.text.trim().isEmpty) {
      showCustomSnackBar(context, "Please enter a title", false);
      return;
    }
    setState(() => isLoading = true);
    try {
      await mediaDataController.createMediaItem(
        file: selectedVideo,
        thumbnailFile: selectedAudio,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        speakers: selectedSpeakerIds,
        topics: selectedTopicIds,
        scriptures: selectedScriptureIds,
      );
      showCustomSnackBar(context, "Media item updated successfully", true);
    } catch (e) {
      showCustomSnackBar(context, "Error: $e", false);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text("Media Insights & Settings", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: _saveMediaItem,
              icon: const Icon(Iconsax.save_2, size: 18, color: Colors.white),
              label: const Text("Save Changes"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Content Performance", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard("Total Views", totalViews.toString(), Iconsax.eye, Colors.blue),
                const SizedBox(width: 16),
                _buildStatCard("Peak Views", peakViews.toString(), Iconsax.trend_up, Colors.green),
                const SizedBox(width: 16),
                _buildStatCard("Content ID", widget.mediaitemid.substring(0, 8), Iconsax.code, Colors.orange),
              ],
            ),
            const SizedBox(height: 24),

            _glassCard(
              child: SizedBox(
                height: 350,
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
                  tooltipBehavior: _tooltipBehavior,
                  legend: Legend(isVisible: true, position: LegendPosition.bottom),
                  series: _buildChartSeries(),
                ),
              ),
            ),
            const SizedBox(height: 40),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _glassCard(
                    title: "General Information",
                    icon: Iconsax.document_text,
                    child: Column(
                      children: [
                        _modernInput("Title", _titleController, Iconsax.video_play),
                        const SizedBox(height: 16),
                        _modernInput("Description", _descriptionController, Iconsax.text_block, maxLines: 4),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _modernInput("Publication Date", _dateController, Iconsax.calendar, readOnly: true, onTap: () => _selectDate(context))),
                            const SizedBox(width: 16),
                            Expanded(child: _modernInput("Scriptures", _scriptureController, Iconsax.book_1, readOnly: true, onTap: _openScriptureSelector)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _glassCard(
                        title: "Classification",
                        icon: Iconsax.tag_2,
                        child: Column(
                          children: [
                            _buildDynamicHeader("Speakers", _speakerController, _showAddSpeakerDialog),
                            _buildModernDropdown(speakers, _speakerController, (val) {
                              if (val != null) {
                                final sel = speakers.firstWhere((e) => e['name'] == val);
                                setState(() => selectedSpeakerIds = [sel['_id']]);
                              }
                            }),
                            const SizedBox(height: 16),
                            _buildDynamicHeader("Topics", _topicsController, _showAddTopicDialog),
                            _buildModernDropdown(topics, _topicsController, (val) {
                              if (val != null) {
                                final sel = topics.firstWhere((e) => e['name'] == val);
                                setState(() => selectedTopicIds = [sel['_id']]);
                              }
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _glassCard(
                        title: "Media Assets",
                        icon: Iconsax.folder_add,
                        child: Column(
                          children: [
                            _buildMediaBox(80, isVideo: true),
                            const SizedBox(height: 12),
                            _buildMediaBox(80, isVideo: false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _buildDynamicHeader(String label, SingleSelectController controller, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLabel(label),
        IconButton(
          onPressed: onAdd,
          icon: Icon(controller.value == null ? Iconsax.add_square : Iconsax.edit, size: 20, color: Colors.indigo),
          tooltip: controller.value == null ? "Add New" : "Edit",
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 22)),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)), Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold))]),
          ],
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child, String? title, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(children: [Icon(icon, size: 20, color: Colors.indigo), const SizedBox(width: 8), Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16))]),
            const Divider(height: 32),
          ],
          child,
        ],
      ),
    );
  }

  Widget _modernInput(String label, TextEditingController controller, IconData icon, {int maxLines = 1, bool readOnly = false, VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: Colors.indigo),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade100)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.indigo)),
          ),
        ),
      ],
    );
  }

  Widget _buildModernDropdown(List<Map<String, dynamic>> items, SingleSelectController<String> controller, Function(String?) onChanged) {
    return CustomDropdown.search(
      hintText: 'Select...',
      controller: controller,
      items: items.map((e) => e['name'] as String).toList(),
      onChanged: onChanged,
      decoration: CustomDropdownDecoration(
        closedFillColor: Colors.grey.shade50,
        closedBorder: Border.all(color: Colors.grey.shade100),
        closedBorderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildMediaBox(double height, {bool isVideo = true}) {
    final hasFile = isVideo ? selectedVideo != null : selectedAudio != null;
    return GestureDetector(
      onTap: () => _pickFile(isVideo: isVideo),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(color: hasFile ? Colors.indigo.withOpacity(0.05) : Colors.grey.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: hasFile ? Colors.indigo : Colors.grey.shade200)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isVideo ? Iconsax.video : Iconsax.music, color: hasFile ? Colors.indigo : Colors.grey),
              const SizedBox(height: 4),
              Text(hasFile ? "File Selected" : (isVideo ? "Change Video" : "Change Audio"), style: GoogleFonts.poppins(fontSize: 12, color: hasFile ? Colors.indigo : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 8, left: 4), child: Text(text, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade700)));
  }

  // --- DIALOGS & LOGIC ---

  Future<void> _showAddSpeakerDialog() async {
    final nameController = TextEditingController();
    bool isCreating = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text("Create Speaker", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: _modernInput("Speaker Name", nameController, Iconsax.user),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: isCreating ? null : () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;
                setDialogState(() => isCreating = true);
                try {
                  // await mediaDataController.addSpeaker(name); // Ensure API call exists
                  await fetchInitialData();
                  if (mounted) {
                    Navigator.pop(context);
                    setState(() {
                      _speakerController.value = name;
                      selectedSpeakerIds = [speakers.firstWhere((e) => e['name'] == name)['_id']];
                    });
                    showCustomSnackBar(context, "Speaker added", true);
                  }
                } catch (e) { showCustomSnackBar(context, "Error adding speaker", false); }
                finally { if (mounted) setDialogState(() => isCreating = false); }
              },
              child: isCreating ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddTopicDialog() async {
    final topicNameController = TextEditingController();
    bool isCreating = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text("New Topic", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: _modernInput("Topic Name", topicNameController, Iconsax.tag),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: isCreating ? null : () async {
                final topic = topicNameController.text.trim();
                if (topic.isEmpty) return;
                setDialogState(() => isCreating = true);
                try {
                  // await mediaDataController.addTopic(topic); // Ensure API call exists
                  await fetchInitialData();
                  if (mounted) {
                    Navigator.pop(context);
                    setState(() {
                      _topicsController.value = topic;
                      selectedTopicIds = [topics.firstWhere((e) => e['name'] == topic)['_id']];
                    });
                    showCustomSnackBar(context, "Topic created", true);
                  }
                } catch (e) { showCustomSnackBar(context, "Error creating topic", false); }
                finally { if (mounted) setDialogState(() => isCreating = false); }
              },
              child: isCreating ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2101));
    if (picked != null) setState(() => _dateController.text = DateFormat('yyyy-MM-dd').format(picked));
  }

  Future<void> _pickFile({required bool isVideo}) async {
    final result = await FilePicker.platform.pickFiles(type: isVideo ? FileType.video : FileType.audio);
    if (result != null && result.files.single.path != null) {
      setState(() {
        if (isVideo) selectedVideo = File(result.files.single.path!);
        else selectedAudio = File(result.files.single.path!);
      });
    }
  }

  Future<void> _openScriptureSelector() async {
    final selections = await showDialog<List<Map<String, dynamic>>>(
      context: context,
      builder: (context) => Dialog(child: const ScriptureSelector()),
    );
    if (selections != null && selections.isNotEmpty) {
      setState(() {
        _scriptureController.text = selections.map((e) => "${e['book']} ${e['chapter']}").join(', ');
        selectedScriptureIds = selections.map((e) => e['_id']?.toString() ?? "").toList();
      });
    }
  }

  List<StackedColumnSeries<_ChartData, String>> _buildChartSeries() {
    final Map<String, List<_ChartData>> grouped = {};
    for (var d in chartData) grouped.putIfAbsent(d.device, () => []).add(d);
    return grouped.entries.map((e) => StackedColumnSeries<_ChartData, String>(dataSource: e.value, xValueMapper: (d, _) => d.date, yValueMapper: (d, _) => d.views, name: e.key, pointColorMapper: (d, _) => d.color)).toList();
  }
}