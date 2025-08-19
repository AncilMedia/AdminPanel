// import 'package:ancilmediaadminpanel/View/Pushnotification.dart';
// import 'package:ancilmediaadminpanel/View/Organization.dart';
// import 'package:ancilmediaadminpanel/View/User.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:iconsax/iconsax.dart';
//
// import '../Controller/Profile_controller.dart';
// import '../View/Home_page.dart';
// import '../View/Events.dart';
// import '../View/Giving.dart';
// import '../View/Sermons.dart';
// import '../View/Apps_page/Apps.dart';
// import '../View_model/Drawer_provider.dart';
// import '../View_model/Sidebar_provider.dart';
// import '../View_model/Logout.dart';
// import 'Application_page.dart';
// import 'Notifications/Notification_page.dart';
// import 'Profile_page.dart';
// import '../Services/api_client.dart';
// import 'Notifications/notification_bell.dart';
//
// class MainLayout extends StatefulWidget {
//   const MainLayout({super.key});
//
//   @override
//   State<MainLayout> createState() => _MainLayoutState();
// }
//
// class _MainLayoutState extends State<MainLayout> {
//   String orgName = 'Loading...';
//   String? orgImage;
//   String role = '';
//
//   @override
//   void initState() {
//     super.initState();
//     loadOrgInfo();
//   }
//
//   void loadOrgInfo() async {
//     final apiClient = Provider.of<ApiClient>(context, listen: false);
//     final controller = ProfileController(apiClient);
//     final data = await controller.fetchProfile();
//     if (data != null) {
//       setState(() {
//         orgName = data['username'] ?? 'Unknown';
//         orgImage = data['image'];
//         role = data['role'] ?? '';
//       });
//     }
//   }
//
//   Widget _getContent(DrawerItem item) {
//     switch (item) {
//       case DrawerItem.home:
//         return const HomePage();
//       case DrawerItem.events:
//         return const Events();
//       case DrawerItem.sermons:
//         return const Sermons();
//       case DrawerItem.giving:
//         return const Giving();
//       case DrawerItem.apps:
//         return const Apps();
//       case DrawerItem.user:
//         return const UserPage();
//       case DrawerItem.organization:
//         return const Organization();
//       case DrawerItem.applications:
//         return const ApplicationPage();
//       case DrawerItem.pushnotification:
//         return const PushNotification();
//       case DrawerItem.profile:
//         return const Profile();
//       case DrawerItem.notification:
//         return const NotificationPage();
//       default:
//         return const HomePage();
//     }
//   }
//
//   String _getTitle(DrawerItem item) {
//     switch (item) {
//       case DrawerItem.home:
//         return 'Home';
//       case DrawerItem.events:
//         return 'Events';
//       case DrawerItem.sermons:
//         return 'Sermons';
//       case DrawerItem.giving:
//         return 'Giving';
//       case DrawerItem.apps:
//         return 'Apps';
//       case DrawerItem.user:
//         return 'User';
//       case DrawerItem.organization:
//         return 'Organization';
//       case DrawerItem.pushnotification:
//         return 'Push Notification';
//       case DrawerItem.applications:
//         return 'Application';
//       case DrawerItem.profile:
//         return 'Profile';
//       case DrawerItem.notification:
//         return 'Profile';
//       default:
//         return 'Ancil Media';
//     }
//   }
//
//   Widget _buildDrawerTile(BuildContext context, IconData icon, String label, DrawerItem item, bool isDesktop) {
//     final provider = Provider.of<SidedrawerProvider>(context);
//     final isSelected = provider.selectedItem == item;
//     final color = isSelected ? Colors.cyan : Colors.black;
//     final fontWeight = isSelected ? FontWeight.w600 : FontWeight.normal;
//
//     return ListTile(
//       leading: Icon(icon, color: color),
//       title: Padding(
//         padding: const EdgeInsets.only(left: 12.0),
//         child: Text(
//           label,
//           style: GoogleFonts.poppins(
//             textStyle: TextStyle(
//               color: color,
//               fontWeight: fontWeight,
//             ),
//           ),
//         ),
//       ),
//       onTap: () {
//         if (item == DrawerItem.apps) {
//           Provider.of<SubDrawerProvider>(context, listen: false).selectItem(SubDrawerItem.mobile);
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (_) => const Apps()),
//                 (route) => false,
//           );
//         } else {
//           provider.selectItem(item);
//           if (!isDesktop) Navigator.pop(context);
//         }
//       },
//     );
//   }
//
//   Widget _buildCurvedDrawerHeader(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.cyan,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(35),
//           bottomRight: Radius.circular(35),
//         ),
//       ),
//       height: 150,
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 25,
//             backgroundImage: orgImage != null
//                 ? NetworkImage(orgImage!)
//                 : const AssetImage('assets/favicon.png') as ImageProvider,
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               orgName,
//               overflow: TextOverflow.ellipsis,
//               style: GoogleFonts.poppins(
//                 textStyle: const TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//           ),
//           if (role == 'admin')
//             NotificationIconDropdown()
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _buildDrawerItems(BuildContext context, bool isDesktop) {
//     final List<Widget> items = [
//       _buildCurvedDrawerHeader(context),
//       _buildDrawerTile(context, Iconsax.home, 'Home', DrawerItem.home, isDesktop),
//       _buildDrawerTile(context, Iconsax.book, 'Events', DrawerItem.events, isDesktop),
//       _buildDrawerTile(context, Iconsax.safe_home, 'Sermons', DrawerItem.sermons, isDesktop),
//       _buildDrawerTile(context, Iconsax.wallet_money, 'Giving', DrawerItem.giving, isDesktop),
//       _buildDrawerTile(context, Iconsax.element_3, 'Apps', DrawerItem.apps, isDesktop),
//       if (role == 'admin')
//         _buildDrawerTile(context, Iconsax.profile_2user, 'User', DrawerItem.user, isDesktop),
//       if (role == 'admin')
//         _buildDrawerTile(context, Iconsax.building, 'Organization', DrawerItem.organization, isDesktop),
//       if (role == 'admin')
//         _buildDrawerTile(context, Iconsax.box_2, 'Applications', DrawerItem.applications, isDesktop),
//       if (role == 'admin')
//         _buildDrawerTile(context, Iconsax.notification_bing, 'Push Notification', DrawerItem.pushnotification, isDesktop),
//       _buildDrawerTile(context, Iconsax.message_text, 'Notification', DrawerItem.notification, isDesktop),
//       _buildDrawerTile(context, Iconsax.profile_circle, 'Settings', DrawerItem.profile, isDesktop),
//     ];
//
//     return items;
//   }
//
//   Widget _buildLogoutSection(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.cyan.shade300,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(15),
//           topRight: Radius.circular(15),
//         ),
//       ),
//       width: MediaQuery.of(context).size.width,
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: MediaQuery.of(context).size.width * 0.01,
//           vertical: MediaQuery.of(context).size.width * 0.01,
//         ),
//         child: const LogoutButton(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
//     final provider = Provider.of<SidedrawerProvider>(context);
//     final selectedItem = provider.selectedItem;
//
//     return Scaffold(
//       appBar: isDesktop
//           ? null
//           : AppBar(
//         title: Text(
//           _getTitle(selectedItem),
//           style: GoogleFonts.poppins(
//             textStyle: const TextStyle(color: Colors.black),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//       ),
//       drawer: isDesktop
//           ? null
//           : Drawer(
//         width: MediaQuery.of(context).size.width * .8,
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 children: _buildDrawerItems(context, false),
//               ),
//             ),
//             _buildLogoutSection(context),
//           ],
//         ),
//       ),
//       body: Row(
//         children: [
//           if (isDesktop)
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * .160,
//                 color: Colors.grey.shade100,
//                 child: Column(
//                   children: [
//                     ..._buildDrawerItems(context, true),
//                     const Spacer(),
//                     _buildLogoutSection(context),
//                   ],
//                 ),
//               ),
//             ),
//           Expanded(child: _getContent(selectedItem)),
//         ],
//       ),
//     );
//   }
// }


import 'package:ancilmediaadminpanel/View/Pushnotification.dart';
import 'package:ancilmediaadminpanel/View/Organization.dart';
import 'package:ancilmediaadminpanel/View/User.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../Controller/Profile_controller.dart';
import '../Socket_Service.dart';
import '../View/Home_page.dart';
import '../View/Events.dart';
import '../View/Giving.dart';
import '../View/Sermons.dart';
import '../View/Apps_page/Apps.dart';
import '../View_model/Drawer_provider.dart';
import '../View_model/Sidebar_provider.dart';
import '../View_model/Logout.dart';
import '../environmental variables.dart';
import 'Application_page.dart';
import 'Notifications/Notification_page.dart';
import 'Profile_page.dart';
import '../Services/api_client.dart';
import 'Notifications/notification_bell.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String orgName = 'Loading...';
  String? orgImage;
  String role = '';
  IO.Socket? socket;

  @override
  void initState() {
    super.initState();
    loadOrgInfo();
    setupSocketListeners();
  }

  /// 🔹 Fetch profile data initially
  void loadOrgInfo() async {
    final apiClient = Provider.of<ApiClient>(context, listen: false);
    final controller = ProfileController(apiClient);
    final data = await controller.fetchProfile();
    if (data != null) {
      setState(() {
        orgName = data['username'] ?? 'Unknown';
        orgImage = data['image'];
        role = data['role'] ?? '';
      });
    }
  }

  /// 🔹 Initialize socket connection
  void setupSocketListeners() {
    final socketService = SocketService();

    socketService.on('connect', (_) {
      debugPrint('✅ Connected to socket server (MainLayout)');
    });

    socketService.on('disconnect', (_) {
      debugPrint('❌ Disconnected from socket server (MainLayout)');
    });

    socketService.on('profile_updated', (data) {
      debugPrint('📸 Profile updated event: $data');
      setState(() {
        orgName = data['username'] ?? orgName;
        orgImage = data['image'] ?? orgImage;
        role = data['role'] ?? role;
      });
    });
  }


  @override
  void dispose() {
    socket?.disconnect();
    super.dispose();
  }

  /// 🔹 Drawer Content Selection
  Widget _getContent(DrawerItem item) {
    switch (item) {
      case DrawerItem.home:
        return const HomePage();
      case DrawerItem.events:
        return const Events();
      case DrawerItem.sermons:
        return const Sermons();
      case DrawerItem.giving:
        return const Giving();
      case DrawerItem.apps:
        return const Apps();
      case DrawerItem.user:
        return const UserPage();
      case DrawerItem.organization:
        return const Organization();
      case DrawerItem.applications:
        return const ApplicationPage();
      case DrawerItem.pushnotification:
        return const PushNotification();
      case DrawerItem.profile:
        return const Profile();
      case DrawerItem.notification:
        return const NotificationPage();
      default:
        return const HomePage();
    }
  }

  /// 🔹 Title for AppBar
  String _getTitle(DrawerItem item) {
    switch (item) {
      case DrawerItem.home:
        return 'Home';
      case DrawerItem.events:
        return 'Events';
      case DrawerItem.sermons:
        return 'Sermons';
      case DrawerItem.giving:
        return 'Giving';
      case DrawerItem.apps:
        return 'Apps';
      case DrawerItem.user:
        return 'User';
      case DrawerItem.organization:
        return 'Organization';
      case DrawerItem.pushnotification:
        return 'Push Notification';
      case DrawerItem.applications:
        return 'Application';
      case DrawerItem.profile:
        return 'Profile';
      case DrawerItem.notification:
        return 'Notification'; // 🔥 Fixed wrong title
      default:
        return 'Ancil Media';
    }
  }

  /// 🔹 Drawer Tile Widget
  Widget _buildDrawerTile(
      BuildContext context, IconData icon, String label, DrawerItem item, bool isDesktop) {
    final provider = Provider.of<SidedrawerProvider>(context);
    final isSelected = provider.selectedItem == item;
    final color = isSelected ? Colors.cyan : Colors.black;
    final fontWeight = isSelected ? FontWeight.w600 : FontWeight.normal;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Padding(
        padding: const EdgeInsets.only(left: 12.0),
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
        if (item == DrawerItem.apps) {
          Provider.of<SubDrawerProvider>(context, listen: false)
              .selectItem(SubDrawerItem.mobile);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const Apps()),
                (route) => false,
          );
        } else {
          provider.selectItem(item);
          if (!isDesktop) Navigator.pop(context);
        }
      },
    );
  }

  /// 🔹 Drawer Header
  Widget _buildCurvedDrawerHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      height: 150,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: orgImage != null
                ? NetworkImage(orgImage!)
                : const AssetImage('assets/favicon.png') as ImageProvider,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              orgName,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          if (role == 'admin') NotificationIconDropdown(),
        ],
      ),
    );
  }

  /// 🔹 Drawer Items
  List<Widget> _buildDrawerItems(BuildContext context, bool isDesktop) {
    final List<Widget> items = [
      _buildCurvedDrawerHeader(context),
      _buildDrawerTile(context, Iconsax.home, 'Home', DrawerItem.home, isDesktop),
      _buildDrawerTile(context, Iconsax.book, 'Events', DrawerItem.events, isDesktop),
      _buildDrawerTile(context, Iconsax.safe_home, 'Sermons', DrawerItem.sermons, isDesktop),
      _buildDrawerTile(context, Iconsax.wallet_money, 'Giving', DrawerItem.giving, isDesktop),
      _buildDrawerTile(context, Iconsax.element_3, 'Apps', DrawerItem.apps, isDesktop),
      if (role == 'admin')
        _buildDrawerTile(context, Iconsax.profile_2user, 'User', DrawerItem.user, isDesktop),
      if (role == 'admin')
        _buildDrawerTile(context, Iconsax.building, 'Organization', DrawerItem.organization, isDesktop),
      if (role == 'admin')
        _buildDrawerTile(context, Iconsax.box_2, 'Applications', DrawerItem.applications, isDesktop),
      if (role == 'admin')
        _buildDrawerTile(context, Iconsax.notification_bing, 'Push Notification', DrawerItem.pushnotification, isDesktop),
      _buildDrawerTile(context, Iconsax.message_text, 'Notification', DrawerItem.notification, isDesktop),
      _buildDrawerTile(context, Iconsax.profile_circle, 'Settings', DrawerItem.profile, isDesktop),
    ];
    return items;
  }

  /// 🔹 Logout Section
  Widget _buildLogoutSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.cyan.shade300,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.width * 0.01,
        ),
        child: const LogoutButton(),
      ),
    );
  }

  /// 🔹 Build Scaffold
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
    final provider = Provider.of<SidedrawerProvider>(context);
    final selectedItem = provider.selectedItem;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
        title: Text(
          _getTitle(selectedItem),
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      drawer: isDesktop
          ? null
          : Drawer(
        width: MediaQuery.of(context).size.width * .8,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: _buildDrawerItems(context, false),
              ),
            ),
            _buildLogoutSection(context),
          ],
        ),
      ),
      body: Row(
        children: [
          if (isDesktop)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * .160,
                color: Colors.grey.shade100,
                child: Column(
                  children: [
                    ..._buildDrawerItems(context, true),
                    const Spacer(),
                    _buildLogoutSection(context),
                  ],
                ),
              ),
            ),
          Expanded(child: _getContent(selectedItem)),
        ],
      ),
    );
  }
}
