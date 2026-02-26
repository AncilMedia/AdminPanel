import 'package:flutter/material.dart';
import 'host_page.dart';
import 'viewer_page.dart';

class RoleSelectPage extends StatelessWidget {
  const RoleSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Go Live (Host)"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const HostLivePage()));
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Join Live (Viewer)"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewerLivePage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
