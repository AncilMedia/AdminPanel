// import 'dart:typed_data';
// import 'package:ancilmediaadminpanel/View/Login_page.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:iconsax/iconsax.dart';
// import '../Controller/Profile_controller.dart';
// import '../Services/api_client.dart';
// import '../Socket_Service.dart';
// import '../View_model/Authentication_state.dart';
//
// class Profile extends StatefulWidget {
//   const Profile({super.key});
//
//   @override
//   State<Profile> createState() => _ProfileState();
// }
//
// class _ProfileState extends State<Profile> {
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//
//   String? userId, role, createdAt, blockStatus;
//   String? profileImageUrl;
//   String? appName, packageName, organizationName;
//   XFile? selectedImage;
//   Uint8List? imageBytes;
//   bool isChanged = false;
//
//   bool isLoading = true;
//   bool isSaving = false;
//   bool isDeleting = false;
//   String? orgImage;
//
//   ProfileController? _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     setupSocketListeners();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (_controller == null) {
//       final apiClient = Provider.of<ApiClient>(context, listen: false);
//       _controller = ProfileController(apiClient);
//       loadProfile();
//     }
//   }
//
//   void setupSocketListeners() {
//     final socketService = SocketService();
//     socketService.on('profile_updated', (data) {
//       if (mounted) {
//         setState(() {
//           _usernameController.text = data['username'] ?? _usernameController.text;
//           profileImageUrl = data['image'] ?? profileImageUrl;
//           role = data['role'] ?? role;
//           if (data['organization'] != null) {
//             organizationName = data['organization']['name'] ?? organizationName;
//             orgImage = data['organization']['image'] ?? orgImage;
//           }
//           isChanged = false;
//         });
//       }
//     });
//   }
//
//   void loadProfile() async {
//     setState(() => isLoading = true);
//     final data = await _controller!.fetchProfile();
//     if (data != null) {
//       final user = data;
//       setState(() {
//         userId = user['userId'];
//         role = user['role'];
//         _usernameController.text = user['username'] ?? '';
//         _emailController.text = user['email'] ?? '';
//         _phoneController.text = user['phone'] ?? '';
//         profileImageUrl = user['image'];
//         createdAt = user['createdAt']?.toString().split("T").first;
//         blockStatus = user['blocked'] == true ? "Blocked" : "Active";
//         if (user['appId'] != null) {
//           appName = user['appId']['appName'];
//           packageName = user['appId']['packageName'];
//           if (user['appId']['organizations'] != null && user['appId']['organizations'].isNotEmpty) {
//             organizationName = user['appId']['organizations'][0]['name'];
//           }
//         }
//       });
//     }
//     setState(() => isLoading = false);
//   }
//
//   Future<void> pickImage() async {
//     final picker = ImagePicker();
//     final file = await picker.pickImage(source: ImageSource.gallery);
//     if (file != null) {
//       final bytes = await file.readAsBytes();
//       setState(() {
//         selectedImage = file;
//         imageBytes = bytes;
//         isChanged = true;
//       });
//     }
//   }
//
//   Future<void> saveProfile() async {
//     setState(() => isSaving = true);
//     try {
//       await _controller!.updateProfile(
//         username: _usernameController.text,
//         email: _emailController.text,
//         phone: _phoneController.text,
//         imageFile: selectedImage,
//       );
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated!"), backgroundColor: Colors.green));
//         setState(() {
//           isChanged = false;
//           selectedImage = null;
//           imageBytes = null;
//         });
//         loadProfile();
//       }
//     } catch (e) {
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
//     } finally {
//       if (mounted) setState(() => isSaving = false);
//     }
//   }
//
//   Future<void> deleteProfile() async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Delete Account'),
//         content: const Text('This action is permanent. Continue?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
//           ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
//         ],
//       ),
//     );
//
//     if (confirmed == true) {
//       setState(() => isDeleting = true);
//       final success = await _controller!.deleteProfile();
//       if (success && mounted) {
//         Provider.of<AuthState>(context, listen: false).logout();
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
//       }
//       if (mounted) setState(() => isDeleting = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading || isSaving || isDeleting) {
//       return Scaffold(
//         backgroundColor: const Color(0xFFF8F9FD),
//         body: Center(child: Lottie.network('https://res.cloudinary.com/dggylwwqk/raw/upload/v1756722682/profile_c67ivh.json', width: 300)),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FD),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("User Profile", style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade900)),
//             const SizedBox(height: 24),
//
//             _buildProfileHeader(),
//
//             const SizedBox(height: 24),
//
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: _glassCard(
//                     title: "Personal Information",
//                     icon: Iconsax.user_edit,
//                     child: Column(
//                       children: [
//                         _modernInput("Full Name", _usernameController, Iconsax.user),
//                         _modernInput("Email Address", _emailController, Iconsax.sms),
//                         _modernInput("Phone Number", _phoneController, Iconsax.call),
//                         const SizedBox(height: 16),
//                         if (isChanged)
//                           SizedBox(
//                             width: double.infinity,
//                             height: 55,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade400, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 0),
//                               onPressed: saveProfile,
//                               child: Text("Save Changes", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 24),
//                 Expanded(
//                   flex: 2,
//                   child: _glassCard(
//                     title: "Account Details",
//                     icon: Iconsax.info_circle,
//                     child: Column(
//                       children: [
//                         _statusRow("App Name", appName ?? "Not linked"),
//                         _statusRow("Organization", organizationName ?? "Not linked"),
//                         _statusRow("Block Status", blockStatus ?? "Active"),
//                         _statusRow("Created On", createdAt ?? ""),
//                         const SizedBox(height: 32),
//                         _buildDeleteButton(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileHeader() {
//     return Container(
//       padding: const EdgeInsets.all(32),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: [Colors.blue.shade800, Colors.blueAccent.shade400], begin: Alignment.topLeft, end: Alignment.bottomRight),
//         borderRadius: BorderRadius.circular(28),
//         boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 25, offset: const Offset(0, 10))],
//       ),
//       child: Row(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.5), width: 5)),
//                 child: CircleAvatar(
//                   radius: 55,
//                   backgroundColor: Colors.white,
//                   backgroundImage: imageBytes != null
//                       ? MemoryImage(imageBytes!)
//                       : (profileImageUrl != null && profileImageUrl!.isNotEmpty)
//                       ? NetworkImage(profileImageUrl!)
//                       : null as ImageProvider?,
//                   child: (imageBytes == null && (profileImageUrl == null || profileImageUrl!.isEmpty))
//                       ? Icon(Iconsax.user, size: 50, color: Colors.blue.shade800)
//                       : null,
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 right: 0,
//                 child: GestureDetector(
//                   onTap: pickImage,
//                   child: Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
//                     child: const Icon(Iconsax.camera, size: 20, color: Colors.blueAccent),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 32),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(_usernameController.text, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
//               const SizedBox(height: 4),
//               Text("User ID: $userId", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14, letterSpacing: 0.5)),
//               const SizedBox(height: 12),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                 decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(30)),
//                 child: Text(role?.toUpperCase() ?? "USER", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _glassCard({required String title, required IconData icon, required Widget child}) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)]),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(children: [Icon(icon, size: 22, color: Colors.blueAccent), const SizedBox(width: 12), Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18))]),
//           const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(height: 1, thickness: 1.2)),
//           child,
//         ],
//       ),
//     );
//   }
//
//   Widget _modernInput(String label, TextEditingController controller, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade600)),
//           const SizedBox(height: 10),
//           TextFormField(
//             controller: controller,
//             onChanged: (_) => setState(() => isChanged = true),
//             style: GoogleFonts.poppins(fontSize: 15),
//             decoration: InputDecoration(
//               prefixIcon: Icon(icon, size: 20, color: Colors.blueAccent),
//               filled: true,
//               fillColor: Colors.grey.shade50,
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
//               enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade100)),
//               focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _statusRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 14),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: GoogleFonts.poppins(fontSize: 14, color: Colors.blueGrey.shade400, fontWeight: FontWeight.w500)),
//           Text(value, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDeleteButton() {
//     return InkWell(
//       onTap: deleteProfile,
//       borderRadius: BorderRadius.circular(15),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.red.withOpacity(0.1))),
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Iconsax.trash, size: 20, color: Colors.red),
//               const SizedBox(width: 10),
//               Text("Delete Account", style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'dart:typed_data';
import 'package:ancilmediaadminpanel/View/Login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../Controller/Profile_controller.dart';
import '../Services/api_client.dart';
import '../Socket_Service.dart';
import '../View_model/Authentication_state.dart';

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
  String? appName, packageName, organizationName;
  XFile? selectedImage;
  Uint8List? imageBytes;
  bool isChanged = false;

  bool isLoading = true;
  bool isSaving = false;
  bool isDeleting = false;
  String? orgImage;

  ProfileController? _controller;

  @override
  void initState() {
    super.initState();
    setupSocketListeners();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      final apiClient = Provider.of<ApiClient>(context, listen: false);
      _controller = ProfileController(apiClient);
      loadProfile();
    }
  }

  // ... setupSocketListeners, loadProfile, pickImage, saveProfile, deleteProfile remain unchanged ...
  void setupSocketListeners() {
    final socketService = SocketService();
    socketService.on('profile_updated', (data) {
      if (mounted) {
        setState(() {
          _usernameController.text = data['username'] ?? _usernameController.text;
          profileImageUrl = data['image'] ?? profileImageUrl;
          role = data['role'] ?? role;
          if (data['organization'] != null) {
            organizationName = data['organization']['name'] ?? organizationName;
            orgImage = data['organization']['image'] ?? orgImage;
          }
          isChanged = false;
        });
      }
    });
  }

  void loadProfile() async {
    setState(() => isLoading = true);
    final data = await _controller!.fetchProfile();
    if (data != null) {
      final user = data;
      setState(() {
        userId = user['userId'];
        role = user['role'];
        _usernameController.text = user['username'] ?? '';
        _emailController.text = user['email'] ?? '';
        _phoneController.text = user['phone'] ?? '';
        profileImageUrl = user['image'];
        createdAt = user['createdAt']?.toString().split("T").first;
        blockStatus = user['blocked'] == true ? "Blocked" : "Active";
        if (user['appId'] != null) {
          appName = user['appId']['appName'];
          packageName = user['appId']['packageName'];
          if (user['appId']['organizations'] != null && user['appId']['organizations'].isNotEmpty) {
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated!"), backgroundColor: Colors.green));
        setState(() {
          isChanged = false;
          selectedImage = null;
          imageBytes = null;
        });
        loadProfile();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  Future<void> deleteProfile() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This action is permanent. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => isDeleting = true);
      final success = await _controller!.deleteProfile();
      if (success && mounted) {
        Provider.of<AuthState>(context, listen: false).logout();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
      }
      if (mounted) setState(() => isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || isSaving || isDeleting) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        body: Center(child: Lottie.network('https://res.cloudinary.com/dggylwwqk/raw/upload/v1756722682/profile_c67ivh.json', width: 300)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 800;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User Profile",
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 22 : 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
                const SizedBox(height: 24),

                // Responsive Header
                _buildProfileHeader(isMobile),

                const SizedBox(height: 24),

                // Responsive Body Grid
                if (isMobile) ...[
                  // Mobile View: Stacked
                  _buildPersonalCard(),
                  const SizedBox(height: 24),
                  _buildAccountDetailsCard(),
                ] else ...[
                  // Tablet/Desktop View: Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildPersonalCard()),
                      const SizedBox(width: 24),
                      Expanded(flex: 2, child: _buildAccountDetailsCard()),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blueAccent.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: isMobile
          ? Column(
        children: [
          _buildAvatarStack(),
          const SizedBox(height: 20),
          _buildHeaderText(isMobile),
        ],
      )
          : Row(
        children: [
          _buildAvatarStack(),
          const SizedBox(width: 32),
          _buildHeaderText(isMobile),
        ],
      ),
    );
  }

  Widget _buildAvatarStack() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 5),
          ),
          child: CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            backgroundImage: imageBytes != null
                ? MemoryImage(imageBytes!)
                : (profileImageUrl != null && profileImageUrl!.isNotEmpty)
                ? NetworkImage(profileImageUrl!)
                : null,
            child: (imageBytes == null && (profileImageUrl == null || profileImageUrl!.isEmpty))
                ? Icon(Iconsax.user, size: 50, color: Colors.blue.shade800)
                : null,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: pickImage,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: const Icon(Iconsax.camera, size: 20, color: Colors.blueAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderText(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          _usernameController.text,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 22 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "User ID: $userId",
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: isMobile ? 12 : 14,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            role?.toUpperCase() ?? "USER",
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalCard() {
    return _glassCard(
      title: "Personal Information",
      icon: Iconsax.user_edit,
      child: Column(
        children: [
          _modernInput("Full Name", _usernameController, Iconsax.user),
          _modernInput("Email Address", _emailController, Iconsax.sms),
          _modernInput("Phone Number", _phoneController, Iconsax.call),
          const SizedBox(height: 16),
          if (isChanged)
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade400,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                onPressed: saveProfile,
                child: Text(
                  "Save Changes",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAccountDetailsCard() {
    return _glassCard(
      title: "Account Details",
      icon: Iconsax.info_circle,
      child: Column(
        children: [
          _statusRow("App Name", appName ?? "Not linked"),
          _statusRow("Organization", organizationName ?? "Not linked"),
          _statusRow("Block Status", blockStatus ?? "Active"),
          _statusRow("Created On", createdAt ?? ""),
          const SizedBox(height: 32),
          _buildDeleteButton(),
        ],
      ),
    );
  }

  // ... Helper widgets (_glassCard, _modernInput, _statusRow, _buildDeleteButton) ...

  Widget _glassCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: Colors.blueAccent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, thickness: 1.2),
          ),
          child,
        ],
      ),
    );
  }

  Widget _modernInput(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            onChanged: (_) => setState(() => isChanged = true),
            style: GoogleFonts.poppins(fontSize: 15),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20, color: Colors.blueAccent),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade100)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.blueGrey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return InkWell(
      onTap: deleteProfile,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.red.withOpacity(0.1)),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.trash, size: 20, color: Colors.red),
              const SizedBox(width: 10),
              Text(
                "Delete Account",
                style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}