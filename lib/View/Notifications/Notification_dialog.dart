import 'package:ancilmediaadminpanel/View/User.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserDetailDialog extends StatelessWidget {
  final dynamic notif;

  const UserDetailDialog({super.key, required this.notif});

  void _navigateToUserPage(BuildContext context) {
    Navigator.pop(context); // close dialog
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>UserPage())); // or use MaterialPageRoute
  }

  @override
  Widget build(BuildContext context) {
    final user = notif['userId'];
    final createdAt = user?['createdAt'] ?? notif['createdAt'];
    final createdStr = createdAt != null
        ? DateFormat('yMMMd – h:mm a').format(DateTime.parse(createdAt))
        : 'N/A';

    return GestureDetector(
      onTap: () => _navigateToUserPage(context),
      child: AlertDialog(
        title: Text(notif['title'] ?? 'User Info'),
        content: user == null
            ? const Text('No user info available')
            : Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${user['username'] ?? 'N/A'}'),
            Text('Email: ${user['email'] ?? 'N/A'}'),
            Text('User ID: ${user['userId'] ?? 'N/A'}'),
            Text('Approved: ${user['approved'] == true ? 'Yes' : user['approved'] == false ? 'No' : 'Pending'}'),
            Text('Registered: $createdStr'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          )
        ],
      ),
    );
  }
}
