// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:intl/intl.dart';
// // import '../controller/organization_controller.dart';
// //
// // class OrganizationRow extends StatefulWidget {
// //   final Map<String, dynamic> organization;
// //   final VoidCallback onDelete;
// //   final void Function(Map<String, dynamic> org) onEdit; // ✅ Added
// //
// //   const OrganizationRow({
// //     super.key,
// //     required this.organization,
// //     required this.onDelete,
// //     required this.onEdit, // ✅ Added
// //   });
// //
// //   @override
// //   State<OrganizationRow> createState() => _OrganizationRowState();
// // }
// //
// // class _OrganizationRowState extends State<OrganizationRow> {
// //   late Map<String, dynamic> org;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     org = widget.organization;
// //   }
// //
// //   Future<bool> showConfirmationDialog({
// //     required String title,
// //     required String message,
// //   }) async {
// //     return await showDialog<bool>(
// //       context: context,
// //       builder: (ctx) => AlertDialog(
// //         title: Text(title),
// //         content: Text(message),
// //         actions: [
// //           TextButton(
// //             child: const Text("Cancel"),
// //             onPressed: () => Navigator.pop(ctx, false),
// //           ),
// //           ElevatedButton(
// //             style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
// //             child: const Text("Confirm"),
// //             onPressed: () => Navigator.pop(ctx, true),
// //           ),
// //         ],
// //       ),
// //     ) ??
// //         false;
// //   }
// //
// //   String formatDate(String dateStr) {
// //     try {
// //       final date = DateTime.parse(dateStr);
// //       return DateFormat('yy/MM/dd').format(date);
// //     } catch (_) {
// //       return dateStr;
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final columnFlex = [3, 2, 2, 2, 3];
// //     final name = org['name'] ?? "this organization";
// //
// //     return Container(
// //       height: MediaQuery.of(context).size.height * 0.07,
// //       padding: const EdgeInsets.symmetric(horizontal: 16),
// //       decoration: BoxDecoration(
// //         border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
// //       ),
// //       child: Row(
// //         children: [
// //           // Name
// //           Expanded(flex: columnFlex[0], child: _dataItem(name)),
// //
// //           // Block/Unblock
// //           Expanded(
// //             flex: columnFlex[1],
// //             child: Center(
// //               child: GestureDetector(
// //                 onTap: () async {
// //                   final isBlocked = org['blocked'] == true;
// //                   final action = isBlocked ? "unblock" : "block";
// //                   final confirmed = await showConfirmationDialog(
// //                     title:
// //                     "${action[0].toUpperCase()}${action.substring(1)} Organization",
// //                     message: "Are you sure you want to $action '$name'?",
// //                   );
// //                   if (confirmed) {
// //                     final success = await OrganizationController.blockOrganization(
// //                       org['_id'],
// //                       !isBlocked,
// //                     );
// //                     if (success) {
// //                       setState(() {
// //                         org['blocked'] = !isBlocked;
// //                       });
// //                     } else {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         SnackBar(content: Text("Failed to $action organization")),
// //                       );
// //                     }
// //                   }
// //                 },
// //                 child: Container(
// //                   padding:
// //                   const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(10),
// //                     color: org['blocked'] == true
// //                         ? Colors.red.shade100
// //                         : Colors.yellow.shade100,
// //                   ),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Icon(
// //                         Icons.block_rounded,
// //                         color: org['blocked'] == true
// //                             ? Colors.red
// //                             : Colors.orangeAccent,
// //                         size: 18,
// //                       ),
// //                       const SizedBox(width: 8),
// //                       Text(
// //                         org['blocked'] == true ? "Unblock" : "Block",
// //                         style: TextStyle(
// //                           color: org['blocked'] == true
// //                               ? Colors.red
// //                               : Colors.orangeAccent,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //
// //           // Approval
// //           Expanded(
// //             flex: columnFlex[1],
// //             child: Center(
// //               child: org['approved'] == true
// //                   ? const Text("Accepted",
// //                   style: TextStyle(
// //                       color: Colors.green, fontWeight: FontWeight.bold))
// //                   : org['approved'] == false
// //                   ? const Text("Rejected",
// //                   style: TextStyle(
// //                       color: Colors.red, fontWeight: FontWeight.bold))
// //                   : Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   IconButton(
// //                     icon: const Icon(Iconsax.tick_circle,
// //                         color: Colors.green),
// //                     onPressed: () async {
// //                       final confirmed = await showConfirmationDialog(
// //                         title: "Approve Organization",
// //                         message:
// //                         "Are you sure you want to approve '$name'?",
// //                       );
// //                       if (confirmed) {
// //                         final success =
// //                         await OrganizationController.approveOrganization(
// //                             org['_id'], true);
// //                         if (success) {
// //                           setState(() => org['approved'] = true);
// //                         } else {
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             const SnackBar(
// //                                 content: Text(
// //                                     "Failed to approve organization")),
// //                           );
// //                         }
// //                       }
// //                     },
// //                   ),
// //                   IconButton(
// //                     icon: const Icon(Iconsax.close_circle,
// //                         color: Colors.red),
// //                     onPressed: () async {
// //                       final confirmed = await showConfirmationDialog(
// //                         title: "Reject Organization",
// //                         message:
// //                         "Are you sure you want to reject '$name'?",
// //                       );
// //                       if (confirmed) {
// //                         final success =
// //                         await OrganizationController.approveOrganization(
// //                             org['_id'], false);
// //                         if (success) {
// //                           setState(() => org['approved'] = false);
// //                         } else {
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             const SnackBar(
// //                                 content: Text(
// //                                     "Failed to reject organization")),
// //                           );
// //                         }
// //                       }
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //
// //           // Actions
// //           Expanded(
// //             flex: columnFlex[2],
// //             child: Center(
// //               child: PopupMenuButton<String>(
// //                 onSelected: (value) async {
// //                   if (value == 'edit') {
// //                     widget.onEdit(org); // ✅ Call edit
// //                   } else if (value == 'delete') {
// //                     final confirmed = await showConfirmationDialog(
// //                       title: "Delete Organization",
// //                       message: "Are you sure you want to delete '$name'?",
// //                     );
// //                     if (confirmed) widget.onDelete();
// //                   }
// //                 },
// //                 itemBuilder: (context) => const [
// //                   PopupMenuItem(value: 'edit', child: Text("Edit")),
// //                   PopupMenuItem(value: 'delete', child: Text("Delete")),
// //                 ],
// //                 icon: const Icon(Iconsax.card_edit),
// //               ),
// //             ),
// //           ),
// //
// //           // Created At
// //           Expanded(
// //             flex: columnFlex[4],
// //             child: _dataItem(formatDate(org['createdAt'] ?? "")),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _dataItem(String value) => Center(
// //     child: Text(
// //       value,
// //       style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
// //     ),
// //   );
// // }
//
//
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import '../controller/organization_controller.dart';
// import '../controller/app_controller.dart';
//
// class OrganizationRow extends StatefulWidget {
//   final Map<String, dynamic> organization;
//   final VoidCallback onDelete;
//   final void Function(Map<String, dynamic> org) onEdit;
//
//   const OrganizationRow({
//     super.key,
//     required this.organization,
//     required this.onDelete,
//     required this.onEdit,
//   });
//
//   @override
//   State<OrganizationRow> createState() => _OrganizationRowState();
// }
//
// class _OrganizationRowState extends State<OrganizationRow> {
//   late Map<String, dynamic> org;
//   List<Map<String, dynamic>> appList = [];
//   String? selectedAppId;
//   final AppService _appService = AppService();
//   List<dynamic> _apps = [];
//   bool _isLoading = true;
//
//
//   @override
//   void initState() {
//     super.initState();
//     org = widget.organization;
//     selectedAppId = org['app']?['_id'];
//     _fetchApps();
//   }
//
//   Future<void> _fetchApps() async {
//     try {
//       final apps = await _appService.getApps();
//       setState(() {
//         _apps = apps;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Failed to load apps")));
//     }
//   }
//
//
//   Future<bool> showConfirmationDialog({
//     required String title,
//     required String message,
//   }) async {
//     return await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//             child: const Text("Cancel"),
//             onPressed: () => Navigator.pop(ctx, false),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//             child: const Text("Confirm"),
//             onPressed: () => Navigator.pop(ctx, true),
//           ),
//         ],
//       ),
//     ) ??
//         false;
//   }
//
//   String formatDate(String dateStr) {
//     try {
//       final date = DateTime.parse(dateStr);
//       return DateFormat('yy/MM/dd').format(date);
//     } catch (_) {
//       return dateStr;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final columnFlex = [3, 2, 2, 2, 2, 3];
//     final name = org['name'] ?? "this organization";
//
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.07,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
//       ),
//       child: Row(
//         children: [
//           // Name
//           Expanded(flex: columnFlex[0], child: _dataItem(name)),
//
//           // App Dropdown
//           Expanded(
//             flex: columnFlex[1],
//             child: Center(
//               child: DropdownButton<String>(
//                 value: selectedAppId,
//                 hint: const Text("Select App", style: TextStyle(fontSize: 13)),
//                 onChanged: (newValue) async {
//                   final selectedApp = appList.firstWhere((app) => app['_id'] == newValue);
//                   final confirmed = await showConfirmationDialog(
//                     title: "Assign App",
//                     message: "Assign '${selectedApp['appName']}' to '$name'?",
//                   );
//                   if (confirmed) {
//                     final success = await OrganizationController.assignAppToOrganization(
//                       org['_id'],
//                       selectedApp['_id'],
//                     );
//                     if (success) {
//                       setState(() {
//                         selectedAppId = selectedApp['_id'];
//                         org['app'] = selectedApp;
//                       });
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("App assigned successfully")),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Failed to assign app")),
//                       );
//                     }
//                   }
//                 },
//                 items: appList.map((app) {
//                   return DropdownMenuItem<String>(
//                     value: app['_id'],
//                     child: Text(app['appName'], style: const TextStyle(fontSize: 13)),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//
//           // Approval
//           Expanded(
//             flex: columnFlex[2],
//             child: Center(
//               child: org['approved'] == true
//                   ? const Text("Accepted", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
//                   : org['approved'] == false
//                   ? const Text("Rejected", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
//                   : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Iconsax.tick_circle, color: Colors.green),
//                     onPressed: () async {
//                       final confirmed = await showConfirmationDialog(
//                         title: "Approve Organization",
//                         message: "Are you sure you want to approve '$name'?",
//                       );
//                       if (confirmed) {
//                         final success = await OrganizationController.approveOrganization(org['_id'], true);
//                         if (success) {
//                           setState(() => org['approved'] = true);
//                         }
//                       }
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Iconsax.close_circle, color: Colors.red),
//                     onPressed: () async {
//                       final confirmed = await showConfirmationDialog(
//                         title: "Reject Organization",
//                         message: "Are you sure you want to reject '$name'?",
//                       );
//                       if (confirmed) {
//                         final success = await OrganizationController.approveOrganization(org['_id'], false);
//                         if (success) {
//                           setState(() => org['approved'] = false);
//                         }
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Actions
//           Expanded(
//             flex: columnFlex[3],
//             child: Center(
//               child: PopupMenuButton<String>(
//                 onSelected: (value) async {
//                   if (value == 'edit') {
//                     widget.onEdit(org);
//                   } else if (value == 'delete') {
//                     final confirmed = await showConfirmationDialog(
//                       title: "Delete Organization",
//                       message: "Are you sure you want to delete '$name'?",
//                     );
//                     if (confirmed) widget.onDelete();
//                   }
//                 },
//                 itemBuilder: (context) => const [
//                   PopupMenuItem(value: 'edit', child: Text("Edit")),
//                   PopupMenuItem(value: 'delete', child: Text("Delete")),
//                 ],
//                 icon: const Icon(Iconsax.card_edit),
//               ),
//             ),
//           ),
//
//           // Created At
//           Expanded(
//             flex: columnFlex[5],
//             child: _dataItem(formatDate(org['createdAt'] ?? "")),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _dataItem(String value) => Center(
//     child: Text(
//       value,
//       style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
//     ),
//   );
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../controller/organization_controller.dart';
import '../controller/app_controller.dart';

