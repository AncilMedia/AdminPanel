// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // //
// // // Future<void> showCreateMediaItemDialog(BuildContext context) async {
// // //   String? selectedSeries;
// // //   final TextEditingController titleController = TextEditingController();
// // //
// // //   final List<String> mediaSeries = [
// // //     "Series 1",
// // //     "Series 2",
// // //     "Series 3",
// // //   ];
// // //
// // //   return showDialog(
// // //     context: context,
// // //     builder: (BuildContext context) {
// // //       return Dialog(
// // //         shape: RoundedRectangleBorder(
// // //           borderRadius: BorderRadius.circular(16),
// // //         ),
// // //         child: SizedBox(
// // //           width: 400, // 🔹 set custom width
// // //           // height: 350, // 🔹 optional: set custom height
// // //           child: Padding(
// // //             padding: const EdgeInsets.all(20),
// // //             child: Column(
// // //               mainAxisSize: MainAxisSize.min, // keeps height flexible
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   "Create Media Item",
// // //                   style: GoogleFonts.poppins(
// // //                     fontSize: 18,
// // //                     fontWeight: FontWeight.w600,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //
// // //                 TextField(
// // //                   controller: titleController,
// // //                   decoration: InputDecoration(
// // //                     labelText: "Title",
// // //                     border: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(8),
// // //                     ),
// // //                     filled: true,
// // //                     fillColor: Colors.grey.shade100,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //
// // //                 DropdownButtonFormField<String>(
// // //                   value: selectedSeries,
// // //                   items: mediaSeries.map((series) {
// // //                     return DropdownMenuItem<String>(
// // //                       value: series,
// // //                       child: Text(series),
// // //                     );
// // //                   }).toList(),
// // //                   onChanged: (value) {
// // //                     selectedSeries = value;
// // //                   },
// // //                   decoration: InputDecoration(
// // //                     labelText: "Media Series (optional)",
// // //                     border: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(8),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 24),
// // //
// // //                 SizedBox(
// // //                   width: double.infinity,
// // //                   child: ElevatedButton(
// // //                     onPressed: () {
// // //                       debugPrint(
// // //                           "Title: ${titleController
// // //                               .text}, Series: $selectedSeries");
// // //                       Navigator.pop(context);
// // //                     },
// // //                     style: ElevatedButton.styleFrom(
// // //                       backgroundColor: Colors.blueAccent,
// // //                       shape: RoundedRectangleBorder(
// // //                         borderRadius: BorderRadius.circular(30),
// // //                       ),
// // //                       padding: const EdgeInsets.symmetric(vertical: 14),
// // //                     ),
// // //                     child: Text(
// // //                       "Create",
// // //                       style: GoogleFonts.poppins(
// // //                         fontWeight: FontWeight.w500,
// // //                         fontSize: 16,
// // //                         color: Colors.white,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       );
// // //     },
// // //   );
// // // }
// //
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:file_picker/file_picker.dart';
// //
// // import '../Controller/Media_Item_controller.dart';
// //
// // Future<void> showCreateMediaItemDialog(BuildContext context, MediaItemService itemService) async {
// //   String? selectedSeries;
// //   final TextEditingController titleController = TextEditingController();
// //   final TextEditingController descriptionController = TextEditingController();
// //   File? pickedFile;
// //
// //   final List<String> mediaSeries = [
// //     "Series 1",
// //     "Series 2",
// //     "Series 3",
// //   ];
// //
// //   return showDialog(
// //     context: context,
// //     builder: (BuildContext context) {
// //       return StatefulBuilder(
// //         builder: (context, setState) {
// //           return Dialog(
// //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //             child: SizedBox(
// //               width: 400,
// //               child: Padding(
// //                 padding: const EdgeInsets.all(20),
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       "Create Media Item",
// //                       style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
// //                     ),
// //                     const SizedBox(height: 16),
// //
// //                     TextField(
// //                       controller: titleController,
// //                       decoration: InputDecoration(
// //                         labelText: "Title",
// //                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //                         filled: true,
// //                         fillColor: Colors.grey.shade100,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 12),
// //
// //                     TextField(
// //                       controller: descriptionController,
// //                       decoration: InputDecoration(
// //                         labelText: "Description",
// //                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //                         filled: true,
// //                         fillColor: Colors.grey.shade100,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 12),
// //
// //                     DropdownButtonFormField<String>(
// //                       value: selectedSeries,
// //                       items: mediaSeries.map((series) {
// //                         return DropdownMenuItem<String>(
// //                           value: series,
// //                           child: Text(series),
// //                         );
// //                       }).toList(),
// //                       onChanged: (value) {
// //                         setState(() {
// //                           selectedSeries = value;
// //                         });
// //                       },
// //                       decoration: InputDecoration(
// //                         labelText: "Media Series (optional)",
// //                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //
// //                     ElevatedButton(
// //                       onPressed: () async {
// //                         FilePickerResult? result = await FilePicker.platform.pickFiles(
// //                           type: FileType.custom,
// //                           allowedExtensions: ['mp4', 'mp3', 'mov', 'wav'],
// //                         );
// //                         if (result != null) {
// //                           setState(() {
// //                             pickedFile = File(result.files.single.path!);
// //                           });
// //                         }
// //                       },
// //                       child: Text(pickedFile == null ? "Pick Media File" : "File Selected: ${pickedFile!.path.split('/').last}"),
// //                     ),
// //                     const SizedBox(height: 24),
// //
// //                     SizedBox(
// //                       width: double.infinity,
// //                       child: ElevatedButton(
// //                         onPressed: pickedFile == null
// //                             ? null
// //                             : () async {
// //                           try {
// //                             final response = await itemService.createMediaItem(
// //                               title: titleController.text,
// //                               description: descriptionController.text,
// //                               seriesId: selectedSeries,
// //                               file: pickedFile!,
// //                             );
// //                             debugPrint("Created media item: $response");
// //                             Navigator.pop(context, true);
// //                           } catch (e) {
// //                             debugPrint("Error creating media item: $e");
// //                             ScaffoldMessenger.of(context).showSnackBar(
// //                               SnackBar(content: Text("Failed to create media item")),
// //                             );
// //                           }
// //                         },
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.blueAccent,
// //                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
// //                           padding: const EdgeInsets.symmetric(vertical: 14),
// //                         ),
// //                         child: Text(
// //                           "Create",
// //                           style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           );
// //         },
// //       );
// //     },
// //   );
// // }
//
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../Controller/Media_Item_controller.dart';
// import '../Controller/Media_Series_controller.dart';
//
// Future<void> showCreateMediaItemDialog(
//     BuildContext context,
//     MediaItemService itemService,
//     MediaSeriesService seriesService) async {
//
//   String? selectedSeries;
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   File? pickedFile;
//
//   List<dynamic> mediaSeries = [];
//   bool loadingSeries = true;
//
//   // 🔹 Fetch userId from SharedPreferences and then fetch series
//   Future<void> fetchSeries() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString("userId");
//
//     if (userId != null) {
//       try {
//         final response = await seriesService.getSeries(); // Or create an endpoint getSeriesByUser(userId)
//         mediaSeries = response;
//       } catch (e) {
//         debugPrint("⚠️ Error fetching series: $e");
//       }
//     }
//     loadingSeries = false;
//   }
//
//   await fetchSeries();
//
//   return showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return Dialog(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             child: SizedBox(
//               width: 400,
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Create Media Item",
//                       style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: 16),
//
//                     TextField(
//                       controller: titleController,
//                       decoration: InputDecoration(
//                         labelText: "Title",
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                         filled: true,
//                         fillColor: Colors.grey.shade100,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//
//                     TextField(
//                       controller: descriptionController,
//                       decoration: InputDecoration(
//                         labelText: "Description",
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                         filled: true,
//                         fillColor: Colors.grey.shade100,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//
//                     loadingSeries
//                         ? const Center(child: CircularProgressIndicator())
//                         : DropdownButtonFormField<String>(
//                       value: selectedSeries,
//                       items: mediaSeries.map<DropdownMenuItem<String>>((series) {
//                         return DropdownMenuItem<String>(
//                           value: series["_id"], // assuming API returns _id
//                           child: Text(series["title"] ?? "Untitled Series"),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedSeries = value;
//                         });
//                       },
//                       decoration: InputDecoration(
//                         labelText: "Media Series (optional)",
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//
//                     ElevatedButton(
//                       onPressed: () async {
//                         FilePickerResult? result = await FilePicker.platform.pickFiles(
//                           type: FileType.custom,
//                           allowedExtensions: ['mp4', 'mp3', 'mov', 'wav'],
//                         );
//                         if (result != null) {
//                           setState(() {
//                             pickedFile = File(result.files.single.path!);
//                           });
//                         }
//                       },
//                       child: Text(
//                         pickedFile == null
//                             ? "Pick Media File"
//                             : "File Selected: ${pickedFile!.path.split('/').last}",
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: pickedFile == null
//                             ? null
//                             : () async {
//                           try {
//                             final response = await itemService.createMediaItem(
//                               title: titleController.text,
//                               description: descriptionController.text,
//                               seriesId: selectedSeries,
//                               file: pickedFile!,
//                             );
//                             debugPrint("Created media item: $response");
//                             Navigator.pop(context, true);
//                           } catch (e) {
//                             debugPrint("Error creating media item: $e");
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text("Failed to create media item")),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blueAccent,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                         ),
//                         child: Text(
//                           "Create",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }


