// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // import '../environmental variables.dart';
// //
// // class MediaSeriesService {
// //
// //   // 🔹 Create Media Series
// //   Future<Map<String, dynamic>> createSeries({
// //     required String title,
// //     required String description,
// //     required String thumbnail,
// //   }) async {
// //     final prefs = await SharedPreferences.getInstance();
// //
// //     final userId = prefs.getString("userId");
// //     final orgId = prefs.getString("organizationId");
// //     final roleId = prefs.getString("roleId");
// //
// //     final response = await http.post(
// //       Uri.parse("$baseUrl/api/media/series"),
// //       headers: {"Content-Type": "application/json"},
// //       body: jsonEncode({
// //         "title": title,
// //         "description": description,
// //         "thumbnail": thumbnail,
// //         "createdBy": userId,
// //         "organization": orgId,
// //         "role": roleId,
// //       }),
// //     );
// //
// //     return jsonDecode(response.body);
// //   }
// //
// //   // 🔹 Get All Series
// //   Future<List<dynamic>> getSeries() async {
// //     final response = await http.get(Uri.parse("$baseUrl/api/media/series"));
// //     return jsonDecode(response.body);
// //   }
// //
// //   // 🔹 Get Series by ID
// //   Future<Map<String, dynamic>> getSeriesById(String id) async {
// //     final response = await http.get(Uri.parse("$baseUrl/api/media/series/$id"));
// //     return jsonDecode(response.body);
// //   }
// //
// //   // 🔹 Update Series by ID
// //   Future<Map<String, dynamic>> updateSeries({
// //     required String id,
// //     String? title,
// //     String? description,
// //     String? thumbnail,
// //   }) async {
// //     final response = await http.put(
// //       Uri.parse("$baseUrl/api/media/series/$id"),
// //       headers: {"Content-Type": "application/json"},
// //       body: jsonEncode({
// //         "title": title,
// //         "description": description,
// //         "thumbnail": thumbnail,
// //       }),
// //     );
// //
// //     return jsonDecode(response.body);
// //   }
// //
// //   // 🔹 Delete Series by ID
// //   Future<Map<String, dynamic>> deleteSeries(String id) async {
// //     final response = await http.delete(Uri.parse("$baseUrl/api/media/series/$id"));
// //     return jsonDecode(response.body);
// //   }
// // }
//
//
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../environmental variables.dart';
//
// class MediaSeriesService {
//
//   // 🔹 Create Media Series
//
//   Future<Map<String, dynamic>> createSeries({
//     required String title,
//     required String description,
//     File? file, // mobile
//     Uint8List? bytes, // web
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString("userId");
//     final orgId = prefs.getString("organizationId");
//     final roleId = prefs.getString("roleId");
//
//     if (userId == null || orgId == null || roleId == null) {
//       throw Exception("Missing required IDs in local storage");
//     }
//
//     var uri = Uri.parse("$baseUrl/api/media/series");
//     var request = http.MultipartRequest('POST', uri);
//
//     request.fields['title'] = title;
//     request.fields['description'] = description;
//     request.fields['createdBy'] = userId;
//     request.fields['organization'] = orgId;
//     request.fields['role'] = roleId;
//
//     if (kIsWeb && bytes != null) {
//       request.files.add(
//         http.MultipartFile.fromBytes(
//           'thumbnail',
//           bytes,
//           filename: 'thumbnail.png',
//         ),
//       );
//     } else if (!kIsWeb && file != null) {
//       request.files.add(await http.MultipartFile.fromPath(
//         'thumbnail',
//         file.path,
//       ));
//     }
//
//     var streamedResponse = await request.send();
//     var response = await http.Response.fromStream(streamedResponse);
//     if (response.statusCode >= 400) {
//       throw Exception("Failed to create series: ${response.body}");
//     }
//     return response.body.isNotEmpty ? Map<String, dynamic>.from(jsonDecode(response.body)) : {};
//   }
//
//   // 🔹 Get All Series
//   Future<List<dynamic>> getSeries() async {
//     final response = await http.get(Uri.parse("$baseUrl/api/media/series"));
//     final decoded = jsonDecode(response.body);
//     if (decoded is List) return decoded;
//     return [];
//   }
//
//   // 🔹 Get Series by Filter (userId, organizationId)
//   Future<List<dynamic>> getSeriesByFilter({
//     String? userId,
//     String? organizationId,
//   }) async {
//     final queryParams = <String, String>{};
//     if (userId != null) queryParams["userId"] = userId;
//     if (organizationId != null) queryParams["organizationId"] = organizationId;
//
//     final uri = Uri.parse("$baseUrl/api/media/series/filter")
//         .replace(queryParameters: queryParams);
//
//     final response = await http.get(uri);
//     final decoded = jsonDecode(response.body);
//     if (decoded is List) return decoded;
//     return [];
//   }
//
//   // 🔹 Get Series by ID
//   Future<Map<String, dynamic>> getSeriesById(String id) async {
//     final response = await http.get(Uri.parse("$baseUrl/api/media/series/$id"));
//     return jsonDecode(response.body);
//   }
//
//   // 🔹 Update Series by ID
//   // Future<Map<String, dynamic>> updateSeries({
//   //   required String id,
//   //   String? title,
//   //   String? description,
//   //   String? thumbnail,
//   // }) async {
//   //   final body = <String, dynamic>{};
//   //   if (title != null) body["title"] = title;
//   //   if (description != null) body["description"] = description;
//   //   if (thumbnail != null) body["thumbnail"] = thumbnail;
//   //
//   //   final response = await http.put(
//   //     Uri.parse("$baseUrl/api/media/series/$id"),
//   //     headers: {"Content-Type": "application/json"},
//   //     body: jsonEncode(body),
//   //   );
//   //
//   //   return jsonDecode(response.body);
//   // }
//   Future<Map<String, dynamic>> updateSeries({
//     required String id,
//     String? title,
//     String? description,
//     File? file,
//     Uint8List? bytes,
//   }) async {
//     var uri = Uri.parse("$baseUrl/api/media/series/$id");
//     var request = http.MultipartRequest('PUT', uri);
//
//     if (title != null) request.fields['title'] = title;
//     if (description != null) request.fields['description'] = description;
//
//     if (kIsWeb && bytes != null) {
//       request.files.add(http.MultipartFile.fromBytes('thumbnail', bytes, filename: 'thumbnail.png'));
//     } else if (!kIsWeb && file != null) {
//       request.files.add(await http.MultipartFile.fromPath('thumbnail', file.path));
//     }
//
//     var streamedResponse = await request.send();
//     var response = await http.Response.fromStream(streamedResponse);
//     if (response.statusCode >= 400) {
//       throw Exception("Failed to update series: ${response.body}");
//     }
//
//     return response.body.isNotEmpty ? Map<String, dynamic>.from(jsonDecode(response.body)) : {};
//   }
//
//
//   // 🔹 Delete Series by ID
//   Future<Map<String, dynamic>> deleteSeries(String id) async {
//     final response =
//     await http.delete(Uri.parse("$baseUrl/api/media/series/$id"));
//     return jsonDecode(response.body);
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../environmental variables.dart';

