import 'package:ancilmediaadminpanel/View/Apps_page/Apps.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Controller/Roles_controller.dart';
import 'Controller/Sidebar_controller.dart';
import 'Model/Item_Model.dart';
import 'Socket_Service.dart';
import 'View/Mainlayout.dart';
import 'View/Media_page.dart';
import 'View/Pushnotification.dart';
import 'Services/api_client.dart';
import 'View/Login_page.dart';
import 'View/Organization.dart';
import 'View/PopUp/Right_drawer.dart';
import 'View/Role.dart';
import 'View/Video_Analytics.dart';
import 'View_model/Authentication_state.dart';
import 'View_model/Drawer_provider.dart';
import 'View_model/Listitem_details.dart';
import 'View_model/Notification_dropdown_state.dart';
import 'View_model/Sidebar_provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'View_model/side_navbar_drawer.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SocketService().initSocket();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubDrawerProvider()),
        ChangeNotifierProvider(create: (_) => SidedrawerProvider()),
        ChangeNotifierProvider(create: (_) => SidebarProvider()),
        ChangeNotifierProvider(create: (_) => SidebarController()),
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => NotificationState()),
        ChangeNotifierProvider(create: (_) => RolesController()),
        ChangeNotifierProvider(create: (_) => SidebarsubProvider()),
        ChangeNotifierProvider(
          create: (_) => RolesController(),
          child: RolesPage(),
        ),

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
      // home: ListItemDetailsPage(
      //   parentItem: ItemModel(
      //     id: '686394bae4ad10ca022b0242',
      //     title: 'ggggg',
      //     subtitle: '',
      //     url: '',
      //     image: 'https://res.cloudinary.com/dggylwwqk/image/upload/v1751356590/lists/ipyaqgrqjitsyrptj5oy.jpg',
      //     imageName: '',
      //     type: 'list',
      //     createdAt: DateTime.parse('2025-07-01T07:56:42.627Z'),
      //     updatedAt: DateTime.parse('2025-07-01T09:37:01.100Z'),
      //     v: 0,
      //     index: null,
      //   ),
      // ),
      home: MediaAnalyticsDashboard(),
      // home: const Apps(),
    );
  }
}
