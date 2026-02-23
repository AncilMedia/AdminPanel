import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  final TextStyle baseStyle = GoogleFonts.poppins();

  @override
  void initState() {
    super.initState();
    loadUnread();
    setupSocketListeners();
  }

  Future<void> loadUnread() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final data = await NotificationController.getUnread(authState);
    if (mounted) {
      setState(() {
        unread = data.take(5).toList();
        Provider.of<NotificationState>(context, listen: false).updateCount(data.length);
      });
    }
  }

  void setupSocketListeners() {
    final socketService = SocketService();
    socketService.on('new_user_registered', (data) {
      if (mounted) {
        setState(() {
          unread.insert(0, data);
          if (unread.length > 5) unread = unread.take(5).toList();
          Provider.of<NotificationState>(context, listen: false).updateCount(unread.length + 1);
        });
      }
    });
  }

  Future<void> _markAndShow(dynamic notif) async {
    final authState = Provider.of<AuthState>(context, listen: false);
    if (!(notif['read'] ?? false)) {
      await NotificationController.markAsRead(authState, notif['_id']);
      setState(() {
        unread.removeWhere((n) => n['_id'] == notif['_id']);
      });
      Provider.of<NotificationState>(context, listen: false).updateCount(unread.length);
    }
    showDialog(context: context, builder: (_) => UserDetailDialog(notif: notif));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationState>(
      builder: (context, state, __) => PopupMenuButton<dynamic>(
        offset: const Offset(0, 50),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        tooltip: "Notifications",
        // 🔹 MODERN ICON WITH GLOWING BADGE
        icon: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Iconsax.notification, color: Colors.white, size: 24),
            if (state.unreadCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent, // Clean red color
                    shape: BoxShape.circle,
                    // ❌ Removed the border and shadow that caused the "black circle"
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '${state.unreadCount > 9 ? "9+" : state.unreadCount}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
          ],
        ),
        // 🔹 STYLED MENU ITEMS
        itemBuilder: (context) => [
          PopupMenuItem(
            enabled: false,
            child: Text("Recent Notifications",
                style: baseStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey)),
          ),
          const PopupMenuDivider(),
          if (unread.isEmpty)
            PopupMenuItem(
              enabled: false,
              child: Center(child: Text("No new notifications", style: baseStyle.copyWith(fontSize: 12))),
            ),
          ...unread.map((notif) => PopupMenuItem(
            value: notif,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  _buildIconForType(notif['type']),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notif['title'] ?? 'New user registration',
                            style: baseStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(DateFormat('h:mm a').format(DateTime.parse(notif['createdAt'])),
                            style: baseStyle.copyWith(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: 'show_all',
            child: Center(
              child: Text('View All Notifications',
                  style: baseStyle.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo)),
            ),
          ),
        ],
        onSelected: (val) async {
          if (val == 'show_all') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationPage()))
                .then((_) => loadUnread());
          } else {
            await _markAndShow(val);
          }
        },
      ),
    );
  }

  Widget _buildIconForType(String? type) {
    IconData icon = Iconsax.user_add;
    Color color = Colors.orange;

    if (type == 'alert') { icon = Iconsax.danger; color = Colors.red; }
    else if (type == 'update') { icon = Iconsax.refresh_circle; color = Colors.blue; }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: color, size: 18),
    );
  }
}