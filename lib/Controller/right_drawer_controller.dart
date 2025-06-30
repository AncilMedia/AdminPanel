import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/list_model.dart';
import '../environmental variables.dart';

class ListController {

  static Future<List<ListModel>> fetchLists() async {
    final res = await http.get(Uri.parse('$baseUrl/api/lists'));
    if (res.statusCode == 200) {
      final List jsonList = json.decode(res.body);
      return jsonList.map((json) => ListModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load lists');
    }
  }

  static Future<ListModel> createList(String title, String subtitle) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/lists'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'subtitle': subtitle}),
    );

    if (res.statusCode == 201) {
      return ListModel.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to create list');
    }
  }
}
