// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:lottie/lottie.dart';
// import '../Controller/App_controller.dart';
//
// class ApplicationPage extends StatefulWidget {
//   const ApplicationPage({super.key});
//
//   @override
//   State<ApplicationPage> createState() => _ApplicationPageState();
// }
//
// // class _ApplicationPageState extends State<ApplicationPage> {
// //   final AppService _appService = AppService();
// //   List<dynamic> _apps = [];
// //   bool _isLoading = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchApps();
// //   }
// //
// //   Future<void> _fetchApps() async {
// //     try {
// //       final apps = await _appService.getApps();
// //       setState(() {
// //         _apps = apps;
// //         _isLoading = false;
// //       });
// //     } catch (e) {
// //       setState(() => _isLoading = false);
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Failed to load apps")),
// //       );
// //     }
// //   }
// //
// //   Future<void> _deleteApp(String id) async {
// //     final confirmed = await showDialog<bool>(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: const Text('Confirm Delete'),
// //         content: const Text('Are you sure you want to delete this app?'),
// //         actions: [
// //           TextButton(
// //             child: const Text('Cancel'),
// //             onPressed: () => Navigator.pop(context, false),
// //           ),
// //           TextButton(
// //             child: const Text('Delete'),
// //             onPressed: () => Navigator.pop(context, true),
// //           ),
// //         ],
// //       ),
// //     );
// //
// //     if (confirmed == true) {
// //       final success = await _appService.deleteApp(id);
// //       if (success) {
// //         _fetchApps();
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('App deleted successfully')),
// //         );
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Failed to delete app')),
// //         );
// //       }
// //     }
// //   }
// //
// //   String _getOrgNames(dynamic app) {
// //     final orgs = app['organizations'];
// //     if (orgs is List && orgs.isNotEmpty) {
// //       return orgs.map((org) => org['name'] ?? 'Unnamed').join(', ');
// //     }
// //     return 'Unassigned';
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: _isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : Column(
// //         children: [
// //           SizedBox(height: MediaQuery.of(context).size.height * 0.08),
// //           // Padding(
// //           //   padding:
// //           //   const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //           //   child: Row(
// //           //     children: [
// //           //       GestureDetector(
// //           //         onTap: () {
// //           //           // TODO: Implement Add App logic
// //           //         },
// //           //         child: Container(
// //           //           padding: const EdgeInsets.symmetric(horizontal: 16),
// //           //           height: 40,
// //           //           decoration: BoxDecoration(
// //           //             color: Colors.teal.shade300,
// //           //             borderRadius: BorderRadius.circular(10),
// //           //           ),
// //           //           child: Row(
// //           //             children: [
// //           //               const Icon(Iconsax.add, color: Colors.white),
// //           //               const SizedBox(width: 8),
// //           //               Text(
// //           //                 "Add New",
// //           //                 style: GoogleFonts.poppins(
// //           //                   color: Colors.white,
// //           //                   fontWeight: FontWeight.w500,
// //           //                 ),
// //           //               ),
// //           //             ],
// //           //           ),
// //           //         ),
// //           //       ),
// //           //     ],
// //           //   ),
// //           // ),
// //           SizedBox(height: MediaQuery.of(context).size.height * 0.01),
// //           Container(
// //             height: MediaQuery.of(context).size.height * 0.07,
// //             width: double.infinity,
// //             decoration: const BoxDecoration(
// //               color: Colors.teal,
// //               borderRadius: BorderRadius.only(
// //                 bottomLeft: Radius.circular(15),
// //                 bottomRight: Radius.circular(15),
// //               ),
// //             ),
// //             padding: const EdgeInsets.symmetric(horizontal: 16),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   flex: 2,
// //                   child: Text("Name",
// //                       style: GoogleFonts.poppins(
// //                           fontWeight: FontWeight.w500,
// //                           fontSize: 16,
// //                           color: Colors.white)),
// //                 ),
// //                 Expanded(
// //                   flex: 3,
// //                   child: Text("Organizations",
// //                       style: GoogleFonts.poppins(
// //                           fontWeight: FontWeight.w500,
// //                           fontSize: 16,
// //                           color: Colors.white)),
// //                 ),
// //                 Expanded(
// //                   flex: 2,
// //                   child: Text("Created At",
// //                       style: GoogleFonts.poppins(
// //                           fontWeight: FontWeight.w500,
// //                           fontSize: 16,
// //                           color: Colors.white)),
// //                 ),
// //                 Expanded(
// //                   flex: 2,
// //                   child: Text("Delete",
// //                       style: GoogleFonts.poppins(
// //                           fontWeight: FontWeight.w500,
// //                           fontSize: 16,
// //                           color: Colors.white)),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: _apps.length,
// //               itemBuilder: (context, index) {
// //                 final app = _apps[index];
// //                 return Column(
// //                   children: [
// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(
// //                           vertical: 10, horizontal: 16),
// //                       child: Row(
// //                         children: [
// //                           Expanded(
// //                             flex: 2,
// //                             child: Text(
// //                               app['appName'] ?? 'Unnamed',
// //                               style: GoogleFonts.poppins(fontSize: 16),
// //                             ),
// //                           ),
// //                           Expanded(
// //                             flex: 3,
// //                             child: Text(
// //                               _getOrgNames(app),
// //                               style: GoogleFonts.poppins(fontSize: 16),
// //                             ),
// //                           ),
// //                           Expanded(
// //                             flex: 2,
// //                             child: Text(
// //                               app['createdAt']?.substring(0, 10) ?? '',
// //                               style: GoogleFonts.poppins(fontSize: 16),
// //                             ),
// //                           ),
// //                           Expanded(
// //                             flex: 2,
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.start,
// //                               children: [
// //                                 // GestureDetector(
// //                                 //   onTap: () {
// //                                 //     // TODO: Implement edit logic
// //                                 //   },
// //                                 //   child: Container(
// //                                 //     margin:
// //                                 //     const EdgeInsets.only(right: 10),
// //                                 //     height: MediaQuery.of(context)
// //                                 //         .size
// //                                 //         .height *
// //                                 //         .04,
// //                                 //     width: MediaQuery.of(context)
// //                                 //         .size
// //                                 //         .width *
// //                                 //         .06,
// //                                 //     decoration: BoxDecoration(
// //                                 //       borderRadius:
// //                                 //       BorderRadius.circular(10),
// //                                 //       color: Colors.orangeAccent,
// //                                 //     ),
// //                                 //     child: const Icon(Iconsax.edit,
// //                                 //         size: 20, color: Colors.white),
// //                                 //   ),
// //                                 // ),
// //                                 GestureDetector(
// //                                   onTap: () => _deleteApp(app['_id']),
// //                                   child: Container(
// //                                     height: MediaQuery.of(context)
// //                                         .size
// //                                         .height *
// //                                         .04,
// //                                     width: MediaQuery.of(context)
// //                                         .size
// //                                         .width *
// //                                         .06,
// //                                     decoration: BoxDecoration(
// //                                       borderRadius:
// //                                       BorderRadius.circular(10),
// //                                       color: Colors.redAccent,
// //                                     ),
// //                                     child: const Icon(Iconsax.trash,
// //                                         size: 20, color: Colors.white),
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     const Divider(
// //                       color: Colors.grey,
// //                       thickness: 0.2,
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// class _ApplicationPageState extends State<ApplicationPage> {
//   final AppService _appService = AppService();
//   List<dynamic> _apps = [];
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchApps();
//   }
//
//   Future<void> _fetchApps() async {
//     try {
//       final apps = await _appService.getApps();
//       if (!mounted) return; // ✅ Check mounted
//       setState(() {
//         _apps = apps;
//         _isLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return; // ✅ Check mounted
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Failed to load apps")));
//     }
//   }
//
//   Future<void> _deleteApp(String id) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Confirm Delete'),
//         content: const Text('Are you sure you want to delete this app?'),
//         actions: [
//           TextButton(
//             child: const Text('Cancel'),
//             onPressed: () => Navigator.pop(context, false),
//           ),
//           TextButton(
//             child: const Text('Delete'),
//             onPressed: () => Navigator.pop(context, true),
//           ),
//         ],
//       ),
//     );
//
//     if (confirmed != true) return;
//
//     final success = await _appService.deleteApp(id);
//     if (!mounted) return; // ✅ Check mounted before updating state
//     if (success) {
//       await _fetchApps(); // safe now
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('App deleted successfully')));
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Failed to delete app')));
//     }
//   }
//
//   String _getOrgNames(dynamic app) {
//     final orgs = app['organizations'];
//     if (orgs is List && orgs.isNotEmpty) {
//       return orgs.map((org) => org['name'] ?? 'Unnamed').join(', ');
//     }
//     return 'Unassigned';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: _isLoading
//           ? Center(
//               child: Lottie.network(
//                 'https://res.cloudinary.com/dggylwwqk/raw/upload/v1756722682/bass_loading_vottxs.json',
//                 height: 350,
//                 width: 350,
//                 options: LottieOptions(enableMergePaths: false),
//               ),
//             )
//           : Column(
//               children: [
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.08),
//                 // header row
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.07,
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     color: Colors.teal,
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(15),
//                       bottomRight: Radius.circular(15),
//                     ),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           "Name",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child: Text(
//                           "Organizations",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           "Created At",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           "Delete",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _apps.length,
//                     itemBuilder: (context, index) {
//                       final app = _apps[index];
//                       return Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 10,
//                               horizontal: 16,
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     app['appName'] ?? 'Unnamed',
//                                     style: GoogleFonts.poppins(fontSize: 16),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 3,
//                                   child: Text(
//                                     _getOrgNames(app),
//                                     style: GoogleFonts.poppins(fontSize: 16),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     app['createdAt']?.substring(0, 10) ?? '',
//                                     style: GoogleFonts.poppins(fontSize: 16),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 2,
//                                   child: GestureDetector(
//                                     onTap: () => _deleteApp(app['_id']),
//                                     child: Container(
//                                       height:
//                                           MediaQuery.of(context).size.height *
//                                           0.04,
//                                       width:
//                                           MediaQuery.of(context).size.width *
//                                           0.06,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: Colors.redAccent,
//                                       ),
//                                       child: const Icon(
//                                         Iconsax.trash,
//                                         size: 20,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const Divider(color: Colors.grey, thickness: 0.2),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import '../Controller/App_controller.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  final AppService _appService = AppService();
  List<dynamic> _apps = [];
  bool _isLoading = true;

  // Modern SaaS Color Palette
  final Color primaryBrand = const Color(0xFF0F172A); // Slate 900
  final Color accentAction = const Color(0xFF0D9488); // Teal 600
  final Color background = const Color(0xFFF8FAFC);   // Slate 50
  final Color slate200 = const Color(0xFFE2E8F0);
  final Color slate500 = const Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _fetchApps();
  }

  Future<void> _fetchApps() async {
    try {
      final apps = await _appService.getApps();
      if (!mounted) return;
      setState(() {
        _apps = apps;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnackBar("Failed to load applications", isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.plusJakartaSans()),
        backgroundColor: isError ? Colors.redAccent : accentAction,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _deleteApp(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Delete Application?', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
        content: Text('This will permanently remove the application and its configurations.', style: GoogleFonts.plusJakartaSans(color: slate500)),
        actions: [
          TextButton(
            child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: slate500, fontWeight: FontWeight.w600)),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Delete', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w700)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await _appService.deleteApp(id);
    if (!mounted) return;
    if (success) {
      await _fetchApps();
      _showSnackBar('Application removed successfully');
    } else {
      _showSnackBar('Failed to delete application', isError: true);
    }
  }

  String _getOrgNames(dynamic app) {
    final orgs = app['organizations'];
    if (orgs is List && orgs.isNotEmpty) {
      return orgs.map((org) => org['name'] ?? 'Unnamed').join(', ');
    }
    return 'Unassigned';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: _isLoading
          ? Center(
        child: Lottie.network(
          'https://res.cloudinary.com/dggylwwqk/raw/upload/v1756722682/bass_loading_vottxs.json',
          height: 250,
          width: 250,
        ),
      )
          : CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(),
          _buildTableHead(),
          _buildAppList(),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Applications",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: primaryBrand,
                  ),
                ),
                Text(
                  "Manage your connected digital ecosystems",
                  style: GoogleFonts.plusJakartaSans(color: slate500, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            // _buildAddNewButton(),
          ],
        ),
      ),
    );
  }

  // Widget _buildAddNewButton() {
  //   return ElevatedButton.icon(
  //     onPressed: () {}, // TODO: Implement Add Logic
  //     icon: const Icon(Iconsax.add, size: 18, color: Colors.white),
  //     label: Text("New App", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: Colors.white)),
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: accentAction,
  //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  //       elevation: 0,
  //     ),
  //   );
  // }

  Widget _buildTableHead() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: slate200.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            _tableLabel("App Name", flex: 3),
            _tableLabel("Organizations", flex: 4),
            _tableLabel("Date Created", flex: 2),
            _tableLabel("Action", flex: 1, align: TextAlign.right),
          ],
        ),
      ),
    );
  }

  Widget _tableLabel(String text, {int flex = 1, TextAlign align = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: Text(
        text.toUpperCase(),
        textAlign: align,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
          color: slate500,
        ),
      ),
    );
  }

  Widget _buildAppList() {
    if (_apps.isEmpty) {
      return SliverFillRemaining(
        child: Center(child: Text("No applications found", style: GoogleFonts.plusJakartaSans(color: slate500))),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final app = _apps[index];
            return _buildAppRow(app);
          },
          childCount: _apps.length,
        ),
      ),
    );
  }

  Widget _buildAppRow(dynamic app) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white), // Invisible border for spacing
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // App Name with Icon
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: accentAction.withOpacity(0.1),
                  child: Icon(Iconsax.mobile, size: 16, color: accentAction),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    app['appName'] ?? 'Unnamed',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: primaryBrand, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          // Organizations with Chips
          Expanded(
            flex: 4,
            child: Text(
              _getOrgNames(app),
              style: GoogleFonts.plusJakartaSans(color: slate500, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          // Created At
          Expanded(
            flex: 2,
            child: Text(
              app['createdAt']?.substring(0, 10) ?? '',
              style: GoogleFonts.plusJakartaSans(color: slate500, fontSize: 14),
            ),
          ),
          // Action Button
          Expanded(
            flex: 1,
            child: Align(
              alignment: AlignmentGeometry.centerRight,
              child: IconButton(
                onPressed: () => _deleteApp(app['_id']),
                icon: const Icon(Iconsax.trash, color: Colors.redAccent, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}