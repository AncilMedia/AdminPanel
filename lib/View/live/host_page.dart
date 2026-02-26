import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:http/http.dart' as http;

class HostLivePage extends StatefulWidget {
  const HostLivePage({super.key});

  @override
  State<HostLivePage> createState() => _HostLivePageState();
}

class _HostLivePageState extends State<HostLivePage> {
  Room? _room;
  VideoTrack? _localVideoTrack;

  bool connecting = false;

  /// 🔹 Your LiveKit Cloud URL
  final String wsUrl = "wss://newproject-cglk7fdw.livekit.cloud";

  /// 🔹 Your backend API (use LAN IP, not localhost, if on device)
  final String tokenApi = "https://5208-116-68-72-131.ngrok-free.app/token";

  Future<String> getToken() async {
    final res = await http.post(
      Uri.parse(tokenApi),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "room": "live-room",
        "identity": "host",
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Token API failed: ${res.body}");
    }

    final data = jsonDecode(res.body);
    return data['token'];
  }

  Future<void> startLive() async {
    setState(() => connecting = true);

    final token = await getToken();

    _room = Room();

    await _room!.connect(wsUrl, token);

    await _room!.localParticipant!.setCameraEnabled(true);
    await _room!.localParticipant!.setMicrophoneEnabled(true);

    final videoPub =
        _room!.localParticipant!.videoTrackPublications.first;

    _localVideoTrack = videoPub.track as VideoTrack;

    setState(() => connecting = false);
  }

  @override
  void dispose() {
    _room?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🎥 Host Live")),
      body: Column(
        children: [
          Expanded(
            child: _localVideoTrack != null
                ? VideoTrackRenderer(_localVideoTrack!)
                : const Center(child: Text("Camera Preview")),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: connecting ? null : startLive,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: connecting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("START LIVE"),
            ),
          )
        ],
      ),
    );
  }
}