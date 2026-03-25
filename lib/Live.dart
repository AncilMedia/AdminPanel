// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'environmental variables.dart';
//
// class LiveHostingPanel extends StatefulWidget {
//   const LiveHostingPanel({super.key});
//
//   @override
//   State<LiveHostingPanel> createState() => _LiveHostingPanelState();
// }
//
// class _LiveHostingPanelState extends State<LiveHostingPanel> {
//   RtcEngine? _engine;
//   bool _isJoined = false;
//   bool _isBroadcasting = false;
//   bool _isEngineReady = false;
//
//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }
//
//   Future<void> initAgora() async {
//     // 1. WEB DELAY: Give the browser 1 second to register the 'Iris' JS object
//     if (kIsWeb) {
//       await Future.delayed(const Duration(milliseconds: 1000));
//     } else {
//       await [Permission.microphone, Permission.camera].request();
//     }
//
//     try {
//       // 2. Initialize Engine
//       _engine = createAgoraRtcEngine();
//       await _engine!.initialize(RtcEngineContext(appId: AgoraId));
//
//       _engine!.registerEventHandler(
//         RtcEngineEventHandler(
//           onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//             debugPrint("Live channel joined: ${connection.channelId}");
//             if (mounted) setState(() => _isJoined = true);
//           },
//           onLeaveChannel: (connection, stats) {
//             if (mounted) setState(() => _isJoined = false);
//           },
//           onError: (err, msg) {
//             debugPrint("Agora Error: $err - $msg");
//           },
//         ),
//       );
//
//       // 3. System Configuration for Live Hosting
//       await _engine!.enableVideo();
//       await _engine!.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
//       await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//
//       if (mounted) setState(() => _isEngineReady = true);
//
//     } catch (e) {
//       debugPrint("Agora Setup Failed: $e");
//     }
//   }
//
//   Future<void> toggleBroadcast() async {
//     if (_isBroadcasting) {
//       await _engine?.leaveChannel();
//       setState(() => _isBroadcasting = false);
//     } else {
//       // 1. WAKE UP THE CAMERA FIRST
//       await _engine?.enableLocalVideo(true);
//       await _engine?.startPreview();
//
//       // 2. JOIN THE CHANNEL
//       await _engine?.joinChannel(
//         token: TempAgoraId,
//         channelId: "new",
//         uid: 0,
//         options: const ChannelMediaOptions(
//           publishCameraTrack: true,
//           publishMicrophoneTrack: true,
//           clientRoleType: ClientRoleType.clientRoleBroadcaster,
//         ),
//       );
//       setState(() => _isBroadcasting = true);
//     }
//   }
//   @override
//   void dispose() {
//     _engine?.leaveChannel();
//     _engine?.release();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Prevent UI from building before engine is ready to avoid "Null Value" errors
//     if (!_isEngineReady) {
//       return const Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(child: CircularProgressIndicator(color: Colors.white)),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A1A),
//       appBar: AppBar(title: const Text('Ancil Media - Live Panel'), backgroundColor: Colors.blueGrey[900]),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               margin: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: _isBroadcasting ? Colors.redAccent : Colors.white12, width: 3),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(18),
//                 child: _isJoined
//                     ? AgoraVideoView(
//                   controller: VideoViewController(
//                     rtcEngine: _engine!,
//                     canvas: const VideoCanvas(uid: 0),
//                   ),
//                 )
//                     : const Center(child: Text("Camera Ready - Press Start", style: TextStyle(color: Colors.white38))),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 40),
//             child: FloatingActionButton.extended(
//               onPressed: toggleBroadcast,
//               backgroundColor: _isBroadcasting ? Colors.red : Colors.greenAccent[700],
//               icon: Icon(_isBroadcasting ? Icons.stop : Icons.sensors),
//               label: Text(_isBroadcasting ? "STOP STREAM" : "START LIVE STREAM"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }