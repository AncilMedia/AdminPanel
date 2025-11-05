// //
// // import 'package:flutter/material.dart';
// // // import 'dart:convert';
// // // import 'package:flutter/services.dart' show rootBundle;
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:animated_custom_dropdown/custom_dropdown.dart';
// // //
// // // /// 📖 ScriptureSelector dialog
// // // class ScriptureSelector extends StatefulWidget {
// // //   const ScriptureSelector({super.key});
// // //
// // //   @override
// // //   State<ScriptureSelector> createState() => _ScriptureSelectorState();
// // // }
// // //
// // // class _ScriptureSelectorState extends State<ScriptureSelector> {
// // //   List<dynamic> bibleBooks = [];
// // //   dynamic selectedBook;
// // //   int? selectedChapter;
// // //   int? startVerse;
// // //   int? endVerse;
// // //
// // //   /// ✅ Use SingleSelectController instead of TextEditingController
// // //   final SingleSelectController<String> _bookController =
// // //   SingleSelectController<String>(null);
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadBibleData();
// // //   }
// // //
// // //   Future<void> _loadBibleData() async {
// // //     final data = await rootBundle.loadString('assets/bible.json');
// // //     setState(() => bibleBooks = json.decode(data));
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final chapters = selectedBook != null
// // //         ? (selectedBook['chapters'] as List)
// // //         .map<int>((c) => int.parse(c['chapter']))
// // //         .toList()
// // //         : [];
// // //
// // //     final int verseCount = selectedBook != null && selectedChapter != null
// // //         ? int.parse(
// // //       (selectedBook['chapters'] as List)
// // //           .firstWhere((c) => int.parse(c['chapter']) == selectedChapter)['verses']
// // //           .toString(),
// // //     )
// // //         : 0;
// // //
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text("Select Scripture"),
// // //         automaticallyImplyLeading: false,
// // //       ),
// // //       body: bibleBooks.isEmpty
// // //           ? const Center(child: CircularProgressIndicator())
// // //           : Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: SingleChildScrollView(
// // //           child:
// // //           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// // //             /// ✅ Searchable dropdown for book selection
// // //             CustomDropdown<String>.search(
// // //               hintText: 'Select Book',
// // //               controller: _bookController,
// // //               items: bibleBooks.map((b) => b['book'].toString()).toList(),
// // //               decoration: CustomDropdownDecoration(
// // //                 closedBorder: Border.all(color: Colors.black12),
// // //                 expandedBorder: Border.all(color: Colors.blueAccent),
// // //                 closedFillColor: Colors.white,
// // //                 expandedFillColor: Colors.white,
// // //               ),
// // //               onChanged: (value) {
// // //                 final book =
// // //                 bibleBooks.firstWhere((b) => b['book'] == value);
// // //                 setState(() {
// // //                   selectedBook = book;
// // //                   selectedChapter = null;
// // //                   startVerse = null;
// // //                   endVerse = null;
// // //                 });
// // //               },
// // //             ),
// // //
// // //             const SizedBox(height: 16),
// // //
// // //             /// ✅ Chapter Heading + Compact Grid
// // //             if (selectedBook != null) ...[
// // //               Text(
// // //                 "Select Chapter",
// // //                 style: GoogleFonts.poppins(
// // //                   fontWeight: FontWeight.w600,
// // //                   fontSize: 16,
// // //                   color: Colors.black87,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 8),
// // //               Wrap(
// // //                 spacing: 6,
// // //                 runSpacing: 6,
// // //                 children: chapters
// // //                     .map((ch) => GestureDetector(
// // //                   onTap: () => setState(() {
// // //                     selectedChapter = ch;
// // //                     startVerse = null;
// // //                     endVerse = null;
// // //                   }),
// // //                   child: Container(
// // //                     width: 32,
// // //                     height: 32,
// // //                     alignment: Alignment.center,
// // //                     decoration: BoxDecoration(
// // //                       color: selectedChapter == ch
// // //                           ? Colors.blueAccent
// // //                           : Colors.grey.shade200,
// // //                       borderRadius: BorderRadius.circular(6),
// // //                     ),
// // //                     child: Text(
// // //                       ch.toString(),
// // //                       style: GoogleFonts.poppins(
// // //                         fontSize: 13,
// // //                         fontWeight: FontWeight.w500,
// // //                         color: selectedChapter == ch
// // //                             ? Colors.white
// // //                             : Colors.black,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ))
// // //                     .toList(),
// // //               ),
// // //             ],
// // //
// // //             const SizedBox(height: 24),
// // //
// // //             /// ✅ Verse Heading + Compact Grid
// // //             if (selectedChapter != null) ...[
// // //               Text(
// // //                 "Select Verse(s)",
// // //                 style: GoogleFonts.poppins(
// // //                   fontWeight: FontWeight.w600,
// // //                   fontSize: 16,
// // //                   color: Colors.black87,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 8),
// // //               Wrap(
// // //                 spacing: 5,
// // //                 runSpacing: 5,
// // //                 children: List.generate(verseCount, (i) {
// // //                   final v = i + 1;
// // //                   final isSelected = startVerse != null &&
// // //                       endVerse != null &&
// // //                       v >= startVerse! &&
// // //                       v <= endVerse!;
// // //                   return GestureDetector(
// // //                     onTap: () {
// // //                       setState(() {
// // //                         if (startVerse == null) {
// // //                           startVerse = v;
// // //                           endVerse = v;
// // //                         } else if (endVerse == startVerse) {
// // //                           if (v > startVerse!) {
// // //                             endVerse = v;
// // //                           } else {
// // //                             endVerse = startVerse;
// // //                             startVerse = v;
// // //                           }
// // //                         } else {
// // //                           startVerse = v;
// // //                           endVerse = v;
// // //                         }
// // //                       });
// // //                     },
// // //                     child: Container(
// // //                       width: 28,
// // //                       height: 28,
// // //                       alignment: Alignment.center,
// // //                       decoration: BoxDecoration(
// // //                         color: isSelected
// // //                             ? Colors.blueAccent
// // //                             : Colors.grey.shade200,
// // //                         borderRadius: BorderRadius.circular(5),
// // //                       ),
// // //                       child: Text(
// // //                         v.toString(),
// // //                         style: GoogleFonts.poppins(
// // //                           fontSize: 12,
// // //                           fontWeight: FontWeight.w500,
// // //                           color: isSelected
// // //                               ? Colors.white
// // //                               : Colors.black,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   );
// // //                 }),
// // //               ),
// // //             ],
// // //
// // //             const SizedBox(height: 24),
// // //
// // //             /// ✅ Display selected scripture & Done button
// // //             if (startVerse != null)
// // //               Column(
// // //                 children: [
// // //                   Text(
// // //                     startVerse == endVerse
// // //                         ? "${selectedBook['book']} $selectedChapter:$startVerse"
// // //                         : "${selectedBook['book']} $selectedChapter:$startVerse-$endVerse",
// // //                     style: GoogleFonts.poppins(
// // //                       fontWeight: FontWeight.bold,
// // //                       fontSize: 18,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 16),
// // //                   Center(
// // //                     child: GestureDetector(
// // //                       onTap: () {
// // //                         final result = startVerse == endVerse
// // //                             ? "${selectedBook['book']} $selectedChapter:$startVerse"
// // //                             : "${selectedBook['book']} $selectedChapter:$startVerse-$endVerse";
// // //                         Navigator.pop(context, result);
// // //                       },
// // //                       child: Container(
// // //                         height: MediaQuery.of(context).size.height * .05,
// // //                         width: MediaQuery.of(context).size.width * .08,
// // //                         decoration: BoxDecoration(
// // //                           borderRadius: BorderRadius.circular(10),
// // //                           color: Colors.cyan,
// // //                         ),
// // //                         child: Center(
// // //                           child: Text(
// // //                             "Done",
// // //                             style: GoogleFonts.poppins(
// // //                               fontWeight: FontWeight.w500,
// // //                               fontSize: 16,
// // //                               color: Colors.white,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   )
// // //                 ],
// // //               )
// // //           ]),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// // import 'package:flutter/material.dart';
// // import 'dart:convert';
// // import 'package:flutter/services.dart' show rootBundle;
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:animated_custom_dropdown/custom_dropdown.dart';
// //
// // /// 📖 ScriptureSelector dialog (supports multi-select books + chapters)
// // class ScriptureSelector extends StatefulWidget {
// //   final bool isMultiSelect;
// //   const ScriptureSelector({super.key, this.isMultiSelect = true});
// //
// //   @override
// //   State<ScriptureSelector> createState() => _ScriptureSelectorState();
// // }
// //
// // class _ScriptureSelectorState extends State<ScriptureSelector> {
// //   List<dynamic> bibleBooks = [];
// //   dynamic selectedBook;
// //
// //   /// ✅ Use SingleSelectController for dropdown
// //   final SingleSelectController<String> _bookController =
// //   SingleSelectController<String>(null);
// //
// //   /// ✅ Store multiple selections
// //   final List<Map<String, dynamic>> selectedScriptures = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadBibleData();
// //   }
// //
// //   Future<void> _loadBibleData() async {
// //     final data = await rootBundle.loadString('assets/bible.json');
// //     setState(() => bibleBooks = json.decode(data));
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final chapters = selectedBook != null
// //         ? (selectedBook['chapters'] as List)
// //         .map<int>((c) => int.parse(c['chapter']))
// //         .toList()
// //         : [];
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Select Scriptures"),
// //         backgroundColor: Colors.blueAccent,
// //         automaticallyImplyLeading: false,
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context, selectedScriptures),
// //             child: const Text("DONE", style: TextStyle(color: Colors.white)),
// //           ),
// //         ],
// //       ),
// //       body: bibleBooks.isEmpty
// //           ? const Center(child: CircularProgressIndicator())
// //           : Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: SingleChildScrollView(
// //           child:
// //           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //             /// ✅ Dropdown for book selection
// //             CustomDropdown<String>.search(
// //               hintText: 'Select Book',
// //               controller: _bookController,
// //               items: bibleBooks.map((b) => b['book'].toString()).toList(),
// //               decoration: CustomDropdownDecoration(
// //                 closedBorder: Border.all(color: Colors.black12),
// //                 expandedBorder: Border.all(color: Colors.blueAccent),
// //                 closedFillColor: Colors.white,
// //                 expandedFillColor: Colors.white,
// //               ),
// //               onChanged: (value) {
// //                 final book =
// //                 bibleBooks.firstWhere((b) => b['book'] == value);
// //                 setState(() => selectedBook = book);
// //               },
// //             ),
// //
// //             const SizedBox(height: 16),
// //
// //             /// ✅ Chapter grid for current book
// //             if (selectedBook != null) ...[
// //               Text(
// //                 "Select Chapters (${selectedBook['book']})",
// //                 style: GoogleFonts.poppins(
// //                   fontWeight: FontWeight.w600,
// //                   fontSize: 16,
// //                   color: Colors.black87,
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               Wrap(
// //                 spacing: 6,
// //                 runSpacing: 6,
// //                 children: chapters
// //                     .map((ch) => GestureDetector(
// //                   onTap: () {
// //                     final ref = {
// //                       '_id':
// //                       "${selectedBook['book']}_$ch", // pseudo ID
// //                       'book': selectedBook['book'],
// //                       'chapter': ch,
// //                     };
// //
// //                     setState(() {
// //                       final already = selectedScriptures.any(
// //                               (e) => e['_id'] == ref['_id']);
// //                       if (already) {
// //                         selectedScriptures.removeWhere(
// //                                 (e) => e['_id'] == ref['_id']);
// //                       } else {
// //                         selectedScriptures.add(ref);
// //                       }
// //                     });
// //                   },
// //                   child: Container(
// //                     width: 36,
// //                     height: 36,
// //                     alignment: Alignment.center,
// //                     decoration: BoxDecoration(
// //                       color: selectedScriptures.any((e) =>
// //                       e['_id'] ==
// //                           "${selectedBook['book']}_$ch")
// //                           ? Colors.blueAccent
// //                           : Colors.grey.shade200,
// //                       borderRadius: BorderRadius.circular(6),
// //                     ),
// //                     child: Text(
// //                       ch.toString(),
// //                       style: GoogleFonts.poppins(
// //                         fontSize: 13,
// //                         fontWeight: FontWeight.w500,
// //                         color: selectedScriptures.any((e) =>
// //                         e['_id'] ==
// //                             "${selectedBook['book']}_$ch")
// //                             ? Colors.white
// //                             : Colors.black,
// //                       ),
// //                     ),
// //                   ),
// //                 ))
// //                     .toList(),
// //               ),
// //             ],
// //
// //             const SizedBox(height: 24),
// //
// //             /// ✅ Selected scriptures summary
// //             if (selectedScriptures.isNotEmpty) ...[
// //               Text(
// //                 "Selected Scriptures:",
// //                 style: GoogleFonts.poppins(
// //                   fontWeight: FontWeight.w600,
// //                   fontSize: 16,
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               Wrap(
// //                 spacing: 6,
// //                 runSpacing: 6,
// //                 children: selectedScriptures
// //                     .map((s) => Chip(
// //                   label: Text(
// //                     "${s['book']} ${s['chapter']}",
// //                     style: GoogleFonts.poppins(fontSize: 13),
// //                   ),
// //                   deleteIcon: const Icon(Icons.close, size: 16),
// //                   onDeleted: () {
// //                     setState(() {
// //                       selectedScriptures.removeWhere(
// //                               (e) => e['_id'] == s['_id']);
// //                     });
// //                   },
// //                 ))
// //                     .toList(),
// //               ),
// //               const SizedBox(height: 16),
// //               Center(
// //                 child: ElevatedButton(
// //                   onPressed: () =>
// //                       Navigator.pop(context, selectedScriptures),
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.cyan,
// //                     padding: const EdgeInsets.symmetric(
// //                         horizontal: 24, vertical: 12),
// //                     shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(10)),
// //                   ),
// //                   child: const Text(
// //                     "Done",
// //                     style: TextStyle(fontSize: 16, color: Colors.white),
// //                   ),
// //                 ),
// //               )
// //             ],
// //           ]),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:google_fonts/google_fonts.dart';
// import 'package:animated_custom_dropdown/custom_dropdown.dart';
//
// /// 📖 ScriptureSelector
// /// Supports multiple chapters + optional verse ranges per chapter
// class ScriptureSelector extends StatefulWidget {
//   final bool isMultiSelect;
//   const ScriptureSelector({super.key, this.isMultiSelect = true});
//
//   @override
//   State<ScriptureSelector> createState() => _ScriptureSelectorState();
// }
//
// class _ScriptureSelectorState extends State<ScriptureSelector> {
//   List<dynamic> bibleBooks = [];
//   dynamic selectedBook;
//   int? selectedChapter;
//   int? startVerse;
//   int? endVerse;
//
//   final SingleSelectController<String> _bookController =
//   SingleSelectController<String>(null);
//
//   /// ✅ Stores scriptures in format:
//   /// {book: 'John', chapter: 3, start: 16, end: 18}
//   final List<Map<String, dynamic>> selectedScriptures = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadBibleData();
//   }
//
//   Future<void> _loadBibleData() async {
//     final data = await rootBundle.loadString('assets/bible.json');
//     setState(() => bibleBooks = json.decode(data));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final chapters = selectedBook != null
//         ? (selectedBook['chapters'] as List)
//         .map<int>((c) => int.parse(c['chapter']))
//         .toList()
//         : [];
//
//     final int verseCount = selectedBook != null && selectedChapter != null
//         ? int.parse(
//       (selectedBook['chapters'] as List)
//           .firstWhere(
//               (c) => int.parse(c['chapter']) == selectedChapter)['verses']
//           .toString(),
//     )
//         : 0;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Select Scriptures"),
//         backgroundColor: Colors.blueAccent,
//         automaticallyImplyLeading: false,
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, selectedScriptures),
//             child: const Text("DONE", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//       body: bibleBooks.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child:
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             /// ✅ Book dropdown (compact height)
//             SizedBox(
//               height: 46,
//               child: CustomDropdown<String>.search(
//                 hintText: 'Select Book',
//                 controller: _bookController,
//                 items: bibleBooks.map((b) => b['book'].toString()).toList(),
//                 decoration: CustomDropdownDecoration(
//                   closedBorder: Border.all(color: Colors.black12),
//                   expandedBorder: Border.all(color: Colors.blueAccent),
//                   closedFillColor: Colors.white,
//                   expandedFillColor: Colors.white,
//                   closedBorderRadius: BorderRadius.circular(8),
//                 ),
//                 onChanged: (value) {
//                   final book =
//                   bibleBooks.firstWhere((b) => b['book'] == value);
//                   setState(() {
//                     selectedBook = book;
//                     selectedChapter = null;
//                     startVerse = null;
//                     endVerse = null;
//                   });
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             /// ✅ Select Chapter
//             if (selectedBook != null) ...[
//               Text(
//                 "Select Chapter (${selectedBook['book']})",
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Wrap(
//                 spacing: 6,
//                 runSpacing: 6,
//                 children: chapters
//                     .map((ch) => GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedChapter = ch;
//                       startVerse = null;
//                       endVerse = null;
//                     });
//                   },
//                   child: Container(
//                     width: 36,
//                     height: 36,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: selectedChapter == ch
//                           ? Colors.blueAccent
//                           : Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: Text(
//                       ch.toString(),
//                       style: GoogleFonts.poppins(
//                         fontSize: 13,
//                         color: selectedChapter == ch
//                             ? Colors.white
//                             : Colors.black,
//                       ),
//                     ),
//                   ),
//                 ))
//                     .toList(),
//               ),
//             ],
//
//             const SizedBox(height: 20),
//
//             /// ✅ Verse Selector (optional)
//             if (selectedChapter != null) ...[
//               Text(
//                 "Select Verses (optional)",
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 height: 180,
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.black12),
//                 ),
//                 child: SingleChildScrollView(
//                   child: Wrap(
//                     spacing: 5,
//                     runSpacing: 5,
//                     children: List.generate(verseCount, (i) {
//                       final v = i + 1;
//                       final isSelected = startVerse != null &&
//                           endVerse != null &&
//                           v >= startVerse! &&
//                           v <= endVerse!;
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             if (startVerse == null) {
//                               startVerse = v;
//                               endVerse = v;
//                             } else if (endVerse == startVerse) {
//                               if (v > startVerse!) {
//                                 endVerse = v;
//                               } else {
//                                 endVerse = startVerse;
//                                 startVerse = v;
//                               }
//                             } else {
//                               startVerse = v;
//                               endVerse = v;
//                             }
//                           });
//                         },
//                         child: Container(
//                           width: 30,
//                           height: 30,
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? Colors.blueAccent
//                                 : Colors.grey.shade200,
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Text(
//                             v.toString(),
//                             style: GoogleFonts.poppins(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: isSelected
//                                   ? Colors.white
//                                   : Colors.black,
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     final existing = selectedScriptures.any((e) =>
//                     e['book'] == selectedBook['book'] &&
//                         e['chapter'] == selectedChapter);
//
//                     if (existing) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                               "${selectedBook['book']} $selectedChapter already added."),
//                         ),
//                       );
//                       return;
//                     }
//
//                     final newItem = {
//                       'book': selectedBook['book'],
//                       'chapter': selectedChapter,
//                       'start': startVerse,
//                       'end': endVerse,
//                     };
//
//                     setState(() {
//                       selectedScriptures.add(newItem);
//                       selectedChapter = null;
//                       startVerse = null;
//                       endVerse = null;
//                     });
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.cyan,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 24, vertical: 10),
//                   ),
//                   child: const Text("Add Scripture",
//                       style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//             ],
//
//             const SizedBox(height: 24),
//
//             /// ✅ Selected scriptures summary
//             if (selectedScriptures.isNotEmpty) ...[
//               Text(
//                 "Selected Scriptures:",
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Wrap(
//                 spacing: 6,
//                 runSpacing: 6,
//                 children: selectedScriptures.map((s) {
//                   final ref = s['start'] != null
//                       ? "${s['book']} ${s['chapter']}:${s['start']}"
//                       "${s['end'] != null && s['end'] != s['start'] ? "-${s['end']}" : ""}"
//                       : "${s['book']} ${s['chapter']}";
//                   return Chip(
//                     label: Text(ref,
//                         style: GoogleFonts.poppins(fontSize: 13)),
//                     deleteIcon: const Icon(Icons.close, size: 16),
//                     onDeleted: () {
//                       setState(() => selectedScriptures.remove(s));
//                     },
//                   );
//                 }).toList(),
//               ),
//             ],
//           ]),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

/// 📖 ScriptureSelector
/// Supports multiple chapters + optional verse ranges per chapter
class ScriptureSelector extends StatefulWidget {
  final bool isMultiSelect;
  const ScriptureSelector({super.key, this.isMultiSelect = true});

  @override
  State<ScriptureSelector> createState() => _ScriptureSelectorState();
}

class _ScriptureSelectorState extends State<ScriptureSelector> {
  List<dynamic> bibleBooks = [];
  dynamic selectedBook;
  int? selectedChapter;
  int? startVerse;
  int? endVerse;

  final SingleSelectController<String> _bookController =
  SingleSelectController<String>(null);

  /// ✅ Stores scriptures in format:
  /// {book: 'John', chapter: 3, start: 16, end: 18}
  final List<Map<String, dynamic>> selectedScriptures = [];

  @override
  void initState() {
    super.initState();
    _loadBibleData();
  }

  Future<void> _loadBibleData() async {
    final data = await rootBundle.loadString('assets/bible.json');
    setState(() => bibleBooks = json.decode(data));
  }

  @override
  Widget build(BuildContext context) {
    final chapters = selectedBook != null
        ? (selectedBook['chapters'] as List)
        .map<int>((c) => int.parse(c['chapter']))
        .toList()
        : [];

    final int verseCount = selectedBook != null && selectedChapter != null
        ? int.tryParse(
        (selectedBook['chapters'] as List)
            .firstWhere(
                (c) =>
            int.parse(c['chapter']) == selectedChapter,
            orElse: () => {'verses': 0})['verses']
            .toString()) ??
        0
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Scriptures"),
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, selectedScriptures),
            child: const Text("DONE", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: bibleBooks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ✅ Book dropdown (compact height)
                SizedBox(
                  height: 46,
                  child: CustomDropdown<String>.search(
                    hintText: 'Select Book',
                    controller: _bookController,
                    items: bibleBooks
                        .map((b) => b['book'].toString())
                        .toList(),
                    decoration: CustomDropdownDecoration(
                      closedBorder: Border.all(color: Colors.black12),
                      expandedBorder:
                      Border.all(color: Colors.blueAccent),
                      closedFillColor: Colors.white,
                      expandedFillColor: Colors.white,
                      closedBorderRadius: BorderRadius.circular(8),
                    ),
                    onChanged: (value) {
                      final book = bibleBooks.firstWhere(
                              (b) => b['book'] == value,
                          orElse: () => {});
                      setState(() {
                        selectedBook = book.isNotEmpty ? book : null;
                        selectedChapter = null;
                        startVerse = null;
                        endVerse = null;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),

                /// ✅ Select Chapter
                if (selectedBook != null) ...[
                  Text(
                    "Select Chapter (${selectedBook['book']})",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: chapters
                        .map((ch) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedChapter = ch;
                          startVerse = null;
                          endVerse = null;
                        });
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selectedChapter == ch
                              ? Colors.blueAccent
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          ch.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: selectedChapter == ch
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                ],

                const SizedBox(height: 20),

                /// ✅ Verse Selector (optional)
                if (selectedChapter != null) ...[
                  Text(
                    "Select Verses (optional)",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 180,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: List.generate(verseCount, (i) {
                          final v = i + 1;
                          final isSelected = startVerse != null &&
                              endVerse != null &&
                              v >= startVerse! &&
                              v <= endVerse!;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (startVerse == null) {
                                  startVerse = v;
                                  endVerse = v;
                                } else if (endVerse == startVerse) {
                                  if (v > startVerse!) {
                                    endVerse = v;
                                  } else {
                                    endVerse = startVerse;
                                    startVerse = v;
                                  }
                                } else {
                                  startVerse = v;
                                  endVerse = v;
                                }
                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blueAccent
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                v.toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedBook == null ||
                            selectedChapter == null) return;

                        final existing = selectedScriptures.any((e) =>
                        e['book'] == selectedBook['book'] &&
                            e['chapter'] == selectedChapter);

                        if (existing) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "${selectedBook['book']} $selectedChapter already added."),
                            ),
                          );
                          return;
                        }

                        final newItem = {
                          'book': selectedBook['book'] ?? '',
                          'chapter': selectedChapter ?? 0,
                          'start': startVerse,
                          'end': endVerse,
                        };

                        setState(() {
                          selectedScriptures.add(newItem);
                          selectedChapter = null;
                          startVerse = null;
                          endVerse = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                      ),
                      child: const Text("Add Scripture",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                /// ✅ Selected scriptures summary
                if (selectedScriptures.isNotEmpty) ...[
                  Text(
                    "Selected Scriptures:",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: selectedScriptures.map((s) {
                      final book = s['book'] ?? '';
                      final chapter =
                          s['chapter']?.toString() ?? '';
                      final start = s['start']?.toString();
                      final end = s['end']?.toString();

                      String ref = "$book $chapter";
                      if (start != null && end != null) {
                        ref += ":$start${end != start ? '-$end' : ''}";
                      } else if (start != null) {
                        ref += ":$start";
                      }

                      return Chip(
                        label: Text(ref,
                            style: GoogleFonts.poppins(fontSize: 13)),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() =>
                              selectedScriptures.remove(s));
                        },
                      );
                    }).toList(),
                  ),
                ],
              ]),
        ),
      ),
    );
  }
}
