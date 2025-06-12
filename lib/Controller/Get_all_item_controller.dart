import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/Item_Model.dart';
import '../environmental variables.dart';

class ItemService {
  /// Fetch all items
  static Future<List<ItemModel>> fetchItems() async {
    final url = '$baseUrl/api/item';
    final response = await http.get(Uri.parse(url));

    print('GET $url');
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => ItemModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load items: ${response.statusCode}');
    }
  }

  /// Reorder items based on provided list
  static Future<void> reorderItems(List<ItemModel> items) async {
    final url = '$baseUrl/api/item/reorder';

    final orderPayload = {
      "order": items.asMap().entries.map((e) => {
        "_id": e.value.id,
        "index": e.key,
      }).toList()
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderPayload),
    );

    print('POST $url');
    print('Body: $orderPayload');
    print('Status: ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception('Failed to reorder items: ${response.statusCode}');
    }
  }

  /// Delete an item by ID
  static Future<void> deleteItem(String id) async {
    final url = '$baseUrl/api/item/$id';
    final response = await http.delete(Uri.parse(url));

    print('DELETE $url');
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete item: ${response.statusCode}');
    }
  }
}
