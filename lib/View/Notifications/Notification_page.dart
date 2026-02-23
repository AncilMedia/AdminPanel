import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
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

class _NotificationPageState extends State<NotificationPage> with TickerProviderStateMixin {
  List<dynamic> notifications = [];
  late AnimationController _listController;
  final TextStyle baseStyle = GoogleFonts.poppins();

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    // Use a small delay to ensure context is fully available for Provider
    Future.delayed(Duration.zero, () => loadAll());
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  Future<void> loadAll() async {
    if (!mounted) return;
    final authState = Provider.of<AuthState>(context, listen: false);
    final all = await NotificationController.getAll(authState);
    if (mounted) {
      setState(() => notifications = all);
      _listController.forward(from: 0);

      final unreadCount = all.where((n) => n['read'] != true).length;
      Provider.of<NotificationState>(context, listen: false).updateCount(unreadCount);
    }
  }

  Future<void> markRead(String id) async {
    setState(() {
      final index = notifications.indexWhere((n) => n['_id'] == id);
      if (index != -1) notifications[index]['read'] = true;
    });
    final authState = Provider.of<AuthState>(context, listen: false);
    await NotificationController.markAsRead(authState, id);
    final unreadCount = notifications.where((n) => n['read'] != true).length;
    Provider.of<NotificationState>(context, listen: false).updateCount(unreadCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        // title: Text("System Notifications",
        //     style: baseStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey.shade900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: loadAll,
            icon: const Icon(Iconsax.refresh, color: Colors.indigo),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: notifications.length,
        itemBuilder: (context, i) {
          return AnimatedBuilder(
            animation: _listController,
            builder: (context, child) {
              final delay = (i * 0.1).clamp(0.0, 1.0);
              final animation = CurvedAnimation(
                parent: _listController,
                curve: Interval(delay, 1.0, curve: Curves.easeOutQuart),
              );
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(animation),
                  child: _buildNotificationItem(notifications[i]),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(dynamic notif) {
    final bool isUnread = notif['read'] != true;
    final created = DateFormat('yMMMd – h:mm a').format(DateTime.parse(notif['createdAt']));
    final type = notif['type'] ?? 'normal';
    final isRegistration = type == 'registration';
    final user = isRegistration ? (notif['userId'] ?? {}) : {};

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isUnread ? Colors.indigo.withOpacity(0.08) : Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
        border: Border.all(
          color: isUnread ? Colors.indigo.withOpacity(0.1) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Theme(
        // ✅ FIXED: Instead of Theme.of(context).copyWith, we provide a clean ThemeData
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            if (expanded && isUnread) markRead(notif['_id']);
          },
          leading: _buildLeadingIcon(type, isUnread),
          title: Text(
            isRegistration ? 'New User: ${user['username'] ?? 'Admin'}' : (notif['title'] ?? 'Update'),
            style: baseStyle.copyWith(
              fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
              fontSize: 15,
            ),
          ),
          subtitle: Text(created, style: baseStyle.copyWith(fontSize: 12, color: Colors.blueGrey.shade300)),
          trailing: _buildTrailingAction(notif['_id']),
          children: [
            _buildExpandedContent(notif, isRegistration, user),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(String type, bool isUnread) {
    IconData icon = Iconsax.notification;
    Color color = Colors.indigo;

    if (type == 'registration') { icon = Iconsax.user_add; color = Colors.orange; }
    else if (type == 'alert') { icon = Iconsax.danger; color = Colors.red; }

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 20),
        ),
        if (isUnread)
          Positioned(
            right: 0, top: 0,
            child: Container(
              height: 8, width: 8,
              decoration: const BoxDecoration(color: Colors.indigo, shape: BoxShape.circle),
            ),
          ),
      ],
    );
  }

  Widget _buildExpandedContent(dynamic notif, bool isRegistration, dynamic user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15)),
        child: isRegistration
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailText("Username", user['username']),
            _detailText("Email", user['email']),
            _detailText("Phone", user['phone']),
            _detailText("Registration", user['createdAt'] != null ? DateFormat('yMMMd').format(DateTime.parse(user['createdAt'])) : 'N/A'),
          ],
        )
            : Text(notif['body'] ?? 'No additional details.', style: baseStyle.copyWith(fontSize: 14)),
      ),
    );
  }

  Widget _detailText(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: baseStyle.copyWith(fontSize: 13, color: Colors.blueGrey.shade800),
          children: [
            TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/Mailpc.json', height: 200),
          Text("No notifications", style: baseStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.blueGrey.shade300)),
        ],
      ),
    );
  }

  Widget _buildTrailingAction(String id) {
    return PopupMenuButton<String>(
      icon: const Icon(Iconsax.more, size: 18),
      onSelected: (val) { if (val == 'delete') _deleteNotification(id); },
      itemBuilder: (ctx) => [
        const PopupMenuItem(value: 'delete', child: Text("Delete Notification")),
      ],
    );
  }

  Future<void> _deleteNotification(String id) async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final result = await NotificationController.delete(authState, id);
    if (result) loadAll();
  }
}