import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserDetailDialog extends StatelessWidget {
  final dynamic notif;

  const UserDetailDialog({super.key, required this.notif});

  @override
  Widget build(BuildContext context) {
    final user = notif['user'];
    final createdAt = user?['createdAt'] ?? notif['createdAt'];
    final createdStr = createdAt != null
        ? DateFormat('yMMMd – h:mm a').format(DateTime.parse(createdAt))
        : 'N/A';

    return AlertDialog(
      title: Text(notif['title'] ?? 'User Info'),
      content: user == null
          ? const Text('No user info available')
          : Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('👤 Username: ${user['username'] ?? 'N/A'}'),
          Text('📧 Email: ${user['email'] ?? 'N/A'}'),
          Text('🆔 User ID: ${user['userId'] ?? 'N/A'}'),
          Text(
              '✅ Approved: ${user['approved'] == true ? 'Yes' : user['approved'] == false ? 'No' : 'Pending'}'),
          Text('🕒 Registered: $createdStr'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        )
      ],
    );
  }
}
