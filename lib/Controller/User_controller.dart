// import 'dart:convert';
// import 'package:ancilmediaadminpanel/environmental variables.dart';
// import 'package:ancilmediaadminpanel/Model/User_Model.dart';
// import 'package:ancilmediaadminpanel/Services/api_client.dart';
// import '../View_model/Authentication_state.dart';
//
// class UserController {
//   /// Fetch all users with optional filters
//   static Future<List<UserModel>> fetchUsers({
//     required AuthState authState,
//     String? search,
//     String? role,
//     String? approved,
//     String? blocked,
//   }) async {
//     final queryParams = <String, String>{};
//     if (search != null && search.isNotEmpty) queryParams['search'] = search;
//     if (role != null && role.toLowerCase() != 'all') {
//       queryParams['role'] = role.toLowerCase();
//     }
//     if (approved != null) queryParams['approved'] = approved;
//     if (blocked != null) queryParams['blocked'] = blocked;
//
//     final uri =
//     Uri.parse('$baseUrl/api/users').replace(queryParameters: queryParams);
//
//     final api = ApiClient(authState);
//     final response = await api.get(uri.toString());
//
//     if (response.statusCode == 200) {
//       final List data = json.decode(response.body);
//       return data.map((e) => UserModel.fromJson(e)).toList();
//     } else {
//       throw Exception('Failed to load users: ${response.body}');
//     }
//   }
//
//   /// Fetch available roles
//   static Future<List<String>> fetchRoles({required AuthState authState}) async {
//     final api = ApiClient(authState);
//     final uri = '$baseUrl/api/users/roles';
//     final response = await api.get(uri);
//
//     if (response.statusCode == 200) {
//       return List<String>.from(json.decode(response.body));
//     } else {
//       throw Exception(
//           'Failed to fetch roles: ${response.statusCode} - ${response.body}');
//     }
//   }
//
//   /// Approve or reject a user
//   static Future<bool> updateApprovalStatus({
//     required AuthState authState,
//     required String userId,
//     required bool approve,
//   }) async {
//     final api = ApiClient(authState);
//     final uri = '$baseUrl/api/users/approve/$userId';
//     final response = await api.put(
//       uri,
//       body: jsonEncode({'approve': approve}),
//       headers: {'Content-Type': 'application/json'},
//     );
//
//     return response.statusCode == 200;
//   }
//
//   /// Delete a user
//   static Future<bool> deleteUser({
//     required AuthState authState,
//     required String userId,
//   }) async {
//     final api = ApiClient(authState);
//     final uri = '$baseUrl/api/users/$userId';
//     final response = await api.delete(uri);
//
//     return response.statusCode == 204;
//   }
//
//   /// Update user role
//   static Future<bool> updateUserRole({
//     required AuthState authState,
//     required String userId,
//     required String newRole,
//   }) async {
//     final api = ApiClient(authState);
//     final uri = '$baseUrl/api/users/role/$userId';
//     final response = await api.put(
//       uri,
//       body: jsonEncode({'newRole': newRole}),
//       headers: {'Content-Type': 'application/json'},
//     );
//
//     return response.statusCode == 200;
//   }
//
//   /// Block or unblock a user
//   static Future<bool> updateBlockStatus({
//     required AuthState authState,
//     required String userId,
//     required bool block,
//   }) async {
//     final api = ApiClient(authState);
//     final uri = '$baseUrl/api/users/block/$userId';
//     final response = await api.put(
//       uri,
//       body: jsonEncode({'block': block}),
//       headers: {'Content-Type': 'application/json'},
//     );
//
//     return response.statusCode == 200;
//   }
//
//   /// Create new user
//   static Future<Map<String, dynamic>> createUser({
//     required AuthState authState,
//     required String username,
//     required String email,
//     required String phone,
//     required String password,
//     String role = 'viewer',
//   }) async {
//     final api = ApiClient(authState);
//     final Uri url = Uri.parse('$baseUrl/api/users/create');
//
//     try {
//       final response = await api.post(
//         url.toString(),
//         body: jsonEncode({
//           'username': username.trim(),
//           'email': email.trim(),
//           'phone': phone.trim(),
//           'password': password,
//           'role': role,
//         }),
//         headers: {'Content-Type': 'application/json'},
//       );
//
//       final data = jsonDecode(response.body);
//
//       if (response.statusCode == 201) {
//         return {
//           'success': true,
//           'message': data['message'] ?? 'User created successfully',
//           'user': data['user'],
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['error'] ?? 'Failed to create user',
//         };
//       }
//     } catch (e) {
//       return {'success': false, 'message': 'Unexpected error: $e'};
//     }
//   }
//
//   /// Update user info
//   static Future<Map<String, dynamic>> updateUser({
//     required AuthState authState,
//     required String userId,
//     required String username,
//     required String email,
//     required String phone,
//   }) async {
//     final api = ApiClient(authState);
//     final uri = '$baseUrl/api/users/$userId';
//
//     try {
//       final response = await api.put(
//         uri,
//         body: jsonEncode({
//           'username': username.trim(),
//           'email': email.trim(),
//           'phone': phone.trim(),
//         }),
//         headers: {'Content-Type': 'application/json'},
//       );
//
//       final data = jsonDecode(response.body);
//
//       if (response.statusCode == 200) {
//         return {
//           'success': true,
//           'message': data['message'] ?? 'User updated',
//           'user': data['user'],
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['error'] ?? 'Failed to update',
//         };
//       }
//     } catch (e) {
//       return {'success': false, 'message': 'Unexpected error: $e'};
//     }
//   }
// }
//
// class UsergetController {
//   static Future<List<UserModel>> fetchUsers({
//     required AuthState authState,
//   }) async {
//     final queryParams = <String, String>{};
//     final uri = Uri.parse('$baseUrl/api/users').replace(queryParameters: queryParams);
//     final api = ApiClient(authState);
//     final response = await api.get(uri.toString());
//
//     if (response.statusCode == 200) {
//       final List data = json.decode(response.body);
//       return data.map((e) => UserModel.fromJson(e)).toList();
//     } else {
//       throw Exception('Failed to load users');
//     }
//   }
// }


