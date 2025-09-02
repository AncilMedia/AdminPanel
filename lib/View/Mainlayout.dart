// // // // // // // // // // // // // import 'package:ancilmediaadminpanel/View/Pushnotification.dart';
// // // // // // // // // // // // // import 'package:ancilmediaadminpanel/View/Organization.dart';
// // // // // // // // // // // // // import 'package:ancilmediaadminpanel/View/User.dart';
// // // // // // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // // // // // // // // // import 'package:provider/provider.dart';
// // // // // // // // // // // // // import 'package:iconsax/iconsax.dart';
// // // // // // // // // // // // //
// // // // // // // // // // // // // import '../Controller/Profile_controller.dart';
// // // // // // // // // // // // // import '../View/Home_page.dart';
// // // // // // // // // // // // // import '../View/Events.dart';
// // // // // // // // // // // // // import '../View/Giving.dart';
// // // // // // // // // // // // // import '../View/Sermons.dart';
// // // // // // // // // // // // // import '../View/Apps_page/Apps.dart';
// // // // // // // // // // // // // import '../View_model/Drawer_provider.dart';
// // // // // // // // // // // // // import '../View_model/Sidebar_provider.dart';
// // // // // // // // // // // // // import '../View_model/Logout.dart';
// // // // // // // // // // // // // import 'Application_page.dart';
// // // // // // // // // // // // // import 'Notifications/Notification_page.dart';
// // // // // // // // // // // // // import 'Profile_page.dart';
// // // // // // // // // // // // // import '../Services/api_client.dart';
// // // // // // // // // // // // // import 'Notifications/notification_bell.dart';
// // // // // // // // // // // // //
// // // // // // // // // // // // // class MainLayout extends StatefulWidget {
// // // // // // // // // // // // //   const MainLayout({super.key});
// // // // // // // // // // // // //
// // // // // // // // // // // // //   @override
// // // // // // // // // // // // //   State<MainLayout> createState() => _MainLayoutState();
// // // // // // // // // // // // // }
// // // // // // // // // // // // //
// // // // // // // // // // // // // class _MainLayoutState extends State<MainLayout> {
// // // // // // // // // // // // //   String orgName = 'Loading...';
// // // // // // // // // // // // //   String? orgImage;
// // // // // // // // // // // // //   String role = '';
// // // // // // // // // // // // //
// // // // // // // // // // // // //   @override
// // // // // // // // // // // // //   void initState() {
// // // // // // // // // // // // //     super.initState();
// // // // // // // // // // // // //     loadOrgInfo();
// // // // // // // // // // // // //   }
// // // // // // // // // // // // //
// // // // // // // // // // // // //   void loadOrgInfo() async {
// // // // // // // // // // // // //     final apiClient = Provider.of<ApiClient>(context, listen: false);
// // // // // // // // // // // // //     final controller = ProfileController(apiClient);
// // // // // // // // // // // // //     final data = await controller.fetchProfile();
// // // // // // // // // // // // //     if (data != null) {
// // // // // // // // // // // // //       setState(() {
// // // // // // // // // // // // //         orgName = data['username'] ?? 'Unknown';
// // // // // // // // // // // // //         orgImage = data['image'];
// // // // // // // // // // // // //         role = data['role'] ?? '';
// // // // // // // // // // // // //       });
// // // // // // // // // // // // //     }
// // // // // // // // // // // // //   }
// // // // // // // // // // // // //
// // // // // // // // // // // // //   Widget _getContent(DrawerItem item) {
// // // // // // // // // // // // //     switch (item) {
// // // // // // // // // // // // //       case DrawerItem.home:
// // // // // // // // // // // // //         return const HomePage();
// // // // // // // // // // // // //       case DrawerItem.events:
// // // // // // // // // // // // //         return const Events();
// // // // // // // // // // // // //       case DrawerItem.sermons:
// // // // // // // // // // // // //         return const Sermons();
// // // // // // // // // // // // //       case DrawerItem.giving:
// // // // // // // // // // // // //         return const Giving();
// // // // // // // // // // // // //       case DrawerItem.apps:
// // // // // // // // // // // // //         return const Apps();
// // // // // // // // // // // // //       case DrawerItem.user:
// // // // // // // // // // // // //         return const UserPage();
// // // // // // // // // // // // //       case DrawerItem.organization:
// // // // // // // // // // // // //         return const Organization();
// // // // // // // // // // // // //       case DrawerItem.applications:
// // // // // // // // // // // // //         return const ApplicationPage();
// // // // // // // // // // // // //       case DrawerItem.pushnotification:
// // // // // // // // // // // // //         return const PushNotification();
// // // // // // // // // // // // //       case DrawerItem.profile:
// // // // // // // // // // // // //         return const Profile();
// // // // // // // // // // // // //       case DrawerItem.notification:
// // // // // // // // // // // // //         return const NotificationPage();
// // // // // // // // // // // // //       default:
// // // // // // // // // // // // //         return const HomePage();
// // // // // // // // // // // // //     }
// // // // // // // // // // // // //   }
// // // // // // // // // // // // //
// // // // // // // // // // // // //   String _getTitle(DrawerItem item) {
// // // // // // // // // // // // //     switch (item) {
// // // // // // // // // // // // //       case DrawerItem.home:
// // // // // // // // // // // // //         return 'Home';
// // // // // // // // // // // // //       case DrawerItem.events:
// // // // // // // // // // // // //         return 'Events';
// // // // // // // // // // // // //       case DrawerItem.sermons:
// // // // // // // // // // // // //         return 'Sermons';
// // // // // // // // // // // // //       case DrawerItem.giving:
// // // // // // // // // // // // //         return 'Giving';
// // // // // // // // // // // // //       case DrawerItem.apps:
// // // // // // // // // // // // //         return 'Apps';
// // // // // // // // // // // // //       case DrawerItem.user:
// // // // // // // // // // // // //         return 'User';
// // // // // // // // // // // // //       case DrawerItem.organization:
// // // // // // // // // // // // //         return 'Organization';
// // // // // // // // // // // // //       case DrawerItem.pushnotification:
// // // // // // // // // // // // //         return 'Push Notification';
// // // // // // // // // // // // //       case DrawerItem.applications:
// // // // // // // // // // // // //         return 'Application';
// // // // // // // // // // // // //       case DrawerItem.profile:
// // // // // // // // // // // // //         return 'Profile';
// // // // // // // // // // // // //       case DrawerItem.notification:
// // // // // // // // // // // // //         return 'Profile';
// // // // // // // // // // // // //       default:
// // // // // // // // // // // // //         return 'Ancil Media';
// // // // // // // // // // // // //     }
// // // // // // // // // // // // //   }
// // // // // // // // // // // // //
// // // // // // // // // // // // //   Widget _buildDrawerTile(BuildContext context, IconData icon, String label, DrawerItem item, bool isDesktop) {
// // // // // // // // // // // // //     final provider = Provider.of<SidedrawerProvider>(context);
// // // // // // // // // // // // //     final isSelected = provider.selectedItem == item;
// // // // // // // // // // // // //     final color = isSelected ? Colors.cyan : Colors.black;
// // // // // // // // // // // // //     final fontWeight = isSelected ? FontWeight.w600 : FontWeight.normal;
// // // // // // // // // // // // //
// // // // // // // // // // // // //     return ListTile(
// // // // // // // // // // // // //       leading: Icon(icon, color: color),
// // // // // // // // // // // // //       title: Padding(
// // // // // // // // // // // // //         padding: const EdgeInsets.only(left: 12.0),
// // // // // // // // // // // // //         child: Text(
// // // // // // // // // // // // //           label,
// // // // // // // // // // // // //           style: GoogleFonts.poppins(
// // // // // // // // // // // // //             textStyle: TextStyle(
// // // // // // // // // // // // //               color: color,
// // // // // // // // // // // // //               fontWeight: fontWeight,
// // // // // // // // // // // // //             ),
// // // // // // // // // // // // //           ),
// // // // // // // // // // // // //         ),
// // // // // // // // // // // // //       ),
// // // // // // // // // // // // //       onTap: () {
// // // // // // // // // // // // //         if (item == DrawerItem.apps) {
// // // // // // // // // // // // //           Provider.of<SubDrawerProvider>(context, listen: false).selectItem(SubDrawerItem.mobile);
// // // // // // // // // // // // //           Navigator.pushAndRemoveUntil(
// // // // // // // // // // // // //             context,
// // // // // // // // // // // // //             MaterialPageRoute(builder: (_) => const Apps()),
// // // // // // // // // // // // //                 (route) => false,
// // // // // // // // // // // // //           );
// // // // // // // // // // // // //         } else {
// // // // // // // // // // // // //           provider.selectItem(item);
// // // // // // // // // // // // //           if (!isDesktop) Navigator.pop(context);
// // // // // // // // // // // // //         }
// // // // // // // // // // // // //       },
// // // // // // // // // // // // //     );
// // // // // // // // // // // // //   }
// // // // // // // // // // // // //
// // // // // // // // // // // // //   Widget _buildCurvedDrawerHeader(BuildContext context) {
// // // // // // // // // // // // //     return Container(
// // // // // // // // // // // // //       decoration: const BoxDecoration(
// // // // // // // // // // // // //         color: Colors.cyan,
// // // // // // // // // // // // //         borderRadius: BorderRadius.only(
// // // // // // // // // // // // //           bottomLeft: Radius.circular(35),
// // // // // // // // // // // // //           bottomRight: Radius.circular(35),
// // // // // // // // // // // // //         ),
// // // // // // // // // // // // //       ),
// // // // // // // // // // // // //       height: 150,
// // // // // // // // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // // // // // // // //       child: Row(
// // // // // // // // // // // // //         children: [
// // // // // // // // // // // // //           CircleAvatar(
// // // // // // // // // // // // //             radius: 25,
// // // // // // // // // // // // //             backgroundImage: orgImage != null
// // // // // // // // // // // // //                 ? NetworkImage(orgImage!)
// // // // // // // // // // // // //                 : const AssetImage('assets/favicon.png') as ImageProvider,
// // // // // // // // // // // // //           ),
// // // // // // // // // // // // //           const SizedBox(width: 10),
// // // // // // // // // // // // //           Expanded(
// // // // // // // // // // // // //             child: Text(
// // // // // // // // // // // // //               orgName,
// // // // // // // // // // // // //               overflow: TextOverflow.ellipsis,
// // // // // // // // // // // // //               style: GoogleFonts.poppins(
// // // // // // // // // // // // //                 textStyle: const TextStyle(color: Colors.white, fontSize: 20),
// // // // // // // // // // // // //               ),
// // // // // // // // // // // // //             ),
// // // // // // // // // // // // //           ),
// // // // // // // // // // // // //           if (role == 'admin')
// // // // // // // // // // // // //             NotificationIconDropdown()
// // // // // // // // // // // // //         ],
// // // // // // // // // // // // //       ),
// // // // // // // // // // // // //     );
// // // // // // // // // // // // //   }
// // // // // // // // // // // // //
// // // // // // // // // // // // //   List<Widget> _buildDrawerItems(BuildContext context, bool isDesktop) {
// // // // // // // // // // // // //     final List<Widget> items = [
// // // // // // // // // // // // //       _buildCurvedDrawerHeader(context),
// // // // // // // // // // // // //       _buildDrawerTile(context, Iconsax.home, 'Home', DrawerItem.home, isDesktop),
// // // // // // // // // // // // //       _buildDrawerTile(context, Iconsax.book, 'Events', DrawerItem.events, isDesktop),
// // // // // // // // // // // // //       _buildDrawerTile(context, Iconsax.safe_home, 'Sermons', DrawerItem.sermons, isDesktop),
// // // // // // // // // // // // //       _buildDrawerTile(context, Iconsax.wallet_money, 'Giving', DrawerItem.giving, isDesktop),
// // // // // // // // // // // // //       _buildDrawerTile(context, Iconsax.element_3, 'Apps', DrawerItem.apps, isDesktop),
// // // // // // // // // // // // //       if (role == 'admin')
// // // // // // // // // // // // //         _buildDrawerTile(context, Iconsax.profile_2user, 'User', DrawerItem.user, isDesktop),
// // // // // // // // // // // // //       if (role == 'admin')
// // // // // // // // // // // // //         _buildDrawerTile(context, Iconsax.building, 'Organization', DrawerItem.organization, isDesktop),
// // // // // // // // // // // // //       if (role == 'admin')
// // // // // // // // // // // // //         _buildDrawerTile(context, Iconsax.box_2, 'Applications', DrawerItem.applications, isDesktop),
// // // // // // // // // // // // //       if (role == 'admin')
// // // // // // // // // // // // //         _buildDrawerTile(context, Iconsax.notification_bing, 'Push Notification', DrawerItem.pushnotification, isDesktop),
// // // // // // // // // // // // //       _buildDrawerTile(context, Iconsax.message_text, 'Notification', DrawerItem.notification, isDesktop),
// // // // // // // // // // // // //       _buildDrawerTile(context, Iconsax.profile_circle, 'Settings', DrawerItem.profile, isDesktop),
// // // // // // // // // // // // //     ];
// // // // // // // // // // // // //
// // // // // // // // // // // // //     return items;
// // // // // // // // // // // // //   }
// // // // // // // // // // // // //
// // // // // // // // // // // // //   Widget _buildLogoutSection(BuildContext context) {
// // // // // // // // // // // // //     return Container(
// // // // // // // // // // // // //       decoration: BoxDecoration(
// // // // // // // // // // // // //         color: Colors.cyan.shade300,
// // // // // // // // // // // // //         borderRadius: const BorderRadius.only(
// // // // // // // // // // // // //           topLeft: Radius.circular(15),
// // // // // // // // // // // // //           topRight: Radius.circular(15),
// // // // // // // // // // // // //         ),
// // // // // // // // // // // // //       ),
// // // // // // // // // // // // //       width: MediaQuery.of(context).size.width,
// // // // // // // // // // // // //       child: Padding(
// // // // // // // // // // // // //         padding: EdgeInsets.symmetric(
// // // // // // // // // // // // //           horizontal: MediaQuery.of(context).size.width * 0.01,
// // // // // // // // // // // // //           vertical: MediaQuery.of(context).size.width * 0.01,
// // // // // // // // // // // // //         ),
// // // // // // // // // // // // //         child: const LogoutButton(),
// // // // // // // // // // // // //       ),
// // // // // // // // // // // // //     );
// // // // // // // // // // // // //   }
// // // // // // // // // // // // //
// // // // // // // // // // // // //   @override
// // // // // // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // // // // // //     final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
// // // // // // // // // // // // //     final provider = Provider.of<SidedrawerProvider>(context);
// // // // // // // // // // // // //     final selectedItem = provider.selectedItem;
// // // // // // // // // // // // //
// // // // // // // // // // // // //     return Scaffold(
// // // // // // // // // // // // //       appBar: isDesktop
// // // // // // // // // // // // //           ? null
// // // // // // // // // // // // //           : AppBar(
// // // // // // // // // // // // //         title: Text(
// // // // // // // // // // // // //           _getTitle(selectedItem),
// // // // // // // // // // // // //           style: GoogleFonts.poppins(
// // // // // // // // // // // // //             textStyle: const TextStyle(color: Colors.black),
// // // // // // // // // // // // //           ),
// // // // // // // // // // // // //         ),
// // // // // // // // // // // // //         backgroundColor: Colors.white,
// // // // // // // // // // // // //         foregroundColor: Colors.black,
// // // // // // // // // // // // //         elevation: 1,
// // // // // // // // // // // // //       ),
// // // // // // // // // // // // //       drawer: isDesktop
// // // // // // // // // // // // //           ? null
// // // // // // // // // // // // //           : Drawer(
// // // // // // // // // // // // //         width: MediaQuery.of(context).size.width * .8,
// // // // // // // // // // // // //         child: Column(
// // // // // // // // // // // // //           children: [
// // // // // // // // // // // // //             Expanded(
// // // // // // // // // // // // //               child: ListView(
// // // // // // // // // // // // //                 children: _buildDrawerItems(context, false),
// // // // // // // // // // // // //               ),
// // // // // // // // // // // // //             ),
// // // // // // // // // // // // //             _buildLogoutSection(context),
// // // // // // // // // // // // //           ],
// // // // // // // // // // // // //         ),
// // // // // // // // // // // // //       ),
// // // // // // // // // // // // //       body: Row(
// // // // // // // // // // // // //         children: [
// // // // // // // // // // // // //           if (isDesktop)
// // // // // // // // // // // // //             ClipRRect(
// // // // // // // // // // // // //               borderRadius: const BorderRadius.only(
// // // // // // // // // // // // //                 topRight: Radius.circular(30),
// // // // // // // // // // // // //                 bottomRight: Radius.circular(30),
// // // // // // // // // // // // //               ),
// // // // // // // // // // // // //               child: Container(
// // // // // // // // // // // // //                 width: MediaQuery.of(context).size.width * .160,
// // // // // // // // // // // // //                 color: Colors.grey.shade100,
// // // // // // // // // // // // //                 child: Column(
// // // // // // // // // // // // //                   children: [
// // // // // // // // // // // // //                     ..._buildDrawerItems(context, true),
// // // // // // // // // // // // //                     const Spacer(),
// // // // // // // // // // // // //                     _buildLogoutSection(context),
// // // // // // // // // // // // //                   ],
// // // // // // // // // // // // //                 ),
// // // // // // // // // // // // //               ),
// // // // // // // // // // // // //             ),
// // // // // // // // // // // // //           Expanded(child: _getContent(selectedItem)),
// // // // // // // // // // // // //         ],
// // // // // // // // // // // // //       ),
// // // // // // // // // // // // //     );
// // // // // // // // // // // // //   }
// // // // // // // // // // // // // }
// // // // // // // // // // // //
// // // // // // // // // // // //
// // // // // // // // // // // // import 'package:ancilmediaadminpanel/View/Pushnotification.dart';
// // // // // // // // // // // // import 'package:ancilmediaadminpanel/View/Organization.dart';
// // // // // // // // // // // // import 'package:ancilmediaadminpanel/View/User.dart';
// // // // // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // // // // // // // // import 'package:provider/provider.dart';
// // // // // // // // // // // // import 'package:iconsax/iconsax.dart';
// // // // // // // // // // // // import 'package:socket_io_client/socket_io_client.dart' as IO;
// // // // // // // // // // // //
// // // // // // // // // // // // import '../Controller/Profile_controller.dart';
// // // // // // // // // // // // import '../Socket_Service.dart';
// // // // // // // // // // // // import '../View/Home_page.dart';
// // // // // // // // // // // // import '../View/Events.dart';
// // // // // // // // // // // // import '../View/Giving.dart';
// // // // // // // // // // // // import '../View/Sermons.dart';
// // // // // // // // // // // // import '../View/Apps_page/Apps.dart';
// // // // // // // // // // // // import '../View_model/Drawer_provider.dart';
// // // // // // // // // // // // import '../View_model/Sidebar_provider.dart';
// // // // // // // // // // // // import '../View_model/Logout.dart';
// // // // // // // // // // // // import '../environmental variables.dart';
// // // // // // // // // // // // import 'Application_page.dart';
// // // // // // // // // // // // import 'Notifications/Notification_page.dart';
// // // // // // // // // // // // import 'Profile_page.dart';
// // // // // // // // // // // // import '../Services/api_client.dart';
// // // // // // // // // // // // import 'Notifications/notification_bell.dart';
// // // // // // // // // // // //
// // // // // // // // // // // // class MainLayout extends StatefulWidget {
// // // // // // // // // // // //   const MainLayout({super.key});
// // // // // // // // // // // //
// // // // // // // // // // // //   @override
// // // // // // // // // // // //   State<MainLayout> createState() => _MainLayoutState();
// // // // // // // // // // // // }
// // // // // // // // // // // //
// // // // // // // // // // // // class _MainLayoutState extends State<MainLayout> {
// // // // // // // // // // // //   String orgName = 'Loading...';
// // // // // // // // // // // //   String? orgImage;
// // // // // // // // // // // //   String role = '';
// // // // // // // // // // // //   IO.Socket? socket;
// // // // // // // // // // // //
// // // // // // // // // // // //   @override
// // // // // // // // // // // //   void initState() {
// // // // // // // // // // // //     super.initState();
// // // // // // // // // // // //     loadOrgInfo();
// // // // // // // // // // // //     setupSocketListeners();
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Fetch profile data initially
// // // // // // // // // // // //   void loadOrgInfo() async {
// // // // // // // // // // // //     final apiClient = Provider.of<ApiClient>(context, listen: false);
// // // // // // // // // // // //     final controller = ProfileController(apiClient);
// // // // // // // // // // // //     final data = await controller.fetchProfile();
// // // // // // // // // // // //     if (data != null) {
// // // // // // // // // // // //       setState(() {
// // // // // // // // // // // //         orgName = data['username'] ?? 'Unknown';
// // // // // // // // // // // //         orgImage = data['image'];
// // // // // // // // // // // //         role = data['role'] ?? '';
// // // // // // // // // // // //       });
// // // // // // // // // // // //     }
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Initialize socket connection
// // // // // // // // // // // //   void setupSocketListeners() {
// // // // // // // // // // // //     final socketService = SocketService();
// // // // // // // // // // // //
// // // // // // // // // // // //     socketService.on('connect', (_) {
// // // // // // // // // // // //       debugPrint('✅ Connected to socket server (MainLayout)');
// // // // // // // // // // // //     });
// // // // // // // // // // // //
// // // // // // // // // // // //     socketService.on('disconnect', (_) {
// // // // // // // // // // // //       debugPrint('❌ Disconnected from socket server (MainLayout)');
// // // // // // // // // // // //     });
// // // // // // // // // // // //
// // // // // // // // // // // //     socketService.on('profile_updated', (data) {
// // // // // // // // // // // //       debugPrint('📸 Profile updated event: $data');
// // // // // // // // // // // //       setState(() {
// // // // // // // // // // // //         orgName = data['username'] ?? orgName;
// // // // // // // // // // // //         orgImage = data['image'] ?? orgImage;
// // // // // // // // // // // //         role = data['role'] ?? role;
// // // // // // // // // // // //       });
// // // // // // // // // // // //     });
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //
// // // // // // // // // // // //   @override
// // // // // // // // // // // //   void dispose() {
// // // // // // // // // // // //     socket?.disconnect();
// // // // // // // // // // // //     super.dispose();
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Drawer Content Selection
// // // // // // // // // // // //   Widget _getContent(DrawerItem item) {
// // // // // // // // // // // //     switch (item) {
// // // // // // // // // // // //       case DrawerItem.home:
// // // // // // // // // // // //         return const HomePage();
// // // // // // // // // // // //       case DrawerItem.events:
// // // // // // // // // // // //         return const Events();
// // // // // // // // // // // //       case DrawerItem.sermons:
// // // // // // // // // // // //         return const Sermons();
// // // // // // // // // // // //       case DrawerItem.giving:
// // // // // // // // // // // //         return const Giving();
// // // // // // // // // // // //       case DrawerItem.apps:
// // // // // // // // // // // //         return const Apps();
// // // // // // // // // // // //       case DrawerItem.user:
// // // // // // // // // // // //         return const UserPage();
// // // // // // // // // // // //       case DrawerItem.organization:
// // // // // // // // // // // //         return const Organization();
// // // // // // // // // // // //       case DrawerItem.applications:
// // // // // // // // // // // //         return const ApplicationPage();
// // // // // // // // // // // //       case DrawerItem.pushnotification:
// // // // // // // // // // // //         return const PushNotification();
// // // // // // // // // // // //       case DrawerItem.profile:
// // // // // // // // // // // //         return const Profile();
// // // // // // // // // // // //       case DrawerItem.notification:
// // // // // // // // // // // //         return const NotificationPage();
// // // // // // // // // // // //       default:
// // // // // // // // // // // //         return const HomePage();
// // // // // // // // // // // //     }
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Title for AppBar
// // // // // // // // // // // //   String _getTitle(DrawerItem item) {
// // // // // // // // // // // //     switch (item) {
// // // // // // // // // // // //       case DrawerItem.home:
// // // // // // // // // // // //         return 'Home';
// // // // // // // // // // // //       case DrawerItem.events:
// // // // // // // // // // // //         return 'Events';
// // // // // // // // // // // //       case DrawerItem.sermons:
// // // // // // // // // // // //         return 'Sermons';
// // // // // // // // // // // //       case DrawerItem.giving:
// // // // // // // // // // // //         return 'Giving';
// // // // // // // // // // // //       case DrawerItem.apps:
// // // // // // // // // // // //         return 'Apps';
// // // // // // // // // // // //       case DrawerItem.user:
// // // // // // // // // // // //         return 'User';
// // // // // // // // // // // //       case DrawerItem.organization:
// // // // // // // // // // // //         return 'Organization';
// // // // // // // // // // // //       case DrawerItem.pushnotification:
// // // // // // // // // // // //         return 'Push Notification';
// // // // // // // // // // // //       case DrawerItem.applications:
// // // // // // // // // // // //         return 'Application';
// // // // // // // // // // // //       case DrawerItem.profile:
// // // // // // // // // // // //         return 'Profile';
// // // // // // // // // // // //       case DrawerItem.notification:
// // // // // // // // // // // //         return 'Notification'; // 🔥 Fixed wrong title
// // // // // // // // // // // //       default:
// // // // // // // // // // // //         return 'Ancil Media';
// // // // // // // // // // // //     }
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Drawer Tile Widget
// // // // // // // // // // // //   Widget _buildDrawerTile(
// // // // // // // // // // // //       BuildContext context, IconData icon, String label, DrawerItem item, bool isDesktop) {
// // // // // // // // // // // //     final provider = Provider.of<SidedrawerProvider>(context);
// // // // // // // // // // // //     final isSelected = provider.selectedItem == item;
// // // // // // // // // // // //     final color = isSelected ? Colors.cyan : Colors.black;
// // // // // // // // // // // //     final fontWeight = isSelected ? FontWeight.w600 : FontWeight.normal;
// // // // // // // // // // // //
// // // // // // // // // // // //     return ListTile(
// // // // // // // // // // // //       leading: Icon(icon, color: color),
// // // // // // // // // // // //       title: Padding(
// // // // // // // // // // // //         padding: const EdgeInsets.only(left: 12.0),
// // // // // // // // // // // //         child: Text(
// // // // // // // // // // // //           label,
// // // // // // // // // // // //           style: GoogleFonts.poppins(
// // // // // // // // // // // //             textStyle: TextStyle(
// // // // // // // // // // // //               color: color,
// // // // // // // // // // // //               fontWeight: fontWeight,
// // // // // // // // // // // //             ),
// // // // // // // // // // // //           ),
// // // // // // // // // // // //         ),
// // // // // // // // // // // //       ),
// // // // // // // // // // // //       onTap: () {
// // // // // // // // // // // //         if (item == DrawerItem.apps) {
// // // // // // // // // // // //           Provider.of<SubDrawerProvider>(context, listen: false)
// // // // // // // // // // // //               .selectItem(SubDrawerItem.mobile);
// // // // // // // // // // // //           Navigator.pushAndRemoveUntil(
// // // // // // // // // // // //             context,
// // // // // // // // // // // //             MaterialPageRoute(builder: (_) => const Apps()),
// // // // // // // // // // // //                 (route) => false,
// // // // // // // // // // // //           );
// // // // // // // // // // // //         } else {
// // // // // // // // // // // //           provider.selectItem(item);
// // // // // // // // // // // //           if (!isDesktop) Navigator.pop(context);
// // // // // // // // // // // //         }
// // // // // // // // // // // //       },
// // // // // // // // // // // //     );
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Drawer Header
// // // // // // // // // // // //   Widget _buildCurvedDrawerHeader(BuildContext context) {
// // // // // // // // // // // //     return Container(
// // // // // // // // // // // //       decoration: const BoxDecoration(
// // // // // // // // // // // //         color: Colors.cyan,
// // // // // // // // // // // //         borderRadius: BorderRadius.only(
// // // // // // // // // // // //           bottomLeft: Radius.circular(35),
// // // // // // // // // // // //           bottomRight: Radius.circular(35),
// // // // // // // // // // // //         ),
// // // // // // // // // // // //       ),
// // // // // // // // // // // //       height: 150,
// // // // // // // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // // // // // // //       child: Row(
// // // // // // // // // // // //         children: [
// // // // // // // // // // // //           CircleAvatar(
// // // // // // // // // // // //             radius: 25,
// // // // // // // // // // // //             backgroundImage: orgImage != null
// // // // // // // // // // // //                 ? NetworkImage(orgImage!)
// // // // // // // // // // // //                 : const AssetImage('assets/favicon.png') as ImageProvider,
// // // // // // // // // // // //           ),
// // // // // // // // // // // //           const SizedBox(width: 10),
// // // // // // // // // // // //           Expanded(
// // // // // // // // // // // //             child: Text(
// // // // // // // // // // // //               orgName,
// // // // // // // // // // // //               overflow: TextOverflow.ellipsis,
// // // // // // // // // // // //               style: GoogleFonts.poppins(
// // // // // // // // // // // //                 textStyle: const TextStyle(color: Colors.white, fontSize: 20),
// // // // // // // // // // // //               ),
// // // // // // // // // // // //             ),
// // // // // // // // // // // //           ),
// // // // // // // // // // // //           if (role == 'admin') NotificationIconDropdown(),
// // // // // // // // // // // //         ],
// // // // // // // // // // // //       ),
// // // // // // // // // // // //     );
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Drawer Items
// // // // // // // // // // // //   List<Widget> _buildDrawerItems(BuildContext context, bool isDesktop) {
// // // // // // // // // // // //     final List<Widget> items = [
// // // // // // // // // // // //       _buildCurvedDrawerHeader(context),
// // // // // // // // // // // //       _buildDrawerTile(context, Iconsax.home, 'Home', DrawerItem.home, isDesktop),
// // // // // // // // // // // //       _buildDrawerTile(context, Iconsax.book, 'Events', DrawerItem.events, isDesktop),
// // // // // // // // // // // //       _buildDrawerTile(context, Iconsax.safe_home, 'Sermons', DrawerItem.sermons, isDesktop),
// // // // // // // // // // // //       _buildDrawerTile(context, Iconsax.wallet_money, 'Giving', DrawerItem.giving, isDesktop),
// // // // // // // // // // // //       _buildDrawerTile(context, Iconsax.element_3, 'Apps', DrawerItem.apps, isDesktop),
// // // // // // // // // // // //       if (role == '68a7f7cb27471122559a100b')
// // // // // // // // // // // //         _buildDrawerTile(context, Iconsax.profile_2user, 'User', DrawerItem.user, isDesktop),
// // // // // // // // // // // //       if (role == '68a7f7cb27471122559a100b')
// // // // // // // // // // // //         _buildDrawerTile(context, Iconsax.building, 'Organization', DrawerItem.organization, isDesktop),
// // // // // // // // // // // //       if (role == '68a7f7cb27471122559a100b')
// // // // // // // // // // // //         _buildDrawerTile(context, Iconsax.box_2, 'Applications', DrawerItem.applications, isDesktop),
// // // // // // // // // // // //       if (role == '68a7f7cb27471122559a100b')
// // // // // // // // // // // //         _buildDrawerTile(context, Iconsax.notification_bing, 'Push Notification', DrawerItem.pushnotification, isDesktop),
// // // // // // // // // // // //       _buildDrawerTile(context, Iconsax.message_text, 'Notification', DrawerItem.notification, isDesktop),
// // // // // // // // // // // //       _buildDrawerTile(context, Iconsax.profile_circle, 'Settings', DrawerItem.profile, isDesktop),
// // // // // // // // // // // //     ];
// // // // // // // // // // // //     return items;
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Logout Section
// // // // // // // // // // // //   Widget _buildLogoutSection(BuildContext context) {
// // // // // // // // // // // //     return Container(
// // // // // // // // // // // //       decoration: BoxDecoration(
// // // // // // // // // // // //         color: Colors.cyan.shade300,
// // // // // // // // // // // //         borderRadius: const BorderRadius.only(
// // // // // // // // // // // //           topLeft: Radius.circular(15),
// // // // // // // // // // // //           topRight: Radius.circular(15),
// // // // // // // // // // // //         ),
// // // // // // // // // // // //       ),
// // // // // // // // // // // //       width: MediaQuery.of(context).size.width,
// // // // // // // // // // // //       child: Padding(
// // // // // // // // // // // //         padding: EdgeInsets.symmetric(
// // // // // // // // // // // //           horizontal: MediaQuery.of(context).size.width * 0.01,
// // // // // // // // // // // //           vertical: MediaQuery.of(context).size.width * 0.01,
// // // // // // // // // // // //         ),
// // // // // // // // // // // //         child: const LogoutButton(),
// // // // // // // // // // // //       ),
// // // // // // // // // // // //     );
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Build Scaffold
// // // // // // // // // // // //   @override
// // // // // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // // // // //     final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
// // // // // // // // // // // //     final provider = Provider.of<SidedrawerProvider>(context);
// // // // // // // // // // // //     final selectedItem = provider.selectedItem;
// // // // // // // // // // // //
// // // // // // // // // // // //     return Scaffold(
// // // // // // // // // // // //       appBar: isDesktop
// // // // // // // // // // // //           ? null
// // // // // // // // // // // //           : AppBar(
// // // // // // // // // // // //         title: Text(
// // // // // // // // // // // //           _getTitle(selectedItem),
// // // // // // // // // // // //           style: GoogleFonts.poppins(
// // // // // // // // // // // //             textStyle: const TextStyle(color: Colors.black),
// // // // // // // // // // // //           ),
// // // // // // // // // // // //         ),
// // // // // // // // // // // //         backgroundColor: Colors.white,
// // // // // // // // // // // //         foregroundColor: Colors.black,
// // // // // // // // // // // //         elevation: 1,
// // // // // // // // // // // //       ),
// // // // // // // // // // // //       drawer: isDesktop
// // // // // // // // // // // //           ? null
// // // // // // // // // // // //           : Drawer(
// // // // // // // // // // // //         width: MediaQuery.of(context).size.width * .8,
// // // // // // // // // // // //         child: Column(
// // // // // // // // // // // //           children: [
// // // // // // // // // // // //             Expanded(
// // // // // // // // // // // //               child: ListView(
// // // // // // // // // // // //                 children: _buildDrawerItems(context, false),
// // // // // // // // // // // //               ),
// // // // // // // // // // // //             ),
// // // // // // // // // // // //             _buildLogoutSection(context),
// // // // // // // // // // // //           ],
// // // // // // // // // // // //         ),
// // // // // // // // // // // //       ),
// // // // // // // // // // // //       body: Row(
// // // // // // // // // // // //         children: [
// // // // // // // // // // // //           if (isDesktop)
// // // // // // // // // // // //             ClipRRect(
// // // // // // // // // // // //               borderRadius: const BorderRadius.only(
// // // // // // // // // // // //                 topRight: Radius.circular(30),
// // // // // // // // // // // //                 bottomRight: Radius.circular(30),
// // // // // // // // // // // //               ),
// // // // // // // // // // // //               child: Container(
// // // // // // // // // // // //                 width: MediaQuery.of(context).size.width * .160,
// // // // // // // // // // // //                 color: Colors.grey.shade100,
// // // // // // // // // // // //                 child: Column(
// // // // // // // // // // // //                   children: [
// // // // // // // // // // // //                     ..._buildDrawerItems(context, true),
// // // // // // // // // // // //                     const Spacer(),
// // // // // // // // // // // //                     _buildLogoutSection(context),
// // // // // // // // // // // //                   ],
// // // // // // // // // // // //                 ),
// // // // // // // // // // // //               ),
// // // // // // // // // // // //             ),
// // // // // // // // // // // //           Expanded(child: _getContent(selectedItem)),
// // // // // // // // // // // //         ],
// // // // // // // // // // // //       ),
// // // // // // // // // // // //     );
// // // // // // // // // // // //   }
// // // // // // // // // // // // }
// // // // // // // // // // //
// // // // // // // // // // // //
// // // // // // // // // // // // import 'package:ancilmediaadminpanel/View/Pushnotification.dart';
// // // // // // // // // // // // import 'package:ancilmediaadminpanel/View/Organization.dart';
// // // // // // // // // // // // import 'package:ancilmediaadminpanel/View/User.dart';
// // // // // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // // // // // // // // import 'package:provider/provider.dart';
// // // // // // // // // // // // import 'package:iconsax/iconsax.dart';
// // // // // // // // // // // // import 'package:socket_io_client/socket_io_client.dart' as IO;
// // // // // // // // // // // //
// // // // // // // // // // // // import '../Controller/Profile_controller.dart';
// // // // // // // // // // // // import '../Socket_Service.dart';
// // // // // // // // // // // // import '../View/Home_page.dart';
// // // // // // // // // // // // import '../View/Events.dart';
// // // // // // // // // // // // import '../View/Giving.dart';
// // // // // // // // // // // // import '../View/Sermons.dart';
// // // // // // // // // // // // import '../View/Apps_page/Apps.dart';
// // // // // // // // // // // // import '../View_model/Drawer_provider.dart';
// // // // // // // // // // // // import '../View_model/Sidebar_provider.dart';
// // // // // // // // // // // // import '../View_model/Logout.dart';
// // // // // // // // // // // // import '../environmental variables.dart';
// // // // // // // // // // // // import 'Application_page.dart';
// // // // // // // // // // // // import 'Notifications/Notification_page.dart';
// // // // // // // // // // // // import 'Profile_page.dart';
// // // // // // // // // // // // import '../Services/api_client.dart';
// // // // // // // // // // // // import 'Notifications/notification_bell.dart';
// // // // // // // // // // // // import '../Controller/Sidebar_controller.dart';
// // // // // // // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // // // // // // //
// // // // // // // // // // // // class MainLayout extends StatefulWidget {
// // // // // // // // // // // //   const MainLayout({super.key});
// // // // // // // // // // // //
// // // // // // // // // // // //   @override
// // // // // // // // // // // //   State<MainLayout> createState() => _MainLayoutState();
// // // // // // // // // // // // }
// // // // // // // // // // // //
// // // // // // // // // // // // class _MainLayoutState extends State<MainLayout> {
// // // // // // // // // // // //   String orgName = 'Loading...';
// // // // // // // // // // // //   String? orgImage;
// // // // // // // // // // // //   String role = '';
// // // // // // // // // // // //   IO.Socket? socket;
// // // // // // // // // // // //   SidebarController? sidebarController;
// // // // // // // // // // // //
// // // // // // // // // // // //   @override
// // // // // // // // // // // //   void initState() {
// // // // // // // // // // // //     super.initState();
// // // // // // // // // // // //     loadOrgInfo();
// // // // // // // // // // // //     setupSocketListeners();
// // // // // // // // // // // //     loadSidebar();
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// Load sidebar with token from local storage
// // // // // // // // // // // //   void loadSidebar() async {
// // // // // // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // // // // // //     final token = prefs.getString('token') ?? '';
// // // // // // // // // // // //     sidebarController = SidebarController(token: token);
// // // // // // // // // // // //     setState(() {});
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Fetch profile data
// // // // // // // // // // // //   void loadOrgInfo() async {
// // // // // // // // // // // //     final apiClient = Provider.of<ApiClient>(context, listen: false);
// // // // // // // // // // // //     final controller = ProfileController(apiClient);
// // // // // // // // // // // //     final data = await controller.fetchProfile();
// // // // // // // // // // // //     if (data != null) {
// // // // // // // // // // // //       setState(() {
// // // // // // // // // // // //         orgName = data['username'] ?? 'Unknown';
// // // // // // // // // // // //         orgImage = data['image'];
// // // // // // // // // // // //         role = data['role'] ?? '';
// // // // // // // // // // // //       });
// // // // // // // // // // // //     }
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Socket connection
// // // // // // // // // // // //   void setupSocketListeners() {
// // // // // // // // // // // //     final socketService = SocketService();
// // // // // // // // // // // //     socketService.on('connect', (_) {
// // // // // // // // // // // //       debugPrint('✅ Connected to socket server (MainLayout)');
// // // // // // // // // // // //     });
// // // // // // // // // // // //     socketService.on('disconnect', (_) {
// // // // // // // // // // // //       debugPrint('❌ Disconnected from socket server (MainLayout)');
// // // // // // // // // // // //     });
// // // // // // // // // // // //     socketService.on('profile_updated', (data) {
// // // // // // // // // // // //       setState(() {
// // // // // // // // // // // //         orgName = data['username'] ?? orgName;
// // // // // // // // // // // //         orgImage = data['image'] ?? orgImage;
// // // // // // // // // // // //         role = data['role'] ?? role;
// // // // // // // // // // // //       });
// // // // // // // // // // // //     });
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   @override
// // // // // // // // // // // //   void dispose() {
// // // // // // // // // // // //     socket?.disconnect();
// // // // // // // // // // // //     super.dispose();
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Drawer content selection
// // // // // // // // // // // //   Widget _getContent(DrawerItem item) {
// // // // // // // // // // // //     switch (item) {
// // // // // // // // // // // //       case DrawerItem.home:
// // // // // // // // // // // //         return const HomePage();
// // // // // // // // // // // //       case DrawerItem.events:
// // // // // // // // // // // //         return const Events();
// // // // // // // // // // // //       case DrawerItem.sermons:
// // // // // // // // // // // //         return const Sermons();
// // // // // // // // // // // //       case DrawerItem.giving:
// // // // // // // // // // // //         return const Giving();
// // // // // // // // // // // //       case DrawerItem.apps:
// // // // // // // // // // // //         return const Apps();
// // // // // // // // // // // //       case DrawerItem.user:
// // // // // // // // // // // //         return const UserPage();
// // // // // // // // // // // //       case DrawerItem.organization:
// // // // // // // // // // // //         return const Organization();
// // // // // // // // // // // //       case DrawerItem.applications:
// // // // // // // // // // // //         return const ApplicationPage();
// // // // // // // // // // // //       case DrawerItem.pushnotification:
// // // // // // // // // // // //         return const PushNotification();
// // // // // // // // // // // //       case DrawerItem.profile:
// // // // // // // // // // // //         return const Profile();
// // // // // // // // // // // //       case DrawerItem.notification:
// // // // // // // // // // // //         return const NotificationPage();
// // // // // // // // // // // //       default:
// // // // // // // // // // // //         return const HomePage();
// // // // // // // // // // // //     }
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Drawer tile widget
// // // // // // // // // // // //   Widget _buildDrawerTile(Map<String, dynamic> item, bool isDesktop) {
// // // // // // // // // // // //     final provider = Provider.of<SidedrawerProvider>(context);
// // // // // // // // // // // //     final key = item['key'] ?? '';
// // // // // // // // // // // //     final iconData = _getIconFromString(item['icon'] ?? 'home');
// // // // // // // // // // // //     final label = item['name'] ?? 'Unknown';
// // // // // // // // // // // //
// // // // // // // // // // // //     final isSelected = provider.selectedItem?.name == key;
// // // // // // // // // // // //     final color = isSelected ? Colors.cyan : Colors.black;
// // // // // // // // // // // //     final fontWeight = isSelected ? FontWeight.w600 : FontWeight.normal;
// // // // // // // // // // // //
// // // // // // // // // // // //     return ListTile(
// // // // // // // // // // // //       leading: Icon(iconData, color: color),
// // // // // // // // // // // //       title: Padding(
// // // // // // // // // // // //         padding: const EdgeInsets.only(left: 12.0),
// // // // // // // // // // // //         child: Text(
// // // // // // // // // // // //           label,
// // // // // // // // // // // //           style: GoogleFonts.poppins(
// // // // // // // // // // // //             textStyle: TextStyle(color: color, fontWeight: fontWeight),
// // // // // // // // // // // //           ),
// // // // // // // // // // // //         ),
// // // // // // // // // // // //       ),
// // // // // // // // // // // //       onTap: () {
// // // // // // // // // // // //         // Map key to DrawerItem enum
// // // // // // // // // // // //         DrawerItem selectedEnum = DrawerItem.values.firstWhere(
// // // // // // // // // // // //                 (e) => e.name == key,
// // // // // // // // // // // //             orElse: () => DrawerItem.home);
// // // // // // // // // // // //
// // // // // // // // // // // //         provider.selectItem(selectedEnum);
// // // // // // // // // // // //
// // // // // // // // // // // //         if (!isDesktop) Navigator.pop(context);
// // // // // // // // // // // //       },
// // // // // // // // // // // //     );
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // //   /// 🔹 Map string icon name to Iconsax
// // // // // // // // //   IconData _getIconFromString(String icon) {
// // // // // // // // //     switch (icon) {
// // // // // // // // //       case 'home':
// // // // // // // // //         return Iconsax.home;
// // // // // // // // //       case 'events':
// // // // // // // // //         return Iconsax.book;
// // // // // // // // //       case 'sermons':
// // // // // // // // //         return Iconsax.safe_home;
// // // // // // // // //       case 'giving':
// // // // // // // // //         return Iconsax.wallet_money;
// // // // // // // // //       case 'apps':
// // // // // // // // //         return Iconsax.element_3;
// // // // // // // // //       case 'user':
// // // // // // // // //         return Iconsax.profile_2user;
// // // // // // // // //       case 'organization':
// // // // // // // // //         return Iconsax.building;
// // // // // // // // //       case 'applications':
// // // // // // // // //         return Iconsax.box_2;
// // // // // // // // //       case 'pushnotification':
// // // // // // // // //         return Iconsax.notification_bing;
// // // // // // // // //       case 'notification':
// // // // // // // // //         return Iconsax.message_text;
// // // // // // // // //       case 'profile':
// // // // // // // // //         return Iconsax.profile_circle;
// // // // // // // // //       default:
// // // // // // // // //         return Iconsax.home;
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Drawer header
// // // // // // // // // // // //   Widget _buildCurvedDrawerHeader() {
// // // // // // // // // // // //     return Container(
// // // // // // // // // // // //       decoration: const BoxDecoration(
// // // // // // // // // // // //         color: Colors.cyan,
// // // // // // // // // // // //         borderRadius: BorderRadius.only(
// // // // // // // // // // // //           bottomLeft: Radius.circular(35),
// // // // // // // // // // // //           bottomRight: Radius.circular(35),
// // // // // // // // // // // //         ),
// // // // // // // // // // // //       ),
// // // // // // // // // // // //       height: 150,
// // // // // // // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // // // // // // //       child: Row(
// // // // // // // // // // // //         children: [
// // // // // // // // // // // //           CircleAvatar(
// // // // // // // // // // // //             radius: 25,
// // // // // // // // // // // //             backgroundImage: orgImage != null
// // // // // // // // // // // //                 ? NetworkImage(orgImage!)
// // // // // // // // // // // //                 : const AssetImage('assets/favicon.png') as ImageProvider,
// // // // // // // // // // // //           ),
// // // // // // // // // // // //           const SizedBox(width: 10),
// // // // // // // // // // // //           Expanded(
// // // // // // // // // // // //             child: Text(
// // // // // // // // // // // //               orgName,
// // // // // // // // // // // //               overflow: TextOverflow.ellipsis,
// // // // // // // // // // // //               style: GoogleFonts.poppins(
// // // // // // // // // // // //                 textStyle: const TextStyle(color: Colors.white, fontSize: 20),
// // // // // // // // // // // //               ),
// // // // // // // // // // // //             ),
// // // // // // // // // // // //           ),
// // // // // // // // // // // //           if (role == 'admin') NotificationIconDropdown(),
// // // // // // // // // // // //         ],
// // // // // // // // // // // //       ),
// // // // // // // // // // // //     );
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Build drawer items dynamically
// // // // // // // // // // // //   List<Widget> _buildDrawerItems(bool isDesktop) {
// // // // // // // // // // // //     List<Widget> items = [_buildCurvedDrawerHeader()];
// // // // // // // // // // // //
// // // // // // // // // // // //     if (sidebarController != null && sidebarController!.sidebarItems.isNotEmpty) {
// // // // // // // // // // // //       for (var item in sidebarController!.sidebarItems) {
// // // // // // // // // // // //         // Optional: filter by role
// // // // // // // // // // // //         if (item['roles'] == null || item['roles'].contains(role)) {
// // // // // // // // // // // //           items.add(_buildDrawerTile(item, isDesktop));
// // // // // // // // // // // //         }
// // // // // // // // // // // //       }
// // // // // // // // // // // //     }
// // // // // // // // // // // //
// // // // // // // // // // // //     return items;
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Logout section
// // // // // // // // // // // //   Widget _buildLogoutSection() {
// // // // // // // // // // // //     return Container(
// // // // // // // // // // // //       decoration: BoxDecoration(
// // // // // // // // // // // //         color: Colors.cyan.shade300,
// // // // // // // // // // // //         borderRadius: const BorderRadius.only(
// // // // // // // // // // // //           topLeft: Radius.circular(15),
// // // // // // // // // // // //           topRight: Radius.circular(15),
// // // // // // // // // // // //         ),
// // // // // // // // // // // //       ),
// // // // // // // // // // // //       width: double.infinity,
// // // // // // // // // // // //       child: const LogoutButton(),
// // // // // // // // // // // //     );
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// 🔹 Build Scaffold
// // // // // // // // // // // //   @override
// // // // // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // // // // //     final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
// // // // // // // // // // // //     final provider = Provider.of<SidedrawerProvider>(context);
// // // // // // // // // // // //     final selectedItem = provider.selectedItem ?? DrawerItem.home;
// // // // // // // // // // // //
// // // // // // // // // // // //     return Scaffold(
// // // // // // // // // // // //       appBar: isDesktop
// // // // // // // // // // // //           ? null
// // // // // // // // // // // //           : AppBar(
// // // // // // // // // // // //         title: Text(
// // // // // // // // // // // //           selectedItem.name.toUpperCase(),
// // // // // // // // // // // //           style: GoogleFonts.poppins(
// // // // // // // // // // // //               textStyle: const TextStyle(color: Colors.black)),
// // // // // // // // // // // //         ),
// // // // // // // // // // // //         backgroundColor: Colors.white,
// // // // // // // // // // // //         foregroundColor: Colors.black,
// // // // // // // // // // // //         elevation: 1,
// // // // // // // // // // // //       ),
// // // // // // // // // // // //       drawer: isDesktop
// // // // // // // // // // // //           ? null
// // // // // // // // // // // //           : Drawer(
// // // // // // // // // // // //         width: MediaQuery.of(context).size.width * .8,
// // // // // // // // // // // //         child: Column(
// // // // // // // // // // // //           children: [
// // // // // // // // // // // //             Expanded(child: ListView(children: _buildDrawerItems(false))),
// // // // // // // // // // // //             _buildLogoutSection(),
// // // // // // // // // // // //           ],
// // // // // // // // // // // //         ),
// // // // // // // // // // // //       ),
// // // // // // // // // // // //       body: Row(
// // // // // // // // // // // //         children: [
// // // // // // // // // // // //           if (isDesktop)
// // // // // // // // // // // //             ClipRRect(
// // // // // // // // // // // //               borderRadius: const BorderRadius.only(
// // // // // // // // // // // //                 topRight: Radius.circular(30),
// // // // // // // // // // // //                 bottomRight: Radius.circular(30),
// // // // // // // // // // // //               ),
// // // // // // // // // // // //               child: Container(
// // // // // // // // // // // //                 width: MediaQuery.of(context).size.width * .16,
// // // // // // // // // // // //                 color: Colors.grey.shade100,
// // // // // // // // // // // //                 child: Column(
// // // // // // // // // // // //                   children: [
// // // // // // // // // // // //                     ..._buildDrawerItems(true),
// // // // // // // // // // // //                     const Spacer(),
// // // // // // // // // // // //                     _buildLogoutSection(),
// // // // // // // // // // // //                   ],
// // // // // // // // // // // //                 ),
// // // // // // // // // // // //               ),
// // // // // // // // // // // //             ),
// // // // // // // // // // // //           Expanded(child: _getContent(selectedItem)),
// // // // // // // // // // // //         ],
// // // // // // // // // // // //       ),
// // // // // // // // // // // //     );
// // // // // // // // // // // //   }
// // // // // // // // // // // // }
// // // // // // // // // // //
// // // // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // // // // // // // import 'package:provider/provider.dart';
// // // // // // // // // // // import '../Controller/Sidebar_controller.dart';
// // // // // // // // // // // import '../View_model/Sidebar_provider.dart';
// // // // // // // // // // // import '../View_model/Logout.dart';
// // // // // // // // // // //
// // // // // // // // // // // // Pages
// // // // // // // // // // // import '../View_model/side_navbar_drawer.dart';
// // // // // // // // // // // import 'Application_page.dart';
// // // // // // // // // // // import 'Apps_page/Apps.dart';
// // // // // // // // // // // import 'Apps_page/Push_Notifications.dart';
// // // // // // // // // // // import 'Events.dart';
// // // // // // // // // // // import 'Giving.dart';
// // // // // // // // // // // import 'Home_page.dart';
// // // // // // // // // // // import 'Notifications/Notification_page.dart';
// // // // // // // // // // // import 'Organization.dart';
// // // // // // // // // // // import 'Profile_page.dart';
// // // // // // // // // // // import 'Sermons.dart';
// // // // // // // // // // // import 'User.dart';
// // // // // // // // // // // import 'Notifications/notification_bell.dart';
// // // // // // // // // // //
// // // // // // // // // // // class MainLayout extends StatefulWidget {
// // // // // // // // // // //   const MainLayout({Key? key}) : super(key: key);
// // // // // // // // // // //
// // // // // // // // // // //   @override
// // // // // // // // // // //   _MainLayoutState createState() => _MainLayoutState();
// // // // // // // // // // // }
// // // // // // // // // // //
// // // // // // // // // // // class _MainLayoutState extends State<MainLayout> {
// // // // // // // // // // //   String orgName = "Ancil Media";
// // // // // // // // // // //   String? orgImage;
// // // // // // // // // // //   String role = "user"; // ← replace with actual role from profile API
// // // // // // // // // // //
// // // // // // // // // // //   @override
// // // // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // // // // // // // // //     final provider = Provider.of<SidebarProvider>(context);
// // // // // // // // // // //
// // // // // // // // // // //     final selectedKey = provider.selectedKey ??
// // // // // // // // // // //         (sidebarController.sidebarItems.isNotEmpty
// // // // // // // // // // //             ? sidebarController.sidebarItems.first['key']
// // // // // // // // // // //             : null);
// // // // // // // // // // //
// // // // // // // // // // //     final selectedLabel = sidebarController.sidebarItems
// // // // // // // // // // //         .firstWhere(
// // // // // // // // // // //           (item) => item['key'] == selectedKey,
// // // // // // // // // // //       orElse: () => {'label': 'Ancil Media'},
// // // // // // // // // // //     )['label'];
// // // // // // // // // // //
// // // // // // // // // // //     final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
// // // // // // // // // // //
// // // // // // // // // // //     return Scaffold(
// // // // // // // // // // //       appBar: isDesktop
// // // // // // // // // // //           ? null
// // // // // // // // // // //           : AppBar(
// // // // // // // // // // //         title: Text(
// // // // // // // // // // //           selectedLabel,
// // // // // // // // // // //           style: GoogleFonts.poppins(
// // // // // // // // // // //             textStyle: const TextStyle(color: Colors.black),
// // // // // // // // // // //           ),
// // // // // // // // // // //         ),
// // // // // // // // // // //         backgroundColor: Colors.white,
// // // // // // // // // // //         foregroundColor: Colors.black,
// // // // // // // // // // //         elevation: 1,
// // // // // // // // // // //       ),
// // // // // // // // // // //       body: Row(
// // // // // // // // // // //         children: [
// // // // // // // // // // //           /// 🔹 Sidebar
// // // // // // // // // // //           if (isDesktop)
// // // // // // // // // // //             ClipRRect(
// // // // // // // // // // //               borderRadius: const BorderRadius.only(
// // // // // // // // // // //                 topRight: Radius.circular(30),
// // // // // // // // // // //                 bottomRight: Radius.circular(30),
// // // // // // // // // // //               ),
// // // // // // // // // // //               child: Container(
// // // // // // // // // // //                 width: MediaQuery.of(context).size.width * .18,
// // // // // // // // // // //                 color: Colors.grey.shade100,
// // // // // // // // // // //                 child: Column(
// // // // // // // // // // //                   children: [
// // // // // // // // // // //                     _buildCurvedDrawerHeader(),
// // // // // // // // // // //                     Expanded(
// // // // // // // // // // //                       child: sidebarController.isLoading
// // // // // // // // // // //                           ? const Center(child: CircularProgressIndicator())
// // // // // // // // // // //                           : ListView(
// // // // // // // // // // //                         children: _buildSidebarItems(context),
// // // // // // // // // // //                       ),
// // // // // // // // // // //                     ),
// // // // // // // // // // //                     _buildLogoutSection(),
// // // // // // // // // // //                   ],
// // // // // // // // // // //                 ),
// // // // // // // // // // //               ),
// // // // // // // // // // //             ),
// // // // // // // // // // //
// // // // // // // // // // //           /// 🔹 Page Content
// // // // // // // // // // //           Expanded(child: _getContent(selectedKey)),
// // // // // // // // // // //         ],
// // // // // // // // // // //       ),
// // // // // // // // // // //     );
// // // // // // // // // // //   }
// // // // // // // // // // //
// // // // // // // // // // //   /// 🔹 Curved Drawer Header
// // // // // // // // // // //   Widget _buildCurvedDrawerHeader() {
// // // // // // // // // // //     return Container(
// // // // // // // // // // //       decoration: const BoxDecoration(
// // // // // // // // // // //         color: Colors.cyan,
// // // // // // // // // // //         borderRadius: BorderRadius.only(
// // // // // // // // // // //           bottomLeft: Radius.circular(35),
// // // // // // // // // // //           bottomRight: Radius.circular(35),
// // // // // // // // // // //         ),
// // // // // // // // // // //       ),
// // // // // // // // // // //       height: 150,
// // // // // // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // // // // // //       child: Row(
// // // // // // // // // // //         children: [
// // // // // // // // // // //           CircleAvatar(
// // // // // // // // // // //             radius: 25,
// // // // // // // // // // //             backgroundImage: orgImage != null
// // // // // // // // // // //                 ? NetworkImage(orgImage!)
// // // // // // // // // // //                 : const AssetImage('assets/favicon.png') as ImageProvider,
// // // // // // // // // // //           ),
// // // // // // // // // // //           const SizedBox(width: 10),
// // // // // // // // // // //           Expanded(
// // // // // // // // // // //             child: Text(
// // // // // // // // // // //               orgName,
// // // // // // // // // // //               overflow: TextOverflow.ellipsis,
// // // // // // // // // // //               style: GoogleFonts.poppins(
// // // // // // // // // // //                 textStyle: const TextStyle(color: Colors.white, fontSize: 20),
// // // // // // // // // // //               ),
// // // // // // // // // // //             ),
// // // // // // // // // // //           ),
// // // // // // // // // // //           if (role == 'admin') NotificationIconDropdown(),
// // // // // // // // // // //         ],
// // // // // // // // // // //       ),
// // // // // // // // // // //     );
// // // // // // // // // // //   }
// // // // // // // // // // //
// // // // // // // // // // //   /// 🔹 Sidebar Items
// // // // // // // // // // //   List<Widget> _buildSidebarItems(BuildContext context) {
// // // // // // // // // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // // // // // // // // //     final provider = Provider.of<SidebarProvider>(context);
// // // // // // // // // // //
// // // // // // // // // // //     return sidebarController.sidebarItems.map((item) {
// // // // // // // // // // //       final key = item['key'];
// // // // // // // // // // //       final label = item['label'];
// // // // // // // // // // //       final icon = _getIconFromString(item['icon'] ?? 'home');
// // // // // // // // // // //
// // // // // // // // // // //       final isSelected = provider.selectedKey == key;
// // // // // // // // // // //       final color = isSelected ? Colors.cyan : Colors.black;
// // // // // // // // // // //       final fontWeight = isSelected ? FontWeight.bold : FontWeight.normal;
// // // // // // // // // // //
// // // // // // // // // // //       return ListTile(
// // // // // // // // // // //         leading: Icon(icon, color: color),
// // // // // // // // // // //         title: Text(
// // // // // // // // // // //           label,
// // // // // // // // // // //           style: TextStyle(color: color, fontWeight: fontWeight),
// // // // // // // // // // //         ),
// // // // // // // // // // //         onTap: () {
// // // // // // // // // // //           provider.selectItem(key);
// // // // // // // // // // //           setState(() {}); // refresh UI
// // // // // // // // // // //         },
// // // // // // // // // // //       );
// // // // // // // // // // //     }).toList();
// // // // // // // // // // //   }
// // // // // // // // // // //
// // // // // // // // // // //   /// 🔹 Icon Mapper
// // // // // // // // // // //   IconData _getIconFromString(String iconName) {
// // // // // // // // // // //     switch (iconName.toLowerCase()) {
// // // // // // // // // // //       case 'home':
// // // // // // // // // // //         return Icons.home;
// // // // // // // // // // //       case 'events':
// // // // // // // // // // //         return Icons.event;
// // // // // // // // // // //       case 'sermons':
// // // // // // // // // // //         return Icons.menu_book;
// // // // // // // // // // //       case 'giving':
// // // // // // // // // // //         return Icons.card_giftcard;
// // // // // // // // // // //       case 'apps':
// // // // // // // // // // //         return Icons.apps;
// // // // // // // // // // //       case 'user':
// // // // // // // // // // //         return Icons.person;
// // // // // // // // // // //       case 'organization':
// // // // // // // // // // //         return Icons.business;
// // // // // // // // // // //       case 'applications':
// // // // // // // // // // //         return Icons.assignment;
// // // // // // // // // // //       case 'pushnotification':
// // // // // // // // // // //         return Icons.notifications_active;
// // // // // // // // // // //       case 'profile':
// // // // // // // // // // //         return Icons.account_circle;
// // // // // // // // // // //       case 'notification':
// // // // // // // // // // //         return Icons.notifications;
// // // // // // // // // // //       default:
// // // // // // // // // // //         return Icons.circle;
// // // // // // // // // // //     }
// // // // // // // // // // //   }
// // // // // // // // // // //
// // // // // // // // // // //   /// 🔹 Page Content
// // // // // // // // // // //   Widget _getContent(String? key) {
// // // // // // // // // // //     switch (key) {
// // // // // // // // // // //       case 'home':
// // // // // // // // // // //         return const HomePage();
// // // // // // // // // // //       case 'events':
// // // // // // // // // // //         return const Events();
// // // // // // // // // // //       case 'sermons':
// // // // // // // // // // //         return const Sermons();
// // // // // // // // // // //       case 'giving':
// // // // // // // // // // //         return const Giving();
// // // // // // // // // // //       case 'apps':
// // // // // // // // // // //         return const Apps();
// // // // // // // // // // //       case 'user':
// // // // // // // // // // //         return const UserPage();
// // // // // // // // // // //       case 'organization':
// // // // // // // // // // //         return const Organization();
// // // // // // // // // // //       case 'applications':
// // // // // // // // // // //         return const ApplicationPage();
// // // // // // // // // // //       case 'pushnotification':
// // // // // // // // // // //         return const PushNotification();
// // // // // // // // // // //       case 'profile':
// // // // // // // // // // //         return const Profile();
// // // // // // // // // // //       case 'notification':
// // // // // // // // // // //         return const NotificationPage();
// // // // // // // // // // //       default:
// // // // // // // // // // //         return const Center(child: Text("Page not found"));
// // // // // // // // // // //     }
// // // // // // // // // // //   }
// // // // // // // // // // //
// // // // // // // // // // //   /// 🔹 Logout Section
// // // // // // // // // // //   Widget _buildLogoutSection() {
// // // // // // // // // // //     return Container(
// // // // // // // // // // //       decoration: BoxDecoration(
// // // // // // // // // // //         color: Colors.cyan.shade300,
// // // // // // // // // // //         borderRadius: const BorderRadius.only(
// // // // // // // // // // //           topLeft: Radius.circular(15),
// // // // // // // // // // //           topRight: Radius.circular(15),
// // // // // // // // // // //         ),
// // // // // // // // // // //       ),
// // // // // // // // // // //       width: double.infinity,
// // // // // // // // // // //       padding: const EdgeInsets.all(8),
// // // // // // // // // // //       child: const LogoutButton(),
// // // // // // // // // // //     );
// // // // // // // // // // //   }
// // // // // // // // // // // }
// // // // // // // // // //
// // // // // // // // // //
// // // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // // // // // // import 'package:iconsax/iconsax.dart';
// // // // // // // // // // import 'package:provider/provider.dart';
// // // // // // // // // // import '../Controller/Sidebar_controller.dart';
// // // // // // // // // // import '../View_model/Sidebar_provider.dart';
// // // // // // // // // // import '../View_model/Logout.dart';
// // // // // // // // // //
// // // // // // // // // // // Pages
// // // // // // // // // // import '../View_model/side_navbar_drawer.dart';
// // // // // // // // // // import 'Application_page.dart';
// // // // // // // // // // import 'Apps_page/Apps.dart';
// // // // // // // // // // import 'Apps_page/Push_Notifications.dart';
// // // // // // // // // // import 'Events.dart';
// // // // // // // // // // import 'Giving.dart';
// // // // // // // // // // import 'Home_page.dart';
// // // // // // // // // // import 'Notifications/Notification_page.dart';
// // // // // // // // // // import 'Organization.dart';
// // // // // // // // // // import 'Profile_page.dart';
// // // // // // // // // // import 'Pushnotification.dart';
// // // // // // // // // // import 'Sermons.dart';
// // // // // // // // // // import 'User.dart';
// // // // // // // // // // import 'Notifications/notification_bell.dart';
// // // // // // // // // //
// // // // // // // // // // class MainLayout extends StatefulWidget {
// // // // // // // // // //   const MainLayout({Key? key}) : super(key: key);
// // // // // // // // // //
// // // // // // // // // //   @override
// // // // // // // // // //   _MainLayoutState createState() => _MainLayoutState();
// // // // // // // // // // }
// // // // // // // // // //
// // // // // // // // // // class _MainLayoutState extends State<MainLayout> {
// // // // // // // // // //   String orgName = "Ancil Media";
// // // // // // // // // //   String? orgImage;
// // // // // // // // // //   String role = "user"; // ← replace with actual role from profile API
// // // // // // // // // //
// // // // // // // // // //   @override
// // // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // // // // // // // //     final provider = Provider.of<SidebarProvider>(context);
// // // // // // // // // //
// // // // // // // // // //     final selectedKey = provider.selectedKey ??
// // // // // // // // // //         (sidebarController.sidebarItems.isNotEmpty
// // // // // // // // // //             ? sidebarController.sidebarItems.first['key']
// // // // // // // // // //             : null);
// // // // // // // // // //
// // // // // // // // // //     final selectedLabel = sidebarController.sidebarItems
// // // // // // // // // //         .firstWhere(
// // // // // // // // // //           (item) => item['key'] == selectedKey,
// // // // // // // // // //       orElse: () => {'label': 'Ancil Media'},
// // // // // // // // // //     )['label'];
// // // // // // // // // //
// // // // // // // // // //     final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
// // // // // // // // // //
// // // // // // // // // //     return Scaffold(
// // // // // // // // // //       appBar: isDesktop
// // // // // // // // // //           ? null
// // // // // // // // // //           : AppBar(
// // // // // // // // // //         title: Text(
// // // // // // // // // //           selectedLabel,
// // // // // // // // // //           style: GoogleFonts.poppins(
// // // // // // // // // //             textStyle: const TextStyle(color: Colors.black),
// // // // // // // // // //           ),
// // // // // // // // // //         ),
// // // // // // // // // //         backgroundColor: Colors.white,
// // // // // // // // // //         foregroundColor: Colors.black,
// // // // // // // // // //         elevation: 1,
// // // // // // // // // //       ),
// // // // // // // // // //       body: Row(
// // // // // // // // // //         children: [
// // // // // // // // // //           /// 🔹 Sidebar
// // // // // // // // // //           if (isDesktop)
// // // // // // // // // //             ClipRRect(
// // // // // // // // // //               borderRadius: const BorderRadius.only(
// // // // // // // // // //                 topRight: Radius.circular(30),
// // // // // // // // // //                 bottomRight: Radius.circular(30),
// // // // // // // // // //               ),
// // // // // // // // // //               child: Container(
// // // // // // // // // //                 width: MediaQuery.of(context).size.width * .18,
// // // // // // // // // //                 color: Colors.grey.shade100,
// // // // // // // // // //                 child: Column(
// // // // // // // // // //                   children: [
// // // // // // // // // //                     _buildCurvedDrawerHeader(),
// // // // // // // // // //                     Expanded(
// // // // // // // // // //                       child: sidebarController.isLoading
// // // // // // // // // //                           ? const Center(child: CircularProgressIndicator())
// // // // // // // // // //                           : ListView(
// // // // // // // // // //                         children: _buildSidebarItems(context),
// // // // // // // // // //                       ),
// // // // // // // // // //                     ),
// // // // // // // // // //                     _buildLogoutSection(),
// // // // // // // // // //                   ],
// // // // // // // // // //                 ),
// // // // // // // // // //               ),
// // // // // // // // // //             ),
// // // // // // // // // //
// // // // // // // // // //           /// 🔹 Page Content
// // // // // // // // // //           Expanded(child: _getContent(selectedKey)),
// // // // // // // // // //         ],
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }
// // // // // // // // // //
// // // // // // // // // //   /// 🔹 Curved Drawer Header
// // // // // // // // // //   Widget _buildCurvedDrawerHeader() {
// // // // // // // // // //     return Container(
// // // // // // // // // //       decoration: const BoxDecoration(
// // // // // // // // // //         color: Colors.cyan,
// // // // // // // // // //         borderRadius: BorderRadius.only(
// // // // // // // // // //           bottomLeft: Radius.circular(35),
// // // // // // // // // //           bottomRight: Radius.circular(35),
// // // // // // // // // //         ),
// // // // // // // // // //       ),
// // // // // // // // // //       height: 150,
// // // // // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // // // // //       child: Row(
// // // // // // // // // //         children: [
// // // // // // // // // //           CircleAvatar(
// // // // // // // // // //             radius: 25,
// // // // // // // // // //             backgroundImage: orgImage != null
// // // // // // // // // //                 ? NetworkImage(orgImage!)
// // // // // // // // // //                 : const AssetImage('assets/favicon.png') as ImageProvider,
// // // // // // // // // //           ),
// // // // // // // // // //           const SizedBox(width: 10),
// // // // // // // // // //           Expanded(
// // // // // // // // // //             child: Text(
// // // // // // // // // //               orgName,
// // // // // // // // // //               overflow: TextOverflow.ellipsis,
// // // // // // // // // //               style: GoogleFonts.poppins(
// // // // // // // // // //                 textStyle: const TextStyle(color: Colors.white, fontSize: 20),
// // // // // // // // // //               ),
// // // // // // // // // //             ),
// // // // // // // // // //           ),
// // // // // // // // // //           if (role == 'admin') NotificationIconDropdown(),
// // // // // // // // // //         ],
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }
// // // // // // // // // //
// // // // // // // // // //   /// 🔹 Sidebar Items
// // // // // // // // // //   List<Widget> _buildSidebarItems(BuildContext context) {
// // // // // // // // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // // // // // // // //     final provider = Provider.of<SidebarProvider>(context);
// // // // // // // // // //
// // // // // // // // // //     return sidebarController.sidebarItems.map((item) {
// // // // // // // // // //       final key = item['key'];
// // // // // // // // // //       final label = item['label'];
// // // // // // // // // //       final icon = _getIconFromString(item['icon'] ?? 'home');
// // // // // // // // // //
// // // // // // // // // //       return ListTile(
// // // // // // // // // //         leading: Icon(icon, color: Colors.black),
// // // // // // // // // //         title: Text(label, style: const TextStyle(color: Colors.black)),
// // // // // // // // // //         onTap: () {
// // // // // // // // // //           // ✅ Check if page needs its own sidebar
// // // // // // // // // //           if (_pageHasSidebar(key)) {
// // // // // // // // // //             Navigator.push(
// // // // // // // // // //               context,
// // // // // // // // // //               MaterialPageRoute(builder: (_) => _getContent(key)),
// // // // // // // // // //             );
// // // // // // // // // //           } else {
// // // // // // // // // //             provider.selectItem(key);
// // // // // // // // // //             setState(() {});
// // // // // // // // // //           }
// // // // // // // // // //         },
// // // // // // // // // //       );
// // // // // // // // // //     }).toList();
// // // // // // // // // //   }
// // // // // // // // // //
// // // // // // // // // //   /// 🔹 Decide if page should hide parent sidebar
// // // // // // // // // //   bool _pageHasSidebar(String key) {
// // // // // // // // // //     // Add keys of pages that already contain their own sidebar
// // // // // // // // // //     return [
// // // // // // // // // //       'apps',
// // // // // // // // // //       'applications',
// // // // // // // // // //       'pushnotification',
// // // // // // // // // //     ].contains(key.toLowerCase());
// // // // // // // // // //   }
// // // // // // // // // //
// // // // // // // // // //   /// 🔹 Icon Mapper
// // // // // // // // // //   /// 🔹 Map string icon name to Iconsax
// // // // // // // // // //   IconData _getIconFromString(String icon) {
// // // // // // // // // //     switch (icon) {
// // // // // // // // // //       case 'home':
// // // // // // // // // //         return Iconsax.home;
// // // // // // // // // //       case 'events':
// // // // // // // // // //         return Iconsax.book;
// // // // // // // // // //       case 'sermons':
// // // // // // // // // //         return Iconsax.safe_home;
// // // // // // // // // //       case 'giving':
// // // // // // // // // //         return Iconsax.wallet_money;
// // // // // // // // // //       case 'apps':
// // // // // // // // // //         return Iconsax.element_3;
// // // // // // // // // //       case 'user':
// // // // // // // // // //         return Iconsax.profile_2user;
// // // // // // // // // //       case 'organization':
// // // // // // // // // //         return Iconsax.building;
// // // // // // // // // //       case 'applications':
// // // // // // // // // //         return Iconsax.box_2;
// // // // // // // // // //       case 'pushnotification':
// // // // // // // // // //         return Iconsax.notification_bing;
// // // // // // // // // //       case 'notification':
// // // // // // // // // //         return Iconsax.message_text;
// // // // // // // // // //       case 'profile':
// // // // // // // // // //         return Iconsax.profile_circle;
// // // // // // // // // //       default:
// // // // // // // // // //         return Iconsax.home;
// // // // // // // // // //     }
// // // // // // // // // //   }
// // // // // // // // // //   /// 🔹 Page Router
// // // // // // // // // //   Widget _getContent(String? key) {
// // // // // // // // // //     switch (key) {
// // // // // // // // // //       case 'home':
// // // // // // // // // //         return const HomePage();
// // // // // // // // // //       case 'events':
// // // // // // // // // //         return const Events();
// // // // // // // // // //       case 'sermons':
// // // // // // // // // //         return const Sermons();
// // // // // // // // // //       case 'giving':
// // // // // // // // // //         return const Giving();
// // // // // // // // // //       case 'apps':
// // // // // // // // // //         return const Apps();
// // // // // // // // // //       case 'user':
// // // // // // // // // //         return const UserPage();
// // // // // // // // // //       case 'organization':
// // // // // // // // // //         return const Organization();
// // // // // // // // // //       case 'applications':
// // // // // // // // // //         return const ApplicationPage();
// // // // // // // // // //       case 'pushnotification':
// // // // // // // // // //         return const PushNotification();
// // // // // // // // // //       case 'profile':
// // // // // // // // // //         return const Profile();
// // // // // // // // // //       case 'notification':
// // // // // // // // // //         return const NotificationPage();
// // // // // // // // // //       default:
// // // // // // // // // //         return const Center(child: Text("Page not found"));
// // // // // // // // // //     }
// // // // // // // // // //   }
// // // // // // // // // //
// // // // // // // // // //   /// 🔹 Logout Section
// // // // // // // // // //   Widget _buildLogoutSection() {
// // // // // // // // // //     return Container(
// // // // // // // // // //       decoration: BoxDecoration(
// // // // // // // // // //         color: Colors.cyan.shade300,
// // // // // // // // // //         borderRadius: const BorderRadius.only(
// // // // // // // // // //           topLeft: Radius.circular(15),
// // // // // // // // // //           topRight: Radius.circular(15),
// // // // // // // // // //         ),
// // // // // // // // // //       ),
// // // // // // // // // //       width: double.infinity,
// // // // // // // // // //       padding: const EdgeInsets.all(8),
// // // // // // // // // //       child: const LogoutButton(),
// // // // // // // // // //     );
// // // // // // // // // //   }
// // // // // // // // // // }
// // // // // // // // //
// // // // // // // // //
// // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // // // // // import 'package:provider/provider.dart';
// // // // // // // // // import '../Controller/Sidebar_controller.dart';
// // // // // // // // // import '../View_model/Sidebar_provider.dart';
// // // // // // // // // import '../View_model/Logout.dart';
// // // // // // // // //
// // // // // // // // // // Pages
// // // // // // // // // import '../View_model/side_navbar_drawer.dart';
// // // // // // // // // import 'Application_page.dart';
// // // // // // // // // import 'Apps_page/Apps.dart';
// // // // // // // // // import 'Apps_page/Push_Notifications.dart';
// // // // // // // // // import 'Events.dart';
// // // // // // // // // import 'Giving.dart';
// // // // // // // // // import 'Home_page.dart';
// // // // // // // // // import 'Notifications/Notification_page.dart';
// // // // // // // // // import 'Organization.dart';
// // // // // // // // // import 'Profile_page.dart';
// // // // // // // // // import 'Pushnotification.dart';
// // // // // // // // // import 'Sermons.dart';
// // // // // // // // // import 'User.dart';
// // // // // // // // // import 'Notifications/notification_bell.dart';
// // // // // // // // //
// // // // // // // // // class MainLayout extends StatefulWidget {
// // // // // // // // //   final Widget? child; // ✅ allow passing custom child page
// // // // // // // // //
// // // // // // // // //   const MainLayout({Key? key, this.child}) : super(key: key);
// // // // // // // // //
// // // // // // // // //   @override
// // // // // // // // //   _MainLayoutState createState() => _MainLayoutState();
// // // // // // // // // }
// // // // // // // // //
// // // // // // // // // class _MainLayoutState extends State<MainLayout> {
// // // // // // // // //   String orgName = "Ancil Media";
// // // // // // // // //   String? orgImage;
// // // // // // // // //   String role = "user"; // ← replace with actual role from profile API
// // // // // // // // //
// // // // // // // // //   @override
// // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // // // // // // //     final provider = Provider.of<SidebarProvider>(context);
// // // // // // // // //
// // // // // // // // //     final selectedKey = provider.selectedKey ??
// // // // // // // // //         (sidebarController.sidebarItems.isNotEmpty
// // // // // // // // //             ? sidebarController.sidebarItems.first['key']
// // // // // // // // //             : null);
// // // // // // // // //
// // // // // // // // //     final selectedLabel = sidebarController.sidebarItems
// // // // // // // // //         .firstWhere(
// // // // // // // // //           (item) => item['key'] == selectedKey,
// // // // // // // // //       orElse: () => {'label': 'Ancil Media'},
// // // // // // // // //     )['label'];
// // // // // // // // //
// // // // // // // // //     final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
// // // // // // // // //
// // // // // // // // //     /// ✅ If widget.child is provided, show it directly (no sidebar)
// // // // // // // // //     if (widget.child != null) {
// // // // // // // // //       return Scaffold(
// // // // // // // // //         appBar: AppBar(
// // // // // // // // //           title: Text(
// // // // // // // // //             selectedLabel,
// // // // // // // // //             style: GoogleFonts.poppins(
// // // // // // // // //               textStyle: const TextStyle(color: Colors.black),
// // // // // // // // //             ),
// // // // // // // // //           ),
// // // // // // // // //           backgroundColor: Colors.white,
// // // // // // // // //           foregroundColor: Colors.black,
// // // // // // // // //           elevation: 1,
// // // // // // // // //         ),
// // // // // // // // //         body: widget.child!,
// // // // // // // // //       );
// // // // // // // // //     }
// // // // // // // // //
// // // // // // // // //     /// ✅ Otherwise, show the sidebar layout
// // // // // // // // //     return Scaffold(
// // // // // // // // //       appBar: isDesktop
// // // // // // // // //           ? null
// // // // // // // // //           : AppBar(
// // // // // // // // //         title: Text(
// // // // // // // // //           selectedLabel,
// // // // // // // // //           style: GoogleFonts.poppins(
// // // // // // // // //             textStyle: const TextStyle(color: Colors.black),
// // // // // // // // //           ),
// // // // // // // // //         ),
// // // // // // // // //         backgroundColor: Colors.white,
// // // // // // // // //         foregroundColor: Colors.black,
// // // // // // // // //         elevation: 1,
// // // // // // // // //       ),
// // // // // // // // //       body: Row(
// // // // // // // // //         children: [
// // // // // // // // //           /// 🔹 Sidebar
// // // // // // // // //           if (isDesktop)
// // // // // // // // //             ClipRRect(
// // // // // // // // //               borderRadius: const BorderRadius.only(
// // // // // // // // //                 topRight: Radius.circular(30),
// // // // // // // // //                 bottomRight: Radius.circular(30),
// // // // // // // // //               ),
// // // // // // // // //               child: Container(
// // // // // // // // //                 width: MediaQuery.of(context).size.width * .18,
// // // // // // // // //                 color: Colors.grey.shade100,
// // // // // // // // //                 child: Column(
// // // // // // // // //                   children: [
// // // // // // // // //                     _buildCurvedDrawerHeader(),
// // // // // // // // //                     Expanded(
// // // // // // // // //                       child: sidebarController.isLoading
// // // // // // // // //                           ? const Center(child: CircularProgressIndicator())
// // // // // // // // //                           : ListView(
// // // // // // // // //                         children: _buildSidebarItems(context),
// // // // // // // // //                       ),
// // // // // // // // //                     ),
// // // // // // // // //                     _buildLogoutSection(),
// // // // // // // // //                   ],
// // // // // // // // //                 ),
// // // // // // // // //               ),
// // // // // // // // //             ),
// // // // // // // // //
// // // // // // // // //           /// 🔹 Page Content
// // // // // // // // //           Expanded(child: _getContent(selectedKey)),
// // // // // // // // //         ],
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   /// 🔹 Curved Drawer Header
// // // // // // // // //   Widget _buildCurvedDrawerHeader() {
// // // // // // // // //     return Container(
// // // // // // // // //       decoration: const BoxDecoration(
// // // // // // // // //         color: Colors.cyan,
// // // // // // // // //         borderRadius: BorderRadius.only(
// // // // // // // // //           bottomLeft: Radius.circular(35),
// // // // // // // // //           bottomRight: Radius.circular(35),
// // // // // // // // //         ),
// // // // // // // // //       ),
// // // // // // // // //       height: 150,
// // // // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // // // //       child: Row(
// // // // // // // // //         children: [
// // // // // // // // //           CircleAvatar(
// // // // // // // // //             radius: 25,
// // // // // // // // //             backgroundImage: orgImage != null
// // // // // // // // //                 ? NetworkImage(orgImage!)
// // // // // // // // //                 : const AssetImage('assets/favicon.png') as ImageProvider,
// // // // // // // // //           ),
// // // // // // // // //           const SizedBox(width: 10),
// // // // // // // // //           Expanded(
// // // // // // // // //             child: Text(
// // // // // // // // //               orgName,
// // // // // // // // //               overflow: TextOverflow.ellipsis,
// // // // // // // // //               style: GoogleFonts.poppins(
// // // // // // // // //                 textStyle: const TextStyle(color: Colors.white, fontSize: 20),
// // // // // // // // //               ),
// // // // // // // // //             ),
// // // // // // // // //           ),
// // // // // // // // //           if (role == 'admin') NotificationIconDropdown(),
// // // // // // // // //         ],
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   /// 🔹 Sidebar Items
// // // // // // // // //   List<Widget> _buildSidebarItems(BuildContext context) {
// // // // // // // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // // // // // // //     final provider = Provider.of<SidebarProvider>(context);
// // // // // // // // //
// // // // // // // // //     return sidebarController.sidebarItems.map((item) {
// // // // // // // // //       final key = item['key'];
// // // // // // // // //       final label = item['label'];
// // // // // // // // //       final icon = _getIconFromString(item['icon'] ?? 'home');
// // // // // // // // //
// // // // // // // // //       final isSelected = provider.selectedKey == key;
// // // // // // // // //       final color = isSelected ? Colors.cyan : Colors.black;
// // // // // // // // //       final fontWeight = isSelected ? FontWeight.bold : FontWeight.normal;
// // // // // // // // //
// // // // // // // // //       return ListTile(
// // // // // // // // //         leading: Icon(icon, color: color),
// // // // // // // // //         title: Text(
// // // // // // // // //           label,
// // // // // // // // //           style: TextStyle(color: color, fontWeight: fontWeight),
// // // // // // // // //         ),
// // // // // // // // //         onTap: () {
// // // // // // // // //           provider.selectItem(key);
// // // // // // // // //           setState(() {}); // refresh UI
// // // // // // // // //         },
// // // // // // // // //       );
// // // // // // // // //     }).toList();
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   /// 🔹 Icon Mapper
// // // // // // // // //   IconData _getIconFromString(String iconName) {
// // // // // // // // //     switch (iconName.toLowerCase()) {
// // // // // // // // //       case 'home':
// // // // // // // // //         return Icons.home;
// // // // // // // // //       case 'events':
// // // // // // // // //         return Icons.event;
// // // // // // // // //       case 'sermons':
// // // // // // // // //         return Icons.menu_book;
// // // // // // // // //       case 'giving':
// // // // // // // // //         return Icons.card_giftcard;
// // // // // // // // //       case 'apps':
// // // // // // // // //         return Icons.apps;
// // // // // // // // //       case 'user':
// // // // // // // // //         return Icons.person;
// // // // // // // // //       case 'organization':
// // // // // // // // //         return Icons.business;
// // // // // // // // //       case 'applications':
// // // // // // // // //         return Icons.assignment;
// // // // // // // // //       case 'pushnotification':
// // // // // // // // //         return Icons.notifications_active;
// // // // // // // // //       case 'profile':
// // // // // // // // //         return Icons.account_circle;
// // // // // // // // //       case 'notification':
// // // // // // // // //         return Icons.notifications;
// // // // // // // // //       default:
// // // // // // // // //         return Icons.circle;
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   /// 🔹 Page Content
// // // // // // // // //   Widget _getContent(String? key) {
// // // // // // // // //     switch (key) {
// // // // // // // // //       case 'home':
// // // // // // // // //         return const HomePage();
// // // // // // // // //       case 'events':
// // // // // // // // //         return const Events();
// // // // // // // // //       case 'sermons':
// // // // // // // // //         return const Sermons();
// // // // // // // // //       case 'giving':
// // // // // // // // //         return const Giving();
// // // // // // // // //       case 'apps':
// // // // // // // // //         return const Apps();
// // // // // // // // //       case 'user':
// // // // // // // // //         return const UserPage();
// // // // // // // // //       case 'organization':
// // // // // // // // //         return const Organization();
// // // // // // // // //       case 'applications':
// // // // // // // // //         return const ApplicationPage();
// // // // // // // // //       case 'pushnotification':
// // // // // // // // //         return const PushNotification(); // ✅ will be inside sidebar
// // // // // // // // //       case 'profile':
// // // // // // // // //         return const Profile();
// // // // // // // // //       case 'notification':
// // // // // // // // //         return const NotificationPage();
// // // // // // // // //       default:
// // // // // // // // //         return const Center(child: Text("Page not found"));
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   /// 🔹 Logout Section
// // // // // // // // //   Widget _buildLogoutSection() {
// // // // // // // // //     return Container(
// // // // // // // // //       decoration: BoxDecoration(
// // // // // // // // //         color: Colors.cyan.shade300,
// // // // // // // // //         borderRadius: const BorderRadius.only(
// // // // // // // // //           topLeft: Radius.circular(15),
// // // // // // // // //           topRight: Radius.circular(15),
// // // // // // // // //         ),
// // // // // // // // //       ),
// // // // // // // // //       width: double.infinity,
// // // // // // // // //       padding: const EdgeInsets.all(8),
// // // // // // // // //       child: const LogoutButton(),
// // // // // // // // //     );
// // // // // // // // //   }
// // // // // // // // // }
// // // // // // // //
// // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // // // // import 'package:provider/provider.dart';
// // // // // // // // import '../Controller/Sidebar_controller.dart';
// // // // // // // // import '../View_model/Sidebar_provider.dart';
// // // // // // // // import '../View_model/Logout.dart';
// // // // // // // //
// // // // // // // // // Pages
// // // // // // // // import '../View_model/side_navbar_drawer.dart';
// // // // // // // // import 'Application_page.dart';
// // // // // // // // import 'Apps_page/Apps.dart';
// // // // // // // // import 'Apps_page/Push_Notifications.dart';
// // // // // // // // import 'Events.dart';
// // // // // // // // import 'Giving.dart';
// // // // // // // // import 'Home_page.dart';
// // // // // // // // import 'Notifications/Notification_page.dart';
// // // // // // // // import 'Organization.dart';
// // // // // // // // import 'Profile_page.dart';
// // // // // // // // import 'Pushnotification.dart';
// // // // // // // // import 'Sermons.dart';
// // // // // // // // import 'User.dart';
// // // // // // // // import 'Notifications/notification_bell.dart';
// // // // // // // //
// // // // // // // // class MainLayout extends StatefulWidget {
// // // // // // // //   const MainLayout({Key? key}) : super(key: key);
// // // // // // // //
// // // // // // // //   @override
// // // // // // // //   _MainLayoutState createState() => _MainLayoutState();
// // // // // // // // }
// // // // // // // //
// // // // // // // // class _MainLayoutState extends State<MainLayout> {
// // // // // // // //   String orgName = "Ancil Media";
// // // // // // // //   String? orgImage;
// // // // // // // //   String role = "user"; // ← replace with actual role from profile API
// // // // // // // //
// // // // // // // //   @override
// // // // // // // //   Widget build(BuildContext context) {
// // // // // // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // // // // // //     final provider = Provider.of<SidebarProvider>(context);
// // // // // // // //
// // // // // // // //     final selectedKey = provider.selectedKey ??
// // // // // // // //         (sidebarController.sidebarItems.isNotEmpty
// // // // // // // //             ? sidebarController.sidebarItems.first['key']
// // // // // // // //             : null);
// // // // // // // //
// // // // // // // //     final selectedLabel = sidebarController.sidebarItems
// // // // // // // //         .firstWhere(
// // // // // // // //           (item) => item['key'] == selectedKey,
// // // // // // // //       orElse: () => {'label': 'Ancil Media'},
// // // // // // // //     )['label'];
// // // // // // // //
// // // // // // // //     final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
// // // // // // // //
// // // // // // // //     return Scaffold(
// // // // // // // //       appBar: isDesktop
// // // // // // // //           ? null
// // // // // // // //           : AppBar(
// // // // // // // //         title: Text(
// // // // // // // //           selectedLabel,
// // // // // // // //           style: GoogleFonts.poppins(
// // // // // // // //             textStyle: const TextStyle(color: Colors.black),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //         backgroundColor: Colors.white,
// // // // // // // //         foregroundColor: Colors.black,
// // // // // // // //         elevation: 1,
// // // // // // // //       ),
// // // // // // // //       body: Row(
// // // // // // // //         children: [
// // // // // // // //           /// 🔹 Sidebar (hide when going to Apps which has its own sub-sidebar)
// // // // // // // //           if (isDesktop && selectedKey != "apps")
// // // // // // // //             ClipRRect(
// // // // // // // //               borderRadius: const BorderRadius.only(
// // // // // // // //                 topRight: Radius.circular(30),
// // // // // // // //                 bottomRight: Radius.circular(30),
// // // // // // // //               ),
// // // // // // // //               child: Container(
// // // // // // // //                 width: MediaQuery.of(context).size.width * .18,
// // // // // // // //                 color: Colors.grey.shade100,
// // // // // // // //                 child: Column(
// // // // // // // //                   children: [
// // // // // // // //                     _buildCurvedDrawerHeader(),
// // // // // // // //                     Expanded(
// // // // // // // //                       child: sidebarController.isLoading
// // // // // // // //                           ? const Center(child: CircularProgressIndicator())
// // // // // // // //                           : ListView(
// // // // // // // //                         children: _buildSidebarItems(context),
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                     _buildLogoutSection(),
// // // // // // // //                   ],
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //
// // // // // // // //           /// 🔹 Page Content
// // // // // // // //           Expanded(child: _getContent(selectedKey)),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   /// 🔹 Curved Drawer Header
// // // // // // // //   Widget _buildCurvedDrawerHeader() {
// // // // // // // //     return Container(
// // // // // // // //       decoration: const BoxDecoration(
// // // // // // // //         color: Colors.cyan,
// // // // // // // //         borderRadius: BorderRadius.only(
// // // // // // // //           bottomLeft: Radius.circular(35),
// // // // // // // //           bottomRight: Radius.circular(35),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //       height: 150,
// // // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // // //       child: Row(
// // // // // // // //         children: [
// // // // // // // //           CircleAvatar(
// // // // // // // //             radius: 25,
// // // // // // // //             backgroundImage: orgImage != null
// // // // // // // //                 ? NetworkImage(orgImage!)
// // // // // // // //                 : const AssetImage('assets/favicon.png') as ImageProvider,
// // // // // // // //           ),
// // // // // // // //           const SizedBox(width: 10),
// // // // // // // //           Expanded(
// // // // // // // //             child: Text(
// // // // // // // //               orgName,
// // // // // // // //               overflow: TextOverflow.ellipsis,
// // // // // // // //               style: GoogleFonts.poppins(
// // // // // // // //                 textStyle: const TextStyle(color: Colors.white, fontSize: 20),
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //           if (role == 'admin') NotificationIconDropdown(),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   /// 🔹 Sidebar Items
// // // // // // // //   List<Widget> _buildSidebarItems(BuildContext context) {
// // // // // // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // // // // // //     final provider = Provider.of<SidebarProvider>(context);
// // // // // // // //
// // // // // // // //     return sidebarController.sidebarItems.map((item) {
// // // // // // // //       final key = item['key'];
// // // // // // // //       final label = item['label'];
// // // // // // // //       final icon = _getIconFromString(item['icon'] ?? 'home');
// // // // // // // //
// // // // // // // //       final isSelected = provider.selectedKey == key;
// // // // // // // //       final color = isSelected ? Colors.cyan : Colors.black;
// // // // // // // //       final fontWeight = isSelected ? FontWeight.bold : FontWeight.normal;
// // // // // // // //
// // // // // // // //       return ListTile(
// // // // // // // //         leading: Icon(icon, color: color),
// // // // // // // //         title: Text(
// // // // // // // //           label,
// // // // // // // //           style: TextStyle(color: color, fontWeight: fontWeight),
// // // // // // // //         ),
// // // // // // // //         onTap: () {
// // // // // // // //           provider.selectItem(key);
// // // // // // // //           setState(() {}); // refresh UI
// // // // // // // //         },
// // // // // // // //       );
// // // // // // // //     }).toList();
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   /// 🔹 Icon Mapper
// // // // // // // //   IconData _getIconFromString(String iconName) {
// // // // // // // //     switch (iconName.toLowerCase()) {
// // // // // // // //       case 'home':
// // // // // // // //         return Icons.home;
// // // // // // // //       case 'events':
// // // // // // // //         return Icons.event;
// // // // // // // //       case 'sermons':
// // // // // // // //         return Icons.menu_book;
// // // // // // // //       case 'giving':
// // // // // // // //         return Icons.card_giftcard;
// // // // // // // //       case 'apps':
// // // // // // // //         return Icons.apps;
// // // // // // // //       case 'user':
// // // // // // // //         return Icons.person;
// // // // // // // //       case 'organization':
// // // // // // // //         return Icons.business;
// // // // // // // //       case 'applications':
// // // // // // // //         return Icons.assignment;
// // // // // // // //       case 'pushnotification':
// // // // // // // //         return Icons.notifications_active;
// // // // // // // //       case 'profile':
// // // // // // // //         return Icons.account_circle;
// // // // // // // //       case 'notification':
// // // // // // // //         return Icons.notifications;
// // // // // // // //       default:
// // // // // // // //         return Icons.circle;
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   /// 🔹 Page Content
// // // // // // // //   Widget _getContent(String? key) {
// // // // // // // //     switch (key) {
// // // // // // // //       case 'home':
// // // // // // // //         return const HomePage();
// // // // // // // //       case 'events':
// // // // // // // //         return const Events();
// // // // // // // //       case 'sermons':
// // // // // // // //         return const Sermons();
// // // // // // // //       case 'giving':
// // // // // // // //         return const Giving();
// // // // // // // //       case 'apps':
// // // // // // // //         return Apps(); // ✅ no const here
// // // // // // // //       case 'user':
// // // // // // // //         return const UserPage();
// // // // // // // //       case 'organization':
// // // // // // // //         return const Organization();
// // // // // // // //       case 'applications':
// // // // // // // //         return const ApplicationPage();
// // // // // // // //       case 'pushnotification':
// // // // // // // //         return const PushNotification();
// // // // // // // //       case 'profile':
// // // // // // // //         return const Profile();
// // // // // // // //       case 'notification':
// // // // // // // //         return const NotificationPage();
// // // // // // // //       default:
// // // // // // // //         return const Center(child: Text("Page not found"));
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   /// 🔹 Logout Section
// // // // // // // //   Widget _buildLogoutSection() {
// // // // // // // //     return Container(
// // // // // // // //       decoration: BoxDecoration(
// // // // // // // //         color: Colors.cyan.shade300,
// // // // // // // //         borderRadius: const BorderRadius.only(
// // // // // // // //           topLeft: Radius.circular(15),
// // // // // // // //           topRight: Radius.circular(15),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //       width: double.infinity,
// // // // // // // //       padding: const EdgeInsets.all(8),
// // // // // // // //       child: const LogoutButton(),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // // }
// // // // // // //
// // // // // // //
// // // // // // // import 'package:flutter/material.dart';
// // // // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // // // import 'package:provider/provider.dart';
// // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // //
// // // // // // // import '../Controller/Sidebar_controller.dart';
// // // // // // // import '../View_model/Sidebar_provider.dart';
// // // // // // // import '../View_model/Logout.dart';
// // // // // // //
// // // // // // // // Pages
// // // // // // // import '../View_model/side_navbar_drawer.dart';
// // // // // // // import 'Application_page.dart';
// // // // // // // import 'Apps_page/Apps.dart';
// // // // // // // import 'Apps_page/Push_Notifications.dart';
// // // // // // // import 'Events.dart';
// // // // // // // import 'Giving.dart';
// // // // // // // import 'Home_page.dart';
// // // // // // // import 'Notifications/Notification_page.dart';
// // // // // // // import 'Organization.dart';
// // // // // // // import 'Profile_page.dart';
// // // // // // // import 'Pushnotification.dart';
// // // // // // // import 'Sermons.dart';
// // // // // // // import 'User.dart';
// // // // // // // import 'Notifications/notification_bell.dart';
// // // // // // //
// // // // // // // class MainLayout extends StatefulWidget {
// // // // // // //   const MainLayout({Key? key}) : super(key: key);
// // // // // // //
// // // // // // //   @override
// // // // // // //   _MainLayoutState createState() => _MainLayoutState();
// // // // // // // }
// // // // // // //
// // // // // // // class _MainLayoutState extends State<MainLayout> {
// // // // // // //   String orgName = orgName;
// // // // // // //   String? orgImage;
// // // // // // //   String role = role; // ← will be updated from SharedPreferences
// // // // // // //
// // // // // // //   @override
// // // // // // //   void initState() {
// // // // // // //     super.initState();
// // // // // // //     _loadOrgData();
// // // // // // //   }
// // // // // // //
// // // // // // //   Future<void> _loadOrgData() async {
// // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // //     setState(() {
// // // // // // //       orgName = prefs.getString('orgName')!;
// // // // // // //       role = prefs.getString('role')!;
// // // // // // //     });
// // // // // // //   }
// // // // // // //
// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // // // // //     final provider = Provider.of<SidebarProvider>(context);
// // // // // // //
// // // // // // //     final selectedKey = provider.selectedKey ??
// // // // // // //         (sidebarController.sidebarItems.isNotEmpty
// // // // // // //             ? sidebarController.sidebarItems.first['key']
// // // // // // //             : null);
// // // // // // //
// // // // // // //     final selectedLabel = sidebarController.sidebarItems
// // // // // // //         .firstWhere(
// // // // // // //           (item) => item['key'] == selectedKey,
// // // // // // //       orElse: () => {'label': 'Ancil Media'},
// // // // // // //     )['label'];
// // // // // // //
// // // // // // //     final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
// // // // // // //
// // // // // // //     return Scaffold(
// // // // // // //       appBar: isDesktop
// // // // // // //           ? null
// // // // // // //           : AppBar(
// // // // // // //         title: Text(
// // // // // // //           selectedLabel,
// // // // // // //           style: GoogleFonts.poppins(
// // // // // // //             textStyle: const TextStyle(color: Colors.black),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //         backgroundColor: Colors.white,
// // // // // // //         foregroundColor: Colors.black,
// // // // // // //         elevation: 1,
// // // // // // //       ),
// // // // // // //       body: Row(
// // // // // // //         children: [
// // // // // // //           /// 🔹 Sidebar (hide when going to Apps which has its own sub-sidebar)
// // // // // // //           if (isDesktop && selectedKey != "apps")
// // // // // // //             ClipRRect(
// // // // // // //               borderRadius: const BorderRadius.only(
// // // // // // //                 topRight: Radius.circular(30),
// // // // // // //                 bottomRight: Radius.circular(30),
// // // // // // //               ),
// // // // // // //               child: Container(
// // // // // // //                 width: MediaQuery.of(context).size.width * .18,
// // // // // // //                 color: Colors.grey.shade100,
// // // // // // //                 child: Column(
// // // // // // //                   children: [
// // // // // // //                     _buildCurvedDrawerHeader(),
// // // // // // //                     Expanded(
// // // // // // //                       child: sidebarController.isLoading
// // // // // // //                           ? const Center(child: CircularProgressIndicator())
// // // // // // //                           : ListView(
// // // // // // //                         children: _buildSidebarItems(context),
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                     _buildLogoutSection(),
// // // // // // //                   ],
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //
// // // // // // //           /// 🔹 Page Content
// // // // // // //           Expanded(child: _getContent(selectedKey)),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   /// 🔹 Curved Drawer Header
// // // // // // //   Widget _buildCurvedDrawerHeader() {
// // // // // // //     return Container(
// // // // // // //       decoration: const BoxDecoration(
// // // // // // //         color: Colors.cyan,
// // // // // // //         borderRadius: BorderRadius.only(
// // // // // // //           bottomLeft: Radius.circular(35),
// // // // // // //           bottomRight: Radius.circular(35),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //       height: 150,
// // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // //       child: Row(
// // // // // // //         children: [
// // // // // // //           CircleAvatar(
// // // // // // //             radius: 25,
// // // // // // //             backgroundImage: orgImage != null
// // // // // // //                 ? NetworkImage(orgImage!)
// // // // // // //                 : const AssetImage('assets/favicon.png') as ImageProvider,
// // // // // // //           ),
// // // // // // //           const SizedBox(width: 10),
// // // // // // //           Expanded(
// // // // // // //             child: Text(
// // // // // // //               orgName,
// // // // // // //               overflow: TextOverflow.ellipsis,
// // // // // // //               style: GoogleFonts.poppins(
// // // // // // //                 textStyle: const TextStyle(color: Colors.white, fontSize: 20),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //           if (role == 'admin') NotificationIconDropdown(),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   /// 🔹 Sidebar Items
// // // // // // //   List<Widget> _buildSidebarItems(BuildContext context) {
// // // // // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // // // // //     final provider = Provider.of<SidebarProvider>(context);
// // // // // // //
// // // // // // //     return sidebarController.sidebarItems.map((item) {
// // // // // // //       final key = item['key'];
// // // // // // //       final label = item['label'];
// // // // // // //       final icon = _getIconFromString(item['icon'] ?? 'home');
// // // // // // //
// // // // // // //       final isSelected = provider.selectedKey == key;
// // // // // // //       final color = isSelected ? Colors.cyan : Colors.black;
// // // // // // //       final fontWeight = isSelected ? FontWeight.bold : FontWeight.normal;
// // // // // // //
// // // // // // //       return ListTile(
// // // // // // //         leading: Icon(icon, color: color),
// // // // // // //         title: Text(
// // // // // // //           label,
// // // // // // //           style: TextStyle(color: color, fontWeight: fontWeight),
// // // // // // //         ),
// // // // // // //         onTap: () {
// // // // // // //           provider.selectItem(key);
// // // // // // //           setState(() {}); // refresh UI
// // // // // // //         },
// // // // // // //       );
// // // // // // //     }).toList();
// // // // // // //   }
// // // // // // //
// // // // // // //   /// 🔹 Icon Mapper
// // // // // // //   IconData _getIconFromString(String iconName) {
// // // // // // //     switch (iconName.toLowerCase()) {
// // // // // // //       case 'home':
// // // // // // //         return Icons.home;
// // // // // // //       case 'events':
// // // // // // //         return Icons.event;
// // // // // // //       case 'sermons':
// // // // // // //         return Icons.menu_book;
// // // // // // //       case 'giving':
// // // // // // //         return Icons.card_giftcard;
// // // // // // //       case 'apps':
// // // // // // //         return Icons.apps;
// // // // // // //       case 'user':
// // // // // // //         return Icons.person;
// // // // // // //       case 'organization':
// // // // // // //         return Icons.business;
// // // // // // //       case 'applications':
// // // // // // //         return Icons.assignment;
// // // // // // //       case 'pushnotification':
// // // // // // //         return Icons.notifications_active;
// // // // // // //       case 'profile':
// // // // // // //         return Icons.account_circle;
// // // // // // //       case 'notification':
// // // // // // //         return Icons.notifications;
// // // // // // //       default:
// // // // // // //         return Icons.circle;
// // // // // // //     }
// // // // // // //   }
// // // // // // //
// // // // // // //   /// 🔹 Page Content
// // // // // // //   Widget _getContent(String? key) {
// // // // // // //     switch (key) {
// // // // // // //       case 'home':
// // // // // // //         return const HomePage();
// // // // // // //       case 'events':
// // // // // // //         return const Events();
// // // // // // //       case 'sermons':
// // // // // // //         return const Sermons();
// // // // // // //       case 'giving':
// // // // // // //         return const Giving();
// // // // // // //       case 'apps':
// // // // // // //         return Apps(); // ✅ no const here
// // // // // // //       case 'user':
// // // // // // //         return const UserPage();
// // // // // // //       case 'organization':
// // // // // // //         return const Organization();
// // // // // // //       case 'applications':
// // // // // // //         return const ApplicationPage();
// // // // // // //       case 'pushnotification':
// // // // // // //         return const PushNotification();
// // // // // // //       case 'profile':
// // // // // // //         return const Profile();
// // // // // // //       case 'notification':
// // // // // // //         return const NotificationPage();
// // // // // // //       default:
// // // // // // //         return const Center(child: Text("Page not found"));
// // // // // // //     }
// // // // // // //   }
// // // // // // //
// // // // // // //   /// 🔹 Logout Section
// // // // // // //   Widget _buildLogoutSection() {
// // // // // // //     return Container(
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         color: Colors.cyan.shade300,
// // // // // // //         borderRadius: const BorderRadius.only(
// // // // // // //           topLeft: Radius.circular(15),
// // // // // // //           topRight: Radius.circular(15),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //       width: double.infinity,
// // // // // // //       padding: const EdgeInsets.all(8),
// // // // // // //       child: const LogoutButton(),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }
// // // // // //
// // // // // //
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // // import 'package:provider/provider.dart';
// // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // //
// // // // // // import '../Controller/Sidebar_controller.dart';
// // // // // // import '../View_model/Sidebar_provider.dart';
// // // // // // import '../View_model/Logout.dart';
// // // // // //
// // // // // // // Pages
// // // // // // import '../View_model/side_navbar_drawer.dart';
// // // // // // import 'Application_page.dart';
// // // // // // import 'Apps_page/Apps.dart';
// // // // // // import 'Apps_page/Push_Notifications.dart';
// // // // // // import 'Events.dart';
// // // // // // import 'Giving.dart';
// // // // // // import 'Home_page.dart';
// // // // // // import 'Notifications/Notification_page.dart';
// // // // // // import 'Organization.dart';
// // // // // // import 'Profile_page.dart';
// // // // // // import 'Pushnotification.dart';
// // // // // // import 'Sermons.dart';
// // // // // // import 'User.dart';
// // // // // // import 'Notifications/notification_bell.dart';
// // // // // //
// // // // // // class MainLayout extends StatefulWidget {
// // // // // //   const MainLayout({Key? key}) : super(key: key);
// // // // // //
// // // // // //   @override
// // // // // //   _MainLayoutState createState() => _MainLayoutState();
// // // // // // }
// // // // // //
// // // // // // class _MainLayoutState extends State<MainLayout> {
// // // // // //   String? orgName;
// // // // // //   String? role;
// // // // // //   String? orgImage;
// // // // // //
// // // // // //   @override
// // // // // //   void initState() {
// // // // // //     super.initState();
// // // // // //     _loadOrgData();
// // // // // //   }
// // // // // //
// // // // // //   Future<void> _loadOrgData() async {
// // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // //     setState(() {
// // // // // //       orgName = prefs.getString('organizationName');
// // // // // //       role = prefs.getString('userRole');
// // // // // //       print('Orgname : $orgName');
// // // // // //       print('User role : $role');
// // // // // //     });
// // // // // //   }
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // // // //     final provider = Provider.of<SidebarProvider>(context);
// // // // // //
// // // // // //     final selectedKey = provider.selectedKey ??
// // // // // //         (sidebarController.sidebarItems.isNotEmpty
// // // // // //             ? sidebarController.sidebarItems.first['key']
// // // // // //             : null);
// // // // // //
// // // // // //     final selectedLabel = sidebarController.sidebarItems
// // // // // //         .firstWhere(
// // // // // //           (item) => item['key'] == selectedKey,
// // // // // //       orElse: () => {'label': 'Loading...'},
// // // // // //     )['label'];
// // // // // //
// // // // // //     final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
// // // // // //
// // // // // //     return Scaffold(
// // // // // //       appBar: isDesktop
// // // // // //           ? null
// // // // // //           : AppBar(
// // // // // //         title: Text(
// // // // // //           selectedLabel ?? '',
// // // // // //           style: GoogleFonts.poppins(
// // // // // //             textStyle: const TextStyle(color: Colors.black),
// // // // // //           ),
// // // // // //         ),
// // // // // //         backgroundColor: Colors.white,
// // // // // //         foregroundColor: Colors.black,
// // // // // //         elevation: 1,
// // // // // //       ),
// // // // // //       body: Row(
// // // // // //         children: [
// // // // // //           /// 🔹 Sidebar (hide when navigating to Apps page)
// // // // // //           if (isDesktop && selectedKey != "apps")
// // // // // //             ClipRRect(
// // // // // //               borderRadius: const BorderRadius.only(
// // // // // //                 topRight: Radius.circular(30),
// // // // // //                 bottomRight: Radius.circular(30),
// // // // // //               ),
// // // // // //               child: Container(
// // // // // //                 width: MediaQuery.of(context).size.width * .18,
// // // // // //                 color: Colors.grey.shade100,
// // // // // //                 child: Column(
// // // // // //                   children: [
// // // // // //                     _buildCurvedDrawerHeader(),
// // // // // //                     Expanded(
// // // // // //                       child: sidebarController.isLoading
// // // // // //                           ? const Center(child: CircularProgressIndicator())
// // // // // //                           : ListView(
// // // // // //                         children: _buildSidebarItems(context),
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                     _buildLogoutSection(),
// // // // // //                   ],
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),
// // // // // //
// // // // // //           /// 🔹 Page Content
// // // // // //           Expanded(child: _getContent(selectedKey)),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   /// 🔹 Curved Drawer Header
// // // // // //   Widget _buildCurvedDrawerHeader() {
// // // // // //     return Container(
// // // // // //       decoration: const BoxDecoration(
// // // // // //         color: Colors.cyan,
// // // // // //         borderRadius: BorderRadius.only(
// // // // // //           bottomLeft: Radius.circular(35),
// // // // // //           bottomRight: Radius.circular(35),
// // // // // //         ),
// // // // // //       ),
// // // // // //       height: 150,
// // // // // //       padding: const EdgeInsets.all(16),
// // // // // //       child: Row(
// // // // // //         children: [
// // // // // //           CircleAvatar(
// // // // // //             radius: 25,
// // // // // //             backgroundImage: orgImage != null
// // // // // //                 ? NetworkImage(orgImage!)
// // // // // //                 : const AssetImage('assets/favicon.png') as ImageProvider,
// // // // // //           ),
// // // // // //           const SizedBox(width: 10),
// // // // // //           Expanded(
// // // // // //             child: Text(
// // // // // //               orgName ?? '',
// // // // // //               overflow: TextOverflow.ellipsis,
// // // // // //               style: GoogleFonts.poppins(
// // // // // //                 textStyle: const TextStyle(color: Colors.white, fontSize: 20),
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //           if (role == 'admin') NotificationIconDropdown(),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   /// 🔹 Sidebar Items
// // // // // //   List<Widget> _buildSidebarItems(BuildContext context) {
// // // // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // // // //     final provider = Provider.of<SidebarProvider>(context);
// // // // // //
// // // // // //     return sidebarController.sidebarItems.map((item) {
// // // // // //       final key = item['key'];
// // // // // //       final label = item['label'];
// // // // // //       final icon = _getIconFromString(item['icon'] ?? 'home');
// // // // // //
// // // // // //       final isSelected = provider.selectedKey == key;
// // // // // //       final color = isSelected ? Colors.cyan : Colors.black;
// // // // // //       final fontWeight = isSelected ? FontWeight.bold : FontWeight.normal;
// // // // // //
// // // // // //       return ListTile(
// // // // // //         leading: Icon(icon, color: color),
// // // // // //         title: Text(
// // // // // //           label,
// // // // // //           style: TextStyle(color: color, fontWeight: fontWeight),
// // // // // //         ),
// // // // // //         onTap: () {
// // // // // //           provider.selectItem(key);
// // // // // //           setState(() {}); // refresh UI
// // // // // //         },
// // // // // //       );
// // // // // //     }).toList();
// // // // // //   }
// // // // // //
// // // // // //   /// 🔹 Icon Mapper
// // // // // //   IconData _getIconFromString(String iconName) {
// // // // // //     switch (iconName.toLowerCase()) {
// // // // // //       case 'home':
// // // // // //         return Icons.home;
// // // // // //       case 'events':
// // // // // //         return Icons.event;
// // // // // //       case 'sermons':
// // // // // //         return Icons.menu_book;
// // // // // //       case 'giving':
// // // // // //         return Icons.card_giftcard;
// // // // // //       case 'apps':
// // // // // //         return Icons.apps;
// // // // // //       case 'user':
// // // // // //         return Icons.person;
// // // // // //       case 'organization':
// // // // // //         return Icons.business;
// // // // // //       case 'applications':
// // // // // //         return Icons.assignment;
// // // // // //       case 'pushnotification':
// // // // // //         return Icons.notifications_active;
// // // // // //       case 'profile':
// // // // // //         return Icons.account_circle;
// // // // // //       case 'notification':
// // // // // //         return Icons.notifications;
// // // // // //       default:
// // // // // //         return Icons.circle;
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   /// 🔹 Page Content
// // // // // //   Widget _getContent(String? key) {
// // // // // //     switch (key) {
// // // // // //       case 'home':
// // // // // //         return const HomePage();
// // // // // //       case 'events':
// // // // // //         return const Events();
// // // // // //       case 'sermons':
// // // // // //         return const Sermons();
// // // // // //       case 'giving':
// // // // // //         return const Giving();
// // // // // //       case 'apps':
// // // // // //         return Apps(); // no const here
// // // // // //       case 'user':
// // // // // //         return const UserPage();
// // // // // //       case 'organization':
// // // // // //         return const Organization();
// // // // // //       case 'applications':
// // // // // //         return const ApplicationPage();
// // // // // //       case 'pushnotification':
// // // // // //         return const PushNotification();
// // // // // //       case 'profile':
// // // // // //         return const Profile();
// // // // // //       case 'notification':
// // // // // //         return const NotificationPage();
// // // // // //       default:
// // // // // //         return const Center(child: Text("Page not found"));
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   /// 🔹 Logout Section
// // // // // //   Widget _buildLogoutSection() {
// // // // // //     return Container(
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: Colors.cyan.shade300,
// // // // // //         borderRadius: const BorderRadius.only(
// // // // // //           topLeft: Radius.circular(15),
// // // // // //           topRight: Radius.circular(15),
// // // // // //         ),
// // // // // //       ),
// // // // // //       width: double.infinity,
// // // // // //       padding: const EdgeInsets.all(8),
// // // // // //       child: const LogoutButton(),
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // //
// // // // //
// // // // //
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // import 'package:iconsax/iconsax.dart';
// // // // // import 'package:provider/provider.dart';
// // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // //
// // // // // import '../Controller/Sidebar_controller.dart';
// // // // // import '../View_model/Logout.dart';
// // // // // import '../View_model/side_navbar_drawer.dart';
// // // // // import 'Application_page.dart';
// // // // // import 'Apps_page/Apps.dart';
// // // // // import 'Events.dart';
// // // // // import 'Giving.dart';
// // // // // import 'Home_page.dart';
// // // // // import 'Notifications/Notification_page.dart';
// // // // // import 'Organization.dart';
// // // // // import 'Profile_page.dart';
// // // // // import 'Pushnotification.dart';
// // // // // import 'Sermons.dart';
// // // // // import 'User.dart';
// // // // // import 'Notifications/notification_bell.dart';
// // // // //
// // // // // class MainLayout extends StatefulWidget {
// // // // //   const MainLayout({Key? key}) : super(key: key);
// // // // //
// // // // //   @override
// // // // //   _MainLayoutState createState() => _MainLayoutState();
// // // // // }
// // // // //
// // // // // class _MainLayoutState extends State<MainLayout> {
// // // // //   String? orgName;
// // // // //   String? role;
// // // // //   String? orgImage;
// // // // //
// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _loadOrgData();
// // // // //   }
// // // // //
// // // // //   Future<void> _loadOrgData() async {
// // // // //     final prefs = await SharedPreferences.getInstance();
// // // // //     setState(() {
// // // // //       orgName = prefs.getString('organizationName') ?? 'Organization';
// // // // //       role = prefs.getString('userRole') ?? 'user';
// // // // //       orgImage = prefs.getString('orgImage'); // optional
// // // // //     });
// // // // //   }
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // // //     final provider = Provider.of<SidebarProvider>(context);
// // // // //
// // // // //     final selectedKey = provider.selectedKey ??
// // // // //         (sidebarController.sidebarItems.isNotEmpty
// // // // //             ? sidebarController.sidebarItems.first['key']
// // // // //             : null);
// // // // //
// // // // //     final selectedLabel = sidebarController.sidebarItems
// // // // //         .firstWhere(
// // // // //           (item) => item['key'] == selectedKey,
// // // // //       orElse: () => {'label': 'Loading...'},
// // // // //     )['label'];
// // // // //
// // // // //     final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
// // // // //
// // // // //     return Scaffold(
// // // // //       appBar: isDesktop
// // // // //           ? null
// // // // //           : AppBar(
// // // // //         title: Text(
// // // // //           selectedLabel ?? '',
// // // // //           style: GoogleFonts.poppins(
// // // // //             textStyle: const TextStyle(color: Colors.black),
// // // // //           ),
// // // // //         ),
// // // // //         backgroundColor: Colors.white,
// // // // //         foregroundColor: Colors.black,
// // // // //         elevation: 1,
// // // // //       ),
// // // // //       body: Row(
// // // // //         children: [
// // // // //           // Sidebar (hidden when inside Apps page)
// // // // //           if (isDesktop && selectedKey != "apps")
// // // // //             ClipRRect(
// // // // //               borderRadius: const BorderRadius.only(
// // // // //                 topRight: Radius.circular(30),
// // // // //                 bottomRight: Radius.circular(30),
// // // // //               ),
// // // // //               child: Container(
// // // // //                 width: MediaQuery.of(context).size.width * .18,
// // // // //                 color: Colors.grey.shade100,
// // // // //                 child: Column(
// // // // //                   children: [
// // // // //                     _buildCurvedDrawerHeader(),
// // // // //                     Expanded(
// // // // //                       child: sidebarController.isLoading
// // // // //                           ? const Center(child: CircularProgressIndicator())
// // // // //                           : ListView(
// // // // //                         children: _buildSidebarItems(context),
// // // // //                       ),
// // // // //                     ),
// // // // //                     _buildLogoutSection(),
// // // // //                   ],
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //           // Page content
// // // // //           Expanded(child: _getContent(selectedKey)),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   Widget _buildCurvedDrawerHeader() {
// // // // //     return Container(
// // // // //       decoration: const BoxDecoration(
// // // // //         color: Colors.cyan,
// // // // //         borderRadius: BorderRadius.only(
// // // // //           bottomLeft: Radius.circular(35),
// // // // //           bottomRight: Radius.circular(35),
// // // // //         ),
// // // // //       ),
// // // // //       height: 150,
// // // // //       padding: const EdgeInsets.all(16),
// // // // //       child: Row(
// // // // //         children: [
// // // // //           CircleAvatar(
// // // // //             radius: 25,
// // // // //             backgroundImage: orgImage != null
// // // // //                 ? NetworkImage(orgImage!)
// // // // //                 : const AssetImage('assets/favicon.png') as ImageProvider,
// // // // //           ),
// // // // //           const SizedBox(width: 10),
// // // // //           Expanded(
// // // // //             child: Text(
// // // // //               orgName ?? '',
// // // // //               overflow: TextOverflow.ellipsis,
// // // // //               style: GoogleFonts.poppins(
// // // // //                 textStyle: const TextStyle(color: Colors.white, fontSize: 20),
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //           if (role == 'admin') NotificationIconDropdown(),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   List<Widget> _buildSidebarItems(BuildContext context) {
// // // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // // //     final provider = Provider.of<SidebarProvider>(context);
// // // // //
// // // // //     return sidebarController.sidebarItems.map((item) {
// // // // //       final key = item['key'];
// // // // //       final label = item['label'];
// // // // //       final icon = _getIconFromString(item['icon'] ?? 'home');
// // // // //
// // // // //       final isSelected = provider.selectedKey == key;
// // // // //       final color = isSelected ? Colors.cyan : Colors.black;
// // // // //       final fontWeight = isSelected ? FontWeight.bold : FontWeight.normal;
// // // // //
// // // // //       return ListTile(
// // // // //         leading: Icon(icon, color: color),
// // // // //         title: Text(label, style: TextStyle(color: color, fontWeight: fontWeight)),
// // // // //         onTap: () {
// // // // //           provider.selectItem(key);
// // // // //           setState(() {});
// // // // //         },
// // // // //       );
// // // // //     }).toList();
// // // // //   }
// // // // //
// // // // //   IconData _getIconFromString(String icon) {
// // // // //     switch (icon) {
// // // // //       case 'home':
// // // // //         return Iconsax.home;
// // // // //       case 'events':
// // // // //         return Iconsax.book;
// // // // //       case 'sermons':
// // // // //         return Iconsax.safe_home;
// // // // //       case 'giving':
// // // // //         return Iconsax.wallet_money;
// // // // //       case 'apps':
// // // // //         return Iconsax.element_3;
// // // // //       case 'user':
// // // // //         return Iconsax.profile_2user;
// // // // //       case 'organization':
// // // // //         return Iconsax.building;
// // // // //       case 'applications':
// // // // //         return Iconsax.box_2;
// // // // //       case 'pushnotification':
// // // // //         return Iconsax.notification_bing;
// // // // //       case 'notification':
// // // // //         return Iconsax.message_text;
// // // // //       case 'profile':
// // // // //         return Iconsax.profile_circle;
// // // // //       default:
// // // // //         return Iconsax.home;
// // // // //     }
// // // // //   }
// // // // //
// // // // //   Widget _getContent(String? key) {
// // // // //     switch (key) {
// // // // //       case 'home':
// // // // //         return const HomePage();
// // // // //       case 'events':
// // // // //         return const Events();
// // // // //       case 'sermons':
// // // // //         return const Sermons();
// // // // //       case 'giving':
// // // // //         return const Giving();
// // // // //       case 'apps':
// // // // //         return const Apps(); // no const issues
// // // // //       case 'user':
// // // // //         return const UserPage();
// // // // //       case 'organization':
// // // // //         return const Organization();
// // // // //       case 'applications':
// // // // //         return const ApplicationPage();
// // // // //       case 'pushnotification':
// // // // //         return const PushNotification();
// // // // //       case 'profile':
// // // // //         return const Profile();
// // // // //       case 'notification':
// // // // //         return const NotificationPage();
// // // // //       default:
// // // // //         return const Center(child: Text("Page not found"));
// // // // //     }
// // // // //   }
// // // // //
// // // // //   Widget _buildLogoutSection() {
// // // // //     return Container(
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.cyan.shade300,
// // // // //         borderRadius: const BorderRadius.only(
// // // // //           topLeft: Radius.circular(15),
// // // // //           topRight: Radius.circular(15),
// // // // //         ),
// // // // //       ),
// // // // //       width: double.infinity,
// // // // //       padding: const EdgeInsets.all(8),
// // // // //       child: const LogoutButton(),
// // // // //     );
// // // // //   }
// // // // // }
// // // //
// // // // import 'package:ancilmediaadminpanel/View/Role.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:google_fonts/google_fonts.dart';
// // // // import 'package:iconsax/iconsax.dart';
// // // // import 'package:provider/provider.dart';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // //
// // // // import '../Controller/Sidebar_controller.dart';
// // // // import '../View_model/Sidebar_provider.dart';
// // // // import '../View_model/Logout.dart';
// // // //
// // // // // Pages
// // // // import '../View_model/side_navbar_drawer.dart';
// // // // import 'Application_page.dart';
// // // // import 'Apps_page/Apps.dart';
// // // // import 'Apps_page/Push_Notifications.dart';
// // // // import 'Events.dart';
// // // // import 'Giving.dart';
// // // // import 'Home_page.dart';
// // // // import 'Notifications/Notification_page.dart';
// // // // import 'Organization.dart';
// // // // import 'Profile_page.dart';
// // // // import 'Pushnotification.dart';
// // // // import 'Sermons.dart';
// // // // import 'User.dart';
// // // // import 'Notifications/notification_bell.dart';
// // // //
// // // // class MainLayout extends StatefulWidget {
// // // //   const MainLayout({Key? key}) : super(key: key);
// // // //
// // // //   @override
// // // //   _MainLayoutState createState() => _MainLayoutState();
// // // // }
// // // //
// // // // class _MainLayoutState extends State<MainLayout> {
// // // //   String? orgName;
// // // //   String? role;
// // // //   String? orgImage;
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _loadOrgData();
// // // //   }
// // // //
// // // //   Future<void> _loadOrgData() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     orgName = prefs.getString('organizationName') ?? 'Organization';
// // // //     role = prefs.getString('userRole') ?? 'user';
// // // //     orgImage = prefs.getString('orgImage');
// // // //
// // // //     // ✅ Fetch sidebar items for this role
// // // //     final sidebarController = Provider.of<SidebarController>(context, listen: false);
// // // //     if (role != null) {
// // // //       await sidebarController.fetchSidebarForRole(role!);
// // // //     }
// // // //     setState(() {});
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // //     final provider = Provider.of<SidebarProvider>(context);
// // // //
// // // //     final selectedKey = provider.selectedKey ??
// // // //         (sidebarController.roleSidebarItems.isNotEmpty
// // // //             ? sidebarController.roleSidebarItems.first['key']
// // // //             : null);
// // // //
// // // //     final selectedLabel = sidebarController.roleSidebarItems
// // // //         .firstWhere(
// // // //           (item) => item['key'] == selectedKey,
// // // //       orElse: () => {'label': 'Loading...'},
// // // //     )['label'];
// // // //
// // // //     final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
// // // //
// // // //     return Scaffold(
// // // //       appBar: isDesktop
// // // //           ? null
// // // //           : AppBar(
// // // //         title: Text(
// // // //           selectedLabel ?? '',
// // // //           style: GoogleFonts.poppins(
// // // //             textStyle: const TextStyle(color: Colors.black),
// // // //           ),
// // // //         ),
// // // //         backgroundColor: Colors.white,
// // // //         foregroundColor: Colors.black,
// // // //         elevation: 1,
// // // //       ),
// // // //       body: Row(
// // // //         children: [
// // // //           // Sidebar (hidden when inside Apps page)
// // // //           if (isDesktop && selectedKey != "apps")
// // // //             ClipRRect(
// // // //               borderRadius: const BorderRadius.only(
// // // //                 topRight: Radius.circular(30),
// // // //                 bottomRight: Radius.circular(30),
// // // //               ),
// // // //               child: Container(
// // // //                 width: MediaQuery.of(context).size.width * .18,
// // // //                 color: Colors.grey.shade100,
// // // //                 child: Column(
// // // //                   children: [
// // // //                     _buildCurvedDrawerHeader(),
// // // //                     Expanded(
// // // //                       child: sidebarController.isLoading
// // // //                           ? const Center(child: CircularProgressIndicator())
// // // //                           : ListView(
// // // //                         children: _buildSidebarItems(context),
// // // //                       ),
// // // //                     ),
// // // //                     _buildLogoutSection(),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           // Page content
// // // //           Expanded(child: _getContent(selectedKey)),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildCurvedDrawerHeader() {
// // // //     return Container(
// // // //       decoration: const BoxDecoration(
// // // //         color: Colors.cyan,
// // // //         borderRadius: BorderRadius.only(
// // // //           bottomLeft: Radius.circular(35),
// // // //           bottomRight: Radius.circular(35),
// // // //         ),
// // // //       ),
// // // //       height: 150,
// // // //       padding: const EdgeInsets.all(16),
// // // //       child: Row(
// // // //         children: [
// // // //           CircleAvatar(
// // // //             radius: 25,
// // // //             backgroundImage: orgImage != null
// // // //                 ? NetworkImage(orgImage!)
// // // //                 : const AssetImage('assets/favicon.png') as ImageProvider,
// // // //           ),
// // // //           const SizedBox(width: 10),
// // // //           Expanded(
// // // //             child: Text(
// // // //               orgName ?? '',
// // // //               overflow: TextOverflow.ellipsis,
// // // //               style: GoogleFonts.poppins(
// // // //                 textStyle: const TextStyle(color: Colors.white, fontSize: 20),
// // // //               ),
// // // //             ),
// // // //           ),
// // // //           if (role == 'admin') NotificationIconDropdown(),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   List<Widget> _buildSidebarItems(BuildContext context) {
// // // //     final sidebarController = Provider.of<SidebarController>(context);
// // // //     final provider = Provider.of<SidebarProvider>(context);
// // // //
// // // //     return sidebarController.roleSidebarItems.map((item) {
// // // //       final key = item['key'];
// // // //       final label = item['label'];
// // // //       final icon = _getIconFromString(item['icon'] ?? 'home');
// // // //
// // // //       final isSelected = provider.selectedKey == key;
// // // //       final color = isSelected ? Colors.cyan : Colors.black;
// // // //       final fontWeight = isSelected ? FontWeight.bold : FontWeight.normal;
// // // //
// // // //       return ListTile(
// // // //         leading: Icon(icon, color: color),
// // // //         title: Text(label, style: TextStyle(color: color, fontWeight: fontWeight)),
// // // //         onTap: () {
// // // //           provider.selectItem(key);
// // // //           setState(() {});
// // // //         },
// // // //       );
// // // //     }).toList();
// // // //   }
// // // //
// // // //   IconData _getIconFromString(String icon) {
// // // //     switch (icon) {
// // // //       case 'home':
// // // //         return Iconsax.home;
// // // //       case 'events':
// // // //         return Iconsax.book;
// // // //       case 'sermons':
// // // //         return Iconsax.safe_home;
// // // //       case 'giving':
// // // //         return Iconsax.wallet_money;
// // // //       case 'apps':
// // // //         return Iconsax.element_3;
// // // //       case 'user':
// // // //         return Iconsax.profile_2user;
// // // //       case 'organization':
// // // //         return Iconsax.building;
// // // //       case 'applications':
// // // //         return Iconsax.box_2;
// // // //       case 'pushnotification':
// // // //         return Iconsax.notification_bing;
// // // //       case 'notification':
// // // //         return Iconsax.message_text;
// // // //       case 'role':
// // // //         return Iconsax.profile_circle;
// // // //       case 'profile':
// // // //         return Iconsax.profile_circle;
// // // //       default:
// // // //         return Iconsax.home;
// // // //     }
// // // //   }
// // // //
// // // //   Widget _getContent(String? key) {
// // // //     switch (key) {
// // // //       case 'home':
// // // //         return const HomePage();
// // // //       case 'events':
// // // //         return const Events();
// // // //       case 'sermons':
// // // //         return const Sermons();
// // // //       case 'giving':
// // // //         return const Giving();
// // // //       case 'apps':
// // // //         return const Apps();
// // // //       case 'user':
// // // //         return const UserPage();
// // // //       case 'organization':
// // // //         return const Organization();
// // // //       case 'applications':
// // // //         return const ApplicationPage();
// // // //       case 'pushnotification':
// // // //         return const PushNotification();
// // // //       case 'role':
// // // //         return const RolesPage();
// // // //       case 'profile':
// // // //         return const Profile();
// // // //       case 'notification':
// // // //         return const NotificationPage();
// // // //       default:
// // // //         return const Center(child: Text("Page not found"));
// // // //     }
// // // //   }
// // // //
// // // //   Widget _buildLogoutSection() {
// // // //     return Container(
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.cyan.shade300,
// // // //         borderRadius: const BorderRadius.only(
// // // //           topLeft: Radius.circular(15),
// // // //           topRight: Radius.circular(15),
// // // //         ),
// // // //       ),
// // // //       width: double.infinity,
// // // //       padding: const EdgeInsets.all(8),
// // // //       child: const LogoutButton(),
// // // //     );
// // // //   }
// // // // }
// // //
// // // import 'package:ancilmediaadminpanel/View/Role.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:iconsax/iconsax.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // //
// // // import '../Controller/Sidebar_controller.dart';
// // // import '../View_model/Sidebar_provider.dart';
// // // import '../View_model/Logout.dart';
// // //
// // // // Pages
// // // import '../View_model/side_navbar_drawer.dart';
// // // import 'Application_page.dart';
// // // import 'Apps_page/Apps.dart';
// // // import 'Apps_page/Push_Notifications.dart';
// // // import 'Events.dart';
// // // import 'Giving.dart';
// // // import 'Home_page.dart';
// // // import 'Notifications/Notification_page.dart';
// // // import 'Organization.dart';
// // // import 'Profile_page.dart';
// // // import 'Pushnotification.dart';
// // // import 'Sermons.dart';
// // // import 'User.dart';
// // // import 'Notifications/notification_bell.dart';
// // //
// // // class MainLayout extends StatefulWidget {
// // //   const MainLayout({Key? key}) : super(key: key);
// // //
// // //   @override
// // //   _MainLayoutState createState() => _MainLayoutState();
// // // }
// // //
// // // class _MainLayoutState extends State<MainLayout> {
// // //   String? orgName;
// // //   String? role;
// // //   String? orgImage;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadOrgData();
// // //   }
// // //
// // //   Future<void> _loadOrgData() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     orgName = prefs.getString('organizationName') ?? 'Organization';
// // //     role = prefs.getString('userRole') ?? 'user';
// // //     orgImage = prefs.getString('orgImage');
// // //
// // //     // ✅ Fetch sidebar items for this role
// // //     final sidebarController =
// // //     Provider.of<SidebarController>(context, listen: false);
// // //     if (role != null) {
// // //       await sidebarController.fetchSidebarForRole(role!);
// // //     }
// // //     setState(() {});
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final sidebarController = Provider.of<SidebarController>(context);
// // //     final provider = Provider.of<SidebarProvider>(context);
// // //
// // //     final selectedKey = provider.selectedKey ??
// // //         (sidebarController.roleSidebarItems.isNotEmpty
// // //             ? sidebarController.roleSidebarItems.first['key']
// // //             : null);
// // //
// // //     final selectedLabel = sidebarController.roleSidebarItems
// // //         .firstWhere(
// // //           (item) => item['key'] == selectedKey,
// // //       orElse: () => {'label': 'Loading...'},
// // //     )['label'];
// // //
// // //     final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
// // //
// // //     return Scaffold(
// // //       appBar: isDesktop
// // //           ? null
// // //           : AppBar(
// // //         title: Text(
// // //           selectedLabel ?? '',
// // //           style: GoogleFonts.poppins(
// // //             textStyle: const TextStyle(color: Colors.black),
// // //           ),
// // //         ),
// // //         backgroundColor: Colors.white,
// // //         foregroundColor: Colors.black,
// // //         elevation: 1,
// // //       ),
// // //       body: Row(
// // //         children: [
// // //           // Sidebar (hidden when inside Apps page)
// // //           if (isDesktop && selectedKey != "apps")
// // //             ClipRRect(
// // //               borderRadius: const BorderRadius.only(
// // //                 topRight: Radius.circular(30),
// // //                 bottomRight: Radius.circular(30),
// // //               ),
// // //               child: Container(
// // //                 width: MediaQuery.of(context).size.width * .18,
// // //                 color: Colors.grey.shade100,
// // //                 child: Column(
// // //                   children: [
// // //                     _buildCurvedDrawerHeader(),
// // //                     Expanded(
// // //                       child: sidebarController.isLoading
// // //                           ? const Center(child: CircularProgressIndicator())
// // //                           : _buildSidebarItems(context),
// // //                     ),
// // //                     _buildLogoutSection(),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //           // Page content
// // //           Expanded(child: _getContent(selectedKey)),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildCurvedDrawerHeader() {
// // //     return Container(
// // //       decoration: const BoxDecoration(
// // //         color: Colors.cyan,
// // //         borderRadius: BorderRadius.only(
// // //           bottomLeft: Radius.circular(35),
// // //           bottomRight: Radius.circular(35),
// // //         ),
// // //       ),
// // //       height: 150,
// // //       padding: const EdgeInsets.all(16),
// // //       child: Row(
// // //         children: [
// // //           CircleAvatar(
// // //             radius: 25,
// // //             backgroundImage: orgImage != null
// // //                 ? NetworkImage(orgImage!)
// // //                 : const AssetImage('assets/favicon.png') as ImageProvider,
// // //           ),
// // //           const SizedBox(width: 10),
// // //           Expanded(
// // //             child: Text(
// // //               orgName ?? '',
// // //               overflow: TextOverflow.ellipsis,
// // //               style: GoogleFonts.poppins(
// // //                 textStyle:
// // //                 const TextStyle(color: Colors.white, fontSize: 20),
// // //               ),
// // //             ),
// // //           ),
// // //           if (role == 'admin') NotificationIconDropdown(),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildSidebarItems(BuildContext context) {
// // //     final sidebarController = Provider.of<SidebarController>(context);
// // //     final provider = Provider.of<SidebarProvider>(context);
// // //
// // //     return ReorderableListView(
// // //       shrinkWrap: true,
// // //       physics: const NeverScrollableScrollPhysics(),
// // //       onReorder: (oldIndex, newIndex) {
// // //         setState(() {
// // //           if (newIndex > oldIndex) newIndex -= 1;
// // //           final item = sidebarController.roleSidebarItems.removeAt(oldIndex);
// // //           sidebarController.roleSidebarItems.insert(newIndex, item);
// // //         });
// // //
// // //         // TODO: Call backend API here if you want to save new order permanently
// // //         // sidebarController.saveSidebarOrder(sidebarController.roleSidebarItems);
// // //       },
// // //       children: [
// // //         for (int i = 0; i < sidebarController.roleSidebarItems.length; i++)
// // //           ListTile(
// // //             key: ValueKey(sidebarController.roleSidebarItems[i]['key']),
// // //             leading: Icon(
// // //               _getIconFromString(
// // //                   sidebarController.roleSidebarItems[i]['icon'] ?? 'home'),
// // //               color: provider.selectedKey ==
// // //                   sidebarController.roleSidebarItems[i]['key']
// // //                   ? Colors.cyan
// // //                   : Colors.black,
// // //             ),
// // //             title: Text(
// // //               sidebarController.roleSidebarItems[i]['label'],
// // //               style: TextStyle(
// // //                 color: provider.selectedKey ==
// // //                     sidebarController.roleSidebarItems[i]['key']
// // //                     ? Colors.cyan
// // //                     : Colors.black,
// // //                 fontWeight: provider.selectedKey ==
// // //                     sidebarController.roleSidebarItems[i]['key']
// // //                     ? FontWeight.bold
// // //                     : FontWeight.normal,
// // //               ),
// // //             ),
// // //             onTap: () {
// // //               provider
// // //                   .selectItem(sidebarController.roleSidebarItems[i]['key']);
// // //               setState(() {});
// // //             },
// // //           ),
// // //       ],
// // //     );
// // //   }
// // //
// // //   IconData _getIconFromString(String icon) {
// // //     switch (icon) {
// // //       case 'home':
// // //         return Iconsax.home;
// // //       case 'events':
// // //         return Iconsax.book;
// // //       case 'sermons':
// // //         return Iconsax.safe_home;
// // //       case 'giving':
// // //         return Iconsax.wallet_money;
// // //       case 'apps':
// // //         return Iconsax.element_3;
// // //       case 'user':
// // //         return Iconsax.profile_2user;
// // //       case 'organization':
// // //         return Iconsax.building;
// // //       case 'applications':
// // //         return Iconsax.box_2;
// // //       case 'pushnotification':
// // //         return Iconsax.notification_bing;
// // //       case 'notification':
// // //         return Iconsax.message_text;
// // //       case 'role':
// // //         return Iconsax.profile_circle;
// // //       case 'profile':
// // //         return Iconsax.profile_circle;
// // //       default:
// // //         return Iconsax.home;
// // //     }
// // //   }
// // //
// // //   Widget _getContent(String? key) {
// // //     switch (key) {
// // //       case 'home':
// // //         return const HomePage();
// // //       case 'events':
// // //         return const Events();
// // //       case 'sermons':
// // //         return const Sermons();
// // //       case 'giving':
// // //         return const Giving();
// // //       case 'apps':
// // //         return const Apps();
// // //       case 'user':
// // //         return const UserPage();
// // //       case 'organization':
// // //         return const Organization();
// // //       case 'applications':
// // //         return const ApplicationPage();
// // //       case 'pushnotification':
// // //         return const PushNotification();
// // //       case 'role':
// // //         return const RolesPage();
// // //       case 'profile':
// // //         return const Profile();
// // //       case 'notification':
// // //         return const NotificationPage();
// // //       default:
// // //         return const Center(child: Text("Page not found"));
// // //     }
// // //   }
// // //
// // //   Widget _buildLogoutSection() {
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         color: Colors.cyan.shade300,
// // //         borderRadius: const BorderRadius.only(
// // //           topLeft: Radius.circular(15),
// // //           topRight: Radius.circular(15),
// // //         ),
// // //       ),
// // //       width: double.infinity,
// // //       padding: const EdgeInsets.all(8),
// // //       child: const LogoutButton(),
// // //     );
// // //   }
// // // }
// //
// //
// // import 'package:ancilmediaadminpanel/View/Role.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:provider/provider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // import '../Controller/Sidebar_controller.dart';
// // import '../View_model/Sidebar_provider.dart';
// // import '../View_model/Logout.dart';
// //
// // // Pages
// // import '../View_model/side_navbar_drawer.dart';
// // import 'Application_page.dart';
// // import 'Apps_page/Apps.dart';
// // import 'Apps_page/Push_Notifications.dart';
// // import 'Events.dart';
// // import 'Giving.dart';
// // import 'Home_page.dart';
// // import 'Notifications/Notification_page.dart';
// // import 'Organization.dart';
// // import 'Profile_page.dart';
// // import 'Pushnotification.dart';
// // import 'Sermons.dart';
// // import 'User.dart';
// // import 'Notifications/notification_bell.dart';
// //
// // class MainLayout extends StatefulWidget {
// //   const MainLayout({Key? key}) : super(key: key);
// //
// //   @override
// //   _MainLayoutState createState() => _MainLayoutState();
// // }
// //
// // class _MainLayoutState extends State<MainLayout> {
// //   String? orgName;
// //   String? role;
// //   String? orgImage;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadOrgData();
// //   }
// //
// //   Future<void> _loadOrgData() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     orgName = prefs.getString('organizationName') ?? 'Organization';
// //     role = prefs.getString('userRole') ?? 'user';
// //     orgImage = prefs.getString('orgImage');
// //
// //     // ✅ Fetch sidebar items for this role
// //     final sidebarController =
// //     Provider.of<SidebarController>(context, listen: false);
// //     if (role != null) {
// //       await sidebarController.fetchSidebarForRole(role!);
// //     }
// //     setState(() {});
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final sidebarController = Provider.of<SidebarController>(context);
// //     final provider = Provider.of<SidebarProvider>(context);
// //
// //     final selectedKey = provider.selectedKey ??
// //         (sidebarController.roleSidebarItems.isNotEmpty
// //             ? sidebarController.roleSidebarItems.first['key']
// //             : null);
// //
// //     final selectedLabel = sidebarController.roleSidebarItems
// //         .firstWhere(
// //           (item) => item['key'] == selectedKey,
// //       orElse: () => {'label': 'Loading...'},
// //     )['label'];
// //
// //     final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
// //
// //     return Scaffold(
// //       appBar: isDesktop
// //           ? null
// //           : AppBar(
// //         title: Text(
// //           selectedLabel ?? '',
// //           style: GoogleFonts.poppins(
// //             textStyle: const TextStyle(color: Colors.black),
// //           ),
// //         ),
// //         backgroundColor: Colors.white,
// //         foregroundColor: Colors.black,
// //         elevation: 1,
// //       ),
// //       body: Row(
// //         children: [
// //           // Sidebar (hidden when inside Apps page)
// //           if (isDesktop && selectedKey != "apps")
// //             ClipRRect(
// //               borderRadius: const BorderRadius.only(
// //                 topRight: Radius.circular(30),
// //                 bottomRight: Radius.circular(30),
// //               ),
// //               child: Container(
// //                 width: MediaQuery.of(context).size.width * .18,
// //                 color: Colors.grey.shade100,
// //                 child: Column(
// //                   children: [
// //                     _buildCurvedDrawerHeader(),
// //                     Expanded(
// //                       child: sidebarController.isLoading
// //                           ? const Center(child: CircularProgressIndicator())
// //                           : _buildSidebarItems(context),
// //                     ),
// //                     _buildLogoutSection(),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           // Page content
// //           Expanded(child: _getContent(selectedKey)),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCurvedDrawerHeader() {
// //     return Container(
// //       decoration: const BoxDecoration(
// //         color: Colors.cyan,
// //         borderRadius: BorderRadius.only(
// //           bottomLeft: Radius.circular(35),
// //           bottomRight: Radius.circular(35),
// //         ),
// //       ),
// //       height: 150,
// //       padding: const EdgeInsets.all(16),
// //       child: Row(
// //         children: [
// //           CircleAvatar(
// //             radius: 25,
// //             backgroundImage: orgImage != null
// //                 ? NetworkImage(orgImage!)
// //                 : const AssetImage('assets/favicon.png') as ImageProvider,
// //           ),
// //           const SizedBox(width: 10),
// //           Expanded(
// //             child: Text(
// //               orgName ?? '',
// //               overflow: TextOverflow.ellipsis,
// //               style: GoogleFonts.poppins(
// //                 textStyle:
// //                 const TextStyle(color: Colors.white, fontSize: 20),
// //               ),
// //             ),
// //           ),
// //           if (role == 'admin') NotificationIconDropdown(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSidebarItems(BuildContext context) {
// //     final sidebarController = Provider.of<SidebarController>(context);
// //     final provider = Provider.of<SidebarsubProvider>(context);
// //
// //     return ReorderableListView(
// //       shrinkWrap: true,
// //       onReorder: (oldIndex, newIndex) async {
// //         if (newIndex > oldIndex) newIndex -= 1;
// //
// //         final item = sidebarController.roleSidebarItems.removeAt(oldIndex);
// //         sidebarController.roleSidebarItems.insert(newIndex, item);
// //
// //         // Update order starting from 1
// //         for (int i = 0; i < sidebarController.roleSidebarItems.length; i++) {
// //           sidebarController.roleSidebarItems[i]["order"] = i + 1;
// //         }
// //
// //         // Save order to backend
// //         if (role != null) {
// //           await sidebarController.reorderSidebar(
// //               sidebarController.roleSidebarItems);
// //         }
// //
// //         setState(() {});
// //       },
// //       children: [
// //         for (int i = 0; i < sidebarController.roleSidebarItems.length; i++)
// //           ListTile(
// //             key: ValueKey(sidebarController.roleSidebarItems[i]['key']),
// //             leading: Icon(
// //               iconMap[sidebarController.roleSidebarItems[i]['key']] ??
// //                   Iconsax.home,
// //             ),
// //             title: Text(sidebarController.roleSidebarItems[i]['label']),
// //             trailing: const Icon(Icons.drag_handle),
// //             onTap: () {
// //               provider.selectItem(
// //                   sidebarController.roleSidebarItems[i]['key']);
// //               setState(() {}); // updates page content
// //             },
// //           ),
// //       ],
// //     );
// //   }
// //
// //   IconData _getIconFromString(String icon) {
// //     switch (icon) {
// //       case 'home':
// //         return Iconsax.home;
// //       case 'events':
// //         return Iconsax.book;
// //       case 'sermons':
// //         return Iconsax.safe_home;
// //       case 'giving':
// //         return Iconsax.wallet_money;
// //       case 'apps':
// //         return Iconsax.element_3;
// //       case 'user':
// //         return Iconsax.profile_2user;
// //       case 'organization':
// //         return Iconsax.building;
// //       case 'applications':
// //         return Iconsax.box_2;
// //       case 'pushnotification':
// //         return Iconsax.notification_bing;
// //       case 'notification':
// //         return Iconsax.message_text;
// //       case 'role':
// //         return Iconsax.profile_circle;
// //       case 'profile':
// //         return Iconsax.profile_circle;
// //       default:
// //         return Iconsax.home;
// //     }
// //   }
// //
// //   Widget _getContent(String? key) {
// //     switch (key) {
// //       case 'home':
// //         return const HomePage();
// //       case 'events':
// //         return const Events();
// //       case 'sermons':
// //         return const Sermons();
// //       case 'giving':
// //         return const Giving();
// //       case 'apps':
// //         return const Apps();
// //       case 'user':
// //         return const UserPage();
// //       case 'organization':
// //         return const Organization();
// //       case 'applications':
// //         return const ApplicationPage();
// //       case 'pushnotification':
// //         return const PushNotification();
// //       case 'role':
// //         return const RolesPage();
// //       case 'profile':
// //         return const Profile();
// //       case 'notification':
// //         return const NotificationPage();
// //       default:
// //         return const Center(child: Text("Page not found"));
// //     }
// //   }
// //
// //   Widget _buildLogoutSection() {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.cyan.shade300,
// //         borderRadius: const BorderRadius.only(
// //           topLeft: Radius.circular(15),
// //           topRight: Radius.circular(15),
// //         ),
// //       ),
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(8),
// //       child: const LogoutButton(),
// //     );
// //   }
// // }
// //
// // class SidebarProvider extends ChangeNotifier {
// //   String? _selectedKey;
// //
// //   String? get selectedKey => _selectedKey;
// //
// //   void selectItem(String key) {
// //     _selectedKey = key;
// //     notifyListeners();
// //   }
// // }
//
//
//
// import 'package:ancilmediaadminpanel/View/Role.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../Controller/Sidebar_controller.dart';
// import '../View_model/Sidebar_provider.dart';
// import '../View_model/Logout.dart';
//
// // Pages
// import '../View_model/side_navbar_drawer.dart';
// import 'Application_page.dart';
// import 'Apps_page/Apps.dart';
// import 'Apps_page/Push_Notifications.dart';
// import 'Events.dart';
// import 'Giving.dart';
// import 'Home_page.dart';
// import 'Notifications/Notification_page.dart';
// import 'Organization.dart';
// import 'Profile_page.dart';
// import 'Pushnotification.dart';
// import 'Sermons.dart';
// import 'User.dart';
// import 'Notifications/notification_bell.dart';
//
// class MainLayout extends StatefulWidget {
//   const MainLayout({Key? key}) : super(key: key);
//
//   @override
//   _MainLayoutState createState() => _MainLayoutState();
// }
//
// class _MainLayoutState extends State<MainLayout> {
//   String? orgName;
//   String? role;
//   String? orgImage;
//
//   final Map<String, IconData> iconMap = {
//     'home': Iconsax.home,
//     'events': Iconsax.book,
//     'sermons': Iconsax.safe_home,
//     'giving': Iconsax.wallet_money,
//     'apps': Iconsax.element_3,
//     'user': Iconsax.profile_2user,
//     'organization': Iconsax.building,
//     'applications': Iconsax.box_2,
//     'pushnotification': Iconsax.notification_bing,
//     'notification': Iconsax.message_text,
//     'role': Iconsax.profile_circle,
//     'profile': Iconsax.profile_circle,
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     _loadOrgData();
//   }
//
//   Future<void> _loadOrgData() async {
//     final prefs = await SharedPreferences.getInstance();
//     orgName = prefs.getString('organizationName') ?? 'Organization';
//     role = prefs.getString('userRole') ?? 'user';
//     orgImage = prefs.getString('orgImage');
//
//     final sidebarController =
//     Provider.of<SidebarController>(context, listen: false);
//     if (role != null) {
//       await sidebarController.fetchSidebarForRole(role!);
//     }
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final sidebarController = Provider.of<SidebarController>(context);
//     final provider = Provider.of<SidebarsubProvider>(context);
//
//     final selectedKey = provider.selectedKey ??
//         (sidebarController.roleSidebarItems.isNotEmpty
//             ? sidebarController.roleSidebarItems.first['key']
//             : null);
//
//     final selectedLabel = sidebarController.roleSidebarItems
//         .firstWhere(
//           (item) => item['key'] == selectedKey,
//       orElse: () => {'label': 'Loading...'},
//     )['label'];
//
//     final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
//
//     return Scaffold(
//       appBar: isDesktop
//           ? null
//           : AppBar(
//         title: Text(
//           selectedLabel ?? '',
//           style: GoogleFonts.poppins(
//             textStyle: const TextStyle(color: Colors.black),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//       ),
//       body: Row(
//         children: [
//           // Sidebar (hidden on Apps page)
//           if (isDesktop && selectedKey != "apps")
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.18,
//                 color: Colors.grey.shade100,
//                 child: Column(
//                   children: [
//                     _buildCurvedDrawerHeader(),
//                     Expanded(
//                       child: sidebarController.isLoading
//                           ? const Center(child: CircularProgressIndicator())
//                           : _buildSidebarItems(context),
//                     ),
//                     _buildLogoutSection(),
//                   ],
//                 ),
//               ),
//             ),
//           // Page content
//           Expanded(child: _getContent(selectedKey)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCurvedDrawerHeader() {
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
//               orgName ?? '',
//               overflow: TextOverflow.ellipsis,
//               style: GoogleFonts.poppins(
//                 textStyle: const TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//           ),
//           if (role == 'admin') NotificationIconDropdown(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSidebarItems(BuildContext context) {
//     final sidebarController = Provider.of<SidebarController>(context);
//     final provider = Provider.of<SidebarsubProvider>(context);
//
//     return ReorderableListView(
//       shrinkWrap: true,
//       onReorder: (oldIndex, newIndex) async {
//         if (newIndex > oldIndex) newIndex -= 1;
//
//         final item = sidebarController.roleSidebarItems.removeAt(oldIndex);
//         sidebarController.roleSidebarItems.insert(newIndex, item);
//
//         // Update order starting from 1
//         for (int i = 0; i < sidebarController.roleSidebarItems.length; i++) {
//           sidebarController.roleSidebarItems[i]["order"] = i + 1;
//         }
//
//         // Save order to backend
//         if (role != null) {
//           await sidebarController.reorderSidebar(
//               sidebarController.roleSidebarItems);
//         }
//
//         setState(() {});
//       },
//       children: [
//         for (int i = 0; i < sidebarController.roleSidebarItems.length; i++)
//           ListTile(
//             key: ValueKey(sidebarController.roleSidebarItems[i]['key']),
//             leading: Icon(
//               iconMap[sidebarController.roleSidebarItems[i]['key']] ??
//                   Iconsax.home,
//             ),
//             title: Text(sidebarController.roleSidebarItems[i]['label']),
//             trailing: const Icon(Icons.drag_handle),
//             onTap: () {
//               provider.selectItem(
//                   sidebarController.roleSidebarItems[i]['key']);
//               setState(() {}); // updates page content
//             },
//           ),
//       ],
//     );
//   }
//
//   Widget _getContent(String? key) {
//     switch (key) {
//       case 'home':
//         return const HomePage();
//       case 'events':
//         return const Events();
//       case 'sermons':
//         return const Sermons();
//       case 'giving':
//         return const Giving();
//       case 'apps':
//         return const Apps();
//       case 'user':
//         return const UserPage();
//       case 'organization':
//         return const Organization();
//       case 'applications':
//         return const ApplicationPage();
//       case 'pushnotification':
//         return const PushNotification();
//       case 'role':
//         return const RolesPage();
//       case 'profile':
//         return const Profile();
//       case 'notification':
//         return const NotificationPage();
//       default:
//         return const Center(
//             child: Text(
//               "Page not found",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ));
//     }
//   }
//
//   Widget _buildLogoutSection() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.cyan.shade300,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(15),
//           topRight: Radius.circular(15),
//         ),
//       ),
//       width: double.infinity,
//       padding: const EdgeInsets.all(8),
//       child: const LogoutButton(),
//     );
//   }
// }
//
// class SidebarsubProvider extends ChangeNotifier {
//   String? _selectedKey;
//
//   String? get selectedKey => _selectedKey;
//
//   void selectItem(String key) {
//     _selectedKey = key;
//     notifyListeners();
//   }
// }

