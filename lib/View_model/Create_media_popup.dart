// import 'dart:io' show File;
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Controller/Media_Item_controller.dart';
// import '../Controller/Media_Series_controller.dart';
//
// Future<void> showCreateMediaItemDialog(
//     BuildContext context,
//     MediaItemService itemService,
//     MediaSeriesService seriesService,
//     ) async {
//   String? selectedSeries;
//   String mediaSource = "file";
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final mediaUrlController = TextEditingController();
//
//   File? pickedFile; PlatformFile? webFile;
//   File? thumbnailFile; PlatformFile? webThumbnailFile;
//
//   List<dynamic> mediaSeries = [];
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final orgId = prefs.getString("organizationId");
//     mediaSeries = await seriesService.getSeriesByFilter(organizationId: orgId);
//   } catch (e) { debugPrint("⚠️ Series Error: $e"); }
//
//   return showDialog(
//     context: context,
//     builder: (context) => StatefulBuilder(
//       builder: (context, setState) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Container(
//           constraints: const BoxConstraints(maxWidth: 450, maxHeight: 750),
//           padding: const EdgeInsets.all(20),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Create Media Item", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 16),
//                 TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title", border: OutlineInputBorder())),
//                 const SizedBox(height: 12),
//                 TextField(controller: descriptionController, maxLines: 2, decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder())),
//                 const SizedBox(height: 12),
//
//                 // Series Dropdown
//                 DropdownButtonFormField<String>(
//                   value: selectedSeries,
//                   hint: const Text("Select Series"),
//                   items: mediaSeries.map<DropdownMenuItem<String>>((s) => DropdownMenuItem(value: s["_id"].toString(), child: Text(s["title"] ?? "Untitled"))).toList(),
//                   onChanged: (val) => setState(() => selectedSeries = val),
//                   decoration: const InputDecoration(border: OutlineInputBorder()),
//                 ),
//                 const SizedBox(height: 12),
//
//                 // Source Selector
//                 DropdownButtonFormField<String>(
//                   value: mediaSource,
//                   items: const [
//                     DropdownMenuItem(value: "file", child: Text("Upload File")),
//                     DropdownMenuItem(value: "youtube", child: Text("YouTube")),
//                     DropdownMenuItem(value: "vimeo", child: Text("Vimeo")),
//                   ],
//                   onChanged: (val) => setState(() => mediaSource = val!),
//                   decoration: const InputDecoration(labelText: "Source Type", border: OutlineInputBorder()),
//                 ),
//                 const SizedBox(height: 12),
//
//                 // Input based on source
//                 if (mediaSource == "file")
//                   _buildPicker(
//                     label: pickedFile?.path.split('/').last ?? webFile?.name ?? "Select Media File",
//                     onTap: () async {
//                       FilePickerResult? res = await FilePicker.platform.pickFiles(type: FileType.video);
//                       if (res != null) { setState(() { if (kIsWeb) webFile = res.files.single; else pickedFile = File(res.files.single.path!); }); }
//                     },
//                   )
//                 else
//                   TextField(controller: mediaUrlController, decoration: InputDecoration(labelText: "$mediaSource URL", border: const OutlineInputBorder())),
//
//                 const SizedBox(height: 12),
//
//                 // Thumbnail
//                 _buildPicker(
//                   label: thumbnailFile?.path.split('/').last ?? webThumbnailFile?.name ?? "Select Thumbnail Image",
//                   onTap: () async {
//                     FilePickerResult? res = await FilePicker.platform.pickFiles(type: FileType.image);
//                     if (res != null) { setState(() { if (kIsWeb) webThumbnailFile = res.files.single; else thumbnailFile = File(res.files.single.path!); }); }
//                   },
//                 ),
//
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
//                     onPressed: () async {
//                       if (mediaSource == "file" && pickedFile == null && webFile == null) {
//                         debugPrint("❌ No media file selected");
//                         if (context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Please select a media file to upload."))
//                           );
//                         }
//                         return;
//                       }
//                       if ((mediaSource == "youtube" || mediaSource == "vimeo") && mediaUrlController.text.isEmpty) {
//                         debugPrint("❌ No URL provided for $mediaSource");
//                         if (context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Please enter a $mediaSource URL."))
//                           );
//                         }
//                         return;
//                       }
//                       try {
//                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Processing upload... Please wait.")));
//                         await itemService.createMediaItem(
//                           title: titleController.text,
//                           description: descriptionController.text,
//                           file: mediaSource == "file" ? pickedFile : null,
//                           webFile: mediaSource == "file" ? webFile : null,
//                           thumbnailFile: thumbnailFile,
//                           webThumbnailFile: webThumbnailFile,
//                           seriesId: selectedSeries,
//                           source: mediaSource,
//                           mediaUrl: mediaSource != "file" ? mediaUrlController.text : null,
//                           // Use tags or other fields as needed
//                         );
//                         if (context.mounted) Navigator.pop(context, true);
//                       } catch (e) {
//                         debugPrint("❌ Media item upload error: $e");
//                         if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
//                       }
//                     },
//                     child: const Text("Create Item"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// Widget _buildPicker({required String label, required VoidCallback onTap}) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
//       child: Row(children: [const Icon(Icons.upload_file, color: Colors.purple), const SizedBox(width: 10), Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 13), overflow: TextOverflow.ellipsis))]),
//     ),
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
import '../demo1.dart';

