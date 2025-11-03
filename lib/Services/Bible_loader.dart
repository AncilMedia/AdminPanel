import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../Model/Bible_book.dart';

Future<List<BibleBook>> loadBibleData() async {
  final data = await rootBundle.loadString('assets/bible.json');
  final List decoded = json.decode(data);
  return decoded.map((book) => BibleBook.fromJson(book)).toList();
}
