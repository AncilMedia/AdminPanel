import 'package:flutter/material.dart';

class TvApps extends StatefulWidget {
  const TvApps({super.key});

  @override
  State<TvApps> createState() => _TvAppsState();
}

class _TvAppsState extends State<TvApps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Tv Apps")
        ],
      ),
    );
  }
}
