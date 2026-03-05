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

// --- Page Imports (Ensure paths are correct) ---
import 'Home_page.dart';
import 'Events.dart';
import 'Giving.dart';
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

  final Map<String, IconData> iconMap = {
    'home': Iconsax.home,
    'events': Iconsax.book,
    // 'sermons': Iconsax.safe_home,
    'giving': Iconsax.wallet_money,
    'apps': Iconsax.element_3,
    'user': Iconsax.profile_2user,
    'organization': Iconsax.building,
    'applications': Iconsax.box_2,
    'pushnotification': Iconsax.notification_bing,
    'media': Iconsax.video,
    'notification': Iconsax.message_text,
    'role': Iconsax.smileys,
    'profile': Iconsax.profile_circle,
    'sidebar': Iconsax.element_2,
    'navigation': Iconsax.route_square,
  };

  @override
  void initState() {
    super.initState();
    selectedKey = widget.initialPage;
    _loadOrgData();
  }

  Future<void> _loadOrgData() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Check for the token
    final token = prefs.getString('accessToken'); // Replace 'token' with your actual key name

    if (token == null || token.isEmpty) {
      // 2. If token is missing, redirect to login
      _handleLogoutRedirect();
      return;
    }

    // Existing logic for loading data
    orgName = prefs.getString('organizationName') ?? 'Organization';
    role = prefs.getString('userRole') ?? 'user';
    orgImage = prefs.getString('orgImage');

    final sidebarController = Provider.of<SidebarController>(context, listen: false);
    if (role != null) {
      await sidebarController.fetchSidebarForRole(role!);
    }
    if (mounted) setState(() {});
  }

// Helper method to handle the transition
  void _handleLogoutRedirect() {
    // Clear any existing session data if necessary
    // SharedPreferences.getInstance().then((prefs) => prefs.clear());

    // Use Navigator to push the Login route and remove all previous routes
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage()));
  }
  // Future<void> _loadOrgData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   orgName = prefs.getString('organizationName') ?? 'Organization';
  //   role = prefs.getString('userRole') ?? 'user';
  //   orgImage = prefs.getString('orgImage');
  //
  //   final sidebarController = Provider.of<SidebarController>(context, listen: false);
  //   if (role != null) {
  //     await sidebarController.fetchSidebarForRole(role!);
  //   }
  //   if (mounted) setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final sidebarController = Provider.of<SidebarController>(context);
    final isDesktop = MediaQuery.of(context).size.width >= 1100;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Soft modern background
      appBar: isDesktop ? null : _buildMobileAppBar(sidebarController),
      body: Row(
        children: [
          // --- MODERN SIDEBAR ---
          if (isDesktop && selectedKey != "apps" && selectedKey != "media")
            _buildModernSidebar(sidebarController),

          // --- MAIN WORKSPACE ---
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
  }

  PreferredSizeWidget _buildMobileAppBar(SidebarController controller) {
    return AppBar(
      title: Text(
        controller.roleSidebarItems.firstWhere(
              (item) => item['key'] == selectedKey,
          orElse: () => {'label': 'Dashboard'},
        )['label'],
        style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.white,
      elevation: 0.5,
      iconTheme: const IconThemeData(color: Colors.black87),
    );
  }

  Widget _buildModernSidebar(SidebarController controller) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.18,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          _buildFloatingHeader(),
          const SizedBox(height: 24),
          Expanded(
            child: controller.isLoading
                ?  Center(child: Lottie.network("https://res.cloudinary.com/dggylwwqk/raw/upload/v1772002591/Weather_Wind_zdbufx.json"))
                : _buildSidebarList(controller),
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
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: orgImage != null
                  ? NetworkImage(orgImage!)
                  : const AssetImage('assets/favicon.png') as ImageProvider,
            ),
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

  Widget _buildSidebarList(SidebarController controller) {
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
        final isSelected = selectedKey == key;

        return _buildModernTile(
          key: ValueKey(key),
          index: i,
          icon: iconMap[key] ?? Iconsax.element_3,
          label: item['label'],
          isSelected: isSelected,
          onTap: () {
            setState(() => selectedKey = key);
            html.window.history.pushState(null, '', '/$key');
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
              if (!isSelected)
                ReorderableDragStartListener(
                  index: index,
                  child: Icon(Iconsax.grid_3, size: 14, color: Colors.grey.shade300),
                )
              else
                Container(
                  width: 5,
                  height: 15,
                  decoration: BoxDecoration(color: Colors.cyan, borderRadius: BorderRadius.circular(10)),
                ),
            ],
          ),
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
      // case 'sermons': return const Sermons();
      case 'giving': return const Giving();
      case 'apps': return const Apps();
      case 'user': return const UserPage();
      case 'organization': return const Organization();
      case 'applications': return const ApplicationPage();
      case 'pushnotification': return const PushNotification();
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

// Ensure the SidebarsubProvider is managed via your main.dart provider list.
class SidebarsubProvider extends ChangeNotifier {
  String? _selectedKey;
  String? get selectedKey => _selectedKey;

  void selectItem(String key) {
    _selectedKey = key;
    notifyListeners();
  }
}