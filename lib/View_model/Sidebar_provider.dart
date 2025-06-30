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
