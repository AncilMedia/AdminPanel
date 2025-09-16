// // // import 'dart:convert';
// // // import 'dart:io';
// // // import 'package:http/http.dart' as http;
// // // import 'package:shared_preferences/shared_preferences.dart';
// // //
// // // import '../environmental variables.dart';
// // //
// // // class MediaItemService {
// // //   // ⬆️ Replace localhost with your backend IP if running on device
// // //
// // //   // 🔹 Create Media Item (upload file + metadata)
// // //   Future<Map<String, dynamic>> createMediaItem({
// // //     required String title,
// // //     required String description,
// // //     String? tags,
// // //     String? seriesId,
// // //     required File file, // video/audio file
// // //   }) async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //
// // //     final userId = prefs.getString("userId");
// // //     final orgId = prefs.getString("organizationId");
// // //     final roleId = prefs.getString("roleId");
// // //
// // //     final uri = Uri.parse("$baseUrl/api/media/item");
// // //     final request = http.MultipartRequest("POST", uri);
// // //
// // //     // 🔹 Add text fields
// // //     request.fields["title"] = title;
// // //     request.fields["description"] = description;
// // //     if (tags != null) request.fields["tags"] = tags; // comma-separated
// // //     if (seriesId != null) request.fields["seriesId"] = seriesId;
// // //     if (userId != null) request.fields["createdBy"] = userId;
// // //     if (orgId != null) request.fields["organization"] = orgId;
// // //     if (roleId != null) request.fields["role"] = roleId;
// // //
// // //     // 🔹 Add file
// // //     request.files.add(
// // //       await http.MultipartFile.fromPath("file", file.path),
// // //     );
// // //
// // //     final response = await request.send();
// // //     final resBody = await response.stream.bytesToString();
// // //
// // //     return jsonDecode(resBody);
// // //   }
// // //
// // //   // 🔹 Get All Media Items
// // //   Future<List<dynamic>> getMediaItems() async {
// // //     final response = await http.get(Uri.parse("$baseUrl/api/media"));
// // //     return jsonDecode(response.body);
// // //   }
// // //
// // //   // 🔹 Bulk Edit Tags
// // //   Future<Map<String, dynamic>> bulkEditMediaItems({
// // //     required List<String> ids,
// // //     required List<String> tags,
// // //   }) async {
// // //     final response = await http.put(
// // //       Uri.parse("$baseUrl/api/media/bulk-edit"),
// // //       headers: {"Content-Type": "application/json"},
// // //       body: jsonEncode({
// // //         "ids": ids,
// // //         "tags": tags,
// // //       }),
// // //     );
// // //
// // //     return jsonDecode(response.body);
// // //   }
// // //
// // //   // 🔹 Delete Media Item
// // //   Future<Map<String, dynamic>> deleteMediaItem(String id) async {
// // //     final response = await http.delete(Uri.parse("$baseUrl/api/media/$id"));
// // //     return jsonDecode(response.body);
// // //   }
// // // }
// //
// //
// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // import '../environmental variables.dart';
// //
// // class MediaItemService {
// //   // ✅ Create Media Item (upload file + metadata)
// //   Future<Map<String, dynamic>> createMediaItem({
// //     required String title,
// //     required String description,
// //     String? tags,
// //     String? seriesId,
// //     required File file, // video/audio file
// //   }) async {
// //     final prefs = await SharedPreferences.getInstance();
// //
// //     final userId = prefs.getString("userId");
// //     final orgId = prefs.getString("organizationId");
// //     final roleId = prefs.getString("roleId");
// //
// //     final uri = Uri.parse("$baseUrl/api/media/item");
// //     final request = http.MultipartRequest("POST", uri);
// //
// //     // 🔹 Add text fields
// //     request.fields["title"] = title;
// //     request.fields["description"] = description;
// //     if (tags != null) request.fields["tags"] = tags;
// //     if (seriesId != null) request.fields["seriesId"] = seriesId;
// //     if (userId != null) request.fields["createdBy"] = userId;
// //     if (orgId != null) request.fields["organization"] = orgId;
// //     if (roleId != null) request.fields["role"] = roleId;
// //
// //     // 🔹 Add file
// //     request.files.add(
// //       await http.MultipartFile.fromPath("file", file.path),
// //     );
// //
// //     final response = await request.send();
// //     final resBody = await response.stream.bytesToString();
// //
// //     return jsonDecode(resBody);
// //   }
// //
// //   // ✅ Get All Media Items
// //   Future<List<dynamic>> getMediaItems() async {
// //     final response = await http.get(Uri.parse("$baseUrl/api/media/item"));
// //     return jsonDecode(response.body);
// //   }
// //
// //   // ✅ Get Media Items by User or Organization
// //   Future<List<dynamic>> getMediaItemsByUserOrOrg({
// //     String? userId,
// //     String? organizationId,
// //   }) async {
// //     final queryParams = <String, String>{};
// //     if (userId != null) queryParams['userId'] = userId;
// //     if (organizationId != null) queryParams['organizationId'] = organizationId;
// //
// //     final uri = Uri.parse("$baseUrl/api/media/item/filter")
// //         .replace(queryParameters: queryParams);
// //
// //     final response = await http.get(uri);
// //     return jsonDecode(response.body);
// //   }
// //
// //   // ✅ Get Media Item by ID
// //   Future<Map<String, dynamic>> getMediaItemById(String id) async {
// //     final response = await http.get(Uri.parse("$baseUrl/api/media/item/$id"));
// //     return jsonDecode(response.body);
// //   }
// //
// //   // ✅ Update Media Item by ID
// //   Future<Map<String, dynamic>> updateMediaItem(
// //       String id, {
// //         String? title,
// //         String? description,
// //         List<String>? tags,
// //         String? seriesId,
// //       }) async {
// //     final body = <String, dynamic>{};
// //     if (title != null) body['title'] = title;
// //     if (description != null) body['description'] = description;
// //     if (tags != null) body['tags'] = tags;
// //     if (seriesId != null) body['seriesId'] = seriesId;
// //
// //     final response = await http.put(
// //       Uri.parse("$baseUrl/api/media/item/$id"),
// //       headers: {"Content-Type": "application/json"},
// //       body: jsonEncode(body),
// //     );
// //
// //     return jsonDecode(response.body);
// //   }
// //
// //   // ✅ Bulk Edit Tags
// //   Future<Map<String, dynamic>> bulkEditMediaItems({
// //     required List<String> ids,
// //     required List<String> tags,
// //   }) async {
// //     final response = await http.put(
// //       Uri.parse("$baseUrl/api/media/item/bulk-edit"),
// //       headers: {"Content-Type": "application/json"},
// //       body: jsonEncode({
// //         "ids": ids,
// //         "tags": tags,
// //       }),
// //     );
// //
// //     return jsonDecode(response.body);
// //   }
// //
// //   // ✅ Delete Media Item
// //   Future<Map<String, dynamic>> deleteMediaItem(String id) async {
// //     final response =
// //     await http.delete(Uri.parse("$baseUrl/api/media/item/$id"));
// //     return jsonDecode(response.body);
// //   }
// // }
//
//
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../environmental variables.dart';
//
// class MediaItemService {
//   // ✅ Create Media Item (upload file + metadata)
//   Future<Map<String, dynamic>> createMediaItem({
//     required String title,
//     required String description,
//     String? tags,
//     String? seriesId,
//     required File file, // video/audio file
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//
//     final userId = prefs.getString("userId");
//     final orgId = prefs.getString("organizationId");
//     final roleId = prefs.getString("roleId");
//
//     final uri = Uri.parse("$baseUrl/api/media/item");
//     final request = http.MultipartRequest("POST", uri);
//
//     // 🔹 Add text fields
//     request.fields["title"] = title;
//     request.fields["description"] = description;
//     if (tags != null) request.fields["tags"] = tags;
//     if (seriesId != null) request.fields["seriesId"] = seriesId;
//     if (userId != null) request.fields["createdBy"] = userId;
//     if (orgId != null) request.fields["organization"] = orgId;
//     if (roleId != null) request.fields["role"] = roleId;
//
//     // 🔹 Add file
//     request.files.add(
//       await http.MultipartFile.fromPath("file", file.path),
//     );
//
//     final response = await request.send();
//     final resBody = await response.stream.bytesToString();
//
//     return jsonDecode(resBody);
//   }
//
//   // ✅ Get All Media Items
//   Future<List<dynamic>> getMediaItems() async {
//     final response = await http.get(Uri.parse("$baseUrl/api/media/item"));
//     final decoded = jsonDecode(response.body);
//
//     if (decoded is List) {
//       return decoded;
//     } else if (decoded is Map && decoded.containsKey("error")) {
//       throw Exception(decoded["error"]);
//     } else {
//       return [];
//     }
//   }
//
//   // ✅ Get Media Items by User or Organization
//   Future<List<dynamic>> getMediaItemsByUserOrOrg({
//     String? userId,
//     String? organizationId,
//   }) async {
//     final queryParams = <String, String>{};
//     if (userId != null) queryParams['userId'] = userId;
//     if (organizationId != null) queryParams['organizationId'] = organizationId;
//
//     final uri = Uri.parse("$baseUrl/api/media/item/filter")
//         .replace(queryParameters: queryParams);
//
//     final response = await http.get(uri);
//     final decoded = jsonDecode(response.body);
//
//     if (decoded is List) {
//       return decoded;
//     } else if (decoded is Map && decoded.containsKey("error")) {
//       throw Exception(decoded["error"]);
//     } else {
//       return [];
//     }
//   }
//
//   // ✅ Get Media Item by ID
//   Future<Map<String, dynamic>> getMediaItemById(String id) async {
//     final response = await http.get(Uri.parse("$baseUrl/api/media/item/$id"));
//     return jsonDecode(response.body);
//   }
//
//   // ✅ Update Media Item by ID
//   Future<Map<String, dynamic>> updateMediaItem(
//       String id, {
//         String? title,
//         String? description,
//         List<String>? tags,
//         String? seriesId,
//       }) async {
//     final body = <String, dynamic>{};
//     if (title != null) body['title'] = title;
//     if (description != null) body['description'] = description;
//     if (tags != null) body['tags'] = tags;
//     if (seriesId != null) body['seriesId'] = seriesId;
//
//     final response = await http.put(
//       Uri.parse("$baseUrl/api/media/item/$id"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(body),
//     );
//
//     return jsonDecode(response.body);
//   }
//
//   // ✅ Bulk Edit Tags
//   Future<Map<String, dynamic>> bulkEditMediaItems({
//     required List<String> ids,
//     required List<String> tags,
//   }) async {
//     final response = await http.put(
//       Uri.parse("$baseUrl/api/media/item/bulk-edit"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "ids": ids,
//         "tags": tags,
//       }),
//     );
//
//     return jsonDecode(response.body);
//   }
//
//   // ✅ Delete Media Item
//   Future<Map<String, dynamic>> deleteMediaItem(String id) async {
//     final response =
//     await http.delete(Uri.parse("$baseUrl/api/media/item/$id"));
//     return jsonDecode(response.body);
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../environmental variables.dart';

