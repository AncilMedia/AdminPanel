import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../View_model/Sidebar_provider.dart';
import 'App_drawer.dart';
import 'Mobile_apps.dart';
import 'Tv_apps.dart';
import 'Push_Notifications.dart';

class Apps extends StatelessWidget {
  const Apps({super.key});

  Widget getSelectedSubPage(String route) {
    switch (route) {
      case '/apps/mobileapps':
        return const MobileApps();
      case '/apps/tvapps':
        return const TvApps();
      case '/apps/pushnotification':
        return const PushNotification();
      default:
        return const Center(child: Text("Please select an app"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SidebarProvider>(context);

    // Fix: Prevent calling notifyListeners during build
    if (provider.selectedAppSubRoute.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final sidebarProvider = Provider.of<SidebarProvider>(context, listen: false);
        if (sidebarProvider.selectedAppSubRoute.isEmpty) {
          sidebarProvider.selectAppSubRoute('/apps/mobileapps');
        }
      });
    }

    final selectedSubRoute = provider.selectedAppSubRoute;
    final isLargeScreen = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: isLargeScreen
          ? null
          : AppBar(
        title: const Text("Apps"),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (route) {
              Provider.of<SidebarProvider>(context, listen: false)
                  .selectAppSubRoute(route);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: '/apps/mobileapps',
                child: Row(
                  children: const [
                    Icon(Icons.phone_android, color: Colors.blue),
                    SizedBox(width: 8),
                    Text("Mobile Apps"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: '/apps/tvapps',
                child: Row(
                  children: const [
                    Icon(Icons.tv, color: Colors.deepPurple),
                    SizedBox(width: 8),
                    Text("TV Apps"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: '/apps/pushnotification',
                child: Row(
                  children: const [
                    Icon(Icons.notifications_active, color: Colors.orange),
                    SizedBox(width: 8),
                    Text("Push Notifications"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          if (isLargeScreen)
            const SizedBox(
              child: AppSubDrawer(),
            ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: getSelectedSubPage(selectedSubRoute),
            ),
          ),
        ],
      ),
    );
  }
}
