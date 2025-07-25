// // // import 'dart:convert';
// // // import 'package:http/http.dart' as http;
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import '../environmental variables.dart';
// // //
// // // class AppService {
// // //   Future<String?> _getToken() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     return prefs.getString('accessToken');
// // //   }
// // //
// // //   Future<String?> _getRefreshToken() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     return prefs.getString('refreshToken');
// // //   }
// // //
// // //   Future<void> _saveTokens(String accessToken, String refreshToken) async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     await prefs.setString('accessToken', accessToken);
// // //     await prefs.setString('refreshToken', refreshToken);
// // //   }
// // //
// // //   Future<Map<String, String>> _getAuthHeaders() async {
// // //     final token = await _getToken();
// // //     return {
// // //       'Authorization': 'Bearer $token',
// // //       'Content-Type': 'application/json',
// // //     };
// // //   }
// // //
// // //   // ✅ Refresh token logic
// // //   Future<bool> _refreshAccessToken() async {
// // //     final refreshToken = await _getRefreshToken();
// // //     if (refreshToken == null) return false;
// // //
// // //     final response = await http.post(
// // //       Uri.parse('$baseUrl/api/auth/refresh'),
// // //       headers: {'Content-Type': 'application/json'},
// // //       body: jsonEncode({'refreshToken': refreshToken}),
// // //     );
// // //
// // //     print('[REFRESH TOKEN] Status: ${response.statusCode}, Body: ${response.body}');
// // //
// // //     if (response.statusCode == 200) {
// // //       final data = jsonDecode(response.body);
// // //       await _saveTokens(data['accessToken'], data['refreshToken']);
// // //       return true;
// // //     }
// // //
// // //     return false;
// // //   }
// // //
// // //   // ✅ Authenticated request with automatic refresh
// // //   Future<http.Response> _authorizedRequest(Future<http.Response> Function(Map<String, String> headers) requestFn) async {
// // //     var headers = await _getAuthHeaders();
// // //     var response = await requestFn(headers);
// // //
// // //     if (response.statusCode == 401) {
// // //       print('[AUTHORIZED REQUEST] 401 encountered. Attempting refresh...');
// // //       final refreshed = await _refreshAccessToken();
// // //       if (refreshed) {
// // //         headers = await _getAuthHeaders(); // update headers with new token
// // //         response = await requestFn(headers); // retry request
// // //       }
// // //     }
// // //
// // //     return response;
// // //   }
// // //
// // //   // ==============================
// // //   // 📱 APP API Methods
// // //   // ==============================
// // //
// // //   Future<List<dynamic>> getApps() async {
// // //     final response = await _authorizedRequest((headers) {
// // //       return http.get(Uri.parse('$baseUrl/api/apps'), headers: headers);
// // //     });
// // //
// // //     print('[getApps] Status: ${response.statusCode}, Body: ${response.body}');
// // //
// // //     if (response.statusCode == 200) {
// // //       return jsonDecode(response.body);
// // //     } else {
// // //       throw Exception('Failed to load apps');
// // //     }
// // //   }
// // //
// // //   Future<bool> createApp({required String packageName, required String appName}) async {
// // //     final response = await _authorizedRequest((headers) {
// // //       return http.post(
// // //         Uri.parse('$baseUrl/api/apps'),
// // //         headers: headers,
// // //         body: jsonEncode({'packageName': packageName, 'appName': appName}),
// // //       );
// // //     });
// // //
// // //     print('[createApp] Status: ${response.statusCode}, Body: ${response.body}');
// // //     return response.statusCode == 201;
// // //   }
// // //
// // //   Future<bool> updateApp(String id, {required String packageName, required String appName}) async {
// // //     final response = await _authorizedRequest((headers) {
// // //       return http.put(
// // //         Uri.parse('$baseUrl/api/apps/$id'),
// // //         headers: headers,
// // //         body: jsonEncode({'packageName': packageName, 'appName': appName}),
// // //       );
// // //     });
// // //
// // //     print('[updateApp] Status: ${response.statusCode}, Body: ${response.body}');
// // //     return response.statusCode == 200;
// // //   }
// // //
// // //   Future<bool> deleteApp(String id) async {
// // //     final response = await _authorizedRequest((headers) {
// // //       return http.delete(Uri.parse('$baseUrl/api/apps/$id'), headers: headers);
// // //     });
// // //
// // //     print('[deleteApp] Status: ${response.statusCode}, Body: ${response.body}');
// // //     return response.statusCode == 200;
// // //   }
// // //
// // //   Future<Map<String, dynamic>?> getAppById(String id) async {
// // //     final response = await _authorizedRequest((headers) {
// // //       return http.get(Uri.parse('$baseUrl/api/apps/$id'), headers: headers);
// // //     });
// // //
// // //     print('[getAppById] Status: ${response.statusCode}, Body: ${response.body}');
// // //
// // //     if (response.statusCode == 200) {
// // //       return jsonDecode(response.body);
// // //     } else {
// // //       return null;
// // //     }
// // //   }
// // //
// // //   Future<bool> assignAppToOrganization(String orgId, String appId) async {
// // //     final response = await _authorizedRequest((headers) {
// // //       return http.patch(
// // //         Uri.parse('$baseUrl/api/organization/$orgId/assign-app'),
// // //         headers: headers,
// // //         body: jsonEncode({'appId': appId}),
// // //       );
// // //     });
// // //
// // //     print('[assignAppToOrganization] Status: ${response.statusCode}, Body: ${response.body}');
// // //     return response.statusCode == 200;
// // //   }
// // // }
// //
// //
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../environmental variables.dart';
// //
// // class AppService {
// //   Future<String?> _getToken() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString('accessToken');
// //   }
// //
// //   Future<String?> _getRefreshToken() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString('refreshToken');
// //   }
// //
// //   Future<void> _saveTokens(String accessToken, String refreshToken) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('accessToken', accessToken);
// //     await prefs.setString('refreshToken', refreshToken);
// //   }
// //
// //   Future<Map<String, String>> _getAuthHeaders() async {
// //     final token = await _getToken();
// //     return {
// //       'Authorization': 'Bearer $token',
// //       'Content-Type': 'application/json',
// //     };
// //   }
// //
// //   // ✅ Refresh token logic
// //   Future<bool> _refreshAccessToken() async {
// //     final refreshToken = await _getRefreshToken();
// //     if (refreshToken == null) return false;
// //
// //     final response = await http.post(
// //       Uri.parse('$baseUrl/api/auth/refresh'),
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({'refreshToken': refreshToken}),
// //     ).timeout(const Duration(seconds: 10));
// //
// //     print('[REFRESH TOKEN] Status: ${response.statusCode}, Body: ${response.body}');
// //
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       await _saveTokens(data['accessToken'], data['refreshToken']);
// //       return true;
// //     }
// //
// //     return false;
// //   }
// //
// //   // ✅ Authenticated request with automatic refresh
// //   Future<http.Response> _authorizedRequest(
// //       Future<http.Response> Function(Map<String, String> headers) requestFn) async {
// //     var headers = await _getAuthHeaders();
// //     var response = await requestFn(headers);
// //
// //     if (response.statusCode == 401) {
// //       print('[AUTHORIZED REQUEST] 401 encountered. Attempting refresh...');
// //       final refreshed = await _refreshAccessToken();
// //       if (refreshed) {
// //         headers = await _getAuthHeaders(); // update headers with new token
// //         response = await requestFn(headers); // retry request
// //       }
// //     }
// //
// //     return response;
// //   }
// //
// //   // ==============================
// //   // 📱 APP API Methods
// //   // ==============================
// //
// //   Future<List<dynamic>> getApps() async {
// //     final response = await _authorizedRequest((headers) {
// //       return http
// //           .get(Uri.parse('$baseUrl/api/apps'), headers: headers)
// //           .timeout(const Duration(seconds: 10));
// //     });
// //
// //     print('[getApps] Status: ${response.statusCode}, Body: ${response.body}');
// //
// //     if (response.statusCode == 200) {
// //       final body = jsonDecode(response.body);
// //       if (body is List) {
// //         return body;
// //       } else {
// //         throw Exception('Unexpected response format');
// //       }
// //     } else {
// //       throw Exception('Failed to load apps');
// //     }
// //   }
// //
// //   Future<bool> createApp({required String packageName, required String appName}) async {
// //     final response = await _authorizedRequest((headers) {
// //       return http
// //           .post(
// //         Uri.parse('$baseUrl/api/apps'),
// //         headers: headers,
// //         body: jsonEncode({'packageName': packageName, 'appName': appName}),
// //       )
// //           .timeout(const Duration(seconds: 10));
// //     });
// //
// //     print('[createApp] Status: ${response.statusCode}, Body: ${response.body}');
// //     return response.statusCode == 201;
// //   }
// //
// //   Future<bool> updateApp(String id, {required String packageName, required String appName}) async {
// //     final response = await _authorizedRequest((headers) {
// //       return http
// //           .put(
// //         Uri.parse('$baseUrl/api/apps/$id'),
// //         headers: headers,
// //         body: jsonEncode({'packageName': packageName, 'appName': appName}),
// //       )
// //           .timeout(const Duration(seconds: 10));
// //     });
// //
// //     print('[updateApp] Status: ${response.statusCode}, Body: ${response.body}');
// //     return response.statusCode == 200;
// //   }
// //
// //   Future<bool> deleteApp(String id) async {
// //     final response = await _authorizedRequest((headers) {
// //       return http
// //           .delete(Uri.parse('$baseUrl/api/apps/$id'), headers: headers)
// //           .timeout(const Duration(seconds: 10));
// //     });
// //
// //     print('[deleteApp] Status: ${response.statusCode}, Body: ${response.body}');
// //     return response.statusCode == 200;
// //   }
// //
// //   Future<Map<String, dynamic>?> getAppById(String id) async {
// //     final response = await _authorizedRequest((headers) {
// //       return http
// //           .get(Uri.parse('$baseUrl/api/apps/$id'), headers: headers)
// //           .timeout(const Duration(seconds: 10));
// //     });
// //
// //     print('[getAppById] Status: ${response.statusCode}, Body: ${response.body}');
// //
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       if (data is Map<String, dynamic>) return data;
// //     }
// //     return null;
// //   }
// //
// //   Future<bool> assignAppToOrganization(String orgId, String appId) async {
// //     final response = await _authorizedRequest((headers) {
// //       return http
// //           .patch(
// //         Uri.parse('$baseUrl/api/organization/$orgId/assign-app'),
// //         headers: headers,
// //         body: jsonEncode({'appId': appId}),
// //       )
// //           .timeout(const Duration(seconds: 10));
// //     });
// //
// //     print('[assignAppToOrganization] Status: ${response.statusCode}, Body: ${response.body}');
// //     return response.statusCode == 200;
// //   }
// //
// //   // Future<bool> assignAppToOrganization(String orgId, String appId) async {
// //   //   final response = await _authorizedRequest((headers) {
// //   //     return http
// //   //         .patch(
// //   //       Uri.parse('$baseUrl/api/organization/$orgId/assign-app'),
// //   //       headers: headers,
// //   //       body: jsonEncode({'appId': appId}),
// //   //     )
// //   //         .timeout(const Duration(seconds: 10));
// //   //   });
// //   //
// //   //   print('[assignAppToOrganization] Status: ${response.statusCode}, Body: ${response.body}');
// //   //   return response.statusCode == 200;
// //   // }
// // }
//
//
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../environmental variables.dart';
//
// class AppService {
//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('accessToken');
//   }
//
//   Future<String?> _getRefreshToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('refreshToken');
//   }
//
//   Future<void> _saveTokens(String accessToken, String refreshToken) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('accessToken', accessToken);
//     await prefs.setString('refreshToken', refreshToken);
//   }
//
//   Future<Map<String, String>> _getAuthHeaders() async {
//     final token = await _getToken();
//     return {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     };
//   }
//
//   Future<bool> _refreshAccessToken() async {
//     final refreshToken = await _getRefreshToken();
//     if (refreshToken == null) return false;
//
//     final response = await http.post(
//       Uri.parse('$baseUrl/api/auth/refresh'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'refreshToken': refreshToken}),
//     ).timeout(const Duration(seconds: 10));
//
//     print('[REFRESH TOKEN] Status: ${response.statusCode}, Body: ${response.body}');
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       await _saveTokens(data['accessToken'], data['refreshToken']);
//       return true;
//     }
//
//     return false;
//   }
//
//   Future<http.Response> _authorizedRequest(
//       Future<http.Response> Function(Map<String, String> headers) requestFn,
//       ) async {
//     var headers = await _getAuthHeaders();
//     var response = await requestFn(headers);
//
//     if (response.statusCode == 401) {
//       print('[AUTHORIZED REQUEST] 401 encountered. Attempting refresh...');
//       final refreshed = await _refreshAccessToken();
//       if (refreshed) {
//         headers = await _getAuthHeaders();
//         response = await requestFn(headers);
//       }
//     }
//
//     return response;
//   }
//
//   // ==============================
//   // 📱 APP API Methods
//   // ==============================
//
//   Future<List<dynamic>> getApps() async {
//     final response = await _authorizedRequest((headers) {
//       return http.get(
//         Uri.parse('$baseUrl/api/apps'),
//         headers: headers,
//       ).timeout(const Duration(seconds: 10));
//     });
//
//     print('[getApps] Status: ${response.statusCode}, Body: ${response.body}');
//
//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body);
//       if (body is List) {
//         return body;
//       } else {
//         throw Exception('Unexpected response format');
//       }
//     } else {
//       throw Exception('Failed to load apps');
//     }
//   }
//
//   Future<bool> createApp({required String packageName, required String appName}) async {
//     final response = await _authorizedRequest((headers) {
//       return http.post(
//         Uri.parse('$baseUrl/api/apps'),
//         headers: headers,
//         body: jsonEncode({'packageName': packageName, 'appName': appName}),
//       ).timeout(const Duration(seconds: 10));
//     });
//
//     print('[createApp] Status: ${response.statusCode}, Body: ${response.body}');
//     return response.statusCode == 201;
//   }
//
//   Future<bool> updateApp(String id, {required String packageName, required String appName}) async {
//     final response = await _authorizedRequest((headers) {
//       return http.put(
//         Uri.parse('$baseUrl/api/apps/$id'),
//         headers: headers,
//         body: jsonEncode({'packageName': packageName, 'appName': appName}),
//       ).timeout(const Duration(seconds: 10));
//     });
//
//     print('[updateApp] Status: ${response.statusCode}, Body: ${response.body}');
//     return response.statusCode == 200;
//   }
//
//   Future<bool> deleteApp(String id) async {
//     final response = await _authorizedRequest((headers) {
//       return http.delete(
//         Uri.parse('$baseUrl/api/apps/$id'),
//         headers: headers,
//       ).timeout(const Duration(seconds: 10));
//     });
//
//     print('[deleteApp] Status: ${response.statusCode}, Body: ${response.body}');
//     return response.statusCode == 200;
//   }
//
//   Future<Map<String, dynamic>?> getAppById(String id) async {
//     final response = await _authorizedRequest((headers) {
//       return http.get(
//         Uri.parse('$baseUrl/api/apps/$id'),
//         headers: headers,
//       ).timeout(const Duration(seconds: 10));
//     });
//
//     print('[getAppById] Status: ${response.statusCode}, Body: ${response.body}');
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data is Map<String, dynamic>) return data;
//     }
//     return null;
//   }
//   Future<bool> assignAppToOrganization(String orgMongoId, String appMongoId) async {
//     final response = await _authorizedRequest((headers) {
//       return http.post(
//         Uri.parse('$baseUrl/api/organization/$orgMongoId/assign-app'),
//         headers: {
//           ...headers,
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'appId': appMongoId}),
//       ).timeout(const Duration(seconds: 10));
//     });
//
//     print('[assignAppToOrganization] Status: ${response.statusCode}');
//     print('[assignAppToOrganization] Response: ${response.body}');
//
//     return response.statusCode == 200;
//   }
//
// }




