import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../Controller/Roles_controller.dart';

class ManageRoles extends StatefulWidget {
  const ManageRoles({super.key});

  @override
  State<ManageRoles> createState() => _ManageRolesState();
}

class _ManageRolesState extends State<ManageRoles> {
  // Matching the high-end palette from RolesPage
  final Color primaryBrand = const Color(0xFF0F172A); // Slate 900
  final Color accentAction = const Color(0xFF6366F1); // Indigo 500
  final Color background = const Color(0xFFF8FAFC); // Slate 50
  final Color slate200 = const Color(0xFFE2E8F0);
  final Color slate400 = const Color(0xFF94A3B8);
  final Color slate500 = const Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RolesController>(context, listen: false).fetchRoles());
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat("MMM dd, yyyy").format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Consumer<RolesController>(
        builder: (context, rolesController, child) {
          return Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: rolesController.isLoading
                    ? Center(child: CircularProgressIndicator(color: accentAction))
                    : _buildRolesList(rolesController),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(bottom: BorderSide(color: slate200)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentAction.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Iconsax.security_user, color: accentAction, size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Role Identities",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: primaryBrand,
                ),
              ),
              Text(
                "Manage system access levels",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: slate500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: slate400),
          ),
        ],
      ),
    );
  }

  Widget _buildRolesList(RolesController controller) {
    if (controller.roles.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.ghost, size: 64, color: slate200),
            const SizedBox(height: 16),
            Text("No roles found", style: GoogleFonts.plusJakartaSans(color: slate400)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: controller.roles.length,
      itemBuilder: (context, index) {
        final role = controller.roles[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: slate200.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryBrand.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      role['name']?.toString().toUpperCase() ?? "ROLE",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: primaryBrand,
                      ),
                    ),
                  ),
                  _buildActionButtons(role['_id'].toString()),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                role['description'] ?? "No description provided.",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: slate500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Iconsax.calendar_1, size: 14, color: slate400),
                  const SizedBox(width: 6),
                  Text(
                    "Created: ${formatDate(role['createdAt'])}",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: slate400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(String roleId) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconBtn(Iconsax.edit, Colors.amber, () {}),
        const SizedBox(width: 8),
        _buildIconBtn(Iconsax.trash, Colors.redAccent, () => _confirmDelete(context, roleId)),
      ],
    );
  }

  Widget _buildIconBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String roleId) async {
    final rolesController = Provider.of<RolesController>(context, listen: false);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text("Delete Role?", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
        content: Text("This action cannot be undone. Are you sure?", style: GoogleFonts.plusJakartaSans(color: slate500)),
        actions: [
          TextButton(
            child: Text("Cancel", style: GoogleFonts.plusJakartaSans(color: slate400, fontWeight: FontWeight.w700)),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text("Confirm Delete", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w700)),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await rolesController.deleteRole(roleId);
    }
  }
}

// Updated openManageRolesSheet to look cleaner on large screens
void openManageRolesSheet(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "ManageRoles",
    barrierColor: Colors.black.withOpacity(0.4), // Darker overlay for focus
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 20, 20),
            width: MediaQuery.of(context).size.width > 1200
                ? MediaQuery.of(context).size.width * 0.3
                : MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(-10, 10),
                ),
              ],
            ),
            child: const ManageRoles(),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutQuart)),
        child: child,
      );
    },
  );
}