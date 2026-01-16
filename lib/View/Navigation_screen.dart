import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../environmental variables.dart';

class NavigationFormPage extends StatefulWidget {
  final Map<String, dynamic>? navData;

  const NavigationFormPage({Key? key, this.navData}) : super(key: key);

  @override
  State<NavigationFormPage> createState() => _NavigationFormPageState();
}

class _NavigationFormPageState extends State<NavigationFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController labelCtrl;
  late TextEditingController iconCtrl;
  late TextEditingController orderCtrl;

  String type = "home";
  bool isActive = true;
  bool loading = false;

  /// User role
  bool isAdmin = false;

  /// Selected organization
  String? selectedOrgId;

  /// Organizations list
  List<Map<String, dynamic>> organizations = [];

  /// Navigation items for selected org
  List<Map<String, dynamic>> assignedNavs = [];
  List<Map<String, dynamic>> unassignedNavs = [];

  final String orgApiUrl = "$baseUrl/api/organization";
  final String navApiUrl = "$baseUrl/api/navigation";

  @override
  void initState() {
    super.initState();
    checkUserRole(); // fetch role from SharedPreferences

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

  /// ================= CHECK USER ROLE =================
  Future<void> checkUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('userRole') ?? '';
    print("🛡️ Role Name: $role");

    setState(() {
      isAdmin = role.toLowerCase() == 'admin';
    });
  }

  /// ================= FETCH ORGANIZATIONS =================
  Future<void> fetchOrganizations() async {
    try {
      final response = await http.get(Uri.parse(orgApiUrl));
      print("Organization response: ${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List list = [];
        if (data is Map && data['organizations'] is List) {
          list = data['organizations'];
        } else if (data is List) {
          list = data;
        }

        setState(() {
          organizations = List<Map<String, dynamic>>.from(list);
        });
      }
    } catch (e) {
      debugPrint("Organization fetch error: $e");
    }
  }

  /// ================= FETCH NAVS FOR SELECTED ORG =================
  Future<void> fetchNavsForOrg() async {
    if (selectedOrgId == null) return;
    try {
      final url = isAdmin
          ? navApiUrl // Admin sees all navs
          : "$navApiUrl/org/$selectedOrgId"; // Non-admin sees only assigned
      final response = await http.get(Uri.parse(url));
      print("Navigation response: ${response.body}");

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
      debugPrint("Error fetching navs for org: $e");
    }
  }

  /// ================= TOGGLE NAV ASSIGNMENT =================
  Future<void> toggleNav(String navId) async {
    if (selectedOrgId == null) return;

    try {
      final res = await http.put(
        Uri.parse("$navApiUrl/select/$navId/$selectedOrgId"),
      );
      print("Toggle response: ${res.body}");

      if (res.statusCode == 200) {
        await fetchNavsForOrg(); // Refresh navs after toggle
      } else {
        showSnack("Toggle failed");
      }
    } catch (e) {
      showSnack("Error: $e");
    }
  }

  /// ================= SUBMIT =================
  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedOrgId == null) {
      showSnack("Please select organization");
      return;
    }

    setState(() => loading = true);

    final body = {
      "label": labelCtrl.text.trim(),
      "icon": iconCtrl.text.trim(),
      "type": type,
      "order": int.parse(orderCtrl.text),
      "organization": selectedOrgId,
      "isActive": isActive,
    };

    try {
      final res = widget.navData == null
          ? await http.post(
              Uri.parse(navApiUrl),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(body),
            )
          : await http.put(
              Uri.parse('$navApiUrl/${widget.navData!['_id']}'),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(body),
            );

      print("Submit response: ${res.body}");

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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.navData == null ? "Create Navigation" : "Edit Navigation",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: inputBox("Label", labelCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: inputBox("Icon", iconCtrl)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: inputBox("Order", orderCtrl, number: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: organizationDropdown()),
                      const SizedBox(width: 12),
                      Expanded(child: typeDropdown()),
                      const SizedBox(width: 12),
                      Expanded(child: activeSwitch()),
                    ],
                  ),
                  const SizedBox(height: 28),

                  Container(
                    height: MediaQuery.of(context).size.height * .0500,
                    width: MediaQuery.of(context).size.width * .1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.cyan,
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Center(
                            child: Text(
                              widget.navData == null ? "CREATE" : "UPDATE",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (selectedOrgId != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (assignedNavs.isNotEmpty) ...[
                    Text(
                      "Assigned Navigation Items",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  ...assignedNavs.map((nav) => navToggleTile(nav, true)),

                  if (isAdmin && unassignedNavs.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          "Not Assigned Navigation Items",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...unassignedNavs.map(
                          (nav) => navToggleTile(nav, false),
                        ),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget navToggleTile(Map<String, dynamic> nav, bool assigned) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(nav['label'] ?? ''),
        subtitle: Text(nav['type'] ?? ''),
        trailing: isAdmin
            ? Switch(
                value: assigned,
                onChanged: (_) => toggleNav(nav['_id'].toString()),
              )
            : Icon(
                assigned ? Icons.check_circle : Icons.remove_circle_outline,
                color: assigned ? Colors.green : Colors.grey,
              ),
      ),
    );
  }

  Widget inputBox(
    String title,
    TextEditingController controller, {
    bool number = false,
  }) {
    return cardWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label(title),
          TextFormField(
            controller: controller,
            keyboardType: number ? TextInputType.number : TextInputType.text,
            validator: (v) => v == null || v.isEmpty ? "Required" : null,
            decoration: fieldDecoration(),
          ),
        ],
      ),
    );
  }

  Widget organizationDropdown() {
    return cardWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label("Organization"),
          DropdownButtonFormField<String>(
            value:
                organizations.any((o) => o['_id'].toString() == selectedOrgId)
                ? selectedOrgId
                : null,
            isExpanded: true,
            items: organizations.map<DropdownMenuItem<String>>((org) {
              return DropdownMenuItem<String>(
                value: org['_id'].toString(),
                child: Text(org['name'].toString()),
              );
            }).toList(),
            onChanged: (val) async {
              setState(() => selectedOrgId = val);
              await fetchNavsForOrg();
            },
            validator: (v) => v == null ? "Required" : null,
            decoration: fieldDecoration(),
          ),
        ],
      ),
    );
  }

  Widget typeDropdown() {
    return cardWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label("Type"),
          DropdownButtonFormField<String>(
            value: type,
            items: const [
              DropdownMenuItem(value: "home", child: Text("Home")),
              DropdownMenuItem(value: "static", child: Text("Static")),
              DropdownMenuItem(value: "custom", child: Text("Custom")),
            ],
            onChanged: (v) => setState(() => type = v!),
            decoration: fieldDecoration(),
          ),
        ],
      ),
    );
  }

  Widget activeSwitch() {
    return cardWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label("Active"),
          Switch(
            value: isActive,
            onChanged: (v) => setState(() => isActive = v),
          ),
        ],
      ),
    );
  }

  Widget cardWrapper(Widget child) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  InputDecoration fieldDecoration() {
    return InputDecoration(
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    );
  }
}
