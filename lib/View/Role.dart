// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import '../Controller/Roles_controller.dart';
// import '../View_model/Custom_snackbar.dart';
// import 'ManageRoles.dart';
//
// class RolesPage extends StatefulWidget {
//   const RolesPage({super.key});
//
//   @override
//   State<RolesPage> createState() => _RolesPageState();
// }
//
// class _RolesPageState extends State<RolesPage> with TickerProviderStateMixin {
//   String? selectedRoleId;
//   bool isSaving = false;
//   bool showNewRoleFields = false;
//   final TextEditingController roleController = TextEditingController();
//   final TextEditingController roleDescController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final controller = context.read<RolesController>();
//       await controller.fetchRoles();
//       if (controller.roles.isNotEmpty) {
//         setState(() => selectedRoleId = controller.roles[0]['_id']);
//         await controller.fetchSidebarForRole(selectedRoleId!);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<RolesController>(
//       builder: (context, controller, _) {
//         return Scaffold(
//           appBar: AppBar(),
//           body: controller.isLoading
//               ? Center(
//               child: Lottie.network(
//                   'https://res.cloudinary.com/dggylwwqk/raw/upload/v1756724442/career_c3zrnl.json',options: LottieOptions(enableMergePaths: false),))
//               : SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Role Dropdown & Create New Role
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Existing Role Dropdown
//                     Row(
//                       children: [
//                         Text(
//                           "Role: ",
//                           style: GoogleFonts.poppins(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         // SizedBox(
//                         //   width: 220,
//                         //   child: DropdownButtonFormField<String>(
//                         //     value: selectedRoleId,
//                         //     decoration: InputDecoration(
//                         //       contentPadding: const EdgeInsets.symmetric(
//                         //           horizontal: 12, vertical: 8),
//                         //       border: OutlineInputBorder(
//                         //         borderRadius: BorderRadius.circular(10),
//                         //       ),
//                         //       enabledBorder: OutlineInputBorder(
//                         //         borderRadius: BorderRadius.circular(10),
//                         //         borderSide: const BorderSide(color: Colors.grey),
//                         //       ),
//                         //       focusedBorder: OutlineInputBorder(
//                         //         borderRadius: BorderRadius.circular(10),
//                         //         borderSide:
//                         //         const BorderSide(color: Colors.cyan, width: 2),
//                         //       ),
//                         //     ),
//                         //     items: controller.roles
//                         //         .map(
//                         //           (role) => DropdownMenuItem<String>(
//                         //         value: role['_id'],
//                         //         child: Text(role['name']),
//                         //       ),
//                         //     )
//                         //         .toList(),
//                         //     onChanged: (val) async {
//                         //       if (val != null) {
//                         //         setState(() => selectedRoleId = val);
//                         //         await controller.fetchSidebarForRole(val);
//                         //       }
//                         //     },
//                         //   ),
//                         // ),
//                         SizedBox(
//                           width: 220,
//                           child: DropdownButtonFormField<String>(
//                             // Ensure value is valid, otherwise null
//                             value: controller.roles.any((role) => role['_id'] == selectedRoleId)
//                                 ? selectedRoleId
//                                 : null,
//                             decoration: InputDecoration(
//                               contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(color: Colors.grey),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(color: Colors.cyan, width: 2),
//                               ),
//                             ),
//                             items: controller.roles
//                                 .map(
//                                   (role) => DropdownMenuItem<String>(
//                                 value: role['_id'],
//                                 child: Text(role['name']),
//                               ),
//                             )
//                                 .toList(),
//                             onChanged: (val) async {
//                               if (val != null) {
//                                 setState(() => selectedRoleId = val);
//                                 await controller.fetchSidebarForRole(val);
//                               }
//                             },
//                           ),
//                         ),
//
//                       ],
//                     ),
//
//                     MouseRegion(
//                       cursor: SystemMouseCursors.click,
//                       child: GestureDetector(
//                         onTap: () {
//                           // instead of Navigator.push(...)
//                           openManageRolesSheet(context);
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             color: Colors.cyan.shade100,
//                           ),
//                           child: Text(
//                             "Manage Roles",
//                             style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Create New Role Section
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         MouseRegion(
//                           cursor: SystemMouseCursors.click,
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() => showNewRoleFields = !showNewRoleFields);
//                             },
//                             child: Text(
//                               "Create New Role",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         AnimatedSize(
//                           duration: const Duration(milliseconds: 300),
//                           curve: Curves.easeInOut,
//                           child: showNewRoleFields
//                               ? Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   SizedBox(
//                                     height: 50,
//                                     width: 200,
//                                     child: TextFormField(
//                                       controller: roleController,
//                                       decoration: const InputDecoration(
//                                         hintText: 'Role Name',
//                                         labelText: 'Role Name',
//                                         border: OutlineInputBorder(),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   SizedBox(
//                                     height: 50,
//                                     width: 200,
//                                     child: TextFormField(
//                                       controller: roleDescController,
//                                       decoration: const InputDecoration(
//                                         hintText: 'Role Description',
//                                         labelText: 'Role Description',
//                                         border: OutlineInputBorder(),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 8),
//                               GestureDetector(
//                                 onTap: () async {
//                                   if (roleController.text.isEmpty) return;
//                                   try {
//                                     await controller.createRole(
//                                       name: roleController.text,
//                                       description: roleDescController.text,
//                                     );
//                                     roleController.clear();
//                                     roleDescController.clear();
//                                     showCustomSnackBar(
//                                         context, 'Role Created ✅', true);
//                                   } catch (e) {
//                                     showCustomSnackBar(
//                                         context, 'Failed to create role ❌', false);
//                                   }
//                                 },
//                                 child: Container(
//                                   height: 50,
//                                   width: 120,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: Colors.teal),
//                                   child: Center(
//                                     child: Text(
//                                       'Create Role',
//                                       style: GoogleFonts.poppins(
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 16,
//                                           color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           )
//                               : const SizedBox.shrink(),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Sidebar Items Header
//                 const Text(
//                   'Sidebar Items',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: const [
//                     SizedBox(width: 120),
//                     Expanded(child: Center(child: Text('View'))),
//                     Expanded(child: Center(child: Text('Read'))),
//                     Expanded(child: Center(child: Text('Manage'))),
//                     Expanded(child: Center(child: Text('All'))),
//                   ],
//                 ),
//                 const Divider(),
//
//                 // Sidebar Categories & Permissions
//                 ...controller.sidebarCategories.entries.map((entry) {
//                   String category = entry.key;
//                   List<Map<String, dynamic>> items = entry.value;
//
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         category,
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       ...items.map((item) {
//                         String key = item['key'];
//                         return Row(
//                           children: [
//                             SizedBox(
//                               width: 120,
//                               child: Text(item['label']),
//                             ),
//                             Expanded(
//                               child: Transform.scale(
//                                 scale: 0.6,
//                                 child: Switch(
//                                   value:
//                                   controller.sidebarPermissionStates[key]?['view'] ??
//                                       false,
//                                   activeColor: Colors.cyan,
//                                   onChanged: (_) =>
//                                       controller.toggleSidebarPermission(key, 'view'),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Transform.scale(
//                                 scale: 0.6,
//                                 child: Switch(
//                                   value:
//                                   controller.sidebarPermissionStates[key]?['read'] ??
//                                       false,
//                                   activeColor: Colors.cyan,
//                                   onChanged: (_) =>
//                                       controller.toggleSidebarPermission(key, 'read'),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Transform.scale(
//                                 scale: 0.6,
//                                 child: Switch(
//                                   value:
//                                   controller.sidebarPermissionStates[key]?['manage'] ??
//                                       false,
//                                   activeColor: Colors.cyan,
//                                   onChanged: (_) =>
//                                       controller.toggleSidebarPermission(key, 'manage'),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Transform.scale(
//                                 scale: 0.6,
//                                 child: Switch(
//                                   value: controller.getSidebarAll(key),
//                                   activeColor: Colors.cyan,
//                                   onChanged: (val) =>
//                                       controller.toggleSidebarAll(key, val),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                       const SizedBox(height: 12),
//                     ],
//                   );
//                 }).toList(),
//
//                 const SizedBox(height: 20),
//                 Center(
//                   child: MouseRegion(
//                     cursor: SystemMouseCursors.click,
//                     child: GestureDetector(
//                       onTap: () async {
//                         if (selectedRoleId == null) return;
//
//                         setState(() => isSaving = true);
//
//                         await controller.updateSidebarPermissions(selectedRoleId!);
//
//                         setState(() => isSaving = false);
//
//                         showCustomSnackBar(context, 'Sidebar updated ✅', true);
//                       },
//                       child: Container(
//                         height: isSaving
//                             ? MediaQuery.of(context).size.height * .0800
//                             : MediaQuery.of(context).size.height * .0500,
//                         width: MediaQuery.of(context).size.height * .3,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: isSaving ? Colors.white : Colors.teal,
//                         ),
//                         child: Center(
//                           child: isSaving
//                               ? Lottie.network(
//                             "https://res.cloudinary.com/dggylwwqk/raw/upload/v1756718762/Loading_please_wait_xlp2jp.json",
//                             height: MediaQuery.of(context).size.height * .2,
//                             options: LottieOptions(enableMergePaths: false),
//                           )
//                               : Text(
//                             'Save Sidebar',
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../Controller/Roles_controller.dart';
import '../View_model/Custom_snackbar.dart';
import 'ManageRoles.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> with TickerProviderStateMixin {
  String? selectedRoleId;
  bool isSaving = false;
  bool showNewRoleFields = false;
  final TextEditingController roleController = TextEditingController();
  final TextEditingController roleDescController = TextEditingController();

  final Color primaryTeal = const Color(0xFF008080);
  final Color accentCyan = const Color(0xFF00BCD4);
  final Color bgGrey = const Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = context.read<RolesController>();
      await controller.fetchRoles();
      if (controller.roles.isNotEmpty) {
        setState(() => selectedRoleId = controller.roles[0]['_id']);
        await controller.fetchSidebarForRole(selectedRoleId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RolesController>(
      builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: bgGrey,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              "Access Management",
              style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w600),
            ),
            actions: [
              _buildHeaderButton(
                label: "Manage Roles",
                icon: Icons.settings_suggest_outlined,
                onTap: () => openManageRolesSheet(context),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: controller.isLoading
              ? Center(child: Lottie.network('https://res.cloudinary.com/dggylwwqk/raw/upload/v1756724442/career_c3zrnl.json', height: 200))
              : CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopControls(controller),
                      const SizedBox(height: 32),
                      _buildPermissionHeader(),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      String category = controller.sidebarCategories.keys.elementAt(index);
                      return _buildCategorySection(category, controller);
                    },
                    childCount: controller.sidebarCategories.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _buildSaveButton(controller),
        );
      },
    );
  }

  Widget _buildTopControls(RolesController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select Active Role", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: controller.roles.any((role) => role['_id'] == selectedRoleId) ? selectedRoleId : null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: bgGrey,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      items: controller.roles.map((role) => DropdownMenuItem(value: role['_id'] as String, child: Text(role['name']))).toList(),
                      onChanged: (val) async {
                        if (val != null) {
                          setState(() => selectedRoleId = val);
                          await controller.fetchSidebarForRole(val);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildActionButton(
                  label: "New Role",
                  icon: showNewRoleFields ? Icons.close : Icons.add,
                  color: showNewRoleFields ? Colors.redAccent : primaryTeal,
                  onTap: () => setState(() => showNewRoleFields = !showNewRoleFields),
                ),
              ),
            ],
          ),
          if (showNewRoleFields) _buildNewRoleForm(controller),
        ],
      ),
    );
  }

  Widget _buildNewRoleForm(RolesController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildTextField(roleController, "Role Name", Icons.badge_outlined)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField(roleDescController, "Description", Icons.description_outlined)),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () async {
                if (roleController.text.isEmpty) return;
                try {
                  await controller.createRole(name: roleController.text, description: roleDescController.text);
                  roleController.clear(); roleDescController.clear();
                  showCustomSnackBar(context, 'Role Created ✅', true);
                  setState(() => showNewRoleFields = false);
                } catch (e) {
                  showCustomSnackBar(context, 'Failed to create role ❌', false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryTeal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text("Confirm Creation", style: GoogleFonts.poppins(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategorySection(String category, RolesController controller) {
    List<Map<String, dynamic>> items = controller.sidebarCategories[category]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Container(width: 4, height: 20, decoration: BoxDecoration(color: accentCyan, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Text(category.toUpperCase(), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.blueGrey)),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
            itemBuilder: (context, index) {
              final item = items[index];
              String key = item['key'];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(item['label'], style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15)),
                    ),
                    _buildPermissionToggle(controller.sidebarPermissionStates[key]?['view'] ?? false, (v) => controller.toggleSidebarPermission(key, 'view')),
                    _buildPermissionToggle(controller.sidebarPermissionStates[key]?['read'] ?? false, (v) => controller.toggleSidebarPermission(key, 'read')),
                    _buildPermissionToggle(controller.sidebarPermissionStates[key]?['manage'] ?? false, (v) => controller.toggleSidebarPermission(key, 'manage')),
                    _buildPermissionToggle(controller.getSidebarAll(key), (v) => controller.toggleSidebarAll(key, v), isAll: true),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionToggle(bool value, Function(bool) onChanged, {bool isAll = false}) {
    return Expanded(
      child: Center(
        child: InkWell(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? (isAll ? Colors.orange.withOpacity(0.1) : accentCyan.withOpacity(0.1)) : Colors.transparent,
            ),
            child: Icon(
              value ? Icons.check_circle : Icons.radio_button_off,
              color: value ? (isAll ? Colors.orange : accentCyan) : Colors.grey[300],
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(RolesController controller) {
    return InkWell(
      onTap: () async {
        if (selectedRoleId == null) return;
        setState(() => isSaving = true);
        await controller.updateSidebarPermissions(selectedRoleId!);
        setState(() => isSaving = false);
        showCustomSnackBar(context, 'Permissions Saved Successfully ✅', true);
      },
      child: Container(
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
          color: isSaving ? Colors.white : primaryTeal,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: primaryTeal.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Center(
          child: isSaving
              ? Lottie.network("https://res.cloudinary.com/dggylwwqk/raw/upload/v1756718762/Loading_please_wait_xlp2jp.json", height: 40)
              : Text('Save Permissions', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
        ),
      ),
    );
  }

  // --- Utility Widgets ---
  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20),
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildHeaderButton({required String label, required IconData icon, required VoidCallback onTap}) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: primaryTeal),
      label: Text(label, style: GoogleFonts.poppins(color: primaryTeal, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionHeader() {
    return Row(
      children: [
        const Expanded(flex: 3, child: SizedBox()),
        _headerLabel("VIEW"),
        _headerLabel("READ"),
        _headerLabel("MANAGE"),
        _headerLabel("ALL"),
      ],
    );
  }

  Widget _headerLabel(String label) {
    return Expanded(
      child: Center(
        child: Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }
}