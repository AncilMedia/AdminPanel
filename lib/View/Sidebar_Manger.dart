// // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:multi_select_flutter/multi_select_flutter.dart';
// // // //
// // // // class ManageSidebar extends StatefulWidget {
// // // //   const ManageSidebar({super.key});
// // // //
// // // //   @override
// // // //   State<ManageSidebar> createState() => _ManageSidebarState();
// // // // }
// // // //
// // // // class _ManageSidebarState extends State<ManageSidebar> {
// // // //   final List<String> _roles = ["Admin", "Editor", "Viewer", "Manager"];
// // // //   List<String> _selectedRoles = [];
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(title: const Text("Manage Sidebar")),
// // // //       body: Padding(
// // // //         padding: const EdgeInsets.all(16.0),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             const Text("Name"),
// // // //             const SizedBox(height: 5),
// // // //             TextFormField(
// // // //               decoration: const InputDecoration(
// // // //                 border: OutlineInputBorder(),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 20),
// // // //
// // // //             const Text("Label"),
// // // //             const SizedBox(height: 5),
// // // //             TextFormField(
// // // //               decoration: const InputDecoration(
// // // //                 border: OutlineInputBorder(),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 20),
// // // //
// // // //             const Text("Assign Roles"),
// // // //             const SizedBox(height: 5),
// // // //             MultiSelectDialogField(
// // // //               items: _roles
// // // //                   .map((role) => MultiSelectItem<String>(role, role))
// // // //                   .toList(),
// // // //               title: const Text("Select Roles"),
// // // //               buttonText: const Text("Choose Roles"),
// // // //               decoration: BoxDecoration(
// // // //                 border: Border.all(color: Colors.grey),
// // // //                 borderRadius: BorderRadius.circular(5),
// // // //               ),
// // // //               listType: MultiSelectListType.CHIP,
// // // //               onConfirm: (values) {
// // // //                 setState(() {
// // // //                   _selectedRoles = values;
// // // //                 });
// // // //               },
// // // //             ),
// // // //
// // // //             const SizedBox(height: 20),
// // // //             Text("Selected Roles: ${_selectedRoles.join(', ')}"),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // //
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:multi_select_flutter/multi_select_flutter.dart';
// // // import 'package:provider/provider.dart';
// // //
// // // import '../Controller/Roles_controller.dart';
// // //
// // // class ManageSidebar extends StatefulWidget {
// // //   const ManageSidebar({super.key});
// // //
// // //   @override
// // //   State<ManageSidebar> createState() => _ManageSidebarState();
// // // }
// // //
// // // class _ManageSidebarState extends State<ManageSidebar> {
// // //   List<Map<String, dynamic>> _selectedRoles = [];
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     // Fetch roles on page load
// // //     Future.microtask(() =>
// // //         Provider.of<RolesController>(context, listen: false).fetchRoles());
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final roleController = Provider.of<RolesController>(context);
// // //
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text("Manage Sidebar")),
// // //       body: roleController.isLoading
// // //           ? const Center(child: CircularProgressIndicator())
// // //           : roleController.roles.isEmpty
// // //           ? const Center(child: Text("No roles found"))
// // //           : Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Row(
// // //               children: [
// // //                 Column(
// // //                   children: [
// // //                     const Text("Name"),
// // //                     const SizedBox(height: 5),
// // //                     Padding(
// // //                       padding: const EdgeInsets.only(left),
// // //                       child: TextFormField(
// // //                         decoration: const InputDecoration(
// // //                           border: OutlineInputBorder(),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 const SizedBox(height: 20),
// // //
// // //                 Column(
// // //                   children: [
// // //                     const Text("Label"),
// // //                     const SizedBox(height: 5),
// // //                     Padding(
// // //                       padding: const EdgeInsets.all(8.0),
// // //                       child: TextFormField(
// // //                         decoration: const InputDecoration(
// // //                           border: OutlineInputBorder(),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ],
// // //             ),
// // //             const SizedBox(height: 20),
// // //
// // //             const Text("Assign Roles"),
// // //             const SizedBox(height: 5),
// // //             MultiSelectDialogField<Map<String, dynamic>>(
// // //               items: roleController.roles
// // //                   .map((role) => MultiSelectItem<Map<String, dynamic>>(
// // //                   role, role["name"]))
// // //                   .toList(),
// // //               title: const Text("Select Roles"),
// // //               buttonText: const Text("Choose Roles"),
// // //               listType: MultiSelectListType.CHIP,
// // //               decoration: BoxDecoration(
// // //                 border: Border.all(color: Colors.grey),
// // //                 borderRadius: BorderRadius.circular(5),
// // //               ),
// // //               onConfirm: (values) {
// // //                 setState(() {
// // //                   _selectedRoles = values;
// // //                 });
// // //
// // //                 final roleIds =
// // //                 values.map((r) => r["_id"].toString()).toList();
// // //                 debugPrint("✅ Selected Role IDs: $roleIds");
// // //               },
// // //             ),
// // //
// // //             const SizedBox(height: 20),
// // //             Text(
// // //               "Selected Role IDs: ${_selectedRoles.map((r) => r['_id']).join(', ')}",
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:multi_select_flutter/multi_select_flutter.dart';
// import 'package:provider/provider.dart';
// import '../Controller/Roles_controller.dart';
// import '../Controller/Sidebar_controller.dart';
//
// class ManageSidebar extends StatefulWidget {
//   const ManageSidebar({super.key});
//
//   @override
//   State<ManageSidebar> createState() => _ManageSidebarState();
// }
//
// class _ManageSidebarState extends State<ManageSidebar> {
//   List<Map<String, dynamic>> _selectedRoles = [];
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() =>
//         Provider.of<RolesController>(context, listen: false).fetchRoles());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final roleController = Provider.of<RolesController>(context);
//     final sidebarController = Provider.of<SidebarController>(context);
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Manage Sidebar")),
//       body: roleController.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : roleController.roles.isEmpty
//           ? const Center(child: Text("No roles found"))
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("Name"),
//                       const SizedBox(height: 5),
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("Label"),
//                       const SizedBox(height: 5),
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Text("Assign Roles"),
//             const SizedBox(height: 5),
//             MultiSelectDialogField<Map<String, dynamic>>(
//               items: roleController.roles
//                   .map((role) => MultiSelectItem<Map<String, dynamic>>(
//                   role, role["name"]))
//                   .toList(),
//               title: const Text("Select Roles"),
//               buttonText: const Text("Choose Roles"),
//               listType: MultiSelectListType.CHIP,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               onConfirm: (values) {
//                 setState(() {
//                   _selectedRoles = values;
//                 });
//
//                 final roleIds =
//                 values.map((r) => r["_id"].toString()).toList();
//                 debugPrint("✅ Selected Role IDs: $roleIds");
//               },
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: _selectedRoles.isEmpty
//                       ? null
//                       : () async {
//                     final roleId =
//                     _selectedRoles.first["_id"].toString();
//                     final success =
//                     await sidebarController.assignSidebarPermissions(
//                       roleId,
//                       sidebarController.roleSidebarItems,
//                     );
//                     if (success) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text(
//                                 "Sidebar permissions updated!")),
//                       );
//                     }
//                   },
//                   child: Container(
//                     height: MediaQuery.of(context).size.height *.0500,
//                     width: MediaQuery.of(context).size.width *.1,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.teal
//                     ),
//                     child: Center(
//                       child: Text("Save Permission",style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 16,
//                         color: Colors.white
//                       ),),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import '../Controller/Roles_controller.dart';
import '../Controller/Sidebar_controller.dart';

