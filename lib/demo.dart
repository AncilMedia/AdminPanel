// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// //
// // class LibraryDetails extends StatefulWidget {
// //   const LibraryDetails({super.key});
// //
// //   @override
// //   State<LibraryDetails> createState() => _LibraryDetailsState();
// // }
// //
// // class _LibraryDetailsState extends State<LibraryDetails> {
// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.grey[200],
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.all(size.width * 0.05),
// //         child: Center(
// //           child: Container(
// //             width: size.width * 0.8,
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(12),
// //               color: Colors.white,
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black12,
// //                   blurRadius: 6,
// //                   offset: Offset(0, 2),
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   "Basic Details",
// //                   style: GoogleFonts.poppins(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //
// //                 // Title
// //                 Text(
// //                   "Title",
// //                   style: GoogleFonts.poppins(
// //                     fontSize: 14,
// //                     color: Colors.grey[700],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 6),
// //                 TextFormField(
// //                   decoration: const InputDecoration(
// //                     border: OutlineInputBorder(),
// //                     hintText: "Enter title",
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //
// //                 // Row with two fields
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             "Author",
// //                             style: GoogleFonts.poppins(
// //                               fontSize: 14,
// //                               color: Colors.grey[700],
// //                             ),
// //                           ),
// //                           const SizedBox(height: 6),
// //                           TextFormField(
// //                             decoration: const InputDecoration(
// //                               border: OutlineInputBorder(),
// //                               hintText: "Enter author",
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             "Date",
// //                             style: GoogleFonts.poppins(
// //                               fontSize: 14,
// //                               color: Colors.grey[700],
// //                             ),
// //                           ),
// //                           const SizedBox(height: 6),
// //                           TextFormField(
// //                             decoration: const InputDecoration(
// //                               border: OutlineInputBorder(),
// //                               hintText: "Select date",
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// class LibraryDetails extends StatefulWidget {
//   const LibraryDetails({super.key});
//
//   @override
//   State<LibraryDetails> createState() => _LibraryDetailsState();
// }
//
// class _LibraryDetailsState extends State<LibraryDetails> {
//   final TextEditingController _dateController = TextEditingController();
//   final TextEditingController mediaitemid = TextEditingController();
//
//   // Example data for chart
//   final List<_ChartData> chartData = [
//     _ChartData("Mon", 5),
//     _ChartData("Tue", 8),
//     _ChartData("Wed", 6),
//     _ChartData("Thu", 10),
//     _ChartData("Fri", 7),
//   ];
//
//   // Speakers, Scripture, Topics
//   final List<String> speakers = ["Speaker 1", "Speaker 2", "Speaker 3", "Speaker 4"];
//   final List<String> scriptures = ["Scripture 1", "Scripture 2", "Scripture 3"];
//   final List<String> topics = ["Topic 1", "Topic 2", "Topic 3", "Topic 4"];
//
//   List<String> selectedSpeakers = [];
//   String? selectedScripture;
//   List<String> selectedTopics = [];
//
//   // Tooltip behavior for chart
//   late TooltipBehavior _tooltipBehavior;
//
//   @override
//   void initState() {
//     super.initState();
//     _tooltipBehavior = TooltipBehavior(
//       enable: true,
//       color: Colors.blueAccent.withOpacity(0.9),
//       textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//       format: 'point.x : point.y views',
//     );
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Column(
//         children: [
//           // 🔹 Chart + Stats Section
//           Container(
//             width: size.width * 0.84,
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: const [
//                 BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
//               ],
//             ),
//             child: Column(
//               children: [
//                 // Chart
//                 SizedBox(
//                   height: size.height * 0.25,
//                   child: SfCartesianChart(
//                     title: ChartTitle(text: 'Analytics'),
//                     primaryXAxis: CategoryAxis(),
//                     primaryYAxis: NumericAxis(),
//                     tooltipBehavior: _tooltipBehavior,
//                     legend: const Legend(isVisible: false),
//                     series: <CartesianSeries<_ChartData, String>>[
//                       ColumnSeries<_ChartData, String>(
//                         dataSource: chartData,
//                         xValueMapper: (data, _) => data.day,
//                         yValueMapper: (data, _) => data.views,
//                         color: Colors.blueAccent,
//                         borderRadius: BorderRadius.circular(6),
//                         dataLabelSettings: const DataLabelSettings(isVisible: true),
//                         enableTooltip: true,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//
//                 // Stats Row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Media Item id: ${mediaitemid.text}',
//                       style: const TextStyle(color: Colors.black54, fontSize: 12),
//                     ),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.black26),
//                         ),
//                         child: Row(
//                           children: const [
//                             Icon(Icons.remove_red_eye, color: Colors.black54),
//                             SizedBox(width: 8),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('0', style: TextStyle(fontWeight: FontWeight.bold)),
//                                 Text('All time plays',
//                                     style: TextStyle(color: Colors.black54, fontSize: 12)),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.black26),
//                         ),
//                         child: Row(
//                           children: const [
//                             Icon(Icons.bar_chart, color: Colors.black54),
//                             SizedBox(width: 8),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('0 on Sep 28, 2025',
//                                     style: TextStyle(fontWeight: FontWeight.bold)),
//                                 Text('Peak traffic plays',
//                                     style: TextStyle(color: Colors.black54, fontSize: 12)),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           SizedBox(height: size.height * 0.02),
//
//           // 🔹 Form Section
//           Expanded(
//             child: Center(
//               child: SingleChildScrollView(
//                 child: Container(
//                   width: size.width * 0.85,
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.white,
//                     boxShadow: const [
//                       BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       /// Basic Details
//                       Text("Basic Details",
//                           style: GoogleFonts.poppins(
//                               fontSize: 16, fontWeight: FontWeight.w600)),
//                       const SizedBox(height: 16),
//                       _buildLabel("Title"),
//                       const SizedBox(height: 6),
//                       _buildInputField(hint: "Enter title"),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 _buildLabel("Author"),
//                                 const SizedBox(height: 6),
//                                 _buildInputField(hint: "Enter author"),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 _buildLabel("Date"),
//                                 const SizedBox(height: 6),
//                                 TextFormField(
//                                   controller: _dateController,
//                                   readOnly: true,
//                                   onTap: () => _selectDate(context),
//                                   decoration: InputDecoration(
//                                     suffixIcon: const Icon(Iconsax.calendar_1),
//                                     hintText: "Select date",
//                                     filled: true,
//                                     fillColor: Colors.black12,
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(6),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(color: Colors.black12),
//                                       borderRadius: BorderRadius.circular(6),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(color: Colors.blueAccent),
//                                       borderRadius: BorderRadius.circular(6),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       _buildLabel("Description"),
//                       const SizedBox(height: 6),
//                       _buildInputField(hint: "Enter description", maxLines: 4),
//                       const SizedBox(height: 24),
//
//                       /// Tags
//                       Text("Tags",
//                           style: GoogleFonts.poppins(
//                               fontSize: 16, fontWeight: FontWeight.w600)),
//                       const SizedBox(height: 14),
//                       MultiSelectDropdown(
//                         title: "Speakers",
//                         items: speakers,
//                         selectedItems: selectedSpeakers,
//                         onSelectionChanged: (selected) {
//                           setState(() {
//                             selectedSpeakers = selected;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       DropdownButtonFormField<String>(
//                         value: selectedScripture,
//                         decoration: InputDecoration(
//                           hintText: "Select Scripture",
//                           filled: true,
//                           fillColor: Colors.black12,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(6),
//                             borderSide: const BorderSide(color: Colors.black12),
//                           ),
//                         ),
//                         items: scriptures
//                             .map((s) => DropdownMenuItem(value: s, child: Text(s)))
//                             .toList(),
//                         onChanged: (val) {
//                           setState(() {
//                             selectedScripture = val;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       MultiSelectDropdown(
//                         title: "Topics",
//                         items: topics,
//                         selectedItems: selectedTopics,
//                         onSelectionChanged: (selected) {
//                           setState(() {
//                             selectedTopics = selected;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 32),
//
//                       /// Video
//                       Text("Video",
//                           style: GoogleFonts.poppins(
//                               fontSize: 16, fontWeight: FontWeight.w600)),
//                       const SizedBox(height: 14),
//                       Container(
//                         height: size.height * 0.2,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           border: Border.all(color: Colors.black12),
//                         ),
//                       ),
//                       const SizedBox(height: 14),
//
//                       /// Audio
//                       Text("Audio",
//                           style: GoogleFonts.poppins(
//                               fontSize: 16, fontWeight: FontWeight.w600)),
//                       const SizedBox(height: 14),
//                       Container(
//                         height: size.height * 0.1,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           border: Border.all(color: Colors.black12),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLabel(String text) =>
//       Text(text, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]));
//
//   Widget _buildInputField({String? hint, int maxLines = 1}) => TextFormField(
//     maxLines: maxLines,
//     decoration: InputDecoration(
//       hintText: hint,
//       filled: true,
//       fillColor: Colors.black12,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
//       enabledBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.black12),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.blueAccent),
//         borderRadius: BorderRadius.circular(6),
//       ),
//     ),
//   );
// }
//
// /// Chart Data Model
// class _ChartData {
//   final String day;
//   final double views;
//   _ChartData(this.day, this.views);
// }
//
// /// ---------------------------
// /// Reusable MultiSelect Dropdown Widget
// /// ---------------------------
// class MultiSelectDropdown extends StatefulWidget {
//   final String title;
//   final List<String> items;
//   final List<String> selectedItems;
//   final Function(List<String>) onSelectionChanged;
//
//   const MultiSelectDropdown({
//     super.key,
//     required this.title,
//     required this.items,
//     required this.selectedItems,
//     required this.onSelectionChanged,
//   });
//
//   @override
//   State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
// }
//
// class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
//   late List<String> tempSelected;
//
//   @override
//   void initState() {
//     super.initState();
//     tempSelected = List.from(widget.selectedItems);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(widget.title, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
//         const SizedBox(height: 6),
//         InkWell(
//           onTap: () async {
//             final List<String>? results = await showDialog(
//               context: context,
//               builder: (_) => AlertDialog(
//                 title: Text("Select ${widget.title}"),
//                 content: SizedBox(
//                   width: double.maxFinite,
//                   child: ListView(
//                     children: widget.items.map((item) {
//                       final isSelected = tempSelected.contains(item);
//                       return CheckboxListTile(
//                         title: Text(item),
//                         value: isSelected,
//                         onChanged: (val) {
//                           setState(() {
//                             if (val == true) {
//                               tempSelected.add(item);
//                             } else {
//                               tempSelected.remove(item);
//                             }
//                           });
//                         },
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context, null),
//                     child: const Text('Cancel'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () => Navigator.pop(context, tempSelected),
//                     child: const Text('OK'),
//                   ),
//                 ],
//               ),
//             );
//             if (results != null) {
//               setState(() {
//                 tempSelected = results;
//               });
//               widget.onSelectionChanged(tempSelected);
//             }
//           },
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(6),
//               border: Border.all(color: Colors.black12),
//               color: Colors.black12,
//             ),
//             child: Text(
//               widget.selectedItems.isEmpty
//                   ? 'Select ${widget.title}'
//                   : widget.selectedItems.join(', '),
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
