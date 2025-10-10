import 'dart:convert';
import 'package:ancilmediaadminpanel/environmental variables.dart';
import 'package:http/http.dart' as http;

class SignupController {
  static Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String phone,
    required String password,
    required String organization,
    String role = 'viewer', // optional role parameter
  }) async {
    final Uri url = Uri.parse("$baseUrl/api/auth/register");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username.trim(),
          'organizationName': organization.trim(), // backend field
          'email': email.trim().toLowerCase(),
          'phone': phone.trim(),
          'password': password,
          'role': role.trim().toLowerCase(),
        }),
      ).timeout(const Duration(seconds: 10));

      print('Signup Response status: ${response.statusCode}');
      print('Signup Response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final user = data['user'] ?? {};
        final orgData = user['organization'];

        // ✅ Handle both String and Map types for 'organization'
        Map<String, dynamic> org = {};
        if (orgData is Map<String, dynamic>) {
          org = orgData;
        } else if (orgData is String) {
          org = {'orgId': orgData}; // fallback to ID-only structure
        }

        return {
          'success': true,
          'user': {
            'userId': user['userId'] ?? '',
            'username': user['username'] ?? '',
            'email': user['email'] ?? '',
            'phone': user['phone'] ?? '',
            'role': user['role'] ?? '',
            'approved': user['approved'] ?? false,
            'createdAt': user['createdAt'] ?? '',
            'organization': org,
          },
          'status': 201,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? data['error'] ?? 'Signup failed. Please try again.',
          'status': response.statusCode,
        };
      }
    } catch (e) {
      print('Signup Error: $e');
      return {
        'success': false,
        'message': 'Unexpected error occurred. Please try again later.',
        'status': 500,
      };
    }
  }
}
