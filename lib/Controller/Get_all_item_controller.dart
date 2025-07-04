import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../Model/Item_Model.dart';
import '../environmental variables.dart';

class ItemService {
  // ✅ Fetch all items (optionally by parentId)
  static Future<List<ItemModel>> fetchItems({String? parentId}) async {
    final uri = Uri.parse(
      parentId != null
          ? '$baseUrl/api/item?parentId=$parentId'
          : '$baseUrl/api/item',
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => ItemModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch items: ${response.statusCode}');
    }
  }

  // ✅ Create item (with optional image or parentId)
  static Future<ItemModel> createItem({
    required String title,
    required String subtitle,
    required String url,
    required String type,
    String? parentId,             // 👈 For nested items
    Uint8List? imageBytes,
    String? imageUrl,
  }) async {
    final uri = Uri.parse('$baseUrl/api/item');
    final request = http.MultipartRequest('POST', uri);

    // Required fields
    request.fields['title'] = title;
    request.fields['subtitle'] = subtitle;
    request.fields['url'] = url;
    request.fields['type'] = type;

    // Optional fields
    if (parentId != null) {
      request.fields['parentId'] = parentId;
    }
    if (imageBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'imageFile',
        imageBytes,
        filename: 'image.jpg',
      ));
    }
    if (imageUrl != null && imageUrl.isNotEmpty) {
      request.fields['image'] = imageUrl;
    }

    final response = await request.send();

    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> jsonData = json.decode(responseBody);
      return ItemModel.fromJson(jsonData);
    } else {
      final errorBody = await response.stream.bytesToString();
      throw Exception('Failed to create item: ${response.statusCode} $errorBody');
    }
  }

  // ✅ Delete item
  static Future<void> deleteItem(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/item/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete item');
    }
  }

  // ✅ Reorder items or sub-items
  static Future<void> reorderItems(List<ItemModel> items) async {
    final body = json.encode({
      'order': items.asMap().entries.map((entry) => {
        '_id': entry.value.id,
        'index': entry.key,
      }).toList(),
    });

    final response = await http.put(
      Uri.parse('$baseUrl/api/item/reorder'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reorder items');
    }
  }

  // ✅ Fetch a single item by ID
  static Future<ItemModel?> fetchItemById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/item/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ItemModel.fromJson(data);
    } else if (response.statusCode == 404) {
      return null; // Not found, return null
    } else {
      throw Exception('Failed to fetch item by ID: ${response.statusCode}');
    }
  }


  // ✅ Update item
  static Future<ItemModel> updateItem(ItemModel item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/item/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );

    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update item');
    }
  }
}
