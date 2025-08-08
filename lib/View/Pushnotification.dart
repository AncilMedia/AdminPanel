// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import '../Controller/Organization_Controller.dart';
// import '../Controller/PushNotification_controller.dart';
// import '../Controller/User_controller.dart';
// import '../Model/User_Model.dart';
// import '../View_model/Authentication_state.dart';
//
// class PushNotification extends StatefulWidget {
//   const PushNotification({super.key});
//
//   @override
//   State<PushNotification> createState() => _PushNotificationState();
// }
//
// class _PushNotificationState extends State<PushNotification> {
//   final TextEditingController titleController = TextEditingController(text: 'Title');
//   final TextEditingController bodyController = TextEditingController(text: 'Body');
//   final TextEditingController eventController = TextEditingController(text: 'Event');
//   final TextEditingController typeController = TextEditingController(text: 'Type');
//
//   Color? selectedColor;
//   IconData? selectedIcon;
//   XFile? selectedImage;
//
//   String? selectedOrganization;
//   String? selectedIndividual;
//
//   bool isSending = false;
//   bool isLoading = true;
//
//   List<Map<String, dynamic>> organizations = [];
//   List<UserModel> users = [];
//
//   final List<IconData?> availableIcons = [
//     null,
//     Iconsax.notification_bing,
//     Iconsax.message,
//     Iconsax.menu_board,
//     Iconsax.calendar_remove,
//     Iconsax.warning_2,
//     Iconsax.tick_circle,
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   Future<void> _loadData() async {
//     setState(() => isLoading = true);
//     await _loadOrganizations();
//     await _fetchUsers();
//     setState(() => isLoading = false);
//   }
//
//   Future<void> _fetchUsers() async {
//     final authState = Provider.of<AuthState>(context, listen: false);
//     try {
//       final fetchedUsers = await UsergetController.fetchUsers(authState: authState);
//       for (var user in fetchedUsers) {
//         print('Fetched user: ${user.username}, ID: ${user.id}');
//       }
//       setState(() => users = fetchedUsers);
//     } catch (e) {
//       print("Error fetching users: $e");
//     }
//   }
//
//
//   Future<void> _loadOrganizations() async {
//     try {
//       final orgs = await OrganizationController.fetchOrganizations();
//       final uniqueOrgs = {
//         for (var org in orgs) org['_id']: org,
//       }.values.toList();
//
//       setState(() => organizations = uniqueOrgs);
//     } catch (e) {
//       print("Error loading organizations: $e");
//     }
//   }
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) setState(() => selectedImage = image);
//   }
//
//   String? _getSelectedOrgId() {
//     final org = organizations.firstWhere(
//           (element) => element['name'] == selectedOrganization,
//       orElse: () => {},
//     );
//     return org['_id'] as String?;
//   }
//
//   String? _getSelectedUserId() {
//     final user = users.firstWhere(
//           (element) => element.username == selectedIndividual,
//       orElse: () => UserModel(id: null),
//     );
//     return user.id;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     final isFormValid = titleController.text.isNotEmpty && bodyController.text.isNotEmpty;
//
//     return Scaffold(
//       appBar: AppBar(),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     children: [
//                       _buildFieldRow("Title", titleController, "Body", bodyController),
//                       const SizedBox(height: 12),
//                       _buildFieldRow("Event", eventController, "Type", typeController),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           Expanded(child: _buildColorPickerField()),
//                           const SizedBox(width: 16),
//                           Expanded(child: _buildIconPickerField()),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildDropdownField(
//                               label: "Organization",
//                               value: selectedOrganization,
//                               items: organizations.map((org) => org['name'] as String).toList(),
//                               onChanged: (value) => setState(() => selectedOrganization = value),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: _buildDropdownField(
//                               label: "Individual",
//                               value: selectedIndividual,
//                               items: users.map((user) => user.username ?? 'Unnamed').toList(),
//                               onChanged: (value) => setState(() => selectedIndividual = value),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   flex: 1,
//                   child: _buildImageBox(screenHeight),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             _buildSendButton(screenWidth, screenHeight, isFormValid),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFieldRow(String label1, TextEditingController controller1, String label2, TextEditingController controller2) {
//     return Row(
//       children: [
//         Expanded(child: _buildTextField(label1, controller1)),
//         const SizedBox(width: 16),
//         Expanded(child: _buildTextField(label2, controller2)),
//       ],
//     );
//   }
//
//   Widget _buildTextField(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14)),
//         const SizedBox(height: 4),
//         TextFormField(
//           controller: controller,
//           decoration: const InputDecoration(
//             contentPadding: EdgeInsets.symmetric(horizontal: 12),
//             border: OutlineInputBorder(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDropdownField({
//     required String label,
//     required String? value,
//     required List<String> items,
//     required void Function(String?) onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16)),
//         const SizedBox(height: 8),
//         DropdownButtonFormField<String>(
//           value: value,
//           isExpanded: true,
//           items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
//           onChanged: onChanged,
//           decoration: const InputDecoration(
//             contentPadding: EdgeInsets.symmetric(horizontal: 12),
//             border: OutlineInputBorder(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildColorPickerField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Color", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14)),
//         const SizedBox(height: 8),
//         InkWell(
//           onTap: _showColorPickerDialog,
//           child: Container(
//             height: 50,
//             decoration: BoxDecoration(
//               color: selectedColor ?? Colors.grey[200],
//               borderRadius: BorderRadius.circular(6),
//               border: Border.all(color: Colors.black26),
//             ),
//             child: selectedColor == null
//                 ? Center(child: Text("None", style: GoogleFonts.poppins(color: Colors.grey)))
//                 : null,
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _showColorPickerDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Pick a color"),
//         content: BlockPicker(
//           pickerColor: selectedColor ?? Colors.white,
//           onColorChanged: (color) => setState(() => selectedColor = color),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
//           TextButton(
//             onPressed: () {
//               setState(() => selectedColor = null);
//               Navigator.pop(context);
//             },
//             child: const Text("Clear"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildIconPickerField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Icon", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14)),
//         const SizedBox(height: 8),
//         InkWell(
//           onTap: _showIconPickerDialog,
//           child: Container(
//             height: 50,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(6),
//               border: Border.all(color: Colors.black26),
//             ),
//             child: selectedIcon == null
//                 ? Text("None", style: GoogleFonts.poppins(color: Colors.grey))
//                 : Icon(selectedIcon),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _showIconPickerDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Pick an icon"),
//         content: Wrap(
//           spacing: 12,
//           runSpacing: 12,
//           children: availableIcons.map((icon) {
//             return GestureDetector(
//               onTap: () {
//                 setState(() => selectedIcon = icon);
//                 Navigator.pop(context);
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: selectedIcon == icon ? Colors.blue : Colors.grey),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: icon == null
//                     ? Text("None", style: GoogleFonts.poppins(color: Colors.grey))
//                     : Icon(icon, size: 28),
//               ),
//             );
//           }).toList(),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildImageBox(double screenHeight) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Image", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16)),
//         const SizedBox(height: 8),
//         InkWell(
//           onTap: _pickImage,
//           child: Container(
//             height: screenHeight * 0.3,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               border: Border.all(color: Colors.black26),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             alignment: Alignment.center,
//             child: selectedImage != null
//                 ? ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.file(
//                 File(selectedImage!.path),
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: double.infinity,
//               ),
//             )
//                 : Text("Tap to pick image", style: GoogleFonts.poppins(color: Colors.grey)),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Widget _buildSendButton(double screenWidth, double screenHeight, bool isFormValid) {
//   //   return GestureDetector(
//   //     onTap: isSending || !isFormValid
//   //         ? null
//   //         : () async {
//   //       setState(() => isSending = true);
//   //       await Future.delayed(const Duration(seconds: 2));
//   //       print("Sending notification...");
//   //       setState(() {
//   //         isSending = false;
//   //         titleController.clear();
//   //         bodyController.clear();
//   //         eventController.clear();
//   //         typeController.clear();
//   //         selectedColor = null;
//   //         selectedIcon = null;
//   //         selectedImage = null;
//   //         selectedOrganization = null;
//   //         selectedIndividual = null;
//   //       });
//   //     },
//   //     child: Container(
//   //       height: screenHeight * 0.05,
//   //       width: screenWidth * 0.2,
//   //       decoration: BoxDecoration(
//   //         borderRadius: BorderRadius.circular(10),
//   //         color: isSending || !isFormValid ? Colors.grey : const Color(0xFF00CED1),
//   //       ),
//   //       child: Center(
//   //         child: isSending
//   //             ? Lottie.asset('assets/signin_button.json', fit: BoxFit.contain)
//   //             : Text(
//   //           "Send",
//   //           style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//   Widget _buildSendButton(double screenWidth, double screenHeight, bool isFormValid) {
//     return GestureDetector(
//       onTap: isSending || !isFormValid
//           ? null
//           : () async {
//         setState(() => isSending = true);
//         try {
//           await PushNotificationController.sendNotification(
//             title: titleController.text,
//             body: bodyController.text,
//             event: eventController.text,
//             type: typeController.text,
//             userId: _getSelectedUserId(),
//             organizationId: _getSelectedOrgId(),
//             color: selectedColor != null ? '#${selectedColor!.value.toRadixString(16).padLeft(8, '0')}' : null,
//             icon: selectedIcon != null ? selectedIcon!.codePoint.toString() : null,
//             imageFile: selectedImage != null ? File(selectedImage!.path) : null,
//           );
//
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Notification sent successfully')),
//           );
//
//           // Reset form
//           setState(() {
//             titleController.clear();
//             bodyController.clear();
//             eventController.clear();
//             typeController.clear();
//             selectedColor = null;
//             selectedIcon = null;
//             selectedImage = null;
//             selectedOrganization = null;
//             selectedIndividual = null;
//           });
//         } catch (e) {
//           print('Failed to send notification: $e');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error: $e')),
//           );
//         } finally {
//           setState(() => isSending = false);
//         }
//       },
//       child: Container(
//         height: screenHeight * 0.05,
//         width: screenWidth * 0.2,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: isSending || !isFormValid ? Colors.grey : const Color(0xFF00CED1),
//         ),
//         child: Center(
//           child: isSending
//               ? Lottie.asset('assets/signin_button.json', fit: BoxFit.contain)
//               : Text(
//             "Send",
//             style: GoogleFonts.poppins(
//               fontWeight: FontWeight.w500,
//               fontSize: 16,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
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
  final TextEditingController titleController = TextEditingController(text: 'Title');
  final TextEditingController bodyController = TextEditingController(text: 'Body');
  final TextEditingController eventController = TextEditingController(text: 'Event');
  final TextEditingController typeController = TextEditingController(text: 'Type');

  Color? selectedColor;
  IconData? selectedIcon;
  XFile? selectedImage;

  String? selectedOrganization;
  String? selectedIndividual;

  bool isSending = false;
  bool isLoading = true;

  List<Map<String, dynamic>> organizations = [];
  List<UserModel> users = [];

  final List<IconData?> availableIcons = [
    null,
    Iconsax.notification_bing,
    Iconsax.message,
    Iconsax.menu_board,
    Iconsax.calendar_remove,
    Iconsax.warning_2,
    Iconsax.tick_circle,
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    await _loadOrganizations();
    await _fetchUsers();
    setState(() => isLoading = false);
  }

  Future<void> _fetchUsers() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    try {
      final fetchedUsers = await UsergetController.fetchUsers(authState: authState);
      setState(() => users = fetchedUsers);
    } catch (e) {
      print("Error fetching users: $e");
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
      print("Error loading organizations: $e");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => selectedImage = image);
  }

  String? _getSelectedOrgId() {
    final org = organizations.firstWhere(
          (element) => element['name'] == selectedOrganization,
      orElse: () => {},
    );
    return org['_id'] as String?;
  }

  /// ✅ Cleaner with .empty() fallback
  String? _getSelectedUserId() {
    final user = users.firstWhere(
          (element) => element.username == selectedIndividual,
      orElse: () => UserModel.empty(),
    );
    return user.userId.isEmpty ? null : user.userId;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isFormValid = titleController.text.isNotEmpty && bodyController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text("Push Notification")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildFieldRow("Title", titleController, "Body", bodyController),
                      const SizedBox(height: 12),
                      _buildFieldRow("Event", eventController, "Type", typeController),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildColorPickerField()),
                          const SizedBox(width: 16),
                          Expanded(child: _buildIconPickerField()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              label: "Organization",
                              value: selectedOrganization,
                              items: organizations.map((org) => org['name'] as String).toList(),
                              onChanged: (value) => setState(() => selectedOrganization = value),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdownField(
                              label: "Individual",
                              value: selectedIndividual,
                              items: users
                                  .where((user) => user.username.isNotEmpty)
                                  .map((user) => user.username)
                                  .toList(),
                              onChanged: (value) => setState(() => selectedIndividual = value),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _buildImageBox(screenHeight),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSendButton(screenWidth, screenHeight, isFormValid),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldRow(String label1, TextEditingController controller1, String label2, TextEditingController controller2) {
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
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14)),
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
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildColorPickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showColorPickerDialog,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: selectedColor ?? Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black26),
            ),
            child: selectedColor == null
                ? Center(child: Text("None", style: GoogleFonts.poppins(color: Colors.grey)))
                : null,
          ),
        ),
      ],
    );
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pick a color"),
        content: BlockPicker(
          pickerColor: selectedColor ?? Colors.white,
          onColorChanged: (color) => setState(() => selectedColor = color),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
          TextButton(
            onPressed: () {
              setState(() => selectedColor = null);
              Navigator.pop(context);
            },
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }

  Widget _buildIconPickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Icon", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showIconPickerDialog,
          child: Container(
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black26),
            ),
            child: selectedIcon == null
                ? Text("None", style: GoogleFonts.poppins(color: Colors.grey))
                : Icon(selectedIcon),
          ),
        ),
      ],
    );
  }

  void _showIconPickerDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pick an icon"),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: availableIcons.map((icon) {
            return GestureDetector(
              onTap: () {
                setState(() => selectedIcon = icon);
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: selectedIcon == icon ? Colors.blue : Colors.grey),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: icon == null
                    ? Text("None", style: GoogleFonts.poppins(color: Colors.grey))
                    : Icon(icon, size: 28),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  Widget _buildImageBox(double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Image", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16)),
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
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(selectedImage!.path),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
                : Text("Tap to pick image", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  Widget _buildSendButton(double screenWidth, double screenHeight, bool isFormValid) {
    return // Inside your GestureDetector
      GestureDetector(
        onTap: isSending || !isFormValid
            ? null
            : () async {
          setState(() => isSending = true);
          try {
            final selectedUserId = _getSelectedUserId();
            print('📤 Sending push notification to userId: $selectedUserId');

            await PushNotificationController.sendNotification(
              title: titleController.text,
              body: bodyController.text,
              event: eventController.text,
              type: typeController.text,
              userId: selectedUserId,
              organizationId: _getSelectedOrgId(),
              color: selectedColor != null
                  ? '#${selectedColor!.value.toRadixString(16).padLeft(8, '0')}'
                  : null,
              icon: selectedIcon?.codePoint.toString(),
              imageFile:
              selectedImage != null ? File(selectedImage!.path) : null,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notification sent successfully')),
            );

            setState(() {
              titleController.clear();
              bodyController.clear();
              eventController.clear();
              typeController.clear();
              selectedColor = null;
              selectedIcon = null;
              selectedImage = null;
              selectedOrganization = null;
              selectedIndividual = null;
            });
          } catch (e) {
            print('Error : $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          } finally {
            setState(() => isSending = false); // Ensure button re-enables
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
                ? Lottie.asset('assets/signin_button.json', fit: BoxFit.contain)
                : Text(
              "Send",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
  }
}
