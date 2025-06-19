import 'dart:convert';
import 'package:ancilmediaadminpanel/environmental variables.dart';
import 'package:ancilmediaadminpanel/Model/User_Model.dart';
import 'package:ancilmediaadminpanel/Services/api_client.dart';
import '../View_model/Authentication_state.dart';

class UserController {
  /// Fetch users with optional search and role filter
  static Future<List<UserModel>> fetchUsers({
    required AuthState authState,
    String? search,
    String? role,
  }) async {
    final queryParams = <String, String>{};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (role != null && role.toLowerCase() != 'all') queryParams['role'] = role.toLowerCase();

    final uri = Uri.parse('$baseUrl/api/users').replace(queryParameters: queryParams);

    final api = ApiClient(authState);
    final response = await api.get(uri.toString());

    if (response.statusCode == 200) {
      print('[✅] Users fetched: ${response.body}');
      final List data = json.decode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      print('[❌] Failed to fetch users: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load users');
    }
  }

  /// Update approval status (true = approve, false = reject)
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

  /// Block or unblock user (true = block, false = unblock)
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
}
