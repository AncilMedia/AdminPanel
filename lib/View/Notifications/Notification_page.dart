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

  // ✅ Mark as read immediately in UI and call API
  Future<void> markRead(String id) async {
    setState(() {
      final index = notifications.indexWhere((n) => n['_id'] == id);
      if (index != -1) notifications[index]['read'] = true;
    });

    final authState = Provider.of<AuthState>(context, listen: false);
    await NotificationController.markAsRead(authState, id);

    // Update unread count in provider
    final unreadCount =
        notifications.where((n) => n['read'] != true).length;
    Provider.of<NotificationState>(context, listen: false)
        .updateCount(unreadCount);
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
        // title: Text(
        //   'Notifications',
        //   style: GoogleFonts.poppins(
        //     fontSize: 18,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
      ),
      body: notifications.isEmpty
          ? Center(child: Lottie.asset('assets/Mailpc.json'))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (_, i) {
          final notif = notifications[i];
          final created = DateFormat('yMMMd – h:mm a')
              .format(DateTime.parse(notif['createdAt']));

          final type = notif['type'] ?? 'normal';
          final isRegistration = type == 'registration';
          final user = isRegistration ? (notif['userId'] ?? {}) : {};
          final hasBody = notif['body'] != null &&
              notif['body'].toString().trim().isNotEmpty;
          final hasImage = notif['imageUrl'] != null &&
              notif['imageUrl'].toString().trim().isNotEmpty;

          String? userCreated;
          if (user['createdAt'] != null) {
            userCreated = DateFormat('yMMMd – h:mm a')
                .format(DateTime.parse(user['createdAt']));
          }

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
                  isRegistration
                      ? 'New User: ${user['username'] ?? 'Unknown'}'
                      : (notif['title'] ?? 'No Title'),
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
                // ✅ Mark as read when expanded
                onExpansionChanged: (isExpanded) {
                  if (isExpanded && notif['read'] != true) {
                    markRead(notif['_id']);
                  }
                },
                children: [
                  if (isRegistration) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4.0),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildUserDetail(
                                'Username', user['username']),
                            _buildUserDetail('Email', user['email']),
                            _buildUserDetail('Phone', user['phone']),
                            _buildUserDetail('User ID', user['userId']),
                            _buildUserDetail(
                              'Approved',
                              user['approved'] == true
                                  ? 'Approved'
                                  : 'Pending',
                            ),
                            _buildUserDetail('Registered', userCreated),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    if (hasBody)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            notif['body'],
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (hasImage)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            notif['imageUrl'],
                            width:
                            MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height *
                                0.3,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserDetail(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        '$label: ${value ?? 'N/A'}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
