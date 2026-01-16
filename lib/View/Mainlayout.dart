import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;
import '../Controller/Sidebar_controller.dart';
import '../View/Login_page.dart';
import 'Home_page.dart';
import 'Events.dart';
import 'Giving.dart';
import 'Navigation_screen.dart';
import 'Notifications/notification_bell.dart';
import 'Sermons.dart';
import 'Apps_page/Apps.dart';
import 'User.dart';
import 'Organization.dart';
import 'Application_page.dart';
import 'Pushnotification.dart';
import 'Role.dart';
import 'Profile_page.dart';
import 'Media_page.dart';
import 'Notifications/Notification_page.dart';
import 'Sidebar_Manger.dart';
import '../View_model/side_navbar_drawer.dart';
import '../View_model/Logout.dart';
import '../View_model/Notification_dropdown_state.dart';

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
    'media': Iconsax.video,
    'notification': Iconsax.message_text,
    'role': Iconsax.smileys,
    'profile': Iconsax.profile_circle,
    'sidebar': Iconsax.element_2,
    'navigation': Iconsax.route_square,
  };

  late String selectedKey;

  @override
  void initState() {
    super.initState();
    selectedKey = widget.initialPage;
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

    return Scaffold(
      appBar: MediaQuery.of(context).size.width >= 1100
          ? null
          : AppBar(
        title: Text(
          sidebarController.roleSidebarItems
              .firstWhere(
                (item) => item['key'] == selectedKey,
            orElse: () => {'label': 'Loading...'},
          )['label'] ??
              '',
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
          // Sidebar
          if (MediaQuery.of(context).size.width >= 1100 &&
              selectedKey != "apps" &&
              selectedKey != "media")
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
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
          // Main content
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
                  textStyle:
                  const TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
          if (role == 'admin') const NotificationIconDropdown(),
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

        for (int i = 0; i < sidebarController.roleSidebarItems.length; i++) {
          sidebarController.roleSidebarItems[i]["order"] = i + 1;
        }

        if (role != null) {
          await sidebarController
              .reorderSidebar(sidebarController.roleSidebarItems);
        }
        setState(() {});
      },
      children: [
        for (int i = 0; i < sidebarController.roleSidebarItems.length; i++)
          ListTile(
            key: ValueKey(sidebarController.roleSidebarItems[i]['key']),
            leading: Icon(
              iconMap[sidebarController.roleSidebarItems[i]['key']] ??
                  Iconsax.element_3,
            ),
            title: Text(sidebarController.roleSidebarItems[i]['label']),
            trailing: ReorderableDragStartListener(
              index: i,
              child: const Icon(Iconsax.activity),
            ),
            // onTap: () {
            //   final key = sidebarController.roleSidebarItems[i]['key'];
            //   provider.selectItem(key);
            //   setState(() => selectedKey = key);
            //
            //   // ✅ Only update the browser URL without navigating
            //   final uri = Uri(path: '/$key');
            //   GoRouter.of(context).routerDelegate.setNewRoutePath(uri);
            // },
            onTap: () {
              final key = sidebarController.roleSidebarItems[i]['key'];
              provider.selectItem(key);
              setState(() => selectedKey = key);

              // ✅ Update the browser URL without navigating
              html.window.history.pushState(null, '', '/$key');
            },

          ),
      ],
    );
  }

  Widget _getContent(String key) {
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
      case 'media':
        return const MediaPage();
      case 'notification':
        return const NotificationPage();
      case 'sidebar':
        return const ManageSidebar();
      case 'navigation' :
        return const NavigationFormPage();
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
