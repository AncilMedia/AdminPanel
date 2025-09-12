import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("🎵 Music Page", style: GoogleFonts.poppins(fontSize: 22)),
    );
  }
}

