// // import 'dart:ui';
// // import 'package:ancilmediaadminpanel/View/PopUp/Add_user.dart';
// // import 'package:ancilmediaadminpanel/View/PopUp/User_block_popup.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:lottie/lottie.dart';
// // import 'package:provider/provider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../Controller/User_controller.dart';
// // import '../Model/User_Model.dart';
// // import '../Socket_Service.dart';
// // import '../View_model/Authentication_state.dart';
// // import '../environmental variables.dart';
// // import 'PopUp/Delete_user.dart';
// // import 'PopUp/Edit_user.dart';
// // import 'package:socket_io_client/socket_io_client.dart' as IO;
// //
// //
// // class UserPage extends StatefulWidget {
// //   const UserPage({super.key});
// //
// //   @override
// //   State<UserPage> createState() => _UserPageState();
// // }
// //
// // class _UserPageState extends State<UserPage> {
// //   final TextEditingController _searchController = TextEditingController();
// //   late Future<List<UserModel>> userListFuture;
// //
// //   String selectedRole = 'All';
// //   String selectedApprovalStatus = 'All';
// //   final List<String> approvalOptions = ['All', 'Approved', 'Rejected', 'Pending'];
// //   List<String> roles = ['All'];
// //   List<String> availableRoles = [];
// //   String? userId;
// //   IO.Socket? socket;
// //   String status = "Connecting...";
// //   List<String> logs = [];
// //
// //   bool _socketInitialized = false;
// //
// //   void addLog(String msg) {
// //     if (logs.length > 100) {
// //       logs.removeAt(0); // prevent memory flood
// //     }
// //
// //     setState(() {
// //       logs.add(msg);
// //     });
// //
// //     print(msg);
// //   }
// //
// //   // Storage for online/offline status
// //   Map<String, String> userPresence = {};
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     userListFuture = Future.value([]);
// //     loadUserId();
// //     final authState = Provider.of<AuthState>(context, listen: false);
// //     _initData(authState);
// //     initSocket();
// //   }
// //
// //   void loadUserId() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() => userId = prefs.getString('userId'));
// //   }
// //
// //   void _initData(AuthState authState) async {
// //     try {
// //       final fetchedRoles = await UserController.fetchRoles(authState: authState);
// //       final fetchedUsers = await UserController.fetchUsers(authState: authState);
// //
// //       setState(() {
// //         availableRoles = fetchedRoles;
// //         roles = ['All', ...fetchedRoles.map((r) => r[0].toUpperCase() + r.substring(1))];
// //         userListFuture = Future.value(fetchedUsers);
// //       });
// //     } catch (e) {
// //       setState(() => userListFuture = Future.error(e.toString()));
// //     }
// //   }
// //
// //   void initSocket() {
// //     if (_socketInitialized) return; // ✅ prevent multiple init
// //     _socketInitialized = true;
// //
// //     SocketService().initSocket();
// //
// //     SocketService().on("presence-update", (data) {
// //       if (!mounted) return;
// //
// //       print("📩 RAW presence-update:");
// //       print(data);
// //
// //       try {
// //         final map = Map<String, dynamic>.from(data);
// //
// //         final id = map["userId"]?.toString();
// //         final status = map["status"]?.toString();
// //
// //         if (id != null && status != null) {
// //           setState(() {
// //             userPresence[id] = status;
// //           });
// //
// //           print("🟢 Updated Presence Map: $userPresence");
// //         }
// //       } catch (e) {
// //         print("❌ Error parsing socket data: $e");
// //       }
// //     });
// //   }
// //
// //   void _fetchUsers() {
// //     final authState = Provider.of<AuthState>(context, listen: false);
// //     final search = _searchController.text.trim();
// //     final role = selectedRole != 'All' ? selectedRole.toLowerCase() : null;
// //
// //     String? approved = (selectedApprovalStatus == 'Approved') ? 'true' : (selectedApprovalStatus == 'Rejected' ? 'false' : (selectedApprovalStatus == 'Pending' ? 'null' : null));
// //
// //     setState(() {
// //       userListFuture = UserController.fetchUsers(
// //         authState: authState,
// //         search: search,
// //         role: role,
// //         approved: approved,
// //       );
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF0F4F8),
// //       extendBodyBehindAppBar: true,
// //       floatingActionButton: FloatingActionButton.extended(
// //         onPressed: () => showDialog(context: context, builder: (_) => AddUserDialog(onSave: _fetchUsers)),
// //         backgroundColor: Colors.teal.shade700,
// //         elevation: 6,
// //         icon: const Icon(Iconsax.user_add, color: Colors.white),
// //         label: Text("Add User", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
// //       ),
// //       body: Stack(
// //         children: [
// //           Positioned(top: -50, right: -50, child: CircleAvatar(radius: 120, backgroundColor: Colors.cyan.withOpacity(0.05))),
// //           Column(
// //             children: [
// //               _buildModernHeader(),
// //               Expanded(
// //                 child: FutureBuilder<List<UserModel>>(
// //                   future: userListFuture,
// //                   builder: (context, snapshot) {
// //                     if (snapshot.connectionState == ConnectionState.waiting) {
// //                       return Center(child: Lottie.asset('assets/circular.json', height: 150));
// //                     } else if (snapshot.hasError) {
// //                       return Center(child: Text('Error: ${snapshot.error}'));
// //                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //                       return _buildEmptyState();
// //                     }
// //
// //                     final users = snapshot.data!;
// //                     users.sort((a, b) {
// //                       if (a.approved == null && b.approved != null) return -1;
// //                       if (a.approved != null && b.approved == null) return 1;
// //                       return 0;
// //                     });
// //
// //                     return ListView.builder(
// //                       padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
// //                       itemCount: users.length,
// //                       itemBuilder: (context, index) {
// //                         final user = users[index];
// //                         return TweenAnimationBuilder(
// //                           duration: Duration(milliseconds: 500 + (index * 100)),
// //                           tween: Tween<double>(begin: 0, end: 1),
// //                           builder: (ctx, double value, child) => Transform.translate(
// //                             offset: Offset(0, 40 * (1 - value)),
// //                             child: Opacity(opacity: value, child: child),
// //                           ),
// //                           child: UserModernCard(
// //                             user: user,
// //                             isMe: user.id == userId,
// //                             availableRoles: availableRoles,
// //                             onRefresh: _fetchUsers,
// //                             presenceStatus: userPresence[user.id], // Pass status to card
// //                           ),
// //                         );
// //                       },
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildModernHeader() {
// //     return ClipRRect(
// //       child: BackdropFilter(
// //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
// //         child: Container(
// //           padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 25),
// //           decoration: BoxDecoration(
// //             color: Colors.white.withOpacity(0.85),
// //             borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
// //             boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 5))],
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text("MANAGEMENT", style: GoogleFonts.poppins(fontSize: 12, color: Colors.cyan.shade800, fontWeight: FontWeight.bold, letterSpacing: 2)),
// //               Text("User Accounts", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.blueGrey.shade900)),
// //               const SizedBox(height: 20),
// //               Row(
// //                 children: [
// //                   Expanded(flex: 2, child: _headerSearchField()),
// //                   const SizedBox(width: 8),
// //                   Expanded(child: _headerDropdown(selectedRole, roles, "Role")),
// //                   const SizedBox(width: 8),
// //                   Expanded(child: _headerDropdown(selectedApprovalStatus, approvalOptions, "Status")),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _headerSearchField() {
// //     return Container(
// //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
// //       child: TextField(
// //         controller: _searchController,
// //         onChanged: (v) => _fetchUsers(),
// //         decoration: InputDecoration(hintText: "Search name...", prefixIcon: const Icon(Iconsax.search_normal_1, color: Colors.cyan, size: 18), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 12)),
// //       ),
// //     );
// //   }
// //
// //   Widget _headerDropdown(String value, List<String> items, String label) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 10),
// //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
// //       child: DropdownButtonHideUnderline(
// //         child: DropdownButton<String>(
// //           value: value,
// //           isExpanded: true,
// //           icon: const Icon(Iconsax.arrow_down_1, size: 12),
// //           style: GoogleFonts.poppins(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.w500),
// //           items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
// //           onChanged: (v) {
// //             setState(() { if (label == "Role") selectedRole = v!; else selectedApprovalStatus = v!; });
// //             _fetchUsers();
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildEmptyState() {
// //     return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Lottie.asset('assets/surf search.json', height: 200), Text("No users found.", style: GoogleFonts.poppins(color: Colors.blueGrey))]));
// //   }
// // }
// //
// // class UserModernCard extends StatelessWidget {
// //   final UserModel user;
// //   final bool isMe;
// //   final List<String> availableRoles;
// //   final VoidCallback onRefresh;
// //   final String? presenceStatus;
// //
// //   const UserModernCard({
// //     super.key,
// //     required this.user,
// //     required this.isMe,
// //     required this.availableRoles,
// //     required this.onRefresh,
// //     this.presenceStatus,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final String initial = user.username.isNotEmpty ? user.username[0].toUpperCase() : "?";
// //     final bool isPending = user.approved == null;
// //     final bool isOnline = presenceStatus == "online";
// //
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 18),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(28),
// //         border: isPending ? Border.all(color: Colors.orange.shade300, width: 1.5) : null,
// //         boxShadow: [
// //           BoxShadow(
// //             color: isPending ? Colors.orange.withOpacity(0.08) : Colors.black.withOpacity(0.04),
// //             blurRadius: 15,
// //             offset: const Offset(0, 8),
// //           )
// //         ],
// //       ),
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(28),
// //         child: Stack(
// //           children: [
// //             if (isPending)
// //               Positioned(
// //                 top: 15, right: 15,
// //                 child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
// //               ),
// //             Column(
// //               children: [
// //                 Padding(
// //                   padding: const EdgeInsets.all(18),
// //                   child: Row(
// //                     children: [
// //                       // Avatar with Online indicator
// //                       Stack(
// //                         children: [
// //                           Container(
// //                             width: 55, height: 55,
// //                             decoration: BoxDecoration(
// //                                 gradient: LinearGradient(colors: isPending ? [Colors.orange.shade300, Colors.orange.shade600] : [Colors.cyan.shade400, Colors.cyan.shade700]),
// //                                 borderRadius: BorderRadius.circular(18)
// //                             ),
// //                             child: Center(child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22))),
// //                           ),
// //                           if (isOnline)
// //                             Positioned(
// //                               bottom: 0,
// //                               right: 0,
// //                               child: Container(
// //                                 width: 14,
// //                                 height: 14,
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.greenAccent.shade700,
// //                                   shape: BoxShape.circle,
// //                                   border: Border.all(color: Colors.white, width: 2),
// //                                 ),
// //                               ),
// //                             ),
// //                         ],
// //                       ),
// //                       const SizedBox(width: 15),
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(user.username + (isMe ? " (You)" : ""), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey.shade900)),
// //                             Text(user.email, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
// //                           ],
// //                         ),
// //                       ),
// //                       _buildStatusBadge(),
// //                     ],
// //                   ),
// //                 ),
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                   color: isPending ? Colors.orange.withOpacity(0.03) : Colors.grey.shade50,
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(horizontal: 10),
// //                         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
// //                         child: DropdownButton<String>(
// //                           value: user.role,
// //                           underline: const SizedBox(),
// //                           icon: const Icon(Iconsax.user_edit, size: 14),
// //                           style: GoogleFonts.poppins(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.w600),
// //                           items: availableRoles.map((r) => DropdownMenuItem(value: r, child: Text(r.toUpperCase()))).toList(),
// //                           onChanged: (newRole) async {
// //                             if (newRole != null && newRole != user.role) {
// //                               final success = await UserController.updateUserRole(authState: Provider.of<AuthState>(context, listen: false), userId: user.id, newRole: newRole);
// //                               if (success) onRefresh();
// //                             }
// //                           },
// //                         ),
// //                       ),
// //                       Row(
// //                         children: [
// //                           if (isPending) ...[
// //                             _circleAction(Iconsax.tick_circle, Colors.green, () => _updateApproval(context, user.id, true)),
// //                             const SizedBox(width: 10),
// //                             _circleAction(Iconsax.close_circle, Colors.red, () => _updateApproval(context, user.id, false)),
// //                           ] else ...[
// //                             _blockButton(context),
// //                             const SizedBox(width: 8),
// //                             _actionMenu(context),
// //                           ]
// //                         ],
// //                       )
// //                     ],
// //                   ),
// //                 )
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStatusBadge() {
// //     Color color = user.approved == true ? Colors.green : (user.approved == false ? Colors.red : Colors.orange);
// //     String label = user.approved == true ? "ACTIVE" : (user.approved == false ? "REJECTED" : "PENDING");
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //       decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))),
// //       child: Text(label, style: GoogleFonts.poppins(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
// //     );
// //   }
// //
// //   Widget _circleAction(IconData icon, Color color, VoidCallback onTap) {
// //     return InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 22)));
// //   }
// //
// //   Widget _blockButton(BuildContext context) {
// //     bool disabled = user.approved == false || isMe;
// //     return InkWell(
// //       onTap: disabled ? null : () => showDialog(context: context, builder: (_) => Block_User(user: user, onSave: onRefresh)),
// //       child: Opacity(
// //         opacity: disabled ? 0.3 : 1.0,
// //         child: Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
// //           decoration: BoxDecoration(color: user.blocked ? Colors.red.shade50 : Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
// //           child: Text(user.blocked ? "UNBLOCK" : "BLOCK", style: TextStyle(color: user.blocked ? Colors.red : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _actionMenu(BuildContext context) {
// //     return PopupMenuButton<String>(
// //       icon: const Icon(Iconsax.more, color: Colors.blueGrey, size: 20),
// //       onSelected: (val) {
// //         if (val == 'edit') showDialog(context: context, builder: (_) => EditUserDialog(user: user, onSave: onRefresh));
// //         else if (val == 'delete') showDialog(context: context, builder: (_) => DeleteUser(user: user, onDelete: onRefresh));
// //       },
// //       itemBuilder: (ctx) => [
// //         const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Iconsax.edit, size: 18), SizedBox(width: 8), Text("Edit")])),
// //         if (!isMe) const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Iconsax.trash, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete", style: TextStyle(color: Colors.red))])),
// //       ],
// //     );
// //   }
// //
// //   void _updateApproval(BuildContext context, String id, bool approve) async {
// //     final success = await UserController.updateApprovalStatus(authState: Provider.of<AuthState>(context, listen: false), userId: id, approve: approve);
// //     if (success) onRefresh();
// //   }
// // }
//
//
// import 'dart:async';
// import 'dart:ui';
// import 'package:ancilmediaadminpanel/View/PopUp/Add_user.dart';
// import 'package:ancilmediaadminpanel/View/PopUp/User_block_popup.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Controller/User_controller.dart';
// import '../Model/User_Model.dart';
// import '../Socket_Service.dart';
// import '../View_model/Authentication_state.dart';
// import 'PopUp/Delete_user.dart';
// import 'PopUp/Edit_user.dart';
//
// class UserPage extends StatefulWidget {
//   const UserPage({super.key});
//
//   @override
//   State<UserPage> createState() => _UserPageState();
// }
//
// class _UserPageState extends State<UserPage> {
//   final TextEditingController _searchController = TextEditingController();
//   late Future<List<UserModel>> userListFuture;
//
//   String selectedRole = 'All';
//   String selectedApprovalStatus = 'All';
//   final List<String> approvalOptions = ['All', 'Approved', 'Rejected', 'Pending'];
//   List<String> roles = ['All'];
//   List<String> availableRoles = [];
//   String? userId;
//
//   Map<String, String> userPresence = {}; // userId -> status (online/offline)
//   bool _socketInitialized = false;
//
//   Timer? _presenceTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     userListFuture = Future.value([]);
//     loadUserId();
//     final authState = Provider.of<AuthState>(context, listen: false);
//     _initData(authState);
//     initSocket();
//     _startStatusTimer();
//   }
//
//
//   void _startStatusTimer() {
//     // Cancel any existing timer first
//     _presenceTimer?.cancel();
//
//     _presenceTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
//       if (mounted) {
//         // Option A: If you want to refresh the whole user list every 2s
//         // _fetchUsers();
//
//         // Option B: If you want to ask the socket specifically for current status
//         // SocketService().emit("get-presence-status", {"timestamp": DateTime.now().toString()});
//
//         print("⏱️ Timer: Requesting status update...");
//       }
//     });
//   }
//
//   void loadUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() => userId = prefs.getString('userId'));
//   }
//
//   void _initData(AuthState authState) async {
//     try {
//       final fetchedRoles = await UserController.fetchRoles(authState: authState);
//       final fetchedUsers = await UserController.fetchUsers(authState: authState);
//       setState(() {
//         availableRoles = fetchedRoles;
//         roles = ['All', ...fetchedRoles.map((r) => r[0].toUpperCase() + r.substring(1))];
//         userListFuture = Future.value(fetchedUsers);
//       });
//     } catch (e) {
//       setState(() => userListFuture = Future.error(e.toString()));
//     }
//   }
//
//   void initSocket() {
//     if (_socketInitialized) return;
//     _socketInitialized = true;
//
//     // SocketService().initSocket();
//
//     SocketService().on("presence-update", (data) {
//       if (data is Map<String, dynamic>) {
//         final id = data["userId"]?.toString();
//         final status = data["status"]?.toString();
//         if (id != null && status != null && mounted) {
//           setState(() => userPresence[id] = status);
//           print("🟢 Socket Update: $id is now $status");
//         }
//       }
//     });
//   }
//
//   void _fetchUsers() {
//     final authState = Provider.of<AuthState>(context, listen: false);
//     final search = _searchController.text.trim();
//     final role = selectedRole != 'All' ? selectedRole.toLowerCase() : null;
//     String? approved = (selectedApprovalStatus == 'Approved') ? 'true' : (selectedApprovalStatus == 'Rejected' ? 'false' : (selectedApprovalStatus == 'Pending' ? 'null' : null));
//
//     setState(() {
//       userListFuture = UserController.fetchUsers(
//         authState: authState,
//         search: search,
//         role: role,
//         approved: approved,
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F4F8),
//       extendBodyBehindAppBar: true,
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => showDialog(context: context, builder: (_) => AddUserDialog(onSave: _fetchUsers)),
//         backgroundColor: Colors.teal.shade700,
//         elevation: 6,
//         icon: const Icon(Iconsax.user_add, color: Colors.white),
//         label: Text("Add User", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
//       ),
//       body: Stack(
//         children: [
//           Positioned(top: -50, right: -50, child: CircleAvatar(radius: 120, backgroundColor: Colors.cyan.withOpacity(0.05))),
//           Column(
//             children: [
//               _buildModernHeader(),
//               Expanded(
//                 child: FutureBuilder<List<UserModel>>(
//                   future: userListFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: Lottie.asset('assets/circular.json', height: 150));
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return _buildEmptyState();
//                     }
//
//                     final users = snapshot.data!;
//                     users.sort((a, b) {
//                       if (a.approved == null && b.approved != null) return -1;
//                       if (a.approved != null && b.approved == null) return 1;
//                       return 0;
//                     });
//
//                     return ListView.builder(
//                       padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
//                       itemCount: users.length,
//                       itemBuilder: (context, index) {
//                         final user = users[index];
//                         return UserModernCard(
//                           user: user,
//                           isMe: user.id == userId,
//                           availableRoles: availableRoles,
//                           onRefresh: _fetchUsers,
//                           presenceStatus: userPresence[user.id],
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ... (Keep your _buildModernHeader, _headerSearchField, _headerDropdown, and _buildEmptyState methods exactly as they were)
//   Widget _buildModernHeader() {
//     return ClipRRect(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 25),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.85),
//             borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
//             boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 5))],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("MANAGEMENT", style: GoogleFonts.poppins(fontSize: 12, color: Colors.cyan.shade800, fontWeight: FontWeight.bold, letterSpacing: 2)),
//               Text("User Accounts", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.blueGrey.shade900)),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(flex: 2, child: _headerSearchField()),
//                   const SizedBox(width: 8),
//                   Expanded(child: _headerDropdown(selectedRole, roles, "Role")),
//                   const SizedBox(width: 8),
//                   Expanded(child: _headerDropdown(selectedApprovalStatus, approvalOptions, "Status")),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _headerSearchField() {
//     return Container(
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
//       child: TextField(
//         controller: _searchController,
//         onChanged: (v) => _fetchUsers(),
//         decoration: InputDecoration(hintText: "Search name...", prefixIcon: const Icon(Iconsax.search_normal_1, color: Colors.cyan, size: 18), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 12)),
//       ),
//     );
//   }
//
//   Widget _headerDropdown(String value, List<String> items, String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value,
//           isExpanded: true,
//           icon: const Icon(Iconsax.arrow_down_1, size: 12),
//           style: GoogleFonts.poppins(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.w500),
//           items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//           onChanged: (v) {
//             setState(() { if (label == "Role") selectedRole = v!; else selectedApprovalStatus = v!; });
//             _fetchUsers();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Lottie.asset('assets/surf search.json', height: 200), Text("No users found.", style: GoogleFonts.poppins(color: Colors.blueGrey))]));
//   }
// }
//
// class UserModernCard extends StatelessWidget {
//   final UserModel user;
//   final bool isMe;
//   final List<String> availableRoles;
//   final VoidCallback onRefresh;
//   final String? presenceStatus;
//
//   const UserModernCard({
//     super.key,
//     required this.user,
//     required this.isMe,
//     required this.availableRoles,
//     required this.onRefresh,
//     this.presenceStatus,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final String initial = user.username.isNotEmpty ? user.username[0].toUpperCase() : "?";
//     final bool isPending = user.approved == null;
//     final bool isOnline = presenceStatus == "online";
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 18, left: 16, right: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(28),
//         border: isPending ? Border.all(color: Colors.orange.shade300, width: 1.5) : null,
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(28),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(18),
//               child: Row(
//                 children: [
//                   Stack(
//                     children: [
//                       Container(
//                         width: 55, height: 55,
//                         decoration: BoxDecoration(
//                             gradient: LinearGradient(colors: isPending ? [Colors.orange.shade300, Colors.orange.shade600] : [Colors.cyan.shade400, Colors.cyan.shade700]),
//                             borderRadius: BorderRadius.circular(18)
//                         ),
//                         child: Center(child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22))),
//                       ),
//                       Positioned(
//                         bottom: 0, right: 0,
//                         child: Container(
//                           width: 16, height: 16,
//                           decoration: BoxDecoration(
//                             color: isOnline ? Colors.greenAccent.shade700 : Colors.grey.shade400,
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white, width: 3),
//                             boxShadow: isOnline ? [BoxShadow(color: Colors.greenAccent.withOpacity(0.5), blurRadius: 5, spreadRadius: 2)] : [],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(width: 15),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text(user.username + (isMe ? " (You)" : ""), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey.shade900)),
//                             const SizedBox(width: 8),
//                             Text(isOnline ? "• Online" : "• Offline", style: GoogleFonts.poppins(fontSize: 10, color: isOnline ? Colors.green : Colors.grey, fontWeight: FontWeight.w600)),
//                           ],
//                         ),
//                         Text(user.email, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
//                       ],
//                     ),
//                   ),
//                   _buildStatusBadge(user),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               color: isPending ? Colors.orange.withOpacity(0.03) : Colors.grey.shade50,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _buildRoleDropdown(context),
//                   Row(
//                     children: [
//                       if (isPending) ...[
//                         _circleAction(Iconsax.tick_circle, Colors.green, () => _updateApproval(context, user.id, true)),
//                         const SizedBox(width: 10),
//                         _circleAction(Iconsax.close_circle, Colors.red, () => _updateApproval(context, user.id, false)),
//                       ] else ...[
//                         _blockButton(context),
//                         const SizedBox(width: 8),
//                         _actionMenu(context),
//                       ]
//                     ],
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatusBadge(UserModel user) {
//     Color color = user.approved == true ? Colors.green : (user.approved == false ? Colors.red : Colors.orange);
//     String label = user.approved == true ? "ACTIVE" : (user.approved == false ? "REJECTED" : "PENDING");
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))),
//       child: Text(label, style: GoogleFonts.poppins(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
//     );
//   }
//
//   Widget _buildRoleDropdown(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
//       child: DropdownButton<String>(
//         value: user.role,
//         underline: const SizedBox(),
//         icon: const Icon(Iconsax.user_edit, size: 14),
//         style: GoogleFonts.poppins(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.w600),
//         items: availableRoles.map((r) => DropdownMenuItem(value: r, child: Text(r.toUpperCase()))).toList(),
//         onChanged: (newRole) async {
//           if (newRole != null && newRole != user.role) {
//             final success = await UserController.updateUserRole(authState: Provider.of<AuthState>(context, listen: false), userId: user.id, newRole: newRole);
//             if (success) onRefresh();
//           }
//         },
//       ),
//     );
//   }
//
//   Widget _circleAction(IconData icon, Color color, VoidCallback onTap) {
//     return InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 22)));
//   }
//
//   Widget _blockButton(BuildContext context) {
//     bool disabled = user.approved == false || isMe;
//     return InkWell(
//       onTap: disabled ? null : () => showDialog(context: context, builder: (_) => Block_User(user: user, onSave: onRefresh)),
//       child: Opacity(
//         opacity: disabled ? 0.3 : 1.0,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
//           decoration: BoxDecoration(color: user.blocked ? Colors.red.shade50 : Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
//           child: Text(user.blocked ? "UNBLOCK" : "BLOCK", style: TextStyle(color: user.blocked ? Colors.red : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
//         ),
//       ),
//     );
//   }
//
//   Widget _actionMenu(BuildContext context) {
//     return PopupMenuButton<String>(
//       icon: const Icon(Iconsax.more, color: Colors.blueGrey, size: 20),
//       onSelected: (val) {
//         if (val == 'edit') showDialog(context: context, builder: (_) => EditUserDialog(user: user, onSave: onRefresh));
//         else if (val == 'delete') showDialog(context: context, builder: (_) => DeleteUser(user: user, onDelete: onRefresh));
//       },
//       itemBuilder: (ctx) => [
//         const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Iconsax.edit, size: 18), SizedBox(width: 8), Text("Edit")])),
//         if (!isMe) const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Iconsax.trash, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete", style: TextStyle(color: Colors.red))])),
//       ],
//     );
//   }
//
//   void _updateApproval(BuildContext context, String id, bool approve) async {
//     final success = await UserController.updateApprovalStatus(authState: Provider.of<AuthState>(context, listen: false), userId: id, approve: approve);
//     if (success) onRefresh();
//   }
// }


