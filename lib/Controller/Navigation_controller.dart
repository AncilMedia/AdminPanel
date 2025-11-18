// // // // import 'dart:convert';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:http/http.dart' as http;
// // // //
// // // // import '../Model/Navigation_model.dart';
// // // // import '../environmental variables.dart';
// // // //
// // // // class NavigationController extends ChangeNotifier {
// // // //
// // // //   List<NavigationModel> navItems = [];
// // // //   bool isLoading = false;
// // // //
// // // //   /// GET ALL NAV ITEMS
// // // //   Future<void> fetchNavItems() async {
// // // //     try {
// // // //       isLoading = true;
// // // //       notifyListeners();
// // // //
// // // //       final res = await http.get(Uri.parse('$baseUrl/api/navigation'));
// // // //
// // // //       if (res.statusCode == 200) {
// // // //         final data = jsonDecode(res.body)['navItems'] as List;
// // // //         navItems = data.map((e) => NavigationModel.fromJson(e)).toList();
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint("Error fetching nav items: $e");
// // // //     } finally {
// // // //       isLoading = false;
// // // //       notifyListeners();
// // // //     }
// // // //   }
// // // //
// // // //   /// CREATE NAV ITEM
// // // //   Future<bool> createNavItem(NavigationModel item) async {
// // // //     try {
// // // //       final res = await http.post(
// // // //         Uri.parse('$baseUrl/api/navigation'),
// // // //         headers: {"Content-Type": "application/json"},
// // // //         body: jsonEncode(item.toJson()),
// // // //       );
// // // //
// // // //       if (res.statusCode == 201) {
// // // //         fetchNavItems();
// // // //         return true;
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint("Error creating nav item: $e");
// // // //     }
// // // //     return false;
// // // //   }
// // // //
// // // //   /// UPDATE NAV ITEM
// // // //   Future<bool> updateNavItem(String id, Map<String, dynamic> updates) async {
// // // //     try {
// // // //       final res = await http.put(
// // // //         Uri.parse("$baseUrl/api/navigation/$id"),
// // // //         headers: {"Content-Type": "application/json"},
// // // //         body: jsonEncode(updates),
// // // //       );
// // // //
// // // //       if (res.statusCode == 200) {
// // // //         fetchNavItems();
// // // //         return true;
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint("Error updating nav item: $e");
// // // //     }
// // // //     return false;
// // // //   }
// // // //
// // // //   /// DELETE NAV ITEM
// // // //   Future<bool> deleteNavItem(String id) async {
// // // //     try {
// // // //       final res = await http.delete(Uri.parse("$baseUrl/api/navigation/$id"));
// // // //
// // // //       if (res.statusCode == 200) {
// // // //         navItems.removeWhere((element) => element.id == id);
// // // //         notifyListeners();
// // // //         return true;
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint("Error deleting nav item: $e");
// // // //     }
// // // //     return false;
// // // //   }
// // // // }
// // //
// // // // lib/Controller/Navigation_Controller.dart
// // // import 'dart:convert';
// // // import 'package:http/http.dart' as http;
// // //
// // // import '../Model/Navigation_model.dart';
// // // import '../environmental variables.dart';
// // //
// // // class NavigationController {
// // //   /// -------------------------------
// // //   /// Fetch All Navigation Items
// // //   /// -------------------------------
// // //   static Future<List<NavigationModel>> fetchNavigation() async {
// // //     try {
// // //       final res = await http.get(Uri.parse("$baseUrl/api/navigation"));
// // //
// // //       if (res.statusCode == 200) {
// // //         final parsed = jsonDecode(res.body)['navItems'] as List;
// // //         final list = parsed.map((e) => NavigationModel.fromJson(e)).toList();
// // //
// // //         // Sort by order
// // //         list.sort((a, b) => a.order.compareTo(b.order));
// // //
// // //         return list;
// // //       } else {
// // //         throw Exception("Failed to load navigation. Status: ${res.statusCode}");
// // //       }
// // //     } catch (e) {
// // //       throw Exception("Error fetching navigation: $e");
// // //     }
// // //   }
// // //
// // //   /// ------------------------------------------
// // //   /// Update navigation order (one-by-one update)
// // //   /// ------------------------------------------
// // //   static Future<void> updateNavOrder(List<NavigationModel> items) async {
// // //     try {
// // //       for (var i = 0; i < items.length; i++) {
// // //         final item = items[i];
// // //
// // //         final res = await http.put(
// // //           Uri.parse("$baseUrl/api/navigation/${item.id}"),
// // //           headers: {"Content-Type": "application/json"},
// // //           body: jsonEncode({"order": i}),
// // //         );
// // //
// // //         if (res.statusCode == 200) {
// // //           item.order = i; // Update local order
// // //         } else {
// // //           throw Exception(
// // //               "Failed updating order for ${item.id}. Status: ${res.statusCode}");
// // //         }
// // //       }
// // //     } catch (e) {
// // //       throw Exception("Error updating navigation order: $e");
// // //     }
// // //   }
// // // }
// //
// // // lib/Controller/Navigation_Controller.dart
// //
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // import '../Model/Navigation_model.dart';
// // import '../environmental variables.dart';
// //
// // class NavigationController {
// //   /// --------------------------------
// //   /// Get organizationId from local storage
// //   /// --------------------------------
// //   static Future<String?> _getOrgId() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString("organizationId");
// //   }
// //
// //   /// --------------------------------
// //   /// Fetch All Navigation Items (Organization Based)
// //   /// --------------------------------
// //   static Future<List<NavigationModel>> fetchNavigation() async {
// //     try {
// //       final orgId = await _getOrgId();
// //
// //       if (orgId == null) {
// //         throw Exception("❌ organizationId not found in storage");
// //       }
// //
// //       final url = "$baseUrl/api/navigation?organization=$orgId";
// //
// //       final res = await http.get(Uri.parse(url));
// //
// //       if (res.statusCode == 200) {
// //         final parsed = jsonDecode(res.body)['navItems'] as List;
// //
// //         final list =
// //         parsed.map((e) => NavigationModel.fromJson(e)).toList();
// //
// //         // Sort by order
// //         list.sort((a, b) => a.order.compareTo(b.order));
// //
// //         return list;
// //       } else {
// //         throw Exception(
// //             "Failed to load navigation. Status: ${res.statusCode}");
// //       }
// //     } catch (e) {
// //       throw Exception("Error fetching navigation: $e");
// //     }
// //   }
// //
// //   /// ------------------------------------------
// //   /// REORDER navigation items (API bulk reorder)
// //   /// ------------------------------------------
// //   static Future<void> reorderNavigation(List<NavigationModel> items) async {
// //     try {
// //       final orgId = await _getOrgId();
// //
// //       if (orgId == null) {
// //         throw Exception("❌ organizationId not found in storage");
// //       }
// //
// //       final url = "$baseUrl/api/navigation/reorder/all";
// //
// //       // Prepare list for backend
// //       final reorderList = items
// //           .asMap()
// //           .entries
// //           .map((entry) => {
// //         "_id": entry.value.id,
// //         "order": entry.key,
// //       })
// //           .toList();
// //
// //       final res = await http.put(
// //         Uri.parse(url),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "organization": orgId,
// //           "items": reorderList,
// //         }),
// //       );
// //
// //       if (res.statusCode != 200) {
// //         throw Exception(
// //             "Failed to reorder navigation. Status: ${res.statusCode}");
// //       }
// //
// //       // Update local order
// //       for (int i = 0; i < items.length; i++) {
// //         items[i].order = i;
// //       }
// //     } catch (e) {
// //       throw Exception("Error reordering navigation: $e");
// //     }
// //   }
// //
// //   /// ------------------------------------------
// //   /// Create Navigation Item
// //   /// ------------------------------------------
// //   static Future<bool> createNavigationItem(NavigationModel item) async {
// //     try {
// //       final orgId = await _getOrgId();
// //       if (orgId == null) throw Exception("organizationId missing");
// //
// //       final url = "$baseUrl/api/navigation";
// //
// //       final res = await http.post(
// //         Uri.parse(url),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "label": item.label,
// //           "icon": item.icon,
// //           "type": item.type,
// //           "content": item.content,
// //           "order": item.order,
// //           "organization": orgId,
// //         }),
// //       );
// //
// //       return res.statusCode == 201;
// //     } catch (e) {
// //       throw Exception("Error creating navigation item: $e");
// //     }
// //   }
// //
// //   /// ------------------------------------------
// //   /// Update Navigation Item
// //   /// ------------------------------------------
// //   static Future<bool> updateNavigationItem(NavigationModel item) async {
// //     try {
// //       final url = "$baseUrl/api/navigation/${item.id}";
// //
// //       final res = await http.put(
// //         Uri.parse(url),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode(item.toJson()),
// //       );
// //
// //       return res.statusCode == 200;
// //     } catch (e) {
// //       throw Exception("Error updating navigation: $e");
// //     }
// //   }
// //
// //   /// ------------------------------------------
// //   /// Delete Navigation Item
// //   /// ------------------------------------------
// //   static Future<bool> deleteNavigationItem(String id) async {
// //     try {
// //       final url = "$baseUrl/api/navigation/$id";
// //
// //       final res = await http.delete(Uri.parse(url));
// //
// //       return res.statusCode == 200;
// //     } catch (e) {
// //       throw Exception("Error deleting navigation: $e");
// //     }
// //   }
// // }
//
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../Model/Navigation_model.dart';
// import '../environmental variables.dart';
//
// class NavigationController {
//
//   /// -------------------------------
//   /// Get orgId from local storage
//   /// -------------------------------
//   static Future<String?> _getOrgId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString("organizationId");
//   }
//
//   /// -------------------------------
//   /// FETCH (Get all navigation items)
//   /// -------------------------------
//   static Future<List<NavigationModel>> fetchNavigation() async {
//     try {
//       final orgId = await _getOrgId();
//       if (orgId == null) throw Exception("organizationId missing");
//
//       final url = "$baseUrl/api/navigation?organization=$orgId";
//
//       final res = await http.get(Uri.parse(url));
//
//       if (res.statusCode == 200) {
//         final parsed = jsonDecode(res.body)['navItems'] as List;
//
//         final list = parsed.map((e) => NavigationModel.fromJson(e)).toList();
//
//         list.sort((a, b) => a.order.compareTo(b.order));
//
//         return list;
//       } else {
//         throw Exception("Failed to load navigation. Status: ${res.statusCode}");
//       }
//     } catch (e) {
//       throw Exception("Error fetching navigation: $e");
//     }
//   }
//
//   /// -------------------------------
//   /// REORDER (Bulk Reorder API)
//   /// -------------------------------
//   static Future<void> reorderNavigation(List<NavigationModel> items) async {
//     try {
//       final orgId = await _getOrgId();
//       if (orgId == null) throw Exception("organizationId missing");
//
//       final url = "$baseUrl/api/navigation/reorder/all";
//
//       final reorderList = items.asMap().entries.map(
//             (entry) => {
//           "_id": entry.value.id,
//           "order": entry.key,
//         },
//       ).toList();
//
//       final res = await http.put(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "organization": orgId,
//           "items": reorderList,
//         }),
//       );
//
//       if (res.statusCode != 200) {
//         throw Exception("Failed to reorder navigation. Status: ${res.statusCode}");
//       }
//
//       for (int i = 0; i < items.length; i++) {
//         items[i].order = i;
//       }
//     } catch (e) {
//       throw Exception("Error reordering navigation: $e");
//     }
//   }
//
//   /// -------------------------------
//   /// CREATE (POST)
//   /// -------------------------------
//   static Future<bool> createNavigationItem(NavigationModel item) async {
//     try {
//       final orgId = await _getOrgId();
//       if (orgId == null) throw Exception("organizationId missing");
//
//       final url = "$baseUrl/api/navigation";
//
//       final res = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "label": item.label,
//           "icon": item.icon,
//           "type": item.type,
//           "content": item.content,
//           "order": item.order,
//           "organization": orgId,
//         }),
//       );
//
//       return res.statusCode == 201;
//     } catch (e) {
//       throw Exception("Error creating navigation item: $e");
//     }
//   }
//
//   /// -------------------------------
//   /// UPDATE (PUT by ID)
//   /// -------------------------------
//   static Future<bool> updateNavigationItem(NavigationModel item) async {
//     try {
//       final url = "$baseUrl/api/navigation/${item.id}";
//
//       final res = await http.put(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(item.toJson()),
//       );
//
//       return res.statusCode == 200;
//     } catch (e) {
//       throw Exception("Error updating navigation: $e");
//     }
//   }
//
//   /// -------------------------------
//   /// DELETE
//   /// -------------------------------
//   static Future<bool> deleteNavigationItem(String id) async {
//     try {
//       final url = "$baseUrl/api/navigation/$id";
//
//       final res = await http.delete(Uri.parse(url));
//
//       return res.statusCode == 200;
//     } catch (e) {
//       throw Exception("Error deleting navigation: $e");
//     }
//   }
// }



