import 'dart:convert';
import 'package:ancilmediaadminpanel/environmental%20variables.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:http/http.dart' as http;

class ViewerLivePage extends StatefulWidget {
  final String roomId;
  final String userId;

  const ViewerLivePage({
    super.key,
    required this.roomId,
    required this.userId,
  });

  @override
  State<ViewerLivePage> createState() => _ViewerLivePageState();
}

class _ViewerLivePageState extends State<ViewerLivePage> {
  late Room room;
  bool connecting = true;
  late EventsListener<RoomEvent> _listener;

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
        "isHost": false,
      }),
    );
    return jsonDecode(res.body);
  }

  Future<void> _connect() async {
    final tokenData = await _getToken();

    room = Room();

    _listener = room.createListener();
    _listener.listen((event) {
      if (mounted) setState(() {});
    });

    await room.connect(
      tokenData['url'],
      tokenData['token'],
      roomOptions: const RoomOptions(adaptiveStream: true),
    );

    setState(() => connecting = false);
  }

  @override
  void dispose() {
    _listener.dispose();
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

    final participants = room.remoteParticipants.values.toList();

    if (participants.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Waiting for host...")),
      );
    }

    final videoTrack = participants
        .first
        .videoTrackPublications
        .firstOrNull
        ?.track;

    if (videoTrack == null) {
      return const Scaffold(
        body: Center(child: Text("No video yet")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Live Stream")),
      body: VideoTrackRenderer(videoTrack),
    );
  }
}
