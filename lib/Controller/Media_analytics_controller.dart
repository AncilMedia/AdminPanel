// // // // // // services/analytics_service.dart
// // // // // import 'dart:convert';
// // // // // import 'package:http/http.dart' as http;
// // // // //
// // // // // import '../environmental variables.dart';
// // // // //
// // // // // class AnalyticsService {
// // // // //   // Fetch all media analytics (paginated)
// // // // //   static Future<Map<String, dynamic>?> getAllMediaAnalytics({
// // // // //     int page = 1,
// // // // //     int limit = 15,
// // // // //   }) async {
// // // // //     try {
// // // // //       final response = await http.get(
// // // // //         Uri.parse("$baseUrl/api/media/analytics?page=$page&limit=$limit"),
// // // // //         headers: {"Content-Type": "application/json"},
// // // // //       );
// // // // //
// // // // //       if (response.statusCode == 200) {
// // // // //         return jsonDecode(response.body) as Map<String, dynamic>;
// // // // //       }
// // // // //       print("Failed to fetch all media analytics: ${response.body}");
// // // // //       return null;
// // // // //     } catch (e) {
// // // // //       print("Error fetching all media analytics: $e");
// // // // //       return null;
// // // // //     }
// // // // //   }
// // // // //
// // // // //   // Fetch single media item analytics
// // // // //   static Future<Map<String, dynamic>?> getMediaAnalytics(String mediaItemId) async {
// // // // //     try {
// // // // //       final response = await http.get(
// // // // //         Uri.parse("$baseUrl/api/media/analytics/$mediaItemId"),
// // // // //         headers: {"Content-Type": "application/json"},
// // // // //       );
// // // // //
// // // // //       if (response.statusCode == 200) {
// // // // //         return jsonDecode(response.body) as Map<String, dynamic>;
// // // // //       }
// // // // //       print("Failed to fetch media analytics: ${response.body}");
// // // // //       return null;
// // // // //     } catch (e) {
// // // // //       print("Error fetching media analytics: $e");
// // // // //       return null;
// // // // //     }
// // // // //   }
// // // // // }
// // // //
// // // //
// // // //
// // // // // services/analytics_service.dart
// // // // import 'dart:convert';
// // // // import 'package:http/http.dart' as http;
// // // // import '../environmental variables.dart';
// // // //
// // // // class AnalyticsService {
// // // //   // ---------------------------
// // // //   // Fetch all media analytics (paginated)
// // // //   // ---------------------------
// // // //   static Future<Map<String, dynamic>?> getAllMediaAnalytics({
// // // //     int page = 1,
// // // //     int limit = 15,
// // // //   }) async {
// // // //     try {
// // // //       final response = await http.get(
// // // //         Uri.parse("$baseUrl/api/media/analytics?page=$page&limit=$limit"),
// // // //         headers: {"Content-Type": "application/json"},
// // // //       ).timeout(const Duration(seconds: 10));
// // // //
// // // //       if (response.statusCode == 200) {
// // // //         return jsonDecode(response.body) as Map<String, dynamic>;
// // // //       }
// // // //
// // // //       print("Failed to fetch all media analytics: ${response.body}");
// // // //       return null;
// // // //     } catch (e) {
// // // //       print("Error fetching all media analytics: $e");
// // // //       return null;
// // // //     }
// // // //   }
// // // //
// // // //   // ---------------------------
// // // //   // Fetch single media item analytics
// // // //   // ---------------------------
// // // //   static Future<Map<String, dynamic>?> getMediaAnalytics(String mediaItemId) async {
// // // //     try {
// // // //       final response = await http.get(
// // // //         Uri.parse("$baseUrl/api/media/analytics/$mediaItemId"),
// // // //         headers: {"Content-Type": "application/json"},
// // // //       ).timeout(const Duration(seconds: 10));
// // // //
// // // //       if (response.statusCode == 200) {
// // // //         return jsonDecode(response.body) as Map<String, dynamic>;
// // // //       }
// // // //
// // // //       print("Failed to fetch media analytics: ${response.body}");
// // // //       return null;
// // // //     } catch (e) {
// // // //       print("Error fetching media analytics: $e");
// // // //       return null;
// // // //     }
// // // //   }
// // // //
// // // //   // ---------------------------
// // // //   // Fetch month-wise aggregated analytics (for charts)
// // // //   // ---------------------------
// // // //   static Future<List<Map<String, dynamic>>?> getMonthlyAnalytics() async {
// // // //     try {
// // // //       final response = await http.get(
// // // //         Uri.parse("$baseUrl/api/media/analytics/monthly"),
// // // //         headers: {"Content-Type": "application/json"},
// // // //       ).timeout(const Duration(seconds: 10));
// // // //
// // // //       if (response.statusCode == 200) {
// // // //         return List<Map<String, dynamic>>.from(jsonDecode(response.body));
// // // //       }
// // // //
// // // //       print("Failed to fetch monthly analytics: ${response.body}");
// // // //       return null;
// // // //     } catch (e) {
// // // //       print("Error fetching monthly analytics: $e");
// // // //       return null;
// // // //     }
// // // //   }
// // // // }
// // //
// // //
// // // // services/analytics_service.dart
// // // import 'dart:convert';
// // // import 'package:http/http.dart' as http;
// // // import '../environmental variables.dart';
// // //
// // // class AnalyticsService {
// // //   // ---------------------------
// // //   // Fetch all media analytics (paginated + sortable)
// // //   // ---------------------------
// // //   static Future<Map<String, dynamic>?> getAllMediaAnalytics({
// // //     int page = 1,
// // //     int limit = 15,
// // //     String sortField = "date", // optional: "date", "plays", etc.
// // //     String sortOrder = "desc", // "asc" or "desc"
// // //   }) async {
// // //     try {
// // //       final uri = Uri.parse(
// // //         "$baseUrl/api/media/analytics"
// // //             "?page=$page&limit=$limit&sortField=$sortField&sortOrder=$sortOrder",
// // //       );
// // //
// // //       final response = await http.get(
// // //         uri,
// // //         headers: {"Content-Type": "application/json"},
// // //       ).timeout(const Duration(seconds: 10));
// // //
// // //       if (response.statusCode == 200) {
// // //         return jsonDecode(response.body) as Map<String, dynamic>;
// // //       }
// // //
// // //       print("❌ Failed to fetch all media analytics: ${response.body}");
// // //       return null;
// // //     } catch (e) {
// // //       print("⚠️ Error fetching all media analytics: $e");
// // //       return null;
// // //     }
// // //   }
// // //
// // //   // ---------------------------
// // //   // Fetch single media item analytics (month-wise chart)
// // //   // ---------------------------
// // //   static Future<Map<String, dynamic>?> getMediaAnalytics(String mediaItemId) async {
// // //     try {
// // //       final uri = Uri.parse("$baseUrl/api/media/analytics/$mediaItemId");
// // //
// // //       final response = await http.get(
// // //         uri,
// // //         headers: {"Content-Type": "application/json"},
// // //       ).timeout(const Duration(seconds: 10));
// // //
// // //       if (response.statusCode == 200) {
// // //         return jsonDecode(response.body) as Map<String, dynamic>;
// // //       }
// // //
// // //       print("❌ Failed to fetch media analytics: ${response.body}");
// // //       return null;
// // //     } catch (e) {
// // //       print("⚠️ Error fetching media analytics: $e");
// // //       return null;
// // //     }
// // //   }
// // //
// // //   // ---------------------------
// // //   // Fetch global dashboard analytics (summary + month-wise chart)
// // //   // ---------------------------
// // //   static Future<Map<String, dynamic>?> getGlobalAnalytics() async {
// // //     try {
// // //       final uri = Uri.parse("$baseUrl/api/media/analytics/dashboard");
// // //
// // //       final response = await http.get(
// // //         uri,
// // //         headers: {"Content-Type": "application/json"},
// // //       ).timeout(const Duration(seconds: 10));
// // //
// // //       if (response.statusCode == 200) {
// // //         return jsonDecode(response.body) as Map<String, dynamic>;
// // //       }
// // //
// // //       print("❌ Failed to fetch global analytics: ${response.body}");
// // //       return null;
// // //     } catch (e) {
// // //       print("⚠️ Error fetching global analytics: $e");
// // //       return null;
// // //     }
// // //   }
// // // }
// //
// //
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import '../environmental variables.dart';
// //
// // class AnalyticsService {
// //   // ---------------------------
// //   // Fetch all media analytics (paginated + sortable)
// //   // Can optionally fetch single media item by mediaItemId
// //   // ---------------------------
// //   static Future<Map<String, dynamic>?> getAllMediaAnalytics({
// //     int page = 1,
// //     int limit = 15,
// //     String sortField = "date",
// //     String sortOrder = "desc",
// //     String? mediaItemId,
// //   }) async {
// //     try {
// //       final queryParams = {
// //         "page": "$page",
// //         "limit": "$limit",
// //         "sortField": sortField,
// //         "sortOrder": sortOrder,
// //       };
// //
// //       final uri = mediaItemId != null
// //           ? Uri.parse("$baseUrl/api/media/analytics/$mediaItemId")
// //           : Uri.parse("$baseUrl/api/media/analytics")
// //           .replace(queryParameters: queryParams);
// //
// //       final response = await http.get(
// //         uri,
// //         headers: {"Content-Type": "application/json"},
// //       ).timeout(const Duration(seconds: 10));
// //
// //       if (response.statusCode == 200) {
// //         return jsonDecode(response.body) as Map<String, dynamic>;
// //       }
// //
// //       print("❌ Failed to fetch analytics: ${response.body}");
// //       return null;
// //     } catch (e) {
// //       print("⚠️ Error fetching analytics: $e");
// //       return null;
// //     }
// //   }
// //
// //   // ---------------------------
// //   // Fetch global dashboard analytics (summary + month-wise chart)
// //   // ---------------------------
// //   static Future<Map<String, dynamic>?> getGlobalAnalytics() async {
// //     try {
// //       final uri = Uri.parse("$baseUrl/api/media/analytics/dashboard");
// //
// //       final response = await http.get(
// //         uri,
// //         headers: {"Content-Type": "application/json"},
// //       ).timeout(const Duration(seconds: 10));
// //
// //       if (response.statusCode == 200) {
// //         return jsonDecode(response.body) as Map<String, dynamic>;
// //       }
// //
// //       print("❌ Failed to fetch global analytics: ${response.body}");
// //       return null;
// //     } catch (e) {
// //       print("⚠️ Error fetching global analytics: $e");
// //       return null;
// //     }
// //   }
// // }
//
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../environmental variables.dart';
//
// class AnalyticsService {
//   // ---------------------------
//   // Fetch all media analytics (paginated + sortable)
//   // Can optionally fetch single media item by mediaItemId
//   // Can optionally filter by startDate and endDate
//   // ---------------------------
//   static Future<Map<String, dynamic>?> getAllMediaAnalytics({
//     int page = 1,
//     int limit = 15,
//     String sortField = "date",
//     String sortOrder = "desc",
//     String? mediaItemId,
//     DateTime? startDate,
//     DateTime? endDate,
//   }) async {
//     try {
//       final queryParams = {
//         "page": "$page",
//         "limit": "$limit",
//         "sortField": sortField,
//         "sortOrder": sortOrder,
//         if (startDate != null) "startDate": startDate.toIso8601String(),
//         if (endDate != null) "endDate": endDate.toIso8601String(),
//       };
//
//       final uri = mediaItemId != null
//           ? Uri.parse("$baseUrl/api/media/analytics/$mediaItemId")
//           .replace(queryParameters: queryParams)
//           : Uri.parse("$baseUrl/api/media/analytics")
//           .replace(queryParameters: queryParams);
//
//       final response = await http.get(
//         uri,
//         headers: {"Content-Type": "application/json"},
//       ).timeout(const Duration(seconds: 10));
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         if (json is Map<String, dynamic>) return json;
//       }
//
//       print("❌ Failed to fetch analytics: ${response.body}");
//       return null;
//     } catch (e) {
//       print("⚠️ Error fetching analytics: $e");
//       return null;
//     }
//   }
//
//   // ---------------------------
//   // Fetch global dashboard analytics (summary + month-wise chart)
//   // ---------------------------
//   static Future<Map<String, dynamic>?> getGlobalAnalytics() async {
//     try {
//       final uri = Uri.parse("$baseUrl/api/media/analytics/dashboard");
//
//       final response = await http.get(
//         uri,
//         headers: {"Content-Type": "application/json"},
//       ).timeout(const Duration(seconds: 10));
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         if (json is Map<String, dynamic>) return json;
//       }
//
//       print("❌ Failed to fetch global analytics: ${response.body}");
//       return null;
//     } catch (e) {
//       print("⚠️ Error fetching global analytics: $e");
//       return null;
//     }
//   }
// }


import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../environmental variables.dart';

class AnalyticsService {
  // final String baseUrl/api/media;
  //
  // AnalyticsService({required this.baseUrl});

  /// Fetch all media analytics with optional filters
  Future<Map<String, dynamic>> getAllMediaAnalytics({
    String? mediaItemId,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 15,
    String sortField = 'date',
    String sortOrder = 'desc',
  }) async {
    try {
      final queryParameters = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        'sortField': sortField,
        'sortOrder': sortOrder,
      };

      if (mediaItemId != null) queryParameters['mediaItemId'] = mediaItemId;
      if (startDate != null) queryParameters['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParameters['endDate'] = endDate.toIso8601String();

      final uri = Uri.parse('$baseUrl/api/media/analytics').replace(queryParameters: queryParameters);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load analytics: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print("AnalyticsService Error: $e");
      rethrow;
    }
  }

  /// Fetch single media item analytics
  Future<Map<String, dynamic>> getSingleMediaAnalytics(String mediaItemId) async {
    try {
      final uri = Uri.parse('$baseUrl/api/media/analytics/$mediaItemId');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load media analytics: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print("AnalyticsService Error: $e");
      rethrow;
    }
  }

  /// Log a play event
  Future<Map<String, dynamic>> logPlayEvent({
    required String mediaItemId,
    required String userId,
    int playedDuration = 0,
    String device = 'other',
    String? sessionId,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/media/analytics/log');

      final body = json.encode({
        'mediaItemId': mediaItemId,
        'userId': userId,
        'playedDuration': playedDuration,
        'device': device,
        'sessionId': sessionId,
      });

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to log play event: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print("AnalyticsService Error: $e");
      rethrow;
    }
  }
}