import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../environmental variables.dart';

class AppService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<bool> _refreshAccessToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveTokens(data['accessToken'], data['refreshToken']);
      return true;
    }
    return false;
  }

  Future<http.Response> _authorizedRequest(
      Future<http.Response> Function(Map<String, String>) requestFn) async {
    var headers = await _getAuthHeaders();
    var response = await requestFn(headers);

    if (response.statusCode == 401) {
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        headers = await _getAuthHeaders();
        response = await requestFn(headers);
      }
    }
    return response;
  }

  // 🔹 Get all apps
  Future<List<dynamic>> getApps() async {
    final response = await _authorizedRequest((headers) {
      return http.get(
        Uri.parse('$baseUrl/api/apps'),
        headers: headers,
      );
    });

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) return body;
    }
    throw Exception('Failed to fetch apps');
  }

  // 🔹 Get app by ID
  Future<Map<String, dynamic>?> getAppById(String id) async {
    final response = await _authorizedRequest((headers) {
      return http.get(
        Uri.parse('$baseUrl/api/apps/$id'),
        headers: headers,
      );
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // 🔹 Create new app
  Future<bool> createApp({
    required String packageName,
    required String appName,
  }) async {
    final response = await _authorizedRequest((headers) {
      return http.post(
        Uri.parse('$baseUrl/api/apps'),
        headers: headers,
        body: jsonEncode({'packageName': packageName, 'appName': appName}),
      );
    });
    return response.statusCode == 201;
  }

  // 🔹 Update app
  Future<bool> updateApp({
    required String id,
    required String packageName,
    required String appName,
  }) async {
    final response = await _authorizedRequest((headers) {
      return http.put(
        Uri.parse('$baseUrl/api/apps/$id'),
        headers: headers,
        body: jsonEncode({'packageName': packageName, 'appName': appName}),
      );
    });
    return response.statusCode == 200;
  }

  // 🔹 Delete app
  Future<bool> deleteApp(String id) async {
    final response = await _authorizedRequest((headers) {
      return http.delete(
        Uri.parse('$baseUrl/api/apps/$id'),
        headers: headers,
      );
    });
    return response.statusCode == 200;
  }

  // 🔹 Assign org to app
  Future<bool> assignOrgToApp(String appMongoId, String orgMongoId) async {
    final response = await _authorizedRequest((headers) {
      return http.put(
        Uri.parse('$baseUrl/api/apps/$appMongoId/assign-org'),
        headers: headers,
        body: jsonEncode({'organizationId': orgMongoId}),
      );
    });
    return response.statusCode == 200;
  }
}
