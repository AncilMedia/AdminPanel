import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../Model/list_model.dart';
import '../environmental variables.dart';

class ListController {
  // ✅ Fetch flat lists (optionally by parentId)
  static Future<List<ListModel>> fetchLists({String? parentId}) async {
    final url = parentId == null
        ? '$baseUrl/api/lists/all'
        : '$baseUrl/api/lists/all?parentId=$parentId';

    print('GET $url');
    final res = await http.get(Uri.parse(url));

    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      final List jsonList = json.decode(res.body);
      return jsonList.map((json) => ListModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load lists');
    }
  }

  // ✅ Create a list (with optional image and parentId)
  static Future<ListModel> createList(
      String title,
      String subtitle, {
        Uint8List? imageBytes,
        String? parentId,
      }) async {
    final uri = Uri.parse('$baseUrl/api/lists');
    final request = http.MultipartRequest('POST', uri)
      ..fields['title'] = title
      ..fields['subtitle'] = subtitle;

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

    print('POST $uri');
    print('Request fields: ${request.fields}');
    if (imageBytes != null) print('Image bytes length: ${imageBytes.length}');

    final streamedRes = await request.send();
    final res = await http.Response.fromStream(streamedRes);

    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(res.body);
      return ListModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to create list: ${res.body}');
    }
  }

  // ✅ Get recursive tree of list
  static Future<ListModel> fetchTreeById(String id) async {
    final url = '$baseUrl/api/lists/tree/$id';
    print('GET $url');

    final res = await http.get(Uri.parse(url));

    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      return ListModel.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to load list tree');
    }
  }

  // ✅ Optional: Get all list trees (if route exists)
  static Future<List<ListModel>> fetchAllTrees() async {
    final url = '$baseUrl/api/lists/trees';
    print('GET $url');

    final res = await http.get(Uri.parse(url));

    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      final List jsonList = json.decode(res.body);
      return jsonList.map((json) => ListModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load list trees');
    }
  }
}
