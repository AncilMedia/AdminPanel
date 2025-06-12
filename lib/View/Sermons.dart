import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Sidebar.dart';

class Sermons extends StatefulWidget {
  const Sermons({super.key});

  @override
  State<Sermons> createState() => _SermonsState();
}

class _SermonsState extends State<Sermons> {
  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      drawer: isLargeScreen ? null : Container(),
      body: Row(
        children: [
          // // Sidebar on desktop
          // if (isLargeScreen)
          //   SizedBox(
          //     width: 250,
          //     child: AppSidebar(),
          //   ),
          //
          // // Main content
          Expanded(
            child: Center(
              child: Text(
                "Sermons",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
