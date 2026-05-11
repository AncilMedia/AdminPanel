// import 'dart:io' show File;
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:file_picker/file_picker.dart';
// import '../Controller/Media_Series_controller.dart';
//
// Future<void> showCreateMediaSeriesDialog(
//     BuildContext context,
//     MediaSeriesService seriesService, {
//       VoidCallback? onCreated,
//     }) async {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//
//   File? pickedFile;
//   Uint8List? pickedBytes;
//   bool isLoading = false;
//
//   return showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(builder: (context, setState) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             width: 450,
//             padding: const EdgeInsets.all(28),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(28),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.15),
//                   blurRadius: 30,
//                   offset: const Offset(0, 15),
//                 )
//               ],
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // --- HEADER ---
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Create Media Series",
//                         style: GoogleFonts.poppins(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blueGrey.shade900,
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Iconsax.close_circle, color: Colors.grey),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ],
//                   ),
//                   const Divider(height: 32),
//
//                   // --- INPUT FIELDS ---
//                   _buildLabel("Series Title"),
//                   _modernInput(titleController, "e.g. Sunday Service 2026", Iconsax.folder_2),
//
//                   const SizedBox(height: 12),
//
//                   _buildLabel("Description"),
//                   _modernInput(descriptionController, "Add a brief summary...", Iconsax.document_text, maxLines: 3),
//
//                   const SizedBox(height: 20),
//
//                   // --- MODERN THUMBNAIL PICKER ---
//                   _buildLabel("Series Thumbnail"),
//                   GestureDetector(
//                     onTap: () async {
//                       FilePickerResult? result = await FilePicker.platform.pickFiles(
//                         type: FileType.image,
//                         withData: true,
//                       );
//
//                       if (result != null) {
//                         if (kIsWeb) {
//                           setState(() => pickedBytes = result.files.single.bytes);
//                         } else {
//                           setState(() => pickedFile = File(result.files.single.path!));
//                         }
//                       }
//                     },
//                     child: Container(
//                       height: 160,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.indigo.withOpacity(0.05),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.indigo.withOpacity(0.1), width: 2),
//                       ),
//                       child: (pickedFile != null || pickedBytes != null)
//                           ? ClipRRect(
//                         borderRadius: BorderRadius.circular(18),
//                         child: kIsWeb
//                             ? Image.memory(pickedBytes!, fit: BoxFit.cover)
//                             : Image.file(pickedFile!, fit: BoxFit.cover),
//                       )
//                           : Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Iconsax.image, size: 40, color: Colors.indigo),
//                           const SizedBox(height: 10),
//                           Text("Select Cover Image",
//                               style: GoogleFonts.poppins(color: Colors.indigo, fontWeight: FontWeight.w600, fontSize: 13)),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 32),
//
//                   // --- ACTION BUTTON ---
//                   SizedBox(
//                     width: double.infinity,
//                     height: 55,
//                     child: ElevatedButton(
//                       onPressed: isLoading
//                           ? null
//                           : () async {
//                         if (titleController.text.isEmpty || (pickedFile == null && pickedBytes == null)) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Title and thumbnail are required"), backgroundColor: Colors.red),
//                           );
//                           return;
//                         }
//
//                         setState(() => isLoading = true);
//
//                         try {
//                           await seriesService.createSeries(
//                             title: titleController.text,
//                             description: descriptionController.text,
//                             file: pickedFile,
//                             bytes: pickedBytes,
//                           );
//                           if (onCreated != null) onCreated();
//                           Navigator.pop(context);
//                         } catch (e) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
//                           );
//                         } finally {
//                           setState(() => isLoading = false);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo.shade600,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                         elevation: 0,
//                       ),
//                       child: isLoading
//                           ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                           : Text(
//                         "Create Series",
//                         style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       });
//     },
//   );
// }
//
// // ================= MODERN STYLING HELPERS =================
//
// Widget _buildLabel(String text) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 8, left: 4),
//     child: Text(
//       text,
//       style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade700),
//     ),
//   );
// }
//
// Widget _modernInput(TextEditingController controller, String hint, IconData icon, {int maxLines = 1}) {
//   return TextFormField(
//     controller: controller,
//     maxLines: maxLines,
//     style: GoogleFonts.poppins(fontSize: 14),
//     decoration: InputDecoration(
//       hintText: hint,
//       prefixIcon: Icon(icon, size: 20, color: Colors.indigo),
//       filled: true,
//       fillColor: Colors.grey.shade50,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
//       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade100)),
//       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.indigo, width: 1.5)),
//       contentPadding: const EdgeInsets.symmetric(vertical: 18),
//     ),
//   );
// }

