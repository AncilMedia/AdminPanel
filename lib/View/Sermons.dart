import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Lottie.network('https://res.cloudinary.com/dggylwwqk/raw/upload/v1749729389/gift_bktmqy.json')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
