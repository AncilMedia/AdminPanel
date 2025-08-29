import 'package:flutter/material.dart';

class SidebarProvider with ChangeNotifier {
  String? _selectedKey; // Instead of enum, we use sidebar item key (from backend)

  String? get selectedKey => _selectedKey;

  /// Select a sidebar item by its key
  void selectItem(String key) {
    _selectedKey = key;
    notifyListeners();
  }
}
