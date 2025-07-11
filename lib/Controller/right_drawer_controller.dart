import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../Model/list_model.dart';
import '../environmental variables.dart';

class ListController {
  // ✅ Fetch items (list/link/event) from `lists` collection by parentId
  static Future<List<ListModel>> fetchLists({String? parentId}) async {
    final url = parentId == null
        ? '$baseUrl/api/lists/all'
        : '$baseUrl/api/lists/all?parentId=$parentId';

    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List decoded = json.decode(res.body);
      return decoded.map((item) => ListModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch lists: ${res.body}');
    }
  }

  static Future<ListModel> createList(
      String title,
      String subtitle, {
        Uint8List? imageBytes,
        String? parentId,
        String type = 'list',
        String? url,
      }) async {
    final uri = Uri.parse('$baseUrl/api/lists');
    final request = http.MultipartRequest('POST', uri);

    request.fields['title'] = title;
    request.fields['subtitle'] = subtitle;
    request.fields['type'] = type;

    if (url != null && url.isNotEmpty) {
      request.fields['url'] = url;
    }

    if (parentId != null && parentId.isNotEmpty) {
      request.fields['parentId'] = parentId;
    }

    if (imageBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'imageFile',
        imageBytes,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    final streamedRes = await request.send();
    final res = await http.Response.fromStream(streamedRes);

    if (res.statusCode == 201) {
      final jsonBody = json.decode(res.body);
      final data = jsonBody['data'] ?? jsonBody;

      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid response format: $data');
      }

      return ListModel.fromJson(data);
    } else {
      throw Exception('Failed to create list: ${res.body}');
    }
  }


  // ✅ Delete a list or sub-item (recursive on backend)
  static Future<void> deleteList(String id) async {
    final url = '$baseUrl/api/lists/$id';
    final res = await http.delete(Uri.parse(url));
    if (res.statusCode != 200) {
      throw Exception('Failed to delete list: ${res.body}');
    }
  }

  // ✅ Fetch a tree of nested items by ID
  static Future<ListModel> fetchTreeById(String id) async {
    final url = '$baseUrl/api/lists/tree/$id';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return ListModel.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to load list tree');
    }
  }

  // ✅ Reorder a group of items (pass array of { _id, index })
  static Future<void> reorderLists(List<Map<String, dynamic>> items) async {
    final url = '$baseUrl/api/lists/reorder';
    final res = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"items": items}),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to reorder lists: ${res.body}');
    }
  }

  // Optional: Fetch all top-level trees (if supported by backend)
  static Future<List<ListModel>> fetchAllTrees() async {
    final url = '$baseUrl/api/lists/trees';
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final List jsonList = json.decode(res.body);
      return jsonList.map((json) => ListModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load all trees');
    }
  }
}
