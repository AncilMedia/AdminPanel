import 'package:ancilmediaadminpanel/View/Apps_page/Apps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Services/api_client.dart';
import 'View/Login_page.dart';
import 'View/PopUp/Right_drawer.dart';
import 'View_model/Authentication_state.dart';
import 'View_model/Drawer_provider.dart';
import 'View_model/Notification_dropdown_state.dart';
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
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => NotificationState()),
        Provider<ApiClient>(
          create: (context) => ApiClient(context.read<AuthState>()),
        ),
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
      home:  Apps(),
      // home: const Apps(),
    );
  }
}