import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

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

// 📄 Individual Page Widgets

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * .2,
        right: MediaQuery.of(context).size.width * .1,
        top: MediaQuery.of(context).size.height * .0500,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bulk Edit Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Iconsax.bookmark, color: Colors.blue, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Save time and add tags to your media library in bulk",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Make the most of your media and get your entire media library tagged with topics,\nscripture, and speakers quickly with Bulk Edit.",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .0400,
                      width: MediaQuery.of(context).size.width * .0700,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black12),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "Get started",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Iconsax.close_circle),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Upload Component
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Iconsax.add_circle, color: Colors.green, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Upload a video or audio file to create a Media item",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Add file picker logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Upload",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LivePage extends StatelessWidget {
  const LivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Live Page", style: GoogleFonts.poppins(fontSize: 22)),
    );
  }
}

class PodcastPage extends StatelessWidget {
  const PodcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("🎙️ Podcast Page", style: GoogleFonts.poppins(fontSize: 22)),
    );
  }
}

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("🎵 Music Page", style: GoogleFonts.poppins(fontSize: 22)),
    );
  }
}

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("📊 Analytics Page", style: GoogleFonts.poppins(fontSize: 22)),
    );
  }
}
