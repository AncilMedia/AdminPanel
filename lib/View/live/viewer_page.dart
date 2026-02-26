import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ViewerLivePage extends StatefulWidget {
  const ViewerLivePage({super.key});

  @override
  State<ViewerLivePage> createState() => _ViewerLivePageState();
}

class _ViewerLivePageState extends State<ViewerLivePage> {
  VideoPlayerController? _controller;

  final String hlsUrl =
      "https://5208-116-68-72-131.ngrok-free.app/livekit/hls/live-room/index.m3u8";

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(hlsUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Watch Live")),
      body: Center(
        child: _controller != null && _controller!.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
}