import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  bool isLoggedIn = true;

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  void login() {
    isLoggedIn = true;
    notifyListeners();
  }
}