import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/Media_Item_controller.dart';
import '../Controller/Media_Series_controller.dart';

Future<void> showCreateMediaItemDialog(
    BuildContext context,
    MediaItemService itemService,
    MediaSeriesService seriesService,
    ) async {
  String? selectedSeries;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? pickedFile; // For mobile/desktop
  PlatformFile? webFile; // For web

  List<dynamic> mediaSeries = [];
  bool loadingSeries = true;

  // 🔹 Fetch userId from SharedPreferences and then fetch series
  Future<void> fetchSeries() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");

    if (userId != null) {
      try {
        final response = await seriesService.getSeries();
        mediaSeries = response;
      } catch (e) {
        debugPrint("⚠️ Error fetching series: $e");
      }
    }
    loadingSeries = false;
  }

  await fetchSeries();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Media Item",
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    const SizedBox(height: 12),

                    loadingSeries
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                      value: selectedSeries,
                      items: mediaSeries.map<DropdownMenuItem<String>>((series) {
                        return DropdownMenuItem<String>(
                          value: series["_id"],
                          child: Text(series["title"] ?? "Untitled Series"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSeries = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Media Series (optional)",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['mp4', 'mp3', 'mov', 'wav'],
                        );

                        if (result != null) {
                          if (kIsWeb) {
                            setState(() {
                              webFile = result.files.single; // bytes available for web
                            });
                          } else {
                            setState(() {
                              pickedFile = File(result.files.single.path!); // path for mobile
                            });
                          }
                        }
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * .0500,
                        width: MediaQuery.of(context).size.width * .3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.purpleAccent.shade200
                        ),
                        child: Center(
                          child: Text(
                            pickedFile == null && webFile == null
                                ? "Pick Media File"
                                : "File Selected: ${kIsWeb ? webFile!.name : pickedFile!.path.split('/').last}",style: GoogleFonts.poppins(
                           fontWeight: FontWeight.w500,
                           fontSize: 16,
                           color: Colors.white
                          ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: pickedFile == null && webFile == null
                            ? null
                            : () async {
                          try {
                            final response = await itemService.createMediaItem(
                              title: titleController.text,
                              description: descriptionController.text,
                              seriesId: selectedSeries,
                              file: pickedFile, // mobile
                              webFile: webFile, // web
                            );
                            debugPrint("✅ Created media item: $response");
                            Navigator.pop(context, true);
                          } catch (e) {
                            debugPrint("❌ Error creating media item: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Failed to create media item")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
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
        },
      );
    },
  );
}
