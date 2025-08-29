// // // // import 'package:flutter/material.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'dart:convert';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import '../environmental variables.dart';
// // // //
// // // // class SidebarController extends ChangeNotifier {
// // // //   List<Map<String, dynamic>> sidebarItems = [];
// // // //   bool isLoading = true;
// // // //
// // // //   SidebarController() {
// // // //     fetchSidebarItems();
// // // //   }
// // // //
// // // //   Future<void> fetchSidebarItems() async {
// // // //     try {
// // // //       isLoading = true;
// // // //       notifyListeners();
// // // //
// // // //       // Get token from local storage
// // // //       SharedPreferences prefs = await SharedPreferences.getInstance();
// // // //       String? token = prefs.getString('accessToken');
// // // //
// // // //       if (token == null) {
// // // //         print('No token found in local storage');
// // // //         isLoading = false;
// // // //         notifyListeners();
// // // //         return;
// // // //       }
// // // //
// // // //       final response = await http.get(
// // // //         Uri.parse('$baseUrl/api/sidebar'),
// // // //         headers: {'Authorization': 'Bearer $token'},
// // // //       );
// // // //
// // // //       if (response.statusCode == 200) {
// // // //         sidebarItems =
// // // //         List<Map<String, dynamic>>.from(json.decode(response.body));
// // // //       } else {
// // // //         sidebarItems = [];
// // // //         print('Failed to fetch sidebar items: ${response.statusCode}');
// // // //       }
// // // //
// // // //       isLoading = false;
// // // //       notifyListeners();
// // // //     } catch (e) {
// // // //       print('Error fetching sidebar items: $e');
// // // //       isLoading = false;
// // // //       notifyListeners();
// // // //     }
// // // //   }
// // // // }
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'dart:convert';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import '../environmental variables.dart';
// // //
// // // class SidebarController extends ChangeNotifier {
// // //   List<Map<String, dynamic>> sidebarItems = [];
// // //   bool isLoading = true;
// // //
// // //   SidebarController() {
// // //     fetchSidebarItems();
// // //   }
// // //
// // //   Future<void> fetchSidebarItems() async {
// // //     try {
// // //       isLoading = true;
// // //       notifyListeners();
// // //
// // //       SharedPreferences prefs = await SharedPreferences.getInstance();
// // //       String? token = prefs.getString('accessToken');
// // //
// // //       if (token == null) {
// // //         print('No token found in local storage');
// // //         isLoading = false;
// // //         notifyListeners();
// // //         return;
// // //       }
// // //
// // //       final response = await http.get(
// // //         Uri.parse('$baseUrl/api/sidebar'),
// // //         headers: {'Authorization': 'Bearer $token'},
// // //       );
// // //
// // //       if (response.statusCode == 200) {
// // //         sidebarItems =
// // //         List<Map<String, dynamic>>.from(json.decode(response.body));
// // //       } else {
// // //         sidebarItems = [];
// // //         print('Failed to fetch sidebar items: ${response.statusCode}');
// // //       }
// // //
// // //       isLoading = false;
// // //       notifyListeners();
// // //     } catch (e) {
// // //       print('Error fetching sidebar items: $e');
// // //       isLoading = false;
// // //       notifyListeners();
// // //     }
// // //   }
// // // }
// //
// //
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // import '../environmental variables.dart';
// //
// //
// // class SidebarController extends ChangeNotifier {
// //   bool isLoading = false;
// //   List<Map<String, dynamic>> sidebarItems = [];
// //   List<Map<String, dynamic>> roleSidebarItems = [];
// //   Map<String, dynamic>? selectedRoleSidebar;
// //
// //   /// ✅ Get stored token
// //   Future<String?> _getToken() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString("accessToken");
// //   }
// //
// //   /// ✅ Get all sidebar items
// //   Future<void> fetchAllSidebarItems() async {
// //     try {
// //       isLoading = true;
// //       notifyListeners();
// //
// //       final token = await _getToken();
// //       final response = await http.get(
// //         Uri.parse('$baseUrl/api/sidebar'),
// //         headers: {"Authorization": "Bearer $token"},
// //       );
// //
// //       if (response.statusCode == 200) {
// //         sidebarItems = List<Map<String, dynamic>>.from(jsonDecode(response.body));
// //       } else {
// //         debugPrint("Fetch Sidebar Items Failed: ${response.body}");
// //       }
// //     } catch (e) {
// //       debugPrint("Fetch Sidebar Items Error: $e");
// //     } finally {
// //       isLoading = false;
// //       notifyListeners();
// //     }
// //   }
// //
// //   /// ✅ Get sidebar items for a role
// //   Future<void> fetchSidebarForRole(String roleId) async {
// //     try {
// //       isLoading = true;
// //       notifyListeners();
// //
// //       final token = await _getToken();
// //       final response = await http.get(
// //         Uri.parse("$baseUrl/api/sidebar/$roleId"),
// //         headers: {"Authorization": "Bearer $token"},
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         selectedRoleSidebar = data;
// //         roleSidebarItems = List<Map<String, dynamic>>.from(data["items"]);
// //       } else {
// //         debugPrint("Fetch Sidebar For Role Failed: ${response.body}");
// //       }
// //     } catch (e) {
// //       debugPrint("Fetch Sidebar For Role Error: $e");
// //     } finally {
// //       isLoading = false;
// //       notifyListeners();
// //     }
// //   }
// //   /// ✅ Create sidebar item (admin only)
// //   Future<bool> createSidebarItem({
// //     required String key,
// //     required String label,
// //     required String icon,
// //     required List<String> roles,
// //     required int order,
// //   }) async {
// //     try {
// //       isLoading = true;
// //       notifyListeners();
// //
// //       final token = await _getToken();
// //       final response = await http.post(
// //         Uri.parse('$baseUrl/api/sidebar'),
// //         headers: {
// //           "Content-Type": "application/json",
// //           "Authorization": "Bearer $token",
// //         },
// //         body: jsonEncode({
// //           "key": key,
// //           "label": label,
// //           "icon": icon,
// //           "roles": roles,
// //           "order": order,
// //         }),
// //       );
// //
// //       if (response.statusCode == 201) {
// //         await fetchAllSidebarItems();
// //         return true;
// //       } else {
// //         debugPrint("Create Sidebar Failed: ${response.body}");
// //         return false;
// //       }
// //     } catch (e) {
// //       debugPrint("Create Sidebar Error: $e");
// //       return false;
// //     } finally {
// //       isLoading = false;
// //       notifyListeners();
// //     }
// //   }
// //
// //   /// ✅ Update sidebar item
// //   Future<bool> updateSidebarItem(String id, {
// //     String? label,
// //     String? icon,
// //     List<String>? roles,
// //     int? order,
// //   }) async {
// //     try {
// //       isLoading = true;
// //       notifyListeners();
// //
// //       final token = await _getToken();
// //       final response = await http.put(
// //         Uri.parse("$baseUrl/api/sidebar/$id"),
// //         headers: {
// //           "Content-Type": "application/json",
// //           "Authorization": "Bearer $token",
// //         },
// //         body: jsonEncode({
// //           if (label != null) "label": label,
// //           if (icon != null) "icon": icon,
// //           if (roles != null) "roles": roles,
// //           if (order != null) "order": order,
// //         }),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         await fetchAllSidebarItems();
// //         return true;
// //       } else {
// //         debugPrint("Update Sidebar Failed: ${response.body}");
// //         return false;
// //       }
// //     } catch (e) {
// //       debugPrint("Update Sidebar Error: $e");
// //       return false;
// //     } finally {
// //       isLoading = false;
// //       notifyListeners();
// //     }
// //   }
// //
// //   /// ✅ Delete sidebar item
// //   Future<bool> deleteSidebarItem(String id) async {
// //     try {
// //       isLoading = true;
// //       notifyListeners();
// //
// //       final token = await _getToken();
// //       final response = await http.delete(
// //         Uri.parse("$baseUrl/api/sidebar/$id"),
// //         headers: {"Authorization": "Bearer $token"},
// //       );
// //
// //       if (response.statusCode == 200) {
// //         sidebarItems.removeWhere((item) => item["_id"] == id);
// //         notifyListeners();
// //         return true;
// //       } else {
// //         debugPrint("Delete Sidebar Failed: ${response.body}");
// //         return false;
// //       }
// //     } catch (e) {
// //       debugPrint("Delete Sidebar Error: $e");
// //       return false;
// //     } finally {
// //       isLoading = false;
// //       notifyListeners();
// //     }
// //   }
// //
// //   /// ✅ Assign sidebar permissions to role
// //   Future<bool> assignSidebarPermissions(String roleId, List<Map<String, dynamic>> sidebar) async {
// //     try {
// //       isLoading = true;
// //       notifyListeners();
// //
// //       final token = await _getToken();
// //       final response = await http.put(
// //         Uri.parse("$baseUrl/api/sidebar/assign/$roleId"),
// //         headers: {
// //           "Content-Type": "application/json",
// //           "Authorization": "Bearer $token",
// //         },
// //         body: jsonEncode({"sidebar": sidebar}),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         debugPrint("Sidebar Permissions Assigned: ${response.body}");
// //         return true;
// //       } else {
// //         debugPrint("Assign Sidebar Permissions Failed: ${response.body}");
// //         return false;
// //       }
// //     } catch (e) {
// //       debugPrint("Assign Sidebar Permissions Error: $e");
// //       return false;
// //     } finally {
// //       isLoading = false;
// //       notifyListeners();
// //     }
// //   }
// // }
//
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../environmental variables.dart';
//
// class SidebarController extends ChangeNotifier {
//   bool isLoading = false;
//   String? errorMessage;
//
//   List<Map<String, dynamic>> sidebarItems = [];
//   List<Map<String, dynamic>> roleSidebarItems = [];
//   Map<String, dynamic>? selectedRoleSidebar;
//
//   /// ✅ Get stored token
//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString("accessToken");
//   }
//
//   /// ✅ Safely decode JSON
//   dynamic _tryParseJson(String source) {
//     try {
//       return jsonDecode(source);
//     } catch (_) {
//       return null;
//     }
//   }
//
//   /// ✅ Get all sidebar items
//   Future<void> fetchAllSidebarItems() async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();
//
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse('$baseUrl/api/sidebar'),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       if (response.statusCode == 200) {
//         final data = _tryParseJson(response.body);
//         if (data is List) {
//           sidebarItems =
//           List<Map<String, dynamic>>.from(data.map((e) => Map<String, dynamic>.from(e)));
//         } else {
//           errorMessage = "Invalid response format";
//         }
//       } else {
//         errorMessage = "Failed to fetch sidebar items";
//       }
//     } catch (e) {
//       errorMessage = "Error: $e";
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /// ✅ Get sidebar items for a role
//   Future<void> fetchSidebarForRole(String roleId) async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();
//
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse("$baseUrl/api/sidebar/$roleId"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       if (response.statusCode == 200) {
//         final data = _tryParseJson(response.body);
//         if (data is Map<String, dynamic>) {
//           selectedRoleSidebar = data;
//           roleSidebarItems = List<Map<String, dynamic>>.from(data["items"] ?? []);
//         } else {
//           errorMessage = "Invalid response format";
//         }
//       } else {
//         errorMessage = "Failed to fetch sidebar for role";
//       }
//     } catch (e) {
//       errorMessage = "Error: $e";
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /// ✅ Create sidebar item (admin only)
//   Future<bool> createSidebarItem({
//     required String key,
//     required String label,
//     required String icon,
//     required List<String> roles,
//     required int order,
//   }) async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();
//
//     try {
//       final token = await _getToken();
//       final response = await http.post(
//         Uri.parse('$baseUrl/api/sidebar'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "key": key,
//           "label": label,
//           "icon": icon,
//           "roles": roles,
//           "order": order,
//         }),
//       );
//
//       if (response.statusCode == 201) {
//         await fetchAllSidebarItems();
//         return true;
//       } else {
//         errorMessage = "Failed to create sidebar item";
//       }
//     } catch (e) {
//       errorMessage = "Error: $e";
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//     return false;
//   }
//
//   /// ✅ Update sidebar item
//   Future<bool> updateSidebarItem(
//       String id, {
//         String? label,
//         String? icon,
//         List<String>? roles,
//         int? order,
//       }) async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();
//
//     try {
//       final token = await _getToken();
//       final response = await http.put(
//         Uri.parse("$baseUrl/api/sidebar/$id"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           if (label != null) "label": label,
//           if (icon != null) "icon": icon,
//           if (roles != null) "roles": roles,
//           if (order != null) "order": order,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         await fetchAllSidebarItems();
//         return true;
//       } else {
//         errorMessage = "Failed to update sidebar item";
//       }
//     } catch (e) {
//       errorMessage = "Error: $e";
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//     return false;
//   }
//
//   /// ✅ Delete sidebar item
//   Future<bool> deleteSidebarItem(String id) async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();
//
//     try {
//       final token = await _getToken();
//       final response = await http.delete(
//         Uri.parse("$baseUrl/api/sidebar/$id"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       if (response.statusCode == 200) {
//         sidebarItems.removeWhere((item) => item["_id"] == id);
//         notifyListeners();
//         return true;
//       } else {
//         errorMessage = "Failed to delete sidebar item";
//       }
//     } catch (e) {
//       errorMessage = "Error: $e";
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//     return false;
//   }
//
//   /// ✅ Assign sidebar permissions to role
//   Future<bool> assignSidebarPermissions(
//       String roleId,
//       List<Map<String, dynamic>> sidebar,
//       ) async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();
//
//     try {
//       final token = await _getToken();
//       final response = await http.put(
//         Uri.parse("$baseUrl/api/sidebar/assign/$roleId"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({"sidebar": sidebar}),
//       );
//
//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         errorMessage = "Failed to assign sidebar permissions";
//       }
//     } catch (e) {
//       errorMessage = "Error: $e";
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//     return false;
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../environmental variables.dart';

class SidebarController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  List<Map<String, dynamic>> sidebarItems = [];
  List<Map<String, dynamic>> roleSidebarItems = [];
  Map<String, dynamic>? selectedRoleSidebar;

  /// ✅ Get stored token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken");
  }

  /// ✅ Safely decode JSON
  dynamic _tryParseJson(String source) {
    try {
      return jsonDecode(source);
    } catch (_) {
      return null;
    }
  }

  /// ✅ Get all sidebar items
  Future<void> fetchAllSidebarItems() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/api/sidebar'),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = _tryParseJson(response.body);
        if (data is List) {
          sidebarItems = List<Map<String, dynamic>>.from(
            data.map((e) => Map<String, dynamic>.from(e)),
          );
        } else {
          errorMessage = "Invalid response format";
        }
      } else {
        errorMessage = "Failed: ${response.body}";
      }
    } catch (e) {
      errorMessage = "Error: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Get sidebar items for a role
  Future<void> fetchSidebarForRole(String roleId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse("$baseUrl/api/sidebar/$roleId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = _tryParseJson(response.body);
        if (data is Map<String, dynamic>) {
          selectedRoleSidebar = data;
          roleSidebarItems = List<Map<String, dynamic>>.from(data["items"] ?? []);
        } else {
          errorMessage = "Invalid response format";
        }
      } else {
        errorMessage = "Failed: ${response.body}";
      }
    } catch (e) {
      errorMessage = "Error: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Create sidebar item (admin only)
  Future<bool> createSidebarItem({
    required String key,
    required String label,
    required String icon,
    required List<String> roles, // Must be role IDs
    required int order,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/api/sidebar'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "key": key,
          "label": label,
          "icon": icon,
          "roles": roles, // ✅ send ObjectIds here
          "order": order,
        }),
      );

      if (response.statusCode == 201) {
        await fetchAllSidebarItems();
        return true;
      } else {
        errorMessage = "Failed: ${response.body}";
      }
    } catch (e) {
      errorMessage = "Error: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }

  /// ✅ Update sidebar item
  Future<bool> updateSidebarItem(
      String id, {
        String? label,
        String? icon,
        List<String>? roles, // Must be role IDs
        int? order,
      }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse("$baseUrl/api/sidebar/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          if (label != null) "label": label,
          if (icon != null) "icon": icon,
          if (roles != null) "roles": roles, // ✅ ObjectIds
          if (order != null) "order": order,
        }),
      );

      if (response.statusCode == 200) {
        await fetchAllSidebarItems();
        return true;
      } else {
        errorMessage = "Failed: ${response.body}";
      }
    } catch (e) {
      errorMessage = "Error: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }

  /// ✅ Delete sidebar item
  Future<bool> deleteSidebarItem(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.delete(
        Uri.parse("$baseUrl/api/sidebar/$id"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        sidebarItems.removeWhere((item) => item["_id"] == id);
        notifyListeners();
        return true;
      } else {
        errorMessage = "Failed: ${response.body}";
      }
    } catch (e) {
      errorMessage = "Error: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }

  /// ✅ Assign sidebar permissions to role
  Future<bool> assignSidebarPermissions(
      String roleId,
      List<Map<String, dynamic>> sidebar,
      ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse("$baseUrl/api/sidebar/assign/$roleId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "sidebar": sidebar.map((e) => {
            "key": e["key"],
            "label": e["label"],
            "icon": e["icon"],
            "order": e["order"] ?? 0,
            "permissions": e["permissions"] ?? {
              "view": true,
              "read": false,
              "manage": false,
            }
          }).toList()
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        errorMessage = "Failed: ${response.body}";
      }
    } catch (e) {
      errorMessage = "Error: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }
}
