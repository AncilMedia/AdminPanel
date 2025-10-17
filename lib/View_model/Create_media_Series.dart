import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
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

  File? pickedFile;
  Uint8List? pickedBytes;
  bool isLoading = false;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
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
                    "Create Media Series",
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

                  // 🔹 Thumbnail Picker
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                        withData: true, // for web
                      );

                      if (result != null) {
                        if (kIsWeb) {
                          setState(() {
                            pickedBytes = result.files.single.bytes;
                          });
                        } else {
                          setState(() {
                            pickedFile = File(result.files.single.path!);
                          });
                        }
                      }
                    },
                    child: Text((pickedFile == null && pickedBytes == null)
                        ? "Pick Thumbnail"
                        : "Thumbnail Selected"),
                  ),

                  // 🔹 Thumbnail Preview
                  if (pickedFile != null || pickedBytes != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: kIsWeb
                          ? Image.memory(pickedBytes!, height: 120, width: 120, fit: BoxFit.cover)
                          : Image.file(pickedFile!, height: 120, width: 120, fit: BoxFit.cover),
                    ),

                  const SizedBox(height: 24),

                  // 🔹 Create Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                        if (titleController.text.isEmpty ||
                            (pickedFile == null && pickedBytes == null)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Title and thumbnail are required")),
                          );
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        try {
                          final response = await seriesService.createSeries(
                            title: titleController.text,
                            description: descriptionController.text,
                            file: pickedFile,
                            bytes: pickedBytes,
                          );

                          debugPrint("Created series: $response");
                          if (onCreated != null) onCreated();
                          Navigator.pop(context);
                        } catch (e) {
                          debugPrint("Error creating series: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to create series: $e")),
                          );
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
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
