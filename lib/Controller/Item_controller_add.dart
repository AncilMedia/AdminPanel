// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:mime/mime.dart';
//
// import '../environmental variables.dart';
//
// class ItemController {
//   static String apiUrl = '$baseUrl/api/item';
//
//   static Future<http.Response> saveItem(
//       Map<String, dynamic> item, Uint8List? imageBytes, String? imageName) async {
//     final isNew = item["_id"] == null || item["_id"].toString().isEmpty;
//     final String url = isNew ? apiUrl : '$apiUrl/${item["_id"]}';
//
//     final request = http.MultipartRequest(
//       isNew ? 'POST' : 'PUT',
//       Uri.parse(url),
//     );
//
//     // ✅ Add all string fields
//     request.fields['title'] = item['title'] ?? '';
//     request.fields['subtitle'] = item['subtitle'] ?? '';
//     request.fields['url'] = item['url'] ?? '';
//
//     // ✅ Add image file if exists
//     if (imageBytes != null && imageName != null) {
//       final mimeType = lookupMimeType(imageName, headerBytes: imageBytes) ?? 'image/jpeg';
//       final mediaType = MediaType.parse(mimeType);
//
//       request.files.add(http.MultipartFile.fromBytes(
//         'imageFile', // make sure this matches the multer field in your backend
//         imageBytes,
//         filename: imageName,
//         contentType: mediaType,
//       ));
//     }
//
//     try {
//       final streamed = await request.send();
//       final response = await http.Response.fromStream(streamed);
//
//       // ✅ Throw on error so UI can respond
//       if (response.statusCode < 200 || response.statusCode >= 300) {
//         throw Exception('Failed to upload item: ${response.statusCode}\n${response.body}');
//       }
//
//       return response;
//     } catch (e) {
//       throw Exception('Error uploading item: $e');
//     }
//   }
// }


import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../environmental variables.dart';

class ItemController {
  static String apiUrl = '$baseUrl/api/item';

  static Future<http.Response> saveItem(
      Map<String, dynamic> item,
      Uint8List? imageBytes,
      String? imageName,
      String userId // 👈 new param to pass logged-in user's ID
      ) async {
    final isNew = item["_id"] == null || item["_id"].toString().isEmpty;
    final String url = isNew ? apiUrl : '$apiUrl/${item["_id"]}';

    final request = http.MultipartRequest(
      isNew ? 'POST' : 'PUT',
      Uri.parse(url),
    );

    // ✅ Add all string fields
    request.fields['title'] = item['title'] ?? '';
    request.fields['subtitle'] = item['subtitle'] ?? '';
    request.fields['url'] = item['url'] ?? '';
    request.fields['type'] = item['type'] ?? '';
    request.fields['organizationId'] = item['organizationId'] ?? '';
    if (item['parentId'] != null) {
      request.fields['parentId'] = item['parentId'];
    }
    if (item['index'] != null) {
      request.fields['index'] = item['index'].toString();
    }

    // ✅ Add image file if exists
    if (imageBytes != null && imageName != null) {
      final mimeType = lookupMimeType(imageName, headerBytes: imageBytes) ?? 'image/jpeg';
      final mediaType = MediaType.parse(mimeType);

      request.files.add(http.MultipartFile.fromBytes(
        'imageFile',
        imageBytes,
        filename: imageName,
        contentType: mediaType,
      ));
    }

    // ✅ Add user ID in header for backend access control
    request.headers['x-user-id'] = userId;

    try {
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Failed to upload item: ${response.statusCode}\n${response.body}');
      }

      return response;
    } catch (e) {
      throw Exception('Error uploading item: $e');
    }
  }
}
