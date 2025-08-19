import 'package:ancilmediaadminpanel/environmental%20variables.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../View_model/Authentication_state.dart';
import '../../Controller/Notification_controller.dart';
import '../../Socket_Service.dart';
import '../../View_model/Notification_dropdown_state.dart';
import 'Notification_dialog.dart';
import 'Notification_page.dart';

class NotificationIconDropdown extends StatefulWidget {
  const NotificationIconDropdown({super.key});

  @override
  State<NotificationIconDropdown> createState() => _NotificationIconDropdownState();
}

class _NotificationIconDropdownState extends State<NotificationIconDropdown> {
  List<dynamic> unread = [];
  IO.Socket? socket;

  @override
  void initState() {
    super.initState();
    loadUnread();
    setupSocketListeners();
  }

  @override
  void dispose() {
    socket?.disconnect();
    socket?.dispose();
    super.dispose();
  }

  /// Fetch unread notifications
  Future<void> loadUnread() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final data = await NotificationController.getUnread(authState);
    if (mounted) {
      unread = data.take(5).toList();
      Provider.of<NotificationState>(context, listen: false).updateCount(data.length);
      setState(() {});
    }
  }


  void setupSocketListeners() {
    final socketService = SocketService();

    // Emit a test ping after connecting
    socketService.on('connect', (_) {
      debugPrint('✅ Connected to socket server');

      // Send ping
      socketService.emit('ping_test', {
        "user": "Flutter",
        "timestamp": DateTime.now().toIso8601String(),
      });
    });

    // Listen for new user notifications
    socketService.on('new_user_registered', (data) {
      debugPrint('📥 Received new user notification:\n$data');
      if (mounted) {
        setState(() {
          unread.insert(0, data);
          if (unread.length > 5) unread = unread.take(5).toList();
          Provider.of<NotificationState>(context, listen: false).updateCount(unread.length);
        });
      }
    });
  }

  /// Connect to Socket.IO server
  // void connectSocket() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('accessToken');
  //
  //   if (token == null) {
  //     debugPrint('⚠️ No token found.');
  //     return;
  //   }
  //
  //   final cleanedUrl = NgrokUrl.endsWith('/')
  //       ? NgrokUrl.substring(0, NgrokUrl.length - 1)
  //       : NgrokUrl;
  //
  //   socket = IO.io(
  //     cleanedUrl,
  //     IO.OptionBuilder()
  //         .setTransports(['websocket'])
  //         .setExtraHeaders({
  //       'Authorization': 'Bearer $token',
  //       'ngrok-skip-browser-warning': 'true',
  //     })
  //         .enableAutoConnect()
  //         .enableReconnection()
  //         .setReconnectionDelay(5000)
  //         .build(),
  //   );
  //
  //   socket!.onConnect((_) => debugPrint('✅ Connected to socket'));
  //   socket!.onConnectError((e) => debugPrint('❌ Socket error: $e'));
  //   socket!.onDisconnect((_) => debugPrint('🔌 Disconnected'));
  //
  //   socket!.on('new_user_registered', (data) {
  //     debugPrint('📥 Received new user notification:\n$data');
  //     if (mounted) {
  //       setState(() {
  //         unread.insert(0, data);
  //         if (unread.length > 5) unread = unread.take(5).toList();
  //         Provider.of<NotificationState>(context, listen: false).updateCount(unread.length);
  //       });
  //     }
  //   });
  // }

  /// Mark a notification as read and show the dialog
  Future<void> _markAndShow(dynamic notif) async {
    final authState = Provider.of<AuthState>(context, listen: false);
    if (!(notif['read'] ?? false)) {
      await NotificationController.markAsRead(authState, notif['_id']);
      unread.removeWhere((n) => n['_id'] == notif['_id']);
      Provider.of<NotificationState>(context, listen: false).updateCount(unread.length);
      setState(() {});
    }
    showDialog(context: context, builder: (_) => UserDetailDialog(notif: notif));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationState>(
      builder: (_, state, __) => PopupMenuButton<dynamic>(
        icon: Stack(
          children: [
            const Icon(Iconsax.notification, color: Colors.white),
            if (state.unreadCount > 0)
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${state.unreadCount}',
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
        onSelected: (notif) async {
          if (notif == 'show_all') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationPage()))
                .then((_) => loadUnread());
          } else {
            await _markAndShow(notif);
          }
        },
        itemBuilder: (context) => [
          ...unread.map((notif) => PopupMenuItem(
            value: notif,
            child: ListTile(
              title: Text(notif['title'] ?? 'New user'),
              subtitle: Text(DateFormat('yMMMd – h:mm a')
                  .format(DateTime.parse(notif['createdAt']))),
            ),
          )),
          if (unread.length >= 5) const PopupMenuDivider(),
          if (unread.length >= 5)
            const PopupMenuItem(
              value: 'show_all',
              child: Text('Show All'),
            ),
        ],
      ),
    );
  }
}
