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
//
// // --- Page Imports (Ensure paths are correct) ---
// import 'Home_page.dart';
// import 'Events.dart';
// import 'Giving.dart';
// import 'Sermons.dart';
// import 'User.dart';
// import 'Organization.dart';
// import 'Application_page.dart';
// import 'Pushnotification.dart';
// import 'Role.dart';
// import 'Profile_page.dart';
// import 'Media_page.dart';
// import 'Sidebar_Manger.dart';
// import 'Navigation_screen.dart';
// import 'Apps_page/Apps.dart';
// import 'Notifications/Notification_page.dart';
// import 'Notifications/notification_bell.dart';
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
//   bool isNotificationExpanded = false;
//
//
//   final Map<String, IconData> iconMap = {
//     'home': Iconsax.home,
//     'events': Iconsax.book,
//     // 'sermons': Iconsax.safe_home,
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
//     if (selectedKey == 'pushnotification' || selectedKey == 'notification history') {
//       isNotificationExpanded = true;
//     }
//     _loadOrgData();
//   }
//
//   Future<void> _loadOrgData() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     // 1. Check for the token
//     final token = prefs.getString('accessToken'); // Replace 'token' with your actual key name
//
//     if (token == null || token.isEmpty) {
//       // 2. If token is missing, redirect to login
//       _handleLogoutRedirect();
//       return;
//     }
//
//     // Existing logic for loading data
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
// // Helper method to handle the transition
//   void _handleLogoutRedirect() {
//     // Clear any existing session data if necessary
//     // SharedPreferences.getInstance().then((prefs) => prefs.clear());
//
//     // Use Navigator to push the Login route and remove all previous routes
//     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage()));
//   }
//   // Future<void> _loadOrgData() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   orgName = prefs.getString('organizationName') ?? 'Organization';
//   //   role = prefs.getString('userRole') ?? 'user';
//   //   orgImage = prefs.getString('orgImage');
//   //
//   //   final sidebarController = Provider.of<SidebarController>(context, listen: false);
//   //   if (role != null) {
//   //     await sidebarController.fetchSidebarForRole(role!);
//   //   }
//   //   if (mounted) setState(() {});
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final sidebarController = Provider.of<SidebarController>(context);
//     final isDesktop = MediaQuery.of(context).size.width >= 1100;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F2F5), // Soft modern background
//       appBar: isDesktop ? null : _buildMobileAppBar(sidebarController),
//       body: Row(
//         children: [
//           // --- MODERN SIDEBAR ---
//           if (isDesktop && selectedKey != "apps" && selectedKey != "media")
//             _buildModernSidebar(sidebarController),
//
//           // --- MAIN WORKSPACE ---
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
//         controller.roleSidebarItems.firstWhere(
//               (item) => item['key'] == selectedKey,
//           orElse: () => {'label': 'Dashboard'},
//         )['label'],
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
//                 ?  Center(child: Lottie.network("https://res.cloudinary.com/dggylwwqk/raw/upload/v1772002591/Weather_Wind_zdbufx.json"))
//                 : _buildSidebarList(controller),
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
//   Widget _buildSidebarList(SidebarController controller) {
//     return ReorderableListView.builder(
//       buildDefaultDragHandles: false,
//       itemCount: controller.roleSidebarItems.length,
//       onReorder: (oldIndex, newIndex) async {
//         if (newIndex > oldIndex) newIndex -= 1;
//         final item = controller.roleSidebarItems.removeAt(oldIndex);
//         controller.roleSidebarItems.insert(newIndex, item);
//         if (role != null) await controller.reorderSidebar(controller.roleSidebarItems);
//         setState(() {});
//       },
//       itemBuilder: (context, i) {
//         final item = controller.roleSidebarItems[i];
//         final key = item['key'];
//         final isSelected = selectedKey == key;
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
//           isSelected: isSelected,
//           onTap: () {
//             setState(() => selectedKey = key);
//             html.window.history.pushState(null, '', '/$key');
//           },
//         );
//       },
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
//
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
//               if (!isSelected)
//                 ReorderableDragStartListener(
//                   index: index,
//                   child: Icon(Iconsax.grid_3, size: 14, color: Colors.grey.shade300),
//                 )
//               else
//                 Container(
//                   width: 5,
//                   height: 15,
//                   decoration: BoxDecoration(color: Colors.cyan, borderRadius: BorderRadius.circular(10)),
//                 ),
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
//                   isSelected: selectedKey == 'MasterIntelligenceHub',
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
//
//   Widget _getContent(String key) {
//     switch (key) {
//       case 'home': return const HomePage();
//       case 'events': return const Events();
//       // case 'sermons': return const Sermons();
//       case 'giving': return const Giving();
//       case 'apps': return const Apps();
//       case 'user': return const UserPage();
//       case 'organization': return const Organization();
//       case 'applications': return const ApplicationPage();
//       case 'pushnotification': return const PushNotification();
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
//
// // Ensure the SidebarsubProvider is managed via your main.dart provider list.
// class SidebarsubProvider extends ChangeNotifier {
//   String? _selectedKey;
//   String? get selectedKey => _selectedKey;
//
//   void selectItem(String key) {
//     _selectedKey = key;
//     notifyListeners();
//   }
// }

