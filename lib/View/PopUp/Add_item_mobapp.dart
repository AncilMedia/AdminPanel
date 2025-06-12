import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import '../../Controller/Item_controller_add.dart'; // ✅ Your API controller

class ItemDetailsDialog extends StatefulWidget {
  final Map<String, dynamic> item;

  const ItemDetailsDialog({super.key, required this.item});

  @override
  State<ItemDetailsDialog> createState() => _ItemDetailsDialogState();
}

class _ItemDetailsDialogState extends State<ItemDetailsDialog> {
  late TextEditingController _urlController;
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;

  Uint8List? _imageBytes;
  String? _imageName;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item['title'] ?? '');
    _subtitleController = TextEditingController(
      text: widget.item['subtitle'] ?? '',
    );
    _urlController = TextEditingController(text: widget.item['url'] ?? '');

    if (widget.item['image'] is Uint8List) {
      _imageBytes = widget.item['image'];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _pickImageFromDevice() {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((event) {
          setState(() {
            _imageBytes = reader.result as Uint8List;
            _imageName = file.name;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String url = _urlController.text.trim();

    return AlertDialog(
      backgroundColor: const Color(0xFFEAE7DD),
      title: Text(
        widget.item['_id'] == null
            ? "New Item"
            : "Edit: ${_titleController.text}",
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      content: SizedBox(
        width: 600,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Form
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: GoogleFonts.poppins(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _subtitleController,
                    decoration: InputDecoration(
                      labelText: 'Subtitle',
                      labelStyle: GoogleFonts.poppins(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _urlController,
                          decoration: InputDecoration(
                            labelText: 'External URL',
                            labelStyle: GoogleFonts.poppins(),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          IconButton(
                            tooltip: "Copy URL",
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: url));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("URL copied")),
                              );
                            },
                          ),
                          IconButton(
                            tooltip: "Open in New Tab",
                            icon: const Icon(Icons.open_in_new),
                            onPressed: () {
                              if (url.isNotEmpty) {
                                html.window.open(url, '_blank');
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Right Side: Image Preview
            Expanded(
              child: GestureDetector(
                onTap: _pickImageFromDevice,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _imageBytes != null
                        ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                        : widget.item['image'] is String
                        ? Image.network(
                            widget.item['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(child: Text("Image not found")),
                          )
                        : const Center(child: Text("Tap to upload image")),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              // Cancel
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
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
              // Save
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.green.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () async {
                    final title = _titleController.text.trim();

                    if (title.isEmpty) {
                      debugPrint('[Error] Title is required');
                      return;
                    }

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    final updatedItem = {
                      '_id': widget.item['_id'],
                      'title': title,
                      'subtitle': _subtitleController.text.trim(),
                      'url': _urlController.text.trim(),
                    };

                    try {
                      await ItemController.saveItem(
                        updatedItem,
                        _imageBytes,
                        _imageName,
                      );
                      debugPrint('[Success] Item saved: $updatedItem');

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Item saved successfully!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }

                      Navigator.of(context)
                        ..pop() // Close loading dialog
                        ..pop(updatedItem); // Close item dialog
                    } catch (e) {
                      Navigator.of(context).pop(); // Close loading dialog
                      debugPrint('[Error] Failed to save item: $e');
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    alignment: Alignment.center,
                    child: Text(
                      "Save",
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
        ),
      ],
    );
  }
}
