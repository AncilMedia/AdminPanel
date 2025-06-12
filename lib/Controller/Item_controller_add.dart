// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
//
// class ItemController {
//   static const String apiUrl = 'http://localhost:3000/api/item';
//
//   static Future<void> saveItem(Map<String, dynamic> item) async {
//     final id = item['_id'];
//     if (id == null || id.toString().isEmpty) {
//       print("❌ Cannot update item: _id is missing");
//       return;
//     }
//
//     // Convert image to base64 if needed
//     String? imageData;
//     final rawImage = item['image'];
//     if (rawImage is Uint8List) {
//       imageData = base64Encode(rawImage);
//     } else if (rawImage is String) {
//       imageData = rawImage;
//     } else {
//       print("⚠️ Unknown image format");
//     }
//
//     final body = jsonEncode({
//       'title': item['title'] ?? '',
//       'subtitle': item['subtitle'] ?? '',
//       'url': item['url'] ?? '',
//       'image': imageData ?? '',
//       'imageName': item['imageName'] ?? '',
//     });
//
//     try {
//       final response = await http.put(
//         Uri.parse('$apiUrl/$id'),
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );
//       print("✅ API Response: ${response.statusCode}");
//       print("🧾 Response Body: ${response.body}");
//     } catch (e) {
//       print("❌ API Error: $e");
//     }
//   }
// }

import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../environmental variables.dart';

class ItemController {
  static  String apiUrl = '$baseUrl/api/item';


  static Future<void> saveItem(
      Map<String, dynamic> item, Uint8List? imageBytes, String? imageName) async {
    final String url = item["_id"] == null || item["_id"].toString().isEmpty
        ? apiUrl
        : '$apiUrl/${item["_id"]}';

    final request = http.MultipartRequest(
      item["_id"] == null ? 'POST' : 'PUT',
      Uri.parse(url),
    );

    request.fields['title'] = item['title'] ?? '';
    request.fields['subtitle'] = item['subtitle'] ?? '';
    request.fields['url'] = item['url'] ?? '';

    // Set headers if needed (example: ngrok)
    // request.headers.addAll({
    //   'ngrok-skip-browser-warning': 'true',
    //   'Content-Type': 'multipart/form-data',
    // });

    if (imageBytes != null && imageName != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'imageFile',
        imageBytes,
        filename: imageName,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    try {
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } catch (e) {
      print('Error uploading item: $e');
    }
  }
}
