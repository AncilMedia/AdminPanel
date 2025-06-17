import 'package:flutter/material.dart';
import '../Controller/Login_controller.dart';
import '../View/Login_page.dart';

void handleTokenExpiry(BuildContext context) async {
  final auth = AuthService();
  final newToken = await auth.refreshAccessToken();

  if (newToken == null) {
    // Refresh failed → logout + navigate to login
    await auth.logout();

    // Navigate to login page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }
}
