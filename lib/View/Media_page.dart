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
    final isLargeScreen = MediaQuery.of(context).size.width >= 1100;

    return Scaffold(
      appBar: isLargeScreen
          ? null
          : AppBar(
        title: Text(titles[selectedIndex]),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Row(
        children: [
          if (isLargeScreen)
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              backgroundColor: Colors.grey.shade100,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Iconsax.message_edit),
                  label: Text("Library"),
                ),
                NavigationRailDestination(
                  icon: Icon(Iconsax.video),
                  label: Text("Live"),
                ),
                NavigationRailDestination(
                  icon: Icon(Iconsax.microphone),
                  label: Text("Podcast"),
                ),
                NavigationRailDestination(
                  icon: Icon(Iconsax.music),
                  label: Text("Music"),
                ),
                NavigationRailDestination(
                  icon: Icon(Iconsax.chart),
                  label: Text("Analytics"),
                ),
              ],
            ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: pages[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}


