// import 'package:flutter/material.dart';
// import '../Controller/Login_controller.dart';
// import '../View/Login_page.dart';
//
// void handleTokenExpiry(BuildContext context) async {
//   final auth = AuthService();
//   final newToken = await auth.refreshAccessToken();
//
//   if (newToken == null) {
//     // Refresh failed → logout + navigate to login
//     await auth.logout();
//
//     // Navigate to login page
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const LoginPage()),
//           (route) => false,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/Login_controller.dart';
import '../View/Login_page.dart';
import '../View_model/Authentication_state.dart';

Future<bool> handleTokenExpiry(BuildContext context) async {
  final auth = AuthService();
  final authState = Provider.of<AuthState>(context, listen: false);
  final newToken = await auth.refreshAccessToken(authState);

  if (newToken == null) {
    await auth.logout(authState);
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    }
    return false;
  }

  return true;
}
