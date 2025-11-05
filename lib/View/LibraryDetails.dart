// import 'dart:io';
// import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import '../Controller/Media_Item_controller.dart';
// import '../Controller/Media_analytics_controller.dart';
// import 'Scripture_Selector.dart';
//
// class _ChartData {
//   final String date;
//   final double views;
//   final Color color;
//   final String device;
//   _ChartData(this.date, this.views, this.color, this.device);
// }
//
// class LibraryDetails extends StatefulWidget {
//   final String mediaitemid;
//   const LibraryDetails({super.key, required this.mediaitemid});
//
//   @override
//   State<LibraryDetails> createState() => _LibraryDetailsState();
// }
//
// class _LibraryDetailsState extends State<LibraryDetails> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();
//   final TextEditingController _scriptureController = TextEditingController();
//
//   final SingleSelectController<String> _speakerController = SingleSelectController<String>(null);
//   final SingleSelectController<String> _topicsController = SingleSelectController<String>(null);
//
//   bool isLoading = true;
//   String? error;
//   late TooltipBehavior _tooltipBehavior;
//   int totalViews = 0;
//   int peakViews = 0;
//
//   final AnalyticsService analyticsService = AnalyticsService();
//   List<_ChartData> chartData = [];
//   Map<String, dynamic>? analyticsData;
//
//   File? selectedVideo;
//   File? selectedAudio;
//
//   List<Map<String, dynamic>> speakers = [];
//   List<Map<String, dynamic>> topics = [];
//   List<String> selectedSpeakerIds = [];
//   List<String> selectedTopicIds = [];
//   List<String> selectedScriptureIds = [];
//
//   // device color palette
//   final Map<String, Color> deviceColors = {
//     "ios": Colors.amber,
//     "android": Colors.blue,
//     "appleTv": Colors.purple,
//     "roku": Colors.orange,
//     "webApp": Colors.green,
//     "webEmbed": Colors.teal,
//     "other": Colors.grey,
//   };
//
//   late MediaItemService mediaDataController;
//
//   @override
//   void initState() {
//     super.initState();
//     mediaDataController = MediaItemService();
//
//     _tooltipBehavior = TooltipBehavior(enable: true);
//     fetchInitialData();
//     fetchAnalytics();
//   }
//
//   Future<void> fetchInitialData() async {
//     try {
//       final sp = await mediaDataController.fetchSpeakers();
//       final tp = await mediaDataController.fetchTopics();
//       setState(() {
//         speakers = sp;
//         topics = tp;
//       });
//     } catch (e) {
//       debugPrint("Error fetching initial data: $e");
//     }
//   }
//
//   Future<void> fetchAnalytics() async {
//     setState(() => isLoading = true);
//     try {
//       final data = await analyticsService.getSingleMediaAnalytics(widget.mediaitemid);
//       final Map<String, dynamic> devicesByDate = Map<String, dynamic>.from(data['devices'] ?? {});
//       List<_ChartData> tempChart = [];
//       int maxViews = 0;
//       int total = 0;
//       devicesByDate.forEach((date, deviceMap) {
//         final Map<String, dynamic> dMap = Map<String, dynamic>.from(deviceMap);
//         dMap.forEach((device, value) {
//           double views = (value ?? 0).toDouble();
//           if (views > 0) {
//             tempChart.add(_ChartData(date, views, deviceColors[device] ?? Colors.grey, device));
//             total += views.toInt();
//             if (views > maxViews) maxViews = views.toInt();
//           }
//         });
//       });
//       setState(() {
//         analyticsData = data;
//         chartData = tempChart;
//         totalViews = total;
//         peakViews = maxViews;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         error = e.toString();
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _saveMediaItem() async {
//     if (_titleController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Title and Description are required")),
//       );
//       return;
//     }
//
//     if (selectedVideo == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select a video file")),
//       );
//       return;
//     }
//
//     DateTime? selectedDate;
//     if (_dateController.text.isNotEmpty) {
//       selectedDate = DateTime.tryParse(_dateController.text);
//     }
//
//     try {
//       await mediaDataController.createMediaItem(
//         file: selectedVideo!,
//         thumbnailFile: selectedAudio,
//         title: _titleController.text.trim(),
//         description: _descriptionController.text.trim(),
//         selectedDate: selectedDate,
//         speakers: selectedSpeakerIds,
//         topics: selectedTopicIds,
//         scriptures: selectedScriptureIds,
//       );
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Media Item created successfully!")),
//       );
//
//       _titleController.clear();
//       _descriptionController.clear();
//       _dateController.clear();
//       _speakerController.clear();
//       _scriptureController.clear();
//       _topicsController.clear();
//       setState(() {
//         selectedVideo = null;
//         selectedAudio = null;
//         selectedSpeakerIds = [];
//         selectedScriptureIds = [];
//         selectedTopicIds = [];
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed: $e")));
//     }
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setState(() => _dateController.text = DateFormat('yyyy-MM-dd').format(picked));
//     }
//   }
//
//   Future<void> _pickFile({required bool isVideo}) async {
//     final result = await FilePicker.platform.pickFiles(type: isVideo ? FileType.video : FileType.audio);
//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         if (isVideo) selectedVideo = File(result.files.single.path!);
//         else selectedAudio = File(result.files.single.path!);
//       });
//     }
//   }
//
//   // Future<void> _openScriptureSelector() async {
//   //   final selection = await showDialog<String>(
//   //     context: context,
//   //     builder: (context) => Dialog(
//   //       insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60), // 🔽 reduces overall dialog height
//   //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//   //       child: SizedBox(
//   //         width: MediaQuery.of(context).size.width * 0.9,
//   //         height: MediaQuery.of(context).size.height * 0.65, // 🔽 lower height (65% of screen)
//   //         child: const ScriptureSelector(),
//   //       ),
//   //     ),
//   //   );
//   //
//   //   if (selection != null) {
//   //     setState(() => _scriptureController.text = selection);
//   //   }
//   // }
//
//   Future<void> _openScriptureSelector() async {
//     final selections = await showDialog<List<Map<String, dynamic>>>(
//       context: context,
//       builder: (context) => Dialog(
//         insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: SizedBox(
//           width: MediaQuery.of(context).size.width * 0.9,
//           height: MediaQuery.of(context).size.height * 0.65,
//           child: const ScriptureSelector(),
//         ),
//       ),
//     );
//
//     if (selections != null && selections.isNotEmpty) {
//       final displayText =
//       selections.map((e) => "${e['book']} ${e['chapter']}").join(', ');
//       setState(() {
//         _scriptureController.text = displayText;
//         selectedScriptureIds = selections.map((e) => e['_id'] as String).toList();
//       });
//     }
//   }
//
//
//   InputDecoration _inputDecoration({String? hint, IconData? icon}) => InputDecoration(
//     hintText: hint,
//     suffixIcon: icon != null ? Icon(icon) : null,
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
//     enabledBorder: OutlineInputBorder(
//       borderSide: const BorderSide(color: Colors.black12),
//       borderRadius: BorderRadius.circular(6),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderSide: const BorderSide(color: Colors.blueAccent),
//       borderRadius: BorderRadius.circular(6),
//     ),
//   );
//
//   Widget _buildInputField({String? hint, int maxLines = 1, TextEditingController? controller}) =>
//       TextFormField(controller: controller, maxLines: maxLines, decoration: _inputDecoration(hint: hint));
//
//   Widget _buildMediaBox(double height, {bool isVideo = true}) => GestureDetector(
//     onTap: () => _pickFile(isVideo: isVideo),
//     child: Container(
//       height: height,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.black12),
//       ),
//       child: Center(
//         child: Text(
//           isVideo
//               ? (selectedVideo != null ? "Selected Video" : "Pick Video")
//               : (selectedAudio != null ? "Selected Audio" : "Pick Audio"),
//           style: const TextStyle(color: Colors.black54),
//         ),
//       ),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // ---------- Chart ----------
//             SizedBox(
//               height: size.height * 0.35,
//               child: SfCartesianChart(
//                 title: ChartTitle(text: 'Analytics: ${widget.mediaitemid}'),
//                 primaryXAxis: CategoryAxis(labelRotation: 45),
//                 primaryYAxis: NumericAxis(title: AxisTitle(text: 'Views')),
//                 legend: Legend(isVisible: true),
//                 tooltipBehavior: _tooltipBehavior,
//                 series: _buildChartSeries(),
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // ---------- Form ----------
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Basic Details", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
//                   _buildInputField(hint: "Enter title", controller: _titleController),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(child: _buildInputField(hint: "Enter author")),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: TextFormField(
//                           controller: _dateController,
//                           readOnly: true,
//                           onTap: () => _selectDate(context),
//                           decoration: _inputDecoration(hint: "Select date", icon: Iconsax.calendar_1),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   _buildInputField(hint: "Enter description", maxLines: 3, controller: _descriptionController),
//                   const SizedBox(height: 16),
//
//                   // Speakers
//                   Text("Speakers", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 6),
//                   CustomDropdown.search(
//                     hintText: 'Select a speaker...',
//                     controller: _speakerController,
//                     items: speakers.map((e) => e['name'] as String).toList(),
//                     onChanged: (val) {
//                       final selected = speakers.firstWhere((e) => e['name'] == val);
//                       setState(() => selectedSpeakerIds = [selected['_id'] as String]);
//                     },
//                     decoration: CustomDropdownDecoration(
//                       closedBorder: Border.all(color: Colors.black12),
//                       expandedBorder: Border.all(color: Colors.blueAccent),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Topics
//                   Text("Topics", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 6),
//                   CustomDropdown.search(
//                     hintText: 'Select a topic...',
//                     controller: _topicsController,
//                     items: topics.map((e) => e['name'] as String).toList(),
//                     onChanged: (val) {
//                       final selected = topics.firstWhere((e) => e['name'] == val);
//                       setState(() => selectedTopicIds = [selected['_id'] as String]);
//                     },
//                     decoration: CustomDropdownDecoration(
//                       closedBorder: Border.all(color: Colors.black12),
//                       expandedBorder: Border.all(color: Colors.blueAccent),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // 🔹 Scriptures Selector
//                   Text("Scriptures", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 6),
//                 GestureDetector(
//                   onTap: _openScriptureSelector,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // 🔽 reduced from 14 → 8
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black12),
//                       borderRadius: BorderRadius.circular(8),
//                       color: Colors.white,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             _scriptureController.text.isEmpty
//                                 ? "Select a scripture..."
//                                 : _scriptureController.text,
//                             style: GoogleFonts.poppins(
//                               fontSize: 13, // 🔽 slightly smaller text
//                               color: _scriptureController.text.isEmpty
//                                   ? Colors.black45
//                                   : Colors.black87,
//                             ),
//                             overflow: TextOverflow.ellipsis, // prevents long text overflow
//                           ),
//                         ),
//                         const Icon(Icons.arrow_drop_down, color: Colors.black54, size: 20), // 🔽 smaller icon
//                       ],
//                     ),
//                   ),
//                 ),
//                   const SizedBox(height: 16),
//
//                   _buildMediaBox(100, isVideo: true),
//                   const SizedBox(height: 16),
//                   _buildMediaBox(80, isVideo: false),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _saveMediaItem,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                       ),
//                       child: const Text("Save Media Item"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<StackedColumnSeries<_ChartData, String>> _buildChartSeries() {
//     final Map<String, List<_ChartData>> grouped = {};
//     for (var d in chartData) {
//       grouped.putIfAbsent(d.device, () => []).add(d);
//     }
//     return grouped.entries
//         .map(
//           (e) => StackedColumnSeries<_ChartData, String>(
//         dataSource: e.value,
//         xValueMapper: (d, _) => d.date,
//         yValueMapper: (d, _) => d.views,
//         name: e.key,
//         pointColorMapper: (d, _) => d.color,
//       ),
//     )
//         .toList();
//   }
// }


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

  final SingleSelectController<String> _speakerController =
  SingleSelectController<String>(null);
  final SingleSelectController<String> _topicsController =
  SingleSelectController<String>(null);

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

  // Device color palette
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
    _tooltipBehavior = TooltipBehavior(enable: true);
    fetchInitialData();
    fetchAnalytics();
  }

  Future<void> fetchInitialData() async {
    try {
      final sp = await mediaDataController.fetchSpeakers();
      final tp = await mediaDataController.fetchTopics();
      setState(() {
        speakers = sp;
        topics = tp;
      });
    } catch (e) {
      debugPrint("Error fetching initial data: $e");
    }
  }

  Future<void> fetchAnalytics() async {
    setState(() => isLoading = true);
    try {
      final data =
      await analyticsService.getSingleMediaAnalytics(widget.mediaitemid);
      final Map<String, dynamic> devicesByDate =
      Map<String, dynamic>.from(data['devices'] ?? {});
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

  // Future<void> _saveMediaItem() async {
  //   if (_titleController.text.trim().isEmpty ||
  //       _descriptionController.text.trim().isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Title and Description are required")),
  //     );
  //     return;
  //   }
  //
  //   if (selectedVideo == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please select a video file")),
  //     );
  //     return;
  //   }
  //
  //   DateTime? selectedDate;
  //   if (_dateController.text.isNotEmpty) {
  //     selectedDate = DateTime.tryParse(_dateController.text);
  //   }
  //
  //   try {
  //     await mediaDataController.createMediaItem(
  //       file: selectedVideo!,
  //       thumbnailFile: selectedAudio,
  //       title: _titleController.text.trim(),
  //       description: _descriptionController.text.trim(),
  //       selectedDate: selectedDate,
  //       speakers: selectedSpeakerIds,
  //       topics: selectedTopicIds,
  //       scriptures: selectedScriptureIds,
  //     );
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Media Item created successfully!")),
  //     );
  //
  //     _titleController.clear();
  //     _descriptionController.clear();
  //     _dateController.clear();
  //     _speakerController.clear();
  //     _scriptureController.clear();
  //     _topicsController.clear();
  //
  //     setState(() {
  //       selectedVideo = null;
  //       selectedAudio = null;
  //       selectedSpeakerIds = [];
  //       selectedScriptureIds = [];
  //       selectedTopicIds = [];
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text("Failed: $e")));
  //   }
  // }

  /// ✅ Save all entered details
  Future<void> _saveMediaItem() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a title")),
      );
      return;
    }

    try {
      await mediaDataController.createMediaItem(
        file: selectedVideo,
        thumbnailFile: selectedAudio,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        // selectedDate: selectedDate,
        speakers: selectedSpeakerIds,
        topics: selectedTopicIds,
        scriptures: selectedScriptureIds,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Media item saved successfully")),
      );

      setState(() {
        _titleController.clear();
        _descriptionController.clear();
        _dateController.clear();
        _scriptureController.clear();
        selectedVideo = null;
        selectedAudio = null;
        selectedSpeakerIds.clear();
        selectedTopicIds.clear();
        selectedScriptureIds.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving media item: $e")),
      );
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() =>
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  Future<void> _pickFile({required bool isVideo}) async {
    final result = await FilePicker.platform
        .pickFiles(type: isVideo ? FileType.video : FileType.audio);
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

  /// ✅ Updated Scripture selector (null-safe)
  Future<void> _openScriptureSelector() async {
    final selections = await showDialog<List<Map<String, dynamic>>>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.65,
          child: const ScriptureSelector(),
        ),
      ),
    );

    if (selections != null && selections.isNotEmpty) {
      // Build scripture display text safely
      final displayText = selections.map((e) {
        final book = e['book'] ?? '';
        final chapter = e['chapter']?.toString() ?? '';
        final start = e['start']?.toString();
        final end = e['end']?.toString();

        String ref = "$book $chapter";
        if (start != null && end != null) {
          ref += ":$start${end != start ? '-$end' : ''}";
        } else if (start != null) {
          ref += ":$start";
        }
        return ref;
      }).join(', ');

      setState(() {
        _scriptureController.text = displayText;
        selectedScriptureIds = selections
            .map((e) => e['_id']?.toString() ?? "${e['book']}_${e['chapter']}")
            .toList();
      });
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

  Widget _buildInputField(
      {String? hint, int maxLines = 1, TextEditingController? controller}) =>
      TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: _inputDecoration(hint: hint));

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ---------- Chart ----------
            SizedBox(
              height: size.height * 0.35,
              child: SfCartesianChart(
                title: ChartTitle(text: 'Analytics: ${widget.mediaitemid}'),
                primaryXAxis: CategoryAxis(labelRotation: 45),
                primaryYAxis:
                NumericAxis(title: AxisTitle(text: 'Views')),
                legend: Legend(isVisible: true),
                tooltipBehavior: _tooltipBehavior,
                series: _buildChartSeries(),
              ),
            ),
            const SizedBox(height: 24),

            /// ---------- Form ----------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Basic Details",
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  _buildInputField(
                      hint: "Enter title", controller: _titleController),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child:
                          _buildInputField(hint: "Enter author")),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: _inputDecoration(
                              hint: "Select date",
                              icon: Iconsax.calendar_1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                      hint: "Enter description",
                      maxLines: 3,
                      controller: _descriptionController),
                  const SizedBox(height: 16),

                  // Speakers
                  Text("Speakers",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  CustomDropdown.search(
                    hintText: 'Select a speaker...',
                    controller: _speakerController,
                    items:
                    speakers.map((e) => e['name'] as String).toList(),
                    onChanged: (val) {
                      final selected = speakers
                          .firstWhere((e) => e['name'] == val);
                      setState(() =>
                      selectedSpeakerIds = [selected['_id']]);
                    },
                    decoration: CustomDropdownDecoration(
                      closedBorder:
                      Border.all(color: Colors.black12),
                      expandedBorder:
                      Border.all(color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Topics
                  Text("Topics",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  CustomDropdown.search(
                    hintText: 'Select a topic...',
                    controller: _topicsController,
                    items:
                    topics.map((e) => e['name'] as String).toList(),
                    onChanged: (val) {
                      final selected = topics
                          .firstWhere((e) => e['name'] == val);
                      setState(() =>
                      selectedTopicIds = [selected['_id']]);
                    },
                    decoration: CustomDropdownDecoration(
                      closedBorder:
                      Border.all(color: Colors.black12),
                      expandedBorder:
                      Border.all(color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Scriptures Selector
                  Text("Scriptures",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: _openScriptureSelector,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _scriptureController.text.isEmpty
                                  ? "Select a scripture..."
                                  : _scriptureController.text,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: _scriptureController
                                    .text.isEmpty
                                    ? Colors.black45
                                    : Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down,
                              color: Colors.black54, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildMediaBox(100, isVideo: true),
                  const SizedBox(height: 16),
                  _buildMediaBox(80, isVideo: false),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveMediaItem,
                      style: ElevatedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Save Media Item"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<StackedColumnSeries<_ChartData, String>> _buildChartSeries() {
    final Map<String, List<_ChartData>> grouped = {};
    for (var d in chartData) {
      grouped.putIfAbsent(d.device, () => []).add(d);
    }
    return grouped.entries
        .map(
          (e) => StackedColumnSeries<_ChartData, String>(
        dataSource: e.value,
        xValueMapper: (d, _) => d.date,
        yValueMapper: (d, _) => d.views,
        name: e.key,
        pointColorMapper: (d, _) => d.color,
      ),
    )
        .toList();
  }
}
