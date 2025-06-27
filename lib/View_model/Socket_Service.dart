import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http; // ✅ Added for HTTP call
import 'Notification_dropdown_state.dart';

class SocketService {
  late IO.Socket socket;
  bool isConnected = false;

  List<dynamic> _unread = [];
  List<dynamic> get unread => List.unmodifiable(_unread);

  Timer? _periodicTimer;
  late NotificationState _notificationState;

  final AudioPlayer _player = AudioPlayer();

  void init(String uri, {required NotificationState notifier}) {
    _notificationState = notifier;

    debugPrint("🔌 Connecting to socket: $uri");

    socket = IO.io(
      uri,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling']) // ✅ Use plain literal
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .setTimeout(5000)
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      isConnected = true;
      debugPrint("✅ Connected to socket server");
      socket.emit("register_admin");
      _startPeriodicCheck();
      _emitTestNotification(); // Optional: auto test emit
    });

    socket.onDisconnect((_) {
      isConnected = false;
      debugPrint("🔌 Disconnected from socket server");
      _stopPeriodicCheck();
    });

    socket.on('admin_registered', (data) {
      debugPrint("🎯 Admin registered: $data");
    });

    socket.on('new_notification', (data) {
      debugPrint("📨 New real-time notification received:");
      debugPrint(data.toString());

      _unread.insert(0, data);
      _notificationState.updateCount(_unread.length);
      _playNotificationSound();
    });
  }

  void _playNotificationSound() async {
    try {
      await _player.play(AssetSource('assets/notification_dropdown.mp3'));
    } catch (e) {
      debugPrint("🔇 Failed to play sound: $e");
    }
  }

  void _startPeriodicCheck() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (isConnected) {
        socket.emit('check_updates');
        debugPrint("🕓 Emitted check_updates");
        _emitTestNotification(); // Optional periodic test emit
      }
    });
  }

  void _stopPeriodicCheck() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  void setInitialUnread(List<dynamic> data) {
    _unread = List.from(data);
    _notificationState.updateCount(_unread.length);
  }

  void markAsRead(String id) {
    _unread.removeWhere((n) => n['_id'] == id);
    _notificationState.updateCount(_unread.length);
  }

  void dispose() {
    _stopPeriodicCheck();
    if (socket.connected) {
      socket.disconnect();
    }
    socket.dispose();
  }

  void _emitTestNotification() {
    if (isConnected) {
      socket.emit('test_emit', {'admin': true});
      debugPrint("📤 Emitted test_emit");
    } else {
      debugPrint("❌ Cannot emit test, socket not connected.");
    }
  }

  // ✅ NEW METHOD to trigger test-emit via HTTP
  Future<void> triggerTestNotificationViaHttp() async {
    final uri = Uri.parse('https://3a986766-7c85-4976-a096-2068c43178dc-00-13z0wmt9o3tc5.pike.replit.dev:3000/api/auth/test-emit'); // 🔁 Replace with actual URL

    try {
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        debugPrint("✅ Test notification triggered via HTTP: ${response.body}");
      } else {
        debugPrint("❌ Failed to trigger test notification: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("⚠️ Error during test notification HTTP request: $e");
    }
  }
}
