import 'package:flutter/material.dart';

class NotificationState extends ChangeNotifier {
  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  void updateCount(int count) {
    _unreadCount = count;
    notifyListeners();
  }
}