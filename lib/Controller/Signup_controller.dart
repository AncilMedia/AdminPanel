import 'dart:convert';
import 'package:ancilmediaadminpanel/environmental variables.dart';
import 'package:http/http.dart' as http;

class SignupController {
  static Future<Map<String, dynamic>> signup({
    required String username,
    required String fullName,
    required String password,
  }) async {
    final Uri url = Uri.parse("$baseUrl/api/auth/register");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'fullName': fullName,
          'password': password,
        }),
      );

      print('Signup Response status: ${response.statusCode}');
      print('Signup Response body: ${response.body}');

      // Try parsing JSON
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Signup failed',
        };
      }
    } catch (e) {
      print('Signup Error: $e');
      return {
        'success': false,
        'message': 'Unexpected error occurred. Please try again later.',
      };
    }
  }
}