import 'dart:convert';
import 'package:ancilmediaadminpanel/environmental variables.dart';
import 'package:ancilmediaadminpanel/Model/User_Model.dart';
import 'package:ancilmediaadminpanel/Services/api_client.dart';
import '../View_model/Authentication_state.dart';

class UserController {
  /// Fetch all users with optional filters
  static Future<List<UserModel>> fetchUsers({
    required AuthState authState,
    String? search,
    String? role,
    String? approved,
    String? blocked,
  }) async {
    final queryParams = <String, String>{};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (role != null && role.toLowerCase() != 'all') queryParams['role'] = role.toLowerCase();
    if (approved != null) queryParams['approved'] = approved;
    if (blocked != null) queryParams['blocked'] = blocked;

    final uri = Uri.parse('$baseUrl/api/users').replace(queryParameters: queryParams);
    final api = ApiClient(authState);
    final response = await api.get(uri.toString());

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users: ${response.body}');
    }
  }

  /// Fetch available roles
  static Future<List<String>> fetchRoles({required AuthState authState}) async {
    final api = ApiClient(authState);
    final uri = '$baseUrl/api/users/roles';
    final response = await api.get(uri);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      // Backend returns objects with {name, description}, extract names
      return data.map<String>((e) {
        if (e is String) return e;
        if (e is Map<String, dynamic>) return e['name'] ?? '';
        return '';
      }).where((name) => name.isNotEmpty).toList();
    } else {
      throw Exception('Failed to fetch roles: ${response.statusCode} - ${response.body}');
    }
  }

  /// Approve or reject a user
  static Future<bool> updateApprovalStatus({
    required AuthState authState,
    required String userId,
    required bool approve,
  }) async {
    final api = ApiClient(authState);
    final uri = '$baseUrl/api/users/approve/$userId';
    final response = await api.put(
      uri,
      body: jsonEncode({'approve': approve}),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  /// Delete a user
  static Future<bool> deleteUser({
    required AuthState authState,
    required String userId,
  }) async {
    final api = ApiClient(authState);
    final uri = '$baseUrl/api/users/$userId';
    final response = await api.delete(uri);
    return response.statusCode == 204;
  }

  /// Update user role
  static Future<bool> updateUserRole({
    required AuthState authState,
    required String userId,
    required String newRole,
  }) async {
    final api = ApiClient(authState);
    final uri = '$baseUrl/api/users/role/$userId';
    final response = await api.put(
      uri,
      body: jsonEncode({'newRole': newRole}),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  /// Block or unblock a user
  static Future<bool> updateBlockStatus({
    required AuthState authState,
    required String userId,
    required bool block,
  }) async {
    final api = ApiClient(authState);
    final uri = '$baseUrl/api/users/block/$userId';
    final response = await api.put(
      uri,
      body: jsonEncode({'block': block}),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  /// Create new user
  static Future<Map<String, dynamic>> createUser({
    required AuthState authState,
    required String username,
    required String email,
    required String phone,
    required String password,
    String role = 'viewer',
  }) async {
    final api = ApiClient(authState);
    final Uri url = Uri.parse('$baseUrl/api/users/create');

    try {
      final response = await api.post(
        url.toString(),
        body: jsonEncode({
          'username': username.trim(),
          'email': email.trim(),
          'phone': phone.trim(),
          'password': password,
          'role': role,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'User created successfully',
          'user': data['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Failed to create user',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  /// Update user info
  static Future<Map<String, dynamic>> updateUser({
    required AuthState authState,
    required String userId,
    required String username,
    required String email,
    required String phone,
  }) async {
    final api = ApiClient(authState);
    final uri = '$baseUrl/api/users/$userId';

    try {
      final response = await api.put(
        uri,
        body: jsonEncode({
          'username': username.trim(),
          'email': email.trim(),
          'phone': phone.trim(),
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'User updated',
          'user': data['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Failed to update',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }
}

/// Optional: simple controller to just fetch users
class UsergetController {
  static Future<List<UserModel>> fetchUsers({
    required AuthState authState,
  }) async {
    final queryParams = <String, String>{};
    final uri = Uri.parse('$baseUrl/api/users').replace(queryParameters: queryParams);
    final api = ApiClient(authState);
    final response = await api.get(uri.toString());

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