import 'package:ancilmediaadminpanel/View/Login_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;
import '../Controller/Sidebar_controller.dart';
import '../View_model/side_navbar_drawer.dart';
import '../View_model/Notification_dropdown_state.dart';
import '../View_model/Logout.dart';

// --- Page Imports ---
import 'Home_page.dart';
import 'Events.dart';
import 'Giving.dart';
import 'NotificationHistoryScreen.dart';
import 'Sermons.dart';
import 'User.dart';
import 'Organization.dart';
import 'Application_page.dart';
import 'Pushnotification.dart';
import 'Role.dart';
import 'Profile_page.dart';
import 'Media_page.dart';
import 'Sidebar_Manger.dart';
import 'Navigation_screen.dart';
import 'Apps_page/Apps.dart';
import 'Notifications/Notification_page.dart';
import 'Notifications/notification_bell.dart';

class MainLayout extends StatefulWidget {
  final String initialPage;
  const MainLayout({Key? key, required this.initialPage}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String? orgName;
  String? role;
  String? orgImage;
  late String selectedKey;
  bool isNotificationExpanded = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // For mobile drawer control

  final Map<String, IconData> iconMap = {
    'home': Iconsax.home,
    'events': Iconsax.book,
    'giving': Iconsax.wallet_money,
    'apps': Iconsax.element_3,
    'user': Iconsax.profile_2user,
    'organization': Iconsax.building,
    'applications': Iconsax.box_2,
    'pushnotification': Iconsax.notification_bing,
    'notification_history': Iconsax.notification,
    'media': Iconsax.video,
    'notification': Iconsax.message_text,
    'role': Iconsax.smileys,
    'sidebar': Iconsax.element_2,
    'navigation': Iconsax.route_square,
    'profile': Iconsax.profile_circle,
  };

  @override
  void initState() {
    super.initState();
    selectedKey = widget.initialPage;
    if (selectedKey == 'pushnotification' || selectedKey == 'notification_history') {
      isNotificationExpanded = true;
    }
    _loadOrgData();
  }

  Future<void> _loadOrgData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null || token.isEmpty) {
      _handleLogoutRedirect();
      return;
    }

    orgName = prefs.getString('organizationName') ?? 'Organization';
    role = prefs.getString('userRole') ?? 'user';
    orgImage = prefs.getString('orgImage');