import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/Navigation_model.dart';
import '../environmental variables.dart';

class NavigationController {

  /// -------------------------------
  /// Get orgId from local storage
  /// -------------------------------
  static Future<String?> _getOrgId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("organizationId");
  }

  /// -------------------------------
  /// FETCH (Get all navigation items)
  /// -------------------------------
  static Future<List<NavigationModel>> fetchNavigation() async {
    try {
      final orgId = await _getOrgId();
      if (orgId == null) throw Exception("organizationId missing");

      final url = "$baseUrl/api/navigation?organization=$orgId";

      print("🔵 [FETCH NAV] URL: $url");

      final res = await http.get(Uri.parse(url));

      print("🟣 [FETCH NAV] STATUS: ${res.statusCode}");
      print("🟠 [FETCH NAV] RESPONSE: ${res.body}");

      if (res.statusCode == 200) {
        final parsed = jsonDecode(res.body)['navItems'] as List;

        final list = parsed.map((e) => NavigationModel.fromJson(e)).toList();

        list.sort((a, b) => a.order.compareTo(b.order));

        return list;
      } else {
        throw Exception("Failed to load navigation. Status: ${res.statusCode}");
      }
    } catch (e) {
      print("🔴 [FETCH NAV] ERROR: $e");
      throw Exception("Error fetching navigation: $e");
    }
  }

  /// -------------------------------
  /// REORDER (Bulk Reorder API)
  /// -------------------------------
  static Future<void> reorderNavigation(List<NavigationModel> items) async {
    try {
      final orgId = await _getOrgId();
      if (orgId == null) throw Exception("organizationId missing");

      final url = "$baseUrl/api/navigation/reorder/all";

      final reorderList = items.asMap().entries.map(
            (entry) => {
          "_id": entry.value.id,
          "order": entry.key,
        },
      ).toList();

      print("🔵 [REORDER NAV] URL: $url");
      print("🟡 [REORDER NAV] BODY: ${jsonEncode({
        "organization": orgId,
        "items": reorderList,
      })}");

      final res = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "organization": orgId,
          "items": reorderList,
        }),
      );

      print("🟣 [REORDER NAV] STATUS: ${res.statusCode}");
      print("🟠 [REORDER NAV] RESPONSE: ${res.body}");

      if (res.statusCode != 200) {
        throw Exception("Failed to reorder navigation. Status: ${res.statusCode}");
      }

      // Update local orders after success
      for (int i = 0; i < items.length; i++) {
        items[i].order = i;
      }
    } catch (e) {
      print("🔴 [REORDER NAV] ERROR: $e");
      throw Exception("Error reordering navigation: $e");
    }
  }

  /// -------------------------------
  /// CREATE (POST)
  /// -------------------------------
  static Future<bool> createNavigationItem(NavigationModel item) async {
    try {
      final orgId = await _getOrgId();
      if (orgId == null) throw Exception("organizationId missing");

      final url = "$baseUrl/api/navigation";

      final body = {
        "label": item.label,
        "icon": item.icon,
        "type": item.type,
        "content": item.content,
        "order": item.order,
        "organization": orgId,
      };

      print("🔵 [CREATE NAV] URL: $url");
      print("🟡 [CREATE NAV] BODY: ${jsonEncode(body)}");

      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("🟣 [CREATE NAV] STATUS: ${res.statusCode}");
      print("🟠 [CREATE NAV] RESPONSE: ${res.body}");

      return res.statusCode == 201;
    } catch (e) {
      print("🔴 [CREATE NAV] ERROR: $e");
      throw Exception("Error creating navigation item: $e");
    }
  }

  /// -------------------------------
  /// UPDATE (PUT by ID)
  /// -------------------------------
  static Future<bool> updateNavigationItem(NavigationModel item) async {
    try {
      final url = "$baseUrl/api/navigation/${item.id}";

      print("🔵 [UPDATE NAV] URL: $url");
      print("🟡 [UPDATE NAV] BODY: ${jsonEncode(item.toJson())}");

      final res = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(item.toJson()),
      );

      print("🟣 [UPDATE NAV] STATUS: ${res.statusCode}");
      print("🟠 [UPDATE NAV] RESPONSE: ${res.body}");

      return res.statusCode == 200;
    } catch (e) {
      print("🔴 [UPDATE NAV] ERROR: $e");
      throw Exception("Error updating navigation: $e");
    }
  }

  /// -------------------------------
  /// DELETE
  /// -------------------------------
  static Future<bool> deleteNavigationItem(String id) async {
    try {
      final url = "$baseUrl/api/navigation/$id";

      print("🔵 [DELETE NAV] URL: $url");

      final res = await http.delete(Uri.parse(url));

      print("🟣 [DELETE NAV] STATUS: ${res.statusCode}");
      print("🟠 [DELETE NAV] RESPONSE: ${res.body}");

      return res.statusCode == 200;
    } catch (e) {
      print("🔴 [DELETE NAV] ERROR: $e");
      throw Exception("Error deleting navigation: $e");
    }
  }
}
