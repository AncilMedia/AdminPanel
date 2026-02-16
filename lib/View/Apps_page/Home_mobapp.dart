import 'dart:convert';
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

  // ===== Layout Builder State =====
  String selectedLayout = "none";

  Map<String, dynamic> layoutConfig = {
    "layoutType": null,
    "components": [],
    "settings": {},
  };

  Map<String, dynamic> buildBackendPayload() {
    return {
      "projectId": "demo_project_001",
      "page": "home",
      "layout": layoutConfig,
      "meta": {
        "user": "admin",
        "platform": "flutter_web",
        "timestamp": DateTime.now().toIso8601String(),
      },
    };
  }

  Future<void> _sendLayoutToBackend() async {
    final payload = buildBackendPayload();

    debugPrint("=========== BACKEND PAYLOAD ===========");
    debugPrint(jsonEncode(payload));
    debugPrint("======================================");

    /*
    final response = await http.post(
      Uri.parse("https://your-backend.com/api/layout"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );
    */
  }

  // ================= FILTER LOGIC =================

  List<String> getUniqueOrganizations() {
    final orgSet = <String>{};
    for (var item in widget.items) {
      final name = item['organizationName'];
      if (name != null && name.toString().isNotEmpty) {
        orgSet.add(name.toString());
      }
    }
    return ['All', ...orgSet.toList()..sort()];
  }

  List<Map<String, dynamic>> get filteredItems {
    return widget.items.where((item) {
      final orgName = (item['organizationName'] ?? 'Unknown').toString();
      final matchesOrg = selectedOrg == 'All' || orgName == selectedOrg;
      final matchesSearch =
      orgName.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesOrg && matchesSearch;
    }).toList();
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    /// group items by org
    final Map<String, List<Map<String, dynamic>>> groupedItems = {};

    for (int i = 0; i < filteredItems.length; i++) {
      final item = filteredItems[i];
      final orgName = (item['organizationName'] ?? 'Unknown').toString();

      groupedItems.putIfAbsent(orgName, () => []);
      groupedItems[orgName]!.add({
        ...item,
        '_originalIndex': widget.items.indexOf(item),
      });
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
            // ================= LEFT PANEL =================
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    // 🔍 Filter & Search
                    Row(
                      children: [
                        Text(
                          "Filter by Company:",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
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
                            if (!mounted) return;
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
                              if (!mounted) return;
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search company name',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "Content",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(),

                    InkWell(
                      onTap: widget.onOpenDrawer,
                      child: Row(
                        children: [
                          const Icon(Iconsax.add_circle),
                          const SizedBox(width: 8),
                          Text(
                            "Add Item",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ================= EMPTY STATE =================
                    if (filteredItems.isEmpty)
                      Center(
                        child: SizedBox(
                          height: 200,
                          child: Lottie.asset(
                            'assets/Animation - 1749442430422.json',
                            frameRate: FrameRate.max,
                          ),
                        ),
                      )
                    else
                      ...groupedItems.entries.map((entry) {
                        final orgName = entry.key;
                        final orgItems = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
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

                            // ================= REORDER LIST =================
                            ReorderableListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              buildDefaultDragHandles: false,
                              itemCount: orgItems.length,
                              onReorder: (oldIndex, newIndex) {
                                if (newIndex > oldIndex) newIndex--;

                                final oldOriginal =
                                orgItems[oldIndex]['_originalIndex'];
                                final newOriginal =
                                orgItems[newIndex]['_originalIndex'];

                                widget.onReorder(oldOriginal, newOriginal);
                              },
                              itemBuilder: (context, index) {
                                final item = orgItems[index];
                                final originalIndex =
                                item['_originalIndex'] as int;

                                Widget imageWidget;

                                if (item['image'] is Uint8List) {
                                  imageWidget = Image.memory(
                                    item['image'],
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  );
                                } else if (item['image'] != null &&
                                    item['image'].toString().isNotEmpty) {
                                  imageWidget = Image.network(
                                    Uri.decodeFull(item['image'].toString()),
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _errorImage(),
                                  );
                                } else {
                                  imageWidget = _errorImage();
                                }

                                return ListTile(
                                  key: ValueKey('item_$originalIndex'),
                                  onTap: () => widget
                                      .onShowItemDetails(originalIndex),
                                  leading: ReorderableDragStartListener(
                                    index: index,
                                    child: const Icon(Iconsax.element_3),
                                  ),
                                  title: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(12),
                                        child: imageWidget,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item['title'] ?? 'No title',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
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
            ),

            const SizedBox(width: 20),

            // ================= RIGHT PANEL =================
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Preview
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mobile Preview",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),

                          Center(
                            child: Container(
                              width: 260,
                              height: 520,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 22,
                                      width: 120,
                                      margin: const EdgeInsets.only(top: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: _renderMobileLayout(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Layout Builder
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade200,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Layout Builder",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Apply",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _layoutButton("Row"),
                              _layoutButton("Column"),
                              _layoutButton("Stack"),
                            ],
                          ),

                          const SizedBox(height: 14),

                          Text(
                            "Selected Layout:",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Text(
                              selectedLayout.toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Settings
                    Container(
                      height: MediaQuery.of(context).size.height * .25,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade100,
                      ),
                      child: Center(
                        child: Text(
                          "Settings Panel",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Widget _errorImage() {
    return Container(
      width: 50,
      height: 50,
      color: Colors.grey.shade300,
      child: const Icon(Icons.image_not_supported),
    );
  }


  Widget _componentTile(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const Icon(Iconsax.add),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
  // ================= SELECTABLE LAYOUT BUTTON =================
  Widget _layoutButton(String title) {
    final isSelected = selectedLayout == title.toLowerCase();

    return InkWell(
      onTap: () {
        setState(() {
          selectedLayout = title.toLowerCase();

          layoutConfig = {
            "layoutType": selectedLayout,
            "components": [],
            "settings": {"updatedAt": DateTime.now().toIso8601String()},
          };
        });

        _sendLayoutToBackend();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.blue : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // ================= MOBILE LAYOUT RENDERER =================
  Widget _renderMobileLayout() {
    if (selectedLayout == "row") {
      return Row(children: [_mobileBox("A"), _mobileBox("B"), _mobileBox("C")]);
    }

    if (selectedLayout == "column") {
      return Column(
        children: [_mobileBox("A"), _mobileBox("B"), _mobileBox("C")],
      );
    }

    if (selectedLayout == "stack") {
      return Stack(
        children: [
          _mobileStackBox("Bottom"),
          Positioned(top: 40, left: 40, child: _mobileStackBox("Middle")),
          Positioned(top: 80, left: 80, child: _mobileStackBox("Top")),
        ],
      );
    }

    return Center(
      child: Text(
        "Select Layout",
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _mobileBox(String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: Text(text, style: GoogleFonts.poppins())),
      ),
    );
  }

  Widget _mobileStackBox(String text) {
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.green.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: Text(text, style: GoogleFonts.poppins())),
    );
  }
}
