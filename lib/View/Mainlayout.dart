import 'package:ancilmediaadminpanel/View/User.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../Controller/Profile_controller.dart';
import '../View/Home_page.dart';
import '../View/Events.dart';
import '../View/Giving.dart';
import '../View/Sermons.dart';
import '../View/Apps_page/Apps.dart';
import '../View_model/Drawer_provider.dart';
import '../View_model/Sidebar_provider.dart';
import '../View_model/Logout.dart';
import 'Profile_page.dart';
import '../Services/api_client.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String orgName = 'Loading...';
  String? orgImage;
  ProfileController? _controller;

  @override
  void initState() {
    super.initState();
    loadOrgInfo();
  }

  void loadOrgInfo() async {
    final apiClient = Provider.of<ApiClient>(context, listen: false);
    final controller = ProfileController(apiClient);
    final data = await controller.fetchProfile();
    if (data != null) {
      setState(() {
        orgName = data['username'] ?? 'Unknown';
        orgImage = data['image'];
      });
    }
  }

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
      case DrawerItem.profile:
        return const Profile();
      default:
        return const HomePage();
    }
  }

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
      case DrawerItem.profile:
        return 'Profile';
      default:
        return 'Ancil Media';
    }
  }

  Widget _buildDrawerTile(BuildContext context, IconData icon, String label, DrawerItem item, bool isDesktop) {
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
          Provider.of<SubDrawerProvider>(context, listen: false).selectItem(SubDrawerItem.mobile);
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
        ],
      ),
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context, bool isDesktop) {
    return [
      _buildCurvedDrawerHeader(context),
      _buildDrawerTile(context, Iconsax.home, 'Home', DrawerItem.home, isDesktop),
      _buildDrawerTile(context, Iconsax.book, 'Events', DrawerItem.events, isDesktop),
      _buildDrawerTile(context, Iconsax.safe_home, 'Sermons', DrawerItem.sermons, isDesktop),
      _buildDrawerTile(context, Iconsax.wallet_money, 'Giving', DrawerItem.giving, isDesktop),
      _buildDrawerTile(context, Iconsax.element_3, 'Apps', DrawerItem.apps, isDesktop),
      _buildDrawerTile(context, Iconsax.profile_2user, 'User', DrawerItem.user, isDesktop),
      _buildDrawerTile(context, Iconsax.profile_circle, 'Settings', DrawerItem.profile, isDesktop),
      const Spacer(),
      Container(
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
      ),
    ];
  }

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
        child: ListView(children: _buildDrawerItems(context, isDesktop)),
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
                child: Column(children: _buildDrawerItems(context, isDesktop)),
              ),
            ),
          Expanded(child: _getContent(selectedItem)),
        ],
      ),
    );
  }
}
