import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/Media_Item_controller.dart';
import '../Controller/Media_Series_controller.dart';
import '../View/PopUp/Right_drawer.dart';


Future<void> showCreateMediaItemDialog(
    BuildContext context,
    MediaItemService itemService,
    MediaSeriesService seriesService,
    ) async {
  String? selectedSeries;
  String mediaSource = "file";
  bool isUploading = false;

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
    mediaSeries = await seriesService.getSeriesByFilter(organizationId: orgId);
  } catch (e) {
    debugPrint("⚠️ Series Fetch Error: $e");
  }

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(28),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New Media Item",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade900,
                      ),
                    ),
                    if (!isUploading)
                      IconButton(
                        icon: const Icon(Iconsax.close_circle, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                  ],
                ),
                const Divider(height: 32),

                _buildLabel("Title"),
                _modernInput(titleController, "Enter media title", Iconsax.video_play),

                _buildLabel("Description"),
                _modernInput(descriptionController, "Brief description...", Iconsax.document_text, maxLines: 2),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _modernDropdown(
                        label: "Series",
                        value: selectedSeries,
                        hint: "Select Series",
                        icon: Iconsax.folder_2,
                        items: mediaSeries.map((s) => DropdownMenuItem(
                          value: s["_id"].toString(),
                          child: Text(s["title"] ?? "Untitled", style: const TextStyle(fontSize: 13)),
                        )).toList(),
                        onChanged: (val) => setState(() => selectedSeries = val),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _modernDropdown(
                        label: "Source",
                        value: mediaSource,
                        hint: "Select Source",
                        icon: Iconsax.link_1,
                        items: const [
                          DropdownMenuItem(value: "file", child: Text("Local File", style: TextStyle(fontSize: 13))),
                          DropdownMenuItem(value: "youtube", child: Text("YouTube", style: TextStyle(fontSize: 13))),
                          DropdownMenuItem(value: "vimeo", child: Text("Vimeo", style: TextStyle(fontSize: 13))),
                        ],
                        onChanged: (val) => setState(() => mediaSource = val!),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                _buildLabel("Media Content"),
                if (mediaSource == "file")
                  _modernPicker(
                    label: pickedFile?.path.split('/').last ?? webFile?.name ?? "Pick Video File",
                    icon: Iconsax.video_add,
                    onTap: () async {
                      final res = await FilePicker.platform.pickFiles(type: FileType.video);
                      if (res != null) {
                        setState(() {
                          if (kIsWeb) webFile = res.files.single;
                          else pickedFile = File(res.files.single.path!);
                        });
                      }
                    },
                  )
                else
                  _modernInput(mediaUrlController, "Paste $mediaSource URL", Iconsax.link),

                const SizedBox(height: 16),
                _buildLabel("Thumbnail"),
                _modernPicker(
                  label: thumbnailFile?.path.split('/').last ?? webThumbnailFile?.name ?? "Pick Image",
                  icon: Iconsax.image,
                  onTap: () async {
                    final res = await FilePicker.platform.pickFiles(type: FileType.image);
                    if (res != null) {
                      setState(() {
                        if (kIsWeb) webThumbnailFile = res.files.single;
                        else thumbnailFile = File(res.files.single.path!);
                      });
                    }
                  },
                ),

                const SizedBox(height: 32),

                // --- ACTION BUTTON ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    onPressed: isUploading ? null : () async {
                      if (titleController.text.trim().isEmpty) {
                        showCustomSnackBar(context, "Please provide a title", false);
                        return;
                      }

                      setState(() => isUploading = true);

                      try {
                        await itemService.createMediaItem(
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                          seriesId: selectedSeries,
                          source: mediaSource,
                          mediaUrl: mediaUrlController.text.trim(),
                          file: pickedFile,
                          webFile: webFile,
                          thumbnailFile: thumbnailFile,
                          webThumbnailFile: webThumbnailFile,
                        );

                        if (context.mounted) {
                          showCustomSnackBar(context, "Success! '${titleController.text}' added.", true);
                          Navigator.pop(context, true);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          setState(() => isUploading = false);
                          showCustomSnackBar(context, "Creation failed: $e", false);
                        }
                      }
                    },
                    child: isUploading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                        : Text(
                      "Create Media Item",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
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

// --- HELPER UI WIDGETS ---
Widget _buildLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Text(text, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade700)),
  );
}

Widget _modernInput(TextEditingController controller, String hint, IconData icon, {int maxLines = 1}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
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
      ),
    ),
  );
}

Widget _modernDropdown({required String label, required String? value, required String hint, required IconData icon, required List<DropdownMenuItem<String>> items, required Function(String?) onChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel(label),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            icon: const Icon(Iconsax.arrow_down_1, size: 16),
            hint: Text(hint, style: const TextStyle(fontSize: 13)),
            items: items,
            onChanged: onChanged,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ),
    ],
  );
}

Widget _modernPicker({required String label, required IconData icon, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.indigo.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.indigo),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.indigo.shade800), overflow: TextOverflow.ellipsis)),
        ],
      ),
    ),
  );
}