Future<void> showCreateMediaItemDialog(
    BuildContext context,
    MediaItemService itemService,
    MediaSeriesService seriesService,
    ) async {
  String? selectedSeries;
  String mediaSource = "file";

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final mediaUrlController = TextEditingController();

  File? pickedFile;
  PlatformFile? webFile;
  File? thumbnailFile;
  PlatformFile? webThumbnailFile;

  List<dynamic> mediaSeries = [];

  try {
    final prefs = await SharedPreferences.getInstance();
    final orgId = prefs.getString("organizationId");
    mediaSeries =
    await seriesService.getSeriesByFilter(organizationId: orgId);
  } catch (e) {
    debugPrint("⚠️ Series Error: $e");
  }

  bool isFileLargerThan4MB({File? file, PlatformFile? webFile}) {
    if (kIsWeb && webFile != null) return webFile.size > 4 * 1024 * 1024;
    if (!kIsWeb && file != null) return file.lengthSync() > 4 * 1024 * 1024;
    return false;
  }

  return showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450, maxHeight: 750),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Create Media Item",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                _textField("Title", titleController),
                const SizedBox(height: 12),

                _textField("Description", descriptionController, maxLines: 2),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: selectedSeries,
                  hint: const Text("Select Series"),
                  items: mediaSeries
                      .map<DropdownMenuItem<String>>((s) =>
                      DropdownMenuItem(
                          value: s["_id"].toString(),
                          child: Text(s["title"] ?? "Untitled")))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => selectedSeries = val),
                  decoration:
                  const InputDecoration(border: OutlineInputBorder()),
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: mediaSource,
                  items: const [
                    DropdownMenuItem(
                        value: "file", child: Text("Upload File")),
                    DropdownMenuItem(
                        value: "youtube", child: Text("YouTube")),
                    DropdownMenuItem(
                        value: "vimeo", child: Text("Vimeo")),
                  ],
                  onChanged: (val) =>
                      setState(() => mediaSource = val!),
                  decoration: const InputDecoration(
                      labelText: "Source Type",
                      border: OutlineInputBorder()),
                ),

                const SizedBox(height: 12),

                if (mediaSource == "file")
                  _buildPicker(
                    label: pickedFile?.path.split('/').last ??
                        webFile?.name ??
                        "Select Media File",
                    onTap: () async {
                      final res = await FilePicker.platform.pickFiles(
                          type: FileType.video);
                      if (res != null) {
                        setState(() {
                          if (kIsWeb) {
                            webFile = res.files.single;
                          } else {
                            pickedFile =
                                File(res.files.single.path!);
                          }
                        });
                      }
                    },
                  )
                else
                  _textField("$mediaSource URL", mediaUrlController),

                const SizedBox(height: 12),

                _buildPicker(
                  label: thumbnailFile?.path.split('/').last ??
                      webThumbnailFile?.name ??
                      "Select Thumbnail Image",
                  onTap: () async {
                    final res = await FilePicker.platform.pickFiles(
                        type: FileType.image);
                    if (res != null) {
                      setState(() {
                        if (kIsWeb) {
                          webThumbnailFile = res.files.single;
                        } else {
                          thumbnailFile =
                              File(res.files.single.path!);
                        }
                      });
                    }
                  },
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      try {
                        String? uploadedMediaUrl;
                        String? uploadedThumbUrl;

                        if (mediaSource == "file") {
                          final isLarge =
                          isFileLargerThan4MB(
                              file: pickedFile,
                              webFile: webFile);

                          if (isLarge) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                content: Text(
                                    "Uploading large file to Cloudinary...")));

                            uploadedMediaUrl =
                            await CloudinaryService.uploadFile1(
                              file: pickedFile,
                              webFile: webFile,
                              isVideo: true,
                            );
                          }
                        }

                        final isThumbLarge =
                        isFileLargerThan4MB(
                            file: thumbnailFile,
                            webFile: webThumbnailFile);

                        if (thumbnailFile != null ||
                            webThumbnailFile != null) {
                          if (isThumbLarge) {
                            uploadedThumbUrl =
                            await CloudinaryService.uploadFile1(
                              file: thumbnailFile,
                              webFile: webThumbnailFile,
                              isVideo: false,
                            );
                          }
                        }

                        await itemService.createMediaItem(
                          title: titleController.text,
                          description: descriptionController.text,
                          seriesId: selectedSeries,
                          source: mediaSource,
                          mediaUrl: uploadedMediaUrl ??
                              mediaUrlController.text,
                          // thumbnailUrl: uploadedThumbUrl,

                          file: (mediaSource == "file" &&
                              !isFileLargerThan4MB(
                                  file: pickedFile,
                                  webFile: webFile))
                              ? pickedFile
                              : null,

                          webFile: (mediaSource == "file" &&
                              !isFileLargerThan4MB(
                                  file: pickedFile,
                                  webFile: webFile))
                              ? webFile
                              : null,

                          thumbnailFile:
                          !isThumbLarge ? thumbnailFile : null,
                          webThumbnailFile:
                          !isThumbLarge ? webThumbnailFile : null,
                        );

                        if (context.mounted) {
                          Navigator.pop(context, true);
                        }
                      } catch (e) {
                        debugPrint("❌ Upload Error: $e");
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $e")));
                        }
                      }
                    },
                    child: const Text("Create Item"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildPicker({
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.upload_file, color: Colors.purple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(fontSize: 13)),
          ),
        ],
      ),
    ),
  );
}

Widget _textField(
    String label,
    TextEditingController controller, {
      int maxLines = 1,
    }) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    decoration:
    InputDecoration(labelText: label, border: OutlineInputBorder()),
  );
}
