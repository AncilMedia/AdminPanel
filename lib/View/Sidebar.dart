import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;
import '../View_model/Sidebar_provider.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SidebarProvider>(context);
    final selectedRoute = provider.selectedRoute;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(35),
        bottomLeft: Radius.circular(24),
      ),
      child: Container(
        width: 220,
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: [
            _buildItem(Iconsax.home, "Home", "/home", context, selectedRoute),
            _buildItem(Iconsax.book, "Events", "/events", context, selectedRoute),
            _buildItem(Iconsax.safe_home, "Sermons", "/sermons", context, selectedRoute),
            _buildItem(Iconsax.bag_tick, "Giving", "/giving", context, selectedRoute),
            _buildItem(Iconsax.monitor_mobbile, "Apps", "/apps", context, selectedRoute),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
      IconData icon,
      String label,
      String route,
      BuildContext context,
      String selectedRoute,
      ) {
    final bool isSelected = selectedRoute == route;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.black),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.blue.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: () {

        Provider.of<SidebarProvider>(context, listen: false).selectRoute(route);


        html.window.history.pushState(null, label, route);


        if (Scaffold.of(context).isDrawerOpen) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
