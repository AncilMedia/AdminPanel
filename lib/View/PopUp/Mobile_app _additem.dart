import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/Add_item_controller.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  String title = '';
  String imageUrl = '';
  Uint8List? imageBytes;

  void pickImageWeb() {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((event) {
          setState(() {
            imageBytes = reader.result as Uint8List;
            imageUrl = '';
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = imageBytes != null
        ? ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.memory(
        imageBytes!,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      ),
    )
        : imageUrl.isNotEmpty
        ? ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
        const Icon(Icons.broken_image, size: 40),
      ),
    )
        : const SizedBox(width: 100, height: 100);

    return AlertDialog(
      backgroundColor: const Color(0xFFEAE7DD),
      title: Text(
        "Add New Item",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      content: SizedBox(
        width: 550,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left form
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Shrinks vertically
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: GoogleFonts.poppins(),
                        border: const OutlineInputBorder(),
                        isDense: true, // Reduces vertical space
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                      onChanged: (value) => setState(() => title = value),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Image URL",
                              labelStyle: GoogleFonts.poppins(),
                              border: const OutlineInputBorder(),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            ),
                            onChanged: (value) {
                              setState(() {
                                imageUrl = value;
                                imageBytes = null;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.upload_file),
                          tooltip: "Pick Image",
                          onPressed: () {
                            if (kIsWeb) pickImageWeb();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Right image
              imageWidget,
            ],
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red.withOpacity(0.1),
                  ),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.withOpacity(0.1),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  if (title.isNotEmpty && (imageUrl.isNotEmpty || imageBytes != null)) {
                    final uploadedImageUrl = await AddItemController.uploadItem(
                      title: title,
                      imageBytes: imageBytes,
                      imageUrl: imageBytes == null ? imageUrl : null,
                    );

                    if (uploadedImageUrl != null) {
                      Navigator.pop<Map<String, dynamic>>(context, {
                        'title': title,
                        'image': uploadedImageUrl,
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to upload item')),
                      );
                    }
                  }
                },


                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    "Add",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