class MediaItemService {

  // Future<Map<String, dynamic>> createMediaItem({
  //   required String title,
  //   required String description,
  //   String? tags,
  //   String? seriesId,
  //   File? file, // for mobile/desktop
  //   PlatformFile? webFile, // for web
  // }) async {
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   final userId = prefs.getString("userId");
  //   final orgId = prefs.getString("organizationId");
  //   final roleId = prefs.getString("roleId");
  //
  //   final uri = Uri.parse("$baseUrl/api/media/item");
  //   final request = http.MultipartRequest("POST", uri);
  //
  //   // 🔹 Add text fields
  //   request.fields["title"] = title;
  //   request.fields["description"] = description;
  //   if (tags != null) request.fields["tags"] = tags;
  //   if (seriesId != null) request.fields["seriesId"] = seriesId;
  //   if (userId != null) request.fields["createdBy"] = userId;
  //   if (orgId != null) request.fields["organization"] = orgId;
  //   if (roleId != null) request.fields["role"] = roleId;
  //
  //   // 🔹 Add file depending on platform
  //   if (kIsWeb && webFile != null) {
  //     // Web → use bytes
  //     request.files.add(
  //       http.MultipartFile.fromBytes(
  //         "file",
  //         webFile.bytes!,
  //         filename: webFile.name,
  //       ),
  //     );
  //   } else if (!kIsWeb && file != null) {
  //     // Mobile/Desktop → use path
  //     request.files.add(
  //       await http.MultipartFile.fromPath("file", file.path),
  //     );
  //   } else {
  //     throw Exception("No file selected");
  //   }
  //
  //   print("📤 POST $uri");
  //   final response = await request.send();
  //   final resBody = await response.stream.bytesToString();
  //
  //   print("⬇️ Response [${response.statusCode}]: $resBody");
  //
  //   return jsonDecode(resBody);
  // }

