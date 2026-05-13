// // import 'package:flutter/material.dart';
// // import 'dart:ui'; // Required for ImageFilter (Glassmorphism)
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:intl/intl.dart';
// // import 'package:lottie/lottie.dart';
// // import '../Controller/App_controller.dart';
// // import '../View_model/Custom_snackbar.dart';
// // import '../controller/organization_controller.dart';
// //
// // class Organization extends StatefulWidget {
// //   const Organization({super.key});
// //
// //   @override
// //   State<Organization> createState() => _OrganizationState();
// // }
// //
// // class _OrganizationState extends State<Organization> {
// //   List<Map<String, dynamic>> allOrganizations = [];
// //   List<Map<String, dynamic>> filteredOrganizations = [];
// //   final TextEditingController _searchController = TextEditingController();
// //   bool isLoading = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadOrganizations();
// //   }
// //
// //   Future<void> _loadOrganizations() async {
// //     setState(() => isLoading = true);
// //     try {
// //       final orgs = await OrganizationController.fetchOrganizations();
// //       final uniqueOrgs = {for (var org in orgs) org['_id']: org}.values.toList();
// //       setState(() {
// //         allOrganizations = uniqueOrgs;
// //         filteredOrganizations = [...uniqueOrgs];
// //         _searchController.clear();
// //         isLoading = false;
// //       });
// //     } catch (e) {
// //       setState(() => isLoading = false);
// //     }
// //   }
// //
// //   void _filterOrganizations(String query) {
// //     setState(() {
// //       filteredOrganizations = allOrganizations
// //           .where((org) => org['name'].toLowerCase().contains(query.trim().toLowerCase()))
// //           .toList();
// //     });
// //   }
// //
// //   // --- REFINED SLEEK DIALOG ---
// //   void _showOrganizationDialog({Map<String, dynamic>? org}) {
// //     final nameCtrl = TextEditingController(text: org?['name'] ?? '');
// //     final userCtrl = TextEditingController(text: org?['username'] ?? '');
// //     final emailCtrl = TextEditingController(text: org?['email'] ?? '');
// //     final passCtrl = TextEditingController();
// //     final phoneCtrl = TextEditingController(text: org?['phone'] ?? '');
// //     final formKey = GlobalKey<FormState>();
// //
// //     showDialog(
// //       context: context,
// //       builder: (ctx) => BackdropFilter(
// //         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
// //         child: AlertDialog(
// //           backgroundColor: Colors.white.withOpacity(0.9),
// //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
// //           contentPadding: EdgeInsets.zero,
// //           content: SingleChildScrollView(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.all(25),
// //                   decoration: BoxDecoration(
// //                     gradient: LinearGradient(
// //                       colors: org == null
// //                           ? [Colors.teal.shade400, Colors.teal.shade700]
// //                           : [Colors.blue.shade400, Colors.blue.shade700],
// //                     ),
// //                     borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       Icon(org == null ? Iconsax.add_circle : Iconsax.edit, color: Colors.white),
// //                       const SizedBox(width: 15),
// //                       Text(org == null ? "Register New" : "Update Org",
// //                           style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
// //                     ],
// //                   ),
// //                 ),
// //                 Padding(
// //                   padding: const EdgeInsets.all(20),
// //                   child: Form(
// //                     key: formKey,
// //                     child: Column(
// //                       children: [
// //                         _buildGlassField(nameCtrl, "Organization Name", Iconsax.bank),
// //                         const SizedBox(height: 15),
// //                         _buildGlassField(userCtrl, "Admin Username", Iconsax.user_tag),
// //                         const SizedBox(height: 15),
// //                         _buildGlassField(emailCtrl, "Email", Iconsax.sms, type: TextInputType.emailAddress),
// //                         if (org == null) ...[
// //                           const SizedBox(height: 15),
// //                           _buildGlassField(passCtrl, "Password", Iconsax.lock, obscure: true),
// //                         ],
// //                         const SizedBox(height: 15),
// //                         _buildGlassField(phoneCtrl, "Phone Number", Iconsax.call, type: TextInputType.phone),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 Padding(
// //                   padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
// //                   child: Row(
// //                     children: [
// //                       Expanded(child: _dialogBtn("Cancel", Colors.grey, () => Navigator.pop(ctx))),
// //                       const SizedBox(width: 12),
// //                       Expanded(
// //                         child: _dialogBtn(
// //                           org == null ? "Create" : "Save",
// //                           org == null ? Colors.teal : Colors.blue,
// //                               () async {
// //                             if (formKey.currentState?.validate() ?? false) {
// //                               Navigator.pop(ctx);
// //                               if (org == null) {
// //                                 await OrganizationController.createOrganizationWithAdmin(
// //                                   name: nameCtrl.text.trim(),
// //                                   username: userCtrl.text.trim(),
// //                                   email: emailCtrl.text.trim(),
// //                                   password: passCtrl.text.trim(),
// //                                   phone: phoneCtrl.text.trim(),
// //                                 );
// //                               } else {
// //                                 await OrganizationController.updateOrganizationDetails(
// //                                   id: org['_id'],
// //                                   name: nameCtrl.text.trim(),
// //                                   username: userCtrl.text.trim(),
// //                                   email: emailCtrl.text.trim(),
// //                                   phone: phoneCtrl.text.trim(),
// //                                 );
// //                               }
// //                               _loadOrganizations();
// //                             }
// //                           },
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 )
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildGlassField(TextEditingController ctrl, String label, IconData icon, {bool obscure = false, TextInputType type = TextInputType.text}) {
// //     return TextFormField(
// //       controller: ctrl,
// //       obscureText: obscure,
// //       keyboardType: type,
// //       style: GoogleFonts.poppins(fontSize: 14),
// //       decoration: InputDecoration(
// //         labelText: label,
// //         prefixIcon: Icon(icon, size: 20, color: Colors.blueGrey),
// //         filled: true,
// //         fillColor: Colors.grey.withOpacity(0.05),
// //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
// //         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.teal, width: 1)),
// //       ),
// //       validator: (v) => v == null || v.isEmpty ? "Required" : null,
// //     );
// //   }
// //
// //   Widget _dialogBtn(String label, Color color, VoidCallback onTap) {
// //     return ElevatedButton(
// //       style: ElevatedButton.styleFrom(
// //         backgroundColor: color, elevation: 0,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //         padding: const EdgeInsets.symmetric(vertical: 12),
// //       ),
// //       onPressed: onTap,
// //       child: Text(label, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF0F4F8),
// //       extendBodyBehindAppBar: true,
// //       floatingActionButton: FloatingActionButton.extended(
// //         onPressed: () => _showOrganizationDialog(),
// //         backgroundColor: Colors.teal.shade700,
// //         elevation: 4,
// //         icon: const Icon(Iconsax.add, color: Colors.white),
// //         label: Text("Add Organization", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
// //       ),
// //       body: Stack(
// //         children: [
// //           // Background Gradient decoration
// //           Positioned(
// //             top: -100, right: -100,
// //             child: CircleAvatar(radius: 150, backgroundColor: Colors.teal.withOpacity(0.05)),
// //           ),
// //           Column(
// //             children: [
// //               _buildHeader(),
// //               Expanded(
// //                 child: isLoading
// //                     ? Center(child: Lottie.network('https://res.cloudinary.com/dggylwwqk/raw/upload/v1756722683/Organization_yqbizz.json', height: 250))
// //                     : ListView.builder(
// //                   padding: const EdgeInsets.all(16),
// //                   itemCount: filteredOrganizations.length,
// //                   itemBuilder: (ctx, i) {
// //                     // SLIDE ENTRANCE EFFECT
// //                     return TweenAnimationBuilder(
// //                       duration: Duration(milliseconds: 400 + (i * 100)),
// //                       tween: Tween<double>(begin: 0, end: 1),
// //                       builder: (context, double value, child) {
// //                         return Transform.translate(
// //                           offset: Offset(0, 50 * (1 - value)),
// //                           child: Opacity(opacity: value, child: child),
// //                         );
// //                       },
// //                       child: OrganizationCard(
// //                         org: filteredOrganizations[i],
// //                         onEdit: (o) => _showOrganizationDialog(org: o),
// //                         onRefresh: _loadOrganizations,
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildHeader() {
// //     return ClipRRect(
// //       child: BackdropFilter(
// //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
// //         child: Container(
// //           padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 25),
// //           decoration: BoxDecoration(
// //             color: Colors.white.withOpacity(0.8),
// //             borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.black.withOpacity(0.03),
// //                 blurRadius: 20,
// //                 offset: const Offset(0, 10),
// //               )
// //             ],
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text("SYSTEM PORTAL",
// //                           style: GoogleFonts.poppins(
// //                               fontSize: 12,
// //                               color: Colors.teal,
// //                               fontWeight: FontWeight.bold,
// //                               letterSpacing: 2
// //                           )
// //                       ),
// //                       Text("Organizations",
// //                           style: GoogleFonts.poppins(
// //                               fontSize: 30,
// //                               fontWeight: FontWeight.w800,
// //                               color: Colors.blueGrey.shade900
// //                           )
// //                       ),
// //                     ],
// //                   ),
// //                   const Icon(Iconsax.setting_5, color: Colors.blueGrey),
// //                 ],
// //               ),
// //               const SizedBox(height: 20),
// //               // FIXED: Added shadow via Container decoration, not InputDecoration
// //               Container(
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(20),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.black.withOpacity(0.05),
// //                       blurRadius: 10,
// //                       offset: const Offset(0, 5),
// //                     ),
// //                   ],
// //                 ),
// //                 child: TextField(
// //                   controller: _searchController,
// //                   onChanged: _filterOrganizations,
// //                   decoration: InputDecoration(
// //                     hintText: "Search records...",
// //                     prefixIcon: const Icon(Iconsax.search_normal_1, color: Colors.teal),
// //                     filled: true,
// //                     fillColor: Colors.white,
// //                     contentPadding: EdgeInsets.zero,
// //                     // Remove borders to let the container shadow shine
// //                     border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(20),
// //                         borderSide: BorderSide.none
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class OrganizationCard extends StatefulWidget {
// //   final Map<String, dynamic> org;
// //   final Function(Map<String, dynamic>) onEdit;
// //   final VoidCallback onRefresh;
// //
// //   const OrganizationCard({super.key, required this.org, required this.onEdit, required this.onRefresh});
// //
// //   @override
// //   State<OrganizationCard> createState() => _OrganizationCardState();
// // }
// //
// // class _OrganizationCardState extends State<OrganizationCard> {
// //   final AppService _appService = AppService();
// //   bool _isActionLoading = false;
// //   List<dynamic> _availableApps = [];
// //   Set<String> _assignedAppIds = {};
// //   bool _appsLoading = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _syncApps();
// //     _fetchApps();
// //   }
// //
// //   void _syncApps() {
// //     _assignedAppIds = {
// //       if (widget.org['apps'] != null)
// //         for (var app in widget.org['apps']) if (app['appId'] != null) app['appId']
// //     };
// //   }
// //
// //   Future<void> _fetchApps() async {
// //     try {
// //       final apps = await _appService.getApps();
// //       if (mounted) setState(() { _availableApps = apps; _appsLoading = false; });
// //     } catch (e) { if (mounted) setState(() => _appsLoading = false); }
// //   }
// //
// //   Future<void> _showAppSelectionDialog() async {
// //     // 1. Ensure data is fetching if list is empty
// //     if (_availableApps.isEmpty) {
// //       setState(() => _appsLoading = true);
// //       await _fetchApps();
// //     }
// //
// //     final double screenWidth = MediaQuery.of(context).size.width;
// //
// //     if (!mounted) return;
// //
// //     await showDialog(
// //       context: context,
// //       builder: (ctx) => BackdropFilter(
// //         filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
// //         child: StatefulBuilder(
// //           builder: (context, setModalState) {
// //             // 2. Added a helper to refresh local state if fetching completes late
// //             return AlertDialog(
// //               backgroundColor: Colors.white.withOpacity(0.9),
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
// //               titlePadding: EdgeInsets.zero,
// //               contentPadding: const EdgeInsets.symmetric(vertical: 20),
// //               title: Container(
// //                 padding: const EdgeInsets.all(25),
// //                 decoration: BoxDecoration(
// //                   gradient: LinearGradient(colors: [Colors.cyan.shade400, Colors.cyan.shade800]),
// //                   borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     const Icon(Iconsax.category_2, color: Colors.white),
// //                     const SizedBox(width: 15),
// //                     Text("App Subscriptions",
// //                         style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
// //                   ],
// //                 ),
// //               ),
// //               content: Container(
// //                 width: screenWidth * 0.9,
// //                 constraints: const BoxConstraints(maxWidth: 500, maxHeight: 450),
// //                 child: _appsLoading
// //                     ? Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     const SizedBox(height: 40),
// //                     const CircularProgressIndicator(color: Colors.teal),
// //                     const SizedBox(height: 20),
// //                     Text("Fetching latest apps...",
// //                         style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
// //                     const SizedBox(height: 40),
// //                   ],
// //                 )
// //                     : _availableApps.isEmpty
// //                     ? _buildEmptyAppsState() // Attractive empty state
// //                     : ListView.builder(
// //                   padding: const EdgeInsets.symmetric(horizontal: 15),
// //                   shrinkWrap: true,
// //                   itemCount: _availableApps.length,
// //                   itemBuilder: (context, index) {
// //                     final app = _availableApps[index];
// //                     final appId = app['appId'];
// //                     final isChecked = _assignedAppIds.contains(appId);
// //
// //                     return AnimatedContainer(
// //                       duration: const Duration(milliseconds: 300),
// //                       margin: const EdgeInsets.only(bottom: 12),
// //                       decoration: BoxDecoration(
// //                         color: isChecked ? Colors.teal.withOpacity(0.05) : Colors.white,
// //                         borderRadius: BorderRadius.circular(20),
// //                         border: Border.all(
// //                           color: isChecked ? Colors.teal.withOpacity(0.3) : Colors.grey.shade200,
// //                           width: 1.5,
// //                         ),
// //                         boxShadow: isChecked ? [
// //                           BoxShadow(color: Colors.teal.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
// //                         ] : [],
// //                       ),
// //                       child: ListTile(
// //                         contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
// //                         leading: Container(
// //                           width: 45, height: 45,
// //                           decoration: BoxDecoration(
// //                             gradient: isChecked
// //                                 ? LinearGradient(colors: [Colors.teal, Colors.teal.shade700])
// //                                 : LinearGradient(colors: [Colors.grey.shade200, Colors.grey.shade300]),
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: Center(
// //                             child: Text(
// //                               (app['appName'] ?? "A")[0].toUpperCase(),
// //                               style: TextStyle(
// //                                 color: isChecked ? Colors.white : Colors.blueGrey,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         title: Text(app['appName'] ?? "Application",
// //                             style: GoogleFonts.poppins(
// //                               fontSize: 15,
// //                               fontWeight: FontWeight.w600,
// //                               color: isChecked ? Colors.teal.shade900 : Colors.blueGrey.shade800,
// //                             )),
// //                         subtitle: Text("Access Level: Standard",
// //                             style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
// //                         trailing: Switch.adaptive(
// //                           activeColor: Colors.teal,
// //                           value: isChecked,
// //                           onChanged: (val) async {
// //                             // 3. UI Update (Immediate)
// //                             setModalState(() {
// //                               if (val) _assignedAppIds.add(appId);
// //                               else _assignedAppIds.remove(appId);
// //                             });
// //                             setState(() {
// //                               if (val) _assignedAppIds.add(appId);
// //                               else _assignedAppIds.remove(appId);
// //                             });
// //
// //                             // 4. API Call
// //                             bool success;
// //                             if (val) {
// //                               success = await OrganizationController.assignAppToOrganization(widget.org['_id'], appId);
// //                             } else {
// //                               success = await OrganizationController.unassignAppFromOrganization(widget.org['_id'], appId);
// //                             }
// //
// //                             if (!success) {
// //                               setModalState(() {
// //                                 if (val) _assignedAppIds.remove(appId);
// //                                 else _assignedAppIds.add(appId);
// //                               });
// //                               setState(() {
// //                                 if (val) _assignedAppIds.remove(appId);
// //                                 else _assignedAppIds.add(appId);
// //                               });
// //                               showCustomSnackBar(context, "Failed to update subscription", false);
// //                             }
// //                           },
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //               actions: [
// //                 Padding(
// //                   padding: const EdgeInsets.only(right: 15, bottom: 10),
// //                   child: TextButton(
// //                     style: TextButton.styleFrom(
// //                       backgroundColor: Colors.teal.shade50,
// //                       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
// //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //                     ),
// //                     onPressed: () => Navigator.pop(ctx),
// //                     child: Text("DONE",
// //                         style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.teal.shade800)),
// //                   ),
// //                 ),
// //               ],
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //
// // // 5. Helper for empty state UI
// //   Widget _buildEmptyAppsState() {
// //     return Column(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         const SizedBox(height: 20),
// //         Icon(Iconsax.info_circle, size: 50, color: Colors.grey.shade400),
// //         const SizedBox(height: 10),
// //         Text("No apps available", style: GoogleFonts.poppins(color: Colors.grey)),
// //         const SizedBox(height: 20),
// //       ],
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final bool? status = widget.org['approved'];
// //     final String name = widget.org['name'];
// //
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 18),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(28),
// //         boxShadow: [
// //           BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8)),
// //         ],
// //       ),
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(28),
// //         child: Column(
// //           children: [
// //             // Top Section with Gradient Accent
// //             Container(
// //               padding: const EdgeInsets.all(20.0),
// //               child: Row(
// //                 children: [
// //                   Container(
// //                     width: 55, height: 55,
// //                     decoration: BoxDecoration(
// //                       gradient: LinearGradient(colors: [Colors.cyan.shade300, Colors.cyan.shade600]),
// //                       borderRadius: BorderRadius.circular(18),
// //                     ),
// //                     child: Center(child: Text(name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22))),
// //                   ),
// //                   const SizedBox(width: 15),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.blueGrey.shade900)),
// //                         Text("Joined: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(widget.org['createdAt']))}", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
// //                       ],
// //                     ),
// //                   ),
// //                   _buildStatusBadge(status),
// //                 ],
// //               ),
// //             ),
// //             Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //               color: Colors.grey.shade50,
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       _actionIcon(Iconsax.edit, "Edit", Colors.blue, () => widget.onEdit(widget.org)),
// //                       _actionIcon(Iconsax.box, "Apps", Colors.orange, _showAppSelectionDialog),
// //                     ],
// //                   ),
// //                   status == null
// //                       ? Row(children: [
// //                     _approvalBtn(Iconsax.tick_circle, Colors.green, () => _handleApproval(true)),
// //                     const SizedBox(width: 8),
// //                     _approvalBtn(Iconsax.close_circle, Colors.red, () => _handleApproval(false)),
// //                   ])
// //                       : IconButton(onPressed: _confirmDelete, icon: const Icon(Iconsax.trash, color: Colors.redAccent, size: 22)),
// //                 ],
// //               ),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _actionIcon(IconData icon, String label, Color color, VoidCallback onTap) {
// //     return TextButton.icon(
// //       onPressed: onTap,
// //       icon: Icon(icon, size: 18, color: color),
// //       label: Text(label, style: GoogleFonts.poppins(fontSize: 13, color: color, fontWeight: FontWeight.w500)),
// //     );
// //   }
// //
// //   Widget _approvalBtn(IconData icon, Color color, VoidCallback onTap) {
// //     return InkWell(
// //       onTap: onTap,
// //       child: Container(
// //         padding: const EdgeInsets.all(8),
// //         decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
// //         child: Icon(icon, color: color, size: 22),
// //       ),
// //     );
// //   }
// //
// //   Future<void> _handleApproval(bool approve) async {
// //     await OrganizationController.approveOrganization(widget.org['_id'], approve);
// //     widget.onRefresh();
// //   }
// //
// //   Future<void> _confirmDelete() async {
// //     final confirmed = await showDialog<bool>(
// //       context: context,
// //       builder: (ctx) => AlertDialog(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
// //         title: Text("Delete Entry?", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
// //         content: const Text("This data will be permanently removed from our records."),
// //         actions: [
// //           TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("CANCEL")),
// //           ElevatedButton(
// //             style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
// //             onPressed: () => Navigator.pop(ctx, true),
// //             child: const Text("DELETE", style: TextStyle(color: Colors.white)),
// //           ),
// //         ],
// //       ),
// //     );
// //     if (confirmed == true) {
// //       await OrganizationController.deleteOrganization(widget.org['_id']);
// //       widget.onRefresh();
// //     }
// //   }
// //
// //   Widget _buildStatusBadge(bool? status) {
// //     Color color = status == true ? Colors.green : (status == false ? Colors.red : Colors.orange);
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: color.withOpacity(0.2)),
// //       ),
// //       child: Text(
// //         status == true ? "ACTIVE" : status == false ? "REJECTED" : "PENDING",
// //         style: GoogleFonts.poppins(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'dart:ui';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import '../Controller/App_controller.dart';
// import '../View_model/Custom_snackbar.dart';
// import '../controller/organization_controller.dart';
//
// class Organization extends StatefulWidget {
//   const Organization({super.key});
//
//   @override
//   State<Organization> createState() => _OrganizationState();
// }
//
// class _OrganizationState extends State<Organization> {
//   List<Map<String, dynamic>> allOrganizations = [];
//   List<Map<String, dynamic>> filteredOrganizations = [];
//   final TextEditingController _searchController = TextEditingController();
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadOrganizations();
//   }
//
//   Future<void> _loadOrganizations() async {
//     setState(() => isLoading = true);
//     try {
//       final orgs = await OrganizationController.fetchOrganizations();
//
//       // --- SORTING LOGIC: PENDING (null) ALWAYS AT TOP ---
//       orgs.sort((a, b) {
//         if (a['approved'] == null && b['approved'] != null) return -1;
//         if (a['approved'] != null && b['approved'] == null) return 1;
//         return 0;
//       });
//
//       final uniqueOrgs = {for (var org in orgs) org['_id']: org}.values.toList();
//
//       setState(() {
//         allOrganizations = uniqueOrgs;
//         filteredOrganizations = [...uniqueOrgs];
//         _searchController.clear();
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//     }
//   }
//
//   void _filterOrganizations(String query) {
//     setState(() {
//       filteredOrganizations = allOrganizations
//           .where((org) => org['name'].toLowerCase().contains(query.trim().toLowerCase()))
//           .toList();
//     });
//   }
//
//   void _showOrganizationDialog({Map<String, dynamic>? org}) {
//     final nameCtrl = TextEditingController(text: org?['name'] ?? '');
//     final userCtrl = TextEditingController(text: org?['username'] ?? '');
//     final emailCtrl = TextEditingController(text: org?['email'] ?? '');
//     final passCtrl = TextEditingController();
//     final phoneCtrl = TextEditingController(text: org?['phone'] ?? '');
//     final formKey = GlobalKey<FormState>();
//
//     showDialog(
//       context: context,
//       builder: (ctx) => BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//         child: AlertDialog(
//           backgroundColor: Colors.white.withOpacity(0.9),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//           contentPadding: EdgeInsets.zero,
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(25),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: org == null
//                           ? [Colors.teal.shade400, Colors.teal.shade700]
//                           : [Colors.blue.shade400, Colors.blue.shade700],
//                     ),
//                     borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(org == null ? Iconsax.add_circle : Iconsax.edit, color: Colors.white),
//                       const SizedBox(width: 15),
//                       Text(org == null ? "Register New" : "Update Org",
//                           style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Form(
//                     key: formKey,
//                     child: Column(
//                       children: [
//                         _buildGlassField(nameCtrl, "Organization Name", Iconsax.bank),
//                         const SizedBox(height: 15),
//                         _buildGlassField(userCtrl, "Admin Username", Iconsax.user_tag),
//                         const SizedBox(height: 15),
//                         _buildGlassField(emailCtrl, "Email", Iconsax.sms, type: TextInputType.emailAddress),
//                         if (org == null) ...[
//                           const SizedBox(height: 15),
//                           _buildGlassField(passCtrl, "Password", Iconsax.lock, obscure: true),
//                         ],
//                         const SizedBox(height: 15),
//                         _buildGlassField(phoneCtrl, "Phone Number", Iconsax.call, type: TextInputType.phone),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
//                   child: Row(
//                     children: [
//                       Expanded(child: _dialogBtn("Cancel", Colors.grey, () => Navigator.pop(ctx))),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _dialogBtn(
//                           org == null ? "Create" : "Save",
//                           org == null ? Colors.teal : Colors.blue,
//                               () async {
//                             if (formKey.currentState?.validate() ?? false) {
//                               Navigator.pop(ctx);
//                               if (org == null) {
//                                 await OrganizationController.createOrganizationWithAdmin(
//                                   name: nameCtrl.text.trim(),
//                                   username: userCtrl.text.trim(),
//                                   email: emailCtrl.text.trim(),
//                                   password: passCtrl.text.trim(),
//                                   phone: phoneCtrl.text.trim(),
//                                 );
//                               } else {
//                                 await OrganizationController.updateOrganizationDetails(
//                                   id: org['_id'],
//                                   name: nameCtrl.text.trim(),
//                                   username: userCtrl.text.trim(),
//                                   email: emailCtrl.text.trim(),
//                                   phone: phoneCtrl.text.trim(),
//                                 );
//                               }
//                               _loadOrganizations();
//                             }
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGlassField(TextEditingController ctrl, String label, IconData icon, {bool obscure = false, TextInputType type = TextInputType.text}) {
//     return TextFormField(
//       controller: ctrl,
//       obscureText: obscure,
//       keyboardType: type,
//       style: GoogleFonts.poppins(fontSize: 14),
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, size: 20, color: Colors.blueGrey),
//         filled: true,
//         fillColor: Colors.grey.withOpacity(0.05),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
//         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.teal, width: 1)),
//       ),
//       validator: (v) => v == null || v.isEmpty ? "Required" : null,
//     );
//   }
//
//   Widget _dialogBtn(String label, Color color, VoidCallback onTap) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color, elevation: 0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         padding: const EdgeInsets.symmetric(vertical: 12),
//       ),
//       onPressed: onTap,
//       child: Text(label, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F4F8),
//       extendBodyBehindAppBar: true,
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => _showOrganizationDialog(),
//         backgroundColor: Colors.teal.shade700,
//         elevation: 4,
//         icon: const Icon(Iconsax.add, color: Colors.white),
//         label: Text("Add Organization", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
//       ),
//       body: Stack(
//         children: [
//           Positioned(
//             top: -100, right: -100,
//             child: CircleAvatar(radius: 150, backgroundColor: Colors.teal.withOpacity(0.05)),
//           ),
//           Column(
//             children: [
//               _buildHeader(),
//               Expanded(
//                 child: isLoading
//                     ? Center(child: Lottie.network('https://res.cloudinary.com/dggylwwqk/raw/upload/v1756722683/Organization_yqbizz.json', height: 250))
//                     : ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: filteredOrganizations.length,
//                   itemBuilder: (ctx, i) {
//                     return TweenAnimationBuilder(
//                       duration: Duration(milliseconds: 400 + (i * 100)),
//                       tween: Tween<double>(begin: 0, end: 1),
//                       builder: (context, double value, child) {
//                         return Transform.translate(
//                           offset: Offset(0, 50 * (1 - value)),
//                           child: Opacity(opacity: value, child: child),
//                         );
//                       },
//                       child: OrganizationCard(
//                         org: filteredOrganizations[i],
//                         onEdit: (o) => _showOrganizationDialog(org: o),
//                         onRefresh: _loadOrganizations,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return ClipRRect(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 25),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.8),
//             borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.03),
//                 blurRadius: 20,
//                 offset: const Offset(0, 10),
//               )
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("SYSTEM PORTAL",
//                           style: GoogleFonts.poppins(
//                               fontSize: 12,
//                               color: Colors.teal,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: 2
//                           )
//                       ),
//                       Text("Organizations",
//                           style: GoogleFonts.poppins(
//                               fontSize: 30,
//                               fontWeight: FontWeight.w800,
//                               color: Colors.blueGrey.shade900
//                           )
//                       ),
//                     ],
//                   ),
//                   const Icon(Iconsax.setting_5, color: Colors.blueGrey),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: _searchController,
//                   onChanged: _filterOrganizations,
//                   decoration: InputDecoration(
//                     hintText: "Search records...",
//                     prefixIcon: const Icon(Iconsax.search_normal_1, color: Colors.teal),
//                     filled: true,
//                     fillColor: Colors.white,
//                     contentPadding: EdgeInsets.zero,
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide: BorderSide.none
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class OrganizationCard extends StatefulWidget {
//   final Map<String, dynamic> org;
//   final Function(Map<String, dynamic>) onEdit;
//   final VoidCallback onRefresh;
//
//   const OrganizationCard({super.key, required this.org, required this.onEdit, required this.onRefresh});
//
//   @override
//   State<OrganizationCard> createState() => _OrganizationCardState();
// }
//
// class _OrganizationCardState extends State<OrganizationCard> {
//   final AppService _appService = AppService();
//   bool _isActionLoading = false;
//   List<dynamic> _availableApps = [];
//   Set<String> _assignedAppIds = {};
//   bool _appsLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _syncApps();
//     _fetchApps();
//   }
//
//   void _syncApps() {
//     _assignedAppIds = {
//       if (widget.org['apps'] != null)
//         for (var app in widget.org['apps']) if (app['appId'] != null) app['appId']
//     };
//   }
//
//   Future<void> _fetchApps() async {
//     try {
//       final apps = await _appService.getApps();
//       if (mounted) {
//         setState(() {
//           _availableApps = apps;
//           _appsLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) setState(() => _appsLoading = false);
//     }
//   }
//
//   Future<void> _showAppSelectionDialog() async {
//     // Force a fetch if data is empty to prevent infinite loading
//     if (_availableApps.isEmpty) {
//       setState(() => _appsLoading = true);
//       await _fetchApps();
//     }
//
//     if (!mounted) return;
//     final double screenWidth = MediaQuery.of(context).size.width;
//
//     await showDialog(
//       context: context,
//       builder: (ctx) => BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//         child: StatefulBuilder(
//           builder: (context, setModalState) {
//             return AlertDialog(
//               backgroundColor: Colors.white.withOpacity(0.9),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//               titlePadding: EdgeInsets.zero,
//               contentPadding: const EdgeInsets.symmetric(vertical: 20),
//               title: Container(
//                 padding: const EdgeInsets.all(25),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(colors: [Colors.cyan.shade400, Colors.cyan.shade800]),
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Iconsax.category_2, color: Colors.white),
//                     const SizedBox(width: 15),
//                     Text("App Subscriptions",
//                         style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
//                   ],
//                 ),
//               ),
//               content: Container(
//                 width: screenWidth * 0.9,
//                 constraints: const BoxConstraints(maxWidth: 500, maxHeight: 450),
//                 child: _appsLoading
//                     ? Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const SizedBox(height: 40),
//                     const CircularProgressIndicator(color: Colors.teal),
//                     const SizedBox(height: 20),
//                     Text("Connecting to server...",
//                         style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
//                     const SizedBox(height: 40),
//                   ],
//                 )
//                     : ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   shrinkWrap: true,
//                   itemCount: _availableApps.length,
//                   itemBuilder: (context, index) {
//                     final app = _availableApps[index];
//                     final appId = app['appId'];
//                     final isChecked = _assignedAppIds.contains(appId);
//
//                     return AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       margin: const EdgeInsets.only(bottom: 12),
//                       decoration: BoxDecoration(
//                         color: isChecked ? Colors.teal.withOpacity(0.05) : Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                           color: isChecked ? Colors.teal.withOpacity(0.3) : Colors.grey.shade200,
//                           width: 1.5,
//                         ),
//                       ),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//                         leading: Container(
//                           width: 45, height: 45,
//                           decoration: BoxDecoration(
//                             gradient: isChecked
//                                 ? LinearGradient(colors: [Colors.teal, Colors.teal.shade700])
//                                 : LinearGradient(colors: [Colors.grey.shade200, Colors.grey.shade300]),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Center(
//                             child: Text(
//                               (app['appName'] ?? "A")[0].toUpperCase(),
//                               style: TextStyle(
//                                 color: isChecked ? Colors.white : Colors.blueGrey,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         title: Text(app['appName'] ?? "Application",
//                             style: GoogleFonts.poppins(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                               color: isChecked ? Colors.teal.shade900 : Colors.blueGrey.shade800,
//                             )),
//                         trailing: Switch.adaptive(
//                           activeColor: Colors.teal,
//                           value: isChecked,
//                           onChanged: (val) async {
//                             setModalState(() {
//                               if (val) _assignedAppIds.add(appId);
//                               else _assignedAppIds.remove(appId);
//                             });
//                             setState(() {
//                               if (val) _assignedAppIds.add(appId);
//                               else _assignedAppIds.remove(appId);
//                             });
//
//                             bool success = val
//                                 ? await OrganizationController.assignAppToOrganization(widget.org['_id'], appId)
//                                 : await OrganizationController.unassignAppFromOrganization(widget.org['_id'], appId);
//
//                             if (!success) {
//                               setModalState(() {
//                                 if (val) _assignedAppIds.remove(appId);
//                                 else _assignedAppIds.add(appId);
//                               });
//                               showCustomSnackBar(context, "Update failed", false);
//                             }
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 15, bottom: 10),
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.teal.shade50,
//                       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                     ),
//                     onPressed: () => Navigator.pop(ctx),
//                     child: Text("DONE",
//                         style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.teal.shade800)),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool? status = widget.org['approved'];
//     final String name = widget.org['name'];
//     final bool isPending = status == null;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(28),
//         border: isPending ? Border.all(color: Colors.orange.shade300, width: 1.5) : null,
//         boxShadow: [
//           BoxShadow(
//               color: isPending ? Colors.orange.withOpacity(0.08) : Colors.black.withOpacity(0.04),
//               blurRadius: 15,
//               offset: const Offset(0, 8)
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(28),
//         child: Stack(
//           children: [
//             if (isPending)
//               Positioned(
//                 top: 15, right: 15,
//                 child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
//               ),
//             Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 55, height: 55,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(colors: isPending ? [Colors.orange.shade300, Colors.orange.shade600] : [Colors.cyan.shade300, Colors.cyan.shade600]),
//                           borderRadius: BorderRadius.circular(18),
//                         ),
//                         child: Center(child: Text(name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22))),
//                       ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.blueGrey.shade900)),
//                             Text("Joined: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(widget.org['createdAt']))}", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
//                           ],
//                         ),
//                       ),
//                       _buildStatusBadge(status),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   color: isPending ? Colors.orange.withOpacity(0.03) : Colors.grey.shade50,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           _actionIcon(Iconsax.edit, "Edit", Colors.blue, () => widget.onEdit(widget.org)),
//                           _actionIcon(Iconsax.box, "Apps", Colors.orange, _showAppSelectionDialog),
//                         ],
//                       ),
//                       status == null
//                           ? Row(children: [
//                         _approvalBtn(Iconsax.tick_circle, Colors.green, () => _handleApproval(true)),
//                         const SizedBox(width: 8),
//                         _approvalBtn(Iconsax.close_circle, Colors.red, () => _handleApproval(false)),
//                       ])
//                           : IconButton(onPressed: _confirmDelete, icon: const Icon(Iconsax.trash, color: Colors.redAccent, size: 22)),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _actionIcon(IconData icon, String label, Color color, VoidCallback onTap) {
//     return TextButton.icon(
//       onPressed: onTap,
//       icon: Icon(icon, size: 18, color: color),
//       label: Text(label, style: GoogleFonts.poppins(fontSize: 13, color: color, fontWeight: FontWeight.w500)),
//     );
//   }
//
//   Widget _approvalBtn(IconData icon, Color color, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
//         child: Icon(icon, color: color, size: 22),
//       ),
//     );
//   }
//
//   Future<void> _handleApproval(bool approve) async {
//     await OrganizationController.approveOrganization(widget.org['_id'], approve);
//     widget.onRefresh();
//   }
//
//   Future<void> _confirmDelete() async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//         title: Text("Delete Entry?", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
//         content: const Text("This data will be permanently removed from our records."),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("CANCEL")),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
//             onPressed: () => Navigator.pop(ctx, true),
//             child: const Text("DELETE", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//     if (confirmed == true) {
//       await OrganizationController.deleteOrganization(widget.org['_id']);
//       widget.onRefresh();
//     }
//   }
//
//   Widget _buildStatusBadge(bool? status) {
//     Color color = status == true ? Colors.green : (status == false ? Colors.red : Colors.orange);
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.2)),
//       ),
//       child: Text(
//         status == true ? "ACTIVE" : status == false ? "REJECTED" : "PENDING",
//         style: GoogleFonts.poppins(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../Controller/App_controller.dart';
import '../View_model/Custom_snackbar.dart';
import '../controller/organization_controller.dart';

class Organization extends StatefulWidget {
  const Organization({super.key});

  @override
  State<Organization> createState() => _OrganizationState();
}

class _OrganizationState extends State<Organization> {
  List<Map<String, dynamic>> allOrganizations = [];
  List<Map<String, dynamic>> filteredOrganizations = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrganizations();
  }

  Future<void> _loadOrganizations() async {
    setState(() => isLoading = true);
    try {
      final orgs = await OrganizationController.fetchOrganizations();

      orgs.sort((a, b) {
        if (a['approved'] == null && b['approved'] != null) return -1;
        if (a['approved'] != null && b['approved'] == null) return 1;
        return 0;
      });

      final uniqueOrgs = {for (var org in orgs) org['_id']: org}.values.toList();

      setState(() {
        allOrganizations = uniqueOrgs;
        filteredOrganizations = [...uniqueOrgs];
        _searchController.clear();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _filterOrganizations(String query) {
    setState(() {
      filteredOrganizations = allOrganizations
          .where((org) => org['name'].toLowerCase().contains(query.trim().toLowerCase()))
          .toList();
    });
  }

  void _showOrganizationDialog({Map<String, dynamic>? org}) {
    final nameCtrl = TextEditingController(text: org?['name'] ?? '');
    final userCtrl = TextEditingController(text: org?['username'] ?? '');
    final emailCtrl = TextEditingController(text: org?['email'] ?? '');
    final passCtrl = TextEditingController();
    final phoneCtrl = TextEditingController(text: org?['phone'] ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        final double width = MediaQuery.of(ctx).size.width;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.symmetric(horizontal: width < 600 ? 15 : 40, vertical: 24),
            content: Container(
              width: 500, // Max width
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: org == null
                              ? [Colors.teal.shade400, Colors.teal.shade700]
                              : [Colors.blue.shade400, Colors.blue.shade700],
                        ),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: Row(
                        children: [
                          Icon(org == null ? Iconsax.add_circle : Iconsax.edit, color: Colors.white),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(org == null ? "Register New" : "Update Org",
                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            _buildGlassField(nameCtrl, "Organization Name", Iconsax.bank),
                            const SizedBox(height: 15),
                            _buildGlassField(userCtrl, "Admin Username", Iconsax.user_tag),
                            const SizedBox(height: 15),
                            _buildGlassField(emailCtrl, "Email", Iconsax.sms, type: TextInputType.emailAddress),
                            if (org == null) ...[
                              const SizedBox(height: 15),
                              _buildGlassField(passCtrl, "Password", Iconsax.lock, obscure: true),
                            ],
                            const SizedBox(height: 15),
                            _buildGlassField(phoneCtrl, "Phone Number", Iconsax.call, type: TextInputType.phone),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
                      child: Row(
                        children: [
                          Expanded(child: _dialogBtn("Cancel", Colors.grey, () => Navigator.pop(ctx))),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _dialogBtn(
                              org == null ? "Create" : "Save",
                              org == null ? Colors.teal : Colors.blue,
                                  () async {
                                if (formKey.currentState?.validate() ?? false) {
                                  Navigator.pop(ctx);
                                  if (org == null) {
                                    await OrganizationController.createOrganizationWithAdmin(
                                      name: nameCtrl.text.trim(),
                                      username: userCtrl.text.trim(),
                                      email: emailCtrl.text.trim(),
                                      password: passCtrl.text.trim(),
                                      phone: phoneCtrl.text.trim(),
                                    );
                                  } else {
                                    await OrganizationController.updateOrganizationDetails(
                                      id: org['_id'],
                                      name: nameCtrl.text.trim(),
                                      username: userCtrl.text.trim(),
                                      email: emailCtrl.text.trim(),
                                      phone: phoneCtrl.text.trim(),
                                    );
                                  }
                                  _loadOrganizations();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassField(TextEditingController ctrl, String label, IconData icon, {bool obscure = false, TextInputType type = TextInputType.text}) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      keyboardType: type,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: Colors.blueGrey),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.teal, width: 1)),
      ),
      validator: (v) => v == null || v.isEmpty ? "Required" : null,
    );
  }

  Widget _dialogBtn(String label, Color color, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color, elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: onTap,
      child: Text(label, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showOrganizationDialog(),
        backgroundColor: Colors.teal.shade700,
        elevation: 4,
        icon: const Icon(Iconsax.add, color: Colors.white),
        label: Text("Add Organization", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive Grid Logic
          int crossAxisCount = 1;
          if (constraints.maxWidth > 1200) {
            crossAxisCount = 3;
          } else if (constraints.maxWidth > 800) {
            crossAxisCount = 2;
          }

          return Stack(
            children: [
              Positioned(
                top: -100, right: -100,
                child: CircleAvatar(radius: 150, backgroundColor: Colors.teal.withOpacity(0.05)),
              ),
              Column(
                children: [
                  _buildHeader(constraints.maxWidth),
                  Expanded(
                    child: isLoading
                        ? Center(child: Lottie.network('https://res.cloudinary.com/dggylwwqk/raw/upload/v1756722683/Organization_yqbizz.json', height: 250))
                        : (crossAxisCount > 1)
                        ? GridView.builder(
                      padding: const EdgeInsets.all(24),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 0,
                        mainAxisExtent: 220, // Height fixed for grid alignment
                      ),
                      itemCount: filteredOrganizations.length,
                      itemBuilder: (ctx, i) => _buildAnimatedCard(i),
                    )
                        : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredOrganizations.length,
                      itemBuilder: (ctx, i) => _buildAnimatedCard(i),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedCard(int i) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (i * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: OrganizationCard(
        org: filteredOrganizations[i],
        onEdit: (o) => _showOrganizationDialog(org: o),
        onRefresh: _loadOrganizations,
      ),
    );
  }

  Widget _buildHeader(double width) {
    bool isSmall = width < 600;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 25),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("SYSTEM PORTAL",
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2
                          )
                      ),
                      Text("Organizations",
                          style: GoogleFonts.poppins(
                              fontSize: isSmall ? 24 : 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.blueGrey.shade900
                          )
                      ),
                    ],
                  ),
                  if (!isSmall) const Icon(Iconsax.setting_5, color: Colors.blueGrey),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterOrganizations,
                  decoration: InputDecoration(
                    hintText: "Search records...",
                    prefixIcon: const Icon(Iconsax.search_normal_1, color: Colors.teal),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrganizationCard extends StatefulWidget {
  final Map<String, dynamic> org;
  final Function(Map<String, dynamic>) onEdit;
  final VoidCallback onRefresh;

  const OrganizationCard({super.key, required this.org, required this.onEdit, required this.onRefresh});

  @override
  State<OrganizationCard> createState() => _OrganizationCardState();
}

class _OrganizationCardState extends State<OrganizationCard> {
  final AppService _appService = AppService();
  List<dynamic> _availableApps = [];
  Set<String> _assignedAppIds = {};
  bool _appsLoading = true;

  @override
  void initState() {
    super.initState();
    _syncApps();
    _fetchApps();
  }

  void _syncApps() {
    _assignedAppIds = {
      if (widget.org['apps'] != null)
        for (var app in widget.org['apps']) if (app['appId'] != null) app['appId']
    };
  }

  Future<void> _fetchApps() async {
    try {
      final apps = await _appService.getApps();
      if (mounted) {
        setState(() {
          _availableApps = apps;
          _appsLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _appsLoading = false);
    }
  }

  Future<void> _showAppSelectionDialog() async {
    if (_availableApps.isEmpty) {
      setState(() => _appsLoading = true);
      await _fetchApps();
    }

    if (!mounted) return;
    final double screenWidth = MediaQuery.of(context).size.width;

    await showDialog(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              title: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.cyan.shade400, Colors.cyan.shade800]),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Row(
                  children: [
                    const Icon(Iconsax.category_2, color: Colors.white),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text("App Subscriptions",
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
              ),
              content: Container(
                width: screenWidth * 0.9,
                constraints: const BoxConstraints(maxWidth: 500, maxHeight: 450),
                child: _appsLoading
                    ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    const CircularProgressIndicator(color: Colors.teal),
                    const SizedBox(height: 20),
                    Text("Connecting to server...",
                        style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 40),
                  ],
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  shrinkWrap: true,
                  itemCount: _availableApps.length,
                  itemBuilder: (context, index) {
                    final app = _availableApps[index];
                    final appId = app['appId'];
                    final isChecked = _assignedAppIds.contains(appId);

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isChecked ? Colors.teal.withOpacity(0.05) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isChecked ? Colors.teal.withOpacity(0.3) : Colors.grey.shade200,
                          width: 1.5,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        leading: Container(
                          width: 45, height: 45,
                          decoration: BoxDecoration(
                            gradient: isChecked
                                ? LinearGradient(colors: [Colors.teal, Colors.teal.shade700])
                                : LinearGradient(colors: [Colors.grey.shade200, Colors.grey.shade300]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              (app['appName'] ?? "A")[0].toUpperCase(),
                              style: TextStyle(
                                color: isChecked ? Colors.white : Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        title: Text(app['appName'] ?? "Application",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isChecked ? Colors.teal.shade900 : Colors.blueGrey.shade800,
                            )),
                        trailing: Transform.scale(
                          scale: 0.8,
                          child: Switch.adaptive(
                            activeColor: Colors.teal,
                            value: isChecked,
                            onChanged: (val) async {
                              setModalState(() {
                                if (val) _assignedAppIds.add(appId);
                                else _assignedAppIds.remove(appId);
                              });
                              setState(() {
                                if (val) _assignedAppIds.add(appId);
                                else _assignedAppIds.remove(appId);
                              });

                              bool success = val
                                  ? await OrganizationController.assignAppToOrganization(widget.org['_id'], appId)
                                  : await OrganizationController.unassignAppFromOrganization(widget.org['_id'], appId);

                              if (!success) {
                                setModalState(() {
                                  if (val) _assignedAppIds.remove(appId);
                                  else _assignedAppIds.add(appId);
                                });
                                showCustomSnackBar(context, "Update failed", false);
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15, bottom: 10),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.teal.shade50,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: Text("DONE",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.teal.shade800)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool? status = widget.org['approved'];
    final String name = widget.org['name'];
    final bool isPending = status == null;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: isPending ? Border.all(color: Colors.orange.shade300, width: 1.5) : null,
        boxShadow: [
          BoxShadow(
              color: isPending ? Colors.orange.withOpacity(0.08) : Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8)
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            if (isPending)
              Positioned(
                top: 15, right: 15,
                child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: isPending ? [Colors.orange.shade300, Colors.orange.shade600] : [Colors.cyan.shade300, Colors.cyan.shade600]),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(child: Text(name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey.shade900)),
                            Text("Joined: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(widget.org['createdAt']))}", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),
                      _buildStatusBadge(status),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: isPending ? Colors.orange.withOpacity(0.03) : Colors.grey.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Wrap(
                          children: [
                            _actionIcon(Iconsax.edit, "Edit", Colors.blue, () => widget.onEdit(widget.org)),
                            _actionIcon(Iconsax.box, "Apps", Colors.orange, _showAppSelectionDialog),
                          ],
                        ),
                      ),
                      status == null
                          ? Row(mainAxisSize: MainAxisSize.min, children: [
                        _approvalBtn(Iconsax.tick_circle, Colors.green, () => _handleApproval(true)),
                        const SizedBox(width: 8),
                        _approvalBtn(Iconsax.close_circle, Colors.red, () => _handleApproval(false)),
                      ])
                          : IconButton(padding: EdgeInsets.zero, constraints: BoxConstraints(), onPressed: _confirmDelete, icon: const Icon(Iconsax.trash, color: Colors.redAccent, size: 20)),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionIcon(IconData icon, String label, Color color, VoidCallback onTap) {
    return TextButton.icon(
      style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: color),
      label: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
    );
  }

  Widget _approvalBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Future<void> _handleApproval(bool approve) async {
    await OrganizationController.approveOrganization(widget.org['_id'], approve);
    widget.onRefresh();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text("Delete Entry?", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: const Text("This data will be permanently removed from our records."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("CANCEL")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("DELETE", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await OrganizationController.deleteOrganization(widget.org['_id']);
      widget.onRefresh();
    }
  }

  Widget _buildStatusBadge(bool? status) {
    Color color = status == true ? Colors.green : (status == false ? Colors.red : Colors.orange);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        status == true ? "ACTIVE" : status == false ? "REJECTED" : "PENDING",
        style: GoogleFonts.poppins(color: color, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }
}