class ManageSidebar extends StatefulWidget {
  const ManageSidebar({super.key});

  @override
  State<ManageSidebar> createState() => _ManageSidebarState();
}

class _ManageSidebarState extends State<ManageSidebar> {
  final _keyController = TextEditingController();
  final _labelController = TextEditingController();
  final _iconController = TextEditingController();
  final _orderController = TextEditingController(text: "0");

  List<Map<String, dynamic>> _selectedRoles = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RolesController>(context, listen: false).fetchRoles();
      Provider.of<SidebarController>(
        context,
        listen: false,
      ).fetchAllSidebarItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final roleController = Provider.of<RolesController>(context);
    final sidebarController = Provider.of<SidebarController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Sidebar Item")),
      body: (roleController.isLoading || sidebarController.isLoading)
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Key Field
                  const Text("Key"),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _keyController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Label Field
                  const Text("Label"),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _labelController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // // Icon Field
                  // const Text("Icon (optional)"),
                  // const SizedBox(height: 5),
                  // TextFormField(
                  //   controller: _iconController,
                  //   decoration: const InputDecoration(
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  //
                  // // Order Field
                  // const Text("Order (optional)"),
                  // const SizedBox(height: 5),
                  // TextFormField(
                  //   controller: _orderController,
                  //   keyboardType: TextInputType.number,
                  //   decoration: const InputDecoration(
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  // const SizedBox(height: 20),

                  // Roles MultiSelect
                  const Text("Assign Roles"),
                  const SizedBox(height: 5),
                  MultiSelectDialogField<Map<String, dynamic>>(
                    buttonIcon: Icon(Iconsax.direct_down),
                    items: roleController.roles
                        .map(
                          (role) => MultiSelectItem<Map<String, dynamic>>(
                            role,
                            role["name"],
                          ),
                        )
                        .toList(),
                    title: const Text("Select Roles"),
                    buttonText: const Text("Choose Roles"),
                    listType: MultiSelectListType.CHIP,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onConfirm: (values) {
                      setState(() {
                        _selectedRoles = values;
                      });
                      debugPrint(
                        "✅ Selected Role IDs: ${values.map((r) => r['_id']).toList()}",
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            final key = _keyController.text.trim();
                            final label = _labelController.text.trim();
                            final icon = _iconController.text.trim();
                            final roles = _selectedRoles.map((r) => r["_id"].toString()).toList();

                            if (key.isEmpty || label.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Key and Label are required")),
                              );
                              return;
                            }

                            int order;
                            // If order field is empty or 0, auto increment
                            if (_orderController.text.trim().isEmpty ||
                                int.tryParse(_orderController.text.trim()) == 0) {
                              if (sidebarController.sidebarItems.isEmpty) {
                                order = 1;
                              } else {
                                final lastOrder = sidebarController.sidebarItems
                                    .map((e) => e["order"] ?? 0)
                                    .reduce((a, b) => a > b ? a : b);
                                order = lastOrder + 1;
                              }
                            } else {
                              order = int.tryParse(_orderController.text.trim()) ?? 1;
                            }

                            final success = await sidebarController.createSidebarItem(
                              key: key,
                              label: label,
                              icon: icon,
                              order: order,
                              roles: roles,
                            );

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Sidebar item created successfully!")),
                              );
                              // Clear fields
                              _keyController.clear();
                              _labelController.clear();
                              _iconController.clear();
                              _orderController.text = "0";
                              setState(() {
                                _selectedRoles = [];
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        sidebarController.errorMessage ?? "Error occurred")),
                              );
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * .0500,
                            width: MediaQuery.of(context).size.width * .1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.teal,
                            ),
                            child: Center(
                              child: Text(
                                "Save Permission",
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
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
