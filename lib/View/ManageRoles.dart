// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // // import 'package:iconsax/iconsax.dart';
// // // // // //
// // // // // // class ManageRoles extends StatefulWidget {
// // // // // //   const ManageRoles({super.key});
// // // // // //
// // // // // //   @override
// // // // // //   State<ManageRoles> createState() => _ManageRolesState();
// // // // // // }
// // // // // //
// // // // // // class _ManageRolesState extends State<ManageRoles> {
// // // // // //   // Sample role data
// // // // // //   final List<Map<String, String>> roles = [
// // // // // //     {
// // // // // //       'name': 'Admin',
// // // // // //       'description': 'Admin Description',
// // // // // //       'createdAt': '10-02-25',
// // // // // //     },
// // // // // //     {
// // // // // //       'name': 'Editor',
// // // // // //       'description': 'Editor Description',
// // // // // //       'createdAt': '12-05-25',
// // // // // //     },
// // // // // //     {
// // // // // //       'name': 'Viewer',
// // // // // //       'description': 'Viewer Description',
// // // // // //       'createdAt': '01-08-25',
// // // // // //     },
// // // // // //   ];
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     // Define fixed widths for columns
// // // // // //     final double nameWidth = 120;
// // // // // //     final double descWidth = 180;
// // // // // //     final double dateWidth = 100;
// // // // // //     final double actionsWidth = 100;
// // // // // //
// // // // // //     return Scaffold(
// // // // // //       body: Column(
// // // // // //         children: [
// // // // // //           // Header
// // // // // //           Container(
// // // // // //             height: 60,
// // // // // //             width: double.infinity,
// // // // // //             padding: const EdgeInsets.symmetric(horizontal: 16),
// // // // // //             decoration: BoxDecoration(
// // // // // //               color: Colors.cyan.shade300,
// // // // // //               borderRadius: const BorderRadius.only(
// // // // // //                 bottomLeft: Radius.circular(30),
// // // // // //                 bottomRight: Radius.circular(25),
// // // // // //               ),
// // // // // //             ),
// // // // // //             child: Row(
// // // // // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // //               crossAxisAlignment: CrossAxisAlignment.center,
// // // // // //               children: [
// // // // // //                 SizedBox(width: nameWidth, child: Text("Name", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16,color: Colors.white))),
// // // // // //                 SizedBox(width: descWidth, child: Text("Description", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16,color: Colors.white))),
// // // // // //                 SizedBox(width: dateWidth, child: Text("Created-at", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16,color: Colors.white))),
// // // // // //                 SizedBox(width: actionsWidth, child: Text("Actions", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16,color: Colors.white))),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //
// // // // // //           // Data rows
// // // // // //           Expanded(
// // // // // //             child: ListView.builder(
// // // // // //               itemCount: roles.length,
// // // // // //               itemBuilder: (context, index) {
// // // // // //                 final role = roles[index];
// // // // // //                 return Container(
// // // // // //                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // // // // //                   decoration: BoxDecoration(
// // // // // //                     border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
// // // // // //                   ),
// // // // // //                   child: Row(
// // // // // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //                     children: [
// // // // // //                       SizedBox(width: nameWidth, child: Text(role['name']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16))),
// // // // // //                       SizedBox(width: descWidth, child: Text(role['description']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16))),
// // // // // //                       SizedBox(width: dateWidth, child: Text(role['createdAt']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16))),
// // // // // //                       SizedBox(
// // // // // //                         width: actionsWidth,
// // // // // //                         child: Row(
// // // // // //                           mainAxisAlignment: MainAxisAlignment.start,
// // // // // //                           children: [
// // // // // //                             Container(
// // // // // //                               height: 40,
// // // // // //                               width: 40,
// // // // // //                               margin: const EdgeInsets.only(right: 8),
// // // // // //                               decoration: BoxDecoration(
// // // // // //                                 borderRadius: BorderRadius.circular(10),
// // // // // //                                 color: Colors.amber,
// // // // // //                               ),
// // // // // //                               child: const Icon(Iconsax.edit, color: Colors.white),
// // // // // //                             ),
// // // // // //                             Container(
// // // // // //                               height: 40,
// // // // // //                               width: 40,
// // // // // //                               decoration: BoxDecoration(
// // // // // //                                 borderRadius: BorderRadius.circular(10),
// // // // // //                                 color: Colors.redAccent,
// // // // // //                               ),
// // // // // //                               child: const Icon(Iconsax.trash, color: Colors.white),
// // // // // //                             ),
// // // // // //                           ],
// // // // // //                         ),
// // // // // //                       ),
// // // // // //                     ],
// // // // // //                   ),
// // // // // //                 );
// // // // // //               },
// // // // // //             ),
// // // // // //           )
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // //
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // import 'package:iconsax/iconsax.dart';
// // // // //
// // // // // class ManageRolesSheet extends StatelessWidget {
// // // // //   const ManageRolesSheet({super.key});
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final List<Map<String, String>> roles = [
// // // // //       {'name': 'Admin', 'description': 'Admin Description', 'createdAt': '10-02-25'},
// // // // //       {'name': 'Editor', 'description': 'Editor Description', 'createdAt': '12-05-25'},
// // // // //       {'name': 'Viewer', 'description': 'Viewer Description', 'createdAt': '01-08-25'},
// // // // //     ];
// // // // //
// // // // //     final double nameWidth = 120;
// // // // //     final double descWidth = 180;
// // // // //     final double dateWidth = 100;
// // // // //     final double actionsWidth = 100;
// // // // //
// // // // //     return Align(
// // // // //       alignment: Alignment.centerLeft,
// // // // //       child: Material(
// // // // //         color: Colors.white,
// // // // //         elevation: 10,
// // // // //         borderRadius: const BorderRadius.only(
// // // // //           topRight: Radius.circular(20),
// // // // //           bottomRight: Radius.circular(20),
// // // // //         ),
// // // // //         child: SizedBox(
// // // // //           width: MediaQuery.of(context).size.width * 0.6, // Sheet width
// // // // //           child: Column(
// // // // //             children: [
// // // // //               // Header
// // // // //               Container(
// // // // //                 height: 60,
// // // // //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// // // // //                 decoration: BoxDecoration(
// // // // //                   color: Colors.cyan.shade300,
// // // // //                   borderRadius: const BorderRadius.only(
// // // // //                     topRight: Radius.circular(20),
// // // // //                   ),
// // // // //                 ),
// // // // //                 child: Row(
// // // // //                   children: [
// // // // //                     SizedBox(width: nameWidth, child: Text("Name", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16))),
// // // // //                     SizedBox(width: descWidth, child: Text("Description", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16))),
// // // // //                     SizedBox(width: dateWidth, child: Text("Created-at", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16))),
// // // // //                     SizedBox(width: actionsWidth, child: Text("Actions", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16))),
// // // // //                   ],
// // // // //                 ),
// // // // //               ),
// // // // //
// // // // //               // Rows
// // // // //               Expanded(
// // // // //                 child: ListView.builder(
// // // // //                   itemCount: roles.length,
// // // // //                   itemBuilder: (context, index) {
// // // // //                     final role = roles[index];
// // // // //                     return Container(
// // // // //                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // // // //                       decoration: BoxDecoration(
// // // // //                         border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
// // // // //                       ),
// // // // //                       child: Row(
// // // // //                         children: [
// // // // //                           SizedBox(width: nameWidth, child: Text(role['name']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16))),
// // // // //                           SizedBox(width: descWidth, child: Text(role['description']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16))),
// // // // //                           SizedBox(width: dateWidth, child: Text(role['createdAt']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16))),
// // // // //                           SizedBox(
// // // // //                             width: actionsWidth,
// // // // //                             child: Row(
// // // // //                               children: [
// // // // //                                 Container(
// // // // //                                   height: 40,
// // // // //                                   width: 40,
// // // // //                                   margin: const EdgeInsets.only(right: 8),
// // // // //                                   decoration: BoxDecoration(
// // // // //                                     borderRadius: BorderRadius.circular(10),
// // // // //                                     color: Colors.yellow,
// // // // //                                   ),
// // // // //                                   child: const Icon(Iconsax.edit, color: Colors.white),
// // // // //                                 ),
// // // // //                                 Container(
// // // // //                                   height: 40,
// // // // //                                   width: 40,
// // // // //                                   decoration: BoxDecoration(
// // // // //                                     borderRadius: BorderRadius.circular(10),
// // // // //                                     color: Colors.redAccent,
// // // // //                                   ),
// // // // //                                   child: const Icon(Iconsax.trash, color: Colors.white),
// // // // //                                 ),
// // // // //                               ],
// // // // //                             ),
// // // // //                           ),
// // // // //                         ],
// // // // //                       ),
// // // // //                     );
// // // // //                   },
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // // //
// // // // // /// Function to open sheet
// // // // // void openManageRolesSheet(BuildContext context) {
// // // // //   showGeneralDialog(
// // // // //     context: context,
// // // // //     barrierDismissible: true,
// // // // //     barrierLabel: '',
// // // // //     transitionDuration: const Duration(milliseconds: 300),
// // // // //     pageBuilder: (_, __, ___) => const SizedBox.shrink(),
// // // // //     transitionBuilder: (_, anim, __, child) {
// // // // //       return SlideTransition(
// // // // //         position: Tween<Offset>(
// // // // //           begin: const Offset(-1, 0), // Start off-screen left
// // // // //           end: Offset.zero,
// // // // //         ).animate(anim),
// // // // //         child: const ManageRolesSheet(),
// // // // //       );
// // // // //     },
// // // // //   );
// // // // // }
// // // // //
// // // // // /// Example usage
// // // // // class HomePage extends StatelessWidget {
// // // // //   const HomePage({super.key});
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(title: const Text("Dashboard")),
// // // // //       body: Center(
// // // // //         child: ElevatedButton(
// // // // //           onPressed: () => openManageRolesSheet(context),
// // // // //           child: const Text("Manage Roles"),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:google_fonts/google_fonts.dart';
// // // // import 'package:iconsax/iconsax.dart';
// // // //
// // // // class ManageRoles extends StatefulWidget {
// // // //   const ManageRoles({super.key});
// // // //
// // // //   @override
// // // //   State<ManageRoles> createState() => _ManageRolesState();
// // // // }
// // // //
// // // // class _ManageRolesState extends State<ManageRoles> {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       body: Column(
// // // //         children: [
// // // //           // 🔹 Header with close button
// // // //           Container(
// // // //             height: 60,
// // // //             padding: const EdgeInsets.symmetric(horizontal: 16),
// // // //             decoration: BoxDecoration(
// // // //               color: Colors.cyan.shade300,
// // // //               borderRadius: const BorderRadius.only(
// // // //                 topLeft: Radius.circular(16),
// // // //                 topRight: Radius.circular(16),
// // // //               ),
// // // //             ),
// // // //             child: Row(
// // // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //               children: [
// // // //                 Text("Manage Roles",
// // // //                     style: GoogleFonts.poppins(
// // // //                         fontSize: 18, fontWeight: FontWeight.w600)),
// // // //                 IconButton(
// // // //                   icon: const Icon(Icons.close, color: Colors.white),
// // // //                   onPressed: () => Navigator.of(context).pop(),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //
// // // //           // 🔹 Table header
// // // //           Container(
// // // //             height: 50,
// // // //             width: double.infinity,
// // // //             padding: const EdgeInsets.symmetric(horizontal: 16),
// // // //             decoration: BoxDecoration(
// // // //               color: Colors.cyan.shade100,
// // // //             ),
// // // //             child: Row(
// // // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //               children: [
// // // //                 Expanded(
// // // //                     flex: 2,
// // // //                     child: Text("Name",
// // // //                         style: GoogleFonts.poppins(
// // // //                             fontWeight: FontWeight.w500, fontSize: 14))),
// // // //                 Expanded(
// // // //                     flex: 3,
// // // //                     child: Text("Description",
// // // //                         style: GoogleFonts.poppins(
// // // //                             fontWeight: FontWeight.w500, fontSize: 14))),
// // // //                 Expanded(
// // // //                     flex: 2,
// // // //                     child: Text("Created-at",
// // // //                         style: GoogleFonts.poppins(
// // // //                             fontWeight: FontWeight.w500, fontSize: 14))),
// // // //                 Expanded(
// // // //                     flex: 2,
// // // //                     child: Text("Actions",
// // // //                         style: GoogleFonts.poppins(
// // // //                             fontWeight: FontWeight.w500, fontSize: 14))),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //
// // // //           // 🔹 Example row
// // // //           Expanded(
// // // //             child: ListView(
// // // //               children: [
// // // //                 Container(
// // // //                   padding:
// // // //                   const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // // //                   child: Row(
// // // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                     children: [
// // // //                       Expanded(
// // // //                           flex: 2,
// // // //                           child: Text("Admin",
// // // //                               style: GoogleFonts.poppins(fontSize: 14))),
// // // //                       Expanded(
// // // //                           flex: 3,
// // // //                           child: Text("Admin Description",
// // // //                               style: GoogleFonts.poppins(fontSize: 14))),
// // // //                       Expanded(
// // // //                           flex: 2,
// // // //                           child: Text("10-02-25",
// // // //                               style: GoogleFonts.poppins(fontSize: 14))),
// // // //                       Expanded(
// // // //                         flex: 2,
// // // //                         child: Row(
// // // //                           mainAxisAlignment: MainAxisAlignment.start,
// // // //                           children: [
// // // //                             Container(
// // // //                               height: 36,
// // // //                               width: 36,
// // // //                               decoration: BoxDecoration(
// // // //                                   borderRadius: BorderRadius.circular(8),
// // // //                                   color: Colors.yellow),
// // // //                               child: const Icon(Iconsax.edit, color: Colors.white),
// // // //                             ),
// // // //                             const SizedBox(width: 8),
// // // //                             Container(
// // // //                               height: 36,
// // // //                               width: 36,
// // // //                               decoration: BoxDecoration(
// // // //                                   borderRadius: BorderRadius.circular(8),
// // // //                                   color: Colors.redAccent),
// // // //                               child:
// // // //                               const Icon(Iconsax.trash, color: Colors.white),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       )
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // //
// // // // // 🔹 Floating right sheet
// // // // void openManageRolesSheet(BuildContext context) {
// // // //   showGeneralDialog(
// // // //     context: context,
// // // //     barrierDismissible: true,
// // // //     barrierLabel: "ManageRoles",
// // // //     transitionDuration: const Duration(milliseconds: 400),
// // // //     pageBuilder: (_, __, ___) {
// // // //       return Align(
// // // //         alignment: Alignment.centerRight,
// // // //         child: Container(
// // // //           margin: const EdgeInsets.only(
// // // //               top: 40, bottom: 40, right: 20), // floating box
// // // //           width: MediaQuery.of(context).size.width * 0.6, // 60% width
// // // //           decoration: BoxDecoration(
// // // //             color: Colors.white,
// // // //             borderRadius: BorderRadius.circular(16),
// // // //             boxShadow: [
// // // //               BoxShadow(
// // // //                 color: Colors.black26,
// // // //                 blurRadius: 20,
// // // //                 offset: const Offset(-5, 0),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           child: const ManageRoles(),
// // // //         ),
// // // //       );
// // // //     },
// // // //     transitionBuilder: (_, anim, __, child) {
// // // //       return SlideTransition(
// // // //         position: Tween(
// // // //           begin: const Offset(1, 0), // slide from right
// // // //           end: Offset.zero,
// // // //         ).animate(CurvedAnimation(
// // // //           parent: anim,
// // // //           curve: Curves.easeOutCubic,
// // // //         )),
// // // //         child: child,
// // // //       );
// // // //     },
// // // //   );
// // // // }
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:iconsax/iconsax.dart';
// // //
// // // class ManageRoles extends StatefulWidget {
// // //   const ManageRoles({super.key});
// // //
// // //   @override
// // //   State<ManageRoles> createState() => _ManageRolesState();
// // // }
// // //
// // // class _ManageRolesState extends State<ManageRoles> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return ClipRRect(
// // //       borderRadius: BorderRadius.circular(30), // 👈 clip entire sheet
// // //       child: Scaffold(
// // //         backgroundColor: Colors.white,
// // //         body: Column(
// // //           children: [
// // //             // 🔹 Header with close button
// // //             Container(
// // //               height: 60,
// // //               padding: const EdgeInsets.symmetric(horizontal: 16),
// // //               decoration: BoxDecoration(
// // //                 color: Colors.cyan.shade300,
// // //                 borderRadius: const BorderRadius.only(
// // //                   topLeft: Radius.circular(30), // match sheet curve
// // //                   topRight: Radius.circular(30),
// // //                 ),
// // //               ),
// // //               child: Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                 children: [
// // //                   Text("Manage Roles",
// // //                       style: GoogleFonts.poppins(
// // //                           fontSize: 18, fontWeight: FontWeight.w600)),
// // //                   IconButton(
// // //                     icon: const Icon(Icons.close, color: Colors.white),
// // //                     onPressed: () => Navigator.of(context).pop(),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //
// // //             // 🔹 Table header
// // //             Container(
// // //               height: 50,
// // //               width: double.infinity,
// // //               padding: const EdgeInsets.symmetric(horizontal: 16),
// // //               color: Colors.cyan.shade100,
// // //               child: Row(
// // //                 children: [
// // //                   Expanded(
// // //                       flex: 2,
// // //                       child: Text("Name",
// // //                           style: GoogleFonts.poppins(
// // //                               fontWeight: FontWeight.w500, fontSize: 14))),
// // //                   Expanded(
// // //                       flex: 3,
// // //                       child: Text("Description",
// // //                           style: GoogleFonts.poppins(
// // //                               fontWeight: FontWeight.w500, fontSize: 14))),
// // //                   Expanded(
// // //                       flex: 2,
// // //                       child: Text("Created-at",
// // //                           style: GoogleFonts.poppins(
// // //                               fontWeight: FontWeight.w500, fontSize: 14))),
// // //                   Expanded(
// // //                       flex: 2,
// // //                       child: Text("Actions",
// // //                           style: GoogleFonts.poppins(
// // //                               fontWeight: FontWeight.w500, fontSize: 14))),
// // //                 ],
// // //               ),
// // //             ),
// // //
// // //             // 🔹 Example row
// // //             Expanded(
// // //               child: ListView(
// // //                 children: [
// // //                   Container(
// // //                     padding: const EdgeInsets.symmetric(
// // //                         horizontal: 16, vertical: 12),
// // //                     child: Row(
// // //                       children: [
// // //                         Expanded(
// // //                             flex: 2,
// // //                             child: Text("Admin",
// // //                                 style: GoogleFonts.poppins(fontSize: 14))),
// // //                         Expanded(
// // //                             flex: 3,
// // //                             child: Text("Admin Description",
// // //                                 style: GoogleFonts.poppins(fontSize: 14))),
// // //                         Expanded(
// // //                             flex: 2,
// // //                             child: Text("10-02-25",
// // //                                 style: GoogleFonts.poppins(fontSize: 14))),
// // //                         Expanded(
// // //                           flex: 2,
// // //                           child: Row(
// // //                             children: [
// // //                               Container(
// // //                                 height: 36,
// // //                                 width: 36,
// // //                                 decoration: BoxDecoration(
// // //                                     borderRadius: BorderRadius.circular(8),
// // //                                     color: Colors.yellow),
// // //                                 child: const Icon(Iconsax.edit,
// // //                                     color: Colors.white),
// // //                               ),
// // //                               const SizedBox(width: 8),
// // //                               Container(
// // //                                 height: 36,
// // //                                 width: 36,
// // //                                 decoration: BoxDecoration(
// // //                                     borderRadius: BorderRadius.circular(8),
// // //                                     color: Colors.redAccent),
// // //                                 child: const Icon(Iconsax.trash,
// // //                                     color: Colors.white),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         )
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // // 🔹 Floating right sheet
// // // void openManageRolesSheet(BuildContext context) {
// // //   showGeneralDialog(
// // //     context: context,
// // //     barrierDismissible: true,
// // //     barrierLabel: "ManageRoles",
// // //     transitionDuration: const Duration(milliseconds: 400),
// // //     pageBuilder: (_, __, ___) {
// // //       return Align(
// // //         alignment: Alignment.centerRight,
// // //         child: Container(
// // //           margin:
// // //           const EdgeInsets.only(top: 40, bottom: 40, right: 20), // floating
// // //           width: MediaQuery.of(context).size.width * 0.4, // 👈 smaller width
// // //           decoration: BoxDecoration(
// // //             borderRadius: BorderRadius.circular(30), // 👈 round sheet
// // //             boxShadow: [
// // //               BoxShadow(
// // //                 color: Colors.black26,
// // //                 blurRadius: 20,
// // //                 offset: const Offset(-5, 0),
// // //               ),
// // //             ],
// // //           ),
// // //           child: const ManageRoles(),
// // //         ),
// // //       );
// // //     },
// // //     transitionBuilder: (_, anim, __, child) {
// // //       return SlideTransition(
// // //         position: Tween(
// // //           begin: const Offset(1, 0), // slide from right
// // //           end: Offset.zero,
// // //         ).animate(CurvedAnimation(
// // //           parent: anim,
// // //           curve: Curves.easeOutCubic,
// // //         )),
// // //         child: child,
// // //       );
// // //     },
// // //   );
// // // }
// // //
// //
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:provider/provider.dart';
// // import '../Controller/Roles_controller.dart'; // adjust path
// //
// // class ManageRoles extends StatefulWidget {
// //   const ManageRoles({super.key});
// //
// //   @override
// //   State<ManageRoles> createState() => _ManageRolesState();
// // }
// //
// // class _ManageRolesState extends State<ManageRoles> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     // fetch roles when sheet opens
// //     Future.microtask(() =>
// //         Provider.of<RolesController>(context, listen: false).fetchRoles());
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ClipRRect(
// //       borderRadius: BorderRadius.circular(30), // clip sheet edges
// //       child: Scaffold(
// //         backgroundColor: Colors.white,
// //         body: Consumer<RolesController>(
// //           builder: (context, rolesController, child) {
// //             if (rolesController.isLoading) {
// //               return const Center(child: CircularProgressIndicator());
// //             }
// //
// //             return Column(
// //               children: [
// //                 // 🔹 Header with close button
// //                 Container(
// //                   height: 60,
// //                   padding: const EdgeInsets.symmetric(horizontal: 16),
// //                   decoration: BoxDecoration(
// //                     color: Colors.cyan.shade300,
// //                     borderRadius: const BorderRadius.only(
// //                       topLeft: Radius.circular(30),
// //                       topRight: Radius.circular(30),
// //                     ),
// //                   ),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Text("Manage Roles",
// //                           style: GoogleFonts.poppins(
// //                               fontSize: 18, fontWeight: FontWeight.w600)),
// //                       IconButton(
// //                         icon: const Icon(Icons.close, color: Colors.white),
// //                         onPressed: () => Navigator.of(context).pop(),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 // 🔹 Table header
// //                 Container(
// //                   height: 50,
// //                   width: double.infinity,
// //                   padding: const EdgeInsets.symmetric(horizontal: 16),
// //                   color: Colors.cyan.shade100,
// //                   child: Row(
// //                     children: [
// //                       Expanded(
// //                           flex: 2,
// //                           child: Text("Name",
// //                               style: GoogleFonts.poppins(
// //                                   fontWeight: FontWeight.w500, fontSize: 14))),
// //                       Expanded(
// //                           flex: 3,
// //                           child: Text("Description",
// //                               style: GoogleFonts.poppins(
// //                                   fontWeight: FontWeight.w500, fontSize: 14))),
// //                       Expanded(
// //                           flex: 2,
// //                           child: Text("Created-at",
// //                               style: GoogleFonts.poppins(
// //                                   fontWeight: FontWeight.w500, fontSize: 14))),
// //                       Expanded(
// //                           flex: 2,
// //                           child: Text("Actions",
// //                               style: GoogleFonts.poppins(
// //                                   fontWeight: FontWeight.w500, fontSize: 14))),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 // 🔹 Roles list
// //                 Expanded(
// //                   child: rolesController.roles.isEmpty
// //                       ? Center(
// //                       child: Text("No roles found",
// //                           style: GoogleFonts.poppins(fontSize: 14)))
// //                       : ListView.builder(
// //                     itemCount: rolesController.roles.length,
// //                     itemBuilder: (context, index) {
// //                       final role = rolesController.roles[index];
// //                       return Container(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 16, vertical: 12),
// //                         child: Row(
// //                           children: [
// //                             Expanded(
// //                                 flex: 2,
// //                                 child: Text(role['name'] ?? "",
// //                                     style: GoogleFonts.poppins(
// //                                         fontSize: 14))),
// //                             Expanded(
// //                                 flex: 3,
// //                                 child: Text(role['description'] ?? "",
// //                                     style: GoogleFonts.poppins(
// //                                         fontSize: 14))),
// //                             Expanded(
// //                                 flex: 2,
// //                                 child: Text(role['createdAt'] ?? "",
// //                                     style: GoogleFonts.poppins(
// //                                         fontSize: 14))),
// //                             Expanded(
// //                               flex: 2,
// //                               child: Row(
// //                                 children: [
// //                                   Container(
// //                                     height: 36,
// //                                     width: 36,
// //                                     decoration: BoxDecoration(
// //                                         borderRadius:
// //                                         BorderRadius.circular(8),
// //                                         color: Colors.yellow),
// //                                     child: const Icon(Iconsax.edit,
// //                                         color: Colors.white, size: 18),
// //                                   ),
// //                                   const SizedBox(width: 8),
// //                                   Container(
// //                                     height: 36,
// //                                     width: 36,
// //                                     decoration: BoxDecoration(
// //                                         borderRadius:
// //                                         BorderRadius.circular(8),
// //                                         color: Colors.redAccent),
// //                                     child: const Icon(Iconsax.trash,
// //                                         color: Colors.white, size: 18),
// //                                   ),
// //                                 ],
// //                               ),
// //                             )
// //                           ],
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // 🔹 Floating right sheet
// // void openManageRolesSheet(BuildContext context) {
// //   showGeneralDialog(
// //     context: context,
// //     barrierDismissible: true,
// //     barrierLabel: "ManageRoles",
// //     transitionDuration: const Duration(milliseconds: 400),
// //     pageBuilder: (_, __, ___) {
// //       return Align(
// //         alignment: Alignment.centerRight,
// //         child: Container(
// //           margin:
// //           const EdgeInsets.only(top: 40, bottom: 40, right: 20), // floating
// //           width: MediaQuery.of(context).size.width * 0.4, // smaller width
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(30),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.black26,
// //                 blurRadius: 20,
// //                 offset: const Offset(-5, 0),
// //               ),
// //             ],
// //           ),
// //           child: const ManageRoles(),
// //         ),
// //       );
// //     },
// //     transitionBuilder: (_, anim, __, child) {
// //       return SlideTransition(
// //         position: Tween(
// //           begin: const Offset(1, 0), // slide from right
// //           end: Offset.zero,
// //         ).animate(CurvedAnimation(
// //           parent: anim,
// //           curve: Curves.easeOutCubic,
// //         )),
// //         child: child,
// //       );
// //     },
// //   );
// // }
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart'; // ✅ for date formatting
// import '../Controller/Roles_controller.dart'; // adjust path
//
// class ManageRoles extends StatefulWidget {
//   const ManageRoles({super.key});
//
//   @override
//   State<ManageRoles> createState() => _ManageRolesState();
// }
//
// class _ManageRolesState extends State<ManageRoles> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() =>
//         Provider.of<RolesController>(context, listen: false).fetchRoles());
//   }
//
//   String formatDate(String? dateStr) {
//     if (dateStr == null || dateStr.isEmpty) return "";
//     try {
//       final date = DateTime.parse(dateStr);
//       return DateFormat("yyyy-MM-dd").format(date);
//     } catch (e) {
//       return dateStr; // fallback
//     }
//   }
//
//   Future<void> _confirmDelete(BuildContext context, String roleId) async {
//     final rolesController =
//     Provider.of<RolesController>(context, listen: false);
//
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Text("Confirm Delete",
//             style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
//         content: Text("Are you sure you want to delete this role?",
//             style: GoogleFonts.poppins()),
//         actions: [
//           TextButton(
//             child: Text("Cancel",
//                 style: GoogleFonts.poppins(color: Colors.grey)),
//             onPressed: () => Navigator.of(ctx).pop(false),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8))),
//             child: Text("Delete",
//                 style: GoogleFonts.poppins(color: Colors.white)),
//             onPressed: () => Navigator.of(ctx).pop(true),
//           ),
//         ],
//       ),
//     );
//
//     if (confirm == true) {
//       await rolesController.deleteRole(roleId);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(30),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Consumer<RolesController>(
//           builder: (context, rolesController, child) {
//             if (rolesController.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             return Column(
//               children: [
//                 // Header
//                 Container(
//                   height: 60,
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.cyan.shade300,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Manage Roles",
//                           style: GoogleFonts.poppins(
//                               fontSize: 18, fontWeight: FontWeight.w600)),
//                       IconButton(
//                         icon: const Icon(Icons.close, color: Colors.white),
//                         onPressed: () => Navigator.of(context).pop(),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Table header
//                 Container(
//                   height: 50,
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   color: Colors.cyan.shade100,
//                   child: Row(
//                     children: [
//                       Expanded(
//                           flex: 2,
//                           child: Text("Name",
//                               style: GoogleFonts.poppins(
//                                   fontWeight: FontWeight.w500, fontSize: 14))),
//                       Expanded(
//                           flex: 3,
//                           child: Text("Description",
//                               style: GoogleFonts.poppins(
//                                   fontWeight: FontWeight.w500, fontSize: 14))),
//                       Expanded(
//                           flex: 2,
//                           child: Text("Created-at",
//                               style: GoogleFonts.poppins(
//                                   fontWeight: FontWeight.w500, fontSize: 14))),
//                       Expanded(
//                           flex: 2,
//                           child: Text("Actions",
//                               style: GoogleFonts.poppins(
//                                   fontWeight: FontWeight.w500, fontSize: 14))),
//                     ],
//                   ),
//                 ),
//
//                 // Roles list
//                 Expanded(
//                   child: rolesController.roles.isEmpty
//                       ? Center(
//                       child: Text("No roles found",
//                           style: GoogleFonts.poppins(fontSize: 14)))
//                       : ListView.builder(
//                     itemCount: rolesController.roles.length,
//                     itemBuilder: (context, index) {
//                       final role = rolesController.roles[index];
//                       return Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 12),
//                         child: Row(
//                           children: [
//                             Expanded(
//                                 flex: 2,
//                                 child: Text(role['name'] ?? "",
//                                     style: GoogleFonts.poppins(
//                                         fontSize: 14))),
//                             Expanded(
//                                 flex: 3,
//                                 child: Text(role['description'] ?? "",
//                                     style: GoogleFonts.poppins(
//                                         fontSize: 14))),
//                             Expanded(
//                                 flex: 2,
//                                 child: Text(
//                                     formatDate(role['createdAt']),
//                                     style: GoogleFonts.poppins(
//                                         fontSize: 14))),
//                             Expanded(
//                               flex: 2,
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     height: 36,
//                                     width: 36,
//                                     decoration: BoxDecoration(
//                                         borderRadius:
//                                         BorderRadius.circular(8),
//                                         color: Colors.yellow),
//                                     child: const Icon(Iconsax.edit,
//                                         color: Colors.white, size: 18),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   InkWell(
//                                     onTap: () => _confirmDelete(
//                                         context, role['id'].toString()),
//                                     child: Container(
//                                       height: 36,
//                                       width: 36,
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                           BorderRadius.circular(8),
//                                           color: Colors.redAccent),
//                                       child: const Icon(Iconsax.trash,
//                                           color: Colors.white, size: 18),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// // Floating right sheet
// void openManageRolesSheet(BuildContext context) {
//   showGeneralDialog(
//     context: context,
//     barrierDismissible: true,
//     barrierLabel: "ManageRoles",
//     transitionDuration: const Duration(milliseconds: 400),
//     pageBuilder: (_, __, ___) {
//       return Align(
//         alignment: Alignment.centerRight,
//         child: Container(
//           margin: const EdgeInsets.only(top: 40, bottom: 40, right: 20),
//           width: MediaQuery.of(context).size.width * 0.4,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 20,
//                 offset: const Offset(-5, 0),
//               ),
//             ],
//           ),
//           child: const ManageRoles(),
//         ),
//       );
//     },
//     transitionBuilder: (_, anim, __, child) {
//       return SlideTransition(
//         position: Tween(
//           begin: const Offset(1, 0),
//           end: Offset.zero,
//         ).animate(CurvedAnimation(
//           parent: anim,
//           curve: Curves.easeOutCubic,
//         )),
//         child: child,
//       );
//     },
//   );
// }


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
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RolesController>(context, listen: false).fetchRoles());
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat("yyyy-MM-dd").format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Future<void> _confirmDelete(BuildContext context, String roleId) async {
    final rolesController =
    Provider.of<RolesController>(context, listen: false);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Confirm Delete",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text("Are you sure you want to delete this role?",
            style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            child: Text("Cancel",
                style: GoogleFonts.poppins(color: Colors.grey)),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text("Delete",
                style: GoogleFonts.poppins(color: Colors.white)),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await rolesController.deleteRole(roleId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<RolesController>(
          builder: (context, rolesController, child) {
            if (rolesController.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                // Header
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.cyan.shade300,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Manage Roles",
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                // Table header
                Container(
                  height: 50,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.cyan.shade100,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text("Name",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500, fontSize: 14))),
                      Expanded(
                          flex: 3,
                          child: Text("Description",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500, fontSize: 14))),
                      Expanded(
                          flex: 2,
                          child: Text("Created-at",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500, fontSize: 14))),
                      Expanded(
                          flex: 2,
                          child: Text("Actions",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500, fontSize: 14))),
                    ],
                  ),
                ),

                // Roles list
                Expanded(
                  child: rolesController.roles.isEmpty
                      ? Center(
                      child: Text("No roles found",
                          style: GoogleFonts.poppins(fontSize: 14)))
                      : ListView.builder(
                    itemCount: rolesController.roles.length,
                    itemBuilder: (context, index) {
                      final role = rolesController.roles[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(role['name'] ?? "",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14))),
                            Expanded(
                                flex: 3,
                                child: Text(role['description'] ?? "",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14))),
                            Expanded(
                                flex: 2,
                                child: Text(
                                    formatDate(role['createdAt']),
                                    style: GoogleFonts.poppins(
                                        fontSize: 14))),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        color: Colors.yellow),
                                    child: const Icon(Iconsax.edit,
                                        color: Colors.white, size: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () => _confirmDelete(
                                        context,
                                        role['_id'].toString()),
                                    child: Container(
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          color: Colors.redAccent),
                                      child: const Icon(Iconsax.trash,
                                          color: Colors.white, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Floating right sheet
void openManageRolesSheet(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "ManageRoles",
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(top: 40, bottom: 40, right: 20),
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: const Offset(-5, 0),
              ),
            ],
          ),
          child: const ManageRoles(),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      );
    },
  );
}
