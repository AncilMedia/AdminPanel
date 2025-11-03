class BibleBook {
  final String abbr;
  final String book;
  final List<BibleChapter> chapters;

  BibleBook({required this.abbr, required this.book, required this.chapters});

  factory BibleBook.fromJson(Map<String, dynamic> json) {
    return BibleBook(
      abbr: json['abbr'],
      book: json['book'],
      chapters: (json['chapters'] as List)
          .map((c) => BibleChapter.fromJson(c))
          .toList(),
    );
  }
}

class BibleChapter {
  final int chapter;
  final int verses;

  BibleChapter({required this.chapter, required this.verses});

  factory BibleChapter.fromJson(Map<String, dynamic> json) {
    return BibleChapter(
      chapter: int.parse(json['chapter']),
      verses: int.parse(json['verses']),
    );
  }
}
