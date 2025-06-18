import 'package:ancilmediaadminpanel/View/Mainlayout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../View_model/Sidebar_provider.dart';
import 'App_drawer.dart';
import 'Mobile_apps.dart';
import 'Tv_apps.dart';
import 'Push_Notifications.dart';

class Apps extends StatelessWidget {
  const Apps({super.key});

  Widget _getSelectedPage(SubDrawerItem item) {
    switch (item) {
      case SubDrawerItem.mobile:
        return const MobileApps();
      case SubDrawerItem.tv:
        return const TvApps();
      case SubDrawerItem.push:
        return const PushNotification();
      default:
        return const MainLayout(); // Default fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 1100;
    final provider = Provider.of<SubDrawerProvider>(context);
    final selectedItem = provider.selectedItem;

    // If subdrawer was accidentally set to home, reset to mobile
    if (selectedItem == SubDrawerItem.home) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.selectItem(SubDrawerItem.mobile);
      });
    }

    return Scaffold(
      appBar: isLargeScreen
          ? null
          : AppBar(
        title: const Text("Apps"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (route) {
              final provider =
              Provider.of<SubDrawerProvider>(context, listen: false);
              if (route == 'mobile') {
                provider.selectItem(SubDrawerItem.mobile);
              } else if (route == 'tv') {
                provider.selectItem(SubDrawerItem.tv);
              } else if (route == 'push') {
                provider.selectItem(SubDrawerItem.push);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mobile',
                child: Row(
                  children: [
                    Icon(Icons.phone_android, color: Colors.blue),
                    SizedBox(width: 8),
                    Text("Mobile Apps"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'tv',
                child: Row(
                  children: [
                    Icon(Icons.tv, color: Colors.deepPurple),
                    SizedBox(width: 8),
                    Text("TV Apps"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'push',
                child: Row(
                  children: [
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
          if (isLargeScreen && selectedItem != SubDrawerItem.home)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * .160,
                color: Colors.grey.shade100,
                child: const AppSubDrawer(),
              ),
            ),
          Expanded(child: _getSelectedPage(selectedItem)),
        ],
      ),
    );
  }
}
