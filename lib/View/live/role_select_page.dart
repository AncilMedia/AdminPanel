// import 'package:flutter/material.dart';
// import 'host_page.dart';
// import 'viewer_page.dart';
//
// class RoleSelectPage extends StatelessWidget {
//   const RoleSelectPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Live App")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               child: const Text("Go Live (Host)"),
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (_) => const HostLivePage()));
//               },
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               child: const Text("Join Live (Viewer)"),
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewerLivePage()));
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../../environmental variables.dart';


class LiveHostingPanel extends StatefulWidget {
  const LiveHostingPanel({super.key});

  @override
  State<LiveHostingPanel> createState() => _LiveHostingPanelState();
}

class _LiveHostingPanelState extends State<LiveHostingPanel> {
  RtcEngine? _engine;
  bool _isJoined = false;
  bool _isBroadcasting = false;
  bool _isEngineReady = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }
// Helper function to get token from your Node backend
  Future<String> fetchToken(String channelName, int uid, String role) async {
    // Replace with your actual backend URL (e.g., from your environmental variables)
    final url = Uri.parse('$baseUrl/api/agora/token');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "channelName": channelName,
        "uid": uid,
        "role": role, // For this panel, we use 'publisher'
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      debugPrint("Token Server Error: ${response.body}");
      throw Exception('Failed to load token');
    }
  }

  // Future<void> toggleBroadcast() async {
  //   if (_isBroadcasting) {
  //     await _engine?.leaveChannel();
  //     setState(() => _isBroadcasting = false);
  //   } else {
  //     try {
  //       // 1. WAKE UP THE CAMERA
  //       await _engine?.enableLocalVideo(true);
  //       await _engine?.startPreview();
  //
  //       // 2. FETCH DYNAMIC TOKEN AS PUBLISHER
  //       // Using uid: 0 is fine, Agora will return the assigned UID in the success callback
  //       String dynamicToken = await fetchToken("new_key", 0, 'publisher');
  //
  //       // 3. JOIN THE CHANNEL WITH THE NEW TOKEN
  //       await _engine?.joinChannel(
  //         token: dynamicToken, // Changed from TempAgoraId
  //         channelId: "new_key",
  //         uid: 0,
  //         options: const ChannelMediaOptions(
  //           publishCameraTrack: true,
  //           publishMicrophoneTrack: true,
  //           clientRoleType: ClientRoleType.clientRoleBroadcaster,
  //         ),
  //       );
  //
  //       setState(() => _isBroadcasting = true);
  //     } catch (e) {
  //       debugPrint("Failed to start broadcast: $e");
  //       // Show a snackbar or alert to the user
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Error: Could not connect to token server")),
  //       );
  //     }
  //   }
  // }
  // Future<void> initAgora() async {
  //   // 1. WEB DELAY: Give the browser 1 second to register the 'Iris' JS object
  //   if (kIsWeb) {
  //     await Future.delayed(const Duration(milliseconds: 1000));
  //   } else {
  //     await [Permission.microphone, Permission.camera].request();
  //   }
  //
  //   try {
  //     // 2. Initialize Engine
  //     _engine = createAgoraRtcEngine();
  //     await _engine!.initialize(RtcEngineContext(appId: AgoraId));
  //
  //     _engine!.registerEventHandler(
  //       RtcEngineEventHandler(
  //         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
  //           debugPrint("Live channel joined: ${connection.channelId}");
  //           if (mounted) setState(() => _isJoined = true);
  //         },
  //         onLeaveChannel: (connection, stats) {
  //           if (mounted) setState(() => _isJoined = false);
  //         },
  //         onError: (err, msg) {
  //           debugPrint("Agora Error: $err - $msg");
  //         },
  //       ),
  //     );
  //
  //     // 3. System Configuration for Live Hosting
  //     await _engine!.enableVideo();
  //     await _engine!.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
  //     await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
  //
  //     if (mounted) setState(() => _isEngineReady = true);
  //
  //   } catch (e) {
  //     debugPrint("Agora Setup Failed: $e");
  //   }
  // }

  // ... inside _LiveHostingPanelState ...

  Future<void> initAgora() async {
    if (kIsWeb) {
      await Future.delayed(const Duration(milliseconds: 1000));
    } else {
      await [Permission.microphone, Permission.camera].request();
    }

    try {
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(RtcEngineContext(appId: AgoraId));

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint("Live channel joined: ${connection.channelId}");
            if (mounted) setState(() => _isJoined = true);
          },
          onLeaveChannel: (connection, stats) {
            if (mounted) setState(() => _isJoined = false);
          },
          // ADD THIS: Auto-renew broadcaster token for long streams
          onTokenPrivilegeWillExpire: (RtcConnection connection, String token) async {
            debugPrint("Broadcaster token expiring, renewing...");
            String newToken = await fetchToken("new_key", 0, 'publisher');
            await _engine!.renewToken(newToken);
          },
          onError: (err, msg) {
            debugPrint("Agora Error: $err - $msg");
          },
        ),
      );

      await _engine!.enableVideo();
      await _engine!.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      if (mounted) setState(() => _isEngineReady = true);
    } catch (e) {
      debugPrint("Agora Setup Failed: $e");
    }
  }

  Future<void> toggleBroadcast() async {
    if (_isBroadcasting) {
      // 1. Leave channel and stop local preview to save battery/resources
      await _engine?.stopPreview();
      await _engine?.leaveChannel();
      setState(() => _isBroadcasting = false);
    } else {
      try {
        // Show loading state if you like
        await _engine?.enableLocalVideo(true);
        await _engine?.startPreview();

        // 2. Fetch publisher token (MUST BE 'publisher' to send video)
        String dynamicToken = await fetchToken("new_key", 0, 'publisher');

        await _engine?.joinChannel(
          token: dynamicToken,
          channelId: "new_key",
          uid: 0,
          options: const ChannelMediaOptions(
            publishCameraTrack: true,
            publishMicrophoneTrack: true,
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
          ),
        );

        setState(() => _isBroadcasting = true);
      } catch (e) {
        debugPrint("Failed to start broadcast: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Could not connect to token server")),
        );
      }
    }
  }
  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Prevent UI from building before engine is ready to avoid "Null Value" errors
    if (!_isEngineReady) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(title: const Text('Ancil Media - Live Panel'), backgroundColor: Colors.blueGrey[900]),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _isBroadcasting ? Colors.redAccent : Colors.white12, width: 3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: _isJoined
                    ? AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine!,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                )
                    : const Center(child: Text("Camera Ready - Press Start", style: TextStyle(color: Colors.white38))),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: FloatingActionButton.extended(
              onPressed: toggleBroadcast,
              backgroundColor: _isBroadcasting ? Colors.red : Colors.greenAccent[700],
              icon: Icon(_isBroadcasting ? Icons.stop : Icons.sensors),
              label: Text(_isBroadcasting ? "STOP STREAM" : "START LIVE STREAM"),
            ),
          ),
        ],
      ),
    );
  }
}