  Future<Map<String, dynamic>> createMediaItem({
    required String title,
    required String description,
    String? tags,
    String? seriesId,
    File? file,                // media (mobile/desktop)
    PlatformFile? webFile,     // media (web)
    File? thumbnailFile,       // thumbnail (mobile/desktop)
    PlatformFile? webThumbnailFile, // thumbnail (web)
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString("userId");
    final orgId = prefs.getString("organizationId");
    final roleId = prefs.getString("roleId");

    final uri = Uri.parse("$baseUrl/api/media/item");
    final request = http.MultipartRequest("POST", uri);

    // 🔹 Add text fields
    request.fields["title"] = title;
    request.fields["description"] = description;
    if (tags != null) request.fields["tags"] = tags;
    if (seriesId != null) request.fields["seriesId"] = seriesId;
    if (userId != null) request.fields["createdBy"] = userId;
    if (orgId != null) request.fields["organization"] = orgId;
    if (roleId != null) request.fields["role"] = roleId;

    // 🔹 Add main media file
    if (kIsWeb && webFile != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          webFile.bytes!,
          filename: webFile.name,
        ),
      );
    } else if (!kIsWeb && file != null) {
      request.files.add(
        await http.MultipartFile.fromPath("file", file.path),
      );
    } else {
      throw Exception("No media file selected");
    }

