import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("📊 Analytics Page", style: GoogleFonts.poppins(fontSize: 22)),
    );
  }
}