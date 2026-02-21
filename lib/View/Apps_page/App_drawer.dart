import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../View_model/Sidebar_provider.dart';
import '../../View_model/side_navbar_drawer.dart';

class AppSubDrawer extends StatelessWidget {
  const AppSubDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubDrawerProvider>(context);
    final selectedItem = provider.selectedItem;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // --- MODERN BACK BUTTON ---
          _buildBackButton(context),

          const SizedBox(height: 32),

          // Section Label
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

  // ================= BACK NAVIGATION BUTTON =================
  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // Switch the main sidebar back to home
        Provider.of<SidebarProvider>(context, listen: false).selectItem('home');
      },
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

  // ================= MODERN DRAWER TILE =================
  Widget _buildModernTile(BuildContext context, IconData icon, String label, SubDrawerItem item, SubDrawerItem selectedItem) {
    final isSelected = selectedItem == item;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          final provider = Provider.of<SubDrawerProvider>(context, listen: false);
          provider.selectItem(item);
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            // Soft background fade
            color: isSelected ? Colors.cyan.withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: isSelected ? Colors.cyan : Colors.blueGrey.shade600,
                    size: 20,
                  ),
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
              const SizedBox(height: 8),

              // --- HORIZONTAL INDICATOR LINE ---
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  height: 3,
                  // The line expands horizontally when selected
                  width: isSelected ? 40 : 0,
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                    ],
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