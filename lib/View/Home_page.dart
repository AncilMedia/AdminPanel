import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'Sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double sidebarWidth = 250;

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: isLargeScreen ? null : AppBar(title: const Text("Home")),
      body: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Lottie.asset('assets/no_data.json')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
