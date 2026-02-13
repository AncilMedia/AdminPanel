// import 'package:ancilmediaadminpanel/environmental%20variables.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// class WebRTCService {
//   static final WebRTCService _instance = WebRTCService._internal();
//   factory WebRTCService() => _instance;
//   WebRTCService._internal();
//
//   // final String serverUrl = "http://10.0.2.2:3000"; // change for real device
//   final String serverUrl = NgrokUrl; // change for real device
//
//   late IO.Socket socket;
//   RTCPeerConnection? _peerConnection;
//   MediaStream? _localStream;
//
//   final RTCVideoRenderer localRenderer = RTCVideoRenderer();
//   final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
//
//   Future<void> initRenderers() async {
//     await localRenderer.initialize();
//     await remoteRenderer.initialize();
//   }
//
//   Map<String, dynamic> get _config => {
//     'iceServers': [
//       {'urls': 'stun:stun.l.google.com:19302'},
//     ]
//   };
//
//   // ================= HOST =================
//   Future<void> initHost(String roomId) async {
//     await initRenderers();
//
//     socket = IO.io(serverUrl, {
//       'transports': ['websocket'],
//       'autoConnect': false
//     });
//
//     socket.connect();
//
//     _localStream = await navigator.mediaDevices.getUserMedia({
//       'audio': true,
//       'video': {'facingMode': 'user'}
//     });
//
//     localRenderer.srcObject = _localStream;
//
//     _peerConnection = await createPeerConnection(_config);
//
//     for (var track in _localStream!.getTracks()) {
//       _peerConnection!.addTrack(track, _localStream!);
//     }
//
//     _peerConnection!.onIceCandidate = (candidate) {
//       socket.emit("ice-candidate", {
//         "roomId": roomId,
//         "candidate": {
//           "candidate": candidate.candidate,
//           "sdpMid": candidate.sdpMid,
//           "sdpMLineIndex": candidate.sdpMLineIndex
//         }
//       });
//     };
//
//     socket.on("user-joined", (data) async {
//       RTCSessionDescription offer = await _peerConnection!.createOffer();
//       await _peerConnection!.setLocalDescription(offer);
//
//       socket.emit("offer", {
//         "roomId": roomId,
//         "sdp": offer.sdp,
//         "type": offer.type
//       });
//     });
//
//     socket.on("answer", (data) async {
//       await _peerConnection!.setRemoteDescription(
//         RTCSessionDescription(data['sdp'], data['type']),
//       );
//     });
//
//     socket.on("ice-candidate", (data) async {
//       await _peerConnection!.addCandidate(
//         RTCIceCandidate(
//           data['candidate']['candidate'],
//           data['candidate']['sdpMid'],
//           data['candidate']['sdpMLineIndex'],
//         ),
//       );
//     });
//
//     socket.emit("join-room", {"roomId": roomId, "role": "host"});
//   }
//
//   // ================= VIEWER =================
//   Future<void> initViewer(String roomId) async {
//     await initRenderers();
//
//     socket = IO.io(serverUrl, {
//       'transports': ['websocket'],
//       'autoConnect': false
//     });
//
//     socket.connect();
//
//     _peerConnection = await createPeerConnection(_config);
//
//     _peerConnection!.onTrack = (event) {
//       remoteRenderer.srcObject = event.streams[0];
//     };
//
//     _peerConnection!.onIceCandidate = (candidate) {
//       socket.emit("ice-candidate", {
//         "roomId": roomId,
//         "candidate": {
//           "candidate": candidate.candidate,
//           "sdpMid": candidate.sdpMid,
//           "sdpMLineIndex": candidate.sdpMLineIndex
//         }
//       });
//     };
//
//     socket.on("offer", (data) async {
//       await _peerConnection!.setRemoteDescription(
//         RTCSessionDescription(data['sdp'], data['type']),
//       );
//
//       RTCSessionDescription answer = await _peerConnection!.createAnswer();
//       await _peerConnection!.setLocalDescription(answer);
//
//       socket.emit("answer", {
//         "roomId": roomId,
//         "sdp": answer.sdp,
//         "type": answer.type
//       });
//     });
//
//     socket.on("ice-candidate", (data) async {
//       await _peerConnection!.addCandidate(
//         RTCIceCandidate(
//           data['candidate']['candidate'],
//           data['candidate']['sdpMid'],
//           data['candidate']['sdpMLineIndex'],
//         ),
//       );
//     });
//
//     socket.emit("join-room", {"roomId": roomId, "role": "viewer"});
//   }
// }

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../environmental variables.dart';

class WebRTCService {
  static final WebRTCService _instance = WebRTCService._internal();
  factory WebRTCService() => _instance;
  WebRTCService._internal();

