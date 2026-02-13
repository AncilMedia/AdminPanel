import 'package:flutter/material.dart';
import 'host_page.dart';
import 'viewer_page.dart';

class StartLivePage extends StatelessWidget {
  const StartLivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final roomCtrl = TextEditingController(text: 'live_test');
    final userCtrl = TextEditingController(text: 'user_${DateTime.now().millisecondsSinceEpoch}');

    return Scaffold(
      appBar: AppBar(title: const Text('Live Streaming')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: roomCtrl,
              decoration: const InputDecoration(labelText: 'Room ID'),
            ),
            TextField(
              controller: userCtrl,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => HostLivePage(
                    roomId: roomCtrl.text,
                    userId: userCtrl.text,
                  ),
                ));
              },
              child: const Text('Go Live'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => ViewerLivePage(
                    roomId: roomCtrl.text,
                    userId: userCtrl.text,
                  ),
                ));
              },
              child: const Text('Watch Live'),
            ),
          ],
        ),
      ),
    );
  }
}
