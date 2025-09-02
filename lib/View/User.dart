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
//   String selectedBlockStatus = 'All';
//
//   final List<String> approvalOptions = [
//     'All',
//     'Approved',
//     'Rejected',
//     'Pending',
//   ];
//   final List<String> blockOptions = ['All', 'Blocked', 'Unblocked'];
//   List<String> roles = ['All'];
//   List<String> availableRoles = [];
//   String? userId;
//
//
//   @override
//   void initState() {
//     super.initState();
//     final authState = Provider.of<AuthState>(context, listen: false);
//     userListFuture = Future.value([]);
//     _initData(authState);
//     loadUserId();
//   }
//
//   void loadUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getString('userId');
//     });
//   }
//
//   void _initData(AuthState authState) async {
//     try {
//       final fetchedRoles = await UserController.fetchRoles(
//         authState: authState,
//       );
//       final fetchedUsers = await UserController.fetchUsers(
//         authState: authState,
//       );
//
//       setState(() {
//         availableRoles = fetchedRoles;
//         roles = [
//           'All',
//           ...fetchedRoles.map((r) => r[0].toUpperCase() + r.substring(1)),
//         ];
//         userListFuture = Future.value(fetchedUsers);
//       });
//     } catch (e) {
//       print("Failed to load roles or users: $e");
//       setState(() {
//         userListFuture = Future.error(e.toString());
//       });
//     }
//   }
//
//   void _fetchUsers() {
//     final authState = Provider.of<AuthState>(context, listen: false);
//     final search = _searchController.text.trim();
//     final role = selectedRole != 'All' ? selectedRole.toLowerCase() : null;
//
//     String? approved;
//     if (selectedApprovalStatus == 'Approved')
//       approved = 'true';
//     else if (selectedApprovalStatus == 'Rejected')
//       approved = 'false';
//     else if (selectedApprovalStatus == 'Pending')
//       approved = 'null';
//
//     String? blocked;
//     if (selectedBlockStatus == 'Blocked')
//       blocked = 'true';
//     else if (selectedBlockStatus == 'Unblocked')
//       blocked = 'false';
//
//     setState(() {
//       userListFuture = UserController.fetchUsers(
//         authState: authState,
//         search: search,
//         role: role,
//         approved: approved,
//         blocked: blocked,
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final columnFlex = [2, 3, 2, 2, 2, 2, 2, 1];
//
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(height: MediaQuery.of(context).size.height * 0.09),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//             child: Row(
//               children: [
//                 // Add User Button
//                 MouseRegion(
//                   cursor: SystemMouseCursors.click,
//                   child: GestureDetector(
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (_) => AddUserDialog(onSave: _fetchUsers),
//                       );
//                     },
//                     child: Container(
//                       height: MediaQuery.of(context).size.height * 0.04,
//                       width: MediaQuery.of(context).size.width * 0.06,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.teal.shade300,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Iconsax.add, color: Colors.white),
//                           Text(
//                             "Add new",
//                             style: GoogleFonts.poppins(
//                               textStyle: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: MediaQuery.of(context).size.width * 0.010),
//                 // Search Field
//                 Expanded(
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       prefixIcon: const Icon(Icons.search),
//                       hintText: "Search by name or email",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     onChanged: (value) => _fetchUsers(),
//                   ),
//                 ),
//                 SizedBox(width: MediaQuery.of(context).size.width * .250),
//                 // Filter Dropdowns
//                 Expanded(
//                   child: DropdownButtonFormField<String>(
//                     value: selectedRole,
//                     items: roles
//                         .map(
//                           (role) =>
//                               DropdownMenuItem(value: role, child: Text(role)),
//                         )
//                         .toList(),
//                     decoration: InputDecoration(
//                       labelText: "Filter by Role",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     onChanged: (value) {
//                       setState(() => selectedRole = value!);
//                       _fetchUsers();
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: DropdownButtonFormField<String>(
//                     value: selectedBlockStatus,
//                     items: blockOptions
//                         .map(
//                           (status) => DropdownMenuItem(
//                             value: status,
//                             child: Text(status),
//                           ),
//                         )
//                         .toList(),
//                     decoration: InputDecoration(
//                       labelText: "Filter by Block Status",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     onChanged: (value) {
//                       setState(() => selectedBlockStatus = value!);
//                       _fetchUsers();
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: DropdownButtonFormField<String>(
//                     value: selectedApprovalStatus,
//                     items: approvalOptions
//                         .map(
//                           (status) => DropdownMenuItem(
//                             value: status,
//                             child: Text(status),
//                           ),
//                         )
//                         .toList(),
//                     decoration: InputDecoration(
//                       labelText: "Filter by Approval",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     onChanged: (value) {
//                       setState(() => selectedApprovalStatus = value!);
//                       _fetchUsers();
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Header Row
//           Container(
//             height: MediaQuery.of(context).size.height * 0.07,
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.cyan.shade300,
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(25),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Expanded(flex: columnFlex[0], child: headerItem("Name")),
//                 Expanded(flex: columnFlex[1], child: headerItem("E-mail")),
//                 Expanded(
//                   flex: columnFlex[2],
//                   child: headerItem("Phone Number"),
//                 ),
//                 Expanded(flex: columnFlex[3], child: headerItem("Approve")),
//                 Expanded(flex: columnFlex[4], child: headerItem("Block")),
//                 Expanded(flex: columnFlex[5], child: headerItem("Role")),
//                 Expanded(flex: columnFlex[6], child: headerItem("Update")),
//               ],
//             ),
//           ),
//
//           // User List
//           Expanded(
//             child: FutureBuilder<List<UserModel>>(
//               future: userListFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: Container(
//                       height: MediaQuery.of(context).size.height * .2,
//                       width: MediaQuery.of(context).size.width * .2,
//                       child: Lottie.asset('assets/circular.json'),
//                     ),
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           height: MediaQuery.of(context).size.height * .3,
//                           width: MediaQuery.of(context).size.width * .3,
//                           child: Lottie.asset('assets/surf search.json'),
//                         ),
//                         Text(
//                           "No User Found",
//                           style: GoogleFonts.poppins(
//                             textStyle: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//
//                 final users = snapshot.data!;
//                 return ListView.builder(
//                   itemCount: users.length,
//                   itemBuilder: (context, index) {
//                     final user = users[index];
//                     return Container(
//                       height: MediaQuery.of(context).size.height * 0.07,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             flex: columnFlex[0],
//                             child: dataItem(user.username),
//                           ),
//                           Expanded(
//                             flex: columnFlex[1],
//                             child: dataItem(user.email),
//                           ),
//                           Expanded(
//                             flex: columnFlex[2],
//                             child: dataItem(user.phone),
//                           ),
//                           // Approval Status
//                           Expanded(
//                             flex: columnFlex[3],
//                             child: Center(
//                               child: user.approved == true
//                                   ? const Text(
//                                       'Accepted',
//                                       style: TextStyle(
//                                         color: Colors.green,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     )
//                                   : user.approved == false
//                                   ? const Text(
//                                       'Rejected',
//                                       style: TextStyle(
//                                         color: Colors.red,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     )
//                                   : Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         IconButton(
//                                           icon: const Icon(
//                                             Iconsax.tick_circle,
//                                             color: Colors.green,
//                                           ),
//                                           onPressed: () async {
//                                             final success =
//                                                 await UserController.updateApprovalStatus(
//                                                   authState:
//                                                       Provider.of<AuthState>(
//                                                         context,
//                                                         listen: false,
//                                                       ),
//                                                   userId: user.id,
//                                                   approve: true,
//                                                 );
//                                             if (success) _fetchUsers();
//                                           },
//                                         ),
//                                         IconButton(
//                                           icon: const Icon(
//                                             Iconsax.close_circle,
//                                             color: Colors.red,
//                                           ),
//                                           onPressed: () async {
//                                             final success =
//                                                 await UserController.updateApprovalStatus(
//                                                   authState:
//                                                       Provider.of<AuthState>(
//                                                         context,
//                                                         listen: false,
//                                                       ),
//                                                   userId: user.id,
//                                                   approve: false,
//                                                 );
//                                             if (success) _fetchUsers();
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                             ),
//                           ),
//                           // Block/Unblock Button (Disabled for Rejected)
//                           Expanded(
//                             flex: columnFlex[4],
//                             child: Center(
//                               child: user.approved == false || user.id == userId
//                                   ? Tooltip(
//                                 message: user.id == userId
//                                     ? "You cannot block/unblock yourself"
//                                     : "Rejected users cannot be blocked/unblocked",
//                                 child: Opacity(
//                                   opacity: 0.4,
//                                   child: Container(
//                                     height: MediaQuery.of(context).size.height * 0.05,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: Colors.grey.shade200,
//                                     ),
//                                     child: const Center(
//                                       child: Text(
//                                         "Disabled",
//                                         style: TextStyle(color: Colors.grey),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                                   : GestureDetector(
//                                 onTap: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) => Block_User(user: user, onSave: _fetchUsers),
//                                   );
//                                 },
//                                 child: Container(
//                                   height: MediaQuery.of(context).size.height * 0.05,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: user.blocked
//                                         ? Colors.red.shade100
//                                         : Colors.yellow.shade100,
//                                   ),
//                                   child: Center(
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                          Icon(
//                                           Icons.block_rounded,
//                                           color:  user.blocked
//                                               ? Colors.red
//                                               : Colors.orangeAccent,
//                                         ),
//                                         const SizedBox(width: 10),
//                                         Text(
//                                           user.blocked ? "Unblock" : "Block",
//                                           style: TextStyle(
//                                             color: user.blocked
//                                                 ? Colors.red
//                                                 : Colors.orangeAccent,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // Role Dropdown
//                           Expanded(
//                             flex: columnFlex[5],
//                             child: Center(
//                               child: DropdownButton<String>(
//                                 value: user.role,
//                                 underline: const SizedBox(),
//                                 items: availableRoles.map((role) {
//                                   return DropdownMenuItem(
//                                     value: role,
//                                     child: Text(
//                                       role[0].toUpperCase() + role.substring(1),
//                                     ),
//                                   );
//                                 }).toList(),
//                                 onChanged: (newRole) async {
//                                   if (newRole != null && newRole != user.role) {
//                                     final success =
//                                         await UserController.updateUserRole(
//                                           authState: Provider.of<AuthState>(
//                                             context,
//                                             listen: false,
//                                           ),
//                                           userId: user.id,
//                                           newRole: newRole,
//                                         );
//                                     if (success) _fetchUsers();
//                                   }
//                                 },
//                               ),
//                             ),
//                           ),
//                           // Edit/Delete
//                           Expanded(
//                             flex: columnFlex[6],
//                             child: PopupMenuButton<String>(
//                               icon: const Icon(Iconsax.card_edit),
//                               onSelected: (value) {
//                                 if (value == 'edit') {
//                                   showDialog(
//                                     context: context,
//                                     builder: (_) => EditUserDialog(
//                                       user: user,
//                                       onSave: _fetchUsers,
//                                     ),
//                                   );
//                                 } else if (value == 'delete') {
//                                   showDialog(
//                                     context: context,
//                                     builder: (_) => DeleteUser(
//                                       user: user,
//                                       onDelete: _fetchUsers,
//                                     ),
//                                   );
//                                 }
//                               },
//                               itemBuilder: (context) => [
//                                 const PopupMenuItem(
//                                   value: 'edit',
//                                   child: Text("Edit"),
//                                 ),
//                                 if(userId != user.id)
//                                 const PopupMenuItem(
//                                   value: 'delete',
//                                   child: Text("Delete"),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget headerItem(String title) => Center(
//     child: Text(
//       title,
//       style: GoogleFonts.poppins(
//         fontSize: 16,
//         color: Colors.white,
//         fontWeight: FontWeight.w500,
//       ),
//     ),
//   );
//
//   Widget dataItem(String value) => Center(
//     child: Text(
//       value,
//       style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
//     ),
//   );
// }


import 'package:ancilmediaadminpanel/View/PopUp/Add_user.dart';
import 'package:ancilmediaadminpanel/View/PopUp/User_block_popup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/User_controller.dart';
import '../Model/User_Model.dart';
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
  String selectedBlockStatus = 'All';

  final List<String> approvalOptions = ['All', 'Approved', 'Rejected', 'Pending'];
  final List<String> blockOptions = ['All', 'Blocked', 'Unblocked'];
  List<String> roles = ['All'];
  List<String> availableRoles = [];
  String? userId;

  @override
  void initState() {
    super.initState();
    userListFuture = Future.value([]);
    loadUserId();
    final authState = Provider.of<AuthState>(context, listen: false);
    _initData(authState);
  }

  void loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
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
      print("Failed to load roles or users: $e");
      setState(() {
        userListFuture = Future.error(e.toString());
      });
    }
  }

  void _fetchUsers() {
    final authState = Provider.of<AuthState>(context, listen: false);
    final search = _searchController.text.trim();
    final role = selectedRole != 'All' ? selectedRole.toLowerCase() : null;

    String? approved;
    if (selectedApprovalStatus == 'Approved') approved = 'true';
    else if (selectedApprovalStatus == 'Rejected') approved = 'false';
    else if (selectedApprovalStatus == 'Pending') approved = 'null';

    String? blocked;
    if (selectedBlockStatus == 'Blocked') blocked = 'true';
    else if (selectedBlockStatus == 'Unblocked') blocked = 'false';

    setState(() {
      userListFuture = UserController.fetchUsers(
        authState: authState,
        search: search,
        role: role,
        approved: approved,
        blocked: blocked,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final columnFlex = [2, 3, 2, 2, 2, 2, 2];

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.09),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                // Add User Button
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AddUserDialog(onSave: _fetchUsers),
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.teal.shade300,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.add, color: Colors.white),
                          Text(
                            "Add new",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Search Field
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search by name or email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) => _fetchUsers(),
                  ),
                ),
                const SizedBox(width: 16),
                // Filter Dropdowns
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedRole,
                    items: roles
                        .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                        .toList(),
                    decoration: InputDecoration(
                      labelText: "Filter by Role",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => selectedRole = value!);
                      _fetchUsers();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedBlockStatus,
                    items: blockOptions
                        .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                        .toList(),
                    decoration: InputDecoration(
                      labelText: "Filter by Block Status",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => selectedBlockStatus = value!);
                      _fetchUsers();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedApprovalStatus,
                    items: approvalOptions
                        .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                        .toList(),
                    decoration: InputDecoration(
                      labelText: "Filter by Approval",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => selectedApprovalStatus = value!);
                      _fetchUsers();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Header Row
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.cyan.shade300,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Row(
              children: [
                Expanded(flex: columnFlex[0], child: headerItem("Name")),
                Expanded(flex: columnFlex[1], child: headerItem("E-mail")),
                Expanded(flex: columnFlex[2], child: headerItem("Phone Number")),
                Expanded(flex: columnFlex[3], child: headerItem("Approve")),
                Expanded(flex: columnFlex[4], child: headerItem("Block")),
                Expanded(flex: columnFlex[5], child: headerItem("Role")),
                Expanded(flex: columnFlex[6], child: headerItem("Update")),
              ],
            ),
          ),

          // User List
          Expanded(
            child: FutureBuilder<List<UserModel>>(
              future: userListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Lottie.asset('assets/circular.json'),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Lottie.asset('assets/surf search.json'),
                        ),
                        Text(
                          "No User Found",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final users = snapshot.data!;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(flex: columnFlex[0], child: dataItem(user.username)),
                          Expanded(flex: columnFlex[1], child: dataItem(user.email)),
                          Expanded(flex: columnFlex[2], child: dataItem(user.phone)),
                          // Approval
                          Expanded(
                            flex: columnFlex[3],
                            child: Center(
                              child: user.approved == true
                                  ? const Text(
                                'Accepted',
                                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                              )
                                  : user.approved == false
                                  ? const Text(
                                'Rejected',
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Iconsax.tick_circle, color: Colors.green),
                                    onPressed: () async {
                                      final success = await UserController.updateApprovalStatus(
                                        authState: Provider.of<AuthState>(context, listen: false),
                                        userId: user.id,
                                        approve: true,
                                      );
                                      if (success) _fetchUsers();
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Iconsax.close_circle, color: Colors.red),
                                    onPressed: () async {
                                      final success = await UserController.updateApprovalStatus(
                                        authState: Provider.of<AuthState>(context, listen: false),
                                        userId: user.id,
                                        approve: false,
                                      );
                                      if (success) _fetchUsers();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Block/Unblock
                          Expanded(
                            flex: columnFlex[4],
                            child: Center(
                              child: user.approved == false || user.id == userId
                                  ? Tooltip(
                                message: user.id == userId
                                    ? "You cannot block/unblock yourself"
                                    : "Rejected users cannot be blocked/unblocked",
                                child: Opacity(
                                  opacity: 0.4,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Disabled",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                  : GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Block_User(user: user, onSave: _fetchUsers),
                                  );
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.05,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: user.blocked ? Colors.red.shade100 : Colors.yellow.shade100,
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.block_rounded,
                                            color: user.blocked ? Colors.red : Colors.orangeAccent),
                                        const SizedBox(width: 10),
                                        Text(
                                          user.blocked ? "Unblock" : "Block",
                                          style: TextStyle(
                                            color: user.blocked ? Colors.red : Colors.orangeAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Role Dropdown
                          Expanded(
                            flex: columnFlex[5],
                            child: Center(
                              child: DropdownButton<String>(
                                value: user.role,
                                underline: const SizedBox(),
                                items: availableRoles.map((role) {
                                  return DropdownMenuItem(
                                    value: role,
                                    child: Text(role[0].toUpperCase() + role.substring(1)),
                                  );
                                }).toList(),
                                onChanged: (newRole) async {
                                  if (newRole != null && newRole != user.role) {
                                    final success = await UserController.updateUserRole(
                                      authState: Provider.of<AuthState>(context, listen: false),
                                      userId: user.id,
                                      newRole: newRole,
                                    );
                                    if (success) _fetchUsers();
                                  }
                                },
                              ),
                            ),
                          ),
                          // Edit/Delete
                          Expanded(
                            flex: columnFlex[6],
                            child: PopupMenuButton<String>(
                              icon: const Icon(Iconsax.card_edit),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  showDialog(
                                    context: context,
                                    builder: (_) => EditUserDialog(user: user, onSave: _fetchUsers),
                                  );
                                } else if (value == 'delete') {
                                  showDialog(
                                    context: context,
                                    builder: (_) => DeleteUser(user: user, onDelete: _fetchUsers),
                                  );
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(value: 'edit', child: Text("Edit")),
                                if (userId != user.id) const PopupMenuItem(value: 'delete', child: Text("Delete")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget headerItem(String title) => Center(
    child: Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget dataItem(String value) => Center(
    child: Text(
      value,
      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
    ),
  );
}
