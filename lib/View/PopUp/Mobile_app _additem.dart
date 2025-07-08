import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Controller/Add_item_controller.dart';

class AddItemDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialSubtitle;
  final String? initialImage;
  final String? initialUrl;
  final String? initialType;
  final String? itemId;

  const AddItemDialog({
    super.key,
    this.initialTitle,
    this.initialSubtitle,
    this.initialImage,
    this.initialUrl,
    this.initialType,
    required this.itemId,
  });

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _urlController;

  Uint8List? imageBytes;
  String? imageName;
  bool isLoading = false;
  late String selectedType;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _subtitleController = TextEditingController(text: widget.initialSubtitle ?? '');
    _imageUrlController = TextEditingController(text: widget.initialImage ?? '');
    _urlController = TextEditingController(text: widget.initialUrl ?? '');
    selectedType = widget.initialType ?? 'link';
  }

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
              _imageUrlController.clear();
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _imageUrlController.dispose();
    _urlController.dispose();
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
            height: 160,
            width: 160,
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
            height: 160,
            width: 160,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
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
      width: 160,
      height: 160,
      child: Center(
        child: Icon(Icons.image, size: 50, color: Colors.grey),
      ),
    );

    return AlertDialog(
      backgroundColor: const Color(0xFFEAE7DD),
      title: Text(
        "Update ${selectedType == 'link' ? 'Link' : 'Event'}",
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      content: SizedBox(
        width: 750,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Form Fields
              Expanded(
                child: AbsorbPointer(
                  absorbing: isLoading,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Title"),
                      _buildTextField(_titleController),
                      const SizedBox(height: 8),
                      _buildLabel("Subtitle"),
                      _buildTextField(_subtitleController),
                      const SizedBox(height: 8),
                      _buildLabel("Image URL"),
                      Row(
                        children: [
                          Expanded(child: _buildTextField(_imageUrlController, onChanged: (_) {
                            setState(() => imageBytes = null);
                          })),
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
                      _buildLabel("External URL"),
                      _buildTextField(_urlController),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Right: Image Preview
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
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
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
                onPressed: isLoading
                    ? null
                    : () async {
                  if (widget.itemId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Error: Missing item ID")),
                    );
                    return;
                  }

                  setState(() => isLoading = true);

                  final title = _titleController.text.trim();
                  final subtitle = _subtitleController.text.trim();
                  final imageUrl = _imageUrlController.text.trim();
                  final externalUrl = _urlController.text.trim();

                  try {
                    final uploadedImageUrl = await AddItemController.uploadItem(
                      itemId: widget.itemId!,
                      title: title,
                      subtitle: subtitle,
                      imageBytes: imageBytes,
                      imageUrl: imageBytes == null ? imageUrl : null,
                      externalUrl: externalUrl,
                      type: selectedType,
                    );

                    if (uploadedImageUrl != null && context.mounted) {
                      Navigator.pop<Map<String, dynamic>>(context, {
                        'title': title,
                        'subtitle': subtitle,
                        'image': uploadedImageUrl,
                        'externalUrl': externalUrl,
                        'type': selectedType,
                        if (imageName != null) 'imageName': imageName,
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to update item")),
                      );
                    }
                  } catch (e) {
                    debugPrint('[Upload error] $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
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
                    "Update",
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildTextField(TextEditingController controller, {Function(String)? onChanged}) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      ),
    );
  }
}
