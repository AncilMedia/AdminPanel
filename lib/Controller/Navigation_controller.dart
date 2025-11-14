// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import '../Model/Navigation_model.dart';
// import '../environmental variables.dart';
//
// class NavigationController extends ChangeNotifier {
//
//   List<NavigationModel> navItems = [];
//   bool isLoading = false;
//
//   /// GET ALL NAV ITEMS
//   Future<void> fetchNavItems() async {
//     try {
//       isLoading = true;
//       notifyListeners();
//
//       final res = await http.get(Uri.parse('$baseUrl/api/navigation'));
//
//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body)['navItems'] as List;
//         navItems = data.map((e) => NavigationModel.fromJson(e)).toList();
//       }
//     } catch (e) {
//       debugPrint("Error fetching nav items: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /// CREATE NAV ITEM
//   Future<bool> createNavItem(NavigationModel item) async {
//     try {
//       final res = await http.post(
//         Uri.parse('$baseUrl/api/navigation'),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(item.toJson()),
//       );
//
//       if (res.statusCode == 201) {
//         fetchNavItems();
//         return true;
//       }
//     } catch (e) {
//       debugPrint("Error creating nav item: $e");
//     }
//     return false;
//   }
//
//   /// UPDATE NAV ITEM
//   Future<bool> updateNavItem(String id, Map<String, dynamic> updates) async {
//     try {
//       final res = await http.put(
//         Uri.parse("$baseUrl/api/navigation/$id"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(updates),
//       );
//
//       if (res.statusCode == 200) {
//         fetchNavItems();
//         return true;
//       }
//     } catch (e) {
//       debugPrint("Error updating nav item: $e");
//     }
//     return false;
//   }
//
//   /// DELETE NAV ITEM
//   Future<bool> deleteNavItem(String id) async {
//     try {
//       final res = await http.delete(Uri.parse("$baseUrl/api/navigation/$id"));
//
//       if (res.statusCode == 200) {
//         navItems.removeWhere((element) => element.id == id);
//         notifyListeners();
//         return true;
//       }
//     } catch (e) {
//       debugPrint("Error deleting nav item: $e");
//     }
//     return false;
//   }
// }
