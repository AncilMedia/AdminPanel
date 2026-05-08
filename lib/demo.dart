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




import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';

// Ensure these match your local project structure
import '../Controller/Get_all_item_controller.dart';
import '../Model/Item_Model.dart';
import 'View/PopUp/Right_drawer.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<ItemModel> manualEvents = [];
  List<ItemModel> syncedEventsData = [];
  List<Map<String, dynamic>> syncedSources = [];

  bool isLoading = true;
  int activeTab = 0;
  Map<String, dynamic>? selectedSource;
  int currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _loadManualEvents();
  }

  Future<void> _loadManualEvents() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final allItems = await ItemService.fetchItems();
      if (mounted) {
        setState(() {
          manualEvents = allItems.where((e) => e.type == 'event').toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showImportDialog() {
    final TextEditingController urlController = TextEditingController();
    int dialogTab = 0;
    PlatformFile? pickedFile;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            title: Text("Connect Calendar", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildToggle(dialogTab, (v) => setDialogState(() => dialogTab = v)),
                const SizedBox(height: 25),
                if (dialogTab == 0)
                  TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintText: "Paste .ics URL link",
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      prefixIcon: const Icon(Iconsax.link, color: Color(0xFF00C2D1)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    ),
                  )
                else
                  InkWell(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['ics'],
                        withData: true,
                      );
                      if (result != null) setDialogState(() => pickedFile = result.files.first);
                    },
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(pickedFile == null ? Iconsax.document_upload : Iconsax.document_text, color: const Color(0xFF00C2D1)),
                          const SizedBox(height: 10),
                          Text(pickedFile == null ? "Select .ics File" : pickedFile!.name, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C2D1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  setState(() => isLoading = true);
                  String content = "";
                  try {
                    if (dialogTab == 0 && urlController.text.isNotEmpty) {
                      final proxyUrl = "https://corsproxy.io/?${Uri.encodeComponent(urlController.text.trim())}";
                      final response = await http.get(Uri.parse(proxyUrl));
                      if (response.statusCode == 200) content = response.body;
                    } else if (dialogTab == 1 && pickedFile != null) {
                      content = String.fromCharCodes(pickedFile!.bytes!);
                    }

                    if (content.contains('BEGIN:VCALENDAR')) {
                      final calendar = ICalendar.fromString(content);
                      List<ItemModel> parsed = [];
                      for (var entry in calendar.data) {
                        if (entry['type'] == 'VEVENT') {
                          IcsDateTime? dt = entry['dtstart'];
                          parsed.add(ItemModel(
                            id: entry['uid']?.toString() ?? UniqueKey().toString(),
                            title: entry['summary']?.toString() ?? 'Busy',
                            startDateTime: dt?.toDateTime()?.toIso8601String(),
                            type: 'event',
                          ));
                        }
                      }
                      setState(() {
                        syncedSources.add({'title': dialogTab == 0 ? "Cloud Sync" : pickedFile!.name, 'url': urlController.text, 'events': parsed});
                        syncedEventsData = parsed;
                        selectedSource = syncedSources.last;
                        activeTab = 1;
                        isLoading = false;
                      });
                    }
                  } catch (e) {
                    debugPrint("Sync Error: $e");
                  }
                  setState(() => isLoading = false);
                  Navigator.pop(context);
                },
                child: const Text("Import"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1100;

    return Scaffold(
      endDrawer: CustomRightDrawer(
        isInSublist: false,
        initialSelection: DrawerSelection.event,
        onAddItemToHome: (newItem) => _loadManualEvents(),
      ),
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildSpaciousHeader(),
          _buildPremiumTabs(),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 50 : 20, vertical: 20),
            sliver: isLoading ? _buildShimmer(isDesktop) : _buildBodyContent(isDesktop),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent(bool isDesktop) {
    if (selectedSource != null) return _buildModernYearlyCalendar(isDesktop);
    return activeTab == 0 ? _buildManualGrid(isDesktop) : _buildSyncedSourcesGrid(isDesktop);
  }

  Widget _buildSpaciousHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(50, 60, 50, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedSource != null ? selectedSource!['title'] : "Organization Events",
                  style: GoogleFonts.plusJakartaSans(fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1, color: const Color(0xFF1E293B)),
                ),
                const SizedBox(height: 6),
                _statusPill("Overview • ${activeTab == 0 ? manualEvents.length : syncedSources.length} items found"),
              ],
            ),
            if (selectedSource != null)
              _circularActionBtn(Iconsax.close_circle, Colors.redAccent, () => setState(() => selectedSource = null))
            else
              Row(
                children: [
                  _mainBtn(Iconsax.import, "Sync ICS", Colors.orange.shade600, _showImportDialog),
                  const SizedBox(width: 15),
                  _mainBtn(Iconsax.add, "Add Event", const Color(0xFF00C2D1), () => scaffoldKey.currentState?.openEndDrawer(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumTabs() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        child: Row(children: [_tabItem(0, "Manual"), const SizedBox(width: 40), _tabItem(1, "Synced Sources")]),
      ),
    );
  }

  Widget _buildManualGrid(bool isDesktop) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 4 : 1,
        mainAxisSpacing: 30,
        crossAxisSpacing: 30,
        childAspectRatio: 0.85,
      ),
      delegate: SliverChildBuilderDelegate((context, index) => _buildEventCard(manualEvents[index]), childCount: manualEvents.length),
    );
  }

  Widget _buildEventCard(ItemModel item) {
    DateTime? date = DateTime.tryParse(item.startDateTime ?? "");
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    image: (item.image != null) ? DecorationImage(image: NetworkImage(item.image!), fit: BoxFit.cover) : null,
                    color: const Color(0xFFF1F5F9),
                  ),
                ),
                Positioned(top: 25, left: 25, child: _buildDateBadge(date)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 5, 25, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18, color: const Color(0xFF1E293B))),
                const SizedBox(height: 10),
                _rowDetail(Iconsax.clock, date != null ? DateFormat('hh:mm a').format(date) : "--:--"),
                _rowDetail(Iconsax.location, "Event Location"),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(color: Color(0xFFF1F5F9))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Manage Event", style: GoogleFonts.plusJakartaSans(color: const Color(0xFF007BFF), fontWeight: FontWeight.w700, fontSize: 13)),
                    Row(children: [const Icon(Iconsax.edit, size: 20, color: Colors.green), const SizedBox(width: 15), const Icon(Iconsax.trash, size: 20, color: Colors.redAccent)])
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncedSourcesGrid(bool isDesktop) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 3 : 1, mainAxisSpacing: 25, crossAxisSpacing: 25, childAspectRatio: 2.2),
      delegate: SliverChildBuilderDelegate((context, index) => _buildSourceTile(syncedSources[index]), childCount: syncedSources.length),
    );
  }

  Widget _buildSourceTile(Map<String, dynamic> source) {
    return InkWell(
      onTap: () => setState(() { selectedSource = source; syncedEventsData = List<ItemModel>.from(source['events']); }),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(18)), child: const Icon(Iconsax.link, color: Colors.orange, size: 28)),
            const SizedBox(width: 20),
            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(source['title'], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18)), const SizedBox(height: 4), Text(source['url'], maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 12))])),
            const Icon(Iconsax.arrow_right_3, color: Color(0xFF00C2D1)),
          ],
        ),
      ),
    );
  }

  Widget _buildModernYearlyCalendar(bool isDesktop) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 3 : 1, mainAxisSpacing: 40, crossAxisSpacing: 40, childAspectRatio: 0.75),
      delegate: SliverChildBuilderDelegate((context, index) => _buildCalendarMonthCard(index + 1), childCount: 12),
    );
  }

  Widget _buildCalendarMonthCard(int month) {
    final monthName = DateFormat('MMMM').format(DateTime(currentYear, month));
    final daysInMonth = DateTime(currentYear, month + 1, 0).day;
    final firstDay = DateTime(currentYear, month, 1).weekday % 7;

    final List<String> dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF00C2D1).withOpacity(0.05),
                blurRadius: 30,
                offset: const Offset(0, 15)
            )
          ]
      ),
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(25),
              child: Text(
                  monthName,
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 20, color: const Color(0xFF1E293B))
              )
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                bool isSunday = index == 0;
                return Expanded(
                  child: Center(
                    child: Text(
                      dayLabels[index],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isSunday ? Colors.redAccent : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(15),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 0.8,
              ),
              itemCount: daysInMonth + firstDay,
              itemBuilder: (context, index) {
                if (index < firstDay) return const SizedBox();
                int day = index - firstDay + 1;
                bool isSunday = index % 7 == 0;

                final dayEvents = syncedEventsData.where((e) {
                  final d = DateTime.tryParse(e.startDateTime ?? "");
                  return d?.year == currentYear && d?.month == month && d?.day == day;
                }).toList();

                bool hasEvent = dayEvents.isNotEmpty;
                String fullTitle = hasEvent ? dayEvents.first.title : "";

                return Tooltip(
                  message: hasEvent ? fullTitle : "$monthName $day",
                  verticalOffset: 20,
                  preferBelow: false,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: HoverMagnifier(
                    hasEvent: hasEvent,
                    isSunday: isSunday,
                    day: day,
                    eventTitle: fullTitle,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
    );
  }

  Widget _tabItem(int index, String label) {
    bool isSelected = activeTab == index;
    return GestureDetector(
      onTap: () => setState(() { activeTab = index; selectedSource = null; }),
      child: Column(children: [
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500, color: isSelected ? const Color(0xFF1E293B) : Colors.grey)),
        const SizedBox(height: 8),
        AnimatedContainer(duration: const Duration(milliseconds: 300), height: 4, width: isSelected ? 30 : 0, decoration: BoxDecoration(color: const Color(0xFF00C2D1), borderRadius: BorderRadius.circular(10))),
      ]),
    );
  }

  Widget _buildToggle(int current, Function(int) onChange) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Expanded(child: _toggleItem("URL Link", current == 0, () => onChange(0))),
        Expanded(child: _toggleItem("Local File", current == 1, () => onChange(1))),
      ]),
    );
  }

  Widget _toggleItem(String label, bool s, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: s ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(10), boxShadow: s ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : null),
        child: Center(child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: s ? const Color(0xFF00C2D1) : Colors.grey))),
      ),
    );
  }

  Widget _buildDateBadge(DateTime? date) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.white.withOpacity(0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(date != null ? DateFormat('dd').format(date) : "01", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 18, color: const Color(0xFF1E293B))),
              Text(date != null ? DateFormat('MMM').format(date).toUpperCase() : "MAY", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 11, color: const Color(0xFF00C2D1))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap, icon: Icon(icon, size: 20), label: Text(label),
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
    );
  }

  Widget _rowDetail(IconData icon, String label) {
    return Row(children: [Icon(icon, size: 16, color: const Color(0xFF00C2D1)), const SizedBox(width: 10), Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF64748B), fontWeight: FontWeight.w500))]);
  }

  Widget _circularActionBtn(IconData icon, Color color, VoidCallback onTap) => IconButton(onPressed: onTap, icon: Icon(icon, color: color, size: 34));

  Widget _buildShimmer(bool isDesktop) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 4 : 1, mainAxisSpacing: 30, crossAxisSpacing: 30, childAspectRatio: 0.8),
      delegate: SliverChildBuilderDelegate((context, index) => Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.white, child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)))), childCount: 8),
    );
  }
}

class HoverMagnifier extends StatefulWidget {
  final bool hasEvent;
  final bool isSunday;
  final int day;
  final String eventTitle;

  const HoverMagnifier({
    super.key,
    required this.hasEvent,
    required this.isSunday,
    required this.day,
    required this.eventTitle,
  });

  @override
  State<HoverMagnifier> createState() => _HoverMagnifierState();
}

class _HoverMagnifierState extends State<HoverMagnifier> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: isHovered ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isHovered
                ? const Color(0xFF00C2D1).withOpacity(0.2)
                : (widget.hasEvent ? const Color(0xFF00C2D1).withOpacity(0.1) : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isHovered || widget.hasEvent
                    ? const Color(0xFF00C2D1).withOpacity(0.3)
                    : Colors.transparent
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.day}",
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: widget.hasEvent
                        ? const Color(0xFF00C2D1)
                        : (widget.isSunday ? Colors.redAccent : const Color(0xFF64748B))
                ),
              ),
              if (widget.hasEvent)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    widget.eventTitle,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00C2D1),
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