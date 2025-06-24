// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../../View_model/Authentication_state.dart';
// import '../../Controller/Notification_controller.dart';
// import 'Notification_dialog.dart';
// import 'Notification_page.dart';
//
//
// class NotificationIconDropdown extends StatefulWidget {
//   const NotificationIconDropdown({super.key});
//
//   @override
//   State<NotificationIconDropdown> createState() => _NotificationIconDropdownState();
// }
//
// class _NotificationIconDropdownState extends State<NotificationIconDropdown> {
//   List<dynamic> unread = [];
//
//   @override
//   void initState() {
//     super.initState();
//     loadUnread();
//   }
//
//   Future<void> loadUnread() async {
//     final authState = Provider.of<AuthState>(context, listen: false);
//     final data = await NotificationController.getUnread(authState);
//     if (mounted) setState(() => unread = data.take(5).toList()); // limit 5
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<dynamic>(
//       icon: Stack(
//         children: [
//           const Icon(Icons.notifications),
//           if (unread.isNotEmpty)
//             Positioned(
//               right: 0,
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: const BoxDecoration(
//                   color: Colors.red,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Text(
//                   '${unread.length}',
//                   style: const TextStyle(fontSize: 10, color: Colors.white),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       onSelected: (notif) async {
//         showDialog(
//           context: context,
//           builder: (_) => UserDetailDialog(notif: notif),
//         );
//       },
//       itemBuilder: (context) {
//         return [
//           ...unread.map((notif) => PopupMenuItem(
//             value: notif,
//             child: ListTile(
//               title: Text(notif['title'] ?? 'New user'),
//               subtitle: Text(
//                 DateFormat('yMMMd – h:mm a')
//                     .format(DateTime.parse(notif['createdAt'])),
//               ),
//             ),
//           )),
//           if (unread.length >= 5)
//             const PopupMenuDivider(),
//           if (unread.length >= 5)
//             PopupMenuItem(
//               value: 'show_all',
//               onTap: () {
//                 // Delay navigation to prevent closing issue
//                 Future.delayed(Duration.zero, () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const NotificationPage(),
//                     ),
//                   );
//                 });
//               },
//               child: const Text('Show All'),
//             ),
//         ];
//       },
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../View_model/Authentication_state.dart';
import '../../Controller/Notification_controller.dart';
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

  @override
  void initState() {
    super.initState();
    loadUnread();
  }

  Future<void> loadUnread() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final data = await NotificationController.getUnread(authState);
    if (mounted) {
      unread = data.take(5).toList();
      Provider.of<NotificationState>(context, listen: false).updateCount(data.length);
      setState(() {});
    }
  }

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
            const Icon(Icons.notifications),
            if (state.unreadCount > 0)
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text('${state.unreadCount}', style: const TextStyle(fontSize: 10, color: Colors.white)),
                ),
              ),
          ],
        ),
        onSelected: (notif) async {
          if (notif == 'show_all') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationPage())).then((_) => loadUnread());
          } else {
            await _markAndShow(notif);
          }
        },
        itemBuilder: (context) => [
          ...unread.map((notif) => PopupMenuItem(
            value: notif,
            child: ListTile(
              title: Text(notif['title'] ?? 'New user'),
              subtitle: Text(DateFormat('yMMMd – h:mm a').format(DateTime.parse(notif['createdAt']))),
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