import 'dart:async';
import 'dart:ui';
import 'package:ancilmediaadminpanel/View/PopUp/Add_user.dart';
import 'package:ancilmediaadminpanel/View/PopUp/User_block_popup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Add this to pubspec.yaml
import '../Controller/User_controller.dart';
import '../Model/User_Model.dart';
import '../Socket_Service.dart';
import '../View_model/Authentication_state.dart';
import 'PopUp/Delete_user.dart';
import 'PopUp/Edit_user.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<UserModel>> userListFuture;

  String selectedRole = 'All';
  String selectedApprovalStatus = 'All';
  final List<String> approvalOptions = ['All', 'Approved', 'Rejected', 'Pending'];
  List<String> roles = ['All'];
  List<String> availableRoles = [];
  String? userId;

  // Store both status and lastSeen
  Map<String, Map<String, dynamic>> userPresence = {};
  bool _socketInitialized = false;
  Timer? _presenceTimer;

  @override
  void initState() {
    super.initState();
    userListFuture = Future.value([]);
    loadUserId();
    final authState = Provider.of<AuthState>(context, listen: false);
    _initData(authState);
    initSocket();
    _startStatusTimer();
  }

  @override
  void dispose() {
    _presenceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _startStatusTimer() {
    _presenceTimer?.cancel();
    _presenceTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted && _socketInitialized) {
        // 🔥 FIXED: Use .emit, not .on
        SocketService().emit("get-presence-status", {
          "timestamp": DateTime.now().toIso8601String(),
          "adminId": userId
        });
      }
    });
  }

  void loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => userId = prefs.getString('userId'));
  }

  void _initData(AuthState authState) async {
    try {
      final fetchedRoles = await UserController.fetchRoles(authState: authState);
      final fetchedUsers = await UserController.fetchUsers(authState: authState);
      setState(() {
        availableRoles = fetchedRoles;
        roles = ['All', ...fetchedRoles.map((r) => r[0].toUpperCase() + r.substring(1))];
        userListFuture = Future.value(fetchedUsers);
      });
    } catch (e) {
      setState(() => userListFuture = Future.error(e.toString()));
    }
  }

  void initSocket() {
    if (_socketInitialized) return;
    _socketInitialized = true;

    SocketService().initSocket();

    SocketService().on("presence-update", (data) {
      if (data is Map && mounted) {
        final String? id = data["userId"]?.toString();
        if (id != null) {
          setState(() {
            userPresence[id] = {
              "status": data["status"]?.toString() ?? "offline",
              "lastSeen": data["lastSeen"]?.toString(),
            };
          });
        }
      }
    });
  }

  void _fetchUsers() {
    final authState = Provider.of<AuthState>(context, listen: false);
    final search = _searchController.text.trim();
    final role = selectedRole != 'All' ? selectedRole.toLowerCase() : null;
    String? approved = (selectedApprovalStatus == 'Approved') ? 'true' : (selectedApprovalStatus == 'Rejected' ? 'false' : (selectedApprovalStatus == 'Pending' ? 'null' : null));

    setState(() {
      userListFuture = UserController.fetchUsers(
        authState: authState,
        search: search,
        role: role,
        approved: approved,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(context: context, builder: (_) => AddUserDialog(onSave: _fetchUsers)),
        backgroundColor: Colors.teal.shade700,
        elevation: 6,
        icon: const Icon(Iconsax.user_add, color: Colors.white),
        label: Text("Add User", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: Stack(
        children: [
          Positioned(top: -50, right: -50, child: CircleAvatar(radius: 120, backgroundColor: Colors.cyan.withOpacity(0.05))),
          Column(
            children: [
              _buildModernHeader(),
              Expanded(
                child: FutureBuilder<List<UserModel>>(
                  future: userListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Lottie.asset('assets/circular.json', height: 150));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildEmptyState();
                    }

                    final users = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final presence = userPresence[user.id];

                        return UserModernCard(
                          user: user,
                          isMe: user.id == userId,
                          availableRoles: availableRoles,
                          onRefresh: _fetchUsers,
                          presenceStatus: presence?["status"],
                          lastSeen: presence?["lastSeen"],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernHeader() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 25),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 5))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("MANAGEMENT", style: GoogleFonts.poppins(fontSize: 12, color: Colors.cyan.shade800, fontWeight: FontWeight.bold, letterSpacing: 2)),
              Text("User Accounts", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.blueGrey.shade900)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(flex: 2, child: _headerSearchField()),
                  const SizedBox(width: 8),
                  Expanded(child: _headerDropdown(selectedRole, roles, "Role")),
                  const SizedBox(width: 8),
                  Expanded(child: _headerDropdown(selectedApprovalStatus, approvalOptions, "Status")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerSearchField() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => _fetchUsers(),
        decoration: InputDecoration(hintText: "Search name...", prefixIcon: const Icon(Iconsax.search_normal_1, color: Colors.cyan, size: 18), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 12)),
      ),
    );
  }

  Widget _headerDropdown(String value, List<String> items, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Iconsax.arrow_down_1, size: 12),
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.w500),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) {
            setState(() { if (label == "Role") selectedRole = v!; else selectedApprovalStatus = v!; });
            _fetchUsers();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Lottie.asset('assets/surf search.json', height: 200), Text("No users found.", style: GoogleFonts.poppins(color: Colors.blueGrey))]));
  }
}

