import 'dart:convert';
import 'package:ancilmediaadminpanel/environmental variables.dart';
import 'package:ancilmediaadminpanel/Model/User_Model.dart';
import 'package:ancilmediaadminpanel/Services/api_client.dart';
import '../View_model/Authentication_state.dart';
import 'package:http/http.dart' as http;

class UserController {
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
      throw Exception('Failed to load users');
    }
  }

  static Future<List<String>> fetchRoles({required AuthState authState}) async {
    final api = ApiClient(authState);
    final uri = '$baseUrl/api/users/roles';
    final response = await api.get(uri);

    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      print('[❌] Failed to fetch roles: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load roles');
    }
  }

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

    if (response.statusCode == 200) {
      print('[✅] User ${approve ? 'approved' : 'rejected'} successfully');
      return true;
    } else {
      print('[❌] Failed to update approval: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  static Future<bool> deleteUser({
    required AuthState authState,
    required String userId,
  }) async {
    final api = ApiClient(authState);
    final uri = '$baseUrl/api/users/$userId';
    final response = await api.delete(uri);

    if (response.statusCode == 204) {
      print('[✓] User deleted successfully');
      return true;
    } else {
      print('[✗] Delete failed: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

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

    if (response.statusCode == 200) {
      print('[✓] Role updated successfully');
      return true;
    } else {
      print('[✗] Failed to update role: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

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

    if (response.statusCode == 200) {
      print('[✅] User ${block ? 'blocked' : 'unblocked'} successfully');
      return true;
    } else {
      print('[❌] Failed to update block status: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

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
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'User created successfully',
          'user': data['user'],
        };
      } else {
        print('[❌] API Error: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'message': data['error'] ?? 'Failed to create user',
        };
      }
    } catch (e) {
      print('❌ Exception while creating user: $e');
      return {
        'success': false,
        'message': 'Unexpected error occurred',
      };
    }
  }

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
        print('[❌] Failed to update user: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'message': data['error'] ?? 'Failed to update',
        };
      }
    } catch (e) {
      print('[❌] Update error: $e');
      return {
        'success': false,
        'message': 'Unexpected error',
      };
    }
  }
}
