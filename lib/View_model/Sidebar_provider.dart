import 'package:flutter/material.dart';

class SidebarProvider with ChangeNotifier {
  String _selectedRoute = '/home';
  String _selectedAppSubRoute = '';

  String get selectedRoute => _selectedRoute;
  String get selectedAppSubRoute => _selectedAppSubRoute;

  void selectRoute(String route) {
    _selectedRoute = route;
    // Reset sub-route when main route changes
    if (route != '/apps') {
      _selectedAppSubRoute = '';
    }
    notifyListeners();
  }

  void selectAppSubRoute(String subRoute) {
    _selectedAppSubRoute = subRoute;
    notifyListeners();
  }
}
