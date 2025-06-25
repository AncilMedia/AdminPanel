import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Services/api_client.dart';
import 'View/Login_page.dart';
import 'View_model/Authentication_state.dart';
import 'View_model/Drawer_provider.dart';
import 'View_model/Notification_dropdown_state.dart';
import 'View_model/Sidebar_provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'View_model/Socket_Service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubDrawerProvider()),
        ChangeNotifierProvider(create: (_) => SidedrawerProvider()),
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => NotificationState()),

        Provider<ApiClient>(
          create: (context) => ApiClient(context.read<AuthState>()),
        ),

        /// ✅ Use plain Provider if SocketService is NOT a ChangeNotifier
        Provider<SocketService>(
          // create: (_) => SocketService()..init("https://panel-backend-wrqz.onrender.com"),
          create: (_) => SocketService()..init("https://panel-backend-wrqz.onrender.com"),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
