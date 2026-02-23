import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'Media_Analytics_page.dart';
import 'Media_Library_page.dart';
import 'Media_Music_page.dart';
import 'Media_live_page.dart';
import 'Media_podcast_page.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  int selectedIndex = 0;
  final TextStyle baseStyle = GoogleFonts.poppins();

  final List<String> titles = ["Library", "Live", "Podcast", "Music", "Analytics"];

  final List<Widget> pages = const [
    LibraryPage(),
    LivePage(),
    PodcastPage(),
    MusicPage(),
    AnalyticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isLargeScreen = size.width >= 1100;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      // Mobile AppBar
      appBar: isLargeScreen
          ? null
          : AppBar(
        title: Text(titles[selectedIndex],
            style: baseStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Row(
        children: [
          if (isLargeScreen) _buildModernSidebar(),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                        begin: const Offset(0.02, 0),
                        end: Offset.zero
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: pages[selectedIndex],
            ),
          ),
        ],
      ),
      // Mobile Bottom Nav
      bottomNavigationBar: isLargeScreen ? null : _buildBottomNav(),
    );
  }

  // --- 1. MODERN VERTICAL SIDEBAR (Desktop) ---
  Widget _buildModernSidebar() {
    return Container(
      width: 100, // Compact but elegant
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Logo Area
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.indigo, Colors.purple]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Iconsax.video_play, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 48),

          // Navigation Items
          _sidebarItem(0, Iconsax.message_edit, "Library"),
          _sidebarItem(1, Iconsax.video, "Live"),
          _sidebarItem(2, Iconsax.microphone, "Podcast"),
          _sidebarItem(3, Iconsax.music, "Music"),
          _sidebarItem(4, Iconsax.chart, "Stats"),

          const Spacer(),
          // Bottom Action (Settings/Logout)
          // _sidebarItem(99, Iconsax.setting_2, "Settings"),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sidebarItem(int index, IconData icon, String label) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.indigo.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.indigo : Colors.blueGrey.shade300,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(label,
                style: baseStyle.copyWith(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.indigo : Colors.blueGrey.shade300,
                )
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. MODERN BOTTOM NAV (Mobile) ---
  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(0, Iconsax.message_edit),
          _navItem(1, Iconsax.video),
          _navItem(2, Iconsax.microphone),
          _navItem(3, Iconsax.music),
          _navItem(4, Iconsax.chart),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon) {
    bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => selectedIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.indigo : Colors.blueGrey.shade200),
          const SizedBox(height: 4),
          if (isSelected)
            Container(height: 4, width: 4, decoration: const BoxDecoration(color: Colors.indigo, shape: BoxShape.circle)),
        ],
      ),
    );
  }
}