import 'dart:convert';
import 'package:ancilmediaadminpanel/View/Login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

        // 🔐 Save Tokens
        await prefs.setString('accessToken', responseData['accessToken']);
        await prefs.setString('refreshToken', responseData['refreshToken']);

        // 👤 Save User Info
        final user = responseData['user'];
        if (user != null) {
          await prefs.setString('userId', user['id'] ?? '');
          await prefs.setString('user_Id', user['userId'] ?? '');
          await prefs.setString('username', user['username'] ?? '');
          await prefs.setString('userRole', user['role'] ?? '');
          await prefs.setString('roleId', user['roleId'] ?? ''); // ✅ store roleId

          // 🏢 Save Organization Info
          final org = user['organization'];
          if (org != null) {
            await prefs.setString('organizationId', org['_id'] ?? '');
            // await prefs.setString('organizationId', org['organizationId'] ?? '');
            await prefs.setString('organizationName', org['name'] ?? '');
            await prefs.setString('orgUniqueId', org['orgId'] ?? '');
          }

          // ✅ Debug logs
          print("✅ Stored in SharedPreferences:");
          print("🔑 Access Token: ${prefs.getString('accessToken')}");
          print("🔁 Refresh Token: ${prefs.getString('refreshToken')}");
          print("👤 Username: ${prefs.getString('username')}");
          print("🆔 User ID: ${prefs.getString('userId')}");
          print("🛡️ Role Name: ${prefs.getString('userRole')}");
          print("🛡️ Role ID: ${prefs.getString('roleId')}"); // ✅ debug roleId
          print("🏢 Organization ID: ${prefs.getString('organizationId')}");
          print("🏷️ Organization Name: ${prefs.getString('organizationName')}");
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
      Uri.parse("$baseUrl/api/auth/refresh-token"),
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

  // Future<void> logout(AuthState authState) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final refreshToken = prefs.getString('refreshToken');
  //
  //   if (refreshToken != null) {
  //     await http.post(
  //       Uri.parse("$baseUrl/api/auth/logout"),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'refreshToken': refreshToken}),
  //     );
  //   }
  //
  //   await prefs.clear();
  //   authState.logout();
  //   print('🚪 Logged out and cleared SharedPreferences');
  // }

  Future<void> logout(AuthState authState) async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        print('📡 Notifying server of logout...');
        // We don't await this for too long to keep the UI snappy
        await http.post(
          Uri.parse("$baseUrl/api/auth/logout"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        ).timeout(const Duration(seconds: 2));
      } catch (e) {
        print('⚠️ Server logout notification failed: $e');
      }
    }

    // ALWAYS clear local data
    await prefs.clear();
    // Update the global app state
    authState.logout();
    print('🚪 Local session cleared.');
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
