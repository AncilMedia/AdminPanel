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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _UrlController = TextEditingController();

  Uint8List? imageBytes;
  String? imageName;
  bool isLoading = false;

  void pickImageWeb() {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((event) {
          if (reader.result != null) {
            setState(() {
              imageBytes = reader.result as Uint8List;
              imageName = file.name;
              _imageUrlController.clear(); // Clear URL input if file is picked
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _UrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasUrl = _imageUrlController.text.trim().isNotEmpty;
    final imageWidget = imageBytes != null
        ? Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            imageBytes!,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => setState(() => imageBytes = null),
            tooltip: "Remove image",
          ),
        )
      ],
    )
        : hasUrl
        ? Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            _imageUrlController.text.trim(),
            height: 100,
            width: 100,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
            const Icon(Icons.broken_image, size: 40),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => setState(() => _imageUrlController.clear()),
            tooltip: "Clear URL",
          ),
        )
      ],
    )
        : const SizedBox(
      width: 100,
      height: 100,
      child: Center(
        child: Icon(Icons.image, size: 40, color: Colors.grey),
      ),
    );

    return AlertDialog(
      backgroundColor: const Color(0xFFEAE7DD),
      title: Text(
        "Add New Item",
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      content: SizedBox(
        width: 550,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form
              Expanded(
                child: AbsorbPointer(
                  absorbing: isLoading,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: GoogleFonts.poppins(),
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _imageUrlController,
                              decoration: InputDecoration(
                                labelText: "Image URL",
                                labelStyle: GoogleFonts.poppins(),
                                border: const OutlineInputBorder(),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                              ),
                              onChanged: (_) => setState(() {
                                imageBytes = null;
                              }),
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
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _UrlController,
                        decoration: InputDecoration(
                          labelText: "External Url",
                          labelStyle: GoogleFonts.poppins(),
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Image Preview
              imageWidget,
            ],
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            // Cancel
            Expanded(
              child: InkWell(
                onTap: () {
                  if (!isLoading) Navigator.pop(context);
                },
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
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Add
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
                onPressed: isLoading
                    ? null
                    : () async {
                  final title = _titleController.text.trim();
                  final imageUrl = _imageUrlController.text.trim();
                  final externalUrl = _UrlController.text.trim();

                  if (title.isEmpty) {
                    debugPrint('[Error] Title is empty');
                    return;
                  }

                  if (imageBytes == null && imageUrl.isEmpty) {
                    debugPrint('[Error] No image provided');
                    return;
                  }

                  setState(() => isLoading = true);

                  try {
                    final uploadedImageUrl = await AddItemController.uploadItem(
                      title: title,
                      imageBytes: imageBytes,
                      imageUrl: imageBytes == null ? imageUrl : null,
                      externalUrl: externalUrl, // 👈 passed to controller
                    );

                    if (uploadedImageUrl != null) {
                      print('[Success] Item uploaded: $uploadedImageUrl');
                      if (context.mounted) {
                        Navigator.pop<Map<String, dynamic>>(context, {
                          'title': title,
                          'image': uploadedImageUrl,
                          'externalUrl': externalUrl, // 👈 returned to caller
                          if (imageName != null) 'imageName': imageName,
                        });
                      }
                    } else {
                      print('[Error] Upload failed: returned null');
                    }
                  } catch (e) {
                    print('[Exception] Upload error: $e');
                  } finally {
                    if (mounted) setState(() => isLoading = false);
                  }
                },
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text(
                    "Add",
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w500),
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
