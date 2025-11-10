// // // import 'dart:io';
// // // import 'package:flutter/foundation.dart' show kIsWeb;
// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:image_picker/image_picker.dart';
// // //
// // // class SpeakerPage extends StatefulWidget {
// // //   const SpeakerPage({super.key});
// // //
// // //   @override
// // //   State<SpeakerPage> createState() => _SpeakerPageState();
// // // }
// // //
// // // class _SpeakerPageState extends State<SpeakerPage> {
// // //   final picker = ImagePicker();
// // //   XFile? _pickedFile; // works for both web & mobile
// // //
// // //   final _nameController = TextEditingController();
// // //   final _designationController = TextEditingController();
// // //   final _bioController = TextEditingController();
// // //
// // //   // 📸 Pick image from gallery or camera
// // //   Future<void> _pickImage() async {
// // //     final picked = await picker.pickImage(source: ImageSource.gallery);
// // //     if (picked != null) {
// // //       setState(() {
// // //         _pickedFile = picked;
// // //       });
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(
// // //           "Add Speaker",
// // //           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
// // //         ),
// // //         backgroundColor: Colors.white,
// // //         foregroundColor: Colors.black,
// // //         elevation: 0,
// // //       ),
// // //       body: SafeArea(
// // //         child: SingleChildScrollView(
// // //           padding: const EdgeInsets.all(16.0),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               // Name
// // //               Text(
// // //                 "Name",
// // //                 style: GoogleFonts.poppins(
// // //                     fontSize: 16, fontWeight: FontWeight.w500),
// // //               ),
// // //               const SizedBox(height: 8),
// // //               TextFormField(
// // //                 controller: _nameController,
// // //                 decoration: InputDecoration(
// // //                   hintText: "Enter speaker name",
// // //                   border: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(10),
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 16),
// // //
// // //               // Image Picker
// // //               Text(
// // //                 "Profile Picture",
// // //                 style: GoogleFonts.poppins(
// // //                     fontSize: 16, fontWeight: FontWeight.w500),
// // //               ),
// // //               const SizedBox(height: 8),
// // //               GestureDetector(
// // //                 onTap: _pickImage,
// // //                 child: Container(
// // //                   height: MediaQuery.of(context).size.height * 0.25,
// // //                   width: double.infinity,
// // //                   decoration: BoxDecoration(
// // //                     borderRadius: BorderRadius.circular(12),
// // //                     border: Border.all(color: Colors.grey.shade400),
// // //                     color: Colors.grey.shade100,
// // //                   ),
// // //                   child: _pickedFile != null
// // //                       ? ClipRRect(
// // //                     borderRadius: BorderRadius.circular(12),
// // //                     child: kIsWeb
// // //                         ? Image.network(
// // //                       _pickedFile!.path,
// // //                       fit: BoxFit.cover,
// // //                       width: double.infinity,
// // //                     )
// // //                         : Image.file(
// // //                       File(_pickedFile!.path),
// // //                       fit: BoxFit.cover,
// // //                       width: double.infinity,
// // //                     ),
// // //                   )
// // //                       : Center(
// // //                     child: Column(
// // //                       mainAxisSize: MainAxisSize.min,
// // //                       children: [
// // //                         const Icon(Icons.add_a_photo,
// // //                             color: Colors.grey, size: 40),
// // //                         const SizedBox(height: 8),
// // //                         Text(
// // //                           "Tap to select image",
// // //                           style: GoogleFonts.poppins(
// // //                             color: Colors.grey,
// // //                             fontSize: 14,
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 16),
// // //
// // //               // Designation
// // //               Text(
// // //                 "Designation",
// // //                 style: GoogleFonts.poppins(
// // //                     fontSize: 16, fontWeight: FontWeight.w500),
// // //               ),
// // //               const SizedBox(height: 8),
// // //               TextFormField(
// // //                 controller: _designationController,
// // //                 decoration: InputDecoration(
// // //                   hintText: "Enter designation (e.g., Pastor, Speaker)",
// // //                   border: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(10),
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 16),
// // //
// // //               // Bio
// // //               Text(
// // //                 "Bio",
// // //                 style: GoogleFonts.poppins(
// // //                     fontSize: 16, fontWeight: FontWeight.w500),
// // //               ),
// // //               const SizedBox(height: 8),
// // //               TextFormField(
// // //                 controller: _bioController,
// // //                 maxLines: 4,
// // //                 decoration: InputDecoration(
// // //                   hintText: "Enter a short biography",
// // //                   border: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(10),
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 24),
// // //
// // //               // Save Button
// // //               Center(
// // //                 child: ElevatedButton(
// // //                   style: ElevatedButton.styleFrom(
// // //                     padding: const EdgeInsets.symmetric(
// // //                         horizontal: 32, vertical: 12),
// // //                     shape: RoundedRectangleBorder(
// // //                       borderRadius: BorderRadius.circular(10),
// // //                     ),
// // //                   ),
// // //                   onPressed: () {
// // //                     debugPrint("Name: ${_nameController.text}");
// // //                     debugPrint("Designation: ${_designationController.text}");
// // //                     debugPrint("Bio: ${_bioController.text}");
// // //                     debugPrint("Picked File: ${_pickedFile?.path}");
// // //                   },
// // //                   child: Text(
// // //                     "Save Speaker",
// // //                     style: GoogleFonts.poppins(
// // //                         fontSize: 16, fontWeight: FontWeight.w600),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// // import 'dart:io';
// // import 'package:flutter/foundation.dart' show kIsWeb;
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:image_picker/image_picker.dart';
// //
// // import '../Controller/Speaker_controller.dart';
// //
// // class SpeakerPage extends StatefulWidget {
// //   const SpeakerPage({super.key});
// //
// //   @override
// //   State<SpeakerPage> createState() => _SpeakerPageState();
// // }
// //
// // class _SpeakerPageState extends State<SpeakerPage> {
// //   final picker = ImagePicker();
// //   XFile? _pickedFile; // works for both web & mobile
// //   final _nameController = TextEditingController();
// //   final _designationController = TextEditingController();
// //   final _bioController = TextEditingController();
// //
// //   final _formKey = GlobalKey<FormState>();
// //   bool _isLoading = false;
// //
// //   final MediaSpeakerController _speakerController = MediaSpeakerController();
// //
// //   // 📸 Pick image
// //   Future<void> _pickImage() async {
// //     final picked = await picker.pickImage(source: ImageSource.gallery);
// //     if (picked != null) {
// //       setState(() {
// //         _pickedFile = picked;
// //       });
// //     }
// //   }
// //
// //   // 💾 Save Speaker
// //   Future<void> _saveSpeaker() async {
// //     if (!_formKey.currentState!.validate()) return;
// //
// //     setState(() => _isLoading = true);
// //
// //     try {
// //       final success = await _speakerController.createSpeaker(
// //         name: _nameController.text.trim(),
// //         designation: _designationController.text.trim(),
// //         bio: _bioController.text.trim(),
// //         imageFile: !kIsWeb && _pickedFile != null ? File(_pickedFile!.path) : null,
// //       );
// //
// //       if (success) {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text("✅ Speaker created successfully!")),
// //           );
// //           Navigator.pop(context, true);
// //         }
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("❌ Failed to create speaker")),
// //         );
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("⚠️ Error: $e")),
// //       );
// //     } finally {
// //       setState(() => _isLoading = false);
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           "Add Speaker",
// //           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
// //         ),
// //         backgroundColor: Colors.white,
// //         foregroundColor: Colors.black,
// //         elevation: 0,
// //       ),
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Form(
// //             key: _formKey,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 // 🔹 Name
// //                 Text(
// //                   "Name",
// //                   style: GoogleFonts.poppins(
// //                       fontSize: 16, fontWeight: FontWeight.w500),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 TextFormField(
// //                   controller: _nameController,
// //                   validator: (v) => v == null || v.isEmpty ? "Enter name" : null,
// //                   decoration: InputDecoration(
// //                     hintText: "Enter speaker name",
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //
// //                 // 🔹 Image Picker
// //                 Text(
// //                   "Profile Picture",
// //                   style: GoogleFonts.poppins(
// //                       fontSize: 16, fontWeight: FontWeight.w500),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 GestureDetector(
// //                   onTap: _pickImage,
// //                   child: Container(
// //                     height: MediaQuery.of(context).size.height * 0.25,
// //                     width: double.infinity,
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(12),
// //                       border: Border.all(color: Colors.grey.shade400),
// //                       color: Colors.grey.shade100,
// //                     ),
// //                     child: _pickedFile != null
// //                         ? ClipRRect(
// //                       borderRadius: BorderRadius.circular(12),
// //                       child: kIsWeb
// //                           ? Image.network(
// //                         _pickedFile!.path,
// //                         fit: BoxFit.cover,
// //                         width: double.infinity,
// //                       )
// //                           : Image.file(
// //                         File(_pickedFile!.path),
// //                         fit: BoxFit.cover,
// //                         width: double.infinity,
// //                       ),
// //                     )
// //                         : Center(
// //                       child: Column(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           const Icon(Icons.add_a_photo,
// //                               color: Colors.grey, size: 40),
// //                           const SizedBox(height: 8),
// //                           Text(
// //                             "Tap to select image",
// //                             style: GoogleFonts.poppins(
// //                               color: Colors.grey,
// //                               fontSize: 14,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //
// //                 // 🔹 Designation
// //                 Text(
// //                   "Designation",
// //                   style: GoogleFonts.poppins(
// //                       fontSize: 16, fontWeight: FontWeight.w500),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 TextFormField(
// //                   controller: _designationController,
// //                   validator: (v) =>
// //                   v == null || v.isEmpty ? "Enter designation" : null,
// //                   decoration: InputDecoration(
// //                     hintText: "Enter designation (e.g., Pastor, Speaker)",
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //
// //                 // 🔹 Bio
// //                 Text(
// //                   "Bio",
// //                   style: GoogleFonts.poppins(
// //                       fontSize: 16, fontWeight: FontWeight.w500),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 TextFormField(
// //                   controller: _bioController,
// //                   maxLines: 4,
// //                   decoration: InputDecoration(
// //                     hintText: "Enter a short biography",
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 24),
// //
// //                 // 🔹 Save Button
// //                 Center(
// //                   child: _isLoading
// //                       ? const CircularProgressIndicator()
// //                       : ElevatedButton(
// //                     style: ElevatedButton.styleFrom(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 32, vertical: 12),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                     ),
// //                     onPressed: _saveSpeaker,
// //                     child: Text(
// //                       "Save Speaker",
// //                       style: GoogleFonts.poppins(
// //                           fontSize: 16, fontWeight: FontWeight.w600),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'dart:io';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import '../Controller/Speaker_controller.dart';
//
// class SpeakerPage extends StatefulWidget {
//   const SpeakerPage({super.key});
//
//   @override
//   State<SpeakerPage> createState() => _SpeakerPageState();
// }
//
// class _SpeakerPageState extends State<SpeakerPage> {
//   final picker = ImagePicker();
//   XFile? _pickedFile;
//   final _nameController = TextEditingController();
//   final _designationController = TextEditingController();
//   final _bioController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//
//   final MediaSpeakerController _speakerController = MediaSpeakerController();
//
//   Future<void> _pickImage() async {
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() => _pickedFile = picked);
//     }
//   }
//
//   Future<void> _saveSpeaker() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//
//     final success = await _speakerController.createSpeaker(
//       name: _nameController.text.trim(),
//       designation: _designationController.text.trim(),
//       bio: _bioController.text.trim(),
//       imageFile: !kIsWeb && _pickedFile != null ? File(_pickedFile!.path) : null,
//     );
//
//     setState(() => _isLoading = false);
//
//     if (success && mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("✅ Speaker created successfully")),
//       );
//       Navigator.pop(context, true);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("❌ Failed to create speaker")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Speaker",
//             style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Name", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: _nameController,
//                   validator: (v) => v == null || v.isEmpty ? "Enter name" : null,
//                   decoration: InputDecoration(
//                     hintText: "Enter speaker name",
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 Text("Profile Picture", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
//                 const SizedBox(height: 8),
//                 GestureDetector(
//                   onTap: _pickImage,
//                   child: Container(
//                     height: 180,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade400),
//                       color: Colors.grey.shade100,
//                     ),
//                     child: _pickedFile != null
//                         ? ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: kIsWeb
//                           ? Image.network(_pickedFile!.path, fit: BoxFit.cover)
//                           : Image.file(File(_pickedFile!.path), fit: BoxFit.cover),
//                     )
//                         : const Center(
//                       child: Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 Text("Designation", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: _designationController,
//                   validator: (v) => v == null || v.isEmpty ? "Enter designation" : null,
//                   decoration: InputDecoration(
//                     hintText: "e.g., Pastor, Speaker",
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 Text("Bio", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: _bioController,
//                   maxLines: 4,
//                   decoration: InputDecoration(
//                     hintText: "Enter biography",
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//
//                 Center(
//                   child: _isLoading
//                       ? const CircularProgressIndicator()
//                       : ElevatedButton(
//                     onPressed: _saveSpeaker,
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     child: Text("Save Speaker",
//                         style: GoogleFonts.poppins(
//                             fontSize: 16, fontWeight: FontWeight.w600)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../Controller/Speaker_controller.dart';

class SpeakerPage extends StatefulWidget {
  const SpeakerPage({super.key});

  @override
  State<SpeakerPage> createState() => _SpeakerPageState();
}

class _SpeakerPageState extends State<SpeakerPage> {
  final picker = ImagePicker();
  XFile? _pickedFile;
  Uint8List? _webImageBytes;
  final _nameController = TextEditingController();
  final _designationController = TextEditingController();
  final _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final MediaSpeakerController _speakerController = MediaSpeakerController();

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        _webImageBytes = await picked.readAsBytes();
      }
      setState(() => _pickedFile = picked);
    }
  }

  Future<void> _saveSpeaker() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await _speakerController.createSpeaker(
      name: _nameController.text.trim(),
      designation: _designationController.text.trim(),
      bio: _bioController.text.trim(),
      imageFile: !kIsWeb && _pickedFile != null ? File(_pickedFile!.path) : null,
      imageBytes: kIsWeb ? _webImageBytes : null,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("✅ Speaker created successfully!"),
          backgroundColor: Colors.green.shade600,
        ),
      );

      _formKey.currentState!.reset();
      setState(() {
        _pickedFile = null;
        _webImageBytes = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("❌ Failed to create speaker"),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Speaker",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  validator: (v) => v == null || v.isEmpty ? "Enter name" : null,
                  decoration: InputDecoration(
                    hintText: "Enter speaker name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),

                Text("Profile Picture", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                      color: Colors.grey.shade100,
                    ),
                    child: _pickedFile != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.memory(_webImageBytes!, fit: BoxFit.cover)
                          : Image.file(File(_pickedFile!.path), fit: BoxFit.cover),
                    )
                        : const Center(
                      child: Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Text("Designation", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _designationController,
                  validator: (v) => v == null || v.isEmpty ? "Enter designation" : null,
                  decoration: InputDecoration(
                    hintText: "e.g., Pastor, Speaker",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),

                Text("Bio", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bioController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Enter biography",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 24),

                Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _saveSpeaker,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Save Speaker",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