class MediaSeriesService {
  static const _timeout = Duration(seconds: 60);

  // ===============================
  // CREATE MEDIA SERIES
  // Thumbnail only
  // ===============================
  Future<Map<String, dynamic>> createSeries({
    required String title,
    required String description,
    File? file, // mobile
    Uint8List? bytes, // web
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");
    final orgId = prefs.getString("organizationId");
    final roleId = prefs.getString("roleId");

    if (userId == null || orgId == null || roleId == null) {
      throw Exception("Missing required IDs in local storage");
    }

    final uri = Uri.parse("$baseUrl/api/media/series");
    final request = http.MultipartRequest("POST", uri);

    request.fields.addAll({
      "title": title,
      "description": description,
      "createdBy": userId,
      "organization": orgId,
      "role": roleId,
    });

    if (kIsWeb && bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          "thumbnail",
          bytes,
          filename: "thumbnail.png",
        ),
      );
    } else if (!kIsWeb && file != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "thumbnail",
          file.path,
          filename: "thumbnail.png",
        ),
      );
    }

    final streamed = await request.send().timeout(_timeout);
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode >= 400) {
      throw Exception("Create series failed: ${response.body}");
    }

    return response.body.isNotEmpty
        ? jsonDecode(utf8.decode(response.bodyBytes))
        : {};
  }

  // ===============================
  // GET SERIES BY FILTER
  // ===============================
  Future<List<dynamic>> getSeriesByFilter({
    String? userId,
    String? organizationId,
  }) async {
    final params = <String, String>{};
    if (userId != null) params["userId"] = userId;
    if (organizationId != null) params["organizationId"] = organizationId;

    final uri = Uri.parse("$baseUrl/api/media/series/filter")
        .replace(queryParameters: params);

    final response = await http.get(uri).timeout(_timeout);
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    return decoded is List ? decoded : [];
  }

  // ===============================
  // GET SERIES BY ID
  // ===============================
  Future<Map<String, dynamic>> getSeriesById(String id) async {
    final response = await http
        .get(Uri.parse("$baseUrl/api/media/series/$id"))
        .timeout(_timeout);

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  // ===============================
  // UPDATE SERIES (Thumbnail optional)
  // ===============================
  Future<Map<String, dynamic>> updateSeries({
    required String id,
    String? title,
    String? description,
    File? file,
    Uint8List? bytes,
  }) async {
    final uri = Uri.parse("$baseUrl/api/media/series/$id");
    final request = http.MultipartRequest("PUT", uri);

    if (title != null) request.fields["title"] = title;
    if (description != null) request.fields["description"] = description;

    if (kIsWeb && bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          "thumbnail",
          bytes,
          filename: "thumbnail.png",
        ),
      );
    } else if (!kIsWeb && file != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "thumbnail",
          file.path,
          filename: "thumbnail.png",
        ),
      );
    }

    final streamed = await request.send().timeout(_timeout);
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode >= 400) {
      throw Exception("Update series failed: ${response.body}");
    }

    return response.body.isNotEmpty
        ? jsonDecode(utf8.decode(response.bodyBytes))
        : {};
  }

  // ===============================
  // DELETE SERIES
  // ===============================
  Future<Map<String, dynamic>> deleteSeries(String id) async {
    final response = await http
        .delete(Uri.parse("$baseUrl/api/media/series/$id"))
        .timeout(_timeout);

    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}
