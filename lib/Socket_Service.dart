import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../environmental variables.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  IO.Socket? _socket;

  SocketService._internal();

  /// Initialize the socket connection
  void initSocket() {
    if (_socket != null && _socket!.connected) return;

    final cleanedUrl = NgrokUrl.endsWith('/')
        ? NgrokUrl.substring(0, NgrokUrl.length - 1)
        : NgrokUrl;

    _socket = IO.io(
      cleanedUrl,
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 2000,
      },
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      print('✅ Connected to socket server');
    });

    _socket!.onDisconnect((_) {
      print('❌ Disconnected from socket server');
    });
  }

  /// Listen to an event
  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  /// Emit an event
  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  /// Disconnect
  void disconnect() {
    _socket?.disconnect();
  }
}
