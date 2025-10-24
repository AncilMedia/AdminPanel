// // import 'dart:convert';
// // import 'package:flutter/foundation.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:intl/intl.dart';
// // import '../environmental variables.dart';
// //
// // class AnalyticsService {
// //   /// ✅ Fetch all media analytics (with optional filters)
// //   Future<Map<String, dynamic>> getAllMediaAnalytics({
// //     String? mediaItemId,
// //     DateTime? startDate,
// //     DateTime? endDate,
// //     int page = 1,
// //     int limit = 15,
// //     String sortField = 'date',
// //     String sortOrder = 'desc',
// //     bool useDashboard = false,
// //   }) async {
// //     try {
// //       final Map<String, String> queryParameters = {};
// //
// //       // ✅ Only add if not null
// //       if (page > 0) queryParameters['page'] = page.toString();
// //       if (limit > 0) queryParameters['limit'] = limit.toString();
// //
// //       queryParameters['sortField'] = sortField;
// //       queryParameters['sortOrder'] = sortOrder;
// //
// //       if (mediaItemId != null && mediaItemId.isNotEmpty) {
// //         queryParameters['mediaItemId'] = mediaItemId;
// //       }
// //
// //       if (startDate != null) {
// //         queryParameters['startDate'] = DateFormat('yyyy-MM-dd').format(startDate);
// //       }
// //
// //       if (endDate != null) {
// //         queryParameters['endDate'] = DateFormat('yyyy-MM-dd').format(endDate);
// //       }
// //
// //       final endpoint = useDashboard ? 'dashboard' : '';
// //       final uri = Uri.parse('$baseUrl/api/media/analytics/$endpoint')
// //           .replace(queryParameters: queryParameters);
// //
// //       print("🌐 GET: $uri");
// //
// //       final response = await http.get(uri);
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         return data as Map<String, dynamic>;
// //       } else {
// //         throw Exception('Failed: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       if (kDebugMode) print("AnalyticsService Error: $e");
// //       rethrow;
// //     }
// //   }
// //
// //   /// ✅ Fetch analytics for a single media item
// //   Future<Map<String, dynamic>> getSingleMediaAnalytics(String mediaItemId) async {
// //     try {
// //       final uri = Uri.parse('$baseUrl/api/media/analytics/$mediaItemId');
// //       print("🌐 GET: $uri");
// //
// //       final response = await http.get(uri);
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         return data as Map<String, dynamic>;
// //       } else {
// //         throw Exception('Failed to load media analytics: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       if (kDebugMode) print("AnalyticsService Error: $e");
// //       rethrow;
// //     }
// //   }
// //
// //   /// ✅ Log a play event
// //   Future<Map<String, dynamic>> logPlayEvent({
// //     required String mediaItemId,
// //     required String userId,
// //     int playedDuration = 0,
// //     String device = 'other',
// //     String? sessionId,
// //   }) async {
// //     try {
// //       final uri = Uri.parse('$baseUrl/api/media/analytics/log');
// //
// //       final body = json.encode({
// //         'mediaItemId': mediaItemId,
// //         'userId': userId,
// //         'playedDuration': playedDuration,
// //         'device': device,
// //         'sessionId': sessionId,
// //       });
// //
// //       final response = await http.post(
// //         uri,
// //         headers: {'Content-Type': 'application/json'},
// //         body: body,
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         return data as Map<String, dynamic>;
// //       } else {
// //         throw Exception('Failed to log play event: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       if (kDebugMode) print("AnalyticsService Error: $e");
// //       rethrow;
// //     }
// //   }
// // }
//
//
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import '../environmental variables.dart';
//
// class AnalyticsService {
//   /// ✅ Fetch all media analytics (with optional filters)
//   Future<Map<String, dynamic>> getAllMediaAnalytics({
//     String? mediaItemId,
//     DateTime? startDate,
//     DateTime? endDate,
//     int page = 1,
//     int limit = 15,
//     String sortField = 'date',
//     String sortOrder = 'desc',
//     bool useDashboard = false,
//   }) async {
//     try {
//       final Map<String, String> queryParameters = {};
//
//       if (page > 0) queryParameters['page'] = page.toString();
//       if (limit > 0) queryParameters['limit'] = limit.toString();
//
//       queryParameters['sortField'] = sortField;
//       queryParameters['sortOrder'] = sortOrder;
//
//       if (mediaItemId != null && mediaItemId.isNotEmpty) {
//         queryParameters['mediaItemId'] = mediaItemId;
//       }
//
//       if (startDate != null) {
//         queryParameters['startDate'] = DateFormat('yyyy-MM-dd').format(startDate);
//       }
//
//       if (endDate != null) {
//         queryParameters['endDate'] = DateFormat('yyyy-MM-dd').format(endDate);
//       }
//
//       final endpoint = useDashboard ? 'dashboard' : '';
//       final uri = Uri.parse('$baseUrl/api/media/analytics/$endpoint')
//           .replace(queryParameters: queryParameters);
//
//       print("🌐 GET: $uri");
//
//       final response = await http.get(uri);
//
//       print("📥 Response status: ${response.statusCode}");
//       print("📥 Response body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print("✅ Parsed Data: $data");
//         return data as Map<String, dynamic>;
//       } else {
//         throw Exception('Failed: ${response.statusCode}');
//       }
//     } catch (e) {
//       if (kDebugMode) print("AnalyticsService Error: $e");
//       rethrow;
//     }
//   }
//
//   /// ✅ Fetch analytics for a single media item
//   Future<Map<String, dynamic>> getSingleMediaAnalytics(String mediaItemId) async {
//     try {
//       final uri = Uri.parse('$baseUrl/api/media/analytics/$mediaItemId');
//       print("🌐 GET Single Media Analytics: $uri");
//
//       final response = await http.get(uri);
//
//       print("📥 Response status: ${response.statusCode}");
//       print("📥 Response body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print("✅ Parsed Data: $data");
//         return data as Map<String, dynamic>;
//       } else {
//         throw Exception('Failed to load media analytics: ${response.statusCode}');
//       }
//     } catch (e) {
//       if (kDebugMode) print("AnalyticsService Error: $e");
//       rethrow;
//     }
//   }
//
//   /// ✅ Log a play event
//   Future<Map<String, dynamic>> logPlayEvent({
//     required String mediaItemId,
//     required String userId,
//     int playedDuration = 0,
//     String device = 'other',
//     String? sessionId,
//   }) async {
//     try {
//       final uri = Uri.parse('$baseUrl/api/media/analytics/log');
//
//       final body = json.encode({
//         'mediaItemId': mediaItemId,
//         'userId': userId,
//         'playedDuration': playedDuration,
//         'device': device,
//         'sessionId': sessionId,
//       });
//
//       print("🌐 POST Log Play Event: $uri");
//       print("📤 Request body: $body");
//
//       final response = await http.post(
//         uri,
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );
//
//       print("📥 Response status: ${response.statusCode}");
//       print("📥 Response body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print("✅ Parsed Data: $data");
//         return data as Map<String, dynamic>;
//       } else {
//         throw Exception('Failed to log play event: ${response.statusCode}');
//       }
//     } catch (e) {
//       if (kDebugMode) print("AnalyticsService Error: $e");
//       rethrow;
//     }
//   }
// }