class OrganizationRow extends StatefulWidget {
  final Map<String, dynamic> organization;
  final VoidCallback onDelete;
  final void Function(Map<String, dynamic> org) onEdit;

  const OrganizationRow({
    super.key,
    required this.organization,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<OrganizationRow> createState() => _OrganizationRowState();
}

class _OrganizationRowState extends State<OrganizationRow> {
  late Map<String, dynamic> org;
  final AppService _appService = AppService();

  List<dynamic> _apps = [];
  String? selectedAppId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    org = widget.organization;
    selectedAppId = org['app']?['_id'];
    _fetchApps();
  }

  Future<void> _fetchApps() async {
    try {
      final apps = await _appService.getApps();
      setState(() {
        _apps = apps;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load apps")),
      );
    }
  }

  Future<bool> showConfirmationDialog({
    required String title,
    required String message,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text("Confirm"),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    ) ??
        false;
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('yy/MM/dd').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final columnFlex = [3, 2, 2, 2, 2, 3];
    final name = org['name'] ?? "this organization";

    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // Name
          Expanded(flex: columnFlex[0], child: _dataItem(name)),

          // App Dropdown
          Expanded(
            flex: columnFlex[1],
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : DropdownButton<String>(
                isExpanded: true,
                value: selectedAppId,
                hint: const Text("Select App", style: TextStyle(fontSize: 13)),
                onChanged: (newValue) async {
                  final selectedApp = _apps.firstWhere((app) => app['_id'] == newValue);
                  final confirmed = await showConfirmationDialog(
                    title: "Assign App",
                    message: "Assign '${selectedApp['appName']}' to '$name'?",
                  );
                  if (confirmed) {
                    final success = await OrganizationController.assignAppToOrganization(
                      org['_id'],
                      selectedApp['_id'],
                    );
                    if (success) {
                      setState(() {
                        selectedAppId = selectedApp['_id'];
                        org['app'] = selectedApp;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("App assigned successfully")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to assign app")),
                      );
                    }
                  }
                },
                items: _apps.map((app) {
                  return DropdownMenuItem<String>(
                    value: app['_id'],
                    child: Text(app['appName'], style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
              ),
            ),
          ),

          // Approval Status / Actions
          Expanded(
            flex: columnFlex[2],
            child: Center(
              child: org['approved'] == true
                  ? const Text("Accepted", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                  : org['approved'] == false
                  ? const Text("Rejected", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Iconsax.tick_circle, color: Colors.green),
                    onPressed: () async {
                      final confirmed = await showConfirmationDialog(
                        title: "Approve Organization",
                        message: "Are you sure you want to approve '$name'?",
                      );
                      if (confirmed) {
                        final success = await OrganizationController.approveOrganization(org['_id'], true);
                        if (success) setState(() => org['approved'] = true);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.close_circle, color: Colors.red),
                    onPressed: () async {
                      final confirmed = await showConfirmationDialog(
                        title: "Reject Organization",
                        message: "Are you sure you want to reject '$name'?",
                      );
                      if (confirmed) {
                        final success = await OrganizationController.approveOrganization(org['_id'], false);
                        if (success) setState(() => org['approved'] = false);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // Edit/Delete Actions
          Expanded(
            flex: columnFlex[3],
            child: Center(
              child: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    widget.onEdit(org);
                  } else if (value == 'delete') {
                    final confirmed = await showConfirmationDialog(
                      title: "Delete Organization",
                      message: "Are you sure you want to delete '$name'?",
                    );
                    if (confirmed) widget.onDelete();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text("Edit")),
                  PopupMenuItem(value: 'delete', child: Text("Delete")),
                ],
                icon: const Icon(Iconsax.card_edit),
              ),
            ),
          ),

          // Created At
          Expanded(
            flex: columnFlex[5],
            child: _dataItem(formatDate(org['createdAt'] ?? "")),
          ),
        ],
      ),
    );
  }

  Widget _dataItem(String value) => Center(
    child: Text(
      value,
      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
    ),
  );
}