    final sidebarController = Provider.of<SidebarController>(context, listen: false);
    if (role != null) {
      await sidebarController.fetchSidebarForRole(role!);
    }
    if (mounted) setState(() {});
  }

  void _handleLogoutRedirect() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final sidebarController = Provider.of<SidebarController>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint for Desktop/Tablet vs Mobile
        final bool isDesktop = constraints.maxWidth >= 1100;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFF0F2F5),
          // Show AppBar only on Mobile
          appBar: isDesktop ? null : _buildMobileAppBar(sidebarController),
          // On mobile, the sidebar becomes a Drawer
          drawer: isDesktop ? null : Drawer(
            width: 280,
            backgroundColor: const Color(0xFFF0F2F5),
            child: _buildModernSidebar(sidebarController, isMobile: true),
          ),
          body: Row(
            children: [
              // Show sidebar permanently only on Desktop
              if (isDesktop && selectedKey != "apps" && selectedKey != "media")
                SizedBox(
                  width: constraints.maxWidth * 0.18,
                  child: _buildModernSidebar(sidebarController, isMobile: false),
                ),

              // Main Content Area
              Expanded(
                child: Container(
                  margin: isDesktop ? const EdgeInsets.all(16) : EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: isDesktop ? BorderRadius.circular(30) : BorderRadius.zero,
                    boxShadow: [
                      if (isDesktop)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: isDesktop ? BorderRadius.circular(30) : BorderRadius.zero,
                    child: _getContent(selectedKey),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildMobileAppBar(SidebarController controller) {
    return AppBar(
      title: Text(
        "Admin Panel",
        style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w600),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      backgroundColor: Colors.white,
      elevation: 0.5,
      iconTheme: const IconThemeData(color: Colors.black87),
    );
  }

  // Modified to handle both Drawer (Mobile) and Sidebar (Desktop)
  Widget _buildModernSidebar(SidebarController controller, {required bool isMobile}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          _buildFloatingHeader(),
          const SizedBox(height: 24),
          Expanded(
            child: controller.isLoading
                ? Center(child: Lottie.network("https://res.cloudinary.com/dggylwwqk/raw/upload/v1772002591/Weather_Wind_zdbufx.json"))
                : _buildSidebarList(controller, isMobile: isMobile),
          ),
          _buildLogoutSection(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFloatingHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan.shade700, Colors.cyan.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.cyan.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            backgroundImage: orgImage != null
                ? NetworkImage(orgImage!)
                : const AssetImage('assets/favicon.png') as ImageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(orgName ?? 'Organization',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                Text(role?.toUpperCase() ?? 'USER',
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              ],
            ),
          ),
          if (role == 'admin') const NotificationIconDropdown(),
        ],
      ),
    );
  }

  Widget _buildSidebarList(SidebarController controller, {required bool isMobile}) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      itemCount: controller.roleSidebarItems.length,
      onReorder: (oldIndex, newIndex) async {
        if (newIndex > oldIndex) newIndex -= 1;
        final item = controller.roleSidebarItems.removeAt(oldIndex);
        controller.roleSidebarItems.insert(newIndex, item);
        if (role != null) await controller.reorderSidebar(controller.roleSidebarItems);
        setState(() {});
      },
      itemBuilder: (context, i) {
        final item = controller.roleSidebarItems[i];
        final key = item['key'];

        if (key == 'pushnotification') {
          return _buildExpandableTile(
            key: ValueKey(key),
            index: i,
            icon: iconMap[key] ?? Iconsax.notification_bing,
            label: item['label'],
            isMobile: isMobile,
          );
        }

        return _buildModernTile(
          key: ValueKey(key),
          index: i,
          icon: iconMap[key] ?? Iconsax.element_3,
          label: item['label'],
          isSelected: selectedKey == key,
          onTap: () {
            setState(() => selectedKey = key);
            html.window.history.pushState(null, '', '/$key');
            if (isMobile) Navigator.pop(context); // Close drawer on selection
          },
        );
      },
    );
  }

  Widget _buildModernTile({
    required Key key,
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.cyan.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? Colors.cyan.shade800 : Colors.blueGrey.shade600, size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.cyan.shade900 : Colors.blueGrey.shade700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              if (trailing != null) trailing,
              if (trailing == null)
                isSelected
                    ? Container(width: 5, height: 15, decoration: BoxDecoration(color: Colors.cyan, borderRadius: BorderRadius.circular(10)))
                    : ReorderableDragStartListener(index: index, child: Icon(Iconsax.grid_3, size: 14, color: Colors.grey.shade300)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableTile({
    required Key key,
    required int index,
    required IconData icon,
    required String label,
    required bool isMobile,
  }) {
    bool isChildSelected = selectedKey == 'pushnotification' || selectedKey == 'notification_history';

    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildModernTile(
          key: ValueKey('${key.toString()}_header'),
          index: index,
          icon: icon,
          label: label,
          isSelected: isChildSelected,
          trailing: Icon(
            isNotificationExpanded ? Iconsax.arrow_up_2 : Iconsax.arrow_down_1,
            size: 14,
            color: isChildSelected ? Colors.cyan.shade800 : Colors.blueGrey,
          ),
          onTap: () {
            setState(() {
              isNotificationExpanded = !isNotificationExpanded;
            });
          },
        ),
        if (isNotificationExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 32, bottom: 8),
            child: Column(
              children: [
                _buildSubTile(
                  label: "Send Notification",
                  isSelected: selectedKey == 'pushnotification',
                  onTap: () {
                    setState(() => selectedKey = 'pushnotification');
                    html.window.history.pushState(null, '', '/pushnotification');
                    if (isMobile) Navigator.pop(context);
                  },
                ),
                _buildSubTile(
                  label: "History",
                  isSelected: selectedKey == 'notification_history',
                  onTap: () {
                    setState(() => selectedKey = 'notification_history');
                    html.window.history.pushState(null, '', '/notification_history');
                    if (isMobile) Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSubTile({required String label, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.cyan.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.circle, size: 4, color: isSelected ? Colors.cyan : Colors.grey),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isSelected ? Colors.cyan.shade900 : Colors.blueGrey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const LogoutButton(),
    );
  }

  Widget _getContent(String key) {
    switch (key) {
      case 'home': return const HomePage();
      case 'events': return const Events();
      case 'giving': return const Giving();
      case 'apps': return const Apps();
      case 'user': return const UserPage();
      case 'organization': return const Organization();
      case 'applications': return const ApplicationPage();
      case 'pushnotification': return const PushNotification();
      case 'notification_history': return const MasterIntelligenceHub();
      case 'role': return const RolesPage();
      case 'profile': return const Profile();
      case 'media': return const MediaPage();
      case 'notification': return const NotificationPage();
      case 'sidebar': return const ManageSidebar();
      case 'navigation': return const NavigationFormPage();
      default:
        return Center(child: Text("Page $key not found", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)));
    }
  }
}