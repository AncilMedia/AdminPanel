import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/Item_Model.dart';
import '../environmental variables.dart';

class ItemService {
  static Future<List<ItemModel>> fetchItems({String? parentId}) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_Id');
    final token = prefs.getString('accessToken');

    final uri = Uri.parse(
      parentId != null
          ? '$baseUrl/api/item?parentId=$parentId'
          : '$baseUrl/api/item',
    );

    final response = await http.get(
      uri,
      headers: {
        'x-user-id': userId ?? '',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => ItemModel.fromJson(item)).toList();
    } else {
      print('Fetch items failed: ${response.body}');
      throw Exception('Failed to fetch items');
    }
  }

  static Future<ItemModel> createItem({
    required String title,
    String? subtitle,
    String? url,
    required String type,
    String? parentId,
    Uint8List? imageBytes,
    String? imageUrl,
  }) async {
    final uri = Uri.parse('$baseUrl/api/item');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final userId = prefs.getString('user_Id');
    final organizationId = prefs.getString('organizationId');

    if (token == null) throw Exception('Not authenticated: No access token');
    if (userId == null) throw Exception('No user ID found');
    if (organizationId == null) throw Exception('Missing organizationId in SharedPreferences');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['x-user-id'] = userId
      ..fields['title'] = title
      ..fields['type'] = type
      ..fields['organizationId'] = organizationId;

    if (subtitle?.isNotEmpty ?? false) request.fields['subtitle'] = subtitle!;
    if (url?.isNotEmpty ?? false) request.fields['url'] = url!;
    if (parentId?.isNotEmpty ?? false) request.fields['parentId'] = parentId!;
    if (imageUrl?.isNotEmpty ?? false) request.fields['image'] = imageUrl!;

    if (imageBytes != null && imageBytes.isNotEmpty) {
      request.files.add(http.MultipartFile.fromBytes(
        'imageFile',
        imageBytes,
        filename: 'image.jpg',
      ));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final jsonData = json.decode(responseBody);
      final data = jsonData['data'] ?? jsonData;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }
      return ItemModel.fromJson(data);
    } else {
      print("❌ Failed to create item: $responseBody");
      throw Exception('Failed to create item: $responseBody');
    }
  }

  static Future<void> deleteItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_Id');
    final token = prefs.getString('accessToken');

    final response = await http.delete(
      Uri.parse('$baseUrl/api/item/$id'),
      headers: {
        'x-user-id': userId ?? '',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete item');
    }
  }

  static Future<void> reorderItems(List<ItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_Id');
    final token = prefs.getString('accessToken');

    final body = json.encode({
      'order': items.asMap().entries.map((entry) => {
        '_id': entry.value.id,
        'index': entry.key,
      }).toList(),
    });

    final response = await http.put(
      Uri.parse('$baseUrl/api/item/reorder'),
      headers: {
        'x-user-id': userId ?? '',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reorder items');
    }
  }

  static Future<ItemModel?> fetchItemById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_Id');
    final token = prefs.getString('accessToken');

    final response = await http.get(
      Uri.parse('$baseUrl/api/item/$id'),
      headers: {
        'x-user-id': userId ?? '',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to fetch item');
    }
  }

  static Future<String?> updateItem({
    required String itemId,
    required String title,
    String? subtitle,
    String? externalUrl,
    String? type,
    Uint8List? imageBytes,
    String? imageUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_Id');
    final token = prefs.getString('accessToken');
    final uri = Uri.parse('$baseUrl/api/item/$itemId');

    if (imageBytes != null) {
      final request = http.MultipartRequest('PUT', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['x-user-id'] = userId ?? ''
        ..fields['title'] = title
        ..fields['type'] = type ?? 'link';

      if (subtitle != null) request.fields['subtitle'] = subtitle;
      if (externalUrl != null) request.fields['url'] = externalUrl;

      request.files.add(http.MultipartFile.fromBytes(
        'imageFile',
        imageBytes,
        filename: 'image.jpg',
      ));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(responseBody)['data'] ?? {};
        return data['image'];
      } else {
        throw Exception('Failed to update item: $responseBody');
      }
    } else {
      final body = {
        'title': title,
        'subtitle': subtitle,
        'url': externalUrl,
        'type': type,
        if (imageUrl != null) 'image': imageUrl,
      };

      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'x-user-id': userId ?? '',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] ?? {};
        return data['image'];
      } else {
        throw Exception('Failed to update item');
      }
    }
  }

  static Future<List<ItemModel>> fetchItemsByAppId(String appId) async {
    final uri = Uri.parse('$baseUrl/api/item/by-app/$appId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => ItemModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch items by appId');
    }
  }
}
