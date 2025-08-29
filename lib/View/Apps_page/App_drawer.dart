import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../View_model/Sidebar_provider.dart';
import '../../View_model/side_navbar_drawer.dart';
import '../Mainlayout.dart';
import 'package:iconsax/iconsax.dart';

class AppSubDrawer extends StatelessWidget {
  const AppSubDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubDrawerProvider>(context);
    final selectedItem = provider.selectedItem;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildDrawerTile(context, Iconsax.home, 'Home', SubDrawerItem.home, selectedItem),
        _buildDrawerTile(context, Iconsax.mobile, 'Mobile Apps', SubDrawerItem.mobile, selectedItem),
        _buildDrawerTile(context, Iconsax.monitor, 'TV Apps', SubDrawerItem.tv, selectedItem),
        _buildDrawerTile(context, Iconsax.notification_bing, 'Push Notifications', SubDrawerItem.push, selectedItem),
        const Spacer(),
      ],
    );
  }

  Widget _buildDrawerTile(BuildContext context, IconData icon, String label, SubDrawerItem item, SubDrawerItem selectedItem) {
    final isSelected = selectedItem == item;
    final color = isSelected ? Colors.cyan : Colors.black;
    final fontWeight = isSelected ? FontWeight.w600 : FontWeight.normal;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(label, style: GoogleFonts.poppins(color: color, fontWeight: fontWeight)),
      ),
      onTap: () {
        final provider = Provider.of<SubDrawerProvider>(context, listen: false);

        if (item == SubDrawerItem.home) {
          // Switch back to Home page via provider
          final mainProvider = Provider.of<SidebarProvider>(context, listen: false);
          mainProvider.selectItem('home');
        } else {
          provider.selectItem(item);
        }
      },
    );
  }
}
