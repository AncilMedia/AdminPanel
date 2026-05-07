// // import 'dart:ui';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// //
// // class MasterIntelligenceHub extends StatefulWidget {
// //   const MasterIntelligenceHub({super.key});
// //
// //   @override
// //   State<MasterIntelligenceHub> createState() => _MasterIntelligenceHubState();
// // }
// //
// // class _MasterIntelligenceHubState extends State<MasterIntelligenceHub> {
// //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// //
// //   bool isSocketConnected = true;
// //   int activeTab = 0; // 0: Scheduled, 1: History
// //   final Color primaryTeal = const Color(0xFF0D9488);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       key: _scaffoldKey,
// //       backgroundColor: const Color(0xFFF8FAFC),
// //       drawer: _buildHistoryDrawer(),
// //       body: Stack(
// //         children: [
// //           _buildBackgroundAesthetic(),
// //           CustomScrollView(
// //             physics: const BouncingScrollPhysics(),
// //             slivers: [
// //               _buildModernAppBar(),
// //               SliverToBoxAdapter(
// //                 child: Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 24),
// //                   child: Column(
// //                     children: [
// //                       _buildSocketMonitor(),
// //                       const SizedBox(height: 32),
// //                       _buildSegmentedToggle(),
// //                       const SizedBox(height: 24),
// //                       activeTab == 0 ? _buildScheduledQueue() : _buildDeliveryHistory(),
// //                       const SizedBox(height: 100),
// //                       _buildWatermarkLogo(),
// //                       const SizedBox(height: 50),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildHistoryDrawer() {
// //     return Drawer(
// //       width: MediaQuery.of(context).size.width * 0.85,
// //       // Zero radius for a clean, technical "Side Panel" look
// //       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
// //       child: Container(
// //         color: Colors.white,
// //         child: Column(
// //           children: [
// //             // 1. Technical Header with Glass Effect
// //             Container(
// //               padding: const EdgeInsets.fromLTRB(24, 80, 24, 32),
// //               width: double.infinity,
// //               decoration: const BoxDecoration(
// //                 color: Color(0xFF0F172A), // Deep Slate
// //                 image: DecorationImage(
// //                   // Subtle technical grid pattern if available
// //                   image: NetworkImage('https://www.transparenttextures.com/patterns/carbon-fibre.png'),
// //                   opacity: 0.1,
// //                 ),
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Container(
// //                     padding: const EdgeInsets.all(10),
// //                     decoration: BoxDecoration(
// //                       color: Colors.tealAccent.withOpacity(0.1),
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     child: const Icon(Iconsax.user_octagon, color: Colors.tealAccent, size: 28),
// //                   ),
// //                   const SizedBox(height: 20),
// //                   Text("Recipient Intelligence",
// //                       style: GoogleFonts.plusJakartaSans(
// //                         color: Colors.white,
// //                         fontSize: 24,
// //                         fontWeight: FontWeight.w800,
// //                         letterSpacing: -0.5,
// //                       )),
// //                   const SizedBox(height: 8),
// //                   Text("Live tracking for Ancil Media organization members",
// //                       style: GoogleFonts.inter(color: Colors.white38, fontSize: 12, height: 1.5)),
// //                 ],
// //               ),
// //             ),
// //
// //             // 2. Statistics Overview Bar
// //             Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
// //               color: const Color(0xFF1E293B),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   _drawerStat("SENT", "128", Colors.tealAccent),
// //                   _drawerStat("FAILED", "03", Colors.redAccent),
// //                   _drawerStat("PENDING", "00", Colors.amberAccent),
// //                 ],
// //               ),
// //             ),
// //
// //             // 3. Animated List of Users
// //             Expanded(
// //               child: ListView.builder(
// //                 padding: const EdgeInsets.all(20),
// //                 physics: const BouncingScrollPhysics(),
// //                 itemCount: 15,
// //                 itemBuilder: (context, index) {
// //                   bool isSent = index % 5 != 0; // Simulation logic
// //                   return Container(
// //                     margin: const EdgeInsets.only(bottom: 12),
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xFFF8FAFC),
// //                       borderRadius: BorderRadius.circular(20),
// //                       border: Border.all(
// //                           color: isSent ? Colors.transparent : Colors.redAccent.withOpacity(0.1)
// //                       ),
// //                     ),
// //                     child: ListTile(
// //                       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                       leading: CircleAvatar(
// //                         radius: 22,
// //                         backgroundColor: isSent ? primaryTeal.withOpacity(0.05) : Colors.redAccent.withOpacity(0.05),
// //                         child: Icon(
// //                           isSent ? Iconsax.user_tick : Iconsax.user_remove,
// //                           color: isSent ? primaryTeal : Colors.redAccent,
// //                           size: 20,
// //                         ),
// //                       ),
// //                       title: Text("User #8820$index",
// //                           style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14)),
// //                       subtitle: Text(
// //                         isSent ? "Successfully delivered via FCM" : "Error: Device token expired",
// //                         style: GoogleFonts.inter(fontSize: 11, color: Colors.blueGrey),
// //                       ),
// //                       trailing: Container(
// //                         width: 8, height: 8,
// //                         decoration: BoxDecoration(
// //                           color: isSent ? Colors.green : Colors.red,
// //                           shape: BoxShape.circle,
// //                           boxShadow: [
// //                             BoxShadow(
// //                                 color: isSent ? Colors.green : Colors.red,
// //                                 blurRadius: 6
// //                             )
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ).animate().slideX(begin: 0.2, delay: (index * 50).ms, curve: Curves.easeOutCubic).fadeIn();
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _drawerStat(String label, String value, Color color) {
// //     return Column(
// //       children: [
// //         Text(value, style: GoogleFonts.plusJakartaSans(color: color, fontWeight: FontWeight.w900, fontSize: 16)),
// //         Text(label, style: GoogleFonts.inter(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
// //       ],
// //     );
// //   }
// //   Widget _buildSocketMonitor() {
// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFF0F172A),
// //         borderRadius: BorderRadius.circular(24),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 10, height: 10,
// //             decoration: BoxDecoration(
// //                 color: isSocketConnected ? Colors.tealAccent : Colors.redAccent,
// //                 shape: BoxShape.circle
// //             ),
// //           ).animate(onPlay: (c) => c.repeat()).scale(end: const Offset(1.6, 1.6)).fadeOut(),
// //           const SizedBox(width: 16),
// //           Text(isSocketConnected ? "CORE ACTIVE" : "CORE OFFLINE",
// //               style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1)),
// //           const Spacer(),
// //           const Icon(Iconsax.radar, color: Colors.white24, size: 20),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSegmentedToggle() {
// //     return Container(
// //       padding: const EdgeInsets.all(6),
// //       decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(20)),
// //       child: Row(
// //         children: [
// //           _toggleButton("Scheduled", 0),
// //           _toggleButton("History", 1),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _toggleButton(String label, int index) {
// //     bool isSelected = activeTab == index;
// //     return Expanded(
// //       child: GestureDetector(
// //         onTap: () => setState(() => activeTab = index),
// //         child: AnimatedContainer(
// //           duration: 300.ms,
// //           padding: const EdgeInsets.symmetric(vertical: 12),
// //           decoration: BoxDecoration(
// //             color: isSelected ? Colors.white : Colors.transparent,
// //             borderRadius: BorderRadius.circular(16),
// //           ),
// //           child: Center(
// //             child: Text(label, style: GoogleFonts.plusJakartaSans(
// //                 fontWeight: FontWeight.bold, color: isSelected ? primaryTeal : Colors.blueGrey)),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildScheduledQueue() {
// //     return Column(
// //       children: [
// //         _actionCard("Pro Subscription Alert", Colors.amber, Iconsax.timer_1),
// //         _actionCard("System Update v2.4", primaryTeal, Iconsax.document_upload),
// //       ],
// //     ).animate().fadeIn();
// //   }
// //
// //   Widget _buildDeliveryHistory() {
// //     return Column(
// //       children: [
// //         _statsCard("Live Broadcast: Site Alpha", "98%", "2%", Colors.purple, Iconsax.video_play),
// //         _statsCard("General Maintenance", "85%", "15%", primaryTeal, Iconsax.setting_2),
// //       ],
// //     ).animate().fadeIn();
// //   }
// //
// //   // UPDATED: Added Watermark Icon Background and Centered Footer Label as per image_94f153.png
// //   Widget _actionCard(String title, Color color, IconData icon) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(32),
// //         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)],
// //       ),
// //       child: Stack(
// //         alignment: Alignment.center,
// //         children: [
// //           // Ghost Watermark Icon
// //           Positioned(
// //             right: -10,
// //             top: -10,
// //             child: Icon(icon, size: 120, color: color.withOpacity(0.03)),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(24),
// //             child: Column(
// //               children: [
// //                 Row(
// //                   children: [
// //                     CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 20)),
// //                     const SizedBox(width: 16),
// //                     Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16)),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 40),
// //                 // Centered "Action Required" footer style from image_94f153.png
// //                 Text("Action Required",
// //                     style: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 16)),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // UPDATED: Added Star/Ghost Icon and Centered Percentage Badges as per image_94f153.png
// //   Widget _statsCard(String title, String success, String fail, Color color, IconData icon) {
// //     return GestureDetector(
// //       onTap: () => _scaffoldKey.currentState?.openDrawer(),
// //       child: Container(
// //         margin: const EdgeInsets.only(bottom: 16),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(32),
// //           boxShadow: [BoxShadow(color: color.withOpacity(0.05), blurRadius: 20)],
// //         ),
// //         child: Stack(
// //           alignment: Alignment.center,
// //           children: [
// //             // Ghost Watermark Star (or icon) from image_94f153.png
// //             Positioned(
// //               right: -10,
// //               top: -10,
// //               child: Icon(Iconsax.star, size: 120, color: color.withOpacity(0.03)),
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.all(24),
// //               child: Column(
// //                 children: [
// //                   Row(
// //                     children: [
// //                       Icon(icon, color: color, size: 22),
// //                       const SizedBox(width: 12),
// //                       Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15)),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 40),
// //                   // Centered Percentage badges from image_94f153.png
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       _badge(success, Colors.green),
// //                       const SizedBox(width: 12),
// //                       _badge(fail, Colors.red),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _badge(String val, Color color) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //       decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
// //       child: Row(
// //         children: [
// //           Icon(color == Colors.green ? Icons.check_circle : Icons.cancel, color: color, size: 14),
// //           const SizedBox(width: 6),
// //           Text(val, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildWatermarkLogo() {
// //     return Opacity(
// //       opacity: 0.05,
// //       child: Column(
// //         children: [
// //           const Icon(Iconsax.setting_5, size: 80),
// //           const SizedBox(height: 8),
// //           Text("ANCIL MEDIA",
// //               style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 8)),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBackgroundAesthetic() => Positioned(top: -100, left: -100, child: CircleAvatar(radius: 200, backgroundColor: primaryTeal.withOpacity(0.04)));
// //
// //   Widget _buildModernAppBar() => SliverAppBar(backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Iconsax.menu_1, color: Colors.black), onPressed: () => _scaffoldKey.currentState?.openDrawer()));
// // }
//
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import '../Controller/PushNotification_controller.dart'; // Ensure path is correct
//
// class MasterIntelligenceHub extends StatefulWidget {
//   const MasterIntelligenceHub({super.key});
//
//   @override
//   State<MasterIntelligenceHub> createState() => _MasterIntelligenceHubState();
// }
//
// class _MasterIntelligenceHubState extends State<MasterIntelligenceHub> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   bool isSocketConnected = true;
//   int activeTab = 0; // 0: Scheduled, 1: History
//   final Color primaryTeal = const Color(0xFF0D9488);
//
//   // To store the currently selected notification for the drawer
//   Map<String, dynamic>? selectedNotification;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: const Color(0xFFF8FAFC),
//       // Drawer now dynamic based on selectedNotification
//       drawer: _buildHistoryDrawer(),
//       body: Stack(
//         children: [
//           _buildBackgroundAesthetic(),
//           CustomScrollView(
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               _buildModernAppBar(),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   child: Column(
//                     children: [
//                       _buildSocketMonitor(),
//                       const SizedBox(height: 32),
//                       _buildSegmentedToggle(),
//                       const SizedBox(height: 24),
//
//                       // API INTEGRATION: Fetching real data
//                       FutureBuilder<List<Map<String, dynamic>>>(
//                         future: PushNotificationController.fetchNotifications(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return const Center(child: CircularProgressIndicator());
//                           }
//                           if (snapshot.hasError) {
//                             return Center(child: Text("Error: ${snapshot.error}"));
//                           }
//
//                           final allData = snapshot.data ?? [];
//
//                           // Filter data based on tab
//                           final scheduled = allData.where((n) => n['status'] == 'pending').toList();
//                           final history = allData.where((n) => n['status'] == 'sent' || n['status'] == 'processing').toList();
//
//                           return activeTab == 0
//                               ? _buildScheduledQueue(scheduled)
//                               : _buildDeliveryHistory(history);
//                         },
//                       ),
//
//                       const SizedBox(height: 100),
//                       _buildWatermarkLogo(),
//                       const SizedBox(height: 50),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   /* =========================================================
//      📥 DYNAMIC DRAWER (MESSAGE-WISE)
//   ========================================================= */
//   Widget _buildHistoryDrawer() {
//     if (selectedNotification == null) return const Drawer();
//
//     return Drawer(
//       width: MediaQuery.of(context).size.width * 0.85,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.fromLTRB(24, 80, 24, 32),
//             width: double.infinity,
//             color: const Color(0xFF0F172A),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Icon(Iconsax.user_octagon, color: Colors.tealAccent, size: 32),
//                 const SizedBox(height: 20),
//                 Text(selectedNotification!['title'] ?? "Campaign History",
//                     style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
//                 Text("Recipient Tracking for ${selectedNotification!['event']}",
//                     style: GoogleFonts.inter(color: Colors.white38, fontSize: 12)),
//               ],
//             ),
//           ),
//
//           // FETCHING LIVE STATS FROM CONTROLLER
//           FutureBuilder<Map<String, dynamic>>(
//             future: PushNotificationController.getDeliveryStats(selectedNotification!['_id']),
//             builder: (context, statsSnapshot) {
//               final sent = statsSnapshot.data?['sent'] ?? 0;
//               final failed = statsSnapshot.data?['failed'] ?? 0;
//
//               return Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                 color: const Color(0xFF1E293B),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _drawerStat("SENT", "$sent", Colors.tealAccent),
//                     _drawerStat("FAILED", "$failed", Colors.redAccent),
//                     _drawerStat("TOTAL", "${sent + failed}", Colors.amberAccent),
//                   ],
//                 ),
//               );
//             },
//           ),
//
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(20),
//               itemCount: (selectedNotification!['fcmTokens'] as List?)?.length ?? 0,
//               itemBuilder: (context, index) {
//                 // Since individual logs are in NotificationDelivery, you'd usually fetch them here.
//                 // For now, we display the token list or a placeholder list.
//                 return ListTile(
//                   leading: const Icon(Iconsax.user_tick, color: Colors.teal),
//                   title: Text("Token ID ...${selectedNotification!['fcmTokens'][index].toString().substring(0, 5)}"),
//                   subtitle: const Text("Message Dispatched"),
//                 ).animate().slideX();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /* =========================================================
//      🏗 LIST BUILDERS
//   ========================================================= */
//   Widget _buildScheduledQueue(List<Map<String, dynamic>> data) {
//     if (data.isEmpty) return _buildEmptyState("No scheduled notifications");
//     return Column(
//       children: data.map((n) => _actionCard(
//           n['title'],
//           _getColor(n['color']),
//           _getIcon(n['icon']),
//           n['_id']
//       )).toList(),
//     ).animate().fadeIn();
//   }
//
//   Widget _buildDeliveryHistory(List<Map<String, dynamic>> data) {
//     if (data.isEmpty) return _buildEmptyState("No notification history");
//     return Column(
//       children: data.map((n) => _statsCard(n)).toList(),
//     ).animate().fadeIn();
//   }
//
//   /* =========================================================
//      💎 UI COMPONENTS (INTEGRATED WITH CONTROLLER)
//   ========================================================= */
//
//   Widget _actionCard(String title, Color color, IconData icon, String id) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
//       child: Stack(
//         children: [
//           Positioned(right: -10, top: -10, child: Icon(icon, size: 120, color: color.withOpacity(0.03))),
//           Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 20)),
//                     const SizedBox(width: 16),
//                     Expanded(child: Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16))),
//                     IconButton(
//                       icon: const Icon(Iconsax.trash, color: Colors.red, size: 18),
//                       onPressed: () => _confirmDelete(id),
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 40),
//                 Text("Action Required", style: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 16)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _statsCard(Map<String, dynamic> notification) {
//     final color = _getColor(notification['color']);
//     final icon = _getIcon(notification['icon']);
//
//     return GestureDetector(
//       onTap: () {
//         setState(() => selectedNotification = notification);
//         _scaffoldKey.currentState?.openDrawer();
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
//         child: Stack(
//           children: [
//             Positioned(right: -10, top: -10, child: Icon(Iconsax.star, size: 120, color: color.withOpacity(0.03))),
//             Padding(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Icon(icon, color: color, size: 22),
//                       const SizedBox(width: 12),
//                       Expanded(child: Text(notification['title'], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15))),
//                     ],
//                   ),
//                   const SizedBox(height: 40),
//
//                   // LIVE API DATA: Fetching Stats for the specific card
//                   FutureBuilder<Map<String, dynamic>>(
//                     future: PushNotificationController.getDeliveryStats(notification['_id']),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) return const SizedBox(height: 20);
//                       final sent = snapshot.data!['sent'] ?? 0;
//                       final failed = snapshot.data!['failed'] ?? 0;
//                       final total = sent + failed;
//                       final percent = total == 0 ? "0" : ((sent / total) * 100).toStringAsFixed(0);
//
//                       return Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _badge("$percent%", Colors.green),
//                           const SizedBox(width: 12),
//                           _badge("${100 - int.parse(percent)}%", Colors.red),
//                         ],
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /* =========================================================
//      🛠 HELPERS & ACTIONS
//   ========================================================= */
//
//   void _confirmDelete(String id) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Notification?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
//           TextButton(
//               onPressed: () async {
//                 await PushNotificationController.deleteNotification(id);
//                 Navigator.pop(context);
//                 setState(() {}); // Refresh list
//               },
//               child: const Text("Delete", style: TextStyle(color: Colors.red))
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getColor(String? colorStr) {
//     if (colorStr == null) return primaryTeal;
//     try { return Color(int.parse(colorStr.replaceFirst('#', '0xFF'))); }
//     catch (_) { return primaryTeal; }
//   }
//
//   IconData _getIcon(String? iconStr) {
//     return Iconsax.notification_bing; // Default; can map string to Iconsax icons
//   }
//
//   Widget _buildEmptyState(String msg) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 40),
//       child: Text(msg, style: GoogleFonts.inter(color: Colors.grey)),
//     );
//   }
//
//   // ... (Keep your _drawerStat, _badge, _buildSocketMonitor, _buildSegmentedToggle, etc. from previous code)
//
//   Widget _drawerStat(String label, String value, Color color) {
//     return Column(
//       children: [
//         Text(value, style: GoogleFonts.plusJakartaSans(color: color, fontWeight: FontWeight.w900, fontSize: 16)),
//         Text(label, style: GoogleFonts.inter(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
//       ],
//     );
//   }
//
//   Widget _badge(String val, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
//       child: Row(
//         children: [
//           Icon(color == Colors.green ? Icons.check_circle : Icons.cancel, color: color, size: 14),
//           const SizedBox(width: 6),
//           Text(val, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSocketMonitor() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(24)),
//       child: Row(
//         children: [
//           Container(width: 10, height: 10, decoration: BoxDecoration(color: isSocketConnected ? Colors.tealAccent : Colors.redAccent, shape: BoxShape.circle))
//               .animate(onPlay: (c) => c.repeat()).scale(end: const Offset(1.6, 1.6)).fadeOut(),
//           const SizedBox(width: 16),
//           Text(isSocketConnected ? "CORE ACTIVE" : "CORE OFFLINE", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1)),
//           const Spacer(),
//           const Icon(Iconsax.radar, color: Colors.white24, size: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSegmentedToggle() {
//     return Container(
//       padding: const EdgeInsets.all(6),
//       decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(20)),
//       child: Row(
//         children: [
//           _toggleButton("Scheduled", 0),
//           _toggleButton("History", 1),
//         ],
//       ),
//     );
//   }
//
//   Widget _toggleButton(String label, int index) {
//     bool isSelected = activeTab == index;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => setState(() => activeTab = index),
//         child: AnimatedContainer(
//           duration: 300.ms,
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(16)),
//           child: Center(child: Text(label, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: isSelected ? primaryTeal : Colors.blueGrey))),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildWatermarkLogo() => Opacity(opacity: 0.05, child: Column(children: [const Icon(Iconsax.setting_5, size: 80), const SizedBox(height: 8), Text("ANCIL MEDIA", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 8))]));
//   Widget _buildBackgroundAesthetic() => Positioned(top: -100, left: -100, child: CircleAvatar(radius: 200, backgroundColor: primaryTeal.withOpacity(0.04)));
//   Widget _buildModernAppBar() => SliverAppBar(backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Iconsax.menu_1, color: Colors.black), onPressed: () => _scaffoldKey.currentState?.openDrawer()));
// }


import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../Controller/PushNotification_controller.dart'; //
import 'PushNotification.dart'; // Your form screen

class MasterIntelligenceHub extends StatefulWidget {
  const MasterIntelligenceHub({super.key});

  @override
  State<MasterIntelligenceHub> createState() => _MasterIntelligenceHubState();
}

class _MasterIntelligenceHubState extends State<MasterIntelligenceHub> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isSocketConnected = true; //
  int activeTab = 0; // 0: Scheduled, 1: History
  final Color primaryTeal = const Color(0xFF0D9488);
  Map<String, dynamic>? selectedNotification;


  void _handleCancel(String id) async {
    try {
      // Calling the cancel API from your controller
      await PushNotificationController.cancelNotification(id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Notification cancelled successfully"), backgroundColor: Colors.orange),
        );
        // Refresh the UI
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }
  // Converts server UTC to IST (UTC + 5:30)
  String _formatToIST(String? utcString) {
    if (utcString == null || utcString.isEmpty) return "Instant Send";
    DateTime utcTime = DateTime.parse(utcString);
    DateTime istTime = utcTime.add(const Duration(hours: 5, minutes: 30));
    return DateFormat('dd MMM, hh:mm a').format(istTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: _buildHistoryDrawer(), //
      body: Stack(
        children: [
          _buildBackgroundAesthetic(),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildModernAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildSocketMonitor(),
                      const SizedBox(height: 32),
                      _buildSegmentedToggle(),
                      const SizedBox(height: 24),
                      _buildDataView(),
                      const SizedBox(height: 100),
                      _buildWatermarkLogo(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataView() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: PushNotificationController.fetchNotifications(), //
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final allData = snapshot.data ?? [];
        // final scheduled = allData.where((n) => n['status'] == 'pending').toList();
        // final history = allData.where((n) => n['status'] == 'sent' || n['status'] == 'processing').toList();

        final now = DateTime.now();

        final scheduled = allData.where((n) {
          if (n['status'] != 'pending') return false;

          if (n['scheduledAt'] == null) return false;

          final scheduledDate = DateTime.parse(n['scheduledAt']).toLocal();

          return scheduledDate.isAfter(now);
        }).toList();

        final history = allData.where((n) {

          // instant notifications
          if (n['isScheduled'] == false) return true;

          // completed / cancelled / failed
          if (
          n['status'] == 'completed' ||
              n['status'] == 'processing' ||
              n['status'] == 'sent' ||
              n['status'] == 'failed' ||
              n['status'] == 'cancelled'
          ) {
            return true;
          }

          // expired pending schedules
          if (n['scheduledAt'] != null) {

            final scheduledDate =
            DateTime.parse(n['scheduledAt']).toLocal();

            if (
            scheduledDate.isBefore(now) ||
                scheduledDate.isAtSameMomentAs(now)
            ) {
              return true;
            }
          }

          return false;
        }).toList();

        final currentList = activeTab == 0 ? scheduled : history;
        if (currentList.isEmpty) return _emptyState();

        return Column(
          children: currentList.map((n) => activeTab == 0 ? _actionCard(n) : _statsCard(n)).toList(),
        ).animate().fadeIn();
      },
    );
  }

  // --- SCHEDULED CARD (With Edit/Delete) ---
  Widget _actionCard(Map<String, dynamic> n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)],
      ),
      child: Stack(
        children: [
          Positioned(right: -10, top: -10, child: Icon(Iconsax.timer_1, size: 120, color: Colors.amber.withOpacity(0.03))),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundColor: Colors.amber.withOpacity(0.1), child: const Icon(Iconsax.timer_1, color: Colors.amber, size: 20)),
                    const SizedBox(width: 16),
                    Expanded(child: Text(n['title'] ?? "", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16))),
                    _editDeleteControls(n),
                  ],
                ),
                const SizedBox(height: 12),
                Text(n['body'] ?? "", style: GoogleFonts.inter(fontSize: 13, color: Colors.blueGrey)),
                const SizedBox(height: 24),
                _cardFooter("Action Required", _formatToIST(n['scheduledAt'])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _editDeleteControls(Map<String, dynamic> n) {
  //   return Row(
  //     children: [
  //       IconButton(
  //         icon: const Icon(Iconsax.edit, color: Colors.blue, size: 18),
  //         onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PushNotification(initialData:n))), //
  //       ),
  //       IconButton(
  //         icon: const Icon(Iconsax.trash, color: Colors.red, size: 18),
  //         onPressed: () => _confirmDelete(n['_id']), //
  //       ),
  //     ],
  //   );
  // }
  Widget _editDeleteControls(Map<String, dynamic> n) {
    return Row(
      children: [
        // Edit Button
        IconButton(
          icon: const Icon(Iconsax.edit, color: Colors.blue, size: 18),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PushNotification(initialData: n))
          ),
        ),
        // NEW: Cancel Button (Only for scheduled tasks)
        IconButton(
          icon: const Icon(Iconsax.close_circle, color: Colors.orange, size: 18),
          tooltip: "Cancel Schedule",
          onPressed: () => _handleCancel(n['_id']),
        ),
        // Delete Button
        IconButton(
          icon: const Icon(Iconsax.trash, color: Colors.red, size: 18),
          onPressed: () => _confirmDelete(n['_id']),
        ),
      ],
    );
  }
  // --- HISTORY CARD (With Recipient Stats) ---
  Widget _statsCard(Map<String, dynamic> n) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedNotification = n);
        _scaffoldKey.currentState?.openDrawer(); // Opens Recipient Tracker
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
        child: Stack(
          children: [
            Positioned(right: -10, top: -10, child: Icon(Iconsax.star, size: 120, color: primaryTeal.withOpacity(0.03))),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.notification_bing, color: primaryTeal, size: 22),
                      const SizedBox(width: 12),
                      Expanded(child: Text(n['title'] ?? "", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15))),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildStatBadges(n['_id']), // Fetches live stats per message
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadges(String id) {
    return FutureBuilder<Map<String, dynamic>>(
      future: PushNotificationController.getDeliveryStats(id), //
      builder: (context, snapshot) {
        final sent = snapshot.data?['sent'] ?? 0;
        final failed = snapshot.data?['failed'] ?? 0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _badge("$sent Success", Colors.green),
            const SizedBox(width: 12),
            _badge("$failed Failed", Colors.red),
          ],
        );
      },
    );
  }

  // --- RECIPIENT TRACKER DRAWER ---
  Widget _buildHistoryDrawer() {
    if (selectedNotification == null) return const Drawer();
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.70,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          _drawerHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: (selectedNotification!['fcmTokens'] as List?)?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Iconsax.user_tick, color: Colors.teal),
                  title: Text("Token ID: ...${selectedNotification!['fcmTokens'][index].toString().substring(0, 5)}"),
                  subtitle: const Text("Successfully Dispatched via FCM"),
                ).animate().slideX();
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- COMMON UI ELEMENTS ---
  Widget _drawerHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 32),
      width: double.infinity,
      color: const Color(0xFF0F172A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Iconsax.user_octagon, color: Colors.tealAccent, size: 28),
          const SizedBox(height: 20),
          Text(selectedNotification!['title'] ?? "History", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          Text("Recipient tracking for ${selectedNotification!['type']}", style: GoogleFonts.inter(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Notification?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(onPressed: () async {
            await PushNotificationController.deleteNotification(id); //
            Navigator.pop(context);
            setState(() {});
          }, child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  // (Helper methods like _badge, _socketMonitor, _watermarkLogo remain same as previous versions)
  Widget _badge(String val, Color color) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(12)), child: Row(children: [Icon(color == Colors.green ? Icons.check_circle : Icons.cancel, color: color, size: 14), const SizedBox(width: 6), Text(val, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13))]));
  Widget _cardFooter(String label, String time) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 14)), Text(time, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: primaryTeal))]);
  Widget _buildSocketMonitor() => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(24)), child: Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: isSocketConnected ? Colors.tealAccent : Colors.redAccent, shape: BoxShape.circle)).animate(onPlay: (c) => c.repeat()).scale(end: const Offset(1.6, 1.6)).fadeOut(), const SizedBox(width: 16), Text(isSocketConnected ? "CORE ACTIVE" : "CORE OFFLINE", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1)), const Spacer(), const Icon(Iconsax.radar, color: Colors.white24, size: 20)]));
  Widget _buildSegmentedToggle() => Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(20)), child: Row(children: [_toggleButton("Scheduled", 0), _toggleButton("History", 1)]));
  Widget _toggleButton(String label, int index) { bool isSelected = activeTab == index; return Expanded(child: GestureDetector(onTap: () => setState(() => activeTab = index), child: AnimatedContainer(duration: 300.ms, padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(16)), child: Center(child: Text(label, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: isSelected ? primaryTeal : Colors.blueGrey)))))); }
  Widget _buildWatermarkLogo() => Opacity(opacity: 0.05, child: Column(children: [const Icon(Iconsax.setting_5, size: 80), const SizedBox(height: 8), Text("ANCIL MEDIA", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 8))]));
  Widget _buildBackgroundAesthetic() => Positioned(top: -100, left: -100, child: CircleAvatar(radius: 200, backgroundColor: primaryTeal.withOpacity(0.04)));
  Widget _buildModernAppBar() => SliverAppBar(backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Iconsax.menu_1, color: Colors.black), onPressed: () => _scaffoldKey.currentState?.openDrawer()));
  Widget _emptyState() => Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Text("No Data Available", style: GoogleFonts.inter(color: Colors.grey)));
}