import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isBlocked = false;
  String selectedRole = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> roles = ['All', 'Admin', 'Viewer'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top spacing
          SizedBox(height: MediaQuery.of(context).size.height * 0.09),

          // Search and Dropdown Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                // Search Field
                Expanded(
                  flex: 1,
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
                    onChanged: (value) {
                      // handle search here
                    },
                  ),
                ),
                 SizedBox(width: MediaQuery.of(context).size.width *.5),
                // Role Dropdown Filter
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: selectedRole,
                    items: roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: "Filter by Role",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value!;
                      });
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

          // Data Row
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                dataItem("John Doe"),
                verticalDivider(),
                dataItem("johndoe@gmail.com"),
                verticalDivider(),
                dataItem("+919023456789"),
                verticalDivider(),

                // Approve Buttons
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Approve logic
                        },
                        icon: const Icon(Iconsax.tick_circle, color: Colors.green),
                      ),
                      IconButton(
                        onPressed: () {
                          // Reject logic
                        },
                        icon: const Icon(Iconsax.close_circle, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                verticalDivider(),

                // Block/Unblock Toggle Button
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(isBlocked ? 'Unblock User' : 'Block User'),
                              content: Text(
                                isBlocked
                                    ? 'Are you sure you want to unblock this user?'
                                    : 'Are you sure you want to block this user?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close dialog
                                  },
                                  child: const Text("Close"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isBlocked = !isBlocked;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(isBlocked ? "Yes, Unblock" : "Yes, Block"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * .0500,
                        width: MediaQuery.of(context).size.width * .0500,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isBlocked ? Colors.red.shade100 : Colors.yellow.shade100,
                        ),
                        child: Center(
                          child: Text(
                            isBlocked ? "Unblock" : "Block",
                            style: TextStyle(
                              color: isBlocked ? Colors.red : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                verticalDivider(),

                // Role
                dataItem("Admin"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header Text Widget
  Widget headerItem(String title) {
    return Expanded(
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // Data Cell Text Widget
  Widget dataItem(String value) {
    return Expanded(
      child: Center(
        child: Text(
          value,
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // Vertical Divider Between Cells
  Widget verticalDivider() {
    return Container(
      height: 30,
      width: 2,
      color: Colors.grey.shade300,
    );
  }
}
