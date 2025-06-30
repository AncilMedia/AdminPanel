import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

class HomeContent extends StatelessWidget {
  final BoxConstraints constraints;
  final List<Map<String, dynamic>> items;
  // final void Function() onAddItem;
  final void Function(int index) onShowItemDetails;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(int index) onRemoveItem;
  final void Function() onOpenDrawer; // 👈 Callback to open drawer

  const HomeContent({
    super.key,
    required this.constraints,
    required this.items,
    // required this.onAddItem,
    required this.onShowItemDetails,
    required this.onReorder,
    required this.onRemoveItem,
    required this.onOpenDrawer, // 👈 Required callback
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Padding(
        padding: EdgeInsets.all(constraints.maxWidth * 0.02),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Panel
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Content",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Divider(),

                  // 👉 "Add Item" with drawer opener
                  InkWell(
                    onTap: onOpenDrawer, // 👈 Trigger drawer
                    child: Row(
                      children: [
                        const Icon(Iconsax.add_circle),
                        const SizedBox(width: 8),
                        Text(
                          "Add Item",
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 👉 Empty / List Section
                  if (items.isEmpty)
                    Center(
                      child: Lottie.asset('assets/Animation - 1749442430422.json'),
                    )
                  else
                    ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      onReorder: onReorder,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final imageWidget = item['image'] is Uint8List
                            ? Image.memory(item['image'], height: 50, width: 50, fit: BoxFit.cover)
                            : (item['image'] != null && item['image'].toString().isNotEmpty
                            ? Image.network(
                          Uri.decodeFull(item['image']),
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.broken_image),
                          ),
                        )
                            : Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported),
                        ));

                        return ListTile(
                          key: ValueKey('item_$index'),
                          onTap: () => onShowItemDetails(index),
                          leading: ReorderableDragStartListener(
                            index: index,
                            child: const Icon(Iconsax.element_3),
                          ),
                          title: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: imageWidget,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item['title'],
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Iconsax.more),
                                onSelected: (value) {
                                  if (value == 'Remove') {
                                    onRemoveItem(index);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem<String>(
                                    value: 'Remove',
                                    child: Text('Remove'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Right Panel
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade50,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: MediaQuery.of(context).size.height * .3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade50,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
