// import 'package:ancilmediaadminpanel/View/Home_page.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../View_model/Sidebar_provider.dart';
// import 'App_drawer.dart';
// import 'Mobile_apps.dart';
// import 'Tv_apps.dart';
// import '../Pushnotification.dart';
//
// class Apps extends StatelessWidget {
//   const Apps({super.key});
//
//   Widget _getSelectedPage(SubDrawerItem item) {
//     switch (item) {
//       case SubDrawerItem.home:
//         return const HomePage();
//       case SubDrawerItem.mobile:
//         return const MobileApps();
//       case SubDrawerItem.tv:
//         return const TvApps();
//       case SubDrawerItem.push:
//         return const PushNotification();
//       default:
//         return const MobileApps();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isLargeScreen = MediaQuery.of(context).size.width >= 1100;
//     final provider = Provider.of<SubDrawerProvider>(context);
//     final selectedItem = provider.selectedItem;
//
//     // Ensure default selection
//     if (selectedItem == SubDrawerItem.home) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         provider.selectItem(SubDrawerItem.mobile);
//       });
//     }
//
//     return Scaffold(
//       appBar: isLargeScreen
//           ? null
//           : AppBar(
//         title: const Text("Apps"),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//       ),
//       body: Row(
//         children: [
//           if (isLargeScreen)
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * .16,
//                 color: Colors.grey.shade100,
//                 child: const AppSubDrawer(),
//               ),
//             ),
//           Expanded(child: _getSelectedPage(selectedItem)),
//         ],
//       ),
//     );
//   }
// }

import 'package:ancilmediaadminpanel/View/Home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../View_model/Sidebar_provider.dart';
import 'App_drawer.dart';
import 'Mobile_apps.dart';
import 'Tv_apps.dart';
import '../Pushnotification.dart';

class Apps extends StatelessWidget {
  const Apps({super.key});

  // All pages in order of enum
  static final List<Widget> _pages = [
    const HomePage(),
    const MobileApps(),
    const TvApps(),
    const PushNotification(),
  ];

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 1100;
    final provider = Provider.of<SubDrawerProvider>(context);
    final selectedItem = provider.selectedItem;

    // Convert enum to index for IndexedStack
    final selectedIndex = SubDrawerItem.values.indexOf(selectedItem);

    return Scaffold(
      appBar: isLargeScreen
          ? null
          : AppBar(
        title: const Text("Apps"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Row(
        children: [
          if (isLargeScreen)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * .16,
                color: Colors.grey.shade100,
                child: const AppSubDrawer(),
              ),
            ),
          // ✅ IndexedStack preserves page state
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}
