// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../environmental variables.dart';
//
// class MediaSeriesService {
//
//   // 🔹 Create Media Series
//   Future<Map<String, dynamic>> createSeries({
//     required String title,
//     required String description,
//     required String thumbnail,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//
//     final userId = prefs.getString("userId");
//     final orgId = prefs.getString("organizationId");
//     final roleId = prefs.getString("roleId");
//
//     final response = await http.post(
//       Uri.parse("$baseUrl/api/media/series"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "title": title,
//         "description": description,
//         "thumbnail": thumbnail,
//         "createdBy": userId,
//         "organization": orgId,
//         "role": roleId,
//       }),
//     );
//
//     return jsonDecode(response.body);
//   }
//
//   // 🔹 Get All Series
//   Future<List<dynamic>> getSeries() async {
//     final response = await http.get(Uri.parse("$baseUrl/api/media/series"));
//     return jsonDecode(response.body);
//   }
//
//   // 🔹 Get Series by ID
//   Future<Map<String, dynamic>> getSeriesById(String id) async {
//     final response = await http.get(Uri.parse("$baseUrl/api/media/series/$id"));
//     return jsonDecode(response.body);
//   }
//
//   // 🔹 Update Series by ID
//   Future<Map<String, dynamic>> updateSeries({
//     required String id,
//     String? title,
//     String? description,
//     String? thumbnail,
//   }) async {
//     final response = await http.put(
//       Uri.parse("$baseUrl/api/media/series/$id"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "title": title,
//         "description": description,
//         "thumbnail": thumbnail,
//       }),
//     );
//
//     return jsonDecode(response.body);
//   }
//
//   // 🔹 Delete Series by ID
//   Future<Map<String, dynamic>> deleteSeries(String id) async {
//     final response = await http.delete(Uri.parse("$baseUrl/api/media/series/$id"));
//     return jsonDecode(response.body);
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../environmental variables.dart';

class MediaSeriesService {
  // 🔹 Create Media Series
  // Future<Map<String, dynamic>> createSeries({
  //   required String title,
  //   required String description,
  //   required String thumbnail,
  //   String? userId,
  //   String? orgId,
  //   String? roleId,
  // }) async {
  //   // Use passed IDs or fallback to valid test IDs
  //   final createdBy = userId ?? "68a7f7cd27471122559a1016";
  //   final organization = orgId ?? "68a7f77c27471122559a1003";
  //   final role = roleId ?? "68a7f7cb27471122559a100b";
  //
  //   final response = await http.post(
  //     Uri.parse("$baseUrl/api/media/series"),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({
  //       "title": title,
  //       "description": description,
  //       "thumbnail": thumbnail,
  //       "createdBy": createdBy,
  //       "organization": organization,
  //       "role": role,
  //     }),
  //   );
  //
  //   print("🔹 Create Series Response: ${response.body}");
  //   return jsonDecode(response.body);
  // }

  // 🔹 Create Media Series
  Future<Map<String, dynamic>> createSeries({
    required String title,
    required String description,
    required String thumbnail,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString("userId");
    final orgId = prefs.getString("organizationId");
    final roleId = prefs.getString("roleId");

    // ✅ Validate IDs
    if (userId == null || userId.isEmpty ||
        orgId == null || orgId.isEmpty ||
        roleId == null || roleId.isEmpty) {
      throw Exception(
          "Missing required IDs: userId, organizationId, or roleId in local storage.");
    }

    final response = await http.post(
      Uri.parse("$baseUrl/api/media/series"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
        "thumbnail": thumbnail,
        "createdBy": userId,
        "organization": orgId,
        "role": roleId,
      }),
    );

    print("🔹 Create Series Response: ${response.body}");
    return jsonDecode(response.body);
  }

  // 🔹 Get All Series
  Future<List<dynamic>> getSeries() async {
    final response = await http.get(Uri.parse("$baseUrl/api/media/series"));
    final decoded = jsonDecode(response.body);
    if (decoded is List) return decoded;
    return [];
  }

  // 🔹 Get Series by Filter (userId, organizationId)
  Future<List<dynamic>> getSeriesByFilter({
    String? userId,
    String? organizationId,
  }) async {
    final queryParams = <String, String>{};
    if (userId != null) queryParams["userId"] = userId;
    if (organizationId != null) queryParams["organizationId"] = organizationId;

    final uri = Uri.parse("$baseUrl/api/media/series/filter")
        .replace(queryParameters: queryParams);

    final response = await http.get(uri);
    final decoded = jsonDecode(response.body);
    if (decoded is List) return decoded;
    return [];
  }

  // 🔹 Get Series by ID
  Future<Map<String, dynamic>> getSeriesById(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/api/media/series/$id"));
    return jsonDecode(response.body);
  }

  // 🔹 Update Series by ID
  Future<Map<String, dynamic>> updateSeries({
    required String id,
    String? title,
    String? description,
    String? thumbnail,
  }) async {
    final body = <String, dynamic>{};
    if (title != null) body["title"] = title;
    if (description != null) body["description"] = description;
    if (thumbnail != null) body["thumbnail"] = thumbnail;

    final response = await http.put(
      Uri.parse("$baseUrl/api/media/series/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }

  // 🔹 Delete Series by ID
  Future<Map<String, dynamic>> deleteSeries(String id) async {
    final response =
    await http.delete(Uri.parse("$baseUrl/api/media/series/$id"));
    return jsonDecode(response.body);
  }
}
