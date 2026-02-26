import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../View_model/Sidebar_provider.dart';
import '../../View_model/side_navbar_drawer.dart';
import '../Mainlayout.dart';

class AppSubDrawer extends StatelessWidget {
  const AppSubDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to SubDrawerProvider for internal App tab selections
    final subDrawerProvider = Provider.of<SubDrawerProvider>(context);
    final selectedItem = subDrawerProvider.selectedItem;

    void _handleBackNavigation() {
      if (Navigator.of(context).canPop()) {
        // If we pushed this page, pop returns to the exact previous state
        Navigator.of(context).pop();
      } else {
        // Safety: If stack is lost (direct URL access/refresh), go to Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainLayout(initialPage: 'home'),
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // --- FIXED BACK BUTTON ---
          _buildBackButton(context, _handleBackNavigation),

          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 16),
            child: Text(
              "APP MANAGEMENT",
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
                letterSpacing: 1.5,
              ),
            ),
          ),

          _buildModernTile(context, Iconsax.mobile, 'Mobile Apps', SubDrawerItem.mobile, selectedItem),
          _buildModernTile(context, Iconsax.monitor, 'TV Apps', SubDrawerItem.tv, selectedItem),
          _buildModernTile(context, Iconsax.notification_bing, 'Push Notifications', SubDrawerItem.push, selectedItem),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, VoidCallback onBack) {
    return InkWell(
      onTap: onBack,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.arrow_left_2, size: 16, color: Colors.blueGrey),
            const SizedBox(width: 8),
            Text(
              "Main Menu",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTile(BuildContext context, IconData icon, String label, SubDrawerItem item, SubDrawerItem selectedItem) {
    final isSelected = selectedItem == item;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Provider.of<SubDrawerProvider>(context, listen: false).selectItem(item);
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.cyan.withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(icon, color: isSelected ? Colors.cyan : Colors.blueGrey.shade600, size: 20),
                  const SizedBox(width: 16),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: isSelected ? Colors.cyan.shade800 : Colors.blueGrey.shade700,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (isSelected) const SizedBox(height: 8),
              if (isSelected)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 3,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}