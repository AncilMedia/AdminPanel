// // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // import 'package:http/http.dart' as http;
// // // // // // // // import 'dart:convert';
// // // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // // // import 'package:ancilmediaadminpanel/environmental%20variables.dart';
// // // // // // // //
// // // // // // // // class RolesController extends ChangeNotifier {
// // // // // // // //   bool isLoading = true;
// // // // // // // //
// // // // // // // //   // Permissions
// // // // // // // //   Map<String, List<Map<String, dynamic>>> permissionCategories = {};
// // // // // // // //   Map<String, bool> permissionStates = {};
// // // // // // // //
// // // // // // // //   // Sidebar permissions
// // // // // // // //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
// // // // // // // //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// // // // // // // //
// // // // // // // //   // Roles
// // // // // // // //   List<Map<String, dynamic>> rolesList = [];
// // // // // // // //
// // // // // // // //   String? roleId;
// // // // // // // //   String? token;
// // // // // // // //
// // // // // // // //   RolesController() {
// // // // // // // //     _initLoad();
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Future<void> _initLoad() async {
// // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // //     roleId = prefs.getString('roleId');
// // // // // // // //     token = prefs.getString('accessToken');
// // // // // // // //     if (roleId != null && token != null) {
// // // // // // // //       await refreshRole(roleId!);
// // // // // // // //       await fetchRoles();
// // // // // // // //     } else {
// // // // // // // //       isLoading = false;
// // // // // // // //       notifyListeners();
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   /// ==================== Roles API ====================
// // // // // // // //   Future<List<Map<String, dynamic>>> fetchRoles() async {
// // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // //     token = prefs.getString('accessToken');
// // // // // // // //     if (token == null) return [];
// // // // // // // //
// // // // // // // //     try {
// // // // // // // //       final response = await http.get(
// // // // // // // //         Uri.parse('$baseUrl/api/roles'),
// // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // //       );
// // // // // // // //
// // // // // // // //       print("🔹 fetchRoles response (${response.statusCode}): ${response.body}");
// // // // // // // //
// // // // // // // //       if (response.statusCode == 200) {
// // // // // // // //         final List data = json.decode(response.body);
// // // // // // // //         rolesList = data.map((role) {
// // // // // // // //           return {'id': role['_id'], 'name': role['name']};
// // // // // // // //         }).toList();
// // // // // // // //         notifyListeners();
// // // // // // // //         return rolesList;
// // // // // // // //       } else {
// // // // // // // //         print('Failed to fetch roles: ${response.statusCode}');
// // // // // // // //         return [];
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       print('Error fetching roles: $e');
// // // // // // // //       return [];
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   /// ===================== Permissions =====================
// // // // // // // //   Future<void> refreshRole(String roleId) async {
// // // // // // // //     this.roleId = roleId;
// // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // //     token = prefs.getString('accessToken');
// // // // // // // //
// // // // // // // //     if (token == null) return;
// // // // // // // //
// // // // // // // //     isLoading = true;
// // // // // // // //     notifyListeners();
// // // // // // // //
// // // // // // // //     await fetchPermissionsAndRole();
// // // // // // // //     await fetchSidebarItems();
// // // // // // // //
// // // // // // // //     isLoading = false;
// // // // // // // //     notifyListeners();
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Future<void> fetchPermissionsAndRole() async {
// // // // // // // //     if (roleId == null || token == null) return;
// // // // // // // //
// // // // // // // //     try {
// // // // // // // //       final permResponse = await http.get(
// // // // // // // //         Uri.parse('$baseUrl/api/permissions'),
// // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // //       );
// // // // // // // //       print("🔹 fetchPermissions response (${permResponse.statusCode}): ${permResponse.body}");
// // // // // // // //
// // // // // // // //       if (permResponse.statusCode != 200) return;
// // // // // // // //       final List allPermissions = json.decode(permResponse.body);
// // // // // // // //
// // // // // // // //       final roleResponse = await http.get(
// // // // // // // //         Uri.parse('$baseUrl/api/permissions/$roleId'),
// // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // //       );
// // // // // // // //       print("🔹 role permissions response (${roleResponse.statusCode}): ${roleResponse.body}");
// // // // // // // //
// // // // // // // //       if (roleResponse.statusCode != 200) return;
// // // // // // // //       final roleData = json.decode(roleResponse.body);
// // // // // // // //
// // // // // // // //       final List<String> assignedKeys =
// // // // // // // //       List<String>.from(roleData['permissions'].map((p) => p['key']));
// // // // // // // //
// // // // // // // //       Map<String, List<Map<String, dynamic>>> grouped = {};
// // // // // // // //       permissionStates = {};
// // // // // // // //
// // // // // // // //       for (var perm in allPermissions) {
// // // // // // // //         String category = perm['key'].split(':')[0];
// // // // // // // //         grouped.putIfAbsent(category, () => []);
// // // // // // // //         grouped[category]!.add(perm);
// // // // // // // //         permissionStates[perm['key']] = assignedKeys.contains(perm['key']);
// // // // // // // //       }
// // // // // // // //
// // // // // // // //       permissionCategories = grouped;
// // // // // // // //     } catch (e) {
// // // // // // // //       print('Error fetching permissions: $e');
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Future<bool> updateRolePermissions() async {
// // // // // // // //     if (roleId == null || token == null) return false;
// // // // // // // //
// // // // // // // //     try {
// // // // // // // //       final selectedPermissions = permissionCategories.values
// // // // // // // //           .expand((list) => list)
// // // // // // // //           .where((p) => permissionStates[p['key']] == true)
// // // // // // // //           .map((p) => p['_id'])
// // // // // // // //           .toList();
// // // // // // // //
// // // // // // // //       final response = await http.put(
// // // // // // // //         Uri.parse('$baseUrl/api/permissions/assign/$roleId'),
// // // // // // // //         headers: {
// // // // // // // //           'Authorization': 'Bearer $token',
// // // // // // // //           'Content-Type': 'application/json'
// // // // // // // //         },
// // // // // // // //         body: json.encode({'permissions': selectedPermissions}),
// // // // // // // //       );
// // // // // // // //
// // // // // // // //       print("🔹 updateRolePermissions response (${response.statusCode}): ${response.body}");
// // // // // // // //
// // // // // // // //       return response.statusCode == 200;
// // // // // // // //     } catch (e) {
// // // // // // // //       print('Error updating permissions: $e');
// // // // // // // //       return false;
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   /// ===================== Sidebar =====================
// // // // // // // //   Future<void> fetchSidebarItems() async {
// // // // // // // //     if (roleId == null || token == null) return;
// // // // // // // //
// // // // // // // //     try {
// // // // // // // //       // Fetch all sidebar items
// // // // // // // //       final response = await http.get(
// // // // // // // //         Uri.parse('$baseUrl/api/sidebar'),
// // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // //       );
// // // // // // // //       print("🔹 fetchSidebarItems (all items) (${response.statusCode}): ${response.body}");
// // // // // // // //       if (response.statusCode != 200) return;
// // // // // // // //       final List items = json.decode(response.body);
// // // // // // // //
// // // // // // // //       // Fetch role info to check if admin
// // // // // // // //       final roleResponse = await http.get(
// // // // // // // //         Uri.parse('$baseUrl/api/roles/$roleId'),
// // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // //       );
// // // // // // // //       print("🔹 fetchSidebarItems (role info) (${roleResponse.statusCode}): ${roleResponse.body}");
// // // // // // // //       if (roleResponse.statusCode != 200) return;
// // // // // // // //       final roleData = json.decode(roleResponse.body);
// // // // // // // //       final isAdmin = roleData['name'] == 'admin';
// // // // // // // //
// // // // // // // //       // Fetch assigned sidebar permissions for the role
// // // // // // // //       final sidebarPermResponse = await http.get(
// // // // // // // //         Uri.parse('$baseUrl/api/sidebar/assign/$roleId'),
// // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // //       );
// // // // // // // //       print("🔹 fetchSidebarItems (assigned) (${sidebarPermResponse.statusCode}): ${sidebarPermResponse.body}");
// // // // // // // //
// // // // // // // //       Map<String, dynamic> roleSidebar = {};
// // // // // // // //       if (sidebarPermResponse.statusCode == 200) {
// // // // // // // //         final sidebarData = json.decode(sidebarPermResponse.body);
// // // // // // // //         for (var sb in sidebarData['sidebarPermissions'] ?? []) {
// // // // // // // //           roleSidebar[sb['key']] = sb['permissions'];
// // // // // // // //         }
// // // // // // // //       }
// // // // // // // //
// // // // // // // //       Map<String, List<Map<String, dynamic>>> grouped = {};
// // // // // // // //       sidebarPermissionStates = {};
// // // // // // // //
// // // // // // // //       for (var item in items) {
// // // // // // // //         String key = item['key'];
// // // // // // // //         String category = item['category'] ?? 'General';
// // // // // // // //
// // // // // // // //         // Get permissions for the current item
// // // // // // // //         Map<String, dynamic> perms = roleSidebar[key] ?? {};
// // // // // // // //         bool view = perms['view'] ?? false;
// // // // // // // //         bool read = perms['read'] ?? false;
// // // // // // // //         bool manage = perms['manage'] ?? false;
// // // // // // // //
// // // // // // // //         // Admin sees all, non-admin sees only if 'manage' is true
// // // // // // // //         if (isAdmin || manage) {
// // // // // // // //           grouped.putIfAbsent(category, () => []);
// // // // // // // //           grouped[category]!.add(item);
// // // // // // // //
// // // // // // // //           sidebarPermissionStates[key] = {
// // // // // // // //             'view': view,
// // // // // // // //             'read': read,
// // // // // // // //             'manage': manage,
// // // // // // // //           };
// // // // // // // //         }
// // // // // // // //       }
// // // // // // // //
// // // // // // // //       sidebarCategories = grouped;
// // // // // // // //     } catch (e) {
// // // // // // // //       print('Error fetching sidebar items: $e');
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Future<bool> updateSidebarPermissions() async {
// // // // // // // //     if (roleId == null || token == null) return false;
// // // // // // // //
// // // // // // // //     try {
// // // // // // // //       final data = sidebarPermissionStates.entries
// // // // // // // //           .where((e) => e.value.values.any((v) => v))
// // // // // // // //           .map((e) => {
// // // // // // // //         'key': e.key,
// // // // // // // //         'permissions': e.value,
// // // // // // // //       })
// // // // // // // //           .toList();
// // // // // // // //
// // // // // // // //       final response = await http.put(
// // // // // // // //         Uri.parse('$baseUrl/api/sidebar/assign/$roleId'),
// // // // // // // //         headers: {
// // // // // // // //           'Authorization': 'Bearer $token',
// // // // // // // //           'Content-Type': 'application/json'
// // // // // // // //         },
// // // // // // // //         body: json.encode({'sidebar': data}),
// // // // // // // //       );
// // // // // // // //
// // // // // // // //       print("🔹 updateSidebarPermissions response (${response.statusCode}): ${response.body}");
// // // // // // // //
// // // // // // // //       return response.statusCode == 200;
// // // // // // // //     } catch (e) {
// // // // // // // //       print('Error updating sidebar: $e');
// // // // // // // //       return false;
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //   /// ===================== Sidebar Toggle Helpers =====================
// // // // // // // //   void toggleSidebarPermission(String key, String permType, bool value) {
// // // // // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // // // // //       sidebarPermissionStates[key]![permType] = value;
// // // // // // // //       notifyListeners();
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   bool getSidebarAll(String key) {
// // // // // // // //     final perms = sidebarPermissionStates[key];
// // // // // // // //     if (perms == null) return false;
// // // // // // // //     return perms.values.every((v) => v);
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   void toggleSidebarAll(String key, bool value) {
// // // // // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // // // // //       sidebarPermissionStates[key]!.updateAll((k, v) => value);
// // // // // // // //       notifyListeners();
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // // }
// // // // // // //
// // // // // // //
// // // // // // // import 'dart:convert';
// // // // // // // import 'package:flutter/material.dart';
// // // // // // // import 'package:http/http.dart' as http;
// // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // //
// // // // // // // import '../environmental variables.dart';
// // // // // // //
// // // // // // // // 🌍 Base API URL (update with your backend URL)
// // // // // // // // const String baseUrl = "$baseUrl/api/roles";
// // // // // // //
// // // // // // // class RolesController extends ChangeNotifier {
// // // // // // //   bool isLoading = false;
// // // // // // //   List<Map<String, dynamic>> roles = [];
// // // // // // //
// // // // // // //   /// ✅ Get Token from SharedPreferences
// // // // // // //   Future<String?> _getToken() async {
// // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // //     return prefs.getString("accessToken");
// // // // // // //   }
// // // // // // //
// // // // // // //   /// ✅ Create Role
// // // // // // //   Future<bool> createRole(String name, String description) async {
// // // // // // //     try {
// // // // // // //       isLoading = true;
// // // // // // //       notifyListeners();
// // // // // // //
// // // // // // //       final token = await _getToken();
// // // // // // //       final response = await http.post(
// // // // // // //         Uri.parse('$baseUrl/api/roles'),
// // // // // // //         headers: {
// // // // // // //           "Content-Type": "application/json",
// // // // // // //           "Authorization": "Bearer $token",
// // // // // // //         },
// // // // // // //         body: jsonEncode({"name": name, "description": description}),
// // // // // // //       );
// // // // // // //
// // // // // // //       if (response.statusCode == 201) {
// // // // // // //         await fetchRoles(); // refresh roles list
// // // // // // //         return true;
// // // // // // //       } else {
// // // // // // //         debugPrint("Create Role Failed: ${response.body}");
// // // // // // //         return false;
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint("Create Role Error: $e");
// // // // // // //       return false;
// // // // // // //     } finally {
// // // // // // //       isLoading = false;
// // // // // // //       notifyListeners();
// // // // // // //     }
// // // // // // //   }
// // // // // // //
// // // // // // //   /// ✅ Get Roles
// // // // // // //   Future<void> fetchRoles() async {
// // // // // // //     try {
// // // // // // //       isLoading = true;
// // // // // // //       notifyListeners();
// // // // // // //
// // // // // // //       final token = await _getToken();
// // // // // // //       final response = await http.get(
// // // // // // //         Uri.parse('$baseUrl/api/roles'),
// // // // // // //         headers: {"Authorization": "Bearer $token"},
// // // // // // //       );
// // // // // // //
// // // // // // //       if (response.statusCode == 200) {
// // // // // // //         List<dynamic> data = jsonDecode(response.body);
// // // // // // //         roles = List<Map<String, dynamic>>.from(data);
// // // // // // //       } else {
// // // // // // //         debugPrint("Fetch Roles Failed: ${response.body}");
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint("Fetch Roles Error: $e");
// // // // // // //     } finally {
// // // // // // //       isLoading = false;
// // // // // // //       notifyListeners();
// // // // // // //     }
// // // // // // //   }
// // // // // // //
// // // // // // //   /// ✅ Update Role
// // // // // // //   Future<bool> updateRole(String id, String name, String description) async {
// // // // // // //     try {
// // // // // // //       isLoading = true;
// // // // // // //       notifyListeners();
// // // // // // //
// // // // // // //       final token = await _getToken();
// // // // // // //       final response = await http.put(
// // // // // // //         Uri.parse("$baseUrl/api/roles/$id"),
// // // // // // //         headers: {
// // // // // // //           "Content-Type": "application/json",
// // // // // // //           "Authorization": "Bearer $token",
// // // // // // //         },
// // // // // // //         body: jsonEncode({"name": name, "description": description}),
// // // // // // //       );
// // // // // // //
// // // // // // //       if (response.statusCode == 200) {
// // // // // // //         await fetchRoles(); // refresh roles
// // // // // // //         return true;
// // // // // // //       } else {
// // // // // // //         debugPrint("Update Role Failed: ${response.body}");
// // // // // // //         return false;
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint("Update Role Error: $e");
// // // // // // //       return false;
// // // // // // //     } finally {
// // // // // // //       isLoading = false;
// // // // // // //       notifyListeners();
// // // // // // //     }
// // // // // // //   }
// // // // // // //
// // // // // // //   /// ✅ Delete Role
// // // // // // //   Future<bool> deleteRole(String id) async {
// // // // // // //     try {
// // // // // // //       isLoading = true;
// // // // // // //       notifyListeners();
// // // // // // //
// // // // // // //       final token = await _getToken();
// // // // // // //       final response = await http.delete(
// // // // // // //         Uri.parse("$baseUrl/api/roles/$id"),
// // // // // // //         headers: {"Authorization": "Bearer $token"},
// // // // // // //       );
// // // // // // //
// // // // // // //       if (response.statusCode == 200) {
// // // // // // //         roles.removeWhere((role) => role["_id"] == id);
// // // // // // //         notifyListeners();
// // // // // // //         return true;
// // // // // // //       } else {
// // // // // // //         debugPrint("Delete Role Failed: ${response.body}");
// // // // // // //         return false;
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint("Delete Role Error: $e");
// // // // // // //       return false;
// // // // // // //     } finally {
// // // // // // //       isLoading = false;
// // // // // // //       notifyListeners();
// // // // // // //     }
// // // // // // //   }
// // // // // // // }
// // // // // //
// // // // // //
// // // // // // // lib/Controller/Roles_controller.dart
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:http/http.dart' as http;
// // // // // // import 'dart:convert';
// // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // import 'package:ancilmediaadminpanel/environmental variables.dart';
// // // // // //
// // // // // // class RolesController extends ChangeNotifier {
// // // // // //   bool isLoading = true;
// // // // // //
// // // // // //   // ===== Roles =====
// // // // // //   List<dynamic> roles = [];
// // // // // //
// // // // // //   // ===== Permissions =====
// // // // // //   Map<String, List<Map<String, dynamic>>> permissionCategories = {};
// // // // // //   Map<String, bool> permissionStates = {};
// // // // // //
// // // // // //   // ===== Sidebar =====
// // // // // //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {
// // // // // //     "Dashboard": [
// // // // // //       {"key": "dashboard", "label": "Dashboard"},
// // // // // //     ],
// // // // // //     "Users": [
// // // // // //       {"key": "users", "label": "Users"},
// // // // // //       {"key": "roles", "label": "Roles"},
// // // // // //     ],
// // // // // //     "Settings": [
// // // // // //       {"key": "settings", "label": "Settings"},
// // // // // //     ],
// // // // // //   };
// // // // // //
// // // // // //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// // // // // //
// // // // // //   // ===== Token Helper =====
// // // // // //   Future<String?> _getToken() async {
// // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // //     return prefs.getString('accessToken');
// // // // // //   }
// // // // // //
// // // // // //   // ===== Roles CRUD =====
// // // // // //   Future<void> fetchRoles() async {
// // // // // //     isLoading = true;
// // // // // //     notifyListeners();
// // // // // //     try {
// // // // // //       final token = await _getToken();
// // // // // //       final res = await http.get(
// // // // // //         Uri.parse('$baseUrl/api/roles'),
// // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // //       );
// // // // // //
// // // // // //       debugPrint("📡 fetchRoles → ${res.statusCode} :: ${res.body}");
// // // // // //
// // // // // //       if (res.statusCode == 200) {
// // // // // //         roles = json.decode(res.body);
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       debugPrint("❌ fetchRoles error: $e");
// // // // // //     }
// // // // // //     isLoading = false;
// // // // // //     notifyListeners();
// // // // // //   }
// // // // // //
// // // // // //   Future<bool> createRole(String name) async {
// // // // // //     try {
// // // // // //       final token = await _getToken();
// // // // // //       final res = await http.post(
// // // // // //         Uri.parse('$baseUrl/api/roles'),
// // // // // //         headers: {
// // // // // //           'Authorization': 'Bearer $token',
// // // // // //           'Content-Type': 'application/json',
// // // // // //         },
// // // // // //         body: json.encode({'name': name}),
// // // // // //       );
// // // // // //
// // // // // //       debugPrint("📡 createRole → ${res.statusCode} :: ${res.body}");
// // // // // //
// // // // // //       if (res.statusCode == 201) {
// // // // // //         await fetchRoles();
// // // // // //         return true;
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       debugPrint("❌ createRole error: $e");
// // // // // //     }
// // // // // //     return false;
// // // // // //   }
// // // // // //
// // // // // //   Future<bool> deleteRole(String id) async {
// // // // // //     try {
// // // // // //       final token = await _getToken();
// // // // // //       final res = await http.delete(
// // // // // //         Uri.parse('$baseUrl/api/roles/$id'),
// // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // //       );
// // // // // //
// // // // // //       debugPrint("📡 deleteRole → ${res.statusCode} :: ${res.body}");
// // // // // //
// // // // // //       if (res.statusCode == 200) {
// // // // // //         roles.removeWhere((r) => r['_id'] == id);
// // // // // //         notifyListeners();
// // // // // //         return true;
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       debugPrint("❌ deleteRole error: $e");
// // // // // //     }
// // // // // //     return false;
// // // // // //   }
// // // // // //
// // // // // //   // ===== Sidebar Permissions =====
// // // // // //
// // // // // //   Future<void> refreshRole(String roleId) async {
// // // // // //     isLoading = true;
// // // // // //     notifyListeners();
// // // // // //     try {
// // // // // //       final token = await _getToken();
// // // // // //       final res = await http.get(
// // // // // //         Uri.parse('$baseUrl/api/roles/$roleId'),
// // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // //       );
// // // // // //
// // // // // //       debugPrint("📡 refreshRole($roleId) → ${res.statusCode} :: ${res.body}");
// // // // // //
// // // // // //       if (res.statusCode == 200) {
// // // // // //         final data = json.decode(res.body);
// // // // // //         Map<String, dynamic> sidebar = data['sidebarPermissions'] ?? {};
// // // // // //
// // // // // //         sidebarPermissionStates = {};
// // // // // //         for (var entry in sidebar.entries) {
// // // // // //           sidebarPermissionStates[entry.key] = {
// // // // // //             'view': entry.value['view'] ?? false,
// // // // // //             'read': entry.value['read'] ?? false,
// // // // // //             'manage': entry.value['manage'] ?? false,
// // // // // //           };
// // // // // //         }
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       debugPrint("❌ refreshRole error: $e");
// // // // // //     }
// // // // // //     isLoading = false;
// // // // // //     notifyListeners();
// // // // // //   }
// // // // // //
// // // // // //   void toggleSidebarPermission(String key, String perm, bool value) {
// // // // // //     sidebarPermissionStates[key] ??= {'view': false, 'read': false, 'manage': false};
// // // // // //     sidebarPermissionStates[key]![perm] = value;
// // // // // //     debugPrint("🔄 toggleSidebarPermission($key, $perm) → $value");
// // // // // //     notifyListeners();
// // // // // //   }
// // // // // //
// // // // // //   bool getSidebarAll(String key) {
// // // // // //     final perms = sidebarPermissionStates[key] ?? {};
// // // // // //     return (perms['view'] ?? false) &&
// // // // // //         (perms['read'] ?? false) &&
// // // // // //         (perms['manage'] ?? false);
// // // // // //   }
// // // // // //
// // // // // //   void toggleSidebarAll(String key, bool value) {
// // // // // //     sidebarPermissionStates[key] = {
// // // // // //       'view': value,
// // // // // //       'read': value,
// // // // // //       'manage': value,
// // // // // //     };
// // // // // //     debugPrint("🔄 toggleSidebarAll($key) → $value");
// // // // // //     notifyListeners();
// // // // // //   }
// // // // // //
// // // // // //   Future<bool> updateSidebarPermissions() async {
// // // // // //     try {
// // // // // //       final token = await _getToken();
// // // // // //       final res = await http.put(
// // // // // //         Uri.parse('$baseUrl/api/roles/sidebar'),
// // // // // //         headers: {
// // // // // //           'Authorization': 'Bearer $token',
// // // // // //           'Content-Type': 'application/json',
// // // // // //         },
// // // // // //         body: json.encode({'permissions': sidebarPermissionStates}),
// // // // // //       );
// // // // // //
// // // // // //       debugPrint("📡 updateSidebarPermissions → ${res.statusCode} :: ${res.body}");
// // // // // //
// // // // // //       return res.statusCode == 200;
// // // // // //     } catch (e) {
// // // // // //       debugPrint("❌ updateSidebarPermissions error: $e");
// // // // // //       return false;
// // // // // //     }
// // // // // //   }
// // // // // // }
// // // // //
// // // // //
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:http/http.dart' as http;
// // // // // import 'dart:convert';
// // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // import 'package:ancilmediaadminpanel/environmental variables.dart';
// // // // //
// // // // // class RolesController extends ChangeNotifier {
// // // // //   bool isLoading = true;
// // // // //
// // // // //   // Roles
// // // // //   List<Map<String, dynamic>> roles = [];
// // // // //
// // // // //   // Permissions
// // // // //   Map<String, List<Map<String, dynamic>>> permissionCategories = {};
// // // // //   Map<String, bool> permissionStates = {};
// // // // //
// // // // //   // Sidebar
// // // // //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
// // // // //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// // // // //
// // // // //   // ================= TOKEN =================
// // // // //   Future<String?> _getToken() async {
// // // // //     final prefs = await SharedPreferences.getInstance();
// // // // //     return prefs.getString("accessToken");
// // // // //   }
// // // // //
// // // // //   // ================= ROLES =================
// // // // //   Future<void> fetchRoles() async {
// // // // //     isLoading = true;
// // // // //     notifyListeners();
// // // // //     try {
// // // // //       final token = await _getToken();
// // // // //       final res = await http.get(
// // // // //         Uri.parse('$baseUrl/api/roles'),
// // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // //       );
// // // // //
// // // // //       debugPrint("📡 fetchRoles → ${res.statusCode} :: ${res.body}");
// // // // //
// // // // //       if (res.statusCode == 200) {
// // // // //         roles = List<Map<String, dynamic>>.from(json.decode(res.body));
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint("❌ fetchRoles error: $e");
// // // // //     }
// // // // //     isLoading = false;
// // // // //     notifyListeners();
// // // // //   }
// // // // //
// // // // //   // ================= PERMISSIONS =================
// // // // //   Future<void> fetchPermissions(String roleId) async {
// // // // //     isLoading = true;
// // // // //     notifyListeners();
// // // // //     try {
// // // // //       final token = await _getToken();
// // // // //       final res = await http.get(
// // // // //         Uri.parse('$baseUrl/api/permissions/$roleId'),
// // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // //       );
// // // // //
// // // // //       debugPrint("📡 fetchPermissions($roleId) → ${res.statusCode} :: ${res.body}");
// // // // //
// // // // //       if (res.statusCode == 200) {
// // // // //         final data = json.decode(res.body);
// // // // //
// // // // //         permissionCategories = {};
// // // // //         permissionStates = {};
// // // // //
// // // // //         for (var item in data['permissions']) {
// // // // //           String category = item['category'] ?? "General";
// // // // //           permissionCategories[category] ??= [];
// // // // //           permissionCategories[category]!.add(item);
// // // // //
// // // // //           permissionStates[item['key']] = item['value'] ?? false;
// // // // //         }
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint("❌ fetchPermissions error: $e");
// // // // //     }
// // // // //     isLoading = false;
// // // // //     notifyListeners();
// // // // //   }
// // // // //
// // // // //   void togglePermission(String key) {
// // // // //     permissionStates[key] = !(permissionStates[key] ?? false);
// // // // //     notifyListeners();
// // // // //   }
// // // // //
// // // // //   // ================= SIDEBAR =================
// // // // //   Future<void> fetchSidebarForRole(String roleId) async {
// // // // //     isLoading = true;
// // // // //     notifyListeners();
// // // // //     try {
// // // // //       final token = await _getToken();
// // // // //
// // // // //       // 🔹 Get logged-in role
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       final loggedInRole = prefs.getString("role")?.toLowerCase();
// // // // //       final isAdmin = loggedInRole == "admin";
// // // // //
// // // // //       final res = await http.get(
// // // // //         Uri.parse('$baseUrl/api/sidebar/$roleId'),
// // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // //       );
// // // // //
// // // // //       debugPrint("📡 fetchSidebarForRole($roleId) → ${res.statusCode} :: ${res.body}");
// // // // //
// // // // //       if (res.statusCode == 200) {
// // // // //         final data = json.decode(res.body);
// // // // //
// // // // //         List items = data['items'] ?? [];
// // // // //         List permissions = data['sidebarPermissions'] ?? [];
// // // // //
// // // // //         sidebarCategories = {};
// // // // //         sidebarPermissionStates = {};
// // // // //
// // // // //         for (var item in items) {
// // // // //           String category = "Default"; // or item['category']
// // // // //           String key = item['key'];
// // // // //           String label = item['label'];
// // // // //
// // // // //           sidebarCategories[category] ??= [];
// // // // //           sidebarCategories[category]!.add({
// // // // //             "key": key,
// // // // //             "label": label,
// // // // //             "icon": item['icon'] ?? "",
// // // // //           });
// // // // //
// // // // //           // ================= RULE =================
// // // // //           if (isAdmin) {
// // // // //             // Admin → show all items (with toggles, default = false if not set)
// // // // //             var match = permissions.firstWhere(
// // // // //                   (p) => p['key'] == key,
// // // // //               orElse: () => null,
// // // // //             );
// // // // //
// // // // //             sidebarPermissionStates[key] = {
// // // // //               'view': match?['permissions']?['view'] ?? false,
// // // // //               'read': match?['permissions']?['read'] ?? false,
// // // // //               'manage': match?['permissions']?['manage'] ?? false,
// // // // //             };
// // // // //           } else {
// // // // //             // Non-admin → only show items with explicit permissions
// // // // //             var match = permissions.firstWhere(
// // // // //                   (p) => p['key'] == key,
// // // // //               orElse: () => null,
// // // // //             );
// // // // //
// // // // //             if (match != null) {
// // // // //               sidebarPermissionStates[key] = {
// // // // //                 'view': match['permissions']?['view'] ?? false,
// // // // //                 'read': match['permissions']?['read'] ?? false,
// // // // //                 'manage': match['permissions']?['manage'] ?? false,
// // // // //               };
// // // // //             }
// // // // //           }
// // // // //         }
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint("❌ fetchSidebarForRole error: $e");
// // // // //     }
// // // // //     isLoading = false;
// // // // //     notifyListeners();
// // // // //   }
// // // // //
// // // // //
// // // // //   void toggleSidebarPermission(String key, String type) {
// // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // //       sidebarPermissionStates[key]![type] =
// // // // //       !(sidebarPermissionStates[key]![type] ?? false);
// // // // //       notifyListeners();
// // // // //     }
// // // // //   }
// // // // //
// // // // //   bool getSidebarAll(String key) {
// // // // //     if (!sidebarPermissionStates.containsKey(key)) return false;
// // // // //     return sidebarPermissionStates[key]!.values.every((v) => v);
// // // // //   }
// // // // //
// // // // //   void toggleSidebarAll(String key, bool value) {
// // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // //       sidebarPermissionStates[key] = {
// // // // //         'view': value,
// // // // //         'read': value,
// // // // //         'manage': value,
// // // // //       };
// // // // //       notifyListeners();
// // // // //     }
// // // // //   }
// // // // //
// // // // //   Future<void> updateSidebarPermissions(String roleId) async {
// // // // //     try {
// // // // //       final token = await _getToken();
// // // // //       final payload = {
// // // // //         "sidebarPermissions": sidebarPermissionStates.entries.map((e) {
// // // // //           return {
// // // // //             "key": e.key,
// // // // //             "permissions": e.value,
// // // // //           };
// // // // //         }).toList(),
// // // // //       };
// // // // //
// // // // //       debugPrint("📤 updateSidebarPermissions payload: ${json.encode(payload)}");
// // // // //
// // // // //       final res = await http.put(
// // // // //         Uri.parse('$baseUrl/api/sidebar/$roleId'),
// // // // //         headers: {
// // // // //           'Authorization': 'Bearer $token',
// // // // //           'Content-Type': 'application/json',
// // // // //         },
// // // // //         body: json.encode(payload),
// // // // //       );
// // // // //
// // // // //       debugPrint("📡 updateSidebarPermissions → ${res.statusCode} :: ${res.body}");
// // // // //     } catch (e) {
// // // // //       debugPrint("❌ updateSidebarPermissions error: $e");
// // // // //     }
// // // // //   }
// // // // // }
// // // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'dart:convert';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import 'package:ancilmediaadminpanel/environmental variables.dart';
// // // //
// // // // class RolesController extends ChangeNotifier {
// // // //   bool isLoading = true;
// // // //
// // // //   // Roles
// // // //   List<Map<String, dynamic>> roles = [];
// // // //
// // // //   // Permissions
// // // //   Map<String, List<Map<String, dynamic>>> permissionCategories = {};
// // // //   Map<String, bool> permissionStates = {};
// // // //
// // // //   // Sidebar
// // // //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
// // // //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// // // //
// // // //   // ================= TOKEN =================
// // // //   Future<String?> _getToken() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     return prefs.getString("accessToken");
// // // //   }
// // // //
// // // //   // ================= ROLES =================
// // // //   Future<void> fetchRoles() async {
// // // //     isLoading = true;
// // // //     notifyListeners();
// // // //     try {
// // // //       final token = await _getToken();
// // // //       final res = await http.get(
// // // //         Uri.parse('$baseUrl/api/roles'),
// // // //         headers: {'Authorization': 'Bearer $token'},
// // // //       );
// // // //
// // // //       debugPrint("📡 fetchRoles → ${res.statusCode} :: ${res.body}");
// // // //
// // // //       if (res.statusCode == 200) {
// // // //         roles = List<Map<String, dynamic>>.from(json.decode(res.body));
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint("❌ fetchRoles error: $e");
// // // //     }
// // // //     isLoading = false;
// // // //     notifyListeners();
// // // //   }
// // // //
// // // //   // ================= PERMISSIONS =================
// // // //   Future<void> fetchPermissions(String roleId) async {
// // // //     isLoading = true;
// // // //     notifyListeners();
// // // //     try {
// // // //       final token = await _getToken();
// // // //       final res = await http.get(
// // // //         Uri.parse('$baseUrl/api/permissions/$roleId'),
// // // //         headers: {'Authorization': 'Bearer $token'},
// // // //       );
// // // //
// // // //       debugPrint("📡 fetchPermissions($roleId) → ${res.statusCode} :: ${res.body}");
// // // //
// // // //       if (res.statusCode == 200) {
// // // //         final data = json.decode(res.body);
// // // //
// // // //         permissionCategories = {};
// // // //         permissionStates = {};
// // // //
// // // //         for (var item in data['permissions']) {
// // // //           String category = item['category'] ?? "General";
// // // //           permissionCategories[category] ??= [];
// // // //           permissionCategories[category]!.add(item);
// // // //
// // // //           permissionStates[item['key']] = item['value'] ?? false;
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint("❌ fetchPermissions error: $e");
// // // //     }
// // // //     isLoading = false;
// // // //     notifyListeners();
// // // //   }
// // // //
// // // //   void togglePermission(String key) {
// // // //     permissionStates[key] = !(permissionStates[key] ?? false);
// // // //     notifyListeners();
// // // //   }
// // // //
// // // //   // ================= SIDEBAR =================
// // // //   Future<void> fetchSidebarForRole(String roleId, {bool forceAll = false}) async {
// // // //     isLoading = true;
// // // //     notifyListeners();
// // // //     try {
// // // //       final token = await _getToken();
// // // //
// // // //       // 🔹 First, get logged-in user role from SharedPreferences
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       final loggedInRole = prefs.getString("userRole") ?? ""; // store userRole on login
// // // //
// // // //       final res = await http.get(
// // // //         Uri.parse('$baseUrl/api/sidebar/$roleId'),
// // // //         headers: {'Authorization': 'Bearer $token'},
// // // //       );
// // // //
// // // //       debugPrint("📡 fetchSidebarForRole($roleId as $loggedInRole) → ${res.statusCode} :: ${res.body}");
// // // //
// // // //       if (res.statusCode == 200) {
// // // //         final data = json.decode(res.body);
// // // //
// // // //         List items = data['items'] ?? [];
// // // //         List permissions = data['sidebarPermissions'] ?? [];
// // // //
// // // //         // 🔹 If logged in user is ADMIN → ignore role’s items and fetch all sidebar items
// // // //         if (loggedInRole == "admin") {
// // // //           final allRes = await http.get(
// // // //             Uri.parse('$baseUrl/api/sidebar/all'),
// // // //             headers: {'Authorization': 'Bearer $token'},
// // // //           );
// // // //
// // // //           if (allRes.statusCode == 200) {
// // // //             final allData = json.decode(allRes.body);
// // // //             items = allData['items'] ?? [];
// // // //           }
// // // //         }
// // // //
// // // //         sidebarCategories = {};
// // // //         sidebarPermissionStates = {};
// // // //
// // // //         for (var item in items) {
// // // //           String category = "Default";
// // // //           String key = item['key'];
// // // //           String label = item['label'];
// // // //
// // // //           sidebarCategories[category] ??= [];
// // // //           sidebarCategories[category]!.add({
// // // //             "key": key,
// // // //             "label": label,
// // // //             "icon": item['icon'] ?? "",
// // // //           });
// // // //
// // // //           var match = permissions.firstWhere(
// // // //                 (p) => p['key'] == key,
// // // //             orElse: () => null,
// // // //           );
// // // //
// // // //           sidebarPermissionStates[key] = {
// // // //             'view': match?['permissions']?['view'] ?? false,
// // // //             'read': match?['permissions']?['read'] ?? false,
// // // //             'manage': match?['permissions']?['manage'] ?? false,
// // // //           };
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint("❌ fetchSidebarForRole error: $e");
// // // //     }
// // // //     isLoading = false;
// // // //     notifyListeners();
// // // //   }
// // // //
// // // //   void toggleSidebarPermission(String key, String type) {
// // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // //       sidebarPermissionStates[key]![type] =
// // // //       !(sidebarPermissionStates[key]![type] ?? false);
// // // //       notifyListeners();
// // // //     }
// // // //   }
// // // //
// // // //   bool getSidebarAll(String key) {
// // // //     if (!sidebarPermissionStates.containsKey(key)) return false;
// // // //     return sidebarPermissionStates[key]!.values.every((v) => v);
// // // //   }
// // // //
// // // //   void toggleSidebarAll(String key, bool value) {
// // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // //       sidebarPermissionStates[key] = {
// // // //         'view': value,
// // // //         'read': value,
// // // //         'manage': value,
// // // //       };
// // // //       notifyListeners();
// // // //     }
// // // //   }
// // // //
// // // //   Future<void> updateSidebarPermissions(String roleId) async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       final token = prefs.getString('accessToken');
// // // //       if (token == null) return;
// // // //
// // // //       final sidebar = sidebarPermissionStates.entries.map((entry) {
// // // //         return {
// // // //           "key": entry.key,
// // // //           "permissions": {
// // // //             "view": entry.value["view"] ?? false,
// // // //             "read": entry.value["read"] ?? false,
// // // //             "manage": entry.value["manage"] ?? false,
// // // //           }
// // // //         };
// // // //       }).toList();
// // // //
// // // //       final res = await http.put(
// // // //         Uri.parse('$baseUrl/api/sidebar/assign/$roleId'), // 👈 correct endpoint
// // // //         headers: {
// // // //           'Content-Type': 'application/json',
// // // //           'Authorization': 'Bearer $token',
// // // //         },
// // // //         body: json.encode({"sidebar": sidebar}),
// // // //       );
// // // //
// // // //       if (res.statusCode == 200) {
// // // //         debugPrint("✅ Sidebar permissions updated for $roleId");
// // // //       } else {
// // // //         debugPrint("❌ Failed: ${res.statusCode} :: ${res.body}");
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint("⚠️ updateSidebarPermissions error: $e");
// // // //     }
// // // //   }
// // // // }
// // //
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'dart:convert';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:ancilmediaadminpanel/environmental variables.dart';
// // //
// // // class RolesController extends ChangeNotifier {
// // //   bool isLoading = true;
// // //
// // //   // Roles
// // //   List<Map<String, dynamic>> roles = [];
// // //
// // //   // Permissions
// // //   Map<String, List<Map<String, dynamic>>> permissionCategories = {};
// // //   Map<String, bool> permissionStates = {};
// // //
// // //   // Sidebar
// // //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
// // //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// // //
// // //   // ================= TOKEN =================
// // //   Future<String?> _getToken() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     return prefs.getString("accessToken");
// // //   }
// // //
// // //   // ================= ROLES =================
// // //   Future<void> fetchRoles() async {
// // //     isLoading = true;
// // //     notifyListeners();
// // //     try {
// // //       final token = await _getToken();
// // //       final res = await http.get(
// // //         Uri.parse('$baseUrl/api/roles'),
// // //         headers: {'Authorization': 'Bearer $token'},
// // //       );
// // //
// // //       debugPrint("📡 fetchRoles → ${res.statusCode} :: ${res.body}");
// // //
// // //       if (res.statusCode == 200) {
// // //         roles = List<Map<String, dynamic>>.from(json.decode(res.body));
// // //       }
// // //     } catch (e) {
// // //       debugPrint("❌ fetchRoles error: $e");
// // //     }
// // //     isLoading = false;
// // //     notifyListeners();
// // //   }
// // //
// // //   // ================= PERMISSIONS =================
// // //   Future<void> fetchPermissions(String roleId) async {
// // //     isLoading = true;
// // //     notifyListeners();
// // //     try {
// // //       final token = await _getToken();
// // //       final res = await http.get(
// // //         Uri.parse('$baseUrl/api/permissions/$roleId'),
// // //         headers: {'Authorization': 'Bearer $token'},
// // //       );
// // //
// // //       debugPrint("📡 fetchPermissions($roleId) → ${res.statusCode} :: ${res.body}");
// // //
// // //       if (res.statusCode == 200) {
// // //         final data = json.decode(res.body);
// // //
// // //         permissionCategories = {};
// // //         permissionStates = {};
// // //
// // //         for (var item in data['permissions']) {
// // //           String category = item['category'] ?? "General";
// // //           permissionCategories[category] ??= [];
// // //           permissionCategories[category]!.add(item);
// // //
// // //           permissionStates[item['key']] = item['value'] ?? false;
// // //         }
// // //       }
// // //     } catch (e) {
// // //       debugPrint("❌ fetchPermissions error: $e");
// // //     }
// // //     isLoading = false;
// // //     notifyListeners();
// // //   }
// // //
// // //   void togglePermission(String key) {
// // //     permissionStates[key] = !(permissionStates[key] ?? false);
// // //     notifyListeners();
// // //   }
// // //
// // //   // ================= SIDEBAR =================
// // //   Future<void> fetchSidebarForRole(String roleId, {bool forceAll = false}) async {
// // //     isLoading = true;
// // //     notifyListeners();
// // //     try {
// // //       final token = await _getToken();
// // //
// // //       final prefs = await SharedPreferences.getInstance();
// // //       final loggedInRole = prefs.getString("userRole") ?? "";
// // //
// // //       final res = await http.get(
// // //         Uri.parse('$baseUrl/api/sidebar/$roleId'),
// // //         headers: {'Authorization': 'Bearer $token'},
// // //       );
// // //
// // //       debugPrint("📡 fetchSidebarForRole($roleId as $loggedInRole) → ${res.statusCode} :: ${res.body}");
// // //
// // //       if (res.statusCode == 200) {
// // //         final data = json.decode(res.body);
// // //
// // //         List items = data['items'] ?? [];
// // //         List permissions = data['sidebarPermissions'] ?? [];
// // //
// // //         if (loggedInRole == "admin") {
// // //           final allRes = await http.get(
// // //             Uri.parse('$baseUrl/api/sidebar/all'),
// // //             headers: {'Authorization': 'Bearer $token'},
// // //           );
// // //
// // //           if (allRes.statusCode == 200) {
// // //             final allData = json.decode(allRes.body);
// // //             items = allData['items'] ?? [];
// // //           }
// // //         }
// // //
// // //         sidebarCategories = {};
// // //         sidebarPermissionStates = {};
// // //
// // //         for (var item in items) {
// // //           String category = "Default";
// // //           String key = item['key'];
// // //           String label = item['label'];
// // //
// // //           sidebarCategories[category] ??= [];
// // //           sidebarCategories[category]!.add({
// // //             "key": key,
// // //             "label": label,
// // //             "icon": item['icon'] ?? "",
// // //           });
// // //
// // //           var match = permissions.firstWhere(
// // //                 (p) => p['key'] == key,
// // //             orElse: () => null,
// // //           );
// // //
// // //           sidebarPermissionStates[key] = {
// // //             'view': match?['permissions']?['view'] ?? false,
// // //             'read': match?['permissions']?['read'] ?? false,
// // //             'manage': match?['permissions']?['manage'] ?? false,
// // //           };
// // //         }
// // //       }
// // //     } catch (e) {
// // //       debugPrint("❌ fetchSidebarForRole error: $e");
// // //     }
// // //     isLoading = false;
// // //     notifyListeners();
// // //   }
// // //
// // //   void toggleSidebarPermission(String key, String type) {
// // //     if (sidebarPermissionStates.containsKey(key)) {
// // //       sidebarPermissionStates[key]![type] =
// // //       !(sidebarPermissionStates[key]![type] ?? false);
// // //       notifyListeners();
// // //     }
// // //   }
// // //
// // //   bool getSidebarAll(String key) {
// // //     if (!sidebarPermissionStates.containsKey(key)) return false;
// // //     return sidebarPermissionStates[key]!.values.every((v) => v);
// // //   }
// // //
// // //   void toggleSidebarAll(String key, bool value) {
// // //     if (sidebarPermissionStates.containsKey(key)) {
// // //       sidebarPermissionStates[key] = {
// // //         'view': value,
// // //         'read': value,
// // //         'manage': value,
// // //       };
// // //       notifyListeners();
// // //     }
// // //   }
// // //
// // //   // ================= UPDATE ONLY MARKED =================
// // //   Future<void> updateSidebarPermissions(String roleId) async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       final token = prefs.getString('accessToken');
// // //       if (token == null) return;
// // //
// // //       final sidebar = sidebarPermissionStates.entries
// // //           .where((entry) =>
// // //       (entry.value["view"] ?? false) ||
// // //           (entry.value["read"] ?? false) ||
// // //           (entry.value["manage"] ?? false))
// // //           .map((entry) {
// // //         return {
// // //           "key": entry.key,
// // //           "permissions": {
// // //             "view": entry.value["view"] ?? false,
// // //             "read": entry.value["read"] ?? false,
// // //             "manage": entry.value["manage"] ?? false,
// // //           }
// // //         };
// // //       }).toList();
// // //
// // //       final res = await http.put(
// // //         Uri.parse('$baseUrl/api/sidebar/assign/$roleId'),
// // //         headers: {
// // //           'Content-Type': 'application/json',
// // //           'Authorization': 'Bearer $token',
// // //         },
// // //         body: json.encode({"sidebar": sidebar}),
// // //       );
// // //
// // //       if (res.statusCode == 200) {
// // //         debugPrint("✅ Sidebar permissions updated for $roleId");
// // //       } else {
// // //         debugPrint("❌ Failed: ${res.statusCode} :: ${res.body}");
// // //       }
// // //     } catch (e) {
// // //       debugPrint("⚠️ updateSidebarPermissions error: $e");
// // //     }
// // //   }
// // // }
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:ancilmediaadminpanel/environmental variables.dart';
// //
// // class RolesController extends ChangeNotifier {
// //   bool isLoading = true;
// //
// //   // Roles
// //   List<Map<String, dynamic>> roles = [];
// //
// //   // Permissions
// //   Map<String, List<Map<String, dynamic>>> permissionCategories = {};
// //   Map<String, bool> permissionStates = {};
// //
// //   // Sidebar
// //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
// //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// //
// //   // ================= TOKEN =================
// //   Future<String?> _getToken() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString("accessToken");
// //   }
// //
// //   // ================= ROLES =================
// //   Future<void> fetchRoles() async {
// //     isLoading = true;
// //     notifyListeners();
// //     try {
// //       final token = await _getToken();
// //       final res = await http.get(
// //         Uri.parse('$baseUrl/api/roles'),
// //         headers: {'Authorization': 'Bearer $token'},
// //       );
// //
// //       debugPrint("📡 fetchRoles → ${res.statusCode} :: ${res.body}");
// //
// //       if (res.statusCode == 200) {
// //         roles = List<Map<String, dynamic>>.from(json.decode(res.body));
// //       }
// //     } catch (e) {
// //       debugPrint("❌ fetchRoles error: $e");
// //     }
// //     isLoading = false;
// //     notifyListeners();
// //   }
// //
// //   // ================= PERMISSIONS =================
// //   Future<void> fetchPermissions(String roleId) async {
// //     isLoading = true;
// //     notifyListeners();
// //     try {
// //       final token = await _getToken();
// //       final res = await http.get(
// //         Uri.parse('$baseUrl/api/permissions/$roleId'),
// //         headers: {'Authorization': 'Bearer $token'},
// //       );
// //
// //       debugPrint("📡 fetchPermissions($roleId) → ${res.statusCode} :: ${res.body}");
// //
// //       if (res.statusCode == 200) {
// //         final data = json.decode(res.body);
// //
// //         permissionCategories = {};
// //         permissionStates = {};
// //
// //         for (var item in data['permissions']) {
// //           String category = item['category'] ?? "General";
// //           permissionCategories[category] ??= [];
// //           permissionCategories[category]!.add(item);
// //
// //           permissionStates[item['key']] = item['value'] ?? false;
// //         }
// //       }
// //     } catch (e) {
// //       debugPrint("❌ fetchPermissions error: $e");
// //     }
// //     isLoading = false;
// //     notifyListeners();
// //   }
// //
// //   void togglePermission(String key) {
// //     permissionStates[key] = !(permissionStates[key] ?? false);
// //     notifyListeners();
// //   }
// //
// //   // ================= SIDEBAR =================
// //   // Future<void> fetchSidebarForRole(String roleId, {bool forceAll = false}) async {
// //   //   isLoading = true;
// //   //   notifyListeners();
// //   //   try {
// //   //     final token = await _getToken();
// //   //
// //   //     final prefs = await SharedPreferences.getInstance();
// //   //     final loggedInRole = prefs.getString("userRole") ?? "";
// //   //
// //   //     final res = await http.get(
// //   //       Uri.parse('$baseUrl/api/sidebar/$roleId'),
// //   //       headers: {'Authorization': 'Bearer $token'},
// //   //     );
// //   //
// //   //     debugPrint("📡 fetchSidebarForRole($roleId as $loggedInRole) → ${res.statusCode} :: ${res.body}");
// //   //
// //   //     if (res.statusCode == 200) {
// //   //       final data = json.decode(res.body);
// //   //
// //   //       List items = data['items'] ?? [];
// //   //       List permissions = data['sidebarPermissions'] ?? [];
// //   //
// //   //       if (loggedInRole == "admin") {
// //   //         final allRes = await http.get(
// //   //           Uri.parse('$baseUrl/api/sidebar/all'),
// //   //           headers: {'Authorization': 'Bearer $token'},
// //   //         );
// //   //
// //   //         if (allRes.statusCode == 200) {
// //   //           final allData = json.decode(allRes.body);
// //   //           items = allData['items'] ?? [];
// //   //         }
// //   //       }
// //   //
// //   //       sidebarCategories = {};
// //   //       sidebarPermissionStates = {};
// //   //
// //   //       for (var item in items) {
// //   //         String category = "Default";
// //   //         String key = item['key'];
// //   //         String label = item['label'];
// //   //
// //   //         sidebarCategories[category] ??= [];
// //   //         sidebarCategories[category]!.add({
// //   //           "key": key,
// //   //           "label": label,
// //   //           "icon": item['icon'] ?? "",
// //   //         });
// //   //
// //   //         var match = permissions.firstWhere(
// //   //               (p) => p['key'] == key,
// //   //           orElse: () => null,
// //   //         );
// //   //
// //   //         sidebarPermissionStates[key] = {
// //   //           'view': match?['permissions']?['view'] ?? false,
// //   //           'read': match?['permissions']?['read'] ?? false,
// //   //           'manage': match?['permissions']?['manage'] ?? false,
// //   //         };
// //   //       }
// //   //     }
// //   //   } catch (e) {
// //   //     debugPrint("❌ fetchSidebarForRole error: $e");
// //   //   }
// //   //   isLoading = false;
// //   //   notifyListeners();
// //   // }
// //
// //   Future<void> fetchSidebarForRole(String roleId) async {
// //     isLoading = true;
// //     notifyListeners();
// //
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       final token = prefs.getString('token');
// //       final response = await http.get(
// //         Uri.parse('$baseUrl/role/$roleId'),
// //         headers: {'Authorization': 'Bearer $token'},
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //
// //         sidebarCategories.clear();
// //         sidebarPermissionStates.clear();
// //
// //         if (data['sidebarPermissions'] != null) {
// //           for (var item in data['sidebarPermissions']) {
// //             String key = item['key'];
// //             sidebarPermissionStates[key] = {
// //               'view': item['permissions']?['view'] ?? false,
// //               'read': item['permissions']?['read'] ?? false,
// //               'manage': item['permissions']?['manage'] ?? false,
// //             };
// //
// //             // Group by category (or just one default if no category)
// //             sidebarCategories.putIfAbsent("Sidebar", () => []).add(item);
// //           }
// //         }
// //       }
// //     } catch (e) {
// //       debugPrint("❌ fetchSidebarForRole error: $e");
// //     }
// //
// //     isLoading = false;
// //     notifyListeners();
// //   }
// //
// //   void _setLoading(bool value) {
// //     isLoading = value;
// //     notifyListeners();
// //   }
// //
// //   void toggleSidebarPermission(String key, String type) {
// //     if (sidebarPermissionStates.containsKey(key)) {
// //       sidebarPermissionStates[key]![type] =
// //       !(sidebarPermissionStates[key]![type] ?? false);
// //       notifyListeners();
// //     }
// //   }
// //
// //   bool getSidebarAll(String key) {
// //     if (!sidebarPermissionStates.containsKey(key)) return false;
// //     return sidebarPermissionStates[key]!.values.every((v) => v);
// //   }
// //
// //   void toggleSidebarAll(String key, bool value) {
// //     if (sidebarPermissionStates.containsKey(key)) {
// //       sidebarPermissionStates[key] = {
// //         'view': value,
// //         'read': value,
// //         'manage': value,
// //       };
// //       notifyListeners();
// //     }
// //   }
// //
// //   /// 🔹 NEW: Get only the marked sidebar items
// //   List<Map<String, dynamic>> getMarkedSidebarItems() {
// //     return sidebarPermissionStates.entries
// //         .where((entry) =>
// //         entry.value.values.any((v) => v == true)) // keep only items with at least 1 true
// //         .map((entry) {
// //       return {
// //         "key": entry.key,
// //         "permissions": {
// //           "view": entry.value["view"] ?? false,
// //           "read": entry.value["read"] ?? false,
// //           "manage": entry.value["manage"] ?? false,
// //         }
// //       };
// //     })
// //         .toList();
// //   }
// //
// //   /// 🔹 API update → Only send marked items
// //   Future<void> updateSidebarPermissions(String roleId) async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       final token = prefs.getString('accessToken');
// //       if (token == null) return;
// //
// //       final sidebar = getMarkedSidebarItems(); // ✅ send only marked
// //
// //       final res = await http.put(
// //         Uri.parse('$baseUrl/api/sidebar/assign/$roleId'),
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'Authorization': 'Bearer $token',
// //         },
// //         body: json.encode({"sidebar": sidebar}),
// //       );
// //
// //       if (res.statusCode == 200) {
// //         debugPrint("✅ Sidebar permissions updated for $roleId");
// //       } else {
// //         debugPrint("❌ Failed: ${res.statusCode} :: ${res.body}");
// //       }
// //     } catch (e) {
// //       debugPrint("⚠️ updateSidebarPermissions error: $e");
// //     }
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ancilmediaadminpanel/environmental variables.dart';
//
// class RolesController extends ChangeNotifier {
//   bool isLoading = true;
//
//   // Roles list
//   List<Map<String, dynamic>> roles = [];
//
//   // Sidebar categories (grouped items)
//   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
//
//   // Sidebar states: { "dashboard": {"view": true, "read": false, "manage": false} }
//   Map<String, Map<String, bool>> sidebarPermissionStates = {};
//
//   /// 🔹 Fetch all roles
//   Future<void> fetchRoles() async {
//     try {
//       isLoading = true;
//       notifyListeners();
//
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString("token");
//
//       final response = await http.get(
//         Uri.parse("$baseUrl/roles"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         roles = List<Map<String, dynamic>>.from(data);
//       }
//     } catch (e) {
//       debugPrint("Error fetching roles: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /// 🔹 Fetch sidebar permissions for a specific role
//   Future<void> fetchSidebarForRole(String roleId) async {
//     try {
//       isLoading = true;
//       notifyListeners();
//
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString("token");
//
//       final response = await http.get(
//         Uri.parse("$baseUrl/roles/$roleId/sidebar"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         // Expected structure: { "Category": [ { key, label, permissions } ] }
//         sidebarCategories = {};
//         sidebarPermissionStates = {};
//
//         for (var category in data.keys) {
//           final items = List<Map<String, dynamic>>.from(data[category]);
//
//           sidebarCategories[category] = items;
//
//           for (var item in items) {
//             sidebarPermissionStates[item['key']] = {
//               "view": item["permissions"]["view"] ?? false,
//               "read": item["permissions"]["read"] ?? false,
//               "manage": item["permissions"]["manage"] ?? false,
//             };
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint("Error fetching sidebar: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /// 🔹 Toggle a single sidebar permission
//   void toggleSidebarPermission(String key, String permission) {
//     if (sidebarPermissionStates.containsKey(key)) {
//       sidebarPermissionStates[key]![permission] =
//       !(sidebarPermissionStates[key]![permission] ?? false);
//       notifyListeners();
//     }
//   }
//
//   /// 🔹 Toggle all (view, read, manage) for an item
//   void toggleSidebarAll(String key, bool value) {
//     if (sidebarPermissionStates.containsKey(key)) {
//       sidebarPermissionStates[key] = {
//         "view": value,
//         "read": value,
//         "manage": value,
//       };
//       notifyListeners();
//     }
//   }
//
//   /// 🔹 Get whether "All" should be checked
//   bool getSidebarAll(String key) {
//     if (!sidebarPermissionStates.containsKey(key)) return false;
//     final perms = sidebarPermissionStates[key]!;
//     return perms["view"] == true &&
//         perms["read"] == true &&
//         perms["manage"] == true;
//   }
//
//   /// 🔹 Update sidebar permissions in backend
//   Future<bool> updateSidebarPermissions(String roleId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString("token");
//
//       final response = await http.put(
//         Uri.parse("$baseUrl/roles/$roleId/sidebar"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode(sidebarPermissionStates),
//       );
//
//       if (response.statusCode == 200) {
//         return true; // ✅ success
//       } else {
//         debugPrint("Update failed: ${response.body}");
//         return false; // ❌ failure
//       }
//     } catch (e) {
//       debugPrint("Error updating sidebar: $e");
//       return false;
//     }
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ancilmediaadminpanel/environmental variables.dart';
//
// class RolesController extends ChangeNotifier {
//   bool isLoading = true;
//
//   // Roles list
//   List<Map<String, dynamic>> roles = [];
//
//   // Sidebar categories
//   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
//
//   // Sidebar permissions state
//   Map<String, Map<String, bool>> sidebarPermissionStates = {};
//
//   /// 🔹 Fetch all roles
//   Future<void> fetchRoles() async {
//     try {
//       isLoading = true;
//       notifyListeners();
//
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString("accessToken"); // ✅ FIXED
//
//       final response = await http.get(
//         Uri.parse("$baseUrl/api/roles"), // ✅ FIXED endpoint
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         roles = List<Map<String, dynamic>>.from(data);
//       }
//     } catch (e) {
//       debugPrint("Error fetching roles: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /// 🔹 Fetch sidebar for specific role
//   Future<void> fetchSidebarForRole(String roleId) async {
//     try {
//       isLoading = true;
//       notifyListeners();
//
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString("accessToken");
//
//       final response = await http.get(
//         Uri.parse("$baseUrl/api/sidebar/$roleId"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         sidebarCategories = {};
//         sidebarPermissionStates = {};
//
//         data.forEach((category, items) {
//           // ✅ Ensure items is always a list
//           if (items is List) {
//             sidebarCategories[category] =
//             List<Map<String, dynamic>>.from(items);
//
//             for (var item in items) {
//               sidebarPermissionStates[item['key']] = {
//                 "view": item["permissions"]?["view"] ?? false,
//                 "read": item["permissions"]?["read"] ?? false,
//                 "manage": item["permissions"]?["manage"] ?? false,
//               };
//             }
//           }
//         });
//       }
//     } catch (e) {
//       debugPrint("Error fetching sidebar: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /// 🔹 Toggle a single permission
//   void toggleSidebarPermission(String key, String permission) {
//     if (sidebarPermissionStates.containsKey(key)) {
//       sidebarPermissionStates[key]![permission] =
//       !(sidebarPermissionStates[key]![permission] ?? false);
//       notifyListeners();
//     }
//   }
//
//   /// 🔹 Toggle all for one item
//   void toggleSidebarAll(String key, bool value) {
//     if (sidebarPermissionStates.containsKey(key)) {
//       sidebarPermissionStates[key] = {
//         "view": value,
//         "read": value,
//         "manage": value,
//       };
//       notifyListeners();
//     }
//   }
//
//   /// 🔹 Check if all are true
//   bool getSidebarAll(String key) {
//     if (!sidebarPermissionStates.containsKey(key)) return false;
//     final perms = sidebarPermissionStates[key]!;
//     return perms["view"] == true &&
//         perms["read"] == true &&
//         perms["manage"] == true;
//   }
//
//   /// 🔹 Save sidebar permissions
//   Future<bool> updateSidebarPermissions(String roleId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString("accessToken");
//
//       // 🔹 Transform sidebarPermissionStates into a list
//       final List<Map<String, dynamic>> payload = sidebarPermissionStates.entries
//           .map((entry) => {
//         "key": entry.key,
//         "permissions": {
//           "view": entry.value["view"] ?? false,
//           "read": entry.value["read"] ?? false,
//           "manage": entry.value["manage"] ?? false,
//         }
//       })
//           .toList();
//
//       final response = await http.put(
//         Uri.parse("$baseUrl/api/sidebar/$roleId"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode(payload),
//       );
//
//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         debugPrint("Update failed: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       debugPrint("Error updating sidebar: $e");
//       return false;
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ancilmediaadminpanel/environmental variables.dart';

class RolesController extends ChangeNotifier {
  bool isLoading = true;

  // Roles
  List<Map<String, dynamic>> roles = [];

  // Permissions
  Map<String, List<Map<String, dynamic>>> permissionCategories = {};
  Map<String, bool> permissionStates = {};

  // Sidebar
  Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
  Map<String, Map<String, bool>> sidebarPermissionStates = {};

  // ================= TOKEN =================
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken");
  }

  // ================= ROLES =================
  Future<void> fetchRoles() async {
    isLoading = true;
    notifyListeners();
    try {
      final token = await _getToken();
      final res = await http.get(
        Uri.parse('$baseUrl/api/roles'),
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint("📡 fetchRoles → ${res.statusCode} :: ${res.body}");

      if (res.statusCode == 200) {
        roles = List<Map<String, dynamic>>.from(json.decode(res.body));
      }
    } catch (e) {
      debugPrint("❌ fetchRoles error: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  // ================= PERMISSIONS =================
  Future<void> fetchPermissions(String roleId) async {
    isLoading = true;
    notifyListeners();
    try {
      final token = await _getToken();
      final res = await http.get(
        Uri.parse('$baseUrl/api/permissions/$roleId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint("📡 fetchPermissions($roleId) → ${res.statusCode} :: ${res.body}");

      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        permissionCategories = {};
        permissionStates = {};

        for (var item in data['permissions']) {
          String category = item['category'] ?? "General";
          permissionCategories[category] ??= [];
          permissionCategories[category]!.add(item);

          permissionStates[item['key']] = item['value'] ?? false;
        }
      }
    } catch (e) {
      debugPrint("❌ fetchPermissions error: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  void togglePermission(String key) {
    permissionStates[key] = !(permissionStates[key] ?? false);
    notifyListeners();
  }

  // ================= SIDEBAR =================
  Future<void> fetchSidebarForRole(String roleId) async {
    try {
      isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("accessToken");

      final response = await http.get(
        Uri.parse("$baseUrl/api/sidebar/$roleId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        sidebarCategories = {};
        sidebarPermissionStates = {};

        data.forEach((category, items) {
          // ✅ Ensure items is always a list
          if (items is List) {
            sidebarCategories[category] =
            List<Map<String, dynamic>>.from(items);

            for (var item in items) {
              sidebarPermissionStates[item['key']] = {
                "view": item["permissions"]?["view"] ?? false,
                "read": item["permissions"]?["read"] ?? false,
                "manage": item["permissions"]?["manage"] ?? false,
              };
            }
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching sidebar: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleSidebarPermission(String key, String type) {
    if (sidebarPermissionStates.containsKey(key)) {
      sidebarPermissionStates[key]![type] =
      !(sidebarPermissionStates[key]![type] ?? false);
      notifyListeners();
    }
  }

  bool getSidebarAll(String key) {
    if (!sidebarPermissionStates.containsKey(key)) return false;
    return sidebarPermissionStates[key]!.values.every((v) => v);
  }

  void toggleSidebarAll(String key, bool value) {
    if (sidebarPermissionStates.containsKey(key)) {
      sidebarPermissionStates[key] = {
        'view': value,
        'read': value,
        'manage': value,
      };
      notifyListeners();
    }
  }

  /// 🔹 NEW: Get only the marked sidebar items
  List<Map<String, dynamic>> getMarkedSidebarItems() {
    return sidebarPermissionStates.entries
        .where((entry) =>
        entry.value.values.any((v) => v == true)) // keep only items with at least 1 true
        .map((entry) {
      return {
        "key": entry.key,
        "permissions": {
          "view": entry.value["view"] ?? false,
          "read": entry.value["read"] ?? false,
          "manage": entry.value["manage"] ?? false,
        }
      };
    })
        .toList();
  }

  /// 🔹 API update → Only send marked items
  Future<void> updateSidebarPermissions(String roleId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token == null) return;

      final sidebar = getMarkedSidebarItems(); // ✅ send only marked

      final res = await http.put(
        Uri.parse('$baseUrl/api/sidebar/assign/$roleId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({"sidebar": sidebar}),
      );

      if (res.statusCode == 200) {
        debugPrint("✅ Sidebar permissions updated for $roleId");
      } else {
        debugPrint("❌ Failed: ${res.statusCode} :: ${res.body}");
      }
    } catch (e) {
      debugPrint("⚠️ updateSidebarPermissions error: $e");
    }
  }
}
