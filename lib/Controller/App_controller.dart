import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../environmental variables.dart';

class AppService {

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<List<dynamic>> getApps() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/apps'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load apps');
    }
  }

  Future<bool> createApp({required String packageName, required String appName}) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/apps'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'packageName': packageName,
        'appName': appName,
      }),
    );

    return response.statusCode == 201;
  }

  Future<bool> updateApp(String id, {required String packageName, required String appName}) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/api/apps/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'packageName': packageName,
        'appName': appName,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteApp(String id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/apps/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> getAppById(String id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/apps/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
