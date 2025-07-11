import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../environmental variables.dart';

class OrganizationService {
  static String _baseUrl = '$baseUrl/api/organizations';

  // ✅ Create Organization
  static Future<String> createOrganization(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) throw Exception("No access token");

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'name': name}),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      final orgId = data['_id'] ?? data['id'];
      await prefs.setString('organizationId', orgId);
      return orgId;
    } else {
      throw Exception('Failed to create organization: ${response.body}');
    }
  }

  // ✅ Get Organization by ID
  static Future<Map<String, dynamic>> getOrganization(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    final response = await http.get(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch organization: ${response.body}');
    }
  }

  // ✅ Get Organization by Name
  static Future<String?> getOrganizationByName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) throw Exception("No access token");

    final response = await http.get(
      Uri.parse('$_baseUrl/by-name/$name'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final orgId = data['_id'] ?? data['id'];
      await prefs.setString('organizationId', orgId);
      return orgId;
    } else if (response.statusCode == 404) {
      return null; // Not found
    } else {
      throw Exception('Failed to fetch organization by name: ${response.body}');
    }
  }

  // ✅ Update Organization
  static Future<void> updateOrganization(String id, String newName) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'name': newName}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update organization: ${response.body}');
    }
  }

  // ✅ Delete Organization
  static Future<void> deleteOrganization(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete organization: ${response.body}');
    }
  }

  // ✅ Get stored organizationId
  static Future<String?> getStoredOrganizationId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('organizationId');
  }
}
