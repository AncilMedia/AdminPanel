// lib/Controllers/signup_controller.dart

import 'dart:convert';
import 'package:ancilmediaadminpanel/environmental%20variables.dart';
import 'package:http/http.dart' as http;

class SignupController {
  static Future<Map<String, dynamic>> signup({
    required String username,
    required String fullName,
    required String password,
  }) async {
    final Uri url = Uri.parse("$baseUrl/api/auth/signup");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'fullName': fullName,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {
        'success': false,
        'message': jsonDecode(response.body)['message'] ?? 'Signup failed'
      };
    }
  }
}