import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../environmental variables.dart';

class AnalyticsService {
  /// ✅ Helper to get organizationId from SharedPreferences
  Future<String?> _getOrganizationId() async {
    final prefs = await SharedPreferences.getInstance();
    final orgId = prefs.getString('organizationId');
    if (kDebugMode) print("🏢 Loaded organizationId from prefs: $orgId");
    return orgId;
  }

  /// ✅ Fetch all media analytics (with organization auto-filter)
  Future<Map<String, dynamic>> getAllMediaAnalytics({
    String? mediaItemId,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 15,
    String sortField = 'date',
    String sortOrder = 'desc',
    bool useDashboard = false,
  }) async {
    try {
      final orgId = await _getOrganizationId();

      final Map<String, String> queryParameters = {};

      if (page > 0) queryParameters['page'] = page.toString();
      if (limit > 0) queryParameters['limit'] = limit.toString();
      queryParameters['sortField'] = sortField;
      queryParameters['sortOrder'] = sortOrder;

      if (mediaItemId != null && mediaItemId.isNotEmpty) {
        queryParameters['mediaItemId'] = mediaItemId;
      }

      if (orgId != null && orgId.isNotEmpty) {
        queryParameters['organizationId'] = orgId; // ✅ auto-add org filter
      }

      if (startDate != null) {
        queryParameters['startDate'] = DateFormat('yyyy-MM-dd').format(startDate);
      }

      if (endDate != null) {
        queryParameters['endDate'] = DateFormat('yyyy-MM-dd').format(endDate);
      }

      final endpoint = useDashboard ? 'dashboard' : '';
      final uri = Uri.parse('$baseUrl/api/media/analytics/$endpoint')
          .replace(queryParameters: queryParameters);

      print("🌐 GET: $uri");

      final response = await http.get(uri);

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✅ Parsed Data: $data");
        return data as Map<String, dynamic>;
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print("AnalyticsService Error: $e");
      rethrow;
    }
  }

  /// ✅ Fetch analytics for a single media item (auto org filter)
  Future<Map<String, dynamic>> getSingleMediaAnalytics(String mediaItemId) async {
    try {
      final orgId = await _getOrganizationId();

      final queryParameters = <String, String>{};
      if (orgId != null && orgId.isNotEmpty) {
        queryParameters['organizationId'] = orgId; // ✅ auto-add org filter
      }

      final uri = Uri.parse('$baseUrl/api/media/analytics/$mediaItemId')
          .replace(queryParameters: queryParameters);

      print("🌐 GET Single Media Analytics: $uri");

      final response = await http.get(uri);

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✅ Parsed Data: $data");
        return data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load media analytics: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print("AnalyticsService Error: $e");
      rethrow;
    }
  }

  /// ✅ Log a play event (org auto-detected by backend)
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

      print("🌐 POST Log Play Event: $uri");
      print("📤 Request body: $body");

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✅ Parsed Data: $data");
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
