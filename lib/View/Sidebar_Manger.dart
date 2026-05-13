// // // // //
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:multi_select_flutter/multi_select_flutter.dart';
// // // // // //
// // // // // // class ManageSidebar extends StatefulWidget {
// // // // // //   const ManageSidebar({super.key});
// // // // // //
// // // // // //   @override
// // // // // //   State<ManageSidebar> createState() => _ManageSidebarState();
// // // // // // }
// // // // // //
// // // // // // class _ManageSidebarState extends State<ManageSidebar> {
// // // // // //   final List<String> _roles = ["Admin", "Editor", "Viewer", "Manager"];
// // // // // //   List<String> _selectedRoles = [];
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Scaffold(
// // // // // //       appBar: AppBar(title: const Text("Manage Sidebar")),
// // // // // //       body: Padding(
// // // // // //         padding: const EdgeInsets.all(16.0),
// // // // // //         child: Column(
// // // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //           children: [
// // // // // //             const Text("Name"),
// // // // // //             const SizedBox(height: 5),
// // // // // //             TextFormField(
// // // // // //               decoration: const InputDecoration(
// // // // // //                 border: OutlineInputBorder(),
// // // // // //               ),
// // // // // //             ),
// // // // // //             const SizedBox(height: 20),
// // // // // //
// // // // // //             const Text("Label"),
// // // // // //             const SizedBox(height: 5),
// // // // // //             TextFormField(
// // // // // //               decoration: const InputDecoration(
// // // // // //                 border: OutlineInputBorder(),
// // // // // //               ),
// // // // // //             ),
// // // // // //             const SizedBox(height: 20),
// // // // // //
// // // // // //             const Text("Assign Roles"),
// // // // // //             const SizedBox(height: 5),
// // // // // //             MultiSelectDialogField(
// // // // // //               items: _roles
// // // // // //                   .map((role) => MultiSelectItem<String>(role, role))
// // // // // //                   .toList(),
// // // // // //               title: const Text("Select Roles"),
// // // // // //               buttonText: const Text("Choose Roles"),
// // // // // //               decoration: BoxDecoration(
// // // // // //                 border: Border.all(color: Colors.grey),
// // // // // //                 borderRadius: BorderRadius.circular(5),
// // // // // //               ),
// // // // // //               listType: MultiSelectListType.CHIP,
// // // // // //               onConfirm: (values) {
// // // // // //                 setState(() {
// // // // // //                   _selectedRoles = values;
// // // // // //                 });
// // // // // //               },
// // // // // //             ),
// // // // // //
// // // // // //             const SizedBox(height: 20),
// // // // // //             Text("Selected Roles: ${_selectedRoles.join(', ')}"),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // //
// // // // //
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:multi_select_flutter/multi_select_flutter.dart';
// // // // // import 'package:provider/provider.dart';
// // // // //
// // // // // import '../Controller/Roles_controller.dart';
// // // // //
// // // // // class ManageSidebar extends StatefulWidget {
// // // // //   const ManageSidebar({super.key});
// // // // //
// // // // //   @override
// // // // //   State<ManageSidebar> createState() => _ManageSidebarState();
// // // // // }
// // // // //
// // // // // class _ManageSidebarState extends State<ManageSidebar> {
// // // // //   List<Map<String, dynamic>> _selectedRoles = [];
// // // // //
// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     // Fetch roles on page load
// // // // //     Future.microtask(() =>
// // // // //         Provider.of<RolesController>(context, listen: false).fetchRoles());
// // // // //   }
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final roleController = Provider.of<RolesController>(context);
// // // // //
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(title: const Text("Manage Sidebar")),
// // // // //       body: roleController.isLoading
// // // // //           ? const Center(child: CircularProgressIndicator())
// // // // //           : roleController.roles.isEmpty
// // // // //           ? const Center(child: Text("No roles found"))
// // // // //           : Padding(
// // // // //         padding: const EdgeInsets.all(16.0),
// // // // //         child: Column(
// // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // //           children: [
// // // // //             Row(
// // // // //               children: [
// // // // //                 Column(
// // // // //                   children: [
// // // // //                     const Text("Name"),
// // // // //                     const SizedBox(height: 5),
// // // // //                     Padding(
// // // // //                       padding: const EdgeInsets.only(left),
// // // // //                       child: TextFormField(
// // // // //                         decoration: const InputDecoration(
// // // // //                           border: OutlineInputBorder(),
// // // // //                         ),
// // // // //                       ),
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //                 const SizedBox(height: 20),
// // // // //
// // // // //                 Column(
// // // // //                   children: [
// // // // //                     const Text("Label"),
// // // // //                     const SizedBox(height: 5),
// // // // //                     Padding(
// // // // //                       padding: const EdgeInsets.all(8.0),
// // // // //                       child: TextFormField(
// // // // //                         decoration: const InputDecoration(
// // // // //                           border: OutlineInputBorder(),
// // // // //                         ),
// // // // //                       ),
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //             const SizedBox(height: 20),
// // // // //
// // // // //             const Text("Assign Roles"),
// // // // //             const SizedBox(height: 5),
// // // // //             MultiSelectDialogField<Map<String, dynamic>>(
// // // // //               items: roleController.roles
// // // // //                   .map((role) => MultiSelectItem<Map<String, dynamic>>(
// // // // //                   role, role["name"]))
// // // // //                   .toList(),
// // // // //               title: const Text("Select Roles"),
// // // // //               buttonText: const Text("Choose Roles"),
// // // // //               listType: MultiSelectListType.CHIP,
// // // // //               decoration: BoxDecoration(
// // // // //                 border: Border.all(color: Colors.grey),
// // // // //                 borderRadius: BorderRadius.circular(5),
// // // // //               ),
// // // // //               onConfirm: (values) {
// // // // //                 setState(() {
// // // // //                   _selectedRoles = values;
// // // // //                 });
// // // // //
// // // // //                 final roleIds =
// // // // //                 values.map((r) => r["_id"].toString()).toList();
// // // // //                 debugPrint("✅ Selected Role IDs: $roleIds");
// // // // //               },
// // // // //             ),
// // // // //
// // // // //             const SizedBox(height: 20),
// // // // //             Text(
// // // // //               "Selected Role IDs: ${_selectedRoles.map((r) => r['_id']).join(', ')}",
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // //
// // // //
// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:multi_select_flutter/multi_select_flutter.dart';
// // // import 'package:provider/provider.dart';
// // // import '../Controller/Roles_controller.dart';
// // // import '../Controller/Sidebar_controller.dart';
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
// // //     Future.microtask(() =>
// // //         Provider.of<RolesController>(context, listen: false).fetchRoles());
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final roleController = Provider.of<RolesController>(context);
// // //     final sidebarController = Provider.of<SidebarController>(context);
// // //
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text("Manage Sidebar")),
// // //       body: roleController.isLoading
// // //           ? const Center(child: CircularProgressIndicator())
// // //           : roleController.roles.isEmpty
// // //           ? const Center(child: Text("No roles found"))
// // //           : SingleChildScrollView(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Row(
// // //               children: [
// // //                 Expanded(
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       const Text("Name"),
// // //                       const SizedBox(height: 5),
// // //                       TextFormField(
// // //                         decoration: const InputDecoration(
// // //                           border: OutlineInputBorder(),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 const SizedBox(width: 16),
// // //                 Expanded(
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       const Text("Label"),
// // //                       const SizedBox(height: 5),
// // //                       TextFormField(
// // //                         decoration: const InputDecoration(
// // //                           border: OutlineInputBorder(),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //             const SizedBox(height: 20),
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
// // //             const SizedBox(height: 20),
// // //             Row(
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               crossAxisAlignment: CrossAxisAlignment.center,
// // //               children: [
// // //                 GestureDetector(
// // //                   onTap: _selectedRoles.isEmpty
// // //                       ? null
// // //                       : () async {
// // //                     final roleId =
// // //                     _selectedRoles.first["_id"].toString();
// // //                     final success =
// // //                     await sidebarController.assignSidebarPermissions(
// // //                       roleId,
// // //                       sidebarController.roleSidebarItems,
// // //                     );
// // //                     if (success) {
// // //                       ScaffoldMessenger.of(context).showSnackBar(
// // //                         const SnackBar(
// // //                             content: Text(
// // //                                 "Sidebar permissions updated!")),
// // //                       );
// // //                     }
// // //                   },
// // //                   child: Container(
// // //                     height: MediaQuery.of(context).size.height *.0500,
// // //                     width: MediaQuery.of(context).size.width *.1,
// // //                     decoration: BoxDecoration(
// // //                       borderRadius: BorderRadius.circular(10),
// // //                       color: Colors.teal
// // //                     ),
// // //                     child: Center(
// // //                       child: Text("Save Permission",style: GoogleFonts.poppins(
// // //                         fontWeight: FontWeight.w500,
// // //                         fontSize: 16,
// // //                         color: Colors.white
// // //                       ),),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             )
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:multi_select_flutter/multi_select_flutter.dart';
// // import 'package:provider/provider.dart';
// // import '../Controller/Roles_controller.dart';
// // import '../Controller/Sidebar_controller.dart';
// //
// // class ManageSidebar extends StatefulWidget {
// //   const ManageSidebar({super.key});
// //
// //   @override
// //   State<ManageSidebar> createState() => _ManageSidebarState();
// // }
// //
// // class _ManageSidebarState extends State<ManageSidebar> {
// //   final _keyController = TextEditingController();
// //   final _labelController = TextEditingController();
// //   final _iconController = TextEditingController();
// //   final _orderController = TextEditingController(text: "0");
// //
// //   List<Map<String, dynamic>> _selectedRoles = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     Future.microtask(() {
// //       Provider.of<RolesController>(context, listen: false).fetchRoles();
// //       Provider.of<SidebarController>(
// //         context,
// //         listen: false,
// //       ).fetchAllSidebarItems();
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final roleController = Provider.of<RolesController>(context);
// //     final sidebarController = Provider.of<SidebarController>(context);
// //
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Add Sidebar Item")),
// //       body: (roleController.isLoading || sidebarController.isLoading)
// //           ? const Center(child: CircularProgressIndicator())
// //           : SingleChildScrollView(
// //               padding: const EdgeInsets.all(16),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   // Key Field
// //                   const Text("Key"),
// //                   const SizedBox(height: 5),
// //                   TextFormField(
// //                     controller: _keyController,
// //                     decoration: const InputDecoration(
// //                       border: OutlineInputBorder(),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),
// //
// //                   // Label Field
// //                   const Text("Label"),
// //                   const SizedBox(height: 5),
// //                   TextFormField(
// //                     controller: _labelController,
// //                     decoration: const InputDecoration(
// //                       border: OutlineInputBorder(),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),
// //
// //                   // // Icon Field
// //                   // const Text("Icon (optional)"),
// //                   // const SizedBox(height: 5),
// //                   // TextFormField(
// //                   //   controller: _iconController,
// //                   //   decoration: const InputDecoration(
// //                   //     border: OutlineInputBorder(),
// //                   //   ),
// //                   // ),
// //                   // const SizedBox(height: 20),
// //                   //
// //                   // // Order Field
// //                   // const Text("Order (optional)"),
// //                   // const SizedBox(height: 5),
// //                   // TextFormField(
// //                   //   controller: _orderController,
// //                   //   keyboardType: TextInputType.number,
// //                   //   decoration: const InputDecoration(
// //                   //     border: OutlineInputBorder(),
// //                   //   ),
// //                   // ),
// //                   // const SizedBox(height: 20),
// //
// //                   // Roles MultiSelect
// //                   const Text("Assign Roles"),
// //                   const SizedBox(height: 5),
// //                   MultiSelectDialogField<Map<String, dynamic>>(
// //                     buttonIcon: Icon(Iconsax.direct_down),
// //                     items: roleController.roles
// //                         .map(
// //                           (role) => MultiSelectItem<Map<String, dynamic>>(
// //                             role,
// //                             role["name"],
// //                           ),
// //                         )
// //                         .toList(),
// //                     title: const Text("Select Roles"),
// //                     buttonText: const Text("Choose Roles"),
// //                     listType: MultiSelectListType.CHIP,
// //                     decoration: BoxDecoration(
// //                       border: Border.all(color: Colors.grey),
// //                       borderRadius: BorderRadius.circular(5),
// //                     ),
// //                     onConfirm: (values) {
// //                       setState(() {
// //                         _selectedRoles = values;
// //                       });
// //                       debugPrint(
// //                         "✅ Selected Role IDs: ${values.map((r) => r['_id']).toList()}",
// //                       );
// //                     },
// //                   ),
// //                   const SizedBox(height: 30),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       MouseRegion(
// //                         cursor: SystemMouseCursors.click,
// //                         child: GestureDetector(
// //                           onTap: () async {
// //                             final key = _keyController.text.trim();
// //                             final label = _labelController.text.trim();
// //                             final icon = _iconController.text.trim();
// //                             final roles = _selectedRoles.map((r) => r["_id"].toString()).toList();
// //
// //                             if (key.isEmpty || label.isEmpty) {
// //                               ScaffoldMessenger.of(context).showSnackBar(
// //                                 const SnackBar(content: Text("Key and Label are required")),
// //                               );
// //                               return;
// //                             }
// //
// //                             int order;
// //                             // If order field is empty or 0, auto increment
// //                             if (_orderController.text.trim().isEmpty ||
// //                                 int.tryParse(_orderController.text.trim()) == 0) {
// //                               if (sidebarController.sidebarItems.isEmpty) {
// //                                 order = 1;
// //                               } else {
// //                                 final lastOrder = sidebarController.sidebarItems
// //                                     .map((e) => e["order"] ?? 0)
// //                                     .reduce((a, b) => a > b ? a : b);
// //                                 order = lastOrder + 1;
// //                               }
// //                             } else {
// //                               order = int.tryParse(_orderController.text.trim()) ?? 1;
// //                             }
// //
// //                             final success = await sidebarController.createSidebarItem(
// //                               key: key,
// //                               label: label,
// //                               icon: icon,
// //                               order: order,
// //                               roles: roles,
// //                             );
// //
// //                             if (success) {
// //                               ScaffoldMessenger.of(context).showSnackBar(
// //                                 const SnackBar(content: Text("Sidebar item created successfully!")),
// //                               );
// //                               // Clear fields
// //                               _keyController.clear();
// //                               _labelController.clear();
// //                               _iconController.clear();
// //                               _orderController.text = "0";
// //                               setState(() {
// //                                 _selectedRoles = [];
// //                               });
// //                             } else {
// //                               ScaffoldMessenger.of(context).showSnackBar(
// //                                 SnackBar(
// //                                     content: Text(
// //                                         sidebarController.errorMessage ?? "Error occurred")),
// //                               );
// //                             }
// //                           },
// //                           child: Container(
// //                             height: MediaQuery.of(context).size.height * .0500,
// //                             width: MediaQuery.of(context).size.width * .1,
// //                             decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(10),
// //                               color: Colors.teal,
// //                             ),
// //                             child: Center(
// //                               child: Text(
// //                                 "Save Permission",
// //                                 style: GoogleFonts.poppins(
// //                                   fontWeight: FontWeight.w500,
// //                                   fontSize: 16,
// //                                   color: Colors.white,
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
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
//   // SaaS Color Palette
//   final Color primaryIndigo = const Color(0xFF6366F1);
//   final Color slate900 = const Color(0xFF0F172A);
//   final Color slate50 = const Color(0xFFF8FAFC);
//   final Color slate200 = const Color(0xFFE2E8F0);
//   final Color slate500 = const Color(0xFF64748B);
//
//   final _keyController = TextEditingController();
//   final _labelController = TextEditingController();
//   final _iconController = TextEditingController();
//   final _orderController = TextEditingController(text: "0");
//
//   List<Map<String, dynamic>> _selectedRoles = [];
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       Provider.of<RolesController>(context, listen: false).fetchRoles();
//       Provider.of<SidebarController>(context, listen: false).fetchAllSidebarItems();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final roleController = Provider.of<RolesController>(context);
//     final sidebarController = Provider.of<SidebarController>(context);
//
//     return Scaffold(
//       backgroundColor: slate50,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: false,
//         title: Text(
//           "Menu Configuration",
//           style: GoogleFonts.plusJakartaSans(
//             color: slate900,
//             fontWeight: FontWeight.w800,
//             fontSize: 18,
//           ),
//         ),
//         iconTheme: IconThemeData(color: slate900),
//       ),
//       body: (roleController.isLoading || sidebarController.isLoading)
//           ? Center(child: CircularProgressIndicator(color: primaryIndigo))
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionHeader("Identification", Iconsax.key),
//             const SizedBox(height: 12),
//             _buildCard([
//               _buildTextField("System Key", "e.g. user_management", _keyController, Iconsax.code),
//               const SizedBox(height: 20),
//               _buildTextField("Display Label", "e.g. Manage Users", _labelController, Iconsax.text_block),
//             ]),
//             const SizedBox(height: 32),
//             _buildSectionHeader("Visuals & Sorting", Iconsax.category),
//             const SizedBox(height: 12),
//             _buildCard([
//               Row(
//                 children: [
//                   Expanded(child: _buildTextField("Icon Key", "home-2", _iconController, Iconsax.ghost)),
//                   const SizedBox(width: 16),
//                   Expanded(child: _buildTextField("Sort Order", "0", _orderController, Iconsax.sort, isNum: true)),
//                 ],
//               ),
//             ]),
//             const SizedBox(height: 32),
//             _buildSectionHeader("Access Control", Iconsax.shield_tick),
//             const SizedBox(height: 12),
//             _buildRoleSelector(roleController),
//             const SizedBox(height: 40),
//             _buildSubmitButton(sidebarController),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title, IconData icon) {
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: slate500),
//         const SizedBox(width: 8),
//         Text(
//           title.toUpperCase(),
//           style: GoogleFonts.plusJakartaSans(
//             fontSize: 11,
//             fontWeight: FontWeight.w800,
//             color: slate500,
//             letterSpacing: 1.2,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCard(List<Widget> children) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: slate200),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
//         ],
//       ),
//       child: Column(children: children),
//     );
//   }
//
//   Widget _buildTextField(String label, String hint, TextEditingController ctrl, IconData icon, {bool isNum = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: slate900)),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: ctrl,
//           keyboardType: isNum ? TextInputType.number : TextInputType.text,
//           style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w500),
//           decoration: InputDecoration(
//             hintText: hint,
//             hintStyle: GoogleFonts.plusJakartaSans(color: slate500.withOpacity(0.5), fontSize: 13),
//             prefixIcon: Icon(icon, size: 18, color: primaryIndigo),
//             filled: true,
//             fillColor: slate50,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildRoleSelector(RolesController roleController) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: slate200),
//       ),
//       child: MultiSelectDialogField<Map<String, dynamic>>(
//         buttonIcon: Icon(Iconsax.arrow_circle_down, color: primaryIndigo),
//         items: roleController.roles.map((role) => MultiSelectItem<Map<String, dynamic>>(role, role["name"])).toList(),
//         title: Text("Select Authorized Roles", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
//         buttonText: Text("Select Roles", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: slate900)),
//         listType: MultiSelectListType.CHIP,
//         selectedColor: primaryIndigo,
//         selectedItemsTextStyle: GoogleFonts.plusJakartaSans(color: Colors.white),
//         unselectedColor: slate50,
//         chipDisplay: MultiSelectChipDisplay(
//           chipColor: primaryIndigo.withOpacity(0.1),
//           textStyle: GoogleFonts.plusJakartaSans(color: primaryIndigo, fontWeight: FontWeight.w700, fontSize: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
//         onConfirm: (values) => setState(() => _selectedRoles = values),
//       ),
//     );
//   }
//
//   Widget _buildSubmitButton(SidebarController sidebarController) {
//     return SizedBox(
//       width: double.infinity,
//       height: 58,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: slate900,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           elevation: 0,
//         ),
//         onPressed: () async {
//           final key = _keyController.text.trim();
//           final label = _labelController.text.trim();
//           final icon = _iconController.text.trim();
//           final roles = _selectedRoles.map((r) => r["_id"].toString()).toList();
//
//           if (key.isEmpty || label.isEmpty) {
//             _showSnackBar("Key and Label are required", isError: true);
//             return;
//           }
//
//           int order = int.tryParse(_orderController.text.trim()) ?? 0;
//           if (order == 0) {
//             final lastOrder = sidebarController.sidebarItems.isEmpty
//                 ? 0
//                 : sidebarController.sidebarItems.map((e) => e["order"] ?? 0).reduce((a, b) => a > b ? a : b);
//             order = lastOrder + 1;
//           }
//
//           final success = await sidebarController.createSidebarItem(
//             key: key, label: label, icon: icon, order: order, roles: roles,
//           );
//
//           if (success) {
//             _showSnackBar("Sidebar item added to registry");
//             _keyController.clear();
//             _labelController.clear();
//             _iconController.clear();
//             _orderController.text = "0";
//             setState(() => _selectedRoles = []);
//           } else {
//             _showSnackBar(sidebarController.errorMessage ?? "Registry error", isError: true);
//           }
//         },
//         child: Text(
//           "PUBLISH TO SIDEBAR",
//           style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.5),
//         ),
//       ),
//     );
//   }
//
//   void _showSnackBar(String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: isError ? Colors.redAccent : primaryIndigo,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(20),
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
  // --- Professional Teal & Cyan Palette ---
  final Color primaryTeal = const Color(0xFF0D9488); // Teal 600
  final Color accentCyan = const Color(0xFF06B6D4);  // Cyan 500
  final Color slate900 = const Color(0xFF0F172A);   // Slate 900
  final Color slate50 = const Color(0xFFF8FAFC);    // Slate 50
  final Color slate200 = const Color(0xFFE2E8F0);   // Slate 200
  final Color slate500 = const Color(0xFF64748B);   // Slate 500

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
      Provider.of<SidebarController>(context, listen: false).fetchAllSidebarItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final roleController = Provider.of<RolesController>(context);
    final sidebarController = Provider.of<SidebarController>(context);

    return Scaffold(
      backgroundColor: slate50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Menu Configuration",
              style: GoogleFonts.plusJakartaSans(
                color: slate900,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            Text(
              "Manage global navigation and role permissions",
              style: GoogleFonts.plusJakartaSans(color: slate500, fontSize: 11, fontWeight: FontWeight.w500),
            )
          ],
        ),
        iconTheme: IconThemeData(color: slate900),
      ),
      body: (roleController.isLoading || sidebarController.isLoading)
          ? Center(child: CircularProgressIndicator(color: primaryTeal))
          : LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth > 1100;
          final bool isMobile = constraints.maxWidth < 600;

          return Center(
            child: Container(
              // iMac Optimization: Limit width for readability but keep it wide
              constraints: BoxConstraints(maxWidth: isDesktop ? 1400 : 1000),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(isMobile ? 16 : 32),
                child: isDesktop
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT: Form Section
                    Expanded(
                      flex: 3,
                      child: _buildFormSection(roleController, isMobile),
                    ),
                    const SizedBox(width: 32),
                    // RIGHT: Status Panel
                    Expanded(
                      flex: 2,
                      child: _buildSummaryPanel(sidebarController),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    _buildFormSection(roleController, isMobile),
                    const SizedBox(height: 32),
                    _buildSummaryPanel(sidebarController),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomActions(sidebarController),
    );
  }

  // --- FORM SECTION ---

  Widget _buildFormSection(RolesController roleController, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Identification", Iconsax.key),
        const SizedBox(height: 16),
        _buildCard([
          _buildTextField("System Key", "e.g. user_management", _keyController, Iconsax.code),
          const SizedBox(height: 24),
          _buildTextField("Display Label", "e.g. Manage Users", _labelController, Iconsax.text_block),
        ]),
        const SizedBox(height: 32),
        _buildSectionHeader("Visuals & Sorting", Iconsax.category),
        const SizedBox(height: 16),
        _buildCard([
          if (isMobile) ...[
            _buildTextField("Icon Key", "home-2", _iconController, Iconsax.ghost),
            const SizedBox(height: 24),
            _buildTextField("Sort Order", "0", _orderController, Iconsax.sort, isNum: true),
          ] else
            Row(
              children: [
                Expanded(child: _buildTextField("Icon Key", "home-2", _iconController, Iconsax.ghost)),
                const SizedBox(width: 20),
                Expanded(child: _buildTextField("Sort Order", "0", _orderController, Iconsax.sort, isNum: true)),
              ],
            ),
        ]),
        const SizedBox(height: 32),
        _buildSectionHeader("Access Control", Iconsax.shield_tick),
        const SizedBox(height: 16),
        _buildRoleSelector(roleController),
      ],
    );
  }

  // --- SUMMARY PANEL ---

  Widget _buildSummaryPanel(SidebarController sidebarController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Registry Status", Iconsax.status_up),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [slate900, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: primaryTeal.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Database Insight", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text("Live menu entries in registry", style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 32),
              Row(
                children: [
                  _statItem("TOTAL ITEMS", sidebarController.sidebarItems.length.toString()),
                  const SizedBox(width: 40),
                  _statItem("MAX ORDER", sidebarController.sidebarItems.isEmpty ? "0" :
                  sidebarController.sidebarItems.map((e) => e["order"] ?? 0).reduce((a, b) => a > b ? a : b).toString()),
                ],
              ),
              const SizedBox(height: 32),
              const Divider(color: Colors.white10),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Iconsax.info_circle, color: Colors.cyan, size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Publishing will update the global navigation for all assigned roles immediately.",
                      style: GoogleFonts.plusJakartaSans(color: Colors.white38, fontSize: 11, height: 1.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statItem(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(color: accentCyan, fontWeight: FontWeight.w800, fontSize: 10, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(val, style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 32)),
      ],
    );
  }

  // --- HELPER COMPONENTS ---

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: primaryTeal.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: primaryTeal),
        ),
        const SizedBox(width: 12),
        Text(title.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w800, color: slate900, letterSpacing: 1.5)),
      ],
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: slate200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController ctrl, IconData icon, {bool isNum = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: slate900)),
        const SizedBox(height: 10),
        TextFormField(
          controller: ctrl,
          keyboardType: isNum ? TextInputType.number : TextInputType.text,
          style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(color: slate500.withOpacity(0.4), fontSize: 13),
            prefixIcon: Icon(icon, size: 18, color: primaryTeal),
            filled: true,
            fillColor: slate50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: accentCyan, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelector(RolesController roleController) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: slate200)),
      child: MultiSelectDialogField<Map<String, dynamic>>(
        buttonIcon: Icon(Iconsax.arrow_circle_down, color: primaryTeal),
        items: roleController.roles.map((role) => MultiSelectItem<Map<String, dynamic>>(role, role["name"])).toList(),
        title: Text("Access Permissions", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        buttonText: Text("Assigned Access Levels", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: slate900)),
        listType: MultiSelectListType.CHIP,
        selectedColor: primaryTeal,
        chipDisplay: MultiSelectChipDisplay(
          chipColor: primaryTeal.withOpacity(0.1),
          textStyle: GoogleFonts.plusJakartaSans(color: primaryTeal, fontWeight: FontWeight.w700, fontSize: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
        onConfirm: (values) => setState(() => _selectedRoles = values),
      ),
    );
  }

  Widget _buildBottomActions(SidebarController sidebarController) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: slate200)),
      ),
      child: Row(
        children: [
          if (MediaQuery.of(context).size.width > 700)
            Row(
              children: [
                Icon(Iconsax.verify, color: primaryTeal, size: 18),
                const SizedBox(width: 8),
                Text("Verify configuration before publishing.",
                    style: GoogleFonts.plusJakartaSans(color: slate500, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          const Spacer(),
          _buildSubmitButton(sidebarController),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(SidebarController sidebarController) {
    return SizedBox(
      height: 54,
      width: 260,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: slate900,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        onPressed: () async {
          final key = _keyController.text.trim();
          final label = _labelController.text.trim();
          final icon = _iconController.text.trim();
          final roles = _selectedRoles.map((r) => r["_id"].toString()).toList();

          if (key.isEmpty || label.isEmpty) {
            _showSnackBar("Key and Label are required", isError: true);
            return;
          }

          int order = int.tryParse(_orderController.text.trim()) ?? 0;
          final success = await sidebarController.createSidebarItem(
            key: key, label: label, icon: icon, order: order, roles: roles,
          );

          if (success) {
            _showSnackBar("Registry entry published successfully");
            _keyController.clear(); _labelController.clear(); _iconController.clear();
            _orderController.text = "0"; setState(() => _selectedRoles = []);
          } else {
            _showSnackBar(sidebarController.errorMessage ?? "Publishing failed", isError: true);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.flash_1, size: 18, color: Colors.cyanAccent),
            const SizedBox(width: 12),
            Text("PUBLISH TO REGISTRY", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 13, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.redAccent : primaryTeal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }
}