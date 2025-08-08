import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../Controller/Notification_controller.dart';
import '../../View_model/Authentication_state.dart';
import '../../View_model/Notification_dropdown_state.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  Future<void> loadAll() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final all = await NotificationController.getAll(authState);
    if (mounted) {
      setState(() => notifications = all);
      final unreadCount = all.where((n) => n['read'] != true).length;
      Provider.of<NotificationState>(context, listen: false)
          .updateCount(unreadCount);
    }
  }

  Future<void> markRead(String id) async {
    final authState = Provider.of<AuthState>(context, listen: false);
    await NotificationController.markAsRead(authState, id);
    await loadAll();
  }

  Future<void> _deleteNotification(String id) async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final result = await NotificationController.delete(authState, id);
    if (result) {
      loadAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: notifications.isEmpty
          ? Center(child: Lottie.asset('assets/Mailpc.json'))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (_, i) {
          final notif = notifications[i];
          final user = notif['userId'] ?? {};
          final created = DateFormat('yMMMd – h:mm a')
              .format(DateTime.parse(notif['createdAt']));
          final userCreated = user['createdAt'] != null
              ? DateFormat('yMMMd – h:mm a')
              .format(DateTime.parse(user['createdAt']))
              : 'N/A';

          return Card(
            color: notif['read'] != true
                ? Colors.cyan.shade50
                : Colors.grey.shade100,
            child: Theme(
              data: Theme.of(context)
                  .copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding:
                const EdgeInsets.symmetric(horizontal: 16.0),
                childrenPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _deleteNotification(notif['_id']);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
                title: Text(
                  'New User: ${user['username'] ?? 'Unknown'}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'Created at: $created',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        'Username: ${user['username'] ?? 'N/A'}',
                        'Email: ${user['email'] ?? 'N/A'}',
                        'Phone: ${user['phone'] ?? 'N/A'}',
                        'User ID: ${user['userId'] ?? 'N/A'}',
                        'Approved: ${user['approved'] == true ? 'Approved' : 'Pending'}',
                        'Registered: $userCreated',
                      ].map((e) => Padding(
                        padding:
                        const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          e,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
