
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'View/Apps_page/Apps.dart';
import 'View/Apps_page/Mobile_apps.dart';
import 'View/Home_page.dart';
import 'View_model/Sidebar_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SidebarProvider())],
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
      // home: const MainLayout(),
      home: const Apps(),
    );
  }
}
