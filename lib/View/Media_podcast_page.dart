import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PodcastPage extends StatelessWidget {
  const PodcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("🎙️ Podcast Page", style: GoogleFonts.poppins(fontSize: 22)),
    );
  }
}

