import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// class ScriptureSelector extends StatefulWidget {
//   const ScriptureSelector({super.key});
//
//   @override
//   State<ScriptureSelector> createState() => _ScriptureSelectorState();
// }
//
// class _ScriptureSelectorState extends State<ScriptureSelector> {
//   List<dynamic> bibleBooks = [];
//   dynamic selectedBook;
//   int? selectedChapter;
//   int? selectedStartVerse;
//   int? selectedEndVerse;
//   int? startVerse;
//   int? endVerse;
//
//   @override
//   void initState() {
//     super.initState();
//     loadBible();
//   }
//
//   Future<void> loadBible() async {
//     final data = await rootBundle.loadString('assets/bible.json');
//     setState(() {
//       bibleBooks = json.decode(data);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final chapters = selectedBook != null
//         ? (selectedBook['chapters'] as List)
//         .map<int>((c) => int.parse(c['chapter']))
//         .toList()
//         : <int>[];
//
//     // ✅ Find total verses for the selected chapter
//     final int verseCount = selectedBook != null && selectedChapter != null
//         ? int.parse(
//       (selectedBook['chapters'] as List)
//           .firstWhere(
//               (c) => int.parse(c['chapter']) == selectedChapter)['verses']
//           .toString(),
//     )
//         : 0;
//
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(title: const Text("Select Scripture")),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: bibleBooks.isEmpty
//               ? const Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 📖 Book selection
//                 DropdownButton<dynamic>(
//                   isExpanded: true,
//                   hint: const Text("Select Book"),
//                   value: selectedBook,
//                   items: bibleBooks
//                       .map((book) => DropdownMenuItem(
//                     value: book,
//                     child: Text(book['book']),
//                   ))
//                       .toList(),
//                   onChanged: (book) {
//                     setState(() {
//                       selectedBook = book;
//                       selectedChapter = null;
//                       selectedStartVerse = null;
//                       selectedEndVerse = null;
//                     });
//                   },
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // 📘 Chapter grid
//                 if (selectedBook != null)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("Select Chapter",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16)),
//                       const SizedBox(height: 12),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: chapters
//                             .map((chapter) => GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               selectedChapter = chapter;
//                               selectedStartVerse = null;
//                               selectedEndVerse = null;
//                             });
//                           },
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: selectedChapter == chapter
//                                   ? Colors.blueAccent
//                                   : Colors.grey.shade200,
//                               borderRadius:
//                               BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               chapter.toString(),
//                               style: TextStyle(
//                                 color:
//                                 selectedChapter == chapter
//                                     ? Colors.white
//                                     : Colors.black,
//                               ),
//                             ),
//                           ),
//                         ))
//                             .toList(),
//                       ),
//                     ],
//                   ),
//
//                 const SizedBox(height: 24),
//
//                 // 📜 Verse grid
//                 if (selectedChapter != null)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("Select Verses",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16)),
//                       const SizedBox(height: 12),
//                       Wrap(
//                         spacing: 6,
//                         runSpacing: 6,
//                         children: List.generate(verseCount, (i) {
//                           final verse = i + 1;
//                           final isSelected = selectedStartVerse != null &&
//                               selectedEndVerse != null &&
//                               verse >= selectedStartVerse! &&
//                               verse <= selectedEndVerse!;
//                           return GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 if (selectedStartVerse == null) {
//                                   selectedStartVerse = verse;
//                                   selectedEndVerse = verse;
//                                 } else if (selectedEndVerse ==
//                                     selectedStartVerse) {
//                                   // Second tap → select range
//                                   if (verse > selectedStartVerse!) {
//                                     selectedEndVerse = verse;
//                                   } else {
//                                     selectedEndVerse = selectedStartVerse;
//                                     selectedStartVerse = verse;
//                                   }
//                                 } else {
//                                   // Third tap → reset selection
//                                   selectedStartVerse = verse;
//                                   selectedEndVerse = verse;
//                                 }
//                               });
//                             },
//                             child: Container(
//                               width: 36,
//                               height: 36,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 color: isSelected
//                                     ? Colors.blueAccent
//                                     : Colors.grey.shade200,
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Text(
//                                 verse.toString(),
//                                 style: TextStyle(
//                                   color: isSelected
//                                       ? Colors.white
//                                       : Colors.black,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//                       ),
//
//                       const SizedBox(height: 24),
//
//                       // if (selectedStartVerse != null)
//                       //   Center(
//                       //     child: Text(
//                       //       selectedStartVerse == selectedEndVerse
//                       //           ? "${selectedBook['book']} $selectedChapter:${selectedStartVerse}"
//                       //           : "${selectedBook['book']} $selectedChapter:${selectedStartVerse}-${selectedEndVerse}",
//                       //       style: const TextStyle(
//                       //         fontSize: 18,
//                       //         fontWeight: FontWeight.bold,
//                       //         color: Colors.black87,
//                       //       ),
//                       //     ),
//                       //   ),
//                       if (startVerse != null)
//                         Column(
//                           children: [
//                             Text(
//                               startVerse == endVerse
//                                   ? "${selectedBook['book']} $selectedChapter:$startVerse"
//                                   : "${selectedBook['book']} $selectedChapter:$startVerse-$endVerse",
//                               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                             ),
//                             const SizedBox(height: 12),
//                             ElevatedButton(
//                               onPressed: () {
//                                 final result = startVerse == endVerse
//                                     ? "${selectedBook['book']} $selectedChapter:$startVerse"
//                                     : "${selectedBook['book']} $selectedChapter:$startVerse-$endVerse";
//                                 Navigator.pop(context, result);
//                               },
//                               child: const Text("Done"),
//                             )
//                           ],
//                         )
//                     ],
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


/// 📖 ScriptureSelector dialog
class ScriptureSelector extends StatefulWidget {
  const ScriptureSelector({super.key});

  @override
  State<ScriptureSelector> createState() => _ScriptureSelectorState();
}

class _ScriptureSelectorState extends State<ScriptureSelector> {
  List<dynamic> bibleBooks = [];
  dynamic selectedBook;
  int? selectedChapter;
  int? startVerse;
  int? endVerse;

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
        ? int.parse(
      (selectedBook['chapters'] as List)
          .firstWhere((c) => int.parse(c['chapter']) == selectedChapter)['verses']
          .toString(),
    )
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Scripture"),
        automaticallyImplyLeading: false,
      ),
      body: bibleBooks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            DropdownButton<dynamic>(
              isExpanded: true,
              hint: const Text("Select Book"),
              value: selectedBook,
              items: bibleBooks
                  .map((book) => DropdownMenuItem(value: book, child: Text(book['book'])))
                  .toList(),
              onChanged: (book) => setState(() {
                selectedBook = book;
                selectedChapter = null;
                startVerse = null;
                endVerse = null;
              }),
            ),
            const SizedBox(height: 16),
            if (selectedBook != null)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: chapters
                    .map((ch) => GestureDetector(
                  onTap: () => setState(() {
                    selectedChapter = ch;
                    startVerse = null;
                    endVerse = null;
                  }),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedChapter == ch ? Colors.blueAccent : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(ch.toString(),
                        style: TextStyle(
                            color: selectedChapter == ch ? Colors.white : Colors.black)),
                  ),
                ))
                    .toList(),
              ),
            const SizedBox(height: 24),
            if (selectedChapter != null)
              Wrap(
                spacing: 6,
                runSpacing: 6,
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
                          if (v > startVerse!) endVerse = v;
                          else {
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
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blueAccent : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(v.toString(),
                          style:
                          TextStyle(color: isSelected ? Colors.white : Colors.black)),
                    ),
                  );
                }),
              ),
            const SizedBox(height: 24),
            if (startVerse != null)
              Column(
                children: [
                  Text(
                    startVerse == endVerse
                        ? "${selectedBook['book']} $selectedChapter:$startVerse"
                        : "${selectedBook['book']} $selectedChapter:$startVerse-$endVerse",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      final result = startVerse == endVerse
                          ? "${selectedBook['book']} $selectedChapter:$startVerse"
                          : "${selectedBook['book']} $selectedChapter:$startVerse-$endVerse";
                      Navigator.pop(context, result);
                    },
                    child: const Text("Done"),
                  )
                ],
              )
          ]),
        ),
      ),
    );
  }
}