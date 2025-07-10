import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/Login_controller.dart';
import '../View_model/Authentication_state.dart';

class ApiClient {
  final AuthService _authService = AuthService();
  final AuthState authState;

  ApiClient(this.authState);


  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }


  Future<Map<String, String>> authHeader() async {
    final token = await getAccessToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<http.Response> get(String endpoint) async {
    return _withAuthRetry(() async => http.get(Uri.parse(endpoint), headers: await authHeader()));
  }

  Future<http.Response> post(String endpoint, {Map<String, String>? headers, Object? body}) async {
    return _withAuthRetry(() async => http.post(
        Uri.parse(endpoint), headers: {...?await authHeader(), ...?headers}, body: body));
  }

  Future<http.Response> put(String endpoint, {Map<String, String>? headers, Object? body}) async {
    return _withAuthRetry(() async => http.put(
        Uri.parse(endpoint), headers: {...?await authHeader(), ...?headers}, body: body));
  }

  Future<http.Response> delete(String endpoint, {Map<String, String>? headers}) async {
    return _withAuthRetry(() async => http.delete(
        Uri.parse(endpoint), headers: {...?await authHeader(), ...?headers}));
  }
  Future<http.Response> _withAuthRetry(Future<http.Response> Function() requestFn) async {
    http.Response response = await requestFn();

    if (response.statusCode == 403) {
      print('[⚠️] Access token expired. Trying refresh...');
      final newToken = await _authService.refreshAccessToken(authState);

      if (newToken != null) {
        print('[✅] Token refreshed, retrying request...');
        // Rebuild headers after refresh
        response = await requestFn();
      } else {
        print('[❌] Refresh failed. Logging out...');
        await _authService.logout(authState);
      }
    }

    return response;
  }

  dynamic decodeJson(http.Response response) {
    try {
      return jsonDecode(response.body);
    } catch (e) {
      print('[❌] Failed to decode JSON: $e');
      return null;
    }
  }
}
