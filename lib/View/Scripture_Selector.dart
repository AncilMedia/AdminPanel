import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:iconsax/iconsax.dart';

class ScriptureSelector extends StatefulWidget {
  final bool isMultiSelect;
  const ScriptureSelector({super.key, this.isMultiSelect = true});

  @override
  State<ScriptureSelector> createState() => _ScriptureSelectorState();
}

class _ScriptureSelectorState extends State<ScriptureSelector> with TickerProviderStateMixin {
  List<dynamic> bibleBooks = [];
  dynamic selectedBook;
  int? selectedChapter;
  int? startVerse;
  int? endVerse;

  final SingleSelectController<String> _bookController = SingleSelectController<String>(null);
  final List<Map<String, dynamic>> selectedScriptures = [];

  late AnimationController _gridController;
  final TextStyle baseStyle = GoogleFonts.poppins();

  @override
  void initState() {
    super.initState();
    _gridController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _loadBibleData();
  }

  @override
  void dispose() {
    _gridController.dispose();
    _bookController.dispose();
    super.dispose();
  }

  Future<void> _loadBibleData() async {
    final data = await rootBundle.loadString('assets/bible.json');
    setState(() => bibleBooks = json.decode(data));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // ✅ FIXED: Explicitly cast to List<int>
    final List<int> chapters = selectedBook != null
        ? (selectedBook['chapters'] as List)
        .map<int>((c) => int.tryParse(c['chapter'].toString()) ?? 0)
        .toList()
        : [];

    final int verseCount = selectedBook != null && selectedChapter != null
        ? int.tryParse((selectedBook['chapters'] as List).firstWhere(
            (c) => int.parse(c['chapter'].toString()) == selectedChapter,
        orElse: () => {'verses': 0})['verses'].toString()) ?? 0
        : 0;

    return Container(
      width: size.width * 0.45,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),

          _buildLabel("Step 1: Choose Book"),
          CustomDropdown<String>.search(
            hintText: 'Search for a book...',
            controller: _bookController,
            items: bibleBooks.map((b) => b['book'].toString()).toList(),
            decoration: CustomDropdownDecoration(
              closedFillColor: Colors.grey.shade50,
              closedBorder: Border.all(color: Colors.grey.shade200),
              closedBorderRadius: BorderRadius.circular(12),
            ),
            onChanged: (value) {
              final book = bibleBooks.firstWhere((b) => b['book'] == value, orElse: () => {});
              setState(() {
                selectedBook = book.isNotEmpty ? book : null;
                selectedChapter = null;
                startVerse = null;
                endVerse = null;
                _gridController.forward(from: 0);
              });
            },
          ),

          const SizedBox(height: 24),

          if (selectedBook != null)
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Step 2: Select Chapter"),
                    _buildChapterGrid(chapters),
                    const SizedBox(height: 24),

                    if (selectedChapter != null) ...[
                      _buildLabel("Step 3: Verse Range (Optional)"),
                      _buildVerseGrid(verseCount),
                      const SizedBox(height: 24),
                      _buildAddButton(),
                    ],
                  ],
                ),
              ),
            ),

          const Divider(height: 40),
          _buildSelectionSummary(),
        ],
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Scripture Selector", style: baseStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
            Text("Add references to your media", style: baseStyle.copyWith(fontSize: 12, color: Colors.grey)),
          ],
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, selectedScriptures),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text("Done", style: baseStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade700)),
    );
  }

  Widget _buildChapterGrid(List<int> chapters) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chapters.map((ch) {
        bool isSelected = selectedChapter == ch;
        return GestureDetector(
          onTap: () => setState(() {
            selectedChapter = ch;
            startVerse = null;
            endVerse = null;
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.indigo : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(ch.toString(),
                style: baseStyle.copyWith(color: isSelected ? Colors.white : Colors.black87)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVerseGrid(int verseCount) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100)
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6
        ),
        itemCount: verseCount,
        itemBuilder: (context, i) {
          final v = i + 1;
          final isSelected = startVerse != null && endVerse != null && v >= startVerse! && v <= endVerse!;
          return GestureDetector(
            onTap: () {
              setState(() {
                if (startVerse == null || (startVerse != null && endVerse != startVerse)) {
                  startVerse = v; endVerse = v;
                } else if (v > startVerse!) {
                  endVerse = v;
                } else {
                  endVerse = startVerse; startVerse = v;
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Colors.cyan : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: isSelected ? Colors.cyan : Colors.grey.shade200),
              ),
              child: Text(v.toString(), style: baseStyle.copyWith(fontSize: 11, color: isSelected ? Colors.white : Colors.black87)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          final newItem = {'book': selectedBook['book'], 'chapter': selectedChapter, 'start': startVerse, 'end': endVerse};
          setState(() {
            selectedScriptures.add(newItem);
            selectedChapter = null; startVerse = null; endVerse = null;
          });
        },
        icon: const Icon(Iconsax.add_circle, size: 20),
        label: const Text("Add to Selection"),
        style: TextButton.styleFrom(foregroundColor: Colors.indigo, textStyle: baseStyle.copyWith(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSelectionSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Current Selection"),
        if (selectedScriptures.isEmpty)
          Text("No scriptures added yet.", style: baseStyle.copyWith(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedScriptures.map((s) {
            String ref = "${s['book']} ${s['chapter']}";
            if (s['start'] != null) ref += ":${s['start']}${s['end'] != s['start'] ? '-${s['end']}' : ''}";
            return Chip(
              backgroundColor: Colors.indigo.withOpacity(0.05),
              side: BorderSide(color: Colors.indigo.withOpacity(0.1)),
              label: Text(ref, style: baseStyle.copyWith(fontSize: 12, color: Colors.indigo, fontWeight: FontWeight.bold)),
              deleteIcon: const Icon(Iconsax.close_circle, size: 16, color: Colors.indigo),
              onDeleted: () => setState(() => selectedScriptures.remove(s)),
            );
          }).toList(),
        ),
      ],
    );
  }
}