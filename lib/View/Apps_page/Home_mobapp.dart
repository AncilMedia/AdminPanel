import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../environmental variables.dart';

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

  /// layout state
  String selectedLayout = "column";
  String? organizationId;

  @override
  void initState() {
    super.initState();
    _loadOrgAndFetchLayout();
  }

  // ================= LOAD ORG + LAYOUT =================

  Future<void> _loadOrgAndFetchLayout() async {
    final prefs = await SharedPreferences.getInstance();
    organizationId = prefs.getString('organizationId');

    if (organizationId == null) {
      debugPrint("❌ organizationId missing");
      return;
    }

    fetchLayoutFromBackend();
  }

  // ================= API =================

  Future<void> fetchLayoutFromBackend() async {
    try {
      final url = Uri.parse("$baseUrl/api/homelayout/$organizationId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final backendLayout = data['layout']?.toString().toLowerCase();

        if (mounted) {
          setState(() {
            selectedLayout = backendLayout ?? "column";
          });
        }
      } else {
        setState(() => selectedLayout = "column");
      }
    } catch (e) {
      debugPrint("❌ Fetch Layout Error: $e");
      setState(() => selectedLayout = "column");
    }
  }

  Future<void> updateLayoutBackend(String layout) async {
    try {
      final url = Uri.parse("$baseUrl/api/homelayout/$organizationId");

      await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"layout": layout}),
      );
    } catch (e) {
      debugPrint("❌ Update Layout Error: $e");
    }
  }

  // ================= FILTER =================

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
                  children: [
                    /// FILTER BAR
                    Row(
                      children: [
                        Text("Filter:", style: GoogleFonts.poppins()),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: selectedOrg,
                          items: getUniqueOrganizations()
                              .map((org) => DropdownMenuItem(
                            value: org,
                            child: Text(org),
                          ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => selectedOrg = value);
                            }
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            onChanged: (v) =>
                                setState(() => searchQuery = v),
                            decoration: InputDecoration(
                              hintText: 'Search',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// ADD ITEM
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
                  children: [
                    /// MOBILE PREVIEW
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Mobile Preview",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          Center(
                            child: Container(
                              width: 260,
                              height: 520,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: _renderMobileLayout(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// LAYOUT BUILDER
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade200,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Layout Builder",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600)),
                              InkWell(
                                onTap: () async {
                                  await updateLayoutBackend(selectedLayout);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Applied ${selectedLayout.toUpperCase()} layout")),
                                  );
                                },
                                child: Text("Apply",
                                    style: GoogleFonts.poppins(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            children: [
                              _layoutButton("Row"),
                              _layoutButton("Column"),
                              _layoutButton("Stack"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= MOBILE PREVIEW =================

  Widget _renderMobileLayout() {
    final previewItems = filteredItems.take(5).toList();

    if (previewItems.isEmpty) {
      return Center(child: Text("No content"));
    }

    switch (selectedLayout) {
      case "row":
        return _mobileRowPreview(previewItems);
      case "stack":
        return _mobileStackPreview(previewItems);
      case "column":
      default:
        return _mobileColumnPreview(previewItems);
    }
  }

  Widget _mobileColumnPreview(List<Map<String, dynamic>> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                _previewImage(item),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black87, Colors.transparent],
                      ),
                    ),
                    child: Text(item['title'] ?? '',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _mobileRowPreview(List<Map<String, dynamic>> items) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: items.map((item) {
        return Container(
          width: 120,
          margin: const EdgeInsets.only(right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 9 / 12,
                  child: _previewImage(item),
                ),
              ),
              const SizedBox(height: 4),
              Text(item['title'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontSize: 11)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _mobileStackPreview(List<Map<String, dynamic>> items) {
    return Stack(
      children: items.take(3).toList().asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;

        return Positioned(
          top: i * 25,
          left: i * 25,
          right: i * 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                children: [
                  _previewImage(item),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black87, Colors.transparent],
                        ),
                      ),
                      child: Text(item['title'] ?? '',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _previewImage(Map<String, dynamic> item) {
    final img = item['image'];

    if (img != null && img.toString().isNotEmpty) {
      return Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: Image.network(
          img.toString(),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _errorImage(),
        ),
      );
    }
    return _errorImage();
  }

  Widget _errorImage() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey.shade300,
      child: const Icon(Icons.image_not_supported),
    );
  }

  Widget _layoutButton(String title) {
    final key = title.toLowerCase();
    final isSelected = selectedLayout == key;

    return InkWell(
      onTap: () {
        setState(() {
          selectedLayout = key;
        });
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
}