  // 🔥 Replace with your ngrok / public server URL
  final String serverUrl = NgrokUrl; // e.g: "https://xxxx.ngrok-free.app"

  late IO.Socket socket;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  // ================= INIT =================
  Future<void> initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  // ================= ICE CONFIG (TURN + STUN) =================
  Map<String, dynamic> get _config => {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {
        'urls': 'turn:openrelay.metered.ca:80',
        'username': 'openrelayproject',
        'credential': 'openrelayproject'
      },
      {
        'urls': 'turn:openrelay.metered.ca:443',
        'username': 'openrelayproject',
        'credential': 'openrelayproject'
      }
    ]
  };

  final Map<String, dynamic> offerConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
  };

  // ================= HOST =================
  Future<void> initHost(String roomId) async {
    await initRenderers();

    socket = IO.io(serverUrl, {
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {
        'facingMode': 'user',
        'width': 1280,
        'height': 720,
        'frameRate': 30,
      }
    });

    localRenderer.srcObject = _localStream;

    _peerConnection = await createPeerConnection(_config);

    for (var track in _localStream!.getTracks()) {
      _peerConnection!.addTrack(track, _localStream!);
    }

    _peerConnection!.onIceCandidate = (candidate) {
      if (candidate.candidate != null) {
        socket.emit("ice-candidate", {
          "roomId": roomId,
          "candidate": {
            "candidate": candidate.candidate,
            "sdpMid": candidate.sdpMid,
            "sdpMLineIndex": candidate.sdpMLineIndex
          }
        });
      }
    };

    _peerConnection!.onConnectionState = (state) {
      print("HOST Connection State: $state");
    };

    socket.on("user-joined", (data) async {
      RTCSessionDescription offer =
      await _peerConnection!.createOffer(offerConstraints);
      await _peerConnection!.setLocalDescription(offer);

      socket.emit("offer", {
        "roomId": roomId,
        "sdp": offer.sdp,
        "type": offer.type
      });
    });

    socket.on("answer", (data) async {
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(data['sdp'], data['type']),
      );
    });

    socket.on("ice-candidate", (data) async {
      await _peerConnection!.addCandidate(
        RTCIceCandidate(
          data['candidate']['candidate'],
          data['candidate']['sdpMid'],
          data['candidate']['sdpMLineIndex'],
        ),
      );
    });

    socket.emit("join-room", {"roomId": roomId, "role": "host"});
  }

  // ================= VIEWER =================
  Future<void> initViewer(String roomId) async {
    await initRenderers();

    socket = IO.io(serverUrl, {
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    _peerConnection = await createPeerConnection(_config);

    // 🔥 macOS FIX: track may come without stream
    _peerConnection!.onTrack = (event) async {
      if (event.streams.isNotEmpty) {
        remoteRenderer.srcObject = event.streams[0];
      } else {
        MediaStream stream = await createLocalMediaStream('remote');
        stream.addTrack(event.track);
        remoteRenderer.srcObject = stream;
      }
    };

    _peerConnection!.onIceCandidate = (candidate) {
      if (candidate.candidate != null) {
        socket.emit("ice-candidate", {
          "roomId": roomId,
          "candidate": {
            "candidate": candidate.candidate,
            "sdpMid": candidate.sdpMid,
            "sdpMLineIndex": candidate.sdpMLineIndex
          }
        });
      }
    };

    _peerConnection!.onConnectionState = (state) {
      print("VIEWER Connection State: $state");
    };

    _peerConnection!.onIceConnectionState = (state) {
      print("VIEWER ICE State: $state");
    };

    socket.on("offer", (data) async {
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(data['sdp'], data['type']),
      );

      RTCSessionDescription answer =
      await _peerConnection!.createAnswer(offerConstraints);
      await _peerConnection!.setLocalDescription(answer);

      socket.emit("answer", {
        "roomId": roomId,
        "sdp": answer.sdp,
        "type": answer.type
      });
    });

    socket.on("ice-candidate", (data) async {
      await _peerConnection!.addCandidate(
        RTCIceCandidate(
          data['candidate']['candidate'],
          data['candidate']['sdpMid'],
          data['candidate']['sdpMLineIndex'],
        ),
      );
    });

    socket.emit("join-room", {"roomId": roomId, "role": "viewer"});
  }

  // ================= CLEANUP =================
  Future<void> dispose() async {
    try {
      await socket.disconnect();
      await _peerConnection?.close();
      await localRenderer.dispose();
      await remoteRenderer.dispose();
      _localStream?.dispose();
    } catch (e) {
      print("Dispose error: $e");
    }
  }
}


