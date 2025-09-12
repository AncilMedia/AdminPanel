// // // // import 'package:flutter/material.dart';
// // // // import 'package:google_fonts/google_fonts.dart';
// // // //
// // // // Future<void> showCreateMediaSeriesDialog(BuildContext context) async {
// // // //   String? selectedSeries;
// // // //   final TextEditingController titleController = TextEditingController();
// // // //
// // // //   return showDialog(
// // // //     context: context,
// // // //     builder: (BuildContext context) {
// // // //       return Dialog(
// // // //         shape: RoundedRectangleBorder(
// // // //           borderRadius: BorderRadius.circular(16),
// // // //         ),
// // // //         child: SizedBox(
// // // //           width: 400,
// // // //           child: Padding(
// // // //             padding: const EdgeInsets.all(20),
// // // //             child: Column(
// // // //               mainAxisSize: MainAxisSize.min, // keeps height flexible
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 Text(
// // // //                   "Create Media Series",
// // // //                   style: GoogleFonts.poppins(
// // // //                     fontSize: 18,
// // // //                     fontWeight: FontWeight.w600,
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 16),
// // // //
// // // //                 TextField(
// // // //                   controller: titleController,
// // // //                   decoration: InputDecoration(
// // // //                     labelText: "Title",
// // // //                     border: OutlineInputBorder(
// // // //                       borderRadius: BorderRadius.circular(8),
// // // //                     ),
// // // //                     filled: true,
// // // //                     fillColor: Colors.grey.shade100,
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 16),
// // // //                 SizedBox(
// // // //                   width: double.infinity,
// // // //                   child: ElevatedButton(
// // // //                     onPressed: () {
// // // //                       debugPrint(
// // // //                           "Title: ${titleController
// // // //                               .text}, Series: $selectedSeries");
// // // //                       Navigator.pop(context);
// // // //                     },
// // // //                     style: ElevatedButton.styleFrom(
// // // //                       backgroundColor: Colors.blueAccent,
// // // //                       shape: RoundedRectangleBorder(
// // // //                         borderRadius: BorderRadius.circular(30),
// // // //                       ),
// // // //                       padding: const EdgeInsets.symmetric(vertical: 14),
// // // //                     ),
// // // //                     child: Text(
// // // //                       "Create",
// // // //                       style: GoogleFonts.poppins(
// // // //                         fontWeight: FontWeight.w500,
// // // //                         fontSize: 16,
// // // //                         color: Colors.white,
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       );
// // // //     },
// // // //   );
// // // // }
// // //
// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:file_picker/file_picker.dart';
// // // import '../Controller/Media_Series_controller.dart';
// // //
// // // Future<void> showCreateMediaSeriesDialog(
// // //     BuildContext context, MediaSeriesService seriesService,
// // //     {VoidCallback? onCreated}) async {
// // //   final TextEditingController titleController = TextEditingController();
// // //   final TextEditingController descriptionController = TextEditingController();
// // //   File? pickedThumbnail;
// // //   bool isLoading = false;
// // //
// // //   return showDialog(
// // //     context: context,
// // //     builder: (BuildContext context) {
// // //       return StatefulBuilder(builder: (context, setState) {
// // //         return Dialog(
// // //           shape: RoundedRectangleBorder(
// // //             borderRadius: BorderRadius.circular(16),
// // //           ),
// // //           child: SizedBox(
// // //             width: 400,
// // //             child: Padding(
// // //               padding: const EdgeInsets.all(20),
// // //               child: Column(
// // //                 mainAxisSize: MainAxisSize.min,
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(
// // //                     "Create Media Series",
// // //                     style: GoogleFonts.poppins(
// // //                       fontSize: 18,
// // //                       fontWeight: FontWeight.w600,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 16),
// // //
// // //                   TextField(
// // //                     controller: titleController,
// // //                     decoration: InputDecoration(
// // //                       labelText: "Title",
// // //                       border: OutlineInputBorder(
// // //                           borderRadius: BorderRadius.circular(8)),
// // //                       filled: true,
// // //                       fillColor: Colors.grey.shade100,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 12),
// // //
// // //                   TextField(
// // //                     controller: descriptionController,
// // //                     decoration: InputDecoration(
// // //                       labelText: "Description",
// // //                       border: OutlineInputBorder(
// // //                           borderRadius: BorderRadius.circular(8)),
// // //                       filled: true,
// // //                       fillColor: Colors.grey.shade100,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 12),
// // //
// // //                   ElevatedButton(
// // //                     onPressed: () async {
// // //                       FilePickerResult? result = await FilePicker.platform.pickFiles(
// // //                         type: FileType.image,
// // //                       );
// // //                       if (result != null) {
// // //                         setState(() {
// // //                           pickedThumbnail = File(result.files.single.path!);
// // //                         });
// // //                       }
// // //                     },
// // //                     child: Text(pickedThumbnail == null
// // //                         ? "Pick Thumbnail"
// // //                         : "Thumbnail Selected"),
// // //                   ),
// // //                   const SizedBox(height: 24),
// // //
// // //                   SizedBox(
// // //                     width: double.infinity,
// // //                     child: ElevatedButton(
// // //                       onPressed: isLoading
// // //                           ? null
// // //                           : () async {
// // //                         if (titleController.text.isEmpty ||
// // //                             pickedThumbnail == null) {
// // //                           ScaffoldMessenger.of(context).showSnackBar(
// // //                             const SnackBar(
// // //                               content: Text(
// // //                                   "Title and thumbnail are required"),
// // //                             ),
// // //                           );
// // //                           return;
// // //                         }
// // //
// // //                         setState(() {
// // //                           isLoading = true;
// // //                         });
// // //
// // //                         try {
// // //                           final response = await seriesService.createSeries(
// // //                             title: titleController.text,
// // //                             description: descriptionController.text,
// // //                             thumbnail: pickedThumbnail!.path,
// // //                           );
// // //                           debugPrint("Created series: $response");
// // //
// // //                           if (onCreated != null) onCreated();
// // //
// // //                           Navigator.pop(context);
// // //                         } catch (e) {
// // //                           debugPrint("Error creating series: $e");
// // //                           ScaffoldMessenger.of(context).showSnackBar(
// // //                             const SnackBar(
// // //                                 content: Text("Failed to create series")),
// // //                           );
// // //                         } finally {
// // //                           setState(() {
// // //                             isLoading = false;
// // //                           });
// // //                         }
// // //                       },
// // //                       style: ElevatedButton.styleFrom(
// // //                         backgroundColor: Colors.blueAccent,
// // //                         shape: RoundedRectangleBorder(
// // //                             borderRadius: BorderRadius.circular(30)),
// // //                         padding: const EdgeInsets.symmetric(vertical: 14),
// // //                       ),
// // //                       child: isLoading
// // //                           ? const SizedBox(
// // //                         width: 20,
// // //                         height: 20,
// // //                         child: CircularProgressIndicator(
// // //                           color: Colors.white,
// // //                           strokeWidth: 2,
// // //                         ),
// // //                       )
// // //                           : Text(
// // //                         "Create",
// // //                         style: GoogleFonts.poppins(
// // //                             fontWeight: FontWeight.w500,
// // //                             fontSize: 16,
// // //                             color: Colors.white),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //         );
// // //       });
// // //     },
// // //   );
// // // }
// //
// //
// // // create_media_series_dialog.dart
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:file_picker/file_picker.dart';
// // import '../Controller/Media_Series_controller.dart';
// //
// // Future<void> showCreateMediaSeriesDialog(
// //     BuildContext context,
// //     MediaSeriesService seriesService, {
// //       VoidCallback? onCreated,
// //     }) async {
// //   final TextEditingController titleController = TextEditingController();
// //   final TextEditingController descriptionController = TextEditingController();
// //   File? pickedThumbnail;
// //   bool isLoading = false;
// //
// //   return showDialog(
// //     context: context,
// //     builder: (BuildContext context) {
// //       return StatefulBuilder(builder: (context, setState) {
// //         return Dialog(
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(16),
// //           ),
// //           child: SizedBox(
// //             width: 400,
// //             child: Padding(
// //               padding: const EdgeInsets.all(20),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     "Create Media Series",
// //                     style: GoogleFonts.poppins(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),
// //                   TextField(
// //                     controller: titleController,
// //                     decoration: InputDecoration(
// //                       labelText: "Title",
// //                       border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(8)),
// //                       filled: true,
// //                       fillColor: Colors.grey.shade100,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 12),
// //                   TextField(
// //                     controller: descriptionController,
// //                     decoration: InputDecoration(
// //                       labelText: "Description",
// //                       border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(8)),
// //                       filled: true,
// //                       fillColor: Colors.grey.shade100,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 12),
// //                   ElevatedButton(
// //                     onPressed: () async {
// //                       FilePickerResult? result =
// //                       await FilePicker.platform.pickFiles(
// //                         type: FileType.image,
// //                       );
// //                       if (result != null) {
// //                         setState(() {
// //                           pickedThumbnail = File(result.files.single.path!);
// //                         });
// //                       }
// //                     },
// //                     child: Text(pickedThumbnail == null
// //                         ? "Pick Thumbnail"
// //                         : "Thumbnail Selected"),
// //                   ),
// //                   const SizedBox(height: 24),
// //                   SizedBox(
// //                     width: double.infinity,
// //                     child: ElevatedButton(
// //                       onPressed: isLoading
// //                           ? null
// //                           : () async {
// //                         if (titleController.text.isEmpty ||
// //                             pickedThumbnail == null) {
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             const SnackBar(
// //                                 content: Text(
// //                                     "Title and thumbnail are required")),
// //                           );
// //                           return;
// //                         }
// //
// //                         setState(() {
// //                           isLoading = true;
// //                         });
// //
// //                         try {
// //                           final response = await seriesService.createSeries(
// //                             title: titleController.text,
// //                             description: descriptionController.text,
// //                             thumbnail: pickedThumbnail!.path,
// //                           );
// //                           debugPrint("Created series: $response");
// //
// //                           if (onCreated != null) onCreated();
// //
// //                           Navigator.pop(context);
// //                         } catch (e) {
// //                           debugPrint("Error creating series: $e");
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             const SnackBar(
// //                                 content:
// //                                 Text("Failed to create series")),
// //                           );
// //                         } finally {
// //                           setState(() {
// //                             isLoading = false;
// //                           });
// //                         }
// //                       },
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.blueAccent,
// //                         shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(30)),
// //                         padding: const EdgeInsets.symmetric(vertical: 14),
// //                       ),
// //                       child: isLoading
// //                           ? const SizedBox(
// //                         width: 20,
// //                         height: 20,
// //                         child: CircularProgressIndicator(
// //                           color: Colors.white,
// //                           strokeWidth: 2,
// //                         ),
// //                       )
// //                           : Text(
// //                         "Create",
// //                         style: GoogleFonts.poppins(
// //                           fontWeight: FontWeight.w500,
// //                           fontSize: 16,
// //                           color: Colors.white,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         );
// //       });
// //     },
// //   );
// // }
//
//
//
// // create_media_series_dialog.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
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
//   File? pickedThumbnail;
//   bool isLoading = false;
//
//   return showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(builder: (context, setState) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: SizedBox(
//             width: 400,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Create Media Series",
//                     style: GoogleFonts.poppins(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: titleController,
//                     decoration: InputDecoration(
//                       labelText: "Title",
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8)),
//                       filled: true,
//                       fillColor: Colors.grey.shade100,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: descriptionController,
//                     decoration: InputDecoration(
//                       labelText: "Description",
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8)),
//                       filled: true,
//                       fillColor: Colors.grey.shade100,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   ElevatedButton(
//                     onPressed: () async {
//                       FilePickerResult? result =
//                       await FilePicker.platform.pickFiles(
//                         type: FileType.image,
//                       );
//                       if (result != null) {
//                         setState(() {
//                           pickedThumbnail =
//                               File(result.files.single.path!);
//                         });
//                       }
//                     },
//                     child: Text(pickedThumbnail == null
//                         ? "Pick Thumbnail"
//                         : "Thumbnail Selected"),
//                   ),
//                   const SizedBox(height: 24),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: isLoading
//                           ? null
//                           : () async {
//                         if (titleController.text.isEmpty ||
//                             pickedThumbnail == null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text(
//                                     "Title and thumbnail are required")),
//                           );
//                           return;
//                         }
//
//                         setState(() {
//                           isLoading = true;
//                         });
//
//                         try {
//                           final response = await seriesService.createSeries(
//                             title: titleController.text,
//                             description: descriptionController.text,
//                             thumbnail: pickedThumbnail!.path,
//                           );
//
//                           debugPrint("Created series: $response");
//
//                           if (onCreated != null) onCreated();
//
//                           Navigator.pop(context);
//                         } catch (e) {
//                           debugPrint("Error creating series: $e");
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content:
//                                 Text("Failed to create series")),
//                           );
//                         } finally {
//                           setState(() {
//                             isLoading = false;
//                           });
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blueAccent,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30)),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                       ),
//                       child: isLoading
//                           ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                           : Text(
//                         "Create",
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 16,
//                           color: Colors.white,
//                         ),
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


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../Controller/Media_Series_controller.dart';

Future<void> showCreateMediaSeriesDialog(
    BuildContext context,
    MediaSeriesService seriesService, {
      VoidCallback? onCreated,
    }) async {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? pickedThumbnail;
  bool isLoading = false;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Media Series",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if (result != null) {
                        setState(() {
                          pickedThumbnail = File(result.files.single.path!);
                        });
                      }
                    },
                    child: Text(pickedThumbnail == null
                        ? "Pick Thumbnail"
                        : "Thumbnail Selected"),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                        if (titleController.text.isEmpty ||
                            pickedThumbnail == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Title and thumbnail are required")),
                          );
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        try {
                          final response =
                          await seriesService.createSeries(
                            title: titleController.text,
                            description: descriptionController.text,
                            thumbnail: pickedThumbnail!.path,
                          );
                          debugPrint("Created series: $response");

                          if (onCreated != null) onCreated();

                          Navigator.pop(context);
                        } catch (e) {
                          debugPrint("Error creating series: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    e.toString().contains("Missing required IDs")
                                        ? "Cannot create series: missing user, organization, or role IDs."
                                        : "Failed to create series")),
                          );
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        "Create",
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
          ),
        );
      });
    },
  );
}
