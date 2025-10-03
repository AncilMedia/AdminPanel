// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:google_fonts/google_fonts.dart';
// // // // //
// // // // // class LibraryDetails extends StatefulWidget {
// // // // //   const LibraryDetails({super.key});
// // // // //
// // // // //   @override
// // // // //   State<LibraryDetails> createState() => _LibraryDetailsState();
// // // // // }
// // // // //
// // // // // class _LibraryDetailsState extends State<LibraryDetails> {
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final size = MediaQuery.of(context).size;
// // // // //
// // // // //     return Scaffold(
// // // // //       backgroundColor: Colors.grey[200],
// // // // //       body: SingleChildScrollView(
// // // // //         padding: EdgeInsets.all(size.width * 0.05),
// // // // //         child: Center(
// // // // //           child: Container(
// // // // //             width: size.width * 0.8,
// // // // //             padding: const EdgeInsets.all(16),
// // // // //             decoration: BoxDecoration(
// // // // //               borderRadius: BorderRadius.circular(12),
// // // // //               color: Colors.white,
// // // // //               boxShadow: [
// // // // //                 BoxShadow(
// // // // //                   color: Colors.black12,
// // // // //                   blurRadius: 6,
// // // // //                   offset: Offset(0, 2),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //             child: Column(
// // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // //               children: [
// // // // //                 Text(
// // // // //                   "Basic Details",
// // // // //                   style: GoogleFonts.poppins(
// // // // //                     fontSize: 18,
// // // // //                     fontWeight: FontWeight.w600,
// // // // //                   ),
// // // // //                 ),
// // // // //                 const SizedBox(height: 16),
// // // // //
// // // // //                 // Title
// // // // //                 Text(
// // // // //                   "Title",
// // // // //                   style: GoogleFonts.poppins(
// // // // //                     fontSize: 14,
// // // // //                     color: Colors.grey[700],
// // // // //                   ),
// // // // //                 ),
// // // // //                 const SizedBox(height: 6),
// // // // //                 TextFormField(
// // // // //                   decoration: const InputDecoration(
// // // // //                     border: OutlineInputBorder(),
// // // // //                     hintText: "Enter title",
// // // // //                   ),
// // // // //                 ),
// // // // //                 const SizedBox(height: 16),
// // // // //
// // // // //                 // Row with two fields
// // // // //                 Row(
// // // // //                   children: [
// // // // //                     Expanded(
// // // // //                       child: Column(
// // // // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                         children: [
// // // // //                           Text(
// // // // //                             "Author",
// // // // //                             style: GoogleFonts.poppins(
// // // // //                               fontSize: 14,
// // // // //                               color: Colors.grey[700],
// // // // //                             ),
// // // // //                           ),
// // // // //                           const SizedBox(height: 6),
// // // // //                           TextFormField(
// // // // //                             decoration: const InputDecoration(
// // // // //                               border: OutlineInputBorder(),
// // // // //                               hintText: "Enter author",
// // // // //                             ),
// // // // //                           ),
// // // // //                         ],
// // // // //                       ),
// // // // //                     ),
// // // // //                     const SizedBox(width: 12),
// // // // //                     Expanded(
// // // // //                       child: Column(
// // // // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                         children: [
// // // // //                           Text(
// // // // //                             "Date",
// // // // //                             style: GoogleFonts.poppins(
// // // // //                               fontSize: 14,
// // // // //                               color: Colors.grey[700],
// // // // //                             ),
// // // // //                           ),
// // // // //                           const SizedBox(height: 6),
// // // // //                           TextFormField(
// // // // //                             decoration: const InputDecoration(
// // // // //                               border: OutlineInputBorder(),
// // // // //                               hintText: "Select date",
// // // // //                             ),
// // // // //                           ),
// // // // //                         ],
// // // // //                       ),
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // //
// // // //
// // // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:google_fonts/google_fonts.dart';
// // // // import 'package:iconsax/iconsax.dart';
// // // // import 'package:intl/intl.dart';
// // // // import 'package:syncfusion_flutter_charts/charts.dart';
// // // //
// // // // class LibraryDetails extends StatefulWidget {
// // // //   const LibraryDetails({super.key});
// // // //
// // // //   @override
// // // //   State<LibraryDetails> createState() => _LibraryDetailsState();
// // // // }
// // // //
// // // // class _LibraryDetailsState extends State<LibraryDetails> {
// // // //   final TextEditingController _dateController = TextEditingController();
// // // //   final TextEditingController mediaitemid = TextEditingController();
// // // //
// // // //   // Example data for chart
// // // //   final List<_ChartData> chartData = [
// // // //     _ChartData("Mon", 5),
// // // //     _ChartData("Tue", 8),
// // // //     _ChartData("Wed", 6),
// // // //     _ChartData("Thu", 10),
// // // //     _ChartData("Fri", 7),
// // // //   ];
// // // //
// // // //   // Speakers, Scripture, Topics
// // // //   final List<String> speakers = ["Speaker 1", "Speaker 2", "Speaker 3", "Speaker 4"];
// // // //   final List<String> scriptures = ["Scripture 1", "Scripture 2", "Scripture 3"];
// // // //   final List<String> topics = ["Topic 1", "Topic 2", "Topic 3", "Topic 4"];
// // // //
// // // //   List<String> selectedSpeakers = [];
// // // //   String? selectedScripture;
// // // //   List<String> selectedTopics = [];
// // // //
// // // //   // Tooltip behavior for chart
// // // //   late TooltipBehavior _tooltipBehavior;
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _tooltipBehavior = TooltipBehavior(
// // // //       enable: true,
// // // //       color: Colors.blueAccent.withOpacity(0.9),
// // // //       textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// // // //       format: 'point.x : point.y views',
// // // //     );
// // // //   }
// // // //
// // // //   Future<void> _selectDate(BuildContext context) async {
// // // //     final pickedDate = await showDatePicker(
// // // //       context: context,
// // // //       initialDate: DateTime.now(),
// // // //       firstDate: DateTime(2000),
// // // //       lastDate: DateTime(2101),
// // // //     );
// // // //     if (pickedDate != null) {
// // // //       setState(() {
// // // //         _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
// // // //       });
// // // //     }
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final size = MediaQuery.of(context).size;
// // // //
// // // //     return Scaffold(
// // // //       backgroundColor: Colors.grey[100],
// // // //       body: Column(
// // // //         children: [
// // // //           // 🔹 Chart + Stats Section
// // // //           Container(
// // // //             width: size.width * 0.84,
// // // //             padding: const EdgeInsets.all(12),
// // // //             decoration: BoxDecoration(
// // // //               color: Colors.white,
// // // //               borderRadius: BorderRadius.circular(12),
// // // //               boxShadow: const [
// // // //                 BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
// // // //               ],
// // // //             ),
// // // //             child: Column(
// // // //               children: [
// // // //                 // Chart
// // // //                 SizedBox(
// // // //                   height: size.height * 0.25,
// // // //                   child: SfCartesianChart(
// // // //                     title: ChartTitle(text: 'Analytics'),
// // // //                     primaryXAxis: CategoryAxis(),
// // // //                     primaryYAxis: NumericAxis(),
// // // //                     tooltipBehavior: _tooltipBehavior,
// // // //                     legend: const Legend(isVisible: false),
// // // //                     series: <CartesianSeries<_ChartData, String>>[
// // // //                       ColumnSeries<_ChartData, String>(
// // // //                         dataSource: chartData,
// // // //                         xValueMapper: (data, _) => data.day,
// // // //                         yValueMapper: (data, _) => data.views,
// // // //                         color: Colors.blueAccent,
// // // //                         borderRadius: BorderRadius.circular(6),
// // // //                         dataLabelSettings: const DataLabelSettings(isVisible: true),
// // // //                         enableTooltip: true,
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 12),
// // // //
// // // //                 // Stats Row
// // // //                 Row(
// // // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                   children: [
// // // //                     Text(
// // // //                       'Media Item id: ${mediaitemid.text}',
// // // //                       style: const TextStyle(color: Colors.black54, fontSize: 12),
// // // //                     ),
// // // //                     Expanded(
// // // //                       child: Container(
// // // //                         padding: const EdgeInsets.all(12),
// // // //                         decoration: BoxDecoration(
// // // //                           color: Colors.white,
// // // //                           borderRadius: BorderRadius.circular(12),
// // // //                           border: Border.all(color: Colors.black26),
// // // //                         ),
// // // //                         child: Row(
// // // //                           children: const [
// // // //                             Icon(Icons.remove_red_eye, color: Colors.black54),
// // // //                             SizedBox(width: 8),
// // // //                             Column(
// // // //                               crossAxisAlignment: CrossAxisAlignment.start,
// // // //                               children: [
// // // //                                 Text('0', style: TextStyle(fontWeight: FontWeight.bold)),
// // // //                                 Text('All time plays',
// // // //                                     style: TextStyle(color: Colors.black54, fontSize: 12)),
// // // //                               ],
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(width: 12),
// // // //                     Expanded(
// // // //                       child: Container(
// // // //                         padding: const EdgeInsets.all(12),
// // // //                         decoration: BoxDecoration(
// // // //                           color: Colors.white,
// // // //                           borderRadius: BorderRadius.circular(12),
// // // //                           border: Border.all(color: Colors.black26),
// // // //                         ),
// // // //                         child: Row(
// // // //                           children: const [
// // // //                             Icon(Icons.bar_chart, color: Colors.black54),
// // // //                             SizedBox(width: 8),
// // // //                             Column(
// // // //                               crossAxisAlignment: CrossAxisAlignment.start,
// // // //                               children: [
// // // //                                 Text('0 on Sep 28, 2025',
// // // //                                     style: TextStyle(fontWeight: FontWeight.bold)),
// // // //                                 Text('Peak traffic plays',
// // // //                                     style: TextStyle(color: Colors.black54, fontSize: 12)),
// // // //                               ],
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //
// // // //           SizedBox(height: size.height * 0.02),
// // // //
// // // //           // 🔹 Form Section
// // // //           Expanded(
// // // //             child: Center(
// // // //               child: SingleChildScrollView(
// // // //                 child: Container(
// // // //                   width: size.width * 0.85,
// // // //                   padding: const EdgeInsets.all(16),
// // // //                   decoration: BoxDecoration(
// // // //                     borderRadius: BorderRadius.circular(10),
// // // //                     color: Colors.white,
// // // //                     boxShadow: const [
// // // //                       BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
// // // //                     ],
// // // //                   ),
// // // //                   child: Column(
// // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       /// Basic Details
// // // //                       Text("Basic Details",
// // // //                           style: GoogleFonts.poppins(
// // // //                               fontSize: 16, fontWeight: FontWeight.w600)),
// // // //                       const SizedBox(height: 16),
// // // //                       _buildLabel("Title"),
// // // //                       const SizedBox(height: 6),
// // // //                       _buildInputField(hint: "Enter title"),
// // // //                       const SizedBox(height: 16),
// // // //                       Row(
// // // //                         children: [
// // // //                           Expanded(
// // // //                             child: Column(
// // // //                               crossAxisAlignment: CrossAxisAlignment.start,
// // // //                               children: [
// // // //                                 _buildLabel("Author"),
// // // //                                 const SizedBox(height: 6),
// // // //                                 _buildInputField(hint: "Enter author"),
// // // //                               ],
// // // //                             ),
// // // //                           ),
// // // //                           const SizedBox(width: 12),
// // // //                           Expanded(
// // // //                             child: Column(
// // // //                               crossAxisAlignment: CrossAxisAlignment.start,
// // // //                               children: [
// // // //                                 _buildLabel("Date"),
// // // //                                 const SizedBox(height: 6),
// // // //                                 TextFormField(
// // // //                                   controller: _dateController,
// // // //                                   readOnly: true,
// // // //                                   onTap: () => _selectDate(context),
// // // //                                   decoration: InputDecoration(
// // // //                                     suffixIcon: const Icon(Iconsax.calendar_1),
// // // //                                     hintText: "Select date",
// // // //                                     filled: true,
// // // //                                     fillColor: Colors.black12,
// // // //                                     border: OutlineInputBorder(
// // // //                                       borderRadius: BorderRadius.circular(6),
// // // //                                     ),
// // // //                                     enabledBorder: OutlineInputBorder(
// // // //                                       borderSide: const BorderSide(color: Colors.black12),
// // // //                                       borderRadius: BorderRadius.circular(6),
// // // //                                     ),
// // // //                                     focusedBorder: OutlineInputBorder(
// // // //                                       borderSide: const BorderSide(color: Colors.blueAccent),
// // // //                                       borderRadius: BorderRadius.circular(6),
// // // //                                     ),
// // // //                                   ),
// // // //                                 ),
// // // //                               ],
// // // //                             ),
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                       const SizedBox(height: 16),
// // // //                       _buildLabel("Description"),
// // // //                       const SizedBox(height: 6),
// // // //                       _buildInputField(hint: "Enter description", maxLines: 4),
// // // //                       const SizedBox(height: 24),
// // // //
// // // //                       /// Tags
// // // //                       Text("Tags",
// // // //                           style: GoogleFonts.poppins(
// // // //                               fontSize: 16, fontWeight: FontWeight.w600)),
// // // //                       const SizedBox(height: 14),
// // // //                       MultiSelectDropdown(
// // // //                         title: "Speakers",
// // // //                         items: speakers,
// // // //                         selectedItems: selectedSpeakers,
// // // //                         onSelectionChanged: (selected) {
// // // //                           setState(() {
// // // //                             selectedSpeakers = selected;
// // // //                           });
// // // //                         },
// // // //                       ),
// // // //                       const SizedBox(height: 16),
// // // //                       DropdownButtonFormField<String>(
// // // //                         value: selectedScripture,
// // // //                         decoration: InputDecoration(
// // // //                           hintText: "Select Scripture",
// // // //                           filled: true,
// // // //                           fillColor: Colors.black12,
// // // //                           border: OutlineInputBorder(
// // // //                             borderRadius: BorderRadius.circular(6),
// // // //                             borderSide: const BorderSide(color: Colors.black12),
// // // //                           ),
// // // //                         ),
// // // //                         items: scriptures
// // // //                             .map((s) => DropdownMenuItem(value: s, child: Text(s)))
// // // //                             .toList(),
// // // //                         onChanged: (val) {
// // // //                           setState(() {
// // // //                             selectedScripture = val;
// // // //                           });
// // // //                         },
// // // //                       ),
// // // //                       const SizedBox(height: 16),
// // // //                       MultiSelectDropdown(
// // // //                         title: "Topics",
// // // //                         items: topics,
// // // //                         selectedItems: selectedTopics,
// // // //                         onSelectionChanged: (selected) {
// // // //                           setState(() {
// // // //                             selectedTopics = selected;
// // // //                           });
// // // //                         },
// // // //                       ),
// // // //                       const SizedBox(height: 32),
// // // //
// // // //                       /// Video
// // // //                       Text("Video",
// // // //                           style: GoogleFonts.poppins(
// // // //                               fontSize: 16, fontWeight: FontWeight.w600)),
// // // //                       const SizedBox(height: 14),
// // // //                       Container(
// // // //                         height: size.height * 0.2,
// // // //                         width: double.infinity,
// // // //                         decoration: BoxDecoration(
// // // //                           borderRadius: BorderRadius.circular(15),
// // // //                           border: Border.all(color: Colors.black12),
// // // //                         ),
// // // //                       ),
// // // //                       const SizedBox(height: 14),
// // // //
// // // //                       /// Audio
// // // //                       Text("Audio",
// // // //                           style: GoogleFonts.poppins(
// // // //                               fontSize: 16, fontWeight: FontWeight.w600)),
// // // //                       const SizedBox(height: 14),
// // // //                       Container(
// // // //                         height: size.height * 0.1,
// // // //                         width: double.infinity,
// // // //                         decoration: BoxDecoration(
// // // //                           borderRadius: BorderRadius.circular(15),
// // // //                           border: Border.all(color: Colors.black12),
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildLabel(String text) =>
// // // //       Text(text, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]));
// // // //
// // // //   Widget _buildInputField({String? hint, int maxLines = 1}) => TextFormField(
// // // //     maxLines: maxLines,
// // // //     decoration: InputDecoration(
// // // //       hintText: hint,
// // // //       filled: true,
// // // //       fillColor: Colors.black12,
// // // //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
// // // //       enabledBorder: OutlineInputBorder(
// // // //         borderSide: const BorderSide(color: Colors.black12),
// // // //         borderRadius: BorderRadius.circular(6),
// // // //       ),
// // // //       focusedBorder: OutlineInputBorder(
// // // //         borderSide: const BorderSide(color: Colors.blueAccent),
// // // //         borderRadius: BorderRadius.circular(6),
// // // //       ),
// // // //     ),
// // // //   );
// // // // }
// // // //
// // // // /// Chart Data Model
// // // // class _ChartData {
// // // //   final String day;
// // // //   final double views;
// // // //   _ChartData(this.day, this.views);
// // // // }
// // // //
// // // // /// ---------------------------
// // // // /// Reusable MultiSelect Dropdown Widget
// // // // /// ---------------------------
// // // // class MultiSelectDropdown extends StatefulWidget {
// // // //   final String title;
// // // //   final List<String> items;
// // // //   final List<String> selectedItems;
// // // //   final Function(List<String>) onSelectionChanged;
// // // //
// // // //   const MultiSelectDropdown({
// // // //     super.key,
// // // //     required this.title,
// // // //     required this.items,
// // // //     required this.selectedItems,
// // // //     required this.onSelectionChanged,
// // // //   });
// // // //
// // // //   @override
// // // //   State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
// // // // }
// // // //
// // // // class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
// // // //   late List<String> tempSelected;
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     tempSelected = List.from(widget.selectedItems);
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         Text(widget.title, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
// // // //         const SizedBox(height: 6),
// // // //         InkWell(
// // // //           onTap: () async {
// // // //             final List<String>? results = await showDialog(
// // // //               context: context,
// // // //               builder: (_) => AlertDialog(
// // // //                 title: Text("Select ${widget.title}"),
// // // //                 content: SizedBox(
// // // //                   width: double.maxFinite,
// // // //                   child: ListView(
// // // //                     children: widget.items.map((item) {
// // // //                       final isSelected = tempSelected.contains(item);
// // // //                       return CheckboxListTile(
// // // //                         title: Text(item),
// // // //                         value: isSelected,
// // // //                         onChanged: (val) {
// // // //                           setState(() {
// // // //                             if (val == true) {
// // // //                               tempSelected.add(item);
// // // //                             } else {
// // // //                               tempSelected.remove(item);
// // // //                             }
// // // //                           });
// // // //                         },
// // // //                       );
// // // //                     }).toList(),
// // // //                   ),
// // // //                 ),
// // // //                 actions: [
// // // //                   TextButton(
// // // //                     onPressed: () => Navigator.pop(context, null),
// // // //                     child: const Text('Cancel'),
// // // //                   ),
// // // //                   ElevatedButton(
// // // //                     onPressed: () => Navigator.pop(context, tempSelected),
// // // //                     child: const Text('OK'),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             );
// // // //             if (results != null) {
// // // //               setState(() {
// // // //                 tempSelected = results;
// // // //               });
// // // //               widget.onSelectionChanged(tempSelected);
// // // //             }
// // // //           },
// // // //           child: Container(
// // // //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
// // // //             decoration: BoxDecoration(
// // // //               borderRadius: BorderRadius.circular(6),
// // // //               border: Border.all(color: Colors.black12),
// // // //               color: Colors.black12,
// // // //             ),
// // // //             child: Text(
// // // //               widget.selectedItems.isEmpty
// // // //                   ? 'Select ${widget.title}'
// // // //                   : widget.selectedItems.join(', '),
// // // //               style: const TextStyle(fontSize: 14),
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }
// // // // }
// // // //
// // // //
// // // //
// // // //
// // // //
// // // //
// // // //
// // // //
// // // //
// // // //
// // //
// // //
// // //
// // //
// // //
// // //
// // //
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:iconsax/iconsax.dart';
// // // import 'package:intl/intl.dart';
// // // import 'package:syncfusion_flutter_charts/charts.dart';
// // //
// // // class LibraryDetails extends StatefulWidget {
// // //   final String mediaitemid;
// // //
// // //   const LibraryDetails({super.key, required this.mediaitemid});
// // //
// // //   @override
// // //   State<LibraryDetails> createState() => _LibraryDetailsState();
// // // }
// // //
// // // class _LibraryDetailsState extends State<LibraryDetails> {
// // //   late String mediaitemid;
// // //
// // //   final TextEditingController _dateController = TextEditingController();
// // //   final TextEditingController _speakerController = TextEditingController();
// // //   final TextEditingController _scriptureController = TextEditingController();
// // //   final TextEditingController _topicsController = TextEditingController();
// // //
// // //
// // //   // Example chart data
// // //   final List<_ChartData> chartData = [
// // //     _ChartData("Mon", 5),
// // //     _ChartData("Tue", 8),
// // //     _ChartData("Wed", 6),
// // //     _ChartData("Thu", 10),
// // //     _ChartData("Fri", 7),
// // //   ];
// // //
// // //   // Example tag lists
// // //   final List<String> speakers = ["Speaker 1", "Speaker 2", "Speaker 3", "Speaker 4"];
// // //   final List<String> scriptures = ["Scripture 1", "Scripture 2", "Scripture 3"];
// // //   final List<String> topics = ["Topic 1", "Topic 2", "Topic 3"];
// // //
// // //   late TooltipBehavior _tooltipBehavior;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _tooltipBehavior = TooltipBehavior(
// // //       enable: true,
// // //       color: Colors.blueAccent.withOpacity(0.9),
// // //       textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// // //       format: 'point.x : point.y views',
// // //     );
// // //   }
// // //
// // //   // Date picker
// // //   Future<void> _selectDate(BuildContext context) async {
// // //     final pickedDate = await showDatePicker(
// // //       context: context,
// // //       initialDate: DateTime.now(),
// // //       firstDate: DateTime(2000),
// // //       lastDate: DateTime(2101),
// // //     );
// // //     if (pickedDate != null) {
// // //       setState(() {
// // //         _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
// // //       });
// // //     }
// // //   }
// // //
// // //   // Side sheet for multi-select
// // //   void _showSideSheet({
// // //     required BuildContext context,
// // //     required String title,
// // //     required List<String> items,
// // //     List<String>? preSelected,
// // //     required Function(List<String>) onSelected,
// // //   }) {
// // //     List<String> filteredItems = List.from(items);
// // //     List<String> selected = preSelected != null ? List.from(preSelected) : [];
// // //     final TextEditingController newItemController = TextEditingController();
// // //     final TextEditingController searchController = TextEditingController();
// // //
// // //     showGeneralDialog(
// // //       context: context,
// // //       barrierLabel: "SideSheet",
// // //       barrierDismissible: true,
// // //       barrierColor: Colors.black54,
// // //       transitionDuration: const Duration(milliseconds: 300),
// // //       pageBuilder: (context, anim1, anim2) {
// // //         return Align(
// // //           alignment: Alignment.centerRight,
// // //           child: Padding(
// // //             padding: const EdgeInsets.all(16),
// // //             child: Material(
// // //               color: Colors.white,
// // //               borderRadius: BorderRadius.circular(16),
// // //               child: Container(
// // //                 width: MediaQuery.of(context).size.width * 0.5,
// // //                 height: MediaQuery.of(context).size.height * 0.8,
// // //                 padding: const EdgeInsets.all(16),
// // //                 child: StatefulBuilder(
// // //                   builder: (context, setSheetState) {
// // //                     return Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         // Header
// // //                         Row(
// // //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                           children: [
// // //                             Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// // //                             IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
// // //                           ],
// // //                         ),
// // //                         const SizedBox(height: 12),
// // //
// // //                         // Add new item
// // //                         Row(
// // //                           children: [
// // //                             Expanded(
// // //                               child: TextField(
// // //                                 controller: newItemController,
// // //                                 decoration: const InputDecoration(
// // //                                   hintText: "Add new item",
// // //                                   border: OutlineInputBorder(),
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                             const SizedBox(width: 8),
// // //                             ElevatedButton(
// // //                               onPressed: () {
// // //                                 final newItem = newItemController.text.trim();
// // //                                 if (newItem.isNotEmpty && !items.contains(newItem)) {
// // //                                   setSheetState(() {
// // //                                     items.add(newItem);
// // //                                     filteredItems.add(newItem);
// // //                                     selected.add(newItem);
// // //                                     newItemController.clear();
// // //                                   });
// // //                                 }
// // //                               },
// // //                               child: const Text("Add"),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                         const SizedBox(height: 12),
// // //
// // //                         // Search with clear button
// // //                         TextField(
// // //                           controller: searchController,
// // //                           decoration: InputDecoration(
// // //                             hintText: "Search...",
// // //                             border: const OutlineInputBorder(),
// // //                             prefixIcon: const Icon(Icons.search),
// // //                             suffixIcon: searchController.text.isNotEmpty
// // //                                 ? IconButton(
// // //                               icon: const Icon(Icons.clear),
// // //                               onPressed: () {
// // //                                 setSheetState(() {
// // //                                   searchController.clear();
// // //                                   filteredItems = List.from(items);
// // //                                 });
// // //                               },
// // //                             )
// // //                                 : null,
// // //                           ),
// // //                           onChanged: (val) {
// // //                             setSheetState(() {
// // //                               filteredItems = items.where((e) => e.toLowerCase().contains(val.toLowerCase())).toList();
// // //                             });
// // //                           },
// // //                         ),
// // //                         const SizedBox(height: 12),
// // //
// // //                         // List
// // //                         Expanded(
// // //                           child: ListView.builder(
// // //                             itemCount: filteredItems.length,
// // //                             itemBuilder: (context, index) {
// // //                               final item = filteredItems[index];
// // //                               final isSelected = selected.contains(item);
// // //                               return ListTile(
// // //                                 title: Text(item),
// // //                                 trailing: isSelected
// // //                                     ? const Icon(Icons.check_circle, color: Colors.blue)
// // //                                     : const Icon(Icons.circle_outlined),
// // //                                 onTap: () {
// // //                                   setSheetState(() {
// // //                                     if (isSelected) {
// // //                                       selected.remove(item);
// // //                                     } else {
// // //                                       selected.add(item);
// // //                                     }
// // //                                   });
// // //                                 },
// // //                               );
// // //                             },
// // //                           ),
// // //                         ),
// // //
// // //                         // Done button
// // //                         ElevatedButton(
// // //                           style: ElevatedButton.styleFrom(
// // //                             minimumSize: const Size.fromHeight(48),
// // //                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// // //                           ),
// // //                           onPressed: () {
// // //                             onSelected(selected);
// // //                             Navigator.pop(context);
// // //                           },
// // //                           child: const Text("Done"),
// // //                         ),
// // //                       ],
// // //                     );
// // //                   },
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //       transitionBuilder: (context, anim1, anim2, child) {
// // //         return SlideTransition(
// // //           position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(anim1),
// // //           child: child,
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   /// Helper Widgets
// // //
// // //   Widget _buildStatCard(IconData icon, String value, String label) => Expanded(
// // //     child: Container(
// // //       padding: const EdgeInsets.all(12),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(12),
// // //         border: Border.all(color: Colors.black26),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Icon(icon, color: Colors.black54),
// // //           const SizedBox(width: 8),
// // //           Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
// // //               Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     ),
// // //   );
// // //
// // //   Widget _buildSectionTitle(String text) => Padding(
// // //     padding: const EdgeInsets.only(bottom: 8),
// // //     child: Text(text, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
// // //   );
// // //
// // //   Widget _buildLabel(String text) => Padding(
// // //     padding: const EdgeInsets.only(bottom: 6, top: 12),
// // //     child: Text(text, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700])),
// // //   );
// // //
// // //   Widget _buildTagLabel(String text, {String? tooltipMessage}) => Row(
// // //     crossAxisAlignment: CrossAxisAlignment.center,
// // //     children: [
// // //       _buildLabel(text),
// // //       const SizedBox(width: 4),
// // //       Tooltip(
// // //         message: tooltipMessage ?? "More info about $text",
// // //         waitDuration: const Duration(milliseconds: 300),
// // //         showDuration: const Duration(seconds: 3),
// // //         decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(6)),
// // //         textStyle: const TextStyle(color: Colors.white, fontSize: 12),
// // //         child: const Icon(Iconsax.info_circle, size: 14, color: Colors.grey),
// // //       ),
// // //     ],
// // //   );
// // //
// // //   InputDecoration _inputDecoration({String? hint, IconData? icon}) => InputDecoration(
// // //     hintText: hint,
// // //     suffixIcon: icon != null ? Icon(icon) : null,
// // //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
// // //     enabledBorder: OutlineInputBorder(
// // //       borderSide: const BorderSide(color: Colors.black12),
// // //       borderRadius: BorderRadius.circular(6),
// // //     ),
// // //     focusedBorder: OutlineInputBorder(
// // //       borderSide: const BorderSide(color: Colors.blueAccent),
// // //       borderRadius: BorderRadius.circular(6),
// // //     ),
// // //   );
// // //
// // //   Widget _buildInputField({String? hint, int maxLines = 1, TextEditingController? controller}) =>
// // //       TextFormField(controller: controller, maxLines: maxLines, decoration: _inputDecoration(hint: hint));
// // //
// // //   Widget _buildSelectableField({
// // //     required TextEditingController controller,
// // //     required String hint,
// // //     required VoidCallback onTap,
// // //   }) {
// // //     return TextFormField(
// // //       controller: controller,
// // //       readOnly: true,
// // //       onTap: onTap,
// // //       decoration: InputDecoration(
// // //         hintText: hint,
// // //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
// // //         enabledBorder: OutlineInputBorder(
// // //           borderSide: const BorderSide(color: Colors.black12),
// // //           borderRadius: BorderRadius.circular(6),
// // //         ),
// // //         focusedBorder: OutlineInputBorder(
// // //           borderSide: const BorderSide(color: Colors.blueAccent),
// // //           borderRadius: BorderRadius.circular(6),
// // //         ),
// // //         suffixIcon: Row(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: [
// // //             if (controller.text.isNotEmpty)
// // //               IconButton(
// // //                 icon: const Icon(Icons.clear, color: Colors.grey),
// // //                 onPressed: () {
// // //                   controller.clear();
// // //                   setState(() {});
// // //                 },
// // //               ),
// // //             const Icon(Icons.arrow_drop_down, color: Colors.grey),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildMediaBox(double height) => Container(
// // //     height: height,
// // //     width: double.infinity,
// // //     decoration: BoxDecoration(
// // //       borderRadius: BorderRadius.circular(15),
// // //       border: Border.all(color: Colors.black12),
// // //     ),
// // //   );
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final size = MediaQuery.of(context).size;
// // //     final double boxWidth = size.width * 0.85;
// // //
// // //     return Scaffold(
// // //       backgroundColor: Colors.grey[100],
// // //       body: Column(
// // //         children: [
// // //           // Chart
// // //           Padding(
// // //             padding: EdgeInsets.symmetric(horizontal: size.width * 0.075),
// // //             child: Container(
// // //               padding: const EdgeInsets.all(12),
// // //               margin: const EdgeInsets.only(top: 16),
// // //               decoration: BoxDecoration(
// // //                 color: Colors.white,
// // //                 borderRadius: BorderRadius.circular(12),
// // //                 boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
// // //               ),
// // //               child: Column(
// // //                 children: [
// // //                   SizedBox(
// // //                     height: size.height * 0.25,
// // //                     child: SfCartesianChart(
// // //                       title: ChartTitle(text: 'Analytics of : ${widget.mediaitemid}'),
// // //                       primaryXAxis: CategoryAxis(),
// // //                       primaryYAxis: NumericAxis(),
// // //                       tooltipBehavior: _tooltipBehavior,
// // //                       series: <CartesianSeries<_ChartData, String>>[
// // //                         ColumnSeries<_ChartData, String>(
// // //                           dataSource: chartData,
// // //                           xValueMapper: (data, _) => data.day,
// // //                           yValueMapper: (data, _) => data.views,
// // //                           color: Colors.blueAccent,
// // //                           borderRadius: BorderRadius.circular(6),
// // //                           dataLabelSettings: const DataLabelSettings(isVisible: true),
// // //                           enableTooltip: true,
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 12),
// // //                   Row(
// // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                     children: [
// // //                       Text('Media Item id : ${widget.mediaitemid}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
// // //                       const Spacer(),
// // //                       _buildStatCard(Icons.remove_red_eye, '0', 'All time plays'),
// // //                       const SizedBox(width: 12),
// // //                       _buildStatCard(Icons.bar_chart, '0 on Sep 28, 2025', 'Peak traffic plays'),
// // //                     ],
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //           const SizedBox(height: 16),
// // //           // Form
// // //           Expanded(
// // //             child: SingleChildScrollView(
// // //               child: Container(
// // //                 width: boxWidth,
// // //                 padding: const EdgeInsets.all(16),
// // //                 decoration: BoxDecoration(
// // //                   borderRadius: BorderRadius.circular(10),
// // //                   color: Colors.white,
// // //                   boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
// // //                 ),
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     _buildSectionTitle("Basic Details"),
// // //                     _buildLabel("Title"),
// // //                     _buildInputField(hint: "Enter title"),
// // //                     const SizedBox(height: 16),
// // //                     Row(
// // //                       children: [
// // //                         Expanded(
// // //                           child: Column(
// // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // //                             children: [
// // //                               _buildLabel("Author"),
// // //                               _buildInputField(hint: "Enter author"),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                         const SizedBox(width: 12),
// // //                         Expanded(
// // //                           child: Column(
// // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // //                             children: [
// // //                               _buildLabel("Date"),
// // //                               TextFormField(
// // //                                 controller: _dateController,
// // //                                 readOnly: true,
// // //                                 onTap: () => _selectDate(context),
// // //                                 decoration: _inputDecoration(hint: "Select date", icon: Iconsax.calendar_1),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     const SizedBox(height: 16),
// // //                     _buildLabel("Description"),
// // //                     _buildInputField(hint: "Enter description", maxLines: 4),
// // //                     const SizedBox(height: 24),
// // //                     _buildSectionTitle("Tags"),
// // //                     // Speakers
// // //                     _buildTagLabel("Speakers", tooltipMessage: "Select speakers"),
// // //                     _buildSelectableField(
// // //                       controller: _speakerController,
// // //                       hint: "Tap to select speakers",
// // //                       onTap: () => _showSideSheet(
// // //                         context: context,
// // //                         title: "Select Speakers",
// // //                         items: speakers,
// // //                         preSelected: _speakerController.text.isEmpty ? [] : _speakerController.text.split(", "),
// // //                         onSelected: (selected) => setState(() => _speakerController.text = selected.join(", ")),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 16),
// // //                     // Scripture
// // //                     _buildTagLabel("Scripture", tooltipMessage: "Select scripture references"),
// // //                     _buildSelectableField(
// // //                       controller: _scriptureController,
// // //                       hint: "Tap to select scripture",
// // //                       onTap: () => _showSideSheet(
// // //                         context: context,
// // //                         title: "Select Scripture",
// // //                         items: scriptures,
// // //                         preSelected: _scriptureController.text.isEmpty ? [] : _scriptureController.text.split(", "),
// // //                         onSelected: (selected) => setState(() => _scriptureController.text = selected.join(", ")),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 16),
// // //                     // Topics
// // //                     _buildTagLabel("Topics", tooltipMessage: "Select main topics"),
// // //                     _buildSelectableField(
// // //                       controller: _topicsController,
// // //                       hint: "Tap to select topics",
// // //                       onTap: () => _showSideSheet(
// // //                         context: context,
// // //                         title: "Select Topics",
// // //                         items: topics,
// // //                         preSelected: _topicsController.text.isEmpty ? [] : _topicsController.text.split(", "),
// // //                         onSelected: (selected) => setState(() => _topicsController.text = selected.join(", ")),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 32),
// // //                     _buildSectionTitle("Video"),
// // //                     SizedBox(width: boxWidth, child: _buildMediaBox(size.height * 0.2)),
// // //                     const SizedBox(height: 16),
// // //                     _buildSectionTitle("Audio"),
// // //                     SizedBox(width: boxWidth, child: _buildMediaBox(size.height * 0.1)),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // /// Chart data model
// // // class _ChartData {
// // //   final String day;
// // //   final double views;
// // //   _ChartData(this.day, this.views);
// // // }
// //
// //
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:intl/intl.dart';
// // import 'package:syncfusion_flutter_charts/charts.dart';
// // import '../Controller/Media_analytics_controller.dart';
// //
// // class LibraryDetails extends StatefulWidget {
// //   final String mediaitemid;
// //
// //   const LibraryDetails({super.key, required this.mediaitemid});
// //
// //   @override
// //   State<LibraryDetails> createState() => _LibraryDetailsState();
// // }
// //
// // class _LibraryDetailsState extends State<LibraryDetails> {
// //   // Controllers
// //   final TextEditingController _dateController = TextEditingController();
// //   final TextEditingController _speakerController = TextEditingController();
// //   final TextEditingController _scriptureController = TextEditingController();
// //   final TextEditingController _topicsController = TextEditingController();
// //
// //   // API state
// //   bool isLoading = true;
// //   String? error;
// //
// //   // Analytics Data
// //   List<_ChartData> chartData = [];
// //   int totalViews = 0;
// //   int peakViews = 0;
// //   String peakDate = "-";
// //
// //   // Tooltip
// //   late TooltipBehavior _tooltipBehavior;
// //
// //   // Services
// //   final AnalyticsService analyticsService = AnalyticsService();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _tooltipBehavior = TooltipBehavior(
// //       enable: true,
// //       color: Colors.blueAccent.withOpacity(0.9),
// //       textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //       format: 'point.x : point.y views',
// //     );
// //     fetchAnalytics();
// //   }
// //
// //   // Fetch analytics data from API
// //   Future<void> fetchAnalytics() async {
// //     setState(() {
// //       isLoading = true;
// //       error = null;
// //     });
// //
// //     try {
// //       final data = await analyticsService.getSingleMediaAnalytics(widget.mediaitemid);
// //       final analytics = data['analytics'] ?? {};
// //
// //       final List<dynamic> rawChart = analytics['chartData'] ?? [];
// //       final List<_ChartData> mappedChart = rawChart.map((e) {
// //         return _ChartData(
// //           e['date']?.toString() ?? '',
// //           (e['views'] ?? 0).toDouble(),
// //         );
// //       }).toList();
// //
// //       setState(() {
// //         chartData = mappedChart;
// //         totalViews = analytics['totalViews'] ?? 0;
// //         peakViews = analytics['peakViews'] ?? 0;
// //         peakDate = analytics['peakDate']?.toString() ?? "-";
// //         isLoading = false;
// //       });
// //     } catch (e) {
// //       setState(() {
// //         error = e.toString();
// //         isLoading = false;
// //       });
// //     }
// //   }
// //
// //   // Example tag lists
// //   final List<String> speakers = ["Speaker 1", "Speaker 2", "Speaker 3"];
// //   final List<String> scriptures = ["Scripture 1", "Scripture 2", "Scripture 3"];
// //   final List<String> topics = ["Topic 1", "Topic 2", "Topic 3"];
// //
// //   // Date picker
// //   Future<void> _selectDate(BuildContext context) async {
// //     final pickedDate = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime(2101),
// //     );
// //     if (pickedDate != null) {
// //       setState(() {
// //         _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
// //       });
// //     }
// //   }
// //
// //   // Side sheet for multi-select tags
// //   void _showSideSheet({
// //     required BuildContext context,
// //     required String title,
// //     required List<String> items,
// //     List<String>? preSelected,
// //     required Function(List<String>) onSelected,
// //   }) {
// //     List<String> filteredItems = List.from(items);
// //     List<String> selected = preSelected != null ? List.from(preSelected) : [];
// //     final TextEditingController newItemController = TextEditingController();
// //     final TextEditingController searchController = TextEditingController();
// //
// //     showGeneralDialog(
// //       context: context,
// //       barrierLabel: "SideSheet",
// //       barrierDismissible: true,
// //       barrierColor: Colors.black54,
// //       transitionDuration: const Duration(milliseconds: 300),
// //       pageBuilder: (context, anim1, anim2) {
// //         return Align(
// //           alignment: Alignment.centerRight,
// //           child: Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: Material(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(16),
// //               child: Container(
// //                 width: MediaQuery.of(context).size.width * 0.5,
// //                 height: MediaQuery.of(context).size.height * 0.8,
// //                 padding: const EdgeInsets.all(16),
// //                 child: StatefulBuilder(
// //                   builder: (context, setSheetState) {
// //                     return Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //                             IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
// //                           ],
// //                         ),
// //                         const SizedBox(height: 12),
// //                         // Add new item
// //                         Row(
// //                           children: [
// //                             Expanded(
// //                               child: TextField(
// //                                 controller: newItemController,
// //                                 decoration: const InputDecoration(
// //                                   hintText: "Add new item",
// //                                   border: OutlineInputBorder(),
// //                                 ),
// //                               ),
// //                             ),
// //                             const SizedBox(width: 8),
// //                             ElevatedButton(
// //                               onPressed: () {
// //                                 final newItem = newItemController.text.trim();
// //                                 if (newItem.isNotEmpty && !items.contains(newItem)) {
// //                                   setSheetState(() {
// //                                     items.add(newItem);
// //                                     filteredItems.add(newItem);
// //                                     selected.add(newItem);
// //                                     newItemController.clear();
// //                                   });
// //                                 }
// //                               },
// //                               child: const Text("Add"),
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(height: 12),
// //                         // Search
// //                         TextField(
// //                           controller: searchController,
// //                           decoration: InputDecoration(
// //                             hintText: "Search...",
// //                             border: const OutlineInputBorder(),
// //                             prefixIcon: const Icon(Icons.search),
// //                             suffixIcon: searchController.text.isNotEmpty
// //                                 ? IconButton(
// //                               icon: const Icon(Icons.clear),
// //                               onPressed: () {
// //                                 setSheetState(() {
// //                                   searchController.clear();
// //                                   filteredItems = List.from(items);
// //                                 });
// //                               },
// //                             )
// //                                 : null,
// //                           ),
// //                           onChanged: (val) {
// //                             setSheetState(() {
// //                               filteredItems = items.where((e) => e.toLowerCase().contains(val.toLowerCase())).toList();
// //                             });
// //                           },
// //                         ),
// //                         const SizedBox(height: 12),
// //                         // List
// //                         Expanded(
// //                           child: ListView.builder(
// //                             itemCount: filteredItems.length,
// //                             itemBuilder: (context, index) {
// //                               final item = filteredItems[index];
// //                               final isSelected = selected.contains(item);
// //                               return ListTile(
// //                                 title: Text(item),
// //                                 trailing: isSelected
// //                                     ? const Icon(Icons.check_circle, color: Colors.blue)
// //                                     : const Icon(Icons.circle_outlined),
// //                                 onTap: () {
// //                                   setSheetState(() {
// //                                     if (isSelected) {
// //                                       selected.remove(item);
// //                                     } else {
// //                                       selected.add(item);
// //                                     }
// //                                   });
// //                                 },
// //                               );
// //                             },
// //                           ),
// //                         ),
// //                         ElevatedButton(
// //                           style: ElevatedButton.styleFrom(
// //                             minimumSize: const Size.fromHeight(48),
// //                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// //                           ),
// //                           onPressed: () {
// //                             onSelected(selected);
// //                             Navigator.pop(context);
// //                           },
// //                           child: const Text("Done"),
// //                         ),
// //                       ],
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //       transitionBuilder: (context, anim1, anim2, child) {
// //         return SlideTransition(
// //           position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(anim1),
// //           child: child,
// //         );
// //       },
// //     );
// //   }
// //
// //   // Helper Widgets
// //   Widget _buildStatCard(IconData icon, String value, String label) => Expanded(
// //     child: Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: Colors.black26),
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(icon, color: Colors.black54),
// //           const SizedBox(width: 8),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
// //               Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
// //             ],
// //           ),
// //         ],
// //       ),
// //     ),
// //   );
// //
// //   Widget _buildSectionTitle(String text) => Padding(
// //     padding: const EdgeInsets.only(bottom: 8),
// //     child: Text(text, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
// //   );
// //
// //   Widget _buildLabel(String text) => Padding(
// //     padding: const EdgeInsets.only(bottom: 6, top: 12),
// //     child: Text(text, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700])),
// //   );
// //
// //   Widget _buildSelectableField({
// //     required TextEditingController controller,
// //     required String hint,
// //     required VoidCallback onTap,
// //   }) {
// //     return TextFormField(
// //       controller: controller,
// //       readOnly: true,
// //       onTap: onTap,
// //       decoration: InputDecoration(
// //         hintText: hint,
// //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
// //         suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildMediaBox(double height) => Container(
// //     height: height,
// //     width: double.infinity,
// //     decoration: BoxDecoration(
// //       borderRadius: BorderRadius.circular(15),
// //       border: Border.all(color: Colors.black12),
// //     ),
// //   );
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;
// //     final double boxWidth = size.width * 0.85;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.grey[100],
// //       body: Column(
// //         children: [
// //           // Chart Section
// //           Padding(
// //             padding: EdgeInsets.symmetric(horizontal: size.width * 0.075),
// //             child: Container(
// //               padding: const EdgeInsets.all(12),
// //               margin: const EdgeInsets.only(top: 16),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(12),
// //                 boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
// //               ),
// //               child: isLoading
// //                   ? const Center(child: CircularProgressIndicator())
// //                   : error != null
// //                   ? Text('Error: $error', style: const TextStyle(color: Colors.red))
// //                   : Column(
// //                 children: [
// //                   SizedBox(
// //                     height: size.height * 0.25,
// //                     child: SfCartesianChart(
// //                       title: ChartTitle(text: 'Analytics for: ${widget.mediaitemid}'),
// //                       primaryXAxis: CategoryAxis(),
// //                       primaryYAxis: NumericAxis(),
// //                       tooltipBehavior: _tooltipBehavior,
// //                       series: <CartesianSeries<_ChartData, String>>[
// //                         ColumnSeries<_ChartData, String>(
// //                           dataSource: chartData,
// //                           xValueMapper: (data, _) => data.day,
// //                           yValueMapper: (data, _) => data.views,
// //                           color: Colors.blueAccent,
// //                           borderRadius: BorderRadius.circular(6),
// //                           dataLabelSettings: const DataLabelSettings(isVisible: true),
// //                           enableTooltip: true,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 12),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Text('Media Item ID : ${widget.mediaitemid}',
// //                           style: const TextStyle(color: Colors.black54, fontSize: 12)),
// //                       const Spacer(),
// //                       _buildStatCard(Icons.remove_red_eye, '$totalViews', 'All time plays'),
// //                       const SizedBox(width: 12),
// //                       _buildStatCard(Icons.bar_chart, '$peakViews on $peakDate', 'Peak traffic plays'),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //
// //           const SizedBox(height: 16),
// //
// //           // Form Section
// //           Expanded(
// //             child: SingleChildScrollView(
// //               child: Container(
// //                 width: boxWidth,
// //                 padding: const EdgeInsets.all(16),
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(10),
// //                   color: Colors.white,
// //                   boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
// //                 ),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     _buildSectionTitle("Basic Details"),
// //                     _buildLabel("Title"),
// //                     TextFormField(decoration: const InputDecoration(hintText: "Enter title")),
// //                     const SizedBox(height: 16),
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               _buildLabel("Author"),
// //                               TextFormField(decoration: const InputDecoration(hintText: "Enter author")),
// //                             ],
// //                           ),
// //                         ),
// //                         const SizedBox(width: 12),
// //                         Expanded(
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               _buildLabel("Date"),
// //                               TextFormField(
// //                                 controller: _dateController,
// //                                 readOnly: true,
// //                                 onTap: () => _selectDate(context),
// //                                 decoration: const InputDecoration(
// //                                   hintText: "Select date",
// //                                   suffixIcon: Icon(Iconsax.calendar_1),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 16),
// //                     _buildLabel("Description"),
// //                     TextFormField(maxLines: 4, decoration: const InputDecoration(hintText: "Enter description")),
// //                     const SizedBox(height: 24),
// //                     _buildSectionTitle("Tags"),
// //                     _buildLabel("Speakers"),
// //                     _buildSelectableField(
// //                       controller: _speakerController,
// //                       hint: "Tap to select speakers",
// //                       onTap: () => _showSideSheet(
// //                         context: context,
// //                         title: "Select Speakers",
// //                         items: speakers,
// //                         preSelected: _speakerController.text.isEmpty
// //                             ? []
// //                             : _speakerController.text.split(", "),
// //                         onSelected: (selected) => setState(() => _speakerController.text = selected.join(", ")),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //                     _buildLabel("Scripture"),
// //                     _buildSelectableField(
// //                       controller: _scriptureController,
// //                       hint: "Tap to select scripture",
// //                       onTap: () => _showSideSheet(
// //                         context: context,
// //                         title: "Select Scripture",
// //                         items: scriptures,
// //                         preSelected: _scriptureController.text.isEmpty
// //                             ? []
// //                             : _scriptureController.text.split(", "),
// //                         onSelected: (selected) => setState(() => _scriptureController.text = selected.join(", ")),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //                     _buildLabel("Topics"),
// //                     _buildSelectableField(
// //                       controller: _topicsController,
// //                       hint: "Tap to select topics",
// //                       onTap: () => _showSideSheet(
// //                         context: context,
// //                         title: "Select Topics",
// //                         items: topics,
// //                         preSelected: _topicsController.text.isEmpty
// //                             ? []
// //                             : _topicsController.text.split(", "),
// //                         onSelected: (selected) => setState(() => _topicsController.text = selected.join(", ")),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 32),
// //                     _buildSectionTitle("Video"),
// //                     SizedBox(width: boxWidth, child: _buildMediaBox(size.height * 0.2)),
// //                     const SizedBox(height: 16),
// //                     _buildSectionTitle("Audio"),
// //                     SizedBox(width: boxWidth, child: _buildMediaBox(size.height * 0.1)),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // /// Chart data model
// // class _ChartData {
// //   final String day;
// //   final double views;
// //   _ChartData(this.day, this.views);
// // }
//
//
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import '../Controller/Media_analytics_controller.dart';
//
// class LibraryDetails extends StatefulWidget {
//   final String mediaitemid;
//
//   const LibraryDetails({super.key, required this.mediaitemid});
//
//   @override
//   State<LibraryDetails> createState() => _LibraryDetailsState();
// }
//
// class _LibraryDetailsState extends State<LibraryDetails> {
//   // Controllers
//   final TextEditingController _dateController = TextEditingController();
//   final TextEditingController _speakerController = TextEditingController();
//   final TextEditingController _scriptureController = TextEditingController();
//   final TextEditingController _topicsController = TextEditingController();
//
//   // API state
//   bool isLoading = true;
//   String? error;
//
//   // Analytics Data
//   List<_ChartData> chartData = [];
//   int totalViews = 0;
//   int peakViews = 0;
//
//   // Tooltip
//   late TooltipBehavior _tooltipBehavior;
//
//   // Services
//   final AnalyticsService analyticsService = AnalyticsService();
//
//   @override
//   void initState() {
//     super.initState();
//     _tooltipBehavior = TooltipBehavior(
//       enable: true,
//       color: Colors.blueAccent.withOpacity(0.9),
//       textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//       format: 'point.x : point.y plays',
//     );
//     fetchAnalytics();
//   }
//
//   // 📊 Fetch analytics data from API
//   Future<void> fetchAnalytics() async {
//     setState(() {
//       isLoading = true;
//       error = null;
//     });
//
//     try {
//       print("🔍 Fetching analytics for mediaItemId: ${widget.mediaitemid}");
//       final data = await analyticsService.getSingleMediaAnalytics(widget.mediaitemid);
//       print("📥 Response body: $data"); // Print full response
//
//       final Map<String, dynamic> devices = data['devices'] ?? {};
//
//       // Map devices to chart data
//       final List<_ChartData> mappedChart = devices.entries.map((e) {
//         return _ChartData(e.key, (e.value ?? 0).toDouble());
//       }).toList();
//
//       setState(() {
//         chartData = mappedChart;
//         totalViews = data['plays'] ?? 0;
//         peakViews = devices.values.isNotEmpty ? devices.values.reduce((a, b) => a > b ? a : b) : 0;
//         isLoading = false;
//       });
//
//       print("✅ Analytics fetched successfully. ${chartData.length} chart points loaded.");
//     } catch (e) {
//       setState(() {
//         error = e.toString();
//         isLoading = false;
//       });
//       print("❌ Error fetching analytics: $e");
//     }
//   }
//
//   // Example tag lists
//   final List<String> speakers = ["Speaker 1", "Speaker 2", "Speaker 3"];
//   final List<String> scriptures = ["Scripture 1", "Scripture 2", "Scripture 3"];
//   final List<String> topics = ["Topic 1", "Topic 2", "Topic 3"];
//
//   // 📅 Date picker
//   Future<void> _selectDate(BuildContext context) async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _dateController.text = pickedDate.toIso8601String().split('T')[0];
//       });
//     }
//   }
//
//   // 🧭 Side Sheet for Multi-select Tags
//   void _showSideSheet({
//     required BuildContext context,
//     required String title,
//     required List<String> items,
//     List<String>? preSelected,
//     required Function(List<String>) onSelected,
//   }) {
//     List<String> filteredItems = List.from(items);
//     List<String> selected = preSelected != null ? List.from(preSelected) : [];
//     final TextEditingController newItemController = TextEditingController();
//     final TextEditingController searchController = TextEditingController();
//
//     showGeneralDialog(
//       context: context,
//       barrierLabel: "SideSheet",
//       barrierDismissible: true,
//       barrierColor: Colors.black54,
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (context, anim1, anim2) {
//         return Align(
//           alignment: Alignment.centerRight,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Material(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.5,
//                 height: MediaQuery.of(context).size.height * 0.8,
//                 padding: const EdgeInsets.all(16),
//                 child: StatefulBuilder(
//                   builder: (context, setSheetState) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                             IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         // Add new item
//                         Row(
//                           children: [
//                             Expanded(
//                               child: TextField(
//                                 controller: newItemController,
//                                 decoration: const InputDecoration(
//                                   hintText: "Add new item",
//                                   border: OutlineInputBorder(),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             ElevatedButton(
//                               onPressed: () {
//                                 final newItem = newItemController.text.trim();
//                                 if (newItem.isNotEmpty && !items.contains(newItem)) {
//                                   setSheetState(() {
//                                     items.add(newItem);
//                                     filteredItems.add(newItem);
//                                     selected.add(newItem);
//                                     newItemController.clear();
//                                   });
//                                 }
//                               },
//                               child: const Text("Add"),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         // Search
//                         TextField(
//                           controller: searchController,
//                           decoration: InputDecoration(
//                             hintText: "Search...",
//                             border: const OutlineInputBorder(),
//                             prefixIcon: const Icon(Icons.search),
//                             suffixIcon: searchController.text.isNotEmpty
//                                 ? IconButton(
//                               icon: const Icon(Icons.clear),
//                               onPressed: () {
//                                 setSheetState(() {
//                                   searchController.clear();
//                                   filteredItems = List.from(items);
//                                 });
//                               },
//                             )
//                                 : null,
//                           ),
//                           onChanged: (val) {
//                             setSheetState(() {
//                               filteredItems = items
//                                   .where((e) => e.toLowerCase().contains(val.toLowerCase()))
//                                   .toList();
//                             });
//                           },
//                         ),
//                         const SizedBox(height: 12),
//                         // List
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: filteredItems.length,
//                             itemBuilder: (context, index) {
//                               final item = filteredItems[index];
//                               final isSelected = selected.contains(item);
//                               return ListTile(
//                                 title: Text(item),
//                                 trailing: isSelected
//                                     ? const Icon(Icons.check_circle, color: Colors.blue)
//                                     : const Icon(Icons.circle_outlined),
//                                 onTap: () {
//                                   setSheetState(() {
//                                     if (isSelected) {
//                                       selected.remove(item);
//                                     } else {
//                                       selected.add(item);
//                                     }
//                                   });
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             minimumSize: const Size.fromHeight(48),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                           ),
//                           onPressed: () {
//                             onSelected(selected);
//                             Navigator.pop(context);
//                           },
//                           child: const Text("Done"),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//       transitionBuilder: (context, anim1, anim2, child) {
//         return SlideTransition(
//           position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(anim1),
//           child: child,
//         );
//       },
//     );
//   }
//
//   // Helper UI Builders
//   Widget _buildStatCard(IconData icon, String value, String label) => Expanded(
//     child: Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.black26),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.black54),
//           const SizedBox(width: 8),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
//               Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
//
//   Widget _buildSectionTitle(String text) => Padding(
//     padding: const EdgeInsets.only(bottom: 8),
//     child: Text(text, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
//   );
//
//   Widget _buildLabel(String text) => Padding(
//     padding: const EdgeInsets.only(bottom: 6, top: 12),
//     child: Text(text, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700])),
//   );
//
//   Widget _buildSelectableField({
//     required TextEditingController controller,
//     required String hint,
//     required VoidCallback onTap,
//   }) {
//     return TextFormField(
//       controller: controller,
//       readOnly: true,
//       onTap: onTap,
//       decoration: InputDecoration(
//         hintText: hint,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
//         suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
//       ),
//     );
//   }
//
//   Widget _buildMediaBox(double height) => Container(
//     height: height,
//     width: double.infinity,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(15),
//       border: Border.all(color: Colors.black12),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final double boxWidth = size.width * 0.85;
//
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Column(
//         children: [
//           // 📊 Chart Section
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: size.width * 0.075),
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               margin: const EdgeInsets.only(top: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
//               ),
//               child: isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : error != null
//                   ? Text('Error: $error', style: const TextStyle(color: Colors.red))
//                   : Column(
//                 children: [
//                   SizedBox(
//                     height: size.height * 0.25,
//                     child: SfCartesianChart(
//                       title: ChartTitle(text: 'Device Distribution'),
//                       primaryXAxis: CategoryAxis(),
//                       primaryYAxis: NumericAxis(),
//                       tooltipBehavior: _tooltipBehavior,
//                       series: <CartesianSeries<_ChartData, String>>[
//                         ColumnSeries<_ChartData, String>(
//                           dataSource: chartData,
//                           xValueMapper: (data, _) => data.device,
//                           yValueMapper: (data, _) => data.count,
//                           color: Colors.blueAccent,
//                           borderRadius: BorderRadius.circular(6),
//                           dataLabelSettings: const DataLabelSettings(isVisible: true),
//                           enableTooltip: true,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Media Item ID : ${widget.mediaitemid}',
//                           style: const TextStyle(color: Colors.black54, fontSize: 12)),
//                       const Spacer(),
//                       _buildStatCard(Icons.remove_red_eye, '$totalViews', 'All time plays'),
//                       const SizedBox(width: 12),
//                       _buildStatCard(Icons.bar_chart, '$peakViews', 'Peak device plays'),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           // 📋 Form Section
//           Expanded(
//             child: SingleChildScrollView(
//               child: Container(
//                 width: boxWidth,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                   boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildSectionTitle("Basic Details"),
//                     _buildLabel("Title"),
//                     TextFormField(decoration: const InputDecoration(hintText: "Enter title")),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildLabel("Author"),
//                               TextFormField(decoration: const InputDecoration(hintText: "Enter author")),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildLabel("Date"),
//                               TextFormField(
//                                 controller: _dateController,
//                                 readOnly: true,
//                                 onTap: () => _selectDate(context),
//                                 decoration: const InputDecoration(
//                                   hintText: "Select date",
//                                   suffixIcon: Icon(Iconsax.calendar_1),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     _buildLabel("Description"),
//                     TextFormField(maxLines: 4, decoration: const InputDecoration(hintText: "Enter description")),
//                     const SizedBox(height: 24),
//
//                     _buildSectionTitle("Tags"),
//                     _buildLabel("Speakers"),
//                     _buildSelectableField(
//                       controller: _speakerController,
//                       hint: "Tap to select speakers",
//                       onTap: () => _showSideSheet(
//                         context: context,
//                         title: "Select Speakers",
//                         items: speakers,
//                         preSelected: _speakerController.text.isEmpty
//                             ? []
//                             : _speakerController.text.split(", "),
//                         onSelected: (selected) =>
//                             setState(() => _speakerController.text = selected.join(", ")),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildLabel("Scripture"),
//                     _buildSelectableField(
//                       controller: _scriptureController,
//                       hint: "Tap to select scripture",
//                       onTap: () => _showSideSheet(
//                         context: context,
//                         title: "Select Scripture",
//                         items: scriptures,
//                         preSelected: _scriptureController.text.isEmpty
//                             ? []
//                             : _scriptureController.text.split(", "),
//                         onSelected: (selected) =>
//                             setState(() => _scriptureController.text = selected.join(", ")),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildLabel("Topics"),
//                     _buildSelectableField(
//                       controller: _topicsController,
//                       hint: "Tap to select topics",
//                       onTap: () => _showSideSheet(
//                         context: context,
//                         title: "Select Topics",
//                         items: topics,
//                         preSelected: _topicsController.text.isEmpty
//                             ? []
//                             : _topicsController.text.split(", "),
//                         onSelected: (selected) =>
//                             setState(() => _topicsController.text = selected.join(", ")),
//                       ),
//                     ),
//                     const SizedBox(height: 32),
//                     _buildSectionTitle("Video"),
//                     SizedBox(width: boxWidth, child: _buildMediaBox(size.height * 0.2)),
//                     const SizedBox(height: 16),
//                     _buildSectionTitle("Audio"),
//                     SizedBox(width: boxWidth, child: _buildMediaBox(size.height * 0.1)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Chart data model
// class _ChartData {
//   final String device;
//   final double count;
//   _ChartData(this.device, this.count);
// }


import 'package:flutter/material.dart';
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
      if (filtered && selectedMediaItem != null && mediaController.value != "All Media") {
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

      final chartDataRaw = List<Map<String, dynamic>>.from(data['chartData'] ?? []);

      // ✅ Parse backend months only (no extras)
      final df = DateFormat("MMM yyyy");
      final chartData = chartDataRaw.map((d) {
        return {
          ...d,
          'dateObj': df.parse(d['month']),
        };
      }).toList();

      // ✅ Sort by actual date so they’re sequential
      chartData.sort((a, b) => (a['dateObj'] as DateTime).compareTo(b['dateObj'] as DateTime));

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
    final chartData = List<Map<String, dynamic>>.from(analyticsData?['chartData'] ?? []);
    final mediaItems = List<Map<String, dynamic>>.from(analyticsData?['mediaList'] ?? []);

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
              ElevatedButton(
                onPressed: _selectStartDate,
                child: Text(
                    startDate != null ? DateFormat("dd MMM yyyy").format(startDate!) : "Select"),
              ),
              const SizedBox(width: 16),
              const Text("End Date:"),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _selectEndDate,
                child:
                Text(endDate != null ? DateFormat("dd MMM yyyy").format(endDate!) : "Select"),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => fetchAnalytics(filtered: true),
                child: const Text("Apply Filters"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: clearFilters,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade400),
                child: const Text("Clear Filters"),
              ),
              const SizedBox(width: 20),
              const Text("Media Item:"),
              const SizedBox(width: 8),
              Expanded(
                child: CustomDropdown<String>.search(
                  hintText: "Select Media Item...",
                  items: ["All Media"] +
                      allMediaList.map((e) => e['title'] as String? ?? "").toList(),
                  controller: mediaController,
                  onChanged: (selectedTitle) {
                    if (selectedTitle == "All Media") {
                      setState(() => selectedMediaItem = null);
                    } else {
                      final selected = allMediaList.firstWhere(
                              (e) => e['title'] == selectedTitle,
                          orElse: () => {});
                      setState(() => selectedMediaItem = selected);
                    }
                    fetchAnalytics(filtered: true);
                  },
                  decoration: CustomDropdownDecoration(
                    closedBorder: Border.all(color: Colors.blueAccent),
                    closedBorderRadius: BorderRadius.circular(12),
                  ),
                  searchHintText: "Type to search media...",
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chart
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            shadowColor: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("📅 Monthly Device Usage Overview",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 350,
                    child: SfCartesianChart(
                      primaryXAxis: const CategoryAxis(
                        title: AxisTitle(text: 'Month'),
                        labelRotation: -45,
                        majorGridLines: MajorGridLines(width: 0),
                      ),
                      primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Plays')),
                      legend: const Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                      ),
                      tooltipBehavior: _tooltipBehavior,
                      series: <CartesianSeries>[
                        _buildStackedSeries(chartData, 'ios', 'iOS', Colors.amber),
                        _buildStackedSeries(chartData, 'android', 'Android', Colors.blue),
                        _buildStackedSeries(chartData, 'webApp', 'Web App', Colors.green),
                        _buildStackedSeries(chartData, 'appleTv', 'Apple TV', Colors.purple),
                        _buildStackedSeries(chartData, 'roku', 'Roku', Colors.orange),
                        _buildStackedSeries(chartData, 'webEmbed', 'Web Embed', Colors.teal),
                        _buildStackedSeries(chartData, 'other', 'Other', Colors.grey),
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
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
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
                        Text(item['title'] ?? "",
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        if (item['date'] != null)
                          Text(
                            DateFormat("dd MMM yyyy").format(
                                DateTime.tryParse(item['date']) ?? DateTime.now()),
                            style:
                            const TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  Expanded(flex: 2, child: Text(item['plays'].toString())),
                  Expanded(flex: 2, child: Text(item['uniqueViewers'].toString())),
                  Expanded(flex: 3, child: Text(item['avgDuration'].toString())),
                  Expanded(flex: 3, child: Text(item['totalPlayTime'].toString())),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  StackedColumnSeries<Map<String, dynamic>, String> _buildStackedSeries(
      List<Map<String, dynamic>> data, String key, String name, Color color) {
    final filteredData = data
        .where((d) => d[key] != null && d[key] > 0) // only >0
        .toList();

    return StackedColumnSeries<Map<String, dynamic>, String>(
      dataSource: filteredData,
      xValueMapper: (d, _) => d['month'] as String,
      yValueMapper: (d, _) => d[key] as int,
      name: name,
      color: color,
      width: 0.03, // thinner bars
      dataLabelSettings: const DataLabelSettings(isVisible: false),
    );
  }
}
