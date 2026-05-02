// // // import 'package:socket_io_client/socket_io_client.dart' as IO;
// // // import '../environmental variables.dart';
// // //
// // // class SocketService {
// // //   static final SocketService _instance = SocketService._internal();
// // //   factory SocketService() => _instance;
// // //
// // //   IO.Socket? _socket;
// // //
// // //   SocketService._internal();
// // //
// // //   /// Initialize the socket connection
// // //   void initSocket() {
// // //     if (_socket != null && _socket!.connected) return;
// // //
// // //     final cleanedUrl = NgrokUrl.endsWith('/')
// // //         ? NgrokUrl.substring(0, NgrokUrl.length - 1)
// // //         : NgrokUrl;
// // //
// // //     _socket = IO.io(
// // //       cleanedUrl,
// // //       <String, dynamic>{
// // //         'transports': ['websocket'],
// // //         'autoConnect': true,
// // //         'reconnection': true,
// // //         'reconnectionAttempts': 5,
// // //         'reconnectionDelay': 2000,
// // //       },
// // //     );
// // //
// // //     _socket!.connect();
// // //
// // //     _socket!.onConnect((_) {
// // //       print('✅ Connected to socket server');
// // //     });
// // //
// // //     _socket!.onDisconnect((_) {
// // //       print('❌ Disconnected from socket server');
// // //     });
// // //   }
// // //
// // //   /// Listen to an event
// // //   void on(String event, Function(dynamic) callback) {
// // //     _socket?.on(event, callback);
// // //   }
// // //
// // //   /// Emit an event
// // //   void emit(String event, dynamic data) {
// // //     _socket?.emit(event, data);
// // //   }
// // //
// // //   /// Disconnect
// // //   void disconnect() {
// // //     _socket?.disconnect();
// // //   }
// // // }
// //
// //
// //
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:socket_io_client/socket_io_client.dart' as IO;
// // import '../environmental variables.dart';
// //
// // class SocketService {
// //   static final SocketService _instance = SocketService._internal();
// //   factory SocketService() => _instance;
// //
// //   final Map<String, bool> _registeredEvents = {};
// //
// //   IO.Socket? _socket;
// //
// //   SocketService._internal();
// //
// //   void initSocket() {
// //     if (_socket != null && _socket!.connected) return;
// //
// //     final cleanedUrl = NgrokUrl.endsWith('/')
// //         ? NgrokUrl.substring(0, NgrokUrl.length - 1)
// //         : NgrokUrl;
// //
// //     _socket = IO.io(
// //       cleanedUrl,
// //       <String, dynamic>{
// //         'transports': ['websocket'],
// //         'autoConnect': true,
// //         'reconnection': true,
// //         'reconnectionAttempts': 5,
// //         'reconnectionDelay': 2000,
// //       },
// //     );
// //
// //     _socket!.connect();
// //
// //     _socket!.onConnect((_) {
// //       print('✅ Connected to socket server');
// //     });
// //
// //     _socket!.onDisconnect((_) {
// //       print('❌ Disconnected from socket server');
// //     });
// //   }
// //
// //   /// Listen to an event with a fix for Flutter Web LegacyJavaScriptObject error
// //   // void on(String event, Function(dynamic) callback) {
// //   //   _socket?.on(event, (data) {
// //   //     print('📩 Received data for "$event"');
// //   //
// //   //     // 🔥 THE FIX: Deep convert JS object to Dart Map/List
// //   //     // This prevents the DiagnosticLevel error on Flutter Web
// //   //     dynamic convertedData = data;
// //   //
// //   //     if (data is Map) {
// //   //       convertedData = Map<String, dynamic>.from(data);
// //   //     } else if (data is List) {
// //   //       convertedData = data.map((item) {
// //   //         return item is Map ? Map<String, dynamic>.from(item) : item;
// //   //       }).toList();
// //   //     }
// //   //
// //   //     callback(convertedData);
// //   //   });
// //   // }
// //
// //   // void on(String event, Function(dynamic) callback) {
// //   //   _socket?.on(event, (data) {
// //   //     print('📩 Received data for "$event"');
// //   //
// //   //     dynamic safeData;
// //   //
// //   //     try {
// //   //       // Convert safely for Flutter Web + Mobile
// //   //       if (data is Map) {
// //   //         safeData = Map<String, dynamic>.from(data);
// //   //       } else if (data is List) {
// //   //         safeData = data.map((e) {
// //   //           if (e is Map) return Map<String, dynamic>.from(e);
// //   //           return e;
// //   //         }).toList();
// //   //       } else {
// //   //         safeData = data;
// //   //       }
// //   //     } catch (e) {
// //   //       print("❌ Socket parsing error: $e");
// //   //       safeData = data;
// //   //     }
// //   //
// //   //     callback(safeData);
// //   //   });
// //   // }
// //
// //   // void on(String event, Function(dynamic) callback) {
// //   //   _socket?.on(event, (data) {
// //   //     print('📩 Received data for "$event"');
// //   //
// //   //     try {
// //   //       dynamic safe;
// //   //
// //   //       if (data == null) {
// //   //         safe = null;
// //   //       } else if (data is Map) {
// //   //         safe = Map<String, dynamic>.from(
// //   //           data.map((k, v) => MapEntry(k.toString(), v)),
// //   //         );
// //   //       } else if (data is List) {
// //   //         safe = data.map((e) {
// //   //           if (e is Map) {
// //   //             return Map<String, dynamic>.from(
// //   //               e.map((k, v) => MapEntry(k.toString(), v)),
// //   //             );
// //   //           }
// //   //           return e;
// //   //         }).toList();
// //   //       } else {
// //   //         safe = data;
// //   //       }
// //   //
// //   //       // prevent inspector crash
// //   //       if (!kDebugMode) {
// //   //         callback(safe);
// //   //       } else {
// //   //         WidgetsBinding.instance.addPostFrameCallback((_) {
// //   //           callback(safe);
// //   //         });
// //   //       }
// //   //
// //   //     } catch (e) {
// //   //       print("❌ Socket parse error: $e");
// //   //     }
// //   //   });
// //   // }
// //
// //   // void on(String event, Function(dynamic) callback) {
// //   //   _socket?.on(event, (data) {
// //   //     print('📩 Received data for "$event"');
// //   //
// //   //     dynamic safeData;
// //   //
// //   //     try {
// //   //       if (data is Map) {
// //   //         safeData = Map<String, dynamic>.from(data);
// //   //       } else if (data is List) {
// //   //         safeData = data.map((e) {
// //   //           if (e is Map) return Map<String, dynamic>.from(e);
// //   //           return e;
// //   //         }).toList();
// //   //       } else {
// //   //         safeData = data;
// //   //       }
// //   //     } catch (e) {
// //   //       print("❌ Conversion error: $e");
// //   //       safeData = null;
// //   //     }
// //   //
// //   //     if (safeData != null) {
// //   //       callback(safeData);
// //   //     }
// //   //   });
// //   // }
// //
// //   void on(String event, Function(dynamic) callback) {
// //     if (_registeredEvents[event] == true) return; // ✅ PREVENT DUPLICATES
// //     _registeredEvents[event] = true;
// //
// //     _socket?.on(event, (data) {
// //       print('📩 Received data for "$event"');
// //
// //       dynamic safeData;
// //
// //       try {
// //         if (data is Map) {
// //           safeData = Map<String, dynamic>.from(data);
// //         } else if (data is List) {
// //           safeData = data.map((e) {
// //             if (e is Map) return Map<String, dynamic>.from(e);
// //             return e;
// //           }).toList();
// //         } else {
// //           safeData = data;
// //         }
// //       } catch (e) {
// //         print("❌ Conversion error: $e");
// //         return;
// //       }
// //
// //       // ✅ SAFE UI UPDATE TIMING
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         callback(safeData);
// //       });
// //     });
// //   }
// //
// //   void emit(String event, dynamic data) {
// //     _socket?.emit(event, data);
// //   }
// //
// //   void disconnect() {
// //     _socket?.disconnect();
// //   }
// // }
//
//
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import '../environmental variables.dart';
//
// class SocketService {
//   static final SocketService _instance = SocketService._internal();
//   factory SocketService() => _instance;
//
//   IO.Socket? _socket;
//
//   SocketService._internal();
//
//   void initSocket() {
//     if (_socket != null && _socket!.connected) return;
//
//     final cleanedUrl = NgrokUrl.endsWith('/')
//         ? NgrokUrl.substring(0, NgrokUrl.length - 1)
//         : NgrokUrl;
//
//     _socket = IO.io(
//       cleanedUrl,
//       <String, dynamic>{
//         'transports': ['websocket'],
//         'autoConnect': true,
//         'reconnection': true,
//         'reconnectionAttempts': 5,
//         'reconnectionDelay': 2000,
//       },
//     );
//
//     _socket!.connect();
//
//     _socket!.onConnect((_) => print('✅ Connected to socket server'));
//     _socket!.onDisconnect((_) => print('❌ Disconnected from socket server'));
//   }
//
//   /// Listen to an event with a deep-clean for Flutter Web
//   void on(String event, Function(dynamic) callback) {
//     _socket?.on(event, (data) {
//       print('📩 Socket Service received: "$event"');
//
//       // 🔥 THE CRITICAL FIX FOR WEB:
//       // We must convert the JS object to a pure Dart Map immediately.
//       dynamic sanitizedData = _sanitize(data);
//
//       callback(sanitizedData);
//     });
//   }
//
//   /// Recursively converts LegacyJavaScriptObjects to Dart types
//   dynamic _sanitize(dynamic data) {
//     if (data is Map) {
//       return data.map((key, value) => MapEntry(key.toString(), _sanitize(value)));
//     } else if (data is List) {
//       return data.map((item) => _sanitize(item)).toList();
//     }
//     return data; // Return primitives (String, int, bool, null) as is
//   }
//
//   void emit(String event, dynamic data) {
//     if (_socket?.connected ?? false) {
//       _socket?.emit(event, data);
//     }
//   }
//
//   void disconnect() {
//     _socket?.disconnect();
//     _socket = null;
//   }
// // }
// import 'dart:async';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'environmental variables.dart';
//
// class SocketService {
//   static final SocketService _instance = SocketService._internal();
//   factory SocketService() => _instance;
//
//   IO.Socket? _socket;
//   Timer? _heartbeatTimer;
//
//   String? _userId;
//
//   SocketService._internal();
//
//   IO.Socket? get socket => _socket;
//
//   void initSocket(String userId) {
//     _userId = userId;
//
//     if (_socket != null && _socket!.connected) return;
//
//     final cleanedUrl = NgrokUrl.endsWith('/')
//         ? NgrokUrl.substring(0, NgrokUrl.length - 1)
//         : NgrokUrl;
//
//     _socket = IO.io(
//       cleanedUrl,
//       {
//         'transports': ['websocket'],
//         'autoConnect': false,
//         'reconnection': true,
//         'reconnectionAttempts': 10,
//         'reconnectionDelay': 2000,
//       },
//     );
//
//     _socket!.connect();
//
//     _socket!.onConnect((_) {
//       print("✅ Connected: ${_socket!.id}");
//
//       // 🔥 IMPORTANT: Tell server user is online
//       _socket!.emit("user-online", _userId);
//
//       // 🔥 Start heartbeat
//       _startHeartbeat();
//     });
//
//     _socket!.onDisconnect((_) {
//       print("❌ Disconnected");
//       _stopHeartbeat();
//     });
//   }
//
//   void _startHeartbeat() {
//     _heartbeatTimer?.cancel();
//
//     _heartbeatTimer = Timer.periodic(const Duration(seconds: 20), (_) {
//       if (_socket != null && _socket!.connected && _userId != null) {
//         _socket!.emit("heartbeat", _userId);
//         print("💓 Heartbeat sent");
//       }
//     });
//   }
//
//   void _stopHeartbeat() {
//     _heartbeatTimer?.cancel();
//   }
//
//   /// ✅ SAFE listener (fix for Flutter Web crash)
//   void on(String event, Function(dynamic) callback) {
//     _socket?.on(event, (data) {
//       print("📩 $event raw: $data");
//
//       dynamic safeData;
//
//       try {
//         if (data is Map) {
//           safeData = Map<String, dynamic>.from(data);
//         } else if (data is List) {
//           safeData = data.map((e) {
//             if (e is Map) return Map<String, dynamic>.from(e);
//             return e;
//           }).toList();
//         } else {
//           safeData = data;
//         }
//       } catch (e) {
//         print("❌ Parse error: $e");
//         safeData = null;
//       }
//
//       if (safeData != null) {
//         callback(safeData);
//       }
//     });
//   }
//
//   void dispose() {
//     _heartbeatTimer?.cancel();
//     _socket?.dispose();
//     _socket = null;
//   }
// }

import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../environmental variables.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  IO.Socket? _socket;

  SocketService._internal();

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

    _socket!.onConnect((_) => print('✅ Connected to socket server'));
    _socket!.onDisconnect((_) => print('❌ Disconnected from socket server'));
  }

  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, (data) {
      // sanitize JS objects for Flutter Web
      dynamic sanitized = _sanitize(data);
      callback(sanitized);
    });
  }

  dynamic _sanitize(dynamic data) {
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), _sanitize(value)));
    } else if (data is List) {
      return data.map((item) => _sanitize(item)).toList();
    }
    return data;
  }

  void emit(String event, dynamic data) {
    if (_socket?.connected ?? false) {
      _socket?.emit(event, data);
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}