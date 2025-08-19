import 'dart:typed_data';
import 'package:ancilmediaadminpanel/View/Login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../Controller/Profile_controller.dart';
import '../Services/api_client.dart';
import '../View_model/Authentication_state.dart';
import '../View_model/Custom_snackbar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String? userId, role, createdAt, blockStatus;
  String? profileImageUrl;
  String? appName, packageName, organizationName; // ✅ added
  XFile? selectedImage;
  Uint8List? imageBytes;
  bool isChanged = false;

  bool isLoading = true;
  bool isSaving = false;
  bool isDeleting = false;

  ProfileController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      final apiClient = Provider.of<ApiClient>(context, listen: false);
      _controller = ProfileController(apiClient);
      loadProfile();
    }
  }

  void loadProfile() async {
    setState(() => isLoading = true);
    final data = await _controller!.fetchProfile();
    if (data != null) {
      print('[🔄] Profile data: $data');
      final user = data;
      setState(() {
        userId = user['userId'];
        role = user['role'];
        _usernameController.text = user['username'] ?? '';
        _emailController.text = user['email'] ?? '';
        _phoneController.text = user['phone'] ?? '';
        profileImageUrl = user['image'];
        createdAt = user['createdAt']?.toString().split("T").first;
        blockStatus = user['blocked'] == true ? "True" : "False";
        // ✅ Extract appId details
        if (user['appId'] != null) {
          appName = user['appId']['appName'];
          packageName = user['appId']['packageName'];

          if (user['appId']['organizations'] != null &&
              user['appId']['organizations'].isNotEmpty) {
            organizationName = user['appId']['organizations'][0]['name'];
          }
        }
      });
    }
    setState(() => isLoading = false);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() {
        selectedImage = file;
        imageBytes = bytes;
        isChanged = true;
      });
    }
  }

  Future<void> saveProfile() async {
    setState(() => isSaving = true);
    try {
      await _controller!.updateProfile(
        username: _usernameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        imageFile: selectedImage,
      );
      showCustomSnackBar(context, "Profile updated successfully", true); // ✅ Use snackbar
      setState(() {
        isChanged = false;
        selectedImage = null;
        imageBytes = null;
      });
      loadProfile();
    } catch (e) {
      print('Update failed: $e');
      showCustomSnackBar(context, "Update failed: $e", false); // ✅ Use snackbar
    } finally {
      setState(() => isSaving = false);
    }
  }

  Future<void> deleteProfile() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Profile'),
        content: const Text('Are you sure you want to delete your profile?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => isDeleting = true);
      final success = await _controller!.deleteProfile();
      if (success) {
        final auth = Provider.of<AuthState>(context, listen: false);
        auth.logout();
        showCustomSnackBar(context, "Profile deleted successfully", true); // ✅ Snackbar
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginPage()));
      }
      setState(() => isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || isSaving || isDeleting) {
      return Scaffold(
        body: Center(
          child: Lottie.asset(
            'assets/Circular_moving_dot.json',
            width: 150,
            height: 150,
          ),
        ),
      );
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * .05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * .02),
                          child: Row(children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: pickImage,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: selectedImage != null
                                      ? MemoryImage(imageBytes!)
                                      : (profileImageUrl != null &&
                                      profileImageUrl!.isNotEmpty)
                                      ? NetworkImage(profileImageUrl!)
                                  as ImageProvider
                                      : null,
                                  child: selectedImage == null &&
                                      (profileImageUrl == null ||
                                          profileImageUrl!.isEmpty)
                                      ? const Icon(Icons.person, size: 60)
                                      : null,
                                ),
                              ),
                            ),
                            SizedBox(
                                width:
                                MediaQuery.of(context).size.width * .02),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ID: $userId",
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                    "Role: ${role != null && role!.isNotEmpty ? role![0].toUpperCase() + role!.substring(1) : ''}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 18, color: Colors.grey),
                                  ),
                                ])
                          ]),
                        ),
                        if (isChanged)
                          Padding(
                            padding: EdgeInsets.only(
                                right:
                                MediaQuery.of(context).size.width * .05),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              onPressed: saveProfile,
                              child: const Text("Save",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * .015,
                        vertical:
                        MediaQuery.of(context).size.height * .010,
                      ),
                      child: const Divider(
                          thickness: 1.5, color: Colors.black45),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * .5),
                            child: Column(
                              children: [
                                buildTextField(
                                    "Username", _usernameController),
                                buildTextField("Email", _emailController),
                                buildTextField("Phone", _phoneController),
                              ],
                            ),
                          ),
                          infoRow("App Name", appName ?? "Not linked"),
                          // infoRow("Package Name", packageName ?? "Not linked"),
                          infoRow("Organization",
                              organizationName ?? "Not linked"),
                          infoRow("Block status", blockStatus ?? ""),
                          infoRow("Account Created at", createdAt ?? ""),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: deleteProfile,
                          child: Container(
                            height:
                            MediaQuery.of(context).size.height * .0500,
                            width: MediaQuery.of(context).size.width * .7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text("Delete Profile",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        onChanged: (_) => setState(() => isChanged = true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Text("$label :  ",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 16)),
        Text(value,
            style: GoogleFonts.poppins(
                color: Colors.black45,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
