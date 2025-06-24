import 'package:flutter/material.dart';

/// Define the items in your sidebar
enum DrawerItem { home, events, sermons, giving, apps, user, profile, notification }

/// SidebarProvider handles which drawer item is selected
class SidedrawerProvider with ChangeNotifier {
  DrawerItem _selectedItem = DrawerItem.home;

  DrawerItem get selectedItem => _selectedItem;

  /// Call this method to update the selected item
  void selectItem(DrawerItem item) {
    _selectedItem = item;
    notifyListeners(); // Triggers UI rebuild
  }
}
