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

  File? pickedFile; // For media (mobile/desktop)
  PlatformFile? webFile; // For media (web)

  File? thumbnailFile; // For thumbnail (mobile/desktop)
  PlatformFile? webThumbnailFile; // For thumbnail (web)

  List<dynamic> mediaSeries = [];
  bool loadingSeries = true;

  // 🔹 Fetch Series List
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Media Item",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 🔹 Title
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

                      // 🔹 Description
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

                      // 🔹 Media Series Dropdown
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 🔹 Pick Main Media File
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['mp4', 'mp3', 'mov', 'wav'],
                          );

                          if (result != null) {
                            if (kIsWeb) {
                              setState(() {
                                webFile = result.files.single;
                              });
                            } else {
                              setState(() {
                                pickedFile = File(result.files.single.path!);
                              });
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.purpleAccent.shade200,
                          ),
                          child: Center(
                            child: Text(
                              pickedFile == null && webFile == null
                                  ? "Pick Media File"
                                  : "Selected: ${kIsWeb ? webFile!.name : pickedFile!.path.split('/').last}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 🔹 Pick Thumbnail File
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.image,
                          );

                          if (result != null) {
                            if (kIsWeb) {
                              setState(() {
                                webThumbnailFile = result.files.single;
                              });
                            } else {
                              setState(() {
                                thumbnailFile = File(result.files.single.path!);
                              });
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.orangeAccent,
                          ),
                          child: Center(
                            child: Text(
                              thumbnailFile == null && webThumbnailFile == null
                                  ? "Pick Thumbnail"
                                  : "Thumbnail: ${kIsWeb ? webThumbnailFile!.name : thumbnailFile!.path.split('/').last}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 🔹 Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (pickedFile == null && webFile == null)
                              ? null
                              : () async {
                            try {
                              final response = await itemService.createMediaItem(
                                title: titleController.text,
                                description: descriptionController.text,
                                seriesId: selectedSeries,
                                file: pickedFile,
                                webFile: webFile,
                                thumbnailFile: thumbnailFile,
                                webThumbnailFile: webThumbnailFile,
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
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
            ),
          );
        },
      );
    },
  );
}
