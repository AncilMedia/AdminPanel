import 'dart:io';
import 'dart:ui';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:collection/collection.dart'; // ✅ Needed for firstWhereOrNull

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

class _LibraryDetailsState extends State<LibraryDetails> with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _scriptureController = TextEditingController();

  final SingleSelectController<String> _speakerController = SingleSelectController<String>(null);
  final SingleSelectController<String> _topicsController = SingleSelectController<String>(null);

  bool isLoading = true;
  bool isSaving = false;
  String? error;
  late TooltipBehavior _tooltipBehavior;
  late AnimationController _contentController;

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
  final TextStyle baseStyle = GoogleFonts.poppins();

  @override
  void initState() {
    super.initState();
    mediaDataController = MediaItemService();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    fetchInitialData();
    fetchAnalytics();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _scriptureController.dispose();
    _speakerController.dispose();
    _topicsController.dispose();
    super.dispose();
  }

  Future<void> fetchInitialData() async {
    try {
      final sp = await mediaDataController.fetchSpeakers();
      final tp = await mediaDataController.fetchTopics();
      if (mounted) {
        setState(() {
          speakers = sp;
          topics = tp;
        });
      }
    } catch (e) {
      debugPrint("Error fetching initial data: $e");
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
        _contentController.forward();
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
    setState(() => isSaving = true);
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
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text("Media Insights & Settings", style: baseStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _attractiveButton(
              label: isSaving ? "Saving..." : "Save Changes",
              icon: isSaving ? null : Iconsax.save_2,
              onPressed: isSaving ? null : _saveMediaItem,
              isLoading: isSaving,
              colors: [const Color(0xFF6366F1), const Color(0xFF4F46E5)], // Indigo Gradient
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _staggeredEntry(0, 0.4, child: _buildStatHeader()),
            const SizedBox(height: 24),
            _staggeredEntry(0.1, 0.5, child: _buildChartSection()),
            const SizedBox(height: 40),
            _buildFormSections(),
          ],
        ),
      ),
    );
  }

  // ================= ATTRACTIVE COMPONENTS =================

  Widget _attractiveButton({
    required String label,
    IconData? icon,
    required VoidCallback? onPressed,
    bool isLoading = false,
    List<Color>? colors,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors ?? [const Color(0xFF22D3EE), const Color(0xFF0EA5E9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: (colors?.first ?? Colors.cyan).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              else if (icon != null)
                Icon(icon, color: Colors.white, size: 18),
              if (icon != null || isLoading) const SizedBox(width: 8),
              Text(label, style: baseStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  // ... [StatHeader and ChartSection remain same as previous premium version] ...

  Widget _buildStatHeader() {
    return Row(
      children: [
        _buildStatCard("Total Views", totalViews.toString(), Iconsax.eye, Colors.blue),
        const SizedBox(width: 16),
        _buildStatCard("Peak Views", peakViews.toString(), Iconsax.trend_up, Colors.green),
        const SizedBox(width: 16),
        _buildStatCard("Content ID", widget.mediaitemid.substring(0, 8), Iconsax.code, Colors.orange),
      ],
    );
  }

  Widget _buildChartSection() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Audience Engagement", style: baseStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),
          SizedBox(
            height: 350,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
              tooltipBehavior: _tooltipBehavior,
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              series: _buildChartSeries(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSections() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _staggeredEntry(0.2, 0.6, child: _glassCard(
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
          )),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _staggeredEntry(0.3, 0.7, child: _glassCard(
                title: "Classification",
                icon: Iconsax.tag_2,
                child: Column(
                  children: [
                    _buildDynamicHeader("Speakers", _speakerController, _showAddSpeakerDialog),
                    _buildModernDropdown(speakers, _speakerController, (val) {
                      if (val != null) {
                        final sel = speakers.firstWhereOrNull((e) => e['name'] == val);
                        if (sel != null) setState(() => selectedSpeakerIds = [sel['_id']]);
                      }
                    }),
                    const SizedBox(height: 16),
                    _buildDynamicHeader("Topics", _topicsController, _showAddTopicDialog),
                    _buildModernDropdown(topics, _topicsController, (val) {
                      if (val != null) {
                        final sel = topics.firstWhereOrNull((e) => e['name'] == val);
                        if (sel != null) setState(() => selectedTopicIds = [sel['_id']]);
                      }
                    }),
                  ],
                ),
              )),
              const SizedBox(height: 24),
              _staggeredEntry(0.4, 0.8, child: _glassCard(
                title: "Media Assets",
                icon: Iconsax.folder_add,
                child: Column(
                  children: [
                    _buildMediaBox(80, isVideo: true),
                    const SizedBox(height: 12),
                    _buildMediaBox(80, isVideo: false),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  // ================= LOGIC HANDLERS (CRASH FIXED) =================

  Future<void> _showAddSpeakerDialog() async {
    final nameController = TextEditingController();
    final designationController = TextEditingController();
    final bioController = TextEditingController();

    // Platform-specific image storage
    File? speakerImage;      // Mobile
    Uint8List? webImageBytes; // Web
    bool isCreatingInDialog = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text("Create Speaker Profile",
              style: baseStyle.copyWith(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- 📸 Attractive Image Picker ---
                GestureDetector(
                  onTap: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      withData: true, // Required for Web bytes
                    );
                    if (result != null) {
                      setDialogState(() {
                        if (kIsWeb) {
                          webImageBytes = result.files.first.bytes;
                        } else {
                          speakerImage = File(result.files.single.path!);
                        }
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.indigo.withOpacity(0.2), width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey.shade100,
                      backgroundImage: kIsWeb
                          ? (webImageBytes != null ? MemoryImage(webImageBytes!) : null)
                          : (speakerImage != null ? FileImage(speakerImage!) : null),
                      child: (kIsWeb ? webImageBytes == null : speakerImage == null)
                          ? const Icon(Iconsax.camera, color: Colors.indigo, size: 30)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- 📝 Form Fields ---
                _modernInput("Full Name", nameController, Iconsax.user),
                const SizedBox(height: 12),
                _modernInput("Designation (e.g. Pastor)", designationController, Iconsax.briefcase),
                const SizedBox(height: 12),
                _modernInput("Short Bio", bioController, Iconsax.info_circle, maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text("Cancel", style: baseStyle.copyWith(color: Colors.grey))
            ),
            _attractiveButton(
              label: "Create Profile",
              onPressed: isCreatingInDialog ? null : () async {
                final name = nameController.text.trim();
                if (name.isEmpty || designationController.text.isEmpty) {
                  showCustomSnackBar(context, "Name and Designation are required", false);
                  return;
                }

                setDialogState(() => isCreatingInDialog = true);
                try {
                  // 1. Call API
                  await mediaDataController.addSpeakerComplex(
                    name: name,
                    designation: designationController.text.trim(),
                    bio: bioController.text.trim(),
                    image: speakerImage,
                    webImageBytes: webImageBytes,
                  );

                  // 2. Refresh Data
                  await fetchInitialData();

                  if (mounted) {
                    // 3. Find newly created speaker safely
                    final found = speakers.firstWhereOrNull((e) => e['name'] == name);

                    Navigator.pop(ctx);
                    setState(() {
                      if (found != null) {
                        _speakerController.value = found['name'];
                        selectedSpeakerIds = [found['_id']];
                      }
                    });
                    showCustomSnackBar(context, "Profile Created Successfully", true);
                  }
                } catch (e) {
                  print("Error creating speaker: $e");
                  showCustomSnackBar(context, "Error: $e", false);
                } finally {
                  if (mounted) setDialogState(() => isCreatingInDialog = false);
                }
              },
              isLoading: isCreatingInDialog,
              colors: [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _showAddTopicDialog() async {
    final nameController = TextEditingController();
    bool isCreatingInDialog = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text("New Content Topic", style: baseStyle.copyWith(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Categorize your media with a specific theme or subject.",
                  style: baseStyle.copyWith(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 16),
              _modernInput("Topic Name", nameController, Iconsax.tag),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text("Cancel", style: baseStyle.copyWith(color: Colors.grey))
            ),
            _attractiveButton(
              label: "Create Topic",
              onPressed: isCreatingInDialog ? null : () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  showCustomSnackBar(context, "Please enter a topic name", false);
                  return;
                }

                setDialogState(() => isCreatingInDialog = true);
                try {
                  print("📤 Creating Topic: $name");

                  await mediaDataController.addTopicComplex(name: name);

                  // Refresh list from server
                  await fetchInitialData();

                  if (mounted) {
                    // ✅ FIXED: Using collection package for safety
                    final found = topics.firstWhereOrNull((e) => e['name'] == name);

                    Navigator.pop(ctx);
                    setState(() {
                      if (found != null) {
                        _topicsController.value = found['name'];
                        selectedTopicIds = [found['_id']];
                      }
                    });
                    showCustomSnackBar(context, "Topic added successfully", true);
                  }
                } catch (e) {
                  print("================ TOPIC ERROR ================");
                  print(e);
                  showCustomSnackBar(context, "Error: $e", false);
                } finally {
                  if (mounted) setDialogState(() => isCreatingInDialog = false);
                }
              },
              isLoading: isCreatingInDialog,
              colors: [const Color(0xFFF59E0B), const Color(0xFFD97706)], // Amber Gradient
            ),
          ],
        ),
      ),
    );
  }
  // --- HELPERS (STYLING) ---

  Widget _staggeredEntry(double start, double end, {required Widget child}) {
    final animation = CurvedAnimation(parent: _contentController, curve: Interval(start, end, curve: Curves.easeOutQuart));
    return FadeTransition(opacity: animation, child: SlideTransition(position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(animation), child: child));
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
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: baseStyle.copyWith(fontSize: 12, color: Colors.grey)), Text(value, style: baseStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold))]),
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
            Row(children: [Icon(icon, size: 20, color: Colors.indigo), const SizedBox(width: 8), Text(title, style: baseStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16))]),
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
          style: baseStyle.copyWith(fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: Colors.indigo),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade100)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.indigo, width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildModernDropdown(List<Map<String, dynamic>> items, SingleSelectController<String> controller, Function(String?) onChanged) {
    final List<String> itemNames = items.map((e) => e['name'] as String).toList();
    if (controller.value != null && !itemNames.contains(controller.value)) {
      controller.value = null;
    }
    return CustomDropdown.search(
      hintText: 'Select...',
      controller: controller,
      items: itemNames,
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
              Text(hasFile ? "File Selected" : (isVideo ? "Change Video" : "Change Audio"), style: baseStyle.copyWith(fontSize: 12, color: hasFile ? Colors.indigo : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 8, left: 4), child: Text(text, style: baseStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade700)));
  }

  Widget _buildDynamicHeader(String label, SingleSelectController controller, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLabel(label),
        IconButton(onPressed: onAdd, icon: const Icon(Iconsax.add_square, size: 20, color: Colors.indigo)),
      ],
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
    final selections = await showDialog<List<Map<String, dynamic>>>(context: context, builder: (context) => Dialog(child: const ScriptureSelector()));
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