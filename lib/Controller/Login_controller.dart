import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../View_model/Authentication_state.dart';
import '../environmental variables.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identifier': identifier, 'password': password}),
      );

      final responseData = jsonDecode(response.body);
      print("🔐 Login Status: ${response.statusCode}");
      print("📦 Login Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        // 🔐 Tokens
        await prefs.setString('accessToken', responseData['accessToken']);
        await prefs.setString('refreshToken', responseData['refreshToken']);

        // 👤 User Info
        final user = responseData['user'];
        if (user != null) {
          await prefs.setString('userRole', user['role'] ?? '');
          await prefs.setString('username', user['username'] ?? '');
          await prefs.setString('userId', user['userId'] ?? '');

          // 🏢 Organization Info
          final org = user['organization'];
          if (org != null) {
            await prefs.setString('organizationId', org['_id'] ?? '');
            await prefs.setString('organizationName', org['name'] ?? '');
            await prefs.setString('orgUniqueId', org['orgId'] ?? '');
          }

          // ✅ Debug log all saved data
          print("✅ Stored in SharedPreferences:");
          print("🔑 Access Token: ${prefs.getString('accessToken')}");
          print("🔁 Refresh Token: ${prefs.getString('refreshToken')}");
          print("👤 Username: ${prefs.getString('username')}");
          print("🆔 User ID: ${prefs.getString('userId')}");
          print("🛡️ Role: ${prefs.getString('userRole')}");
          print("🏢 Org ID: ${prefs.getString('organizationId')}");
          print("🏷️ Org Name: ${prefs.getString('organizationName')}");
          print("📛 Org Unique ID: ${prefs.getString('orgUniqueId')}");
        }
      }

      return {
        'status': response.statusCode,
        'body': response.body,
        'parsed': responseData,
      };
    } catch (e) {
      print("❌ Login error: $e");
      return {
        'status': 500,
        'body': 'Login exception',
        'parsed': {'error': 'Unexpected error'},
      };
    }
  }

  Future<String?> refreshAccessToken(AuthState authState) async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    print('[ℹ️] Using refresh token: $refreshToken');

    if (refreshToken == null) return null;

    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/refresh"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    print('[🔁] Refresh response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await prefs.setString('accessToken', data['accessToken']);
      await prefs.setString('refreshToken', data['refreshToken']);

      // ✅ Debug log after refresh
      print("✅ Token refreshed:");
      print("🔑 New Access Token: ${prefs.getString('accessToken')}");
      print("🔁 New Refresh Token: ${prefs.getString('refreshToken')}");

      return data['accessToken'];
    } else {
      await logout(authState);
      return null;
    }
  }

  Future<void> logout(AuthState authState) async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      await http.post(
        Uri.parse("$baseUrl/api/auth/logout"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );
    }

    await prefs.clear();
    authState.logout();
    print('🚪 Logged out and cleared SharedPreferences');
  }

  Future<void> testPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    print("haredPreferences Test:");
    print("Access Token: ${prefs.getString('accessToken')}");
    print("Refresh Token: ${prefs.getString('refreshToken')}");
    print("Username: ${prefs.getString('username')}");
    print("User ID: ${prefs.getString('userId')}");
    print("Role: ${prefs.getString('userRole')}");
  }
}
