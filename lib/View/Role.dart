// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import '../Controller/Roles_controller.dart';
// import '../View_model/Custom_snackbar.dart';
//
// class RolesPage extends StatefulWidget {
//   const RolesPage({super.key});
//
//   @override
//   State<RolesPage> createState() => _RolesPageState();
// }
//
// class _RolesPageState extends State<RolesPage> {
//   String? selectedRoleId;
//   bool isSaving = false;
//   final TextEditingController roleController = TextEditingController();
//   final TextEditingController roleDescController = TextEditingController();
//
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
//
//         return Scaffold(
//           appBar: AppBar(),
//           body: controller.isLoading
//               ?  Center(child: Lottie.network('https://res.cloudinary.com/dggylwwqk/raw/upload/v1756724442/career_c3zrnl.json'))
//               : SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 🔽 Role Dropdown
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
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
//                         SizedBox(
//                           width: 220, // adjust width as needed
//                           child: DropdownButtonFormField<String>(
//                             value: selectedRoleId,
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
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Create New Role",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             SizedBox(height: MediaQuery.of(context).size.height *.010,),
//                             Row(
//                               spacing: 10,
//                               children: [
//                                 Container(
//                                   height: MediaQuery.of(context).size.height * 0.0500,
//                                   width: MediaQuery.of(context).size.height *.3,
//                                   child: TextFormField(
//                                     controller: roleController,
//                                     decoration: const InputDecoration(
//                                       hintText: 'Role Name',
//                                       labelText: 'Role Name',
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   height: MediaQuery.of(context).size.height * 0.0500,
//                                   width: MediaQuery.of(context).size.height *.3,
//                                   child:  TextFormField(
//                                     controller: roleDescController,
//                                     decoration: const InputDecoration(
//                                       hintText: 'Role Description',
//                                       labelText: 'Role Description',
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: MediaQuery.of(context).size.height *.010,),
//                             GestureDetector(
//                               onTap: () async {
//                                 if (roleController.text.isEmpty) return;
//
//                                 try {
//                                   await controller.createRole(
//                                     name: roleController.text,
//                                     description: roleDescController.text,
//                                   );
//                                   roleController.clear();
//                                   roleDescController.clear();
//                                   showCustomSnackBar(context, 'Role Created ✅', true);
//                                 } catch (e) {
//                                   showCustomSnackBar(context, 'Failed to create role ❌', false);
//                                 }
//                               },
//                               child: Container(
//                                 height: MediaQuery.of(context).size.height *.0500,
//                                 width: MediaQuery.of(context).size.width *.1,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.teal
//                                 ),
//                                 child: Center(
//                                   child: Text('Create Role',style: GoogleFonts.poppins(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 16,
//                                       color: Colors.white
//                                   ),),
//                                 ),
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//
//                 const Text(
//                   'Sidebar Items',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//
//                 // Headers
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
//                 // Categories
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
//                                   value: controller.sidebarPermissionStates[key]?['view'] ?? false,
//                                   activeColor: Colors.cyan,
//                                   onChanged: (_) => controller.toggleSidebarPermission(key, 'view'),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Transform.scale(
//                                 scale: 0.6,
//                                 child: Switch(
//                                   value: controller.sidebarPermissionStates[key]?['read'] ?? false,
//                                   activeColor: Colors.cyan,
//                                   onChanged: (_) => controller.toggleSidebarPermission(key, 'read'),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Transform.scale(
//                                 scale: 0.6,
//                                 child: Switch(
//                                   value: controller.sidebarPermissionStates[key]?['manage'] ?? false,
//                                   activeColor: Colors.cyan,
//                                   onChanged: (_) => controller.toggleSidebarPermission(key, 'manage'),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Transform.scale(
//                                 scale: 0.6,
//                                 child: Switch(
//                                   value: controller.getSidebarAll(key),
//                                   activeColor: Colors.cyan,
//                                   onChanged: (val) => controller.toggleSidebarAll(key, val),
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
//                         // 🔹 Use custom snackbar instead of default
//                         showCustomSnackBar(context, 'Sidebar updated ✅', true);
//                       },
//                       child: Container(
//                         height: isSaving ? MediaQuery.of(context).size.height * .0800 : MediaQuery.of(context).size.height * .0500,
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
  bool showNewRoleFields = false; // Toggle for drop-down effect
  final TextEditingController roleController = TextEditingController();
  final TextEditingController roleDescController = TextEditingController();

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
          appBar: AppBar(),
          body: controller.isLoading
              ? Center(
              child: Lottie.network(
                  'https://res.cloudinary.com/dggylwwqk/raw/upload/v1756724442/career_c3zrnl.json'))
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Role Dropdown & Create New Role
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Existing Role Dropdown
                    Row(
                      children: [
                        Text(
                          "Role: ",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // SizedBox(
                        //   width: 220,
                        //   child: DropdownButtonFormField<String>(
                        //     value: selectedRoleId,
                        //     decoration: InputDecoration(
                        //       contentPadding: const EdgeInsets.symmetric(
                        //           horizontal: 12, vertical: 8),
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(10),
                        //       ),
                        //       enabledBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(10),
                        //         borderSide: const BorderSide(color: Colors.grey),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(10),
                        //         borderSide:
                        //         const BorderSide(color: Colors.cyan, width: 2),
                        //       ),
                        //     ),
                        //     items: controller.roles
                        //         .map(
                        //           (role) => DropdownMenuItem<String>(
                        //         value: role['_id'],
                        //         child: Text(role['name']),
                        //       ),
                        //     )
                        //         .toList(),
                        //     onChanged: (val) async {
                        //       if (val != null) {
                        //         setState(() => selectedRoleId = val);
                        //         await controller.fetchSidebarForRole(val);
                        //       }
                        //     },
                        //   ),
                        // ),
                        SizedBox(
                          width: 220,
                          child: DropdownButtonFormField<String>(
                            // Ensure value is valid, otherwise null
                            value: controller.roles.any((role) => role['_id'] == selectedRoleId)
                                ? selectedRoleId
                                : null,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.cyan, width: 2),
                              ),
                            ),
                            items: controller.roles
                                .map(
                                  (role) => DropdownMenuItem<String>(
                                value: role['_id'],
                                child: Text(role['name']),
                              ),
                            )
                                .toList(),
                            onChanged: (val) async {
                              if (val != null) {
                                setState(() => selectedRoleId = val);
                                await controller.fetchSidebarForRole(val);
                              }
                            },
                          ),
                        ),

                      ],
                    ),

                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          // instead of Navigator.push(...)
                          openManageRolesSheet(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.cyan.shade100,
                          ),
                          child: Text(
                            "Manage Roles",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Create New Role Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              setState(() => showNewRoleFields = !showNewRoleFields);
                            },
                            child: Text(
                              "Create New Role",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: showNewRoleFields
                              ? Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: TextFormField(
                                      controller: roleController,
                                      decoration: const InputDecoration(
                                        hintText: 'Role Name',
                                        labelText: 'Role Name',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: TextFormField(
                                      controller: roleDescController,
                                      decoration: const InputDecoration(
                                        hintText: 'Role Description',
                                        labelText: 'Role Description',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () async {
                                  if (roleController.text.isEmpty) return;
                                  try {
                                    await controller.createRole(
                                      name: roleController.text,
                                      description: roleDescController.text,
                                    );
                                    roleController.clear();
                                    roleDescController.clear();
                                    showCustomSnackBar(
                                        context, 'Role Created ✅', true);
                                  } catch (e) {
                                    showCustomSnackBar(
                                        context, 'Failed to create role ❌', false);
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.teal),
                                  child: Center(
                                    child: Text(
                                      'Create Role',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Sidebar Items Header
                const Text(
                  'Sidebar Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    SizedBox(width: 120),
                    Expanded(child: Center(child: Text('View'))),
                    Expanded(child: Center(child: Text('Read'))),
                    Expanded(child: Center(child: Text('Manage'))),
                    Expanded(child: Center(child: Text('All'))),
                  ],
                ),
                const Divider(),

                // Sidebar Categories & Permissions
                ...controller.sidebarCategories.entries.map((entry) {
                  String category = entry.key;
                  List<Map<String, dynamic>> items = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ...items.map((item) {
                        String key = item['key'];
                        return Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(item['label']),
                            ),
                            Expanded(
                              child: Transform.scale(
                                scale: 0.6,
                                child: Switch(
                                  value:
                                  controller.sidebarPermissionStates[key]?['view'] ??
                                      false,
                                  activeColor: Colors.cyan,
                                  onChanged: (_) =>
                                      controller.toggleSidebarPermission(key, 'view'),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Transform.scale(
                                scale: 0.6,
                                child: Switch(
                                  value:
                                  controller.sidebarPermissionStates[key]?['read'] ??
                                      false,
                                  activeColor: Colors.cyan,
                                  onChanged: (_) =>
                                      controller.toggleSidebarPermission(key, 'read'),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Transform.scale(
                                scale: 0.6,
                                child: Switch(
                                  value:
                                  controller.sidebarPermissionStates[key]?['manage'] ??
                                      false,
                                  activeColor: Colors.cyan,
                                  onChanged: (_) =>
                                      controller.toggleSidebarPermission(key, 'manage'),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Transform.scale(
                                scale: 0.6,
                                child: Switch(
                                  value: controller.getSidebarAll(key),
                                  activeColor: Colors.cyan,
                                  onChanged: (val) =>
                                      controller.toggleSidebarAll(key, val),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      const SizedBox(height: 12),
                    ],
                  );
                }).toList(),

                const SizedBox(height: 20),
                Center(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRoleId == null) return;

                        setState(() => isSaving = true);

                        await controller.updateSidebarPermissions(selectedRoleId!);

                        setState(() => isSaving = false);

                        showCustomSnackBar(context, 'Sidebar updated ✅', true);
                      },
                      child: Container(
                        height: isSaving
                            ? MediaQuery.of(context).size.height * .0800
                            : MediaQuery.of(context).size.height * .0500,
                        width: MediaQuery.of(context).size.height * .3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isSaving ? Colors.white : Colors.teal,
                        ),
                        child: Center(
                          child: isSaving
                              ? Lottie.network(
                            "https://res.cloudinary.com/dggylwwqk/raw/upload/v1756718762/Loading_please_wait_xlp2jp.json",
                            height: MediaQuery.of(context).size.height * .2,
                          )
                              : Text(
                            'Save Sidebar',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
