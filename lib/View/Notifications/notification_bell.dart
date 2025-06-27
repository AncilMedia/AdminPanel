import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../View_model/Authentication_state.dart';
import '../../Controller/Notification_controller.dart';
import '../../View_model/Notification_dropdown_state.dart';
import '../../View_model/Socket_Service.dart';
import 'Notification_dialog.dart';
import 'Notification_page.dart';

class NotificationIconDropdown extends StatefulWidget {
  const NotificationIconDropdown({super.key});

  @override
  State<NotificationIconDropdown> createState() => _NotificationIconDropdownState();
}

class _NotificationIconDropdownState extends State<NotificationIconDropdown> {
  @override
  void initState() {
    super.initState();
    _loadInitialUnread(); // Initial fetch to sync with server on start
  }

  Future<void> _loadInitialUnread() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final socket = Provider.of<SocketService>(context, listen: false);
    final data = await NotificationController.getUnread(authState);
    socket.setInitialUnread(data); // Populate socket's unread list
    Provider.of<NotificationState>(context, listen: false).updateCount(data.length);
  }

  Future<void> _markAndShow(dynamic notif) async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final socket = Provider.of<SocketService>(context, listen: false);

    if (!(notif['read'] ?? false)) {
      await NotificationController.markAsRead(authState, notif['_id']);
      socket.markAsRead(notif['_id']);
    }

    showDialog(
      context: context,
      builder: (_) => UserDetailDialog(notif: notif),
    );
  }

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<SocketService>(context);
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationPage()),
            ).then((_) => _loadInitialUnread());
          } else {
            await _markAndShow(notif);
          }
        },
        itemBuilder: (context) => [
          ...socket.unread.take(5).map(
                (notif) => PopupMenuItem(
              value: notif,
              child: ListTile(
                title: Text(notif['title'] ?? 'New user'),
                subtitle: Text(
                  DateFormat('yMMMd – h:mm a').format(
                    DateTime.parse(notif['createdAt']),
                  ),
                ),
              ),
            ),
          ),
          if (socket.unread.length >= 5) const PopupMenuDivider(),
          if (socket.unread.length >= 5)
            const PopupMenuItem(
              value: 'show_all',
              child: Text('Show All'),
            ),
        ],
      ),
    );
  }
}
