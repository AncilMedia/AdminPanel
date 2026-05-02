// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Socket_Service.dart';
// import '../Controller/User_controller.dart';
// import '../Model/User_Model.dart';
// import '../View_model/Authentication_state.dart';
// import 'package:provider/provider.dart';
//
// class SocketTestPage extends StatefulWidget {
//   const SocketTestPage({super.key});
//
//   @override
//   State<SocketTestPage> createState() => _SocketTestPageState();
// }
//
// class _SocketTestPageState extends State<SocketTestPage> {
//   String status = "Connecting...";
//   List<String> logs = [];
//
//   /// 🔥 USERS FROM API
//   List<UserModel> users = [];
//
//   /// 🔥 PRESENCE MAPS (from socket)
//   Map<String, String> userStatus = {};   // userId -> online/offline
//   Map<String, String?> lastSeenMap = {}; // userId -> lastSeen
//
//   @override
//   void initState() {
//     super.initState();
//     initAll();
//   }
//
//   Future<void> initAll() async {
//     await fetchUsers();   // ✅ Load users first
//     await initSocket();   // ✅ Then connect socket
//   }
//
//   /// ================= FETCH USERS =================
//   Future<void> fetchUsers() async {
//     try {
//       final authState = Provider.of<AuthState>(context, listen: false);
//
//       final data = await UserController.fetchUsers(
//         authState: authState,
//       );
//
//       setState(() {
//         users = data;
//       });
//
//       addLog("✅ Users loaded: ${users.length}");
//     } catch (e) {
//       addLog("❌ Failed to load users: $e");
//     }
//   }
//
//   /// ================= SOCKET =================
//   Future<void> initSocket() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString('userId');
//
//     if (userId == null) {
//       addLog("❌ No userId found in storage");
//       return;
//     }
//
//     SocketService().initSocket(userId);
//
//     SocketService().on("presence-update", (data) {
//       if (!mounted) return;
//
//       try {
//         final map = Map<String, dynamic>.from(data);
//
//         final id = map["userId"]?.toString();
//         final stat = map["status"]?.toString();
//         final lastSeen = map["lastSeen"]?.toString();
//
//         addLog("📩 $id → $stat");
//
//         if (id != null && stat != null) {
//           setState(() {
//             userStatus[id] = stat;
//             lastSeenMap[id] = lastSeen;
//           });
//         }
//       } catch (e) {
//         addLog("❌ Socket parse error: $e");
//       }
//     });
//
//     setState(() {
//       status = "🟢 Connected";
//     });
//   }
//
//   void addLog(String msg) {
//     setState(() {
//       logs.add(msg);
//     });
//     print(msg);
//   }
//
//   @override
//   void dispose() {
//     SocketService().dispose();
//     super.dispose();
//   }
//
//   /// ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("User Presence")),
//       body: Column(
//         children: [
//           Text(status),
//
//           /// 🔥 USER LIST FROM API (NOT SOCKET)
//           Expanded(
//             flex: 2,
//             child: ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 final user = users[index];
//
//                 final isOnline = userStatus[user.id] == "online";
//                 final lastSeen = lastSeenMap[user.id];
//
//                 return ListTile(
//                   leading: Stack(
//                     children: [
//                       CircleAvatar(
//                         child: Text(
//                           user.username.isNotEmpty
//                               ? user.username[0].toUpperCase()
//                               : "?",
//                         ),
//                       ),
//
//                       /// 🟢 ONLINE DOT
//                       if (isOnline)
//                         Positioned(
//                           right: 0,
//                           bottom: 0,
//                           child: Container(
//                             width: 12,
//                             height: 12,
//                             decoration: BoxDecoration(
//                               color: Colors.green,
//                               shape: BoxShape.circle,
//                               border:
//                               Border.all(color: Colors.white, width: 2),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//
//                   /// ✅ SHOW NAME INSTEAD OF ID
//                   title: Text(user.username),
//
//                   subtitle: Text(
//                     isOnline
//                         ? "🟢 Online"
//                         : "🔴 Offline\nLast seen: ${lastSeen ?? "N/A"}",
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           /// 🔥 LOGS
//           Expanded(
//             flex: 1,
//             child: Container(
//               color: Colors.black,
//               child: ListView(
//                 children: logs
//                     .map((e) => Text(
//                   e,
//                   style: const TextStyle(color: Colors.green),
//                 ))
//                     .toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }