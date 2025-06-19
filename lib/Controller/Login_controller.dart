// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../environmental variables.dart';
// //
// // class AuthService {
// //
// //   Future<Map<String, dynamic>> login(String username, String password) async {
// //     try {
// //       final response = await http.post(
// //         Uri.parse("$baseUrl/api/auth/login"),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({'username': username, 'password': password}),
// //       );
// //
// //       print("Status: ${response.statusCode}");
// //       print("Body: ${response.body}");
// //
// //       Map<String, dynamic>? responseData;
// //
// //       try {
// //         responseData = jsonDecode(response.body);
// //       } catch (e) {
// //         print("JSON decode error: $e");
// //       }
// //
// //       if (response.statusCode == 200 && responseData != null) {
// //         final prefs = await SharedPreferences.getInstance();
// //         await prefs.setString('accessToken', responseData['accessToken']);
// //         await prefs.setString('refreshToken', responseData['refreshToken']);
// //       }
// //
// //       return {
// //         'status': response.statusCode,
// //         'body': response.body,
// //         'parsed': responseData,
// //       };
// //     } catch (e) {
// //       print("Login error: $e");
// //       return {
// //         'status': 500,
// //         'body': 'Login exception',
// //         'parsed': {'error': 'Unexpected error'},
// //       };
// //     }
// //   }
// //
// //   Future<String?> refreshAccessToken() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final refreshToken = prefs.getString('refreshToken');
// //     if (refreshToken == null) return null;
// //
// //     final response = await http.post(
// //       Uri.parse("$baseUrl/api/auth/refresh-token"),
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({'token': refreshToken}),
// //     );
// //
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       await prefs.setString('accessToken', data['accessToken']);
// //       await prefs.setString('refreshToken', data['refreshToken']);
// //       return data['accessToken'];
// //     } else {
// //       return null;
// //     }
// //   }
// //
// //   Future<void> logout() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final refreshToken = prefs.getString('refreshToken');
// //
// //     if (refreshToken != null) {
// //       await http.post(
// //         Uri.parse("$baseUrl/api/auth/logout"),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({'token': refreshToken}),
// //       );
// //     }
// //
// //     await prefs.clear();
// //   }
// //
// //   Future<void> testPrefs() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('test', 'value');
// //     print("Test value set: ${prefs.getString('test')}");
// //   }
// // }
//
//
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../environmental variables.dart';
//
// class AuthService {
//   Future<Map<String, dynamic>> login(String username, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse("$baseUrl/api/auth/login"),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'username': username, 'password': password}),
//       );
//
//       print("Status: ${response.statusCode}");
//       print("Body: ${response.body}");
//
//       Map<String, dynamic>? responseData;
//
//       try {
//         responseData = jsonDecode(response.body);
//       } catch (e) {
//         print("JSON decode error: $e");
//       }
//
//       if (response.statusCode == 200 && responseData != null) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('accessToken', responseData['accessToken']);
//         await prefs.setString('refreshToken', responseData['refreshToken']);
//
//         // Optionally store user info if returned
//         if (responseData.containsKey('user')) {
//           await prefs.setString('userRole', responseData['user']['role']);
//           await prefs.setString('username', responseData['user']['username']);
//         }
//       }
//
//       return {
//         'status': response.statusCode,
//         'body': response.body,
//         'parsed': responseData,
//       };
//     } catch (e) {
//       print("Login error: $e");
//       return {
//         'status': 500,
//         'body': 'Login exception',
//         'parsed': {'error': 'Unexpected error'},
//       };
//     }
//   }
//
//   Future<String?> refreshAccessToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final refreshToken = prefs.getString('refreshToken');
//     if (refreshToken == null) return null;
//
//     final response = await http.post(
//       Uri.parse("$baseUrl/api/auth/refresh-token"),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'token': refreshToken}),
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       await prefs.setString('accessToken', data['accessToken']);
//       await prefs.setString('refreshToken', data['refreshToken']);
//       return data['accessToken'];
//     } else {
//       return null;
//     }
//   }
//
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     final refreshToken = prefs.getString('refreshToken');
//
//     if (refreshToken != null) {
//       await http.post(
//         Uri.parse("$baseUrl/api/auth/logout"),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'token': refreshToken}),
//       );
//     }
//
//     await prefs.clear();
//   }
//
//   Future<void> testPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('test', 'value');
//     print("Test value set: ${prefs.getString('test')}");
//   }
// }



// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../environmental variables.dart';
//
// class AuthService {
//   /// Login using email or phone as identifier
//   Future<Map<String, dynamic>> login(String identifier, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse("$baseUrl/api/auth/login"),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'identifier': identifier, 'password': password}),
//       );
//
//       print("Status: ${response.statusCode}");
//       print("Body: ${response.body}");
//
//       Map<String, dynamic>? responseData;
//
//       try {
//         responseData = jsonDecode(response.body);
//       } catch (e) {
//         print("JSON decode error: $e");
//       }
//
//       if (response.statusCode == 200 && responseData != null) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('accessToken', responseData['accessToken']);
//         await prefs.setString('refreshToken', responseData['refreshToken']);
//
//         // Optionally store user info if returned
//         if (responseData.containsKey('user')) {
//           await prefs.setString('userRole', responseData['user']['role'] ?? '');
//           await prefs.setString('username', responseData['user']['username'] ?? '');
//         }
//       }
//
//       return {
//         'status': response.statusCode,
//         'body': response.body,
//         'parsed': responseData,
//       };
//     } catch (e) {
//       print("Login error: $e");
//       return {
//         'status': 500,
//         'body': 'Login exception',
//         'parsed': {'error': 'Unexpected error'},
//       };
//     }
//   }
//
//   /// Refresh access token using refresh token
//   Future<String?> refreshAccessToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final refreshToken = prefs.getString('refreshToken');
//
//     print('[ℹ️] Using refresh token: $refreshToken');
//
//     if (refreshToken == null) return null;
//
//     final response = await http.post(
//       Uri.parse("$baseUrl/api/auth/refresh"), // ✅ CORRECT endpoint
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'refreshToken': refreshToken}), // ✅ CORRECT body key
//     );
//
//     print('[🔁] Refresh response: ${response.statusCode} - ${response.body}');
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       await prefs.setString('accessToken', data['accessToken']);
//       await prefs.setString('refreshToken', data['refreshToken']); // in case it's rotated
//       return data['accessToken'];
//     } else {
//       return null;
//     }
//   }
//   /// Clear tokens and logout user
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     final refreshToken = prefs.getString('refreshToken');
//
//     if (refreshToken != null) {
//       await http.post(
//         Uri.parse("$baseUrl/api/auth/logout"),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'token': refreshToken}),
//       );
//     }
//
//     await prefs.clear();
//   }
//
//   /// Debug helper
//   Future<void> testPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('test', 'value');
//     print("Test value set: ${prefs.getString('test')}");
//   }
// }





import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../View_model/Authentication_state.dart';
import '../environmental variables.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identifier': identifier, 'password': password}),
      );

      final responseData = jsonDecode(response.body);
      print("Login Status: ${response.statusCode}");
      print("Login Body: ${response.body}");

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', responseData['accessToken']);
        await prefs.setString('refreshToken', responseData['refreshToken']);

        if (responseData.containsKey('user')) {
          await prefs.setString('userRole', responseData['user']['role'] ?? '');
          await prefs.setString('username', responseData['user']['username'] ?? '');
        }
      }

      return {
        'status': response.statusCode,
        'body': response.body,
        'parsed': responseData,
      };
    } catch (e) {
      print("Login error: $e");
      return {
        'status': 500,
        'body': 'Login exception',
        'parsed': {'error': 'Unexpected error'},
      };
    }
  }

  Future<String?> refreshAccessToken(AuthState authState) async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    print('[ℹ️] Using refresh token: $refreshToken');

    if (refreshToken == null) return null;

    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/refresh"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    print('[🔁] Refresh response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await prefs.setString('accessToken', data['accessToken']);
      await prefs.setString('refreshToken', data['refreshToken']);
      return data['accessToken'];
    } else {
      await logout(authState);
      return null;
    }
  }

  Future<void> logout(AuthState authState) async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      await http.post(
        Uri.parse("$baseUrl/api/auth/logout"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );
    }

    await prefs.clear();
    authState.logout();
    print('[🚪] Logged out');
  }
}
