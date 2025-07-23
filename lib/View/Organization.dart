import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../View_model/organization_popup.dart';
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
  final columnFlex = [3, 2, 2, 2, 3];
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
      final uniqueOrgs = {
        for (var org in orgs) org['_id']: org,
      }.values.toList();

      setState(() {
        allOrganizations = uniqueOrgs;
        filteredOrganizations = [...uniqueOrgs];
        _searchController.clear();
        isLoading = false;
      });
    } catch (e) {
      print("Error loading organizations: $e");
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

  Future<void> _addNewOrganization({
    required String name,
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    final error = await OrganizationController.createOrganizationWithAdmin(
      name: name,
      username: username,
      email: email,
      password: password,
      phone: phone,
    );

    if (error == null) {
      await _loadOrganizations();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _updateOrganization({
    required String id,
    required String name,
    required String username,
    required String email,
    required String phone,
  }) async {
    final success = await OrganizationController.updateOrganizationDetails(
      id: id,
      name: name,
      username: username,
      email: email,
      phone: phone,
    );

    if (success) {
      await _loadOrganizations();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update organization')),
      );
    }
  }

  void _showOrganizationDialog({Map<String, dynamic>? org}) {
    final _orgNameController = TextEditingController(text: org?['name'] ?? '');
    final _usernameController = TextEditingController(text: org?['username'] ?? '');
    final _emailController = TextEditingController(text: org?['email'] ?? '');
    final _passwordController = TextEditingController();
    final _phoneController = TextEditingController(text: org?['phone'] ?? '');
    final _formKey = GlobalKey<FormState>();

    InputDecoration _inputDecoration(String label) => InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(org == null ? "Add New Organization" : "Edit Organization"),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _orgNameController,
                  decoration: _inputDecoration('Organization'),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _usernameController,
                  decoration: _inputDecoration('Username'),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration('Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final email = value?.trim();
                    if (email == null || email.isEmpty) return 'Required';
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(email)) return 'Invalid email';
                    return null;
                  },
                ),
                if (org == null) ...[
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _inputDecoration('Password'),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                  ),
                ],
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('Phone'),
                  validator: (value) {
                    final phone = value?.trim();
                    if (phone == null || phone.isEmpty) return 'Required';
                    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
                    if (!phoneRegex.hasMatch(phone)) return 'Invalid phone number';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                final name = _orgNameController.text.trim();
                final username = _usernameController.text.trim();
                final email = _emailController.text.trim();
                final password = _passwordController.text.trim();
                final phone = _phoneController.text.trim();

                Navigator.pop(ctx);
                if (org == null) {
                  await _addNewOrganization(
                    name: name,
                    username: username,
                    email: email,
                    password: password,
                    phone: phone,
                  );
                } else {
                  await _updateOrganization(
                    id: org['_id'],
                    name: name,
                    username: username,
                    email: email,
                    phone: phone,
                  );
                }
              }
            },
            child: Text(org == null ? "Add" : "Update"),
          ),
        ],
      ),
    );
  }

  Widget _headerItem(String title) => Center(
    child: Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _showOrganizationDialog(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.teal.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Iconsax.add, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          "Add New",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterOrganizations,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search by name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.teal.shade400,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(flex: columnFlex[0], child: _headerItem("Name")),
                Expanded(flex: columnFlex[1], child: _headerItem("Block Status")),
                Expanded(flex: columnFlex[1], child: _headerItem("Approval Status")),
                Expanded(flex: columnFlex[2], child: _headerItem("Actions")),
                Expanded(flex: columnFlex[2], child: _headerItem("Apps")),
                Expanded(flex: columnFlex[4], child: _headerItem("Created At")),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredOrganizations.isEmpty
                ? Center(
              child: Text(
                "No organizations found",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: filteredOrganizations.length,
              itemBuilder: (context, index) {
                final org = filteredOrganizations[index];
                return OrganizationRow(
                  organization: org,
                  onDelete: () async {
                    final success = await OrganizationController.deleteOrganization(org['_id']);
                    if (success) await _loadOrganizations();
                  },
                  onEdit: (org) => _showOrganizationDialog(org: org), // ✅ FIXED
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