class UserModernCard extends StatelessWidget {
  final UserModel user;
  final bool isMe;
  final List<String> availableRoles;
  final VoidCallback onRefresh;
  final String? presenceStatus;
  final String? lastSeen;

  const UserModernCard({
    super.key,
    required this.user,
    required this.isMe,
    required this.availableRoles,
    required this.onRefresh,
    this.presenceStatus,
    this.lastSeen,
  });

  String _formatLastSeen(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return "Offline";
    try {
      final DateTime date = DateTime.parse(isoDate).toLocal();
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) return "Just now";
      if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
      if (difference.inHours < 24) return "${difference.inHours}h ago";
      return DateFormat('MMM d, h:mm a').format(date);
    } catch (e) {
      return "Offline";
    }
  }

  @override
  Widget build(BuildContext context) {
    final String initial = user.username.isNotEmpty ? user.username[0].toUpperCase() : "?";
    final bool isPending = user.approved == null;
    final bool isOnline = presenceStatus == "online";

    return Container(
      margin: const EdgeInsets.only(bottom: 18, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: isPending ? Border.all(color: Colors.orange.shade300, width: 1.5) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 55, height: 55,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: isPending ? [Colors.orange.shade300, Colors.orange.shade600] : [Colors.cyan.shade400, Colors.cyan.shade700]),
                            borderRadius: BorderRadius.circular(18)
                        ),
                        child: Center(child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22))),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          width: 16, height: 16,
                          decoration: BoxDecoration(
                            color: isOnline ? Colors.greenAccent.shade700 : Colors.grey.shade400,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: isOnline ? [BoxShadow(color: Colors.greenAccent.withOpacity(0.5), blurRadius: 5, spreadRadius: 2)] : [],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(user.username + (isMe ? " (You)" : ""), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey.shade900)),
                            const SizedBox(width: 8),
                            Text(
                                isOnline ? "• Online" : "• ${_formatLastSeen(lastSeen)}",
                                style: GoogleFonts.poppins(fontSize: 10, color: isOnline ? Colors.green : Colors.grey, fontWeight: FontWeight.w600)
                            ),
                          ],
                        ),
                        Text(user.email, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  _buildStatusBadge(user),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: isPending ? Colors.orange.withOpacity(0.03) : Colors.grey.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRoleDropdown(context),
                  Row(
                    children: [
                      if (isPending) ...[
                        _circleAction(Iconsax.tick_circle, Colors.green, () => _updateApproval(context, user.id, true)),
                        const SizedBox(width: 10),
                        _circleAction(Iconsax.close_circle, Colors.red, () => _updateApproval(context, user.id, false)),
                      ] else ...[
                        _blockButton(context),
                        const SizedBox(width: 8),
                        _actionMenu(context),
                      ]
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(UserModel user) {
    Color color = user.approved == true ? Colors.green : (user.approved == false ? Colors.red : Colors.orange);
    String label = user.approved == true ? "ACTIVE" : (user.approved == false ? "REJECTED" : "PENDING");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))),
      child: Text(label, style: GoogleFonts.poppins(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }

  Widget _buildRoleDropdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
      child: DropdownButton<String>(
        value: user.role,
        underline: const SizedBox(),
        icon: const Icon(Iconsax.user_edit, size: 14),
        style: GoogleFonts.poppins(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.w600),
        items: availableRoles.map((r) => DropdownMenuItem(value: r, child: Text(r.toUpperCase()))).toList(),
        onChanged: (newRole) async {
          if (newRole != null && newRole != user.role) {
            final success = await UserController.updateUserRole(authState: Provider.of<AuthState>(context, listen: false), userId: user.id, newRole: newRole);
            if (success) onRefresh();
          }
        },
      ),
    );
  }

  Widget _circleAction(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 22)));
  }

  Widget _blockButton(BuildContext context) {
    bool disabled = user.approved == false || isMe;
    return InkWell(
      onTap: disabled ? null : () => showDialog(context: context, builder: (_) => Block_User(user: user, onSave: onRefresh)),
      child: Opacity(
        opacity: disabled ? 0.3 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(color: user.blocked ? Colors.red.shade50 : Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
          child: Text(user.blocked ? "UNBLOCK" : "BLOCK", style: TextStyle(color: user.blocked ? Colors.red : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _actionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Iconsax.more, color: Colors.blueGrey, size: 20),
      onSelected: (val) {
        if (val == 'edit') showDialog(context: context, builder: (_) => EditUserDialog(user: user, onSave: onRefresh));
        else if (val == 'delete') showDialog(context: context, builder: (_) => DeleteUser(user: user, onDelete: onRefresh));
      },
      itemBuilder: (ctx) => [
        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Iconsax.edit, size: 18), SizedBox(width: 8), Text("Edit")])),
        if (!isMe) const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Iconsax.trash, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete", style: TextStyle(color: Colors.red))])),
      ],
    );
  }

  void _updateApproval(BuildContext context, String id, bool approve) async {
    final success = await UserController.updateApprovalStatus(authState: Provider.of<AuthState>(context, listen: false), userId: id, approve: approve);
    if (success) onRefresh();
  }
}