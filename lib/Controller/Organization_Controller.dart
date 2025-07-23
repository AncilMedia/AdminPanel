// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:ancilmediaadminpanel/environmental variables.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class OrganizationController {
//   static final String _orgUrl = '$baseUrl/api/organization';
//
//   static Future<String?> getTokenFromStorage() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('accesstoken'); // or whatever key you're using
//   }
//
//
//   // ✅ Fetch all organizations
//   static Future<List<Map<String, dynamic>>> fetchOrganizations() async {
//     try {
//       final response = await http.get(Uri.parse(_orgUrl)).timeout(const Duration(seconds: 10));
//       print("Fetch Response: ${response.statusCode} ${response.body}");
//
//       final contentType = response.headers['content-type'];
//       if (response.statusCode == 200 && contentType != null && contentType.contains('application/json')) {
//         final List orgs = json.decode(response.body);
//         return orgs.cast<Map<String, dynamic>>();
//       } else {
//         throw Exception("Invalid response: Not JSON or status != 200\n\nBody: ${response.body}");
//       }
//     } catch (e) {
//       print("Fetch error: $e");
//       rethrow;
//     }
//   }
//
//   // ✅ Fetch organization by ID
//   static Future<Map<String, dynamic>?> fetchOrganizationById(String id) async {
//     try {
//       final response = await http.get(Uri.parse("$_orgUrl/$id"));
//       print("Fetch by ID Response: ${response.statusCode} ${response.body}");
//
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         print("Failed to fetch organization by ID: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("Error fetching org by ID: $e");
//       return null;
//     }
//   }
//
//   // ✅ Create organization with admin
//   static Future<String?> createOrganizationWithAdmin({
//     required String name,
//     required String username,
//     required String email,
//     required String password,
//     required String phone,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse(_orgUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'name': name,
//           'username': username,
//           'email': email,
//           'password': password,
//           'phone': phone,
//           'createdByAdmin': true,
//         }),
//       );
//
//       print("Create Org+Admin Response: ${response.statusCode} ${response.body}");
//
//       if (response.statusCode == 201) return null;
//       final body = jsonDecode(response.body);
//       if (response.statusCode == 409) {
//         return body['error'] ?? "Conflict occurred";
//       }
//       return body['error'] ?? 'Failed to create organization with admin';
//     } catch (e) {
//       print("Create error: $e");
//       return 'Network or server error';
//     }
//   }
//
//   // ✅ Delete organization
//   static Future<bool> deleteOrganization(String id) async {
//     try {
//       final response = await http.delete(Uri.parse("$_orgUrl/$id"));
//       print("Delete Response: ${response.statusCode} ${response.body}");
//       return response.statusCode == 200;
//     } catch (e) {
//       print("Delete error: $e");
//       return false;
//     }
//   }
//
//   // ✅ Block / Unblock organization
//   static Future<bool> blockOrganization(String id, bool blocked) async {
//     try {
//       final response = await http.patch(
//         Uri.parse("$_orgUrl/$id/block"),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'blocked': blocked}),
//       );
//       print("Block/Unblock Response: ${response.statusCode} ${response.body}");
//       return response.statusCode == 200;
//     } catch (e) {
//       print("Block error: $e");
//       return false;
//     }
//   }
//
//   // ✅ Approve / Reject organization
//   static Future<bool> approveOrganization(String id, bool? approve) async {
//     try {
//       final response = await http.patch(
//         Uri.parse("$_orgUrl/$id/approve"),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'approve': approve}),
//       );
//       print("Approve/Reject Response: ${response.statusCode} ${response.body}");
//       return response.statusCode == 200;
//     } catch (e) {
//       print("Approve error: $e");
//       return false;
//     }
//   }
//
// // ✅ Assign app to organization
//   static Future<bool> assignAppToOrganization(String orgId, String appId) async {
//     try {
//       final token = await getTokenFromStorage(); // <- Replace with your token getter
//
//       final response = await http.patch(
//         Uri.parse("$_orgUrl/$orgId/assign-app"),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token', // ✅ Add this if backend uses JWT
//         },
//         body: jsonEncode({'appId': appId}),
//       );
//
//       print("Assign App Response: ${response.statusCode} ${response.body}");
//       return response.statusCode == 200;
//     } catch (e) {
//       print("Assign App Error: $e");
//       return false;
//     }
//   }
//
//   // ✅ Update organization details
//   static Future<bool> updateOrganizationDetails({
//     required String id,
//     required String name,
//     required String username,
//     required String email,
//     required String phone,
//   }) async {
//     try {
//       final response = await http.put(
//         Uri.parse("$_orgUrl/$id"),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'name': name,
//           'username': username,
//           'email': email,
//           'phone': phone,
//           'createdByAdmin': true,
//         }),
//       );
//       print("Update Response: ${response.statusCode} ${response.body}");
//       return response.statusCode == 200;
//     } catch (e) {
//       print("Update error: $e");
//       return false;
//     }
//   }
// }



import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ancilmediaadminpanel/environmental variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrganizationController {
  static final String _orgUrl = '$baseUrl/api/organization';
  static final String _authUrl = '$baseUrl/api/auth';

  // Get access token from SharedPreferences
  static Future<String?> getTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // fixed key spelling here
  }

  // Get refresh token from SharedPreferences
  static Future<String?> getRefreshTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  // Save new tokens to SharedPreferences
  static Future<void> saveTokens(String accessToken, String? refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    if (refreshToken != null) {
      await prefs.setString('refreshToken', refreshToken);
    }
  }

  // Helper: Refresh access token using refresh token
  static Future<bool> _refreshAccessToken() async {
    final refreshToken = await getRefreshTokenFromStorage();
    if (refreshToken == null) {
      print("No refresh token found.");
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse("$_authUrl/refresh-token"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'] as String?;
        final newRefreshToken = data['refreshToken'] as String?;
        if (newAccessToken != null) {
          await saveTokens(newAccessToken, newRefreshToken);
          print("Access token refreshed.");
          return true;
        }
      }
      print("Failed to refresh token: ${response.statusCode} ${response.body}");
      return false;
    } catch (e) {
      print("Error refreshing token: $e");
      return false;
    }
  }

  // Generic helper for making authorized HTTP requests with automatic token refresh
  static Future<http.Response?> _makeAuthorizedRequest(
      Future<http.Response> Function(String accessToken) requestFunc,
      ) async {
    String? accessToken = await getTokenFromStorage();

    if (accessToken == null) {
      print("No access token found.");
      return null;
    }

    http.Response response = await requestFunc(accessToken);

    if (response.statusCode == 401) {
      print("Access token expired, trying refresh...");
      final refreshed = await _refreshAccessToken();
      if (!refreshed) {
        print("Token refresh failed.");
        return response; // return original 401
      }

      accessToken = await getTokenFromStorage();
      if (accessToken == null) {
        print("No access token after refresh.");
        return response;
      }

      // Retry the original request with new token
      response = await requestFunc(accessToken);
    }

    return response;
  }

  // --- Your existing methods with minor adjustment to add token refresh support

  // ✅ Fetch all organizations (No auth assumed)
  static Future<List<Map<String, dynamic>>> fetchOrganizations() async {
    try {
      final response = await http.get(Uri.parse(_orgUrl)).timeout(const Duration(seconds: 10));
      print("Fetch Response: ${response.statusCode} ${response.body}");

      final contentType = response.headers['content-type'];
      if (response.statusCode == 200 && contentType != null && contentType.contains('application/json')) {
        final List orgs = json.decode(response.body);
        return orgs.cast<Map<String, dynamic>>();
      } else {
        throw Exception("Invalid response: Not JSON or status != 200\n\nBody: ${response.body}");
      }
    } catch (e) {
      print("Fetch error: $e");
      rethrow;
    }
  }

  // ✅ Fetch organization by ID (No auth assumed)
  static Future<Map<String, dynamic>?> fetchOrganizationById(String id) async {
    try {
      final response = await http.get(Uri.parse("$_orgUrl/$id"));
      print("Fetch by ID Response: ${response.statusCode} ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Failed to fetch organization by ID: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching org by ID: $e");
      return null;
    }
  }

  // ✅ Create organization with admin (No auth assumed, or add token if needed)
  static Future<String?> createOrganizationWithAdmin({
    required String name,
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_orgUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'username': username,
          'email': email,
          'password': password,
          'phone': phone,
          'createdByAdmin': true,
        }),
      );

      print("Create Org+Admin Response: ${response.statusCode} ${response.body}");

      if (response.statusCode == 201) return null;
      final body = jsonDecode(response.body);
      if (response.statusCode == 409) {
        return body['error'] ?? "Conflict occurred";
      }
      return body['error'] ?? 'Failed to create organization with admin';
    } catch (e) {
      print("Create error: $e");
      return 'Network or server error';
    }
  }

  // ✅ Delete organization (with auth & refresh support)
  static Future<bool> deleteOrganization(String id) async {
    final response = await _makeAuthorizedRequest(
          (token) => http.delete(
        Uri.parse("$_orgUrl/$id"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response == null) return false;

    print("Delete Response: ${response.statusCode} ${response.body}");
    return response.statusCode == 200;
  }

  // ✅ Block / Unblock organization
  static Future<bool> blockOrganization(String id, bool blocked) async {
    final response = await _makeAuthorizedRequest(
          (token) => http.patch(
        Uri.parse("$_orgUrl/$id/block"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'blocked': blocked}),
      ),
    );

    if (response == null) return false;

    print("Block/Unblock Response: ${response.statusCode} ${response.body}");
    return response.statusCode == 200;
  }

  // ✅ Approve / Reject organization
  static Future<bool> approveOrganization(String id, bool? approve) async {
    final response = await _makeAuthorizedRequest(
          (token) => http.patch(
        Uri.parse("$_orgUrl/$id/approve"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'approve': approve}),
      ),
    );

    if (response == null) return false;

    print("Approve/Reject Response: ${response.statusCode} ${response.body}");
    return response.statusCode == 200;
  }

  // ✅ Assign app to organization with automatic token refresh support
  static Future<bool> assignAppToOrganization(String orgId, String appId) async {
    final response = await _makeAuthorizedRequest(
          (token) => http.patch(
        Uri.parse("$_orgUrl/$orgId/assign-app"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'appId': appId}),
      ),
    );

    if (response == null) return false;

    print("Assign App Response: ${response.statusCode} ${response.body}");
    return response.statusCode == 200;
  }

  // ✅ Update organization details
  static Future<bool> updateOrganizationDetails({
    required String id,
    required String name,
    required String username,
    required String email,
    required String phone,
  }) async {
    final response = await _makeAuthorizedRequest(
          (token) => http.put(
        Uri.parse("$_orgUrl/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'username': username,
          'email': email,
          'phone': phone,
          'createdByAdmin': true,
        }),
      ),
    );

    if (response == null) return false;

    print("Update Response: ${response.statusCode} ${response.body}");
    return response.statusCode == 200;
  }
}
