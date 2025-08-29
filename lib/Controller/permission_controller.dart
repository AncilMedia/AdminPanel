import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../environmental variables.dart';


class PermissionsController extends ChangeNotifier {
  bool isLoading = false;
  List<Map<String, dynamic>> permissions = [];
  Map<String, dynamic>? selectedRole;

  /// ✅ Get Token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken");
  }

  /// ✅ Create Permission
  Future<bool> createPermission(String key, String label) async {
    try {
      isLoading = true;
      notifyListeners();

      final token = await _getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/api/permissions'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"key": key, "label": label}),
      );

      if (response.statusCode == 201) {
        await fetchPermissions();
        return true;
      } else {
        debugPrint("Create Permission Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Create Permission Error: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Get all Permissions
  Future<void> fetchPermissions() async {
    try {
      isLoading = true;
      notifyListeners();

      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/api/permissions'),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        permissions = List<Map<String, dynamic>>.from(data);
      } else {
        debugPrint("Fetch Permissions Failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("Fetch Permissions Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Assign Permissions to Role
  Future<bool> assignPermissionsToRole(String roleId, List<String> permissionIds) async {
    try {
      isLoading = true;
      notifyListeners();

      final token = await _getToken();
      final response = await http.put(
        Uri.parse("$baseUrl/api/permissions/assign/$roleId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"permissions": permissionIds}),
      );

      if (response.statusCode == 200) {
        debugPrint("Permissions Assigned: ${response.body}");
        return true;
      } else {
        debugPrint("Assign Permissions Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Assign Permissions Error: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Get Role with Permissions
  Future<void> fetchRoleWithPermissions(String roleId) async {
    try {
      isLoading = true;
      notifyListeners();

      final token = await _getToken();
      final response = await http.get(
        Uri.parse("$baseUrl/api/permissions/$roleId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        selectedRole = jsonDecode(response.body);
      } else {
        debugPrint("Fetch Role With Permissions Failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("Fetch Role With Permissions Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
