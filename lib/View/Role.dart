// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:provider/provider.dart';
// // // import '../Controller/Roles_controller.dart';
// // //
// // // class RolesPage extends StatefulWidget {
// // //   const RolesPage({super.key});
// // //
// // //   @override
// // //   State<RolesPage> createState() => _RolesPageState();
// // // }
// // //
// // // class _RolesPageState extends State<RolesPage> {
// // //   String? selectedRoleId;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     WidgetsBinding.instance.addPostFrameCallback((_) async {
// // //       final controller = context.read<RolesController>();
// // //       await controller.fetchRoles();
// // //       if (controller.roles.isNotEmpty) {
// // //         setState(() => selectedRoleId = controller.roles[0]['_id']);
// // //         // 🔹 Replace refreshRole with both fetches
// // //         await controller.fetchPermissions(selectedRoleId!);
// // //         await controller.fetchSidebarForRole(selectedRoleId!);
// // //       }
// // //     });
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Consumer<RolesController>(
// // //       builder: (context, controller, _) {
// // //         if (controller.isLoading) {
// // //           return const Scaffold(
// // //             body: Center(child: CircularProgressIndicator()),
// // //           );
// // //         }
// // //
// // //         return Scaffold(
// // //           appBar: AppBar(title: const Text('Manage Role Permissions')),
// // //           body: SingleChildScrollView(
// // //             padding: const EdgeInsets.all(16),
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 // 🔽 Role Dropdown
// // //                 Row(
// // //                   children: [
// // //                     Text(
// // //                       "Role: ",
// // //                       style: GoogleFonts.poppins(
// // //                         fontSize: 16,
// // //                         fontWeight: FontWeight.w500,
// // //                       ),
// // //                     ),
// // //                     const SizedBox(width: 8),
// // //                     DropdownButton<String>(
// // //                       value: selectedRoleId,
// // //                       items: controller.roles
// // //                           .map(
// // //                             (role) => DropdownMenuItem<String>(
// // //                           value: role['_id'], // 🔹 use _id from backend
// // //                           child: Text(role['name']),
// // //                         ),
// // //                       )
// // //                           .toList(),
// // //                       onChanged: (val) async {
// // //                         if (val != null) {
// // //                           setState(() => selectedRoleId = val);
// // //                           // 🔹 Replace refreshRole
// // //                           await controller.fetchPermissions(val);
// // //                           await controller.fetchSidebarForRole(val);
// // //                         }
// // //                       },
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //
// // //                 // 🔽 Sidebar Items Header
// // //                 const Text(
// // //                   'Sidebar Items',
// // //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //                 ),
// // //                 const SizedBox(height: 8),
// // //
// // //                 // Table Headers
// // //                 Row(
// // //                   children: const [
// // //                     SizedBox(width: 120),
// // //                     Expanded(child: Center(child: Text('View'))),
// // //                     Expanded(child: Center(child: Text('Read'))),
// // //                     Expanded(child: Center(child: Text('Manage'))),
// // //                     Expanded(child: Center(child: Text('All'))),
// // //                   ],
// // //                 ),
// // //                 const Divider(),
// // //
// // //                 // 🔽 Sidebar Categories
// // //                 ...controller.sidebarCategories.entries.map((entry) {
// // //                   String category = entry.key;
// // //                   List<Map<String, dynamic>> items = entry.value;
// // //
// // //                   return Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Text(
// // //                         category,
// // //                         style: GoogleFonts.poppins(
// // //                           fontWeight: FontWeight.w600,
// // //                         ),
// // //                       ),
// // //                       ...items.map((item) {
// // //                         String key = item['key'];
// // //                         return Row(
// // //                           children: [
// // //                             SizedBox(
// // //                               width: 120,
// // //                               child: Text(item['label']),
// // //                             ),
// // //                             Expanded(
// // //                               child: Checkbox(
// // //                                 value: controller.sidebarPermissionStates[key]
// // //                                 ?['view'] ??
// // //                                     false,
// // //                                 onChanged: (_) =>
// // //                                     controller.toggleSidebarPermission(key, 'view'),
// // //                               ),
// // //                             ),
// // //                             Expanded(
// // //                               child: Checkbox(
// // //                                 value: controller.sidebarPermissionStates[key]
// // //                                 ?['read'] ??
// // //                                     false,
// // //                                 onChanged: (_) =>
// // //                                     controller.toggleSidebarPermission(key, 'read'),
// // //                               ),
// // //                             ),
// // //                             Expanded(
// // //                               child: Checkbox(
// // //                                 value: controller.sidebarPermissionStates[key]
// // //                                 ?['manage'] ??
// // //                                     false,
// // //                                 onChanged: (_) =>
// // //                                     controller.toggleSidebarPermission(key, 'manage'),
// // //                               ),
// // //                             ),
// // //                             Expanded(
// // //                               child: Checkbox(
// // //                                 value: controller.getSidebarAll(key),
// // //                                 onChanged: (val) => controller.toggleSidebarAll(
// // //                                   key,
// // //                                   val ?? false,
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         );
// // //                       }).toList(),
// // //                       const SizedBox(height: 12),
// // //                     ],
// // //                   );
// // //                 }).toList(),
// // //
// // //                 const SizedBox(height: 20),
// // //                 Center(
// // //                   child: ElevatedButton(
// // //                     onPressed: () async {
// // //                       if (selectedRoleId == null) return;
// // //                       await controller.updateSidebarPermissions(selectedRoleId!);
// // //                       ScaffoldMessenger.of(context).showSnackBar(
// // //                         const SnackBar(
// // //                           content: Text('Sidebar updated ✅'),
// // //                         ),
// // //                       );
// // //                     },
// // //                     child: const Text('Save Sidebar'),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // // }
// //
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:provider/provider.dart';
// // import '../Controller/Roles_controller.dart';
// //
// // class RolesPage extends StatefulWidget {
// //   const RolesPage({super.key});
// //
// //   @override
// //   State<RolesPage> createState() => _RolesPageState();
// // }
// //
// // class _RolesPageState extends State<RolesPage> {
// //   String? selectedRoleId;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) async {
// //       final controller = context.read<RolesController>();
// //       await controller.fetchRoles();
// //       if (controller.roles.isNotEmpty) {
// //         setState(() => selectedRoleId = controller.roles[0]['_id']);
// //         await controller.fetchSidebarForRole(selectedRoleId!);
// //       }
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer<RolesController>(
// //       builder: (context, controller, _) {
// //         if (controller.isLoading) {
// //           return const Scaffold(
// //             body: Center(child: CircularProgressIndicator()),
// //           );
// //         }
// //
// //         return Scaffold(
// //           appBar: AppBar(title: const Text('Manage Role Permissions')),
// //           body: SingleChildScrollView(
// //             padding: const EdgeInsets.all(16),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 // 🔽 Role Dropdown
// //                 Row(
// //                   children: [
// //                     Text("Role: ",
// //                         style: GoogleFonts.poppins(
// //                             fontSize: 16, fontWeight: FontWeight.w500)),
// //                     const SizedBox(width: 8),
// //                     DropdownButton<String>(
// //                       value: selectedRoleId,
// //                       items: controller.roles
// //                           .map(
// //                             (role) => DropdownMenuItem<String>(
// //                           value: role['_id'],
// //                           child: Text(role['name']),
// //                         ),
// //                       )
// //                           .toList(),
// //                       onChanged: (val) async {
// //                         if (val != null) {
// //                           setState(() => selectedRoleId = val);
// //                           await controller.fetchSidebarForRole(val);
// //                         }
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 16),
// //
// //                 const Text('Sidebar Items',
// //                     style:
// //                     TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //                 const SizedBox(height: 8),
// //
// //                 // Headers
// //                 Row(
// //                   children: const [
// //                     SizedBox(width: 120),
// //                     Expanded(child: Center(child: Text('View'))),
// //                     Expanded(child: Center(child: Text('Read'))),
// //                     Expanded(child: Center(child: Text('Manage'))),
// //                     Expanded(child: Center(child: Text('All'))),
// //                   ],
// //                 ),
// //                 const Divider(),
// //
// //                 // Categories
// //                 ...controller.sidebarCategories.entries.map((entry) {
// //                   String category = entry.key;
// //                   List<Map<String, dynamic>> items = entry.value;
// //
// //                   return Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(category,
// //                           style: GoogleFonts.poppins(
// //                               fontWeight: FontWeight.w600)),
// //                       ...items.map((item) {
// //                         String key = item['key'];
// //                         return Row(
// //                           children: [
// //                             SizedBox(width: 120, child: Text(item['label'])),
// //                             Expanded(
// //                               child: Checkbox(
// //                                 value: controller.sidebarPermissionStates[key]
// //                                 ?['view'] ??
// //                                     false,
// //                                 onChanged: (_) => controller
// //                                     .toggleSidebarPermission(key, 'view'),
// //                               ),
// //                             ),
// //                             Expanded(
// //                               child: Checkbox(
// //                                 value: controller.sidebarPermissionStates[key]
// //                                 ?['read'] ??
// //                                     false,
// //                                 onChanged: (_) => controller
// //                                     .toggleSidebarPermission(key, 'read'),
// //                               ),
// //                             ),
// //                             Expanded(
// //                               child: Checkbox(
// //                                 value: controller.sidebarPermissionStates[key]
// //                                 ?['manage'] ??
// //                                     false,
// //                                 onChanged: (_) => controller
// //                                     .toggleSidebarPermission(key, 'manage'),
// //                               ),
// //                             ),
// //                             Expanded(
// //                               child: Checkbox(
// //                                 value: controller.getSidebarAll(key),
// //                                 onChanged: (val) => controller.toggleSidebarAll(
// //                                   key,
// //                                   val ?? false,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         );
// //                       }).toList(),
// //                       const SizedBox(height: 12),
// //                     ],
// //                   );
// //                 }).toList(),
// //
// //                 const SizedBox(height: 20),
// //                 Center(
// //                   child: ElevatedButton(
// //                     onPressed: () async {
// //                       if (selectedRoleId == null) return;
// //                       await controller.updateSidebarPermissions(selectedRoleId!);
// //
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(
// //                           content: Text('Sidebar updated ✅'),
// //                         ),
// //                       );
// //                     },
// //                     child: const Text('Save Sidebar'),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../Controller/Roles_controller.dart';
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
//         if (controller.isLoading && selectedRoleId == null) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//         return Scaffold(
//           appBar: AppBar(title: const Text('Manage Role Permissions')),
//           body: controller.isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 🔽 Role Dropdown
//                 Row(
//                   children: [
//                     Text("Role: ",
//                         style: GoogleFonts.poppins(
//                             fontSize: 16, fontWeight: FontWeight.w500)),
//                     const SizedBox(width: 8),
//                     DropdownButton<String>(
//                       value: selectedRoleId,
//                       items: controller.roles
//                           .map(
//                             (role) => DropdownMenuItem<String>(
//                           value: role['_id'],
//                           child: Text(role['name']),
//                         ),
//                       )
//                           .toList(),
//                       onChanged: (val) async {
//                         if (val != null) {
//                           setState(() => selectedRoleId = val);
//                           await controller.fetchSidebarForRole(val);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//
//                 const Text('Sidebar Items',
//                     style: TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold)),
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
//                       Text(category,
//                           style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w600)),
//                       ...items.map((item) {
//                         String key = item['key'];
//                         return Row(
//                           children: [
//                             SizedBox(
//                                 width: 120, child: Text(item['label'])),
//                             Expanded(
//                               child: Checkbox(
//                                 value: controller.sidebarPermissionStates[key]
//                                 ?['view'] ??
//                                     false,
//                                 onChanged: (_) => controller
//                                     .toggleSidebarPermission(key, 'view'),
//                               ),
//                             ),
//                             Expanded(
//                               child: Checkbox(
//                                 value: controller.sidebarPermissionStates[key]
//                                 ?['read'] ??
//                                     false,
//                                 onChanged: (_) => controller
//                                     .toggleSidebarPermission(key, 'read'),
//                               ),
//                             ),
//                             Expanded(
//                               child: Checkbox(
//                                 value: controller.sidebarPermissionStates[key]
//                                 ?['manage'] ??
//                                     false,
//                                 onChanged: (_) => controller
//                                     .toggleSidebarPermission(key, 'manage'),
//                               ),
//                             ),
//                             Expanded(
//                               child: Checkbox(
//                                 value: controller.getSidebarAll(key),
//                                 onChanged: (val) => controller
//                                     .toggleSidebarAll(
//                                     key, val ?? false),
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
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (selectedRoleId == null) return;
//                       await controller
//                           .updateSidebarPermissions(selectedRoleId!);
//
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Sidebar updated ✅'),
//                         ),
//                       );
//                     },
//                     child: const Text('Save Sidebar'),
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
import 'package:provider/provider.dart';
import '../Controller/Roles_controller.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  String? selectedRoleId;

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
        if (controller.isLoading && selectedRoleId == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Manage Role Permissions')),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔽 Role Dropdown
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
                          SizedBox(
                            width: 220, // adjust width as needed
                            child: DropdownButtonFormField<String>(
                              value: selectedRoleId,
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
                      const SizedBox(height: 16),

                      const Text(
                        'Sidebar Items',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Headers
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

                      // Categories
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
                                            controller
                                                .sidebarPermissionStates[key]?['view'] ??
                                            false,
                                        activeColor: Colors.cyan,
                                        onChanged: (_) => controller
                                            .toggleSidebarPermission(key, 'view'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Transform.scale(
                                      scale: 0.6,
                                      child: Switch(
                                        value:
                                        controller
                                            .sidebarPermissionStates[key]?['read'] ??
                                            false,
                                        activeColor: Colors.cyan,
                                        onChanged: (_) => controller
                                            .toggleSidebarPermission(key, 'read'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Transform.scale(
                                      scale: 0.6,
                                      child: Switch(
                                        value:
                                        controller
                                            .sidebarPermissionStates[key]?['manage'] ??
                                            false,
                                        activeColor: Colors.cyan,
                                        onChanged: (_) => controller
                                            .toggleSidebarPermission(key, 'manage'),
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
                              await controller.updateSidebarPermissions(
                                selectedRoleId!,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Sidebar updated ✅'),
                                ),
                              );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height *.0500,
                              width: MediaQuery.of(context).size.height * .3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.teal
                              ),
                              child: Center(
                                child: Text('Save Sidebar',style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white
                                ),),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Center(
                      //   child: ElevatedButton(
                      //     onPressed: () async {
                      //       if (selectedRoleId == null) return;
                      //       await controller.updateSidebarPermissions(
                      //         selectedRoleId!,
                      //       );
                      //
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         const SnackBar(
                      //           content: Text('Sidebar updated ✅'),
                      //         ),
                      //       );
                      //     },
                      //     child: const Text('Save Sidebar'),
                      //   ),
                      // ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
