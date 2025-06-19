import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../Controller/User_controller.dart';
import '../Model/User_Model.dart';
import '../View_model/Authentication_state.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String selectedRole = 'All';
  final TextEditingController _searchController = TextEditingController();
  late Future<List<UserModel>> userListFuture;

  final List<String> roles = ['All', 'Admin', 'Viewer'];

  @override
  void initState() {
    super.initState();
    final authState = Provider.of<AuthState>(context, listen: false);
    userListFuture = UserController.fetchUsers(authState: authState);
  }

  void _fetchUsers() {
    final authState = Provider.of<AuthState>(context, listen: false);
    final search = _searchController.text.trim();
    final role = selectedRole != 'All' ? selectedRole : null;

    setState(() {
      userListFuture = UserController.fetchUsers(
        authState: authState,
        search: search,
        role: role,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.09),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search by name or email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (value) => _fetchUsers(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedRole,
                    items: roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                    decoration: InputDecoration(
                      labelText: "Filter by Role",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (value) {
                      setState(() => selectedRole = value!);
                      _fetchUsers();
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: double.infinity,
            color: Colors.cyan.shade300,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                headerItem("Name"),
                verticalDivider(),
                headerItem("E-mail"),
                verticalDivider(),
                headerItem("Phone Number"),
                verticalDivider(),
                headerItem("Approve"),
                verticalDivider(),
                headerItem("Block"),
                verticalDivider(),
                headerItem("Role"),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<UserModel>>(
              future: userListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No users found'));
                }

                final users = snapshot.data!;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          dataItem(user.username),
                          verticalDivider(),
                          dataItem(user.email),
                          verticalDivider(),
                          dataItem(user.phone),
                          verticalDivider(),
                          Expanded(
                            child: Center(
                              child: user.approved == true
                                  ? const Text('Accepted', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                                  : user.approved == false
                                  ? const Text('Rejected', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final success = await UserController.updateApprovalStatus(
                                        authState: Provider.of<AuthState>(context, listen: false),
                                        userId: user.id,
                                        approve: true,
                                      );
                                      if (success) {
                                        setState(() => user.approved = true);
                                      }
                                    },
                                    icon: const Icon(Iconsax.tick_circle, color: Colors.green),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final success = await UserController.updateApprovalStatus(
                                        authState: Provider.of<AuthState>(context, listen: false),
                                        userId: user.id,
                                        approve: false,
                                      );
                                      if (success) {
                                        setState(() => user.approved = false);
                                      }
                                    },
                                    icon: const Icon(Iconsax.close_circle, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          verticalDivider(),
                          Expanded(
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(user.blocked ? 'Unblock User' : 'Block User'),
                                      content: Text(user.blocked ? 'Are you sure you want to unblock this user?' : 'Are you sure you want to block this user?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
                                        TextButton(
                                          onPressed: () async {
                                            final success = await UserController.updateBlockStatus(
                                              authState: Provider.of<AuthState>(context, listen: false),
                                              userId: user.id,
                                              block: !user.blocked,
                                            );
                                            if (success) {
                                              setState(() => user.approved = !user.blocked);
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: Text(user.blocked ? "Yes, Unblock" : "Yes, Block"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.05,
                                  width: MediaQuery.of(context).size.width * 0.05,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: user.blocked ? Colors.red.shade100 : Colors.yellow.shade100,
                                  ),
                                  child: Center(
                                    child: Text(
                                      user.blocked ? "Unblock" : "Block",
                                      style: TextStyle(
                                        color: user.blocked ? Colors.red : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          verticalDivider(),
                          dataItem(user.role),
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

  Widget headerItem(String title) => Expanded(
    child: Center(
      child: Text(
        title,
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );

  Widget dataItem(String value) => Expanded(
    child: Center(
      child: Text(
        value,
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ),
    ),
  );

  Widget verticalDivider() => Container(
    height: 30,
    width: 2,
    color: Colors.grey.shade300,
  );
}
