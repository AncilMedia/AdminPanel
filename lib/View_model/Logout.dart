import 'package:flutter/material.dart';
import '../Controller/Login_controller.dart';
import '../View/Login_page.dart'; // AuthService

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _logout(BuildContext context) async {
    await AuthService().logout();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.logout),
      label: const Text('Logout'),
      onPressed: () => _logout(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
    );
  }
}
