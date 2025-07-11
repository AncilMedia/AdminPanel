// import 'dart:convert';
// import 'package:ancilmediaadminpanel/environmental variables.dart';
// import 'package:http/http.dart' as http;
//
// class SignupController {
//   static Future<Map<String, dynamic>> signup({
//     required String username,
//     required String email,
//     required String phone,
//     required String password,
//     required String organization,
//   }) async {
//     final Uri url = Uri.parse("$baseUrl/api/auth/register");
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'username': username.trim(),
//           'organization': organization.trim(),
//           'email': email.trim(),
//           'phone': phone.trim(),
//           'password': password,
//         }),
//       ).timeout(const Duration(seconds: 10));
//
//       print('Signup Response status: ${response.statusCode}');
//       print('Signup Response body: ${response.body}');
//
//       final data = jsonDecode(response.body);
//
//       switch (response.statusCode) {
//         case 201:
//           return {
//             'success': true,
//             'data': data,
//             'status': 201,
//           };
//         case 400:
//         case 409:
//           return {
//             'success': false,
//             'message': data['error'] ?? 'Invalid input or user exists.',
//             'status': response.statusCode,
//           };
//         default:
//           return {
//             'success': false,
//             'message': data['error'] ?? 'Signup failed. Please try again.',
//             'status': response.statusCode,
//           };
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
    required String phone,
    required String password,
    required String organization,
  }) async {
    final Uri url = Uri.parse("$baseUrl/api/auth/register");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username.trim(),
          'organizationName': organization.trim(), // ✅ Backend expects organizationName
          'email': email.trim(),
          'phone': phone.trim(),
          'password': password,
          'role': 'viewer', // ✅ Explicitly defaulting on frontend
        }),
      ).timeout(const Duration(seconds: 10));

      print('Signup Response status: ${response.statusCode}');
      print('Signup Response body: ${response.body}');

      final data = jsonDecode(response.body);

      switch (response.statusCode) {
        case 201:
          final user = data['user'] ?? {};
          final org = user['organization'] ?? {};

          return {
            'success': true,
            'user': {
              'userId': user['userId'],
              'username': user['username'],
              'email': user['email'],
              'phone': user['phone'],
              'role': user['role'],
              'approved': user['approved'],
              'createdAt': user['createdAt'],
              'organization': {
                'name': org['name'],
                'orgId': org['orgId'],
                'createdAt': org['createdAt'],
              },
            },
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
