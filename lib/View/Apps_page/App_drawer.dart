import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';

import '../../View_model/Sidebar_provider.dart';
import '../Mainlayout.dart'; // Add this import

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

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: IconButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainLayout()),
                  );
                }
              },
              icon: Icon(Iconsax.arrow_left_2)),
        ),

        const SizedBox(height: 16),

        _buildDrawerTile(
          context,
          Iconsax.home,
          'Home',
          SubDrawerItem.home,
          selectedItem,
        ),
        _buildDrawerTile(
          context,
          Iconsax.mobile,
          'Mobile Apps',
          SubDrawerItem.mobile,
          selectedItem,
        ),
        _buildDrawerTile(
          context,
          Iconsax.monitor,
          'TV Apps',
          SubDrawerItem.tv,
          selectedItem,
        ),
        _buildDrawerTile(
          context,
          Iconsax.notification_bing,
          'Push Notifications',
          SubDrawerItem.push,
          selectedItem,
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildDrawerTile(
      BuildContext context,
      IconData icon,
      String label,
      SubDrawerItem item,
      SubDrawerItem selectedItem,
      ) {
    final isSelected = selectedItem == item;
    final color = isSelected ? Colors.cyan : Colors.black;
    final fontWeight = isSelected ? FontWeight.w600 : FontWeight.normal;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: color,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
      onTap: () {
        final provider = Provider.of<SubDrawerProvider>(context, listen: false);

        if (item == SubDrawerItem.home) {
          // Navigate to MainLayout when Home is selected
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainLayout()),
                (route) => false,
          );
        } else {
          provider.selectItem(item);
        }
      },
    );
  }
}
