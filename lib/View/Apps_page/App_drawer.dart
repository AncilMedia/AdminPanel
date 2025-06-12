import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../View_model/Sidebar_provider.dart';

class AppSubDrawer extends StatelessWidget {
  const AppSubDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SidebarProvider>(context);
    String selected = provider.selectedAppSubRoute;

    // ✅ Fix: Avoid calling notifyListeners during build
    if (selected.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final sidebarProvider = Provider.of<SidebarProvider>(context, listen: false);
        if (sidebarProvider.selectedAppSubRoute.isEmpty) {
          sidebarProvider.selectAppSubRoute('/apps/mobileapps');
          html.window.history.pushState(null, 'Mobile Apps', '/apps/mobileapps');
        }
      });
    }

    return Container(
      width: 250,
      color: Colors.grey[200],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildItem(Iconsax.mobile, "Mobile Apps", "/apps/mobileapps", selected, context),
          _buildItem(Iconsax.monitor, "TV Apps", "/apps/tvapps", selected, context),
          _buildItem(Iconsax.notification_bing, "Push Notifications", "/apps/pushnotification", selected, context),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, String route, String selected, BuildContext context) {
    final isSelected = selected == route;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.black54,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? Colors.blue.shade50 : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () {
        Provider.of<SidebarProvider>(context, listen: false).selectAppSubRoute(route);
        html.window.history.pushState(null, label, route);
      },
    );
  }
}
