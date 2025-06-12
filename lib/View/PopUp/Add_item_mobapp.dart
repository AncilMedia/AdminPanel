// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/services.dart';
// import 'dart:html' as html;
// import 'dart:typed_data';
//
// import '../../Controller/Item_controller_add.dart';
//
// class ItemDetailsDialog extends StatefulWidget {
//   final Map<String, dynamic> item;
//
//   const ItemDetailsDialog({super.key, required this.item});
//
//   @override
//   State<ItemDetailsDialog> createState() => _ItemDetailsDialogState();
// }
//
// class _ItemDetailsDialogState extends State<ItemDetailsDialog> {
//   late TextEditingController _urlController;
//   late TextEditingController _titleController;
//   late TextEditingController _subtitleController;
//
//   Uint8List? _imageBytes;
//   String? _imageName;
//
//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.item['title'] ?? '');
//     _subtitleController = TextEditingController(text: widget.item['subtitle'] ?? '');
//     _urlController = TextEditingController(text: widget.item['url'] ?? '');
//
//     // Load existing image if it's Uint8List (uploaded) or leave null
//     if (widget.item['image'] is Uint8List) {
//       _imageBytes = widget.item['image'];
//     }
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _subtitleController.dispose();
//     _urlController.dispose();
//     super.dispose();
//   }
//
//   void _pickImageFromDevice() {
//     final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
//     uploadInput.click();
//
//     uploadInput.onChange.listen((event) {
//       final file = uploadInput.files?.first;
//       if (file != null) {
//         final reader = html.FileReader();
//         reader.readAsArrayBuffer(file);
//         reader.onLoadEnd.listen((event) {
//           setState(() {
//             _imageBytes = reader.result as Uint8List;
//             _imageName = file.name;
//           });
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final String url = _urlController.text.trim();
//
//     return AlertDialog(
//       backgroundColor: const Color(0xFFEAE7DD),
//       title: Text(
//         _titleController.text.isEmpty ? "Edit Item" : _titleController.text,
//         style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
//       ),
//       content: SizedBox(
//         width: 600,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Left: Form Fields
//             Expanded(
//               flex: 2,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextFormField(
//                     controller: _titleController,
//                     decoration: InputDecoration(
//                       labelStyle: GoogleFonts.poppins(),
//                       border: const OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   TextFormField(
//                     controller: _subtitleController,
//                     decoration: InputDecoration(
//                       labelText: 'Subtitle',
//                       labelStyle: GoogleFonts.poppins(),
//                       border: const OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextFormField(
//                           controller: _urlController,
//                           decoration: InputDecoration(
//                             labelText: 'External URL',
//                             labelStyle: GoogleFonts.poppins(),
//                             border: const OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Column(
//                         children: [
//                           IconButton(
//                             tooltip: "Copy URL",
//                             icon: const Icon(Icons.copy),
//                             onPressed: () {
//                               Clipboard.setData(ClipboardData(text: url));
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text("URL copied")),
//                               );
//                             },
//                           ),
//                           IconButton(
//                             tooltip: "Open in New Tab",
//                             icon: const Icon(Icons.open_in_new),
//                             onPressed: () {
//                               if (url.isNotEmpty) {
//                                 html.window.open(url, '_blank');
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 20),
//             // Right: Image Preview
//             Expanded(
//               child: GestureDetector(
//                 onTap: _pickImageFromDevice,
//                 child: Container(
//                   height: 200,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: Colors.white,
//                     border: Border.all(color: Colors.grey.shade400),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: _imageBytes != null
//                         ? Image.memory(_imageBytes!, fit: BoxFit.cover)
//                         : widget.item['image'] is String
//                         ? Image.network(
//                       widget.item['image'],
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) => const Center(child: Text("Image not found")),
//                     )
//                         : const Center(child: Text("Tap to upload image")),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: Row(
//             children: [
//               // Cancel Button
//               Expanded(
//                 child: InkWell(
//                   onTap: () => Navigator.pop(context),
//                   borderRadius: BorderRadius.circular(20),
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * 0.05,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Colors.red.withOpacity(0.1),
//                     ),
//                     child: Text(
//                       "Cancel",
//                       style: GoogleFonts.poppins(
//                         textStyle: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               // Save Button
//               Expanded(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     elevation: 0,
//                     backgroundColor: Colors.green.withOpacity(0.1),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     padding: EdgeInsets.zero,
//                   ),
//                   // onPressed: () {
//                   //   Navigator.pop(context, {
//                   //     'title': _titleController.text.trim(),
//                   //     'subtitle': _subtitleController.text.trim(),
//                   //     'url': _urlController.text.trim(),
//                   //     'image': _imageBytes ?? widget.item['image'],
//                   //     'imageName': _imageName ?? widget.item['imageName'],
//                   //   });
//                   // },
//                   onPressed: () async {
//                     final updatedItem = {
//                       ...widget.item,
//                       'title': _titleController.text.trim(),
//                       'subtitle': _subtitleController.text.trim(),
//                       'url': _urlController.text.trim(),
//                       'image': _imageBytes ?? widget.item['image'],
//                       'imageName': _imageName ?? widget.item['imageName'],
//                     };
//
//                     // Ensure _id is present or fallback to a default (like 'new')
//                     updatedItem['_id'] ??= 'new'; // Your backend must handle this logic
//
//                     await ItemController.saveItem(updatedItem);
//
//                     print("Item saved via PUT: $updatedItem");
//
//                     Navigator.pop(context, updatedItem);
//                   },
//
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * 0.05,
//                     alignment: Alignment.center,
//                     child: Text(
//                       "Save",
//                       style: GoogleFonts.poppins(
//                         textStyle: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }



import 'dart:typed_data';
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import '../../Controller/Item_controller_add.dart'; // ✅ import your controller

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
    _subtitleController = TextEditingController(text: widget.item['subtitle'] ?? '');
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
        _titleController.text.isEmpty ? "Edit Item" : _titleController.text,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      content: SizedBox(
        width: 600,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Form
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
            // Right Image Upload
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
              // Cancel Button
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
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Save Button
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
                    final updatedItem = {
                      '_id': widget.item['_id'],
                      'title': _titleController.text.trim(),
                      'subtitle': _subtitleController.text.trim(),
                      'url': _urlController.text.trim(),
                      'image': _imageBytes ?? widget.item['image'], // <- Include this
                      'imageName': _imageName ?? widget.item['imageName'],
                    };

                    await ItemController.saveItem(updatedItem, _imageBytes, _imageName);

                    Navigator.of(context).pop(updatedItem); // <- Pass back updated item
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    alignment: Alignment.center,
                    child: Text(
                      "Save",
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
