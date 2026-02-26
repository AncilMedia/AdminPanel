// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../environmental variables.dart';
//
// class NavigationFormPage extends StatefulWidget {
//   final Map<String, dynamic>? navData;
//
//   const NavigationFormPage({Key? key, this.navData}) : super(key: key);
//
//   @override
//   State<NavigationFormPage> createState() => _NavigationFormPageState();
// }
//
// class _NavigationFormPageState extends State<NavigationFormPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   late TextEditingController labelCtrl;
//   late TextEditingController iconCtrl;
//   late TextEditingController orderCtrl;
//
//   String type = "home";
//   bool isActive = true;
//   bool loading = false;
//
//   /// User role
//   bool isAdmin = false;
//
//   /// Selected organization
//   String? selectedOrgId;
//
//   /// Organizations list
//   List<Map<String, dynamic>> organizations = [];
//
//   /// Navigation items for selected org
//   List<Map<String, dynamic>> assignedNavs = [];
//   List<Map<String, dynamic>> unassignedNavs = [];
//
//   final String orgApiUrl = "$baseUrl/api/organization";
//   final String navApiUrl = "$baseUrl/api/navigation";
//
//   @override
//   void initState() {
//     super.initState();
//     checkUserRole(); // fetch role from SharedPreferences
//
//     labelCtrl = TextEditingController(text: widget.navData?['label'] ?? '');
//     iconCtrl = TextEditingController(text: widget.navData?['icon'] ?? '');
//     orderCtrl = TextEditingController(
//       text: widget.navData?['order']?.toString() ?? '0',
//     );
//
//     type = widget.navData?['type'] ?? 'home';
//     isActive = widget.navData?['isActive'] ?? true;
//
//     final org = widget.navData?['organization'];
//     if (org is String) {
//       selectedOrgId = org;
//     } else if (org is Map && org['_id'] != null) {
//       selectedOrgId = org['_id'].toString();
//     }
//
//     fetchOrganizations().then((_) {
//       if (selectedOrgId != null) fetchNavsForOrg();
//     });
//   }
//
//   /// ================= CHECK USER ROLE =================
//   Future<void> checkUserRole() async {
//     final prefs = await SharedPreferences.getInstance();
//     final role = prefs.getString('userRole') ?? '';
//     print("🛡️ Role Name: $role");
//
//     setState(() {
//       isAdmin = role.toLowerCase() == 'admin';
//     });
//   }
//
//   /// ================= FETCH ORGANIZATIONS =================
//   Future<void> fetchOrganizations() async {
//     try {
//       final response = await http.get(Uri.parse(orgApiUrl));
//       print("Organization response: ${response.body}");
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         List list = [];
//         if (data is Map && data['organizations'] is List) {
//           list = data['organizations'];
//         } else if (data is List) {
//           list = data;
//         }
//
//         setState(() {
//           organizations = List<Map<String, dynamic>>.from(list);
//         });
//       }
//     } catch (e) {
//       debugPrint("Organization fetch error: $e");
//     }
//   }
//
//   /// ================= FETCH NAVS FOR SELECTED ORG =================
//   Future<void> fetchNavsForOrg() async {
//     if (selectedOrgId == null) return;
//     try {
//       final url = isAdmin
//           ? navApiUrl // Admin sees all navs
//           : "$navApiUrl/org/$selectedOrgId"; // Non-admin sees only assigned
//       final response = await http.get(Uri.parse(url));
//       print("Navigation response: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         List allNavs = data['navItems'] ?? [];
//
//         setState(() {
//           assignedNavs = [];
//           unassignedNavs = [];
//
//           for (var nav in allNavs) {
//             final selectedByOrgs = List<String>.from(
//               (nav['selectedByOrganizations'] ?? []).map((e) => e.toString()),
//             );
//             if (selectedByOrgs.contains(selectedOrgId)) {
//               assignedNavs.add(Map<String, dynamic>.from(nav));
//             } else {
//               unassignedNavs.add(Map<String, dynamic>.from(nav));
//             }
//           }
//         });
//       }
//     } catch (e) {
//       debugPrint("Error fetching navs for org: $e");
//     }
//   }
//
//   /// ================= TOGGLE NAV ASSIGNMENT =================
//   Future<void> toggleNav(String navId) async {
//     if (selectedOrgId == null) return;
//
//     try {
//       final res = await http.put(
//         Uri.parse("$navApiUrl/select/$navId/$selectedOrgId"),
//       );
//       print("Toggle response: ${res.body}");
//
//       if (res.statusCode == 200) {
//         await fetchNavsForOrg(); // Refresh navs after toggle
//       } else {
//         showSnack("Toggle failed");
//       }
//     } catch (e) {
//       showSnack("Error: $e");
//     }
//   }
//
//   /// ================= SUBMIT =================
//   Future<void> submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (selectedOrgId == null) {
//       showSnack("Please select organization");
//       return;
//     }
//
//     setState(() => loading = true);
//
//     final body = {
//       "label": labelCtrl.text.trim(),
//       "icon": iconCtrl.text.trim(),
//       "type": type,
//       "order": int.parse(orderCtrl.text),
//       "organization": selectedOrgId,
//       "isActive": isActive,
//     };
//
//     try {
//       final res = widget.navData == null
//           ? await http.post(
//               Uri.parse(navApiUrl),
//               headers: {"Content-Type": "application/json"},
//               body: jsonEncode(body),
//             )
//           : await http.put(
//               Uri.parse('$navApiUrl/${widget.navData!['_id']}'),
//               headers: {"Content-Type": "application/json"},
//               body: jsonEncode(body),
//             );
//
//       print("Submit response: ${res.body}");
//
//       if (res.statusCode == 200 || res.statusCode == 201) {
//         Navigator.pop(context, true);
//       } else {
//         showSnack("Save failed");
//       }
//     } catch (e) {
//       showSnack("Error: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }
//
//   void showSnack(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.navData == null ? "Create Navigation" : "Edit Navigation",
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(child: inputBox("Label", labelCtrl)),
//                       const SizedBox(width: 12),
//                       Expanded(child: inputBox("Icon", iconCtrl)),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: inputBox("Order", orderCtrl, number: true),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(child: organizationDropdown()),
//                       const SizedBox(width: 12),
//                       Expanded(child: typeDropdown()),
//                       const SizedBox(width: 12),
//                       Expanded(child: activeSwitch()),
//                     ],
//                   ),
//                   const SizedBox(height: 28),
//
//                   Container(
//                     height: MediaQuery.of(context).size.height * .0500,
//                     width: MediaQuery.of(context).size.width * .1,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       color: Colors.cyan,
//                     ),
//                     child: loading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : Center(
//                             child: Text(
//                               widget.navData == null ? "CREATE" : "UPDATE",
//                               style: GoogleFonts.poppins(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             if (selectedOrgId != null)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (assignedNavs.isNotEmpty) ...[
//                     Text(
//                       "Assigned Navigation Items",
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                   ],
//                   ...assignedNavs.map((nav) => navToggleTile(nav, true)),
//
//                   if (isAdmin && unassignedNavs.isNotEmpty)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 16),
//                         Text(
//                           "Not Assigned Navigation Items",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         ...unassignedNavs.map(
//                           (nav) => navToggleTile(nav, false),
//                         ),
//                       ],
//                     ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget navToggleTile(Map<String, dynamic> nav, bool assigned) {
//     return Card(
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: ListTile(
//         title: Text(nav['label'] ?? ''),
//         subtitle: Text(nav['type'] ?? ''),
//         trailing: isAdmin
//             ? Switch(
//                 value: assigned,
//                 onChanged: (_) => toggleNav(nav['_id'].toString()),
//               )
//             : Icon(
//                 assigned ? Icons.check_circle : Icons.remove_circle_outline,
//                 color: assigned ? Colors.green : Colors.grey,
//               ),
//       ),
//     );
//   }
//
//   Widget inputBox(
//     String title,
//     TextEditingController controller, {
//     bool number = false,
//   }) {
//     return cardWrapper(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           label(title),
//           TextFormField(
//             controller: controller,
//             keyboardType: number ? TextInputType.number : TextInputType.text,
//             validator: (v) => v == null || v.isEmpty ? "Required" : null,
//             decoration: fieldDecoration(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget organizationDropdown() {
//     return cardWrapper(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           label("Organization"),
//           DropdownButtonFormField<String>(
//             value:
//                 organizations.any((o) => o['_id'].toString() == selectedOrgId)
//                 ? selectedOrgId
//                 : null,
//             isExpanded: true,
//             items: organizations.map<DropdownMenuItem<String>>((org) {
//               return DropdownMenuItem<String>(
//                 value: org['_id'].toString(),
//                 child: Text(org['name'].toString()),
//               );
//             }).toList(),
//             onChanged: (val) async {
//               setState(() => selectedOrgId = val);
//               await fetchNavsForOrg();
//             },
//             validator: (v) => v == null ? "Required" : null,
//             decoration: fieldDecoration(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget typeDropdown() {
//     return cardWrapper(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           label("Type"),
//           DropdownButtonFormField<String>(
//             value: type,
//             items: const [
//               DropdownMenuItem(value: "home", child: Text("Home")),
//               DropdownMenuItem(value: "static", child: Text("Static")),
//               DropdownMenuItem(value: "custom", child: Text("Custom")),
//             ],
//             onChanged: (v) => setState(() => type = v!),
//             decoration: fieldDecoration(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget activeSwitch() {
//     return cardWrapper(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           label("Active"),
//           Switch(
//             value: isActive,
//             onChanged: (v) => setState(() => isActive = v),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget cardWrapper(Widget child) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade300),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
//
//   Widget label(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
//
//   InputDecoration fieldDecoration() {
//     return InputDecoration(
//       isDense: true,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax/iconsax.dart';

import '../environmental variables.dart';

class NavigationFormPage extends StatefulWidget {
  final Map<String, dynamic>? navData;

  const NavigationFormPage({Key? key, this.navData}) : super(key: key);

  @override
  State<NavigationFormPage> createState() => _NavigationFormPageState();
}

class _NavigationFormPageState extends State<NavigationFormPage> {
  final _formKey = GlobalKey<FormState>();

  // High-End SaaS Color Palette
  final Color primaryIndigo = const Color(0xFF6366F1); // Indigo 500
  final Color slate900 = const Color(0xFF0F172A);      // Slate 900
  final Color slate50 = const Color(0xFFF8FAFC);       // Slate 50
  final Color slate200 = const Color(0xFFE2E8F0);      // Slate 200
  final Color slate500 = const Color(0xFF64748B);      // Slate 500

  late TextEditingController labelCtrl;
  late TextEditingController iconCtrl;
  late TextEditingController orderCtrl;

  String type = "home";
  bool isActive = true;
  bool loading = false;
  bool isAdmin = false;
  String? selectedOrgId;

  List<Map<String, dynamic>> organizations = [];
  List<Map<String, dynamic>> assignedNavs = [];
  List<Map<String, dynamic>> unassignedNavs = [];

  final String orgApiUrl = "$baseUrl/api/organization";
  final String navApiUrl = "$baseUrl/api/navigation";

  @override
  void initState() {
    super.initState();
    checkUserRole();

    labelCtrl = TextEditingController(text: widget.navData?['label'] ?? '');
    iconCtrl = TextEditingController(text: widget.navData?['icon'] ?? '');
    orderCtrl = TextEditingController(
      text: widget.navData?['order']?.toString() ?? '0',
    );

    type = widget.navData?['type'] ?? 'home';
    isActive = widget.navData?['isActive'] ?? true;

    final org = widget.navData?['organization'];
    if (org is String) {
      selectedOrgId = org;
    } else if (org is Map && org['_id'] != null) {
      selectedOrgId = org['_id'].toString();
    }

    fetchOrganizations().then((_) {
      if (selectedOrgId != null) fetchNavsForOrg();
    });
  }

  Future<void> checkUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('userRole') ?? '';
    setState(() => isAdmin = role.toLowerCase() == 'admin');
  }

  Future<void> fetchOrganizations() async {
    try {
      final response = await http.get(Uri.parse(orgApiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List list = (data is Map && data['organizations'] is List)
            ? data['organizations']
            : (data is List ? data : []);
        setState(() => organizations = List<Map<String, dynamic>>.from(list));
      }
    } catch (e) {
      debugPrint("Org Error: $e");
    }
  }

  Future<void> fetchNavsForOrg() async {
    if (selectedOrgId == null) return;
    try {
      final url = isAdmin ? navApiUrl : "$navApiUrl/org/$selectedOrgId";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List allNavs = data['navItems'] ?? [];
        setState(() {
          assignedNavs = [];
          unassignedNavs = [];
          for (var nav in allNavs) {
            final selectedByOrgs = List<String>.from(
              (nav['selectedByOrganizations'] ?? []).map((e) => e.toString()),
            );
            if (selectedByOrgs.contains(selectedOrgId)) {
              assignedNavs.add(Map<String, dynamic>.from(nav));
            } else {
              unassignedNavs.add(Map<String, dynamic>.from(nav));
            }
          }
        });
      }
    } catch (e) {
      debugPrint("Nav Error: $e");
    }
  }

  Future<void> toggleNav(String navId) async {
    if (selectedOrgId == null) return;
    try {
      final res = await http.put(Uri.parse("$navApiUrl/select/$navId/$selectedOrgId"));
      if (res.statusCode == 200) await fetchNavsForOrg();
    } catch (e) {
      showSnack("Toggle failed: $e");
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedOrgId == null) {
      showSnack("Please select an organization");
      return;
    }

    setState(() => loading = true);
    final body = {
      "label": labelCtrl.text.trim(),
      "icon": iconCtrl.text.trim(),
      "type": type,
      "order": int.tryParse(orderCtrl.text) ?? 0,
      "organization": selectedOrgId,
      "isActive": isActive,
    };

    try {
      final res = widget.navData == null
          ? await http.post(Uri.parse(navApiUrl),
          headers: {"Content-Type": "application/json"}, body: jsonEncode(body))
          : await http.put(Uri.parse('$navApiUrl/${widget.navData!['_id']}'),
          headers: {"Content-Type": "application/json"}, body: jsonEncode(body));

      if (res.statusCode == 200 || res.statusCode == 201) {
        Navigator.pop(context, true);
      } else {
        showSnack("Save failed");
      }
    } catch (e) {
      showSnack("Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.plusJakartaSans()),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: slate50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          widget.navData == null ? "Create Navigation" : "Update Item",
          style: GoogleFonts.plusJakartaSans(
              color: slate900, fontWeight: FontWeight.w800, fontSize: 18),
        ),
        iconTheme: IconThemeData(color: slate900),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Configuration Details"),
              const SizedBox(height: 12),
              _buildFormCard(),
              const SizedBox(height: 32),
              _buildSectionTitle("Organization Assignment"),
              const SizedBox(height: 12),
              _buildOrgDropdown(),
              if (selectedOrgId != null) ...[
                const SizedBox(height: 32),
                _buildNavList("Currently Assigned Items", assignedNavs, true),
                if (isAdmin && unassignedNavs.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  _buildNavList("Available to Assign", unassignedNavs, false),
                ],
              ],
              const SizedBox(height: 120), // Spacer for bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.plusJakartaSans(
          fontSize: 11, fontWeight: FontWeight.w800, color: slate500, letterSpacing: 1),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: slate200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          _buildTextField("Label Name", labelCtrl, Iconsax.text_block),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField("Icon Key", iconCtrl, Iconsax.category)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField("Sort Order", orderCtrl, Iconsax.sort, isNum: true)),
            ],
          ),
          const SizedBox(height: 16),
          _buildTypeSelector(),
          const Divider(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Set as Active",
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: slate900)),
              Switch.adaptive(
                activeColor: primaryIndigo,
                value: isActive,
                onChanged: (v) => setState(() => isActive = v),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, IconData icon, {bool isNum = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 12, fontWeight: FontWeight.w700, color: slate500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: isNum ? TextInputType.number : TextInputType.text,
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: primaryIndigo),
            filled: true,
            fillColor: slate50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Navigation Type",
            style: GoogleFonts.plusJakartaSans(
                fontSize: 12, fontWeight: FontWeight.w700, color: slate500)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: type,
          decoration: InputDecoration(
            filled: true,
            fillColor: slate50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          items: const [
            DropdownMenuItem(value: "home", child: Text("Home")),
            DropdownMenuItem(value: "static", child: Text("Static")),
            DropdownMenuItem(value: "custom", child: Text("Custom")),
          ],
          onChanged: (v) => setState(() => type = v!),
        ),
      ],
    );
  }

  Widget _buildOrgDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: slate200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: organizations.any((o) => o['_id'].toString() == selectedOrgId)
              ? selectedOrgId
              : null,
          isExpanded: true,
          hint: Text("Select Organization", style: GoogleFonts.plusJakartaSans()),
          items: organizations.map((org) {
            return DropdownMenuItem(
              value: org['_id'].toString(),
              child: Text(org['name'].toString(),
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
            );
          }).toList(),
          onChanged: (val) {
            setState(() => selectedOrgId = val);
            fetchNavsForOrg();
          },
        ),
      ),
    );
  }

  Widget _buildNavList(String title, List<Map<String, dynamic>> items, bool isAssigned) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 12),
        ...items.map((nav) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isAssigned ? primaryIndigo.withOpacity(0.2) : slate200),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isAssigned ? primaryIndigo.withOpacity(0.1) : slate50,
              child: Icon(Iconsax.link, color: isAssigned ? primaryIndigo : slate500, size: 18),
            ),
            title: Text(nav['label'] ?? '',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14)),
            subtitle: Text(nav['type'] ?? '',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: slate500)),
            trailing: isAdmin
                ? Switch.adaptive(
              activeColor: primaryIndigo,
              value: isAssigned,
              onChanged: (_) => toggleNav(nav['_id'].toString()),
            )
                : Icon(isAssigned ? Icons.check_circle : Icons.circle_outlined,
                color: isAssigned ? Colors.green : slate200),
          ),
        )),
      ],
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : () => submit(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyan,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(
          widget.navData == null ? "PROCEED TO CREATE" : "SAVE CONFIGURATION",
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1),
        ),
      ),
    );
  }
}