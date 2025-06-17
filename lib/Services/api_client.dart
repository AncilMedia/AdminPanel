import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/Login_controller.dart';
import '../environmental variables.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<http.Response> get(String endpoint) async {
    return _withAuthRetry(() async => http.get(Uri.parse(endpoint), headers: await _authHeader()));
  }

  Future<http.Response> post(String endpoint, {Map<String, String>? headers, Object? body}) async {
    return _withAuthRetry(() async => http.post(Uri.parse(endpoint),
        headers: {...?await _authHeader(), ...?headers}, body: body));
  }

  Future<http.Response> put(String endpoint, {Map<String, String>? headers, Object? body}) async {
    return _withAuthRetry(() async => http.put(Uri.parse(endpoint),
        headers: {...?await _authHeader(), ...?headers}, body: body));
  }

  Future<http.Response> delete(String endpoint, {Map<String, String>? headers}) async {
    return _withAuthRetry(() async => http.delete(Uri.parse(endpoint),
        headers: {...?await _authHeader(), ...?headers}));
  }

  Future<Map<String, String>> _authHeader() async {
    final token = await _getAccessToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<http.Response> _withAuthRetry(Future<http.Response> Function() requestFn) async {
    http.Response response = await requestFn();

    if (response.statusCode == 401) {
      // Try refresh
      final authService = AuthService();
      final newToken = await authService.refreshAccessToken();

      if (newToken != null) {
        response = await requestFn();
      } else {
        await authService.logout();
      }
    }

    return response;
  }
}