import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:file_picker/file_picker.dart';
import '../Controller/Media_Series_controller.dart';

Future<void> showCreateMediaSeriesDialog(
    BuildContext context,
    MediaSeriesService seriesService, {
      VoidCallback? onCreated,
    }) async {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? pickedFile;
  Uint8List? pickedBytes;
  bool isLoading = false;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        // --- RESPONSIVE CALCULATIONS ---
        final screenWidth = MediaQuery.of(context).size.width;
        final bool isMobile = screenWidth < 600;

        return Dialog(
          backgroundColor: Colors.transparent,
          // Adjust padding around the dialog based on screen size
          insetPadding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 40,
              vertical: 24
          ),
          child: Container(
            // Use constraints instead of a fixed width for responsiveness
            constraints: const BoxConstraints(maxWidth: 500),
            width: double.infinity,
            padding: EdgeInsets.all(isMobile ? 20 : 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                )
              ],
            ),
            child: SingleChildScrollView(
              // Physics ensures smooth scrolling on small devices if keyboard covers fields
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Create Media Series",
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 18 : 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade900,
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Iconsax.close_circle, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // --- INPUT FIELDS ---
                  _buildLabel("Series Title"),
                  _modernInput(titleController, "e.g. Sunday Service 2026", Iconsax.folder_2),

                  const SizedBox(height: 12),

                  _buildLabel("Description"),
                  _modernInput(descriptionController, "Add a brief summary...", Iconsax.document_text, maxLines: 3),

                  const SizedBox(height: 20),

                  // --- MODERN THUMBNAIL PICKER ---
                  _buildLabel("Series Thumbnail"),
                  GestureDetector(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                        withData: true,
                      );

                      if (result != null) {
                        if (kIsWeb) {
                          setState(() => pickedBytes = result.files.single.bytes);
                        } else {
                          setState(() => pickedFile = File(result.files.single.path!));
                        }
                      }
                    },
                    child: Container(
                      height: isMobile ? 140 : 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.indigo.withOpacity(0.1), width: 2),
                      ),
                      child: (pickedFile != null || pickedBytes != null)
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: kIsWeb
                            ? Image.memory(pickedBytes!, fit: BoxFit.cover)
                            : Image.file(pickedFile!, fit: BoxFit.cover),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.image, size: isMobile ? 32 : 40, color: Colors.indigo),
                          const SizedBox(height: 10),
                          Text("Select Cover Image",
                              style: GoogleFonts.poppins(color: Colors.indigo, fontWeight: FontWeight.w600, fontSize: isMobile ? 12 : 13)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- ACTION BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                        if (titleController.text.isEmpty || (pickedFile == null && pickedBytes == null)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Title and thumbnail are required"), backgroundColor: Colors.red),
                          );
                          return;
                        }

                        setState(() => isLoading = true);

                        try {
                          await seriesService.createSeries(
                            title: titleController.text,
                            description: descriptionController.text,
                            file: pickedFile,
                            bytes: pickedBytes,
                          );
                          if (onCreated != null) onCreated();

                          // Check context.mounted before popping
                          if (context.mounted) Navigator.pop(context);
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
                            );
                          }
                        } finally {
                          // Fix for the error: Use context.mounted here
                          if (context.mounted) {
                            setState(() => isLoading = false);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade600,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(
                        "Create Series",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: isMobile ? 14 : 16, color: Colors.white),
                      ),
                    ),
                  ),
                  // Add extra padding at the bottom for mobile devices with home bars
                  if (isMobile) const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}

// ================= MODERN STYLING HELPERS =================

Widget _buildLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Text(
      text,
      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade700),
    ),
  );
}

Widget _modernInput(TextEditingController controller, String hint, IconData icon, {int maxLines = 1}) {
  return TextFormField(
    controller: controller,
    maxLines: maxLines,
    style: GoogleFonts.poppins(fontSize: 14),
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20, color: Colors.indigo),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade100)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.indigo, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
    ),
  );
}