import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../environmental variables.dart';

// ======================= AUTH MANAGER =======================

class AuthManager {
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

// ======================= LOGOUT HANDLER =======================

class LogoutHandler {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static Future<void> logout() async {
    await AuthManager.clearSession();

    final context = navigatorKey.currentContext;
    if (context == null) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
          (route) => false,
    );
  }
}

// ======================= TOKEN REFRESHER =======================

class TokenRefresher {
  static bool _isRefreshing = false;

  static Future<String?> refresh() async {
    if (_isRefreshing) return null;

    _isRefreshing = true;

    final refresh = await AuthManager.getRefreshToken();
    if (refresh == null) {
      await LogoutHandler.logout();
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refresh}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccess = data['accessToken'];

        await AuthManager.saveAccessToken(newAccess);
        return newAccess;
      }

      await LogoutHandler.logout();
      return null;
    } catch (_) {
      await LogoutHandler.logout();
      return null;
    } finally {
      _isRefreshing = false;
    }
  }
}

// ======================= API CLIENT =======================

class ApiClient {
  static Future<http.Response> get(String url) async {
    return _secureRequest(
          () async {
        final token = await AuthManager.getAccessToken();
        return http.get(
          Uri.parse(url),
          headers: _headers(token),
        );
      },
    );
  }

  static Future<http.Response> post(String url, Map body) async {
    return _secureRequest(
          () async {
        final token = await AuthManager.getAccessToken();
        return http.post(
          Uri.parse(url),
          headers: _headers(token),
          body: jsonEncode(body),
        );
      },
    );
  }

  static Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> _secureRequest(
      Future<http.Response> Function() request,
      ) async {
    String? token = await AuthManager.getAccessToken();

    if (token == null) {
      await LogoutHandler.logout();
      throw Exception("No access token");
    }

    http.Response response = await request();

    if (response.statusCode == 401) {
      final newToken = await TokenRefresher.refresh();
      if (newToken == null) throw Exception("Session expired");

      response = await request();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      await LogoutHandler.logout();
      throw Exception("Unauthorized");
    }

    return response;
  }
}
