import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import 'environmental variables.dart';

class LiveStreamPanel extends StatefulWidget {
  const LiveStreamPanel({super.key});

  @override
  State<LiveStreamPanel> createState() => _LiveStreamPanelState();
}

class _LiveStreamPanelState extends State<LiveStreamPanel> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  bool isLive = false;
  bool loading = false;
  Timer? _statusTimer;

  final headers = const {
    "Accept": "application/json",
  };

  @override
  void initState() {
    super.initState();
    _checkStatus();
    _statusTimer =
        Timer.periodic(const Duration(seconds: 5), (_) => _checkStatus());
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _disposePlayer();
    super.dispose();
  }

  Future<void> _startStream() async {
    setState(() => loading = true);
    await http.post(Uri.parse("$NgrokUrl/api/stream/start"), headers: headers);
    await Future.delayed(const Duration(seconds: 2));
    await _checkStatus();
    setState(() => loading = false);
  }

  Future<void> _stopStream() async {
    setState(() => loading = true);
    await http.post(Uri.parse("$NgrokUrl/api/stream/stop"), headers: headers);
    await Future.delayed(const Duration(seconds: 2));
    await _checkStatus();
    setState(() => loading = false);
  }

  Future<void> _checkStatus() async {
    try {
      final res = await http.get(
        Uri.parse("$NgrokUrl/api/stream/status"),
        headers: headers,
      );

      final data = json.decode(res.body);
      final bool live = data["running"] ?? false;

      if (live != isLive) {
        isLive = live;
        if (live) {
          await _startPlayer();
        } else {
          _disposePlayer();
        }
        if (mounted) setState(() {});
      }
    } catch (_) {
      if (isLive) {
        isLive = false;
        _disposePlayer();
        if (mounted) setState(() {});
      }
    }
  }

  Future<void> _startPlayer() async {
    _disposePlayer();

    _videoController = VideoPlayerController.network(
      "$NgrokUrl/hls/stream.m3u8",
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    await _videoController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: true,
      allowFullScreen: true,
      allowPlaybackSpeedChanging: false,
      showControls: true,
    );
  }

  void _disposePlayer() {
    try {
      _chewieController?.pause();
      _videoController?.pause();
    } catch (_) {}

    _chewieController?.dispose();
    _videoController?.dispose();

    _chewieController = null;
    _videoController = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🎥 Live Stream")),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: isLive || loading ? null : _startStream,
                child: const Text("Start"),
              ),
              ElevatedButton(
                onPressed: !isLive || loading ? null : _stopStream,
                child: const Text("Stop"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: isLive && _chewieController != null
                ? Chewie(controller: _chewieController!)
                : const Center(child: Text("📡 Stream Offline")),
          )
        ],
      ),
    );
  }
}
