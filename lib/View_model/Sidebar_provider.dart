// import 'package:flutter/material.dart';
//
// class SidebarProvider with ChangeNotifier {
//   String _selectedRoute = '/home';
//   String _selectedAppSubRoute = '';
//
//   String get selectedRoute => _selectedRoute;
//   String get selectedAppSubRoute => _selectedAppSubRoute;
//
//   void selectRoute(String route) {
//     _selectedRoute = route;
//     // Reset sub-route when main route changes
//     if (route != '/apps') {
//       _selectedAppSubRoute = '';
//     }
//     notifyListeners();
//   }
//
//   void selectAppSubRoute(String subRoute) {
//     _selectedAppSubRoute = subRoute;
//     notifyListeners();
//   }
// }

// SubDrawerProvider.dart
import 'package:flutter/material.dart';

enum SubDrawerItem { mobile, tv, push , home }

class SubDrawerProvider extends ChangeNotifier {
  SubDrawerItem _selectedItem = SubDrawerItem.mobile; // default here

  SubDrawerItem get selectedItem => _selectedItem;

  void selectItem(SubDrawerItem item) {
    _selectedItem = item;
    notifyListeners();
  }
}