import 'package:ancilmediaadminpanel/View/Role.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/Sidebar_controller.dart';
import '../View_model/Sidebar_provider.dart';
import '../View_model/Logout.dart';

// Pages
import '../View_model/side_navbar_drawer.dart';
import 'Application_page.dart';
import 'Apps_page/Apps.dart';
import 'Apps_page/Push_Notifications.dart';
import 'Events.dart';
import 'Giving.dart';
import 'Home_page.dart';
import 'Notifications/Notification_page.dart';
import 'Organization.dart';
import 'Profile_page.dart';
import 'Pushnotification.dart';
import 'Sermons.dart';
import 'User.dart';
import 'Notifications/notification_bell.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String? orgName;
  String? role;
  String? orgImage;

  final Map<String, IconData> iconMap = {
    'home': Iconsax.home,
    'events': Iconsax.book,
    'sermons': Iconsax.safe_home,
    'giving': Iconsax.wallet_money,
    'apps': Iconsax.element_3,
    'user': Iconsax.profile_2user,
    'organization': Iconsax.building,
    'applications': Iconsax.box_2,
    'pushnotification': Iconsax.notification_bing,
    'notification': Iconsax.message_text,
    'role': Iconsax.profile_circle,
    'profile': Iconsax.profile_circle,
  };

  @override
  void initState() {
    super.initState();
    _loadOrgData();
  }

  Future<void> _loadOrgData() async {
    final prefs = await SharedPreferences.getInstance();
    orgName = prefs.getString('organizationName') ?? 'Organization';
    role = prefs.getString('userRole') ?? 'user';
    orgImage = prefs.getString('orgImage');

    final sidebarController =
    Provider.of<SidebarController>(context, listen: false);
    if (role != null) {
      await sidebarController.fetchSidebarForRole(role!);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final sidebarController = Provider.of<SidebarController>(context);
    final provider = Provider.of<SidebarsubProvider>(context);

    final selectedKey = provider.selectedKey ??
        (sidebarController.roleSidebarItems.isNotEmpty
            ? sidebarController.roleSidebarItems.first['key']
            : null);

    final selectedLabel = sidebarController.roleSidebarItems
        .firstWhere(
          (item) => item['key'] == selectedKey,
      orElse: () => {'label': 'Loading...'},
    )['label'];

    final bool isDesktop = MediaQuery.of(context).size.width >= 1100;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
        title: Text(
          selectedLabel ?? '',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Row(
        children: [
          // Sidebar (hidden on Apps page)
          if (isDesktop && selectedKey != "apps")
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.18,
                color: Colors.grey.shade100,
                child: Column(
                  children: [
                    _buildCurvedDrawerHeader(),
                    Expanded(
                      child: sidebarController.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildSidebarItems(context),
                    ),
                    _buildLogoutSection(),
                  ],
                ),
              ),
            ),
          // Page content
          Expanded(child: _getContent(selectedKey)),
        ],
      ),
    );
  }

  Widget _buildCurvedDrawerHeader() {
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
              orgName ?? '',
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

  Widget _buildSidebarItems(BuildContext context) {
    final sidebarController = Provider.of<SidebarController>(context);
    final provider = Provider.of<SidebarsubProvider>(context);

    return ReorderableListView(
      buildDefaultDragHandles: false,
      shrinkWrap: true,
      onReorder: (oldIndex, newIndex) async {
        if (newIndex > oldIndex) newIndex -= 1;

        final item = sidebarController.roleSidebarItems.removeAt(oldIndex);
        sidebarController.roleSidebarItems.insert(newIndex, item);

        // Update order starting from 1
        for (int i = 0; i < sidebarController.roleSidebarItems.length; i++) {
          sidebarController.roleSidebarItems[i]["order"] = i + 1;
        }

        // Save order to backend
        if (role != null) {
          await sidebarController.reorderSidebar(sidebarController.roleSidebarItems);
        }

        setState(() {});
      },
      children: [
        for (int i = 0; i < sidebarController.roleSidebarItems.length; i++)
          ListTile(
            key: ValueKey(sidebarController.roleSidebarItems[i]['key']),
            leading: Icon(
              iconMap[sidebarController.roleSidebarItems[i]['key']] ??
                  Iconsax.element_3, // main icon
            ),
            title: Text(sidebarController.roleSidebarItems[i]['label']),
            trailing: ReorderableDragStartListener(
              index: i,
              child: const Icon(Iconsax.activity), // drag handle now at trailing
            ),
            onTap: () {
              provider.selectItem(sidebarController.roleSidebarItems[i]['key']);
              setState(() {}); // update page content
            },
          ),
      ],
    );
  }

  Widget _getContent(String? key) {
    switch (key) {
      case 'home':
        return const HomePage();
      case 'events':
        return const Events();
      case 'sermons':
        return const Sermons();
      case 'giving':
        return const Giving();
      case 'apps':
        return const Apps();
      case 'user':
        return const UserPage();
      case 'organization':
        return const Organization();
      case 'applications':
        return const ApplicationPage();
      case 'pushnotification':
        return const PushNotification();
      case 'role':
        return const RolesPage();
      case 'profile':
        return const Profile();
      case 'notification':
        return const NotificationPage();
      default:
        return const Center(
            child: Text(
              "Page not found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ));
    }
  }

  Widget _buildLogoutSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.cyan.shade300,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: const LogoutButton(),
    );
  }
}

class SidebarsubProvider extends ChangeNotifier {
  String? _selectedKey;

  String? get selectedKey => _selectedKey;

  void selectItem(String key) {
    _selectedKey = key;
    notifyListeners();
  }
}
