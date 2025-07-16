import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

class HomeContent extends StatefulWidget {
  final BoxConstraints constraints;
  final List<Map<String, dynamic>> items;
  final void Function(int index) onShowItemDetails;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(int index) onRemoveItem;
  final void Function() onOpenDrawer;

  const HomeContent({
    super.key,
    required this.constraints,
    required this.items,
    required this.onShowItemDetails,
    required this.onReorder,
    required this.onRemoveItem,
    required this.onOpenDrawer,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String selectedOrg = 'All';
  String searchQuery = '';

  List<String> getUniqueOrganizations() {
    final orgSet = <String>{};
    for (var item in widget.items) {
      orgSet.add(item['organizationName'] ?? 'Unknown');
    }
    return ['All', ...orgSet.toList()..sort()];
  }

  List<Map<String, dynamic>> get filteredItems {
    return widget.items.where((item) {
      final orgName = item['organizationName'] ?? 'Unknown';
      final matchesOrg = selectedOrg == 'All' || orgName == selectedOrg;
      final matchesSearch = orgName.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesOrg && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final groupedItems = <String, List<Map<String, dynamic>>>{};

    for (int i = 0; i < filteredItems.length; i++) {
      final item = filteredItems[i];
      final orgName = item['organizationName'] ?? 'Unknown';
      groupedItems.putIfAbsent(orgName, () => []);
      groupedItems[orgName]!.add({...item, '_originalIndex': widget.items.indexOf(item)});
    }

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.constraints.maxWidth * 0.02),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Panel
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔍 Filter & Search
                  Row(
                    children: [
                      Text(
                        "Filter by Company: ",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: selectedOrg,
                        items: getUniqueOrganizations().map((org) {
                          return DropdownMenuItem<String>(
                            value: org,
                            child: Text(org),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedOrg = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search company name',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text("Content", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                  const Divider(),

                  InkWell(
                    onTap: widget.onOpenDrawer,
                    child: Row(
                      children: [
                        const Icon(Iconsax.add_circle),
                        const SizedBox(width: 8),
                        Text("Add Item", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (filteredItems.isEmpty)
                    Center(child: Lottie.asset('assets/Animation - 1749442430422.json'))
                  else
                    ...groupedItems.entries.map((entry) {
                      final orgName = entry.key;
                      final orgItems = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              orgName,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          ReorderableListView.builder(
                            shrinkWrap: true,
                            buildDefaultDragHandles: false,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orgItems.length,
                            onReorder: (oldIndex, newIndex) {
                              widget.onReorder(
                                orgItems[oldIndex]['_originalIndex'],
                                orgItems[newIndex]['_originalIndex'],
                              );
                            },
                            itemBuilder: (context, index) {
                              final item = orgItems[index];
                              final originalIndex = item['_originalIndex'];

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
                                key: ValueKey('item_$originalIndex'),
                                onTap: () => widget.onShowItemDetails(originalIndex),
                                leading: ReorderableDragStartListener(
                                  index: index,
                                  child: const Icon(Iconsax.element_3),
                                ),
                                title: Row(
                                  children: [
                                    ClipRRect(borderRadius: BorderRadius.circular(12), child: imageWidget),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item['title'],
                                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Tooltip(
                                      message: orgName,
                                      child: Text(
                                        orgName,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: const Icon(Iconsax.more),
                                      onSelected: (value) {
                                        if (value == 'Remove') {
                                          widget.onRemoveItem(originalIndex);
                                        }
                                      },
                                      itemBuilder: (context) => const [
                                        PopupMenuItem<String>(
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
                      );
                    }).toList(),
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
