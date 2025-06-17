import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../environmental variables.dart';

class AuthService {
  /// Login and store tokens in SharedPreferences
  Future<Map<String, dynamic>?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data['accessToken']);
      await prefs.setString('refreshToken', data['refreshToken']);
      return data;
    } else {
      return null;
    }
  }

  /// Try refreshing the access token using the refresh token
  Future<String?> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');
    if (refreshToken == null) return null;

    final response = await http.post(
      Uri.parse("$baseUrl/refresh-token"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await prefs.setString('accessToken', data['accessToken']);
      await prefs.setString('refreshToken', data['refreshToken']);
      return data['accessToken'];
    } else {
      return null;
    }
  }

  /// Clear local storage and optionally inform backend
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': refreshToken}),
      );
    }

    await prefs.clear();
  }
}
