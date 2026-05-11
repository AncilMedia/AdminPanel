// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:iconsax/iconsax.dart';
// import '../../View_model/Sidebar_provider.dart';
// import '../../View_model/side_navbar_drawer.dart';
// import '../Mainlayout.dart';
//
// class AppSubDrawer extends StatelessWidget {
//   const AppSubDrawer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Listen to SubDrawerProvider for internal App tab selections
//     final subDrawerProvider = Provider.of<SubDrawerProvider>(context);
//     final selectedItem = subDrawerProvider.selectedItem;
//
//     void _handleBackNavigation() {
//       if (Navigator.of(context).canPop()) {
//         // If we pushed this page, pop returns to the exact previous state
//         Navigator.of(context).pop();
//       } else {
//         // Safety: If stack is lost (direct URL access/refresh), go to Home
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const MainLayout(initialPage: 'home'),
//           ),
//         );
//       }
//     }
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 24),
//
//           // --- FIXED BACK BUTTON ---
//           _buildBackButton(context, _handleBackNavigation),
//
//           const SizedBox(height: 32),
//
//           Padding(
//             padding: const EdgeInsets.only(left: 12, bottom: 16),
//             child: Text(
//               "APP MANAGEMENT",
//               style: GoogleFonts.poppins(
//                 fontSize: 10,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey.shade400,
//                 letterSpacing: 1.5,
//               ),
//             ),
//           ),
//
//           _buildModernTile(context, Iconsax.mobile, 'Mobile Apps', SubDrawerItem.mobile, selectedItem),
//           _buildModernTile(context, Iconsax.monitor, 'TV Apps', SubDrawerItem.tv, selectedItem),
//           _buildModernTile(context, Iconsax.notification_bing, 'Push Notifications', SubDrawerItem.push, selectedItem),
//
//           const Spacer(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBackButton(BuildContext context, VoidCallback onBack) {
//     return InkWell(
//       onTap: onBack,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade50,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade200),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Iconsax.arrow_left_2, size: 16, color: Colors.blueGrey),
//             const SizedBox(width: 8),
//             Text(
//               "Main Menu",
//               style: GoogleFonts.poppins(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.blueGrey.shade700,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildModernTile(BuildContext context, IconData icon, String label, SubDrawerItem item, SubDrawerItem selectedItem) {
//     final isSelected = selectedItem == item;
//
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: InkWell(
//         onTap: () {
//           Provider.of<SubDrawerProvider>(context, listen: false).selectItem(item);
//         },
//         borderRadius: BorderRadius.circular(12),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//           decoration: BoxDecoration(
//             color: isSelected ? Colors.cyan.withOpacity(0.05) : Colors.transparent,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: [
//                   Icon(icon, color: isSelected ? Colors.cyan : Colors.blueGrey.shade600, size: 20),
//                   const SizedBox(width: 16),
//                   Text(
//                     label,
//                     style: GoogleFonts.poppins(
//                       color: isSelected ? Colors.cyan.shade800 : Colors.blueGrey.shade700,
//                       fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//               if (isSelected) const SizedBox(height: 8),
//               if (isSelected)
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Container(
//                     height: 3,
//                     width: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.cyan,
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
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
    final subDrawerProvider = Provider.of<SubDrawerProvider>(context);
    final selectedItem = subDrawerProvider.selectedItem;

    // Determine screen type using LayoutBuilder or MediaQuery
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 600;

    void _handleBackNavigation() {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainLayout(initialPage: 'home'),
          ),
        );
      }
    }

    return Container(
      // Ensure the drawer fills the available height but respects width constraints
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      child: SafeArea(
        // Safety for notched devices (iPhone/Android)
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isMobile ? 16 : 24),

              // --- FIXED BACK BUTTON ---
              _buildBackButton(context, _handleBackNavigation, isMobile),

              SizedBox(height: isMobile ? 24 : 32),

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

              // Scrollable area for menu items to prevent overflow on short screens
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildModernTile(context, Iconsax.mobile, 'Mobile Apps', SubDrawerItem.mobile, selectedItem, isMobile),
                    _buildModernTile(context, Iconsax.monitor, 'TV Apps', SubDrawerItem.tv, selectedItem, isMobile),
                    _buildModernTile(context, Iconsax.notification_bing, 'Push Notifications', SubDrawerItem.push, selectedItem, isMobile),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, VoidCallback onBack, bool isMobile) {
    return InkWell(
      onTap: onBack,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 12,
            vertical: 8
        ),
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
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTile(BuildContext context, IconData icon, String label, SubDrawerItem item, SubDrawerItem selectedItem, bool isMobile) {
    final isSelected = selectedItem == item;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Provider.of<SubDrawerProvider>(context, listen: false).selectItem(item);
          // If on mobile, you might want to close the Drawer after selection:
          // if (isMobile) Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(
              vertical: isMobile ? 10 : 12,
              horizontal: 16
          ),
          decoration: BoxDecoration(
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
                      size: isMobile ? 18 : 20
                  ),
                  const SizedBox(width: 16),
                  Expanded( // Added Expanded to prevent text overflow on very narrow sidebars
                    child: Text(
                      label,
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.cyan.shade800 : Colors.blueGrey.shade700,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: isMobile ? 13 : 14,
                      ),
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