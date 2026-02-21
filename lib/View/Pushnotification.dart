import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/Organization_Controller.dart';
import '../Controller/PushNotification_controller.dart';
import '../Controller/User_controller.dart';
import '../Model/User_Model.dart';
import '../View_model/Authentication_state.dart';

class PushNotification extends StatefulWidget {
  const PushNotification({super.key});

  @override
  State<PushNotification> createState() => _PushNotificationState();
}

class _PushNotificationState extends State<PushNotification> {
  final TextEditingController titleController = TextEditingController(text: 'New Update Available');
  final TextEditingController bodyController = TextEditingController(text: 'Check out the latest features in the app!');
  final TextEditingController eventController = TextEditingController(text: 'general_update');
  final TextEditingController typeController = TextEditingController(text: 'info');

  XFile? selectedImage;
  String? selectedOrganization;
  String? selectedIndividual;

  bool isSending = false;
  bool isLoading = true;
  bool isAdmin = false;

  List<Map<String, dynamic>> organizations = [];
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    await _loadUserRole();
    if (isAdmin) await _loadOrganizations();
    await _fetchUsers();
    setState(() => isLoading = false);
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('userRole');
    setState(() => isAdmin = role == 'admin');
  }

  Future<void> _fetchUsers() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    try {
      final fetchedUsers = await UsergetController.fetchUsers(authState: authState);
      setState(() => users = fetchedUsers);
    } catch (e) {
      debugPrint("Error fetching users: $e");
    }
  }

  Future<void> _loadOrganizations() async {
    try {
      final orgs = await OrganizationController.fetchOrganizations();
      setState(() => organizations = orgs);
    } catch (e) {
      debugPrint("Error loading organizations: $e");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => selectedImage = image);
  }

  String? _getSelectedOrgId() {
    if (!isAdmin || selectedOrganization == null) return null;
    final org = organizations.firstWhere((e) => e['name'] == selectedOrganization, orElse: () => {});
    return org['_id'] as String?;
  }

  String? _getSelectedUserId() {
    if (selectedIndividual == null || selectedIndividual == "All Users") return null;
    final user = users.firstWhere((e) => e.username == selectedIndividual, orElse: () => UserModel.empty());
    return user.userId.isNotEmpty ? user.userId : null;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        body: Center(
          child: Lottie.network(
              'https://res.cloudinary.com/dggylwwqk/raw/upload/v1756724306/New_Notification_Bell_krzyrx.json',
              height: 250),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Push Notifications", style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade900)),
            Text("Create and broadcast messages to your users", style: GoogleFonts.poppins(fontSize: 14, color: Colors.blueGrey.shade400)),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- COMPOSER PANEL ---
                Expanded(
                  flex: 3,
                  child: _glassCard(
                    child: Column(
                      children: [
                        _sectionHeader(Iconsax.edit, "Compose Notification"),
                        const SizedBox(height: 24),
                        _buildFieldRow("Title", titleController, "Message Body", bodyController, Iconsax.text, Iconsax.textalign_left),
                        const SizedBox(height: 16),
                        _buildFieldRow("Event Key", eventController, "Category Type", typeController, Iconsax.key, Iconsax.category),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            if (isAdmin)
                              Expanded(
                                child: _modernDropdown("Organization", selectedOrganization, organizations.map((e) => e['name'] as String).toList(), (v) => setState(() => selectedOrganization = v), Iconsax.hierarchy),
                              ),
                            if (isAdmin) const SizedBox(width: 16),
                            Expanded(
                              child: _modernDropdown("Individual User", selectedIndividual, ["All Users", ...users.where((u) => u.username.isNotEmpty).map((u) => u.username).toList()], (v) => setState(() => selectedIndividual = v), Iconsax.user),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        _buildSendButton(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),

                // --- PREVIEW PANEL ---
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _glassCard(
                        child: Column(
                          children: [
                            _sectionHeader(Iconsax.image, "Banner Image"),
                            const SizedBox(height: 16),
                            _buildImageBox(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildLivePreview(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: child,
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.cyan.shade700),
        const SizedBox(width: 10),
        Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey.shade800)),
      ],
    );
  }

  Widget _buildFieldRow(String l1, TextEditingController c1, String l2, TextEditingController c2, IconData i1, IconData i2) {
    return Row(
      children: [
        Expanded(child: _modernInput(l1, c1, i1)),
        const SizedBox(width: 16),
        Expanded(child: _modernInput(l2, c2, i2)),
      ],
    );
  }

  Widget _modernInput(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onChanged: (v) => setState(() {}),
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: Colors.cyan.shade700),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade100)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.cyan.shade700)),
          ),
        ),
      ],
    );
  }

  Widget _modernDropdown(String label, String? value, List<String> items, Function(String?) onChanged, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Iconsax.arrow_down_1, size: 16),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageBox() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.cyan.withOpacity(0.2))),
        child: selectedImage != null
            ? ClipRRect(borderRadius: BorderRadius.circular(15), child: kIsWeb ? Image.network(selectedImage!.path, fit: BoxFit.cover) : Image.file(File(selectedImage!.path), fit: BoxFit.cover))
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Iconsax.add_square, color: Colors.cyan, size: 30), const SizedBox(height: 8), Text("Add Image Banner", style: GoogleFonts.poppins(color: Colors.cyan, fontSize: 13))]),
      ),
    );
  }

  Widget _buildLivePreview() {
    return _glassCard(
      child: Column(
        children: [
          _sectionHeader(Iconsax.mobile, "Live App Preview"),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.grey.shade200)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.cyan.shade700, shape: BoxShape.circle), child: const Icon(Iconsax.notification, color: Colors.white, size: 18)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titleController.text.isEmpty ? "Notification Title" : titleController.text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(bodyController.text.isEmpty ? "Type a message body to see a preview..." : bodyController.text, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                      if (selectedImage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ClipRRect(borderRadius: BorderRadius.circular(8), child: SizedBox(height: 100, width: double.infinity, child: kIsWeb ? Image.network(selectedImage!.path, fit: BoxFit.cover) : Image.file(File(selectedImage!.path), fit: BoxFit.cover))),
                        ),
                    ],
                  ),
                ),
                Text("now", style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    bool isValid = titleController.text.isNotEmpty && bodyController.text.isNotEmpty;
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: isValid ? Colors.cyan.shade700 : Colors.grey.shade300, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 0),
        onPressed: isSending || !isValid ? null : _handleSend,
        child: isSending
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Iconsax.send_1, color: Colors.white, size: 20), const SizedBox(width: 10), Text("Dispatch Notification", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white))]),
      ),
    );
  }

  Future<void> _handleSend() async {
    setState(() => isSending = true);
    try {
      await PushNotificationController.sendNotification(
        title: titleController.text,
        body: bodyController.text,
        event: eventController.text,
        type: typeController.text,
        userId: _getSelectedUserId(),
        organizationId: _getSelectedOrgId(),
        imageFile: (!kIsWeb && selectedImage != null) ? File(selectedImage!.path) : null,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notification sent successfully!'), backgroundColor: Colors.green));
        setState(() {
          titleController.clear(); bodyController.clear(); eventController.clear(); typeController.clear();
          selectedImage = null; selectedOrganization = null; selectedIndividual = null;
        });
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => isSending = false);
    }
  }
}