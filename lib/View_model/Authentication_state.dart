// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthState extends ChangeNotifier {
//   String? _accessToken;
//
//   bool get isLoggedIn => _accessToken != null;
//   String? get accessToken => _accessToken;
//
//   // Call this at the very start of your app (main.dart)
//   Future<void> checkExistingLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     _accessToken = prefs.getString('accessToken');
//     notifyListeners();
//   }
//
//   Future<void> login(String token) async {
//     _accessToken = token;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('accessToken', token);
//
//     // This notification is what tells GoRouter to switch screens
//     notifyListeners();
//   }
//
//   Future<void> logout() async {
//     _accessToken = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('accessToken');
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState extends ChangeNotifier {
  String? _accessToken;

  bool get isLoggedIn => _accessToken != null;
  String? get accessToken => _accessToken;

  /// Call this in your main.dart or during app initialization
  Future<void> checkExistingLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('accessToken');
    notifyListeners();
  }

  /// Updates the app state, saves to disk, and notifies all listeners (UI)
  Future<void> login(String token) async {
    _accessToken = token;

    // Save to permanent storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);

    // 🔹 This is what makes the app "go inside" without a manual refresh
    notifyListeners();
  }

  Future<void> logout() async {
    _accessToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    notifyListeners();
  }
}