import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:http/http.dart' as http;

import '../../environmental variables.dart';

class HostLivePage extends StatefulWidget {
  final String roomId;
  final String userId;

  const HostLivePage({
    super.key,
    required this.roomId,
    required this.userId,
  });

  @override
  State<HostLivePage> createState() => _HostLivePageState();
}

class _HostLivePageState extends State<HostLivePage> {
  late Room room;
  bool connecting = true;

  static  String serverUrl = "$baseUrl";

  @override
  void initState() {
    super.initState();
    _connect();
  }

  Future<Map<String, dynamic>> _getToken() async {
    final res = await http.post(
      Uri.parse('$NgrokUrl/api/live/token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "roomName": widget.roomId,
        "userId": widget.userId,
        "isHost": true,
      }),
    );
    return jsonDecode(res.body);
  }

  Future<void> _connect() async {
    final tokenData = await _getToken();

    room = Room();

    await room.connect(
      tokenData['url'],
      tokenData['token'],
      roomOptions: const RoomOptions(adaptiveStream: true),
    );

    await room.localParticipant?.setCameraEnabled(true);
    await room.localParticipant?.setMicrophoneEnabled(true);

    setState(() => connecting = false);
  }

  @override
  void dispose() {
    room.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (connecting) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final videoTrack = room.localParticipant
        ?.videoTrackPublications
        .firstOrNull
        ?.track;

    return Scaffold(
      appBar: AppBar(title: const Text("You're Live 🔴")),
      body: Stack(
        children: [
          if (videoTrack != null)
            VideoTrackRenderer(videoTrack),
          _controls(),
        ],
      ),
    );
  }

  Widget _controls() {
    final local = room.localParticipant!;

    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(local.isMicrophoneEnabled()
                ? Icons.mic
                : Icons.mic_off),
            color: Colors.white,
            onPressed: () async {
              await local.setMicrophoneEnabled(!local.isMicrophoneEnabled());
              setState(() {});
            },
          ),
          const SizedBox(width: 20),
          IconButton(
            icon: Icon(local.isCameraEnabled()
                ? Icons.videocam
                : Icons.videocam_off),
            color: Colors.white,
            onPressed: () async {
              await local.setCameraEnabled(!local.isCameraEnabled());
              setState(() {});
            },
          ),
          const SizedBox(width: 20),
          IconButton(
            icon: const Icon(Icons.call_end),
            color: Colors.red,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
