import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'View/Login_page.dart';
import 'View_model/Drawer_provider.dart';
import 'View_model/Sidebar_provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubDrawerProvider()),
        ChangeNotifierProvider(create: (_) => SidedrawerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      // home: const Apps(),
    );
  }
}
