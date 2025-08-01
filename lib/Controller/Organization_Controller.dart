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
    return prefs.getString('accessToken');
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

  // Unassign app from organization
  static Future<bool> unassignAppFromOrganization(String orgId, String appId) async {
    final response = await _makeAuthorizedRequest(
          (token) => http.patch(
        Uri.parse("$_orgUrl/$orgId/unassign-app"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'appId': appId}),
      ),
    );

    if (response == null) return false;

    print("Unassign App Response: ${response.statusCode} ${response.body}");
    return response.statusCode == 200;
  }

  // Refresh access token using refresh token
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

  // Generic helper for authorized HTTP requests with token refresh
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
      if (!refreshed) return response;

      accessToken = await getTokenFromStorage();
      if (accessToken == null) return response;

      response = await requestFunc(accessToken);
    }

    return response;
  }

  // Fetch all organizations
  static Future<List<Map<String, dynamic>>> fetchOrganizations() async {
    try {
      final response = await http.get(Uri.parse(_orgUrl)).timeout(const Duration(seconds: 10));
      print("Fetch Response: ${response.statusCode} ${response.body}");

      if (response.statusCode == 200 &&
          response.headers['content-type']?.contains('application/json') == true) {
        final List orgs = json.decode(response.body);
        return orgs.cast<Map<String, dynamic>>();
      } else {
        throw Exception("Invalid response: ${response.statusCode}");
      }
    } catch (e) {
      print("Fetch error: $e");
      rethrow;
    }
  }

  static Future<bool> assignAppToOrganization(String orgId, String appId) async {
    final response = await http.patch(
      Uri.parse("$_orgUrl/$orgId/assign-app"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'appId': appId}),
    );

    print("Assign App Response: ${response.statusCode} ${response.body}");

    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>?> fetchOrganizationById(String id) async {
    try {
      final response = await http.get(Uri.parse("$_orgUrl/$id"));
      print("Fetch by ID Response: ${response.statusCode} ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      }
    } catch (e) {
      print("Error fetching org by ID: $e");
    }
    return null;
  }

  // Create organization with admin
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
      return body['error'] ?? 'Failed to create organization';
    } catch (e) {
      print("Create error: $e");
      return 'Network or server error';
    }
  }

  // Delete organization
  static Future<bool> deleteOrganization(String id) async {
    final response = await _makeAuthorizedRequest(
          (token) => http.delete(
        Uri.parse("$_orgUrl/$id"),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response == null) return false;

    print("Delete Response: ${response.statusCode} ${response.body}");
    return response.statusCode == 200;
  }

  // Block / Unblock organization
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

  // Approve / Reject organization
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

  // Assign app to organization
  // static Future<bool> assignAppToOrganization(String orgId, String appId) async {
  //   final response = await _makeAuthorizedRequest(
  //         (token) => http.patch(
  //       Uri.parse("$_orgUrl/$orgId/assign-app"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({'appId': appId}),
  //     ),
  //   );
  //
  //   if (response == null) return false;
  //
  //   print("Assign App Response: ${response.statusCode} ${response.body}");
  //   return response.statusCode == 200;
  // }

  // Update organization details
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
