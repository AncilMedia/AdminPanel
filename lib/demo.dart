// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../Socket_Service.dart';
// // import '../Controller/User_controller.dart';
// // import '../Model/User_Model.dart';
// // import '../View_model/Authentication_state.dart';
// // import 'package:provider/provider.dart';
// //
// // class SocketTestPage extends StatefulWidget {
// //   const SocketTestPage({super.key});
// //
// //   @override
// //   State<SocketTestPage> createState() => _SocketTestPageState();
// // }
// //
// // class _SocketTestPageState extends State<SocketTestPage> {
// //   String status = "Connecting...";
// //   List<String> logs = [];
// //
// //   /// 🔥 USERS FROM API
// //   List<UserModel> users = [];
// //
// //   /// 🔥 PRESENCE MAPS (from socket)
// //   Map<String, String> userStatus = {};   // userId -> online/offline
// //   Map<String, String?> lastSeenMap = {}; // userId -> lastSeen
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     initAll();
// //   }
// //
// //   Future<void> initAll() async {
// //     await fetchUsers();   // ✅ Load users first
// //     await initSocket();   // ✅ Then connect socket
// //   }
// //
// //   /// ================= FETCH USERS =================
// //   Future<void> fetchUsers() async {
// //     try {
// //       final authState = Provider.of<AuthState>(context, listen: false);
// //
// //       final data = await UserController.fetchUsers(
// //         authState: authState,
// //       );
// //
// //       setState(() {
// //         users = data;
// //       });
// //
// //       addLog("✅ Users loaded: ${users.length}");
// //     } catch (e) {
// //       addLog("❌ Failed to load users: $e");
// //     }
// //   }
// //
// //   /// ================= SOCKET =================
// //   Future<void> initSocket() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final userId = prefs.getString('userId');
// //
// //     if (userId == null) {
// //       addLog("❌ No userId found in storage");
// //       return;
// //     }
// //
// //     SocketService().initSocket(userId);
// //
// //     SocketService().on("presence-update", (data) {
// //       if (!mounted) return;
// //
// //       try {
// //         final map = Map<String, dynamic>.from(data);
// //
// //         final id = map["userId"]?.toString();
// //         final stat = map["status"]?.toString();
// //         final lastSeen = map["lastSeen"]?.toString();
// //
// //         addLog("📩 $id → $stat");
// //
// //         if (id != null && stat != null) {
// //           setState(() {
// //             userStatus[id] = stat;
// //             lastSeenMap[id] = lastSeen;
// //           });
// //         }
// //       } catch (e) {
// //         addLog("❌ Socket parse error: $e");
// //       }
// //     });
// //
// //     setState(() {
// //       status = "🟢 Connected";
// //     });
// //   }
// //
// //   void addLog(String msg) {
// //     setState(() {
// //       logs.add(msg);
// //     });
// //     print(msg);
// //   }
// //
// //   @override
// //   void dispose() {
// //     SocketService().dispose();
// //     super.dispose();
// //   }
// //
// //   /// ================= UI =================
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("User Presence")),
// //       body: Column(
// //         children: [
// //           Text(status),
// //
// //           /// 🔥 USER LIST FROM API (NOT SOCKET)
// //           Expanded(
// //             flex: 2,
// //             child: ListView.builder(
// //               itemCount: users.length,
// //               itemBuilder: (context, index) {
// //                 final user = users[index];
// //
// //                 final isOnline = userStatus[user.id] == "online";
// //                 final lastSeen = lastSeenMap[user.id];
// //
// //                 return ListTile(
// //                   leading: Stack(
// //                     children: [
// //                       CircleAvatar(
// //                         child: Text(
// //                           user.username.isNotEmpty
// //                               ? user.username[0].toUpperCase()
// //                               : "?",
// //                         ),
// //                       ),
// //
// //                       /// 🟢 ONLINE DOT
// //                       if (isOnline)
// //                         Positioned(
// //                           right: 0,
// //                           bottom: 0,
// //                           child: Container(
// //                             width: 12,
// //                             height: 12,
// //                             decoration: BoxDecoration(
// //                               color: Colors.green,
// //                               shape: BoxShape.circle,
// //                               border:
// //                               Border.all(color: Colors.white, width: 2),
// //                             ),
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //
// //                   /// ✅ SHOW NAME INSTEAD OF ID
// //                   title: Text(user.username),
// //
// //                   subtitle: Text(
// //                     isOnline
// //                         ? "🟢 Online"
// //                         : "🔴 Offline\nLast seen: ${lastSeen ?? "N/A"}",
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //
// //           /// 🔥 LOGS
// //           Expanded(
// //             flex: 1,
// //             child: Container(
// //               color: Colors.black,
// //               child: ListView(
// //                 children: logs
// //                     .map((e) => Text(
// //                   e,
// //                   style: const TextStyle(color: Colors.green),
// //                 ))
// //                     .toList(),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
//
//
// import 'dart:core';
//
// import 'package:ancilmediaadminpanel/View/Events.dart';
// import 'package:ancilmediaadminpanel/View/Login_page.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:html' as html;
// import '../Controller/Sidebar_controller.dart';
// import '../View_model/side_navbar_drawer.dart';
// import '../View_model/Notification_dropdown_state.dart';
// import '../View_model/Logout.dart';
// import 'View/Application_page.dart';
// import 'View/Apps_page/Apps.dart';
// import 'View/Giving.dart';
// import 'View/Home_page.dart';
// import 'View/Media_page.dart';
// import 'View/Navigation_screen.dart';
// import 'View/Notifications/Notification_page.dart';
// import 'View/Notifications/notification_bell.dart';
// import 'View/Organization.dart';
// import 'View/Profile_page.dart';
// import 'View/PushNotification.dart';
// import 'View/Role.dart';
// import 'View/Sidebar_Manger.dart';
// import 'View/User.dart';
//
//
//
// class MainLayout extends StatefulWidget {
//   final String initialPage;
//   const MainLayout({Key? key, required this.initialPage}) : super(key: key);
//
//   @override
//   _MainLayoutState createState() => _MainLayoutState();
// }
//
// class _MainLayoutState extends State<MainLayout> {
//   String? orgName;
//   String? role;
//   String? orgImage;
//   late String selectedKey;
//
//   // Track expanded state for menus
//   bool isNotificationExpanded = false;
//
//   final Map<String, IconData> iconMap = {
//     'home': Iconsax.home,
//     'events': Iconsax.book,
//     'giving': Iconsax.wallet_money,
//     'apps': Iconsax.element_3,
//     'user': Iconsax.profile_2user,
//     'organization': Iconsax.building,
//     'applications': Iconsax.box_2,
//     'pushnotification': Iconsax.notification_bing,
//     'media': Iconsax.video,
//     'notification': Iconsax.message_text,
//     'role': Iconsax.smileys,
//     'profile': Iconsax.profile_circle,
//     'sidebar': Iconsax.element_2,
//     'navigation': Iconsax.route_square,
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     selectedKey = widget.initialPage;
//     // Auto-expand if the initial page is a sub-page of notifications
//     if (selectedKey == 'pushnotification' || selectedKey == 'notification_history') {
//       isNotificationExpanded = true;
//     }
//     _loadOrgData();
//   }
//
//   Future<void> _loadOrgData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('accessToken');
//
//     if (token == null || token.isEmpty) {
//       _handleLogoutRedirect();
//       return;
//     }
//
//     orgName = prefs.getString('organizationName') ?? 'Organization';
//     role = prefs.getString('userRole') ?? 'user';
//     orgImage = prefs.getString('orgImage');
//
//     final sidebarController = Provider.of<SidebarController>(context, listen: false);
//     if (role != null) {
//       await sidebarController.fetchSidebarForRole(role!);
//     }
//     if (mounted) setState(() {});
//   }
//
//   void _handleLogoutRedirect() {
//     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final sidebarController = Provider.of<SidebarController>(context);
//     final isDesktop = MediaQuery.of(context).size.width >= 1100;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F2F5),
//       appBar: isDesktop ? null : _buildMobileAppBar(sidebarController),
//       body: Row(
//         children: [
//           if (isDesktop && selectedKey != "apps" && selectedKey != "media")
//             _buildModernSidebar(sidebarController),
//           Expanded(
//             child: Container(
//               margin: isDesktop ? const EdgeInsets.all(16) : EdgeInsets.zero,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: isDesktop ? BorderRadius.circular(30) : BorderRadius.zero,
//                 boxShadow: [
//                   if (isDesktop)
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.04),
//                       blurRadius: 24,
//                       offset: const Offset(0, 8),
//                     )
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: isDesktop ? BorderRadius.circular(30) : BorderRadius.zero,
//                 child: _getContent(selectedKey),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildMobileAppBar(SidebarController controller) {
//     return AppBar(
//       title: Text(
//         "Dashboard",
//         style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w600),
//       ),
//       backgroundColor: Colors.white,
//       elevation: 0.5,
//       iconTheme: const IconThemeData(color: Colors.black87),
//     );
//   }
//
//   Widget _buildModernSidebar(SidebarController controller) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.18,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           const SizedBox(height: 24),
//           _buildFloatingHeader(),
//           const SizedBox(height: 24),
//           Expanded(
//             child: controller.isLoading
//                 ? Center(child: Lottie.network("https://res.cloudinary.com/dggylwwqk/raw/upload/v1772002591/Weather_Wind_zdbufx.json"))
//                 : _buildSidebarList(sidebarController: controller),
//           ),
//           _buildLogoutSection(),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFloatingHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.cyan.shade700, Colors.cyan.shade400],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(color: Colors.cyan.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(2),
//             decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
//             child: CircleAvatar(
//               radius: 20,
//               backgroundImage: orgImage != null
//                   ? NetworkImage(orgImage!)
//                   : const AssetImage('assets/favicon.png') as ImageProvider,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(orgName ?? 'Organization',
//                     overflow: TextOverflow.ellipsis,
//                     style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
//                 Text(role?.toUpperCase() ?? 'USER',
//                     style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
//               ],
//             ),
//           ),
//           if (role == 'admin') const NotificationIconDropdown(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSidebarList({required SidebarController sidebarController}) {
//     return ReorderableListView.builder(
//       buildDefaultDragHandles: false,
//       itemCount: sidebarController.roleSidebarItems.length,
//       onReorder: (oldIndex, newIndex) async {
//         if (newIndex > oldIndex) newIndex -= 1;
//         final item = sidebarController.roleSidebarItems.removeAt(oldIndex);
//         sidebarController.roleSidebarItems.insert(newIndex, item);
//         if (role != null) await sidebarController.reorderSidebar(sidebarController.roleSidebarItems);
//         setState(() {});
//       },
//       itemBuilder: (context, i) {
//         final item = sidebarController.roleSidebarItems[i];
//         final key = item['key'];
//
//         // Special handling for Push Notification heading
//         if (key == 'pushnotification') {
//           return _buildExpandableTile(
//             key: ValueKey(key),
//             index: i,
//             icon: iconMap[key] ?? Iconsax.notification_bing,
//             label: item['label'],
//           );
//         }
//
//         return _buildModernTile(
//           key: ValueKey(key),
//           index: i,
//           icon: iconMap[key] ?? Iconsax.element_3,
//           label: item['label'],
//           isSelected: selectedKey == key,
//           onTap: () {
//             setState(() => selectedKey = key);
//             html.window.history.pushState(null, '', '/$key');
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildExpandableTile({
//     required Key key,
//     required int index,
//     required IconData icon,
//     required String label,
//   }) {
//     bool isChildSelected = selectedKey == 'pushnotification' || selectedKey == 'notification_history';
//
//     return Column(
//       key: key,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _buildModernTile(
//           key: ValueKey('${key.toString()}_header'),
//           index: index,
//           icon: icon,
//           label: label,
//           isSelected: isChildSelected,
//           trailing: Icon(
//             isNotificationExpanded ? Iconsax.arrow_up_2 : Iconsax.arrow_down_1,
//             size: 14,
//             color: isChildSelected ? Colors.cyan.shade800 : Colors.blueGrey,
//           ),
//           onTap: () {
//             setState(() {
//               isNotificationExpanded = !isNotificationExpanded;
//             });
//           },
//         ),
//         if (isNotificationExpanded)
//           Padding(
//             padding: const EdgeInsets.only(left: 32, bottom: 8),
//             child: Column(
//               children: [
//                 _buildSubTile(
//                   label: "Send Notification",
//                   isSelected: selectedKey == 'pushnotification',
//                   onTap: () {
//                     setState(() => selectedKey = 'pushnotification');
//                     html.window.history.pushState(null, '', '/pushnotification');
//                   },
//                 ),
//                 _buildSubTile(
//                   label: "History",
//                   isSelected: selectedKey == 'notification_history',
//                   onTap: () {
//                     setState(() => selectedKey = 'notification_history');
//                     html.window.history.pushState(null, '', '/notification_history');
//                   },
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildSubTile({required String label, required bool isSelected, required VoidCallback onTap}) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.cyan.withOpacity(0.08) : Colors.transparent,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Icon(Icons.circle, size: 4, color: isSelected ? Colors.cyan : Colors.grey),
//             const SizedBox(width: 12),
//             Text(
//               label,
//               style: GoogleFonts.poppins(
//                 fontSize: 13,
//                 color: isSelected ? Colors.cyan.shade900 : Colors.blueGrey.shade700,
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildModernTile({
//     required Key key,
//     required int index,
//     required IconData icon,
//     required String label,
//     required bool isSelected,
//     required VoidCallback onTap,
//     Widget? trailing,
//   }) {
//     return Padding(
//       key: key,
//       padding: const EdgeInsets.only(bottom: 6),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(15),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//           decoration: BoxDecoration(
//             color: isSelected ? Colors.cyan.withOpacity(0.12) : Colors.transparent,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Row(
//             children: [
//               Icon(icon, color: isSelected ? Colors.cyan.shade800 : Colors.blueGrey.shade600, size: 20),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Text(
//                   label,
//                   style: GoogleFonts.poppins(
//                     color: isSelected ? Colors.cyan.shade900 : Colors.blueGrey.shade700,
//                     fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               if (trailing != null) trailing,
//               if (trailing == null)
//                 isSelected
//                     ? Container(width: 4, height: 16, decoration: BoxDecoration(color: Colors.cyan, borderRadius: BorderRadius.circular(10)))
//                     : ReorderableDragStartListener(index: index, child: Icon(Iconsax.grid_3, size: 14, color: Colors.grey.shade300)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLogoutSection() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: const LogoutButton(),
//     );
//   }
//
//   Widget _getContent(String key) {
//     switch (key) {
//       case 'home': return const HomePage();
//       case 'events': return const Events();
//       case 'giving': return const Giving();
//       case 'apps': return const Apps();
//       case 'user': return const UserPage();
//       case 'organization': return const Organization();
//       case 'applications': return const ApplicationPage();
//       case 'pushnotification': return const PushNotification(); // This is the 'Send' page
//       case 'notification_history': return const Center(child: Text("History Page Content")); // Replace with actual History widget
//       case 'role': return const RolesPage();
//       case 'profile': return const Profile();
//       case 'media': return const MediaPage();
//       case 'notification': return const NotificationPage();
//       case 'sidebar': return const ManageSidebar();
//       case 'navigation': return const NavigationFormPage();
//       default:
//         return Center(child: Text("Page $key not found", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)));
//     }
//   }
// }

