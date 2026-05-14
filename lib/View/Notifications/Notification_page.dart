// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:intl/intl.dart';
// // import 'package:lottie/lottie.dart';
// // import 'package:provider/provider.dart';
// //
// // import '../../Controller/Notification_controller.dart';
// // import '../../View_model/Authentication_state.dart';
// // import '../../View_model/Notification_dropdown_state.dart';
// //
// // class NotificationPage extends StatefulWidget {
// //   const NotificationPage({super.key});
// //
// //   @override
// //   State<NotificationPage> createState() => _NotificationPageState();
// // }
// //
// // class _NotificationPageState extends State<NotificationPage> with TickerProviderStateMixin {
// //   List<dynamic> notifications = [];
// //   late AnimationController _listController;
// //   final TextStyle baseStyle = GoogleFonts.poppins();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _listController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 1000),
// //     );
// //     // Use a small delay to ensure context is fully available for Provider
// //     Future.delayed(Duration.zero, () => loadAll());
// //   }
// //
// //   @override
// //   void dispose() {
// //     _listController.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<void> loadAll() async {
// //     if (!mounted) return;
// //     final authState = Provider.of<AuthState>(context, listen: false);
// //     final all = await NotificationController.getAll(authState);
// //     if (mounted) {
// //       setState(() => notifications = all);
// //       _listController.forward(from: 0);
// //
// //       final unreadCount = all.where((n) => n['read'] != true).length;
// //       Provider.of<NotificationState>(context, listen: false).updateCount(unreadCount);
// //     }
// //   }
// //
// //   Future<void> markRead(String id) async {
// //     setState(() {
// //       final index = notifications.indexWhere((n) => n['_id'] == id);
// //       if (index != -1) notifications[index]['read'] = true;
// //     });
// //     final authState = Provider.of<AuthState>(context, listen: false);
// //     await NotificationController.markAsRead(authState, id);
// //     final unreadCount = notifications.where((n) => n['read'] != true).length;
// //     Provider.of<NotificationState>(context, listen: false).updateCount(unreadCount);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF8F9FD),
// //       appBar: AppBar(
// //         // title: Text("System Notifications",
// //         //     style: baseStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey.shade900)),
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         actions: [
// //           IconButton(
// //             onPressed: loadAll,
// //             icon: const Icon(Iconsax.refresh, color: Colors.indigo),
// //           ),
// //           const SizedBox(width: 16),
// //         ],
// //       ),
// //       body: notifications.isEmpty
// //           ? _buildEmptyState()
// //           : ListView.builder(
// //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
// //         itemCount: notifications.length,
// //         itemBuilder: (context, i) {
// //           return AnimatedBuilder(
// //             animation: _listController,
// //             builder: (context, child) {
// //               final delay = (i * 0.1).clamp(0.0, 1.0);
// //               final animation = CurvedAnimation(
// //                 parent: _listController,
// //                 curve: Interval(delay, 1.0, curve: Curves.easeOutQuart),
// //               );
// //               return FadeTransition(
// //                 opacity: animation,
// //                 child: SlideTransition(
// //                   position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(animation),
// //                   child: _buildNotificationItem(notifications[i]),
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget _buildNotificationItem(dynamic notif) {
// //     final bool isUnread = notif['read'] != true;
// //     final created = DateFormat('yMMMd – h:mm a').format(DateTime.parse(notif['createdAt']));
// //     final type = notif['type'] ?? 'normal';
// //     final isRegistration = type == 'registration';
// //     final user = isRegistration ? (notif['userId'] ?? {}) : {};
// //
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: isUnread ? Colors.indigo.withOpacity(0.08) : Colors.black.withOpacity(0.02),
// //             blurRadius: 15,
// //             offset: const Offset(0, 8),
// //           )
// //         ],
// //         border: Border.all(
// //           color: isUnread ? Colors.indigo.withOpacity(0.1) : Colors.transparent,
// //           width: 1.5,
// //         ),
// //       ),
// //       child: Theme(
// //         // ✅ FIXED: Instead of Theme.of(context).copyWith, we provide a clean ThemeData
// //         data: ThemeData(
// //           splashColor: Colors.transparent,
// //           highlightColor: Colors.transparent,
// //           dividerColor: Colors.transparent,
// //         ),
// //         child: ExpansionTile(
// //           onExpansionChanged: (expanded) {
// //             if (expanded && isUnread) markRead(notif['_id']);
// //           },
// //           leading: _buildLeadingIcon(type, isUnread),
// //           title: Text(
// //             isRegistration ? 'New User: ${user['username'] ?? 'Admin'}' : (notif['title'] ?? 'Update'),
// //             style: baseStyle.copyWith(
// //               fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
// //               fontSize: 15,
// //             ),
// //           ),
// //           subtitle: Text(created, style: baseStyle.copyWith(fontSize: 12, color: Colors.blueGrey.shade300)),
// //           trailing: _buildTrailingAction(notif['_id']),
// //           children: [
// //             _buildExpandedContent(notif, isRegistration, user),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildLeadingIcon(String type, bool isUnread) {
// //     IconData icon = Iconsax.notification;
// //     Color color = Colors.indigo;
// //
// //     if (type == 'registration') { icon = Iconsax.user_add; color = Colors.orange; }
// //     else if (type == 'alert') { icon = Iconsax.danger; color = Colors.red; }
// //
// //     return Stack(
// //       children: [
// //         Container(
// //           padding: const EdgeInsets.all(10),
// //           decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
// //           child: Icon(icon, color: color, size: 20),
// //         ),
// //         if (isUnread)
// //           Positioned(
// //             right: 0, top: 0,
// //             child: Container(
// //               height: 8, width: 8,
// //               decoration: const BoxDecoration(color: Colors.indigo, shape: BoxShape.circle),
// //             ),
// //           ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildExpandedContent(dynamic notif, bool isRegistration, dynamic user) {
// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
// //       child: Container(
// //         width: double.infinity,
// //         padding: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15)),
// //         child: isRegistration
// //             ? Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             _detailText("Username", user['username']),
// //             _detailText("Email", user['email']),
// //             _detailText("Phone", user['phone']),
// //             _detailText("Registration", user['createdAt'] != null ? DateFormat('yMMMd').format(DateTime.parse(user['createdAt'])) : 'N/A'),
// //           ],
// //         )
// //             : Text(notif['body'] ?? 'No additional details.', style: baseStyle.copyWith(fontSize: 14)),
// //       ),
// //     );
// //   }
// //
// //   Widget _detailText(String label, String? value) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 4),
// //       child: RichText(
// //         text: TextSpan(
// //           style: baseStyle.copyWith(fontSize: 13, color: Colors.blueGrey.shade800),
// //           children: [
// //             TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
// //             TextSpan(text: value ?? 'N/A'),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildEmptyState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Lottie.asset('assets/Mailpc.json', height: 200),
// //           Text("No notifications", style: baseStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.blueGrey.shade300)),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTrailingAction(String id) {
// //     return PopupMenuButton<String>(
// //       icon: const Icon(Iconsax.more, size: 18),
// //       onSelected: (val) { if (val == 'delete') _deleteNotification(id); },
// //       itemBuilder: (ctx) => [
// //         const PopupMenuItem(value: 'delete', child: Text("Delete Notification")),
// //       ],
// //     );
// //   }
// //
// //   Future<void> _deleteNotification(String id) async {
// //     final authState = Provider.of<AuthState>(context, listen: false);
// //     final result = await NotificationController.delete(authState, id);
// //     if (result) loadAll();
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'dart:ui';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
//
// import '../../Controller/Notification_controller.dart';
// import '../../View_model/Authentication_state.dart';
// import '../../View_model/Notification_dropdown_state.dart';
//
// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});
//
//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }
//
// class _NotificationPageState extends State<NotificationPage> with TickerProviderStateMixin {
//   List<dynamic> notifications = [];
//   late AnimationController _listController;
//   final TextStyle baseStyle = GoogleFonts.plusJakartaSans();
//
//   // Branding Colors
//   final Color primaryTeal = Colors.teal.shade700;
//   final Color accentCyan = Colors.cyan.shade600;
//
//   @override
//   void initState() {
//     super.initState();
//     _listController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     Future.delayed(Duration.zero, () => loadAll());
//   }
//
//   @override
//   void dispose() {
//     _listController.dispose();
//     super.dispose();
//   }
//
//   Future<void> loadAll() async {
//     if (!mounted) return;
//     final authState = Provider.of<AuthState>(context, listen: false);
//     final all = await NotificationController.getAll(authState);
//     if (mounted) {
//       setState(() => notifications = all);
//       _listController.forward(from: 0);
//       final unreadCount = all.where((n) => n['read'] != true).length;
//       Provider.of<NotificationState>(context, listen: false).updateCount(unreadCount);
//     }
//   }
//
//   Future<void> markRead(String id) async {
//     setState(() {
//       final index = notifications.indexWhere((n) => n['_id'] == id);
//       if (index != -1) notifications[index]['read'] = true;
//     });
//     final authState = Provider.of<AuthState>(context, listen: false);
//     await NotificationController.markAsRead(authState, id);
//     final unreadCount = notifications.where((n) => n['read'] != true).length;
//     Provider.of<NotificationState>(context, listen: false).updateCount(unreadCount);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           double width = constraints.maxWidth;
//           int columns = width > 1200 ? 3 : (width > 800 ? 2 : 1);
//
//           return CustomScrollView(
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               _buildModernAppBar(width),
//               notifications.isEmpty
//                   ? SliverFillRemaining(child: _buildEmptyState())
//                   : SliverPadding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: width > 800 ? 40 : 16,
//                   vertical: 24,
//                 ),
//                 sliver: SliverToBoxAdapter(
//                   child: Wrap(
//                     spacing: 20,
//                     runSpacing: 20,
//                     children: List.generate(notifications.length, (i) {
//                       return SizedBox(
//                         width: columns == 1
//                             ? double.infinity
//                             : (width - (width > 800 ? 80 : 32) - ((columns - 1) * 20)) / columns,
//                         child: _buildAnimatedItem(i, notifications[i]),
//                       );
//                     }),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildModernAppBar(double width) {
//     return SliverAppBar(
//       expandedHeight: 160,
//       pinned: true,
//       backgroundColor: primaryTeal,
//       elevation: 0,
//       flexibleSpace: FlexibleSpaceBar(
//         centerTitle: false,
//         titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
//         title: Text(
//           "Notifications",
//           style: GoogleFonts.plusJakartaSans(
//               fontWeight: FontWeight.w800,
//               fontSize: 22,
//               color: Colors.white
//           ),
//         ),
//         background: Stack(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [primaryTeal, accentCyan],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//             ),
//             Positioned(
//               right: -30, top: -20,
//               child: CircleAvatar(radius: 80, backgroundColor: Colors.white.withOpacity(0.05)),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         IconButton(
//             onPressed: loadAll,
//             icon: const Icon(Iconsax.refresh, color: Colors.white)
//         ),
//         const SizedBox(width: 16),
//       ],
//     );
//   }
//
//   Widget _buildAnimatedItem(int i, dynamic notif) {
//     return AnimatedBuilder(
//       animation: _listController,
//       builder: (context, child) {
//         final delay = (i * 0.05).clamp(0.0, 1.0);
//         final animation = CurvedAnimation(
//           parent: _listController,
//           curve: Interval(delay, 1.0, curve: Curves.easeOutQuart),
//         );
//         return FadeTransition(
//           opacity: animation,
//           child: SlideTransition(
//             position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(animation),
//             child: HoverCard(
//               child: _buildNotificationCard(notif),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildNotificationCard(dynamic notif) {
//     final bool isUnread = notif['read'] != true;
//     final created = DateFormat('MMM dd, h:mm a').format(DateTime.parse(notif['createdAt']));
//     final type = notif['type'] ?? 'normal';
//     final isRegistration = type == 'registration';
//     final user = isRegistration ? (notif['userId'] ?? {}) : {};
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: isUnread ? primaryTeal.withOpacity(0.3) : Colors.transparent,
//           width: 1.5,
//         ),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24),
//         child: Theme(
//           data: ThemeData(dividerColor: Colors.transparent),
//           child: ExpansionTile(
//             tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//             onExpansionChanged: (expanded) {
//               if (expanded && isUnread) markRead(notif['_id']);
//             },
//             leading: _buildLeadingIcon(type, isUnread),
//             title: Text(
//               isRegistration ? 'New User Registration' : (notif['title'] ?? 'System Info'),
//               style: baseStyle.copyWith(
//                 fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600,
//                 fontSize: 15,
//                 color: const Color(0xFF0F172A),
//               ),
//             ),
//             subtitle: Text(
//               isRegistration ? (user['username'] ?? 'Admin User') : created,
//               style: baseStyle.copyWith(fontSize: 12, color: Colors.blueGrey.shade400),
//             ),
//             trailing: _buildTrailingAction(notif['_id']),
//             children: [
//               _buildExpandedContent(notif, isRegistration, user),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLeadingIcon(String type, bool isUnread) {
//     IconData icon = Iconsax.notification;
//     Color color = primaryTeal;
//
//     if (type == 'registration') { icon = Iconsax.user_add; color = accentCyan; }
//     else if (type == 'alert') { icon = Iconsax.danger; color = Colors.redAccent; }
//
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(16)
//       ),
//       child: Icon(icon, color: color, size: 20),
//     );
//   }
//
//   Widget _buildExpandedContent(dynamic notif, bool isRegistration, dynamic user) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//           color: const Color(0xFFF1F5F9),
//           borderRadius: BorderRadius.circular(20)
//       ),
//       child: isRegistration
//           ? Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _detailRow(Iconsax.user, "Username", user['username']),
//           _detailRow(Iconsax.sms, "Email", user['email']),
//           _detailRow(Iconsax.call, "Phone", user['phone']),
//         ],
//       )
//           : Text(
//         notif['body'] ?? 'No additional information.',
//         style: baseStyle.copyWith(
//             fontSize: 14,
//             color: Colors.blueGrey.shade700,
//             height: 1.5
//         ),
//       ),
//     );
//   }
//
//   Widget _detailRow(IconData icon, String label, String? value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         children: [
//           Icon(icon, size: 14, color: primaryTeal),
//           const SizedBox(width: 8),
//           Text("$label: ", style: baseStyle.copyWith(fontSize: 13, fontWeight: FontWeight.bold)),
//           Expanded(
//               child: Text(value ?? 'N/A', style: baseStyle.copyWith(fontSize: 13))
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Lottie.asset('assets/Mailpc.json', height: 220),
//           const SizedBox(height: 16),
//           Text(
//               "All caught up!",
//               style: baseStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold)
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTrailingAction(String id) {
//     return PopupMenuButton<String>(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       icon: const Icon(Iconsax.more, size: 18),
//       onSelected: (val) { if (val == 'delete') _deleteNotification(id); },
//       itemBuilder: (ctx) => [
//         const PopupMenuItem(value: 'delete', child: Text("Delete")),
//       ],
//     );
//   }
//
//   Future<void> _deleteNotification(String id) async {
//     final authState = Provider.of<AuthState>(context, listen: false);
//     final result = await NotificationController.delete(authState, id);
//     if (result) loadAll();
//   }
// }
//
// // ================= HOVER EFFECT WRAPPER =================
//
// class HoverCard extends StatefulWidget {
//   final Widget child;
//   const HoverCard({super.key, required this.child});
//
//   @override
//   State<HoverCard> createState() => _HoverCardState();
// }
//
// class _HoverCardState extends State<HoverCard> {
//   bool isHovered = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final hoveredTransform = Matrix4.identity()..translate(0, -6, 0);
//     final transform = isHovered ? hoveredTransform : Matrix4.identity();
//
//     return MouseRegion(
//       onEnter: (_) => setState(() => isHovered = true),
//       onExit: (_) => setState(() => isHovered = false),
//       cursor: SystemMouseCursors.click,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         curve: Curves.easeOutCubic,
//         transform: transform,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: isHovered
//                   ? Colors.teal.withOpacity(0.12)
//                   : Colors.black.withOpacity(0.04),
//               blurRadius: isHovered ? 25 : 15,
//               offset: isHovered ? const Offset(0, 12) : const Offset(0, 8),
//             )
//           ],
//         ),
//         child: widget.child,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:ui';
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
  State<NotificationPage> createState() =>
      _NotificationPageState();
}

class _NotificationPageState
    extends State<NotificationPage>
    with TickerProviderStateMixin {

  List<dynamic> notifications = [];

  late AnimationController _listController;

  final TextStyle baseStyle =
  GoogleFonts.plusJakartaSans();

  // ======================================================
  // COLORS
  // ======================================================

  final Color primaryTeal =
      Colors.teal.shade700;

  final Color accentCyan =
      Colors.cyan.shade600;

  // ======================================================
  // INIT
  // ======================================================

  @override
  void initState() {
    super.initState();

    _listController =
        AnimationController(
          vsync: this,
          duration: const Duration(
            milliseconds: 1000,
          ),
        );

    Future.delayed(
      Duration.zero,
          () => loadAll(),
    );
  }

  // ======================================================
  // DISPOSE
  // ======================================================

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  // ======================================================
  // LOAD ALL
  // ======================================================

  Future<void> loadAll() async {

    if (!mounted) return;

    final authState =
    Provider.of<AuthState>(
      context,
      listen: false,
    );

    final all =
    await NotificationController.getAll(
      authState,
    );

    if (mounted) {

      setState(() {
        notifications = all;
      });

      _listController.forward(from: 0);

      final unreadCount =
          all.where(
                (n) => n['read'] != true,
          ).length;

      Provider.of<NotificationState>(
        context,
        listen: false,
      ).updateCount(unreadCount);
    }
  }

  // ======================================================
  // MARK SINGLE READ
  // ======================================================

  Future<void> markRead(String id) async {

    setState(() {

      final index =
      notifications.indexWhere(
            (n) => n['_id'] == id,
      );

      if (index != -1) {
        notifications[index]['read'] = true;
      }
    });

    final authState =
    Provider.of<AuthState>(
      context,
      listen: false,
    );

    await NotificationController.markAsRead(
      authState,
      id,
    );

    final unreadCount =
        notifications.where(
              (n) => n['read'] != true,
        ).length;

    Provider.of<NotificationState>(
      context,
      listen: false,
    ).updateCount(unreadCount);
  }

  // ======================================================
  // MARK ALL READ
  // ======================================================

  Future<void> markAllAsRead() async {

    final authState =
    Provider.of<AuthState>(
      context,
      listen: false,
    );

    final success =
    await NotificationController.markAllAsRead(
      authState,
    );

    if (success) {

      setState(() {

        for (var n in notifications) {
          n['read'] = true;
        }

      });

      Provider.of<NotificationState>(
        context,
        listen: false,
      ).updateCount(0);

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(
            "All notifications marked as read",
            style: baseStyle.copyWith(
              color: Colors.white,
            ),
          ),

          backgroundColor: primaryTeal,

          behavior:
          SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ======================================================
  // DELETE
  // ======================================================

  Future<void> _deleteNotification(
      String id,
      ) async {

    final authState =
    Provider.of<AuthState>(
      context,
      listen: false,
    );

    final result =
    await NotificationController.delete(
      authState,
      id,
    );

    if (result) {
      loadAll();
    }
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF8FAFC),

      body: LayoutBuilder(

        builder: (
            context,
            constraints,
            ) {

          double width =
              constraints.maxWidth;

          int columns =
          width > 1200
              ? 3
              : (width > 800 ? 2 : 1);

          return CustomScrollView(

            physics:
            const BouncingScrollPhysics(),

            slivers: [

              _buildModernAppBar(width),

              notifications.isEmpty

                  ? SliverFillRemaining(
                child:
                _buildEmptyState(),
              )

                  : SliverPadding(

                padding:
                EdgeInsets.symmetric(
                  horizontal:
                  width > 800
                      ? 40
                      : 16,

                  vertical: 24,
                ),

                sliver:
                SliverToBoxAdapter(

                  child: Wrap(

                    spacing: 20,

                    runSpacing: 20,

                    children: List.generate(
                      notifications.length,
                          (i) {

                        return SizedBox(

                          width: columns == 1

                              ? double.infinity

                              : (
                              width -
                                  (
                                      width > 800
                                          ? 80
                                          : 32
                                  ) -
                                  (
                                      (
                                          columns - 1
                                      ) *
                                          20
                                  )
                          ) /
                              columns,

                          child:
                          _buildAnimatedItem(
                            i,
                            notifications[i],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ======================================================
  // APP BAR
  // ======================================================

  Widget _buildModernAppBar(
      double width,
      ) {

    return SliverAppBar(

      expandedHeight: 160,

      pinned: true,

      backgroundColor: primaryTeal,

      elevation: 0,

      flexibleSpace: FlexibleSpaceBar(

        centerTitle: false,

        titlePadding:
        const EdgeInsets.only(
          left: 24,
          bottom: 16,
        ),

        title: Column(

          mainAxisSize:
          MainAxisSize.min,

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(

              "Notifications",

              style:
              GoogleFonts.plusJakartaSans(

                fontWeight:
                FontWeight.w800,

                fontSize: 22,

                color: Colors.white,
              ),
            ),

            const SizedBox(height: 4),

            Text(

              "${notifications.where((n) => n['read'] != true).length} unread notifications",

              style:
              GoogleFonts.plusJakartaSans(

                fontSize: 12,

                color: Colors.white70,

                fontWeight:
                FontWeight.w500,
              ),
            ),
          ],
        ),

        background: Stack(

          children: [

            Container(

              decoration: BoxDecoration(

                gradient:
                LinearGradient(

                  colors: [
                    primaryTeal,
                    accentCyan,
                  ],

                  begin:
                  Alignment.topLeft,

                  end:
                  Alignment.bottomRight,
                ),
              ),
            ),

            Positioned(

              right: -30,

              top: -20,

              child: CircleAvatar(

                radius: 80,

                backgroundColor:
                Colors.white.withOpacity(
                  0.05,
                ),
              ),
            ),
          ],
        ),
      ),

      actions: [

        // ======================================================
        // MARK ALL READ
        // ======================================================

        IconButton(

          tooltip:
          "Mark all as read",

          onPressed:
          notifications.any(
                (n) =>
            n['read'] != true,
          )
              ? markAllAsRead
              : null,

          icon: const Icon(
            Iconsax.tick_circle,
            color: Colors.white,
          ),
        ),

        // ======================================================
        // REFRESH
        // ======================================================

        IconButton(

          onPressed: loadAll,

          icon: const Icon(
            Iconsax.refresh,
            color: Colors.white,
          ),
        ),

        const SizedBox(width: 16),
      ],
    );
  }

  // ======================================================
  // ANIMATED ITEM
  // ======================================================

  Widget _buildAnimatedItem(
      int i,
      dynamic notif,
      ) {

    return AnimatedBuilder(

      animation: _listController,

      builder: (context, child) {

        final delay =
        (i * 0.05).clamp(0.0, 1.0);

        final animation =
        CurvedAnimation(

          parent: _listController,

          curve: Interval(
            delay,
            1.0,
            curve:
            Curves.easeOutQuart,
          ),
        );

        return FadeTransition(

          opacity: animation,

          child: SlideTransition(

            position:
            Tween<Offset>(

              begin:
              const Offset(
                0,
                0.1,
              ),

              end: Offset.zero,

            ).animate(animation),

            child: HoverCard(
              child:
              _buildNotificationCard(
                notif,
              ),
            ),
          ),
        );
      },
    );
  }

  // ======================================================
  // CARD
  // ======================================================

  Widget _buildNotificationCard(
      dynamic notif,
      ) {

    final bool isUnread =
        notif['read'] != true;

    final created =
    DateFormat(
      'MMM dd, h:mm a',
    ).format(
      DateTime.parse(
        notif['createdAt'],
      ),
    );

    final type =
        notif['type'] ?? 'normal';

    final isRegistration =
        type == 'registration';

    final user =
    isRegistration
        ? (notif['user'] ?? {})
        : {};

    return Container(

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(24),

        border: Border.all(

          color:
          isUnread

              ? primaryTeal.withOpacity(
            0.3,
          )

              : Colors.transparent,

          width: 1.5,
        ),
      ),

      child: ClipRRect(

        borderRadius:
        BorderRadius.circular(24),

        child: Theme(

          data: ThemeData(
            dividerColor:
            Colors.transparent,
          ),

          child: ExpansionTile(

            tilePadding:
            const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),

            onExpansionChanged:
                (expanded) {

              if (
              expanded &&
                  isUnread
              ) {

                markRead(
                  notif['_id'],
                );
              }
            },

            leading:
            _buildLeadingIcon(
              type,
              isUnread,
            ),

            title: Text(

              isRegistration

                  ? 'New User Registration'

                  : (
                  notif['title'] ??
                      'System Info'
              ),

              style:
              baseStyle.copyWith(

                fontWeight:
                isUnread

                    ? FontWeight.w800

                    : FontWeight.w600,

                fontSize: 15,

                color:
                const Color(
                  0xFF0F172A,
                ),
              ),
            ),

            subtitle: Text(

              isRegistration

                  ? (
                  user['username'] ??
                      'Admin User'
              )

                  : created,

              style:
              baseStyle.copyWith(

                fontSize: 12,

                color:
                Colors.blueGrey.shade400,
              ),
            ),

            trailing:
            _buildTrailingAction(
              notif['_id'],
            ),

            children: [

              _buildExpandedContent(
                notif,
                isRegistration,
                user,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======================================================
  // LEADING ICON
  // ======================================================

  Widget _buildLeadingIcon(
      String type,
      bool isUnread,
      ) {

    IconData icon =
        Iconsax.notification;

    Color color = primaryTeal;

    if (type == 'registration') {

      icon = Iconsax.user_add;
      color = accentCyan;

    } else if (type == 'alert') {

      icon = Iconsax.danger;
      color = Colors.redAccent;
    }

    return Container(

      padding:
      const EdgeInsets.all(12),

      decoration: BoxDecoration(

        color:
        color.withOpacity(0.1),

        borderRadius:
        BorderRadius.circular(16),
      ),

      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  // ======================================================
  // EXPANDED CONTENT
  // ======================================================

  Widget _buildExpandedContent(
      dynamic notif,
      bool isRegistration,
      dynamic user,
      ) {

    return Container(

      width: double.infinity,

      margin:
      const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16,
      ),

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color:
        const Color(0xFFF1F5F9),

        borderRadius:
        BorderRadius.circular(20),
      ),

      child:
      isRegistration

          ? Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          _detailRow(
            Iconsax.user,
            "Username",
            user['username'],
          ),

          _detailRow(
            Iconsax.sms,
            "Email",
            user['email'],
          ),

          _detailRow(
            Iconsax.call,
            "Phone",
            user['phone'],
          ),
        ],
      )

          : Text(

        notif['body'] ??
            'No additional information.',

        style:
        baseStyle.copyWith(

          fontSize: 14,

          color:
          Colors.blueGrey.shade700,

          height: 1.5,
        ),
      ),
    );
  }

  // ======================================================
  // DETAIL ROW
  // ======================================================

  Widget _detailRow(
      IconData icon,
      String label,
      String? value,
      ) {

    return Padding(

      padding:
      const EdgeInsets.only(
        bottom: 8,
      ),

      child: Row(

        children: [

          Icon(
            icon,
            size: 14,
            color: primaryTeal,
          ),

          const SizedBox(width: 8),

          Text(

            "$label: ",

            style:
            baseStyle.copyWith(
              fontSize: 13,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          Expanded(

            child: Text(

              value ?? 'N/A',

              style:
              baseStyle.copyWith(
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // EMPTY STATE
  // ======================================================

  Widget _buildEmptyState() {

    return Center(

      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Lottie.asset(
            'assets/Mailpc.json',
            height: 220,
          ),

          const SizedBox(height: 16),

          Text(

            "All caught up!",

            style:
            baseStyle.copyWith(

              fontSize: 18,

              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // TRAILING ACTION
  // ======================================================

  Widget _buildTrailingAction(
      String id,
      ) {

    return PopupMenuButton<String>(

      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(15),
      ),

      icon: const Icon(
        Iconsax.more,
        size: 18,
      ),

      onSelected: (val) {

        if (val == 'delete') {
          _deleteNotification(id);
        }
      },

      itemBuilder: (ctx) => [

        const PopupMenuItem(
          value: 'delete',
          child: Text("Delete"),
        ),
      ],
    );
  }
}

// ======================================================
// HOVER CARD
// ======================================================

class HoverCard extends StatefulWidget {

  final Widget child;

  const HoverCard({
    super.key,
    required this.child,
  });

  @override
  State<HoverCard> createState() =>
      _HoverCardState();
}

class _HoverCardState
    extends State<HoverCard> {

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {

    final hoveredTransform =
    Matrix4.identity()
      ..translate(0, -6, 0);

    final transform =
    isHovered

        ? hoveredTransform

        : Matrix4.identity();

    return MouseRegion(

      onEnter:
          (_) => setState(
            () => isHovered = true,
      ),

      onExit:
          (_) => setState(
            () => isHovered = false,
      ),

      cursor:
      SystemMouseCursors.click,

      child: AnimatedContainer(

        duration:
        const Duration(
          milliseconds: 250,
        ),

        curve:
        Curves.easeOutCubic,

        transform: transform,

        decoration: BoxDecoration(

          borderRadius:
          BorderRadius.circular(24),

          boxShadow: [

            BoxShadow(

              color:

              isHovered

                  ? Colors.teal.withOpacity(
                0.12,
              )

                  : Colors.black.withOpacity(
                0.04,
              ),

              blurRadius:
              isHovered ? 25 : 15,

              offset:

              isHovered

                  ? const Offset(0, 12)

                  : const Offset(0, 8),
            )
          ],
        ),

        child: widget.child,
      ),
    );
  }
}