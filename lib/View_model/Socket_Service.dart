import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';

class SocketService {
  late IO.Socket socket;
  bool isConnected = false;

  void init(String uri) {
    socket = IO.io(
      uri,
      IO.OptionBuilder()
          .setTransports(['websocket']) // Important for Flutter Web
          .enableReconnection()
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      isConnected = true;
      debugPrint("✅ Connected to socket server");
    });

    socket.onConnectError((err) {
      isConnected = false;
      debugPrint("❌ Connection error: $err");
    });

    socket.onDisconnect((_) {
      isConnected = false;
      debugPrint("🔌 Disconnected from socket server");
    });

    socket.on('test_event', (data) {
      debugPrint("🎯 Received test_event: $data");
    });
  }
}
