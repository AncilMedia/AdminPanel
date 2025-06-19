import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../Controller/Login_controller.dart';
import '../View/Login_page.dart';
import '../View_model/Authentication_state.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  bool _isLoggingOut = false;

  Future<void> _logout(BuildContext context) async {
    setState(() {
      _isLoggingOut = true;
    });

    final authState = Provider.of<AuthState>(context, listen: false);
    await AuthService().logout(authState);

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    }

    setState(() {
      _isLoggingOut = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: _isLoggingOut
          ? SizedBox(
        width: 24,
        height: 24,
        child: Lottie.asset(
          'assets/Hour_glass_Loading.json',
          fit: BoxFit.contain,
        ),
      )
          : const Icon(Icons.logout),
      label: Text(_isLoggingOut ? 'Logging out...' : 'Logout'),
      onPressed: _isLoggingOut ? null : () => _logout(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}
