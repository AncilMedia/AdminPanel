import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
  final TextEditingController titleController =
  TextEditingController(text: 'Title');
  final TextEditingController bodyController =
  TextEditingController(text: 'Body');
  final TextEditingController eventController =
  TextEditingController(text: 'Event');
  final TextEditingController typeController =
  TextEditingController(text: 'Type');

  Color? selectedColor;
  IconData? selectedIcon;
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

    if (isAdmin) {
      await _loadOrganizations();
    }

    await _fetchUsers();

    setState(() => isLoading = false);
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('userRole');

    setState(() {
      isAdmin = role == 'admin';
    });

    print("🔐 User Role: $role");
  }

  Future<void> _fetchUsers() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    try {
      final fetchedUsers =
      await UsergetController.fetchUsers(authState: authState);
      setState(() => users = fetchedUsers);
    } catch (e) {
      debugPrint("Error fetching users: $e");
    }
  }

  Future<void> _loadOrganizations() async {
    try {
      final orgs = await OrganizationController.fetchOrganizations();
      final uniqueOrgs = {
        for (var org in orgs) org['_id']: org,
      }.values.toList();

      setState(() => organizations = uniqueOrgs);
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

    final org = organizations.firstWhere(
          (e) => e['name'] == selectedOrganization,
      orElse: () => {},
    );

    return org['_id'] as String?;
  }

  String? _getSelectedUserId() {
    if (selectedIndividual == null ||
        selectedIndividual == "All Users") return null;

    final user = users.firstWhere(
          (e) => e.username == selectedIndividual,
      orElse: () => UserModel.empty(),
    );

    return user.userId.isNotEmpty ? user.userId : null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isFormValid =
        titleController.text.isNotEmpty && bodyController.text.isNotEmpty;

    return Scaffold(
      body: isLoading
          ? Center(
        child: Lottie.network(
            'https://res.cloudinary.com/dggylwwqk/raw/upload/v1756724306/New_Notification_Bell_krzyrx.json'),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildFieldRow("Title", titleController, "Body",
                          bodyController),
                      const SizedBox(height: 12),
                      _buildFieldRow("Event", eventController, "Type",
                          typeController),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          if (isAdmin)
                            Expanded(
                              child: _buildDropdownField(
                                label: "Organization",
                                value: selectedOrganization,
                                items: organizations
                                    .map((e) => e['name'] as String)
                                    .toList(),
                                onChanged: (v) => setState(
                                        () => selectedOrganization = v),
                              ),
                            ),
                          if (isAdmin) const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdownField(
                              label: "Individual",
                              value: selectedIndividual,
                              items: [
                                "All Users",
                                ...users
                                    .where((u) =>
                                u.username.isNotEmpty)
                                    .map((u) => u.username)
                                    .toList(),
                              ],
                              onChanged: (v) => setState(
                                      () => selectedIndividual = v),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(flex: 1, child: _buildImageBox(screenHeight)),
              ],
            ),
            const SizedBox(height: 24),
            _buildSendButton(
                screenWidth, screenHeight, isFormValid),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldRow(String label1,
      TextEditingController controller1, String label2,
      TextEditingController controller2) {
    return Row(
      children: [
        Expanded(child: _buildTextField(label1, controller1)),
        const SizedBox(width: 16),
        Expanded(child: _buildTextField(label2, controller2)),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500, fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          items: items
              .map((item) =>
              DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildImageBox(double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Image",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500, fontSize: 16)),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickImage,
          child: Container(
            height: screenHeight * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: selectedImage != null
                ? kIsWeb
                ? Image.network(selectedImage!.path,
                fit: BoxFit.cover)
                : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(File(selectedImage!.path),
                  fit: BoxFit.cover),
            )
                : Text("Tap to pick image",
                style: GoogleFonts.poppins(color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  Widget _buildSendButton(
      double screenWidth, double screenHeight, bool isFormValid) {
    return GestureDetector(
      onTap: isSending || !isFormValid
          ? null
          : () async {
        setState(() => isSending = true);
        try {
          await PushNotificationController.sendNotification(
            title: titleController.text,
            body: bodyController.text,
            event: eventController.text,
            type: typeController.text,
            userId: _getSelectedUserId(),
            organizationId: _getSelectedOrgId(),
            imageFile: (!kIsWeb && selectedImage != null)
                ? File(selectedImage!.path)
                : null,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Notification sent successfully')),
          );

          setState(() {
            titleController.clear();
            bodyController.clear();
            eventController.clear();
            typeController.clear();
            selectedImage = null;
            selectedOrganization = null;
            selectedIndividual = null;
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        } finally {
          setState(() => isSending = false);
        }
      },
      child: Container(
        height: screenHeight * 0.05,
        width: screenWidth * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSending || !isFormValid
              ? Colors.grey
              : const Color(0xFF00CED1),
        ),
        child: Center(
          child: isSending
              ? Lottie.asset('assets/signin_button.json')
              : Text("Send",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.white)),
        ),
      ),
    );
  }
}