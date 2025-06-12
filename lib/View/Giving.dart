import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Sidebar.dart';


class Giving extends StatefulWidget {
  const Giving({super.key});

  @override
  State<Giving> createState() => _GivingState();
}

class _GivingState extends State<Giving> {
  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      drawer: isLargeScreen ? null : Container( ),
      body: Row(
        children: [
          // Sidebar on desktop
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
                "Giving",
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