    // 🔹 Add thumbnail file if provided
    if (kIsWeb && webThumbnailFile != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          "thumbnail",
          webThumbnailFile.bytes!,
          filename: webThumbnailFile.name,
        ),
      );
    } else if (!kIsWeb && thumbnailFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath("thumbnail", thumbnailFile.path),
      );
    }

    print("📤 POST $uri with fields: ${request.fields}");
    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    print("⬇️ Response [${response.statusCode}]: $resBody");

    return jsonDecode(resBody);
  }



  // ✅ Get All Media Items
  Future<List<dynamic>> getMediaItems() async {
    final uri = Uri.parse("$baseUrl/api/media/item");
    print("📤 GET $uri");

    final response = await http.get(uri);
    print("⬇️ Response [${response.statusCode}]: ${response.body}");

    final decoded = jsonDecode(response.body);
    if (decoded is List) {
      return decoded;
    } else if (decoded is Map && decoded.containsKey("error")) {
      throw Exception(decoded["error"]);
    } else {
      return [];
    }
  }

  // ✅ Get Media Items by User or Organization
  Future<List<dynamic>> getMediaItemsByUserOrOrg({
    String? userId,
    String? organizationId,
  }) async {
    final queryParams = <String, String>{};
    if (userId != null) queryParams['userId'] = userId;
    if (organizationId != null) queryParams['organizationId'] = organizationId;

    final uri = Uri.parse("$baseUrl/api/media/item/filter")
        .replace(queryParameters: queryParams);

    print("📤 GET $uri");

    final response = await http.get(uri);
    print("⬇️ Response [${response.statusCode}]: ${response.body}");

    final decoded = jsonDecode(response.body);
    if (decoded is List) {
      return decoded;
    } else if (decoded is Map && decoded.containsKey("error")) {
      throw Exception(decoded["error"]);
    } else {
      return [];
    }
  }

  // ✅ Get Media Item by ID
  Future<Map<String, dynamic>> getMediaItemById(String id) async {
    final uri = Uri.parse("$baseUrl/api/media/item/$id");
    print("📤 GET $uri");

    final response = await http.get(uri);
    print("⬇️ Response [${response.statusCode}]: ${response.body}");

    return jsonDecode(response.body);
  }

  // ✅ Update Media Item by ID
  Future<Map<String, dynamic>> updateMediaItem(
      String id, {
        String? title,
        String? description,
        List<String>? tags,
        String? seriesId,
      }) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;
    if (tags != null) body['tags'] = tags;
    if (seriesId != null) body['seriesId'] = seriesId;

    final uri = Uri.parse("$baseUrl/api/media/item/$id");
    print("📤 PUT $uri with body: $body");

    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    print("⬇️ Response [${response.statusCode}]: ${response.body}");

    return jsonDecode(response.body);
  }

  // ✅ Bulk Edit Tags
  Future<Map<String, dynamic>> bulkEditMediaItems({
    required List<String> ids,
    required List<String> tags,
  }) async {
    final uri = Uri.parse("$baseUrl/api/media/item/bulk-edit");
    final body = {"ids": ids, "tags": tags};

    print("📤 PUT $uri with body: $body");

    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    print("⬇️ Response [${response.statusCode}]: ${response.body}");

    return jsonDecode(response.body);
  }

  // ✅ Delete Media Item
  Future<Map<String, dynamic>> deleteMediaItem(String id) async {
    final uri = Uri.parse("$baseUrl/api/media/item/$id");
    print("📤 DELETE $uri");

    final response = await http.delete(uri);
    print("⬇️ Response [${response.statusCode}]: ${response.body}");

    return jsonDecode(response.body);
  }
}
