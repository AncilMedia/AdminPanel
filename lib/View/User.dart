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
    // Adjusted flex for better proportion on dashboard
    final columnFlex = [2, 3, 2, 2, 2, 2, 1];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildTopActionCard(),
          _buildModernHeader(columnFlex),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: users.length,
                  itemBuilder: (context, index) => _buildUserRow(users[index], columnFlex),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= MODERN UI COMPONENTS =================

  Widget _buildTopActionCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
      ),
      child: Row(
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: () => showDialog(context: context, builder: (_) => AddUserDialog(onSave: _fetchUsers)),
            icon: const Icon(Iconsax.user_add, size: 20),
            label: Text("Add New User", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 20),
          Expanded(flex: 2, child: _modernSearchField()),
          const SizedBox(width: 12),
          Expanded(child: _modernDropdown(selectedRole, roles, "Filter Role")),
          const SizedBox(width: 12),
          Expanded(child: _modernDropdown(selectedApprovalStatus, approvalOptions, "Filter Status")),
        ],
      ),
    );
  }

  Widget _modernSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => _fetchUsers(),
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: const InputDecoration(
          hintText: "Search name or email...",
          prefixIcon: Icon(Iconsax.search_normal, size: 18, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _modernDropdown(String value, List<String> items, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Iconsax.arrow_down_1, size: 16),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.poppins(fontSize: 13)))).toList(),
          onChanged: (v) {
            setState(() {
              if (label.contains("Role")) selectedRole = v!;
              else selectedApprovalStatus = v!;
            });
            _fetchUsers();
          },
        ),
      ),
    );
  }

  Widget _buildModernHeader(List<int> flexes) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.cyan.shade600,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(flex: flexes[0], child: _headerText("Name")),
          Expanded(flex: flexes[1], child: _headerText("E-mail")),
          Expanded(flex: flexes[2], child: _headerText("Approval")),
          Expanded(flex: flexes[3], child: _headerText("Block Status")),
          Expanded(flex: flexes[4], child: _headerText("Role")),
          Expanded(flex: flexes[5], child: _headerText("Actions")),
        ],
      ),
    );
  }

  Widget _buildUserRow(UserModel user, List<int> flexes) {
    bool isMe = user.id == userId;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Expanded(flex: flexes[0], child: _dataText(user.username, isBold: true)),
          Expanded(flex: flexes[1], child: _dataText(user.email)),
          Expanded(flex: flexes[2], child: _buildApprovalStatus(user)),
          Expanded(flex: flexes[3], child: _buildBlockAction(user, isMe)),
          Expanded(flex: flexes[4], child: _buildRoleSelector(user)),
          Expanded(flex: flexes[5], child: _buildActionMenu(user, isMe)),
        ],
      ),
    );
  }

  // ================= DATA HELPERS =================

  Widget _buildApprovalStatus(UserModel user) {
    if (user.approved == true) return _statusChip("Approved", Colors.green);
    if (user.approved == false) return _statusChip("Rejected", Colors.red);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Iconsax.tick_circle, color: Colors.green, size: 22),
          onPressed: () => _updateApproval(user.id, true),
        ),
        IconButton(
          icon: const Icon(Iconsax.close_circle, color: Colors.red, size: 22),
          onPressed: () => _updateApproval(user.id, false),
        ),
      ],
    );
  }

  Widget _buildBlockAction(UserModel user, bool isMe) {
    bool disabled = user.approved == false || isMe;
    return Center(
      child: InkWell(
        onTap: disabled ? null : () => showDialog(context: context, builder: (_) => Block_User(user: user, onSave: _fetchUsers)),
        child: Opacity(
          opacity: disabled ? 0.4 : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: user.blocked ? Colors.red.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              user.blocked ? "Unblock" : "Block",
              style: TextStyle(color: user.blocked ? Colors.red : Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector(UserModel user) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
        child: DropdownButton<String>(
          value: user.role,
          underline: const SizedBox(),
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.blueGrey),
          items: availableRoles.map((role) => DropdownMenuItem(value: role, child: Text(role[0].toUpperCase() + role.substring(1)))).toList(),
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
    );
  }

  Widget _buildActionMenu(UserModel user, bool isMe) {
    return PopupMenuButton<String>(
      icon: const Icon(Iconsax.more, color: Colors.blueGrey),
      onSelected: (val) {
        if (val == 'edit') {
          showDialog(context: context, builder: (_) => EditUserDialog(user: user, onSave: _fetchUsers));
        } else if (val == 'delete') {
          showDialog(context: context, builder: (_) => DeleteUser(user: user, onDelete: _fetchUsers));
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Iconsax.edit, size: 18), SizedBox(width: 8), Text("Edit")])),
        if (!isMe) const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Iconsax.trash, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete", style: TextStyle(color: Colors.red))])),
      ],
    );
  }

  // --- REUSABLE MINI WIDGETS ---

  Widget _headerText(String t) => Center(child: Text(t, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)));

  Widget _dataText(String t, {bool isBold = false}) => Center(child: Text(t, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: Colors.blueGrey.shade800)));

  Widget _statusChip(String label, Color color) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/surf search.json', height: 200),
          Text("No users found matching your criteria", style: GoogleFonts.poppins(color: Colors.blueGrey, fontSize: 16)),
        ],
      ),
    );
  }

  void _updateApproval(String id, bool approve) async {
    final success = await UserController.updateApprovalStatus(
      authState: Provider.of<AuthState>(context, listen: false),
      userId: id,
      approve: approve,
    );
    if (success) _fetchUsers();
  }
}