// import 'dart:convert';
// import 'package:ancilmediaadminpanel/environmental variables.dart';
// import 'package:http/http.dart' as http;
//
// class SignupController {
//   static Future<Map<String, dynamic>> signup({
//     required String username,
//     required String email,
//     required String password,
//   }) async {
//     final Uri url = Uri.parse("$baseUrl/api/auth/register");
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'username': username,
//           'email': email,
//           'password': password,
//         }),
//       ).timeout(const Duration(seconds: 10));
//
//       print('Signup Response status: ${response.statusCode}');
//       print('Signup Response body: ${response.body}');
//
//       final data = jsonDecode(response.body);
//
//       if (response.statusCode == 201) {
//         return {
//           'success': true,
//           'data': data,
//           'status': response.statusCode,
//         };
//       } else if (response.statusCode == 400) {
//         return {
//           'success': false,
//           'message': data['error'] ?? 'Invalid input data.',
//           'status': 400,
//         };
//       } else if (response.statusCode == 409) {
//         return {
//           'success': false,
//           'message': data['error'] ?? 'User already exists. Please login.',
//           'status': 409,
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['error'] ?? 'Signup failed',
//           'status': response.statusCode,
//         };
//       }
//     } catch (e) {
//       print('Signup Error: $e');
//       return {
//         'success': false,
//         'message': 'Unexpected error occurred. Please try again later.',
//         'status': 500,
//       };
//     }
//   }
// }


import 'dart:convert';
import 'package:ancilmediaadminpanel/environmental variables.dart';
import 'package:http/http.dart' as http;

class SignupController {
  static Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    final Uri url = Uri.parse("$baseUrl/api/auth/register");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username.trim(),
          'email': email.trim(),
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      print('Signup Response status: ${response.statusCode}');
      print('Signup Response body: ${response.body}');

      final data = jsonDecode(response.body);

      switch (response.statusCode) {
        case 201:
          return {
            'success': true,
            'data': data,
            'status': 201,
          };
        case 400:
        case 409:
          return {
            'success': false,
            'message': data['error'] ?? 'Invalid input or user exists.',
            'status': response.statusCode,
          };
        default:
          return {
            'success': false,
            'message': data['error'] ?? 'Signup failed. Please try again.',
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
