import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../View_model/Custom_snackbar.dart';
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
  String selectedLayout = "column";
  String? organizationId;

  @override
  void initState() {
    super.initState();
    _loadOrgAndFetchLayout();
    fetchNavigation();
    print("organization : $organizationId");
  }

  List<dynamic> navItems = [];
  bool navLoading = true;

  Future<void> fetchNavigation() async {
    try {
      final url = Uri.parse("$baseUrl/api/navigation/organization/$organizationId");

      final response = await http.get(url);

      // 🔎 Print response info
      debugPrint("Navigation API URL: $url");
      debugPrint("Navigation Status Code: ${response.statusCode}");
      debugPrint("Navigation Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        debugPrint("Decoded Navigation Data: $data");

        setState(() {
          navItems = data['navItems'] ?? [];
          navLoading = false;
        });

        debugPrint("Nav Items Loaded: $navItems");
      } else {
        debugPrint("Navigation API failed with status: ${response.statusCode}");

        setState(() {
          navLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Navigation load error: $e");

      setState(() {
        navLoading = false;
      });
    }
  }

  // ================= DATA LOGIC =================

  // Future<void> _loadOrgAndFetchLayout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   // Read saved organizationId
  //   organizationId = prefs.getString('organizationId');
  //
  //   debugPrint("Loaded organizationId: $organizationId");
  //
  //   if (organizationId != null && organizationId!.isNotEmpty) {
  //     fetchLayoutFromBackend();
  //     fetchNavigation();
  //   } else {
  //     debugPrint("❌ organizationId not found in SharedPreferences");
  //     setState(() {
  //       navLoading = false;
  //     });
  //   }
  // }
  Future<void> _loadOrgAndFetchLayout() async {
    final prefs = await SharedPreferences.getInstance();

    organizationId = prefs.getString('organizationId');

    debugPrint("Loaded organizationId: $organizationId");

    if (organizationId != null && organizationId!.isNotEmpty) {
      await fetchLayoutFromBackend();
      await fetchNavigation();
    } else {
      debugPrint("❌ organizationId not found in SharedPreferences");

      setState(() {
        navLoading = false;
      });
    }
  }

  Future<void> fetchLayoutFromBackend() async {
    try {
      final url = Uri.parse("$baseUrl/api/homelayout/$organizationId");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) setState(() => selectedLayout = data['layout']?.toString().toLowerCase() ?? "column");
      }
    } catch (e) {
      debugPrint("❌ Fetch Layout Error: $e");
    }
  }

  Future<void> updateLayoutBackend(String layout) async {
    try {
      final url = Uri.parse("$baseUrl/api/homelayout/$organizationId");

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"layout": layout}),
      );

      if (response.statusCode == 200) {
        // ✅ Success Snackbar
        showCustomSnackBar(
            context,
            "Layout updated to ${layout.toUpperCase()} successfully!",
            true
        );
      } else {
        // ❌ Server Error Snackbar
        showCustomSnackBar(
            context,
            "Failed to update layout. Please try again.",
            false
        );
      }
    } catch (e) {
      debugPrint("❌ Update Layout Error: $e");
      // ❌ Connection/Network Error Snackbar
      showCustomSnackBar(
          context,
          "Connection error. Check your internet.",
          false
      );
    }
  }
  List<String> getUniqueOrganizations() {
    final orgSet = <String>{};
    for (var item in widget.items) {
      final name = item['organizationName'];
      if (name != null && name.toString().isNotEmpty) orgSet.add(name.toString());
    }
    return ['All', ...orgSet.toList()..sort()];
  }

  List<Map<String, dynamic>> get filteredItems {
    return widget.items.where((item) {
      final orgName = (item['organizationName'] ?? 'Unknown').toString();
      final matchesOrg = selectedOrg == 'All' || orgName == selectedOrg;
      final matchesSearch = item['title'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return matchesOrg && matchesSearch;
    }).toList();
  }

  // ================= MAIN BUILD =================

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> groupedItems = {};
    for (var item in filteredItems) {
      final orgName = (item['organizationName'] ?? 'Unknown').toString();
      groupedItems.putIfAbsent(orgName, () => []);
      groupedItems[orgName]!.add({...item, '_originalIndex': widget.items.indexOf(item)});
    }

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FD),
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: SingleChildScrollView( // Add scrolling to the whole view if content exceeds screen
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT PANEL: CONTENT
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  const SizedBox(height: 24),
                  _buildFilterBar(),
                  const SizedBox(height: 16),
                  if (filteredItems.isEmpty)
                    _buildEmptyState()
                  else
                  // Using Column instead of ListView inside a SingleChildScrollView
                  // or ListView with shrinkWrap: true to avoid the layout crash.
                    Column(
                      children: groupedItems.entries.map((e) => _buildOrgGroup(e.key, e.value)).toList(),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 32),
            // RIGHT PANEL: PREVIEW
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildMobilePreviewFrame(),
                  const SizedBox(height: 24),
                  _buildLayoutSelector(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI COMPONENTS =================

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Home Content", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("Drag to reorder items for your mobile app", style: GoogleFonts.poppins(fontSize: 13, color: Colors.blueGrey)),
        ]),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: widget.onOpenDrawer,
          icon: const Icon(Iconsax.add_square, size: 20),
          label: Text("Add Item", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: Row(children: [
        const Icon(Iconsax.filter_search, size: 20, color: Colors.blueAccent),
        const SizedBox(width: 12),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedOrg,
            items: getUniqueOrganizations().map((org) => DropdownMenuItem(value: org, child: Text(org, style: GoogleFonts.poppins(fontSize: 14)))).toList(),
            onChanged: (v) => setState(() => selectedOrg = v!),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            onChanged: (v) => setState(() => searchQuery = v),
            decoration: const InputDecoration(hintText: "Search records...", border: InputBorder.none),
          ),
        ),
      ]),
    );
  }

  Widget _buildOrgGroup(String name, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(children: [
            Container(width: 4, height: 16, decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blueGrey)),
          ]),
        ),

        // FIXED: Removed shrinkWrap conflict by using buildDefaultDragHandles: false
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false, // <--- 1. This removes the default icon
          itemCount: items.length,
          onReorder: (oldIdx, newIdx) {
            if (newIdx > oldIdx) newIdx--;
            widget.onReorder(items[oldIdx]['_originalIndex'], items[newIdx]['_originalIndex']);
          },
          itemBuilder: (context, index) => _buildDraggableTile(items[index], index),
        ),
      ],
    );
  }

  Widget _buildDraggableTile(Map<String, dynamic> item, int index) {
    return Container(
      key: ValueKey('item_${item['_originalIndex']}'),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        onTap: () => widget.onShowItemDetails(item['_originalIndex']),

        // 2. This listener makes YOUR icon the only way to drag
        leading: ReorderableDragStartListener(
          index: index,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Iconsax.element_2, color: Colors.blueAccent, size: 22),
          ),
        ),

        title: Row(
          children: [
            _buildItemImage(item['image']),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['title'] ?? '',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Iconsax.more, size: 18),
              onSelected: (v) => widget.onRemoveItem(item['_originalIndex']),
              itemBuilder: (_) => [const PopupMenuItem(value: 'Remove', child: Text("Remove"))],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage(dynamic img) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: img is Uint8List
          ? Image.memory(img, height: 40, width: 40, fit: BoxFit.cover)
          : (img != null && img.toString().isNotEmpty)
          ? Image.network(img.toString(), height: 40, width: 40, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _errorIcon())
          : _errorIcon(),
    );
  }

  Widget _errorIcon() => Container(width: 40, height: 40, color: Colors.grey.shade100, child: const Icon(Icons.image_not_supported, size: 16));

  Widget _buildMobilePreviewFrame() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Iconsax.mobile, size: 18, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Text(
                "Live Preview",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// PHONE FRAME
          Container(
            width: 230,
            height: 460,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: Colors.black, width: 6),
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),

              child: Column(
                children: [

                  /// HOME CONTENT
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: _renderMobileLayout(),
                    ),
                  ),

                  /// BOTTOM NAVIGATION PREVIEW
                  _mobileBottomNavPreview(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLayoutSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue.shade700, Colors.blue.shade900]), borderRadius: BorderRadius.circular(24)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Display Layout", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          IconButton(onPressed: () => updateLayoutBackend(selectedLayout), icon: const Icon(Iconsax.tick_circle, color: Colors.white)),
        ]),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _layoutOption("Row", Iconsax.row_vertical),
          _layoutOption("Column", Iconsax.element_4),
          _layoutOption("Stack", Iconsax.layer),
        ]),
      ]),
    );
  }

  Widget _layoutOption(String title, IconData icon) {
    bool isSelected = selectedLayout == title.toLowerCase();
    return GestureDetector(
      onTap: () => setState(() => selectedLayout = title.toLowerCase()),
      child: Column(children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.white10, borderRadius: BorderRadius.circular(15)),
          child: Icon(icon, color: isSelected ? Colors.blue.shade900 : Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      ]),
    );
  }

  // ================= PREVIEW RENDERING =================

  Widget _renderMobileLayout() {
    final previewItems = filteredItems.take(5).toList();
    if (previewItems.isEmpty) return const Center(child: Text("No content", style: TextStyle(fontSize: 10)));

    switch (selectedLayout) {
      case "row": return _mobileRowPreview(previewItems);
      case "stack": return _mobileStackPreview(previewItems);
      default: return _mobileColumnPreview(previewItems);
    }
  }

  Widget _mobileColumnPreview(List<Map<String, dynamic>> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      itemBuilder: (_, i) => Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          const SizedBox(width: 8),
          _buildItemImage(items[i]['image']),
          const SizedBox(width: 8),
          Text(items[i]['title'] ?? '', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  Widget _mobileRowPreview(List<Map<String, dynamic>> items) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(10),
      child: Row(children: items.map((item) => Container(
        width: 80,
        margin: const EdgeInsets.only(right: 8),
        child: Column(children: [
          ClipRRect(borderRadius: BorderRadius.circular(8), child: _previewImage(item)),
          const SizedBox(height: 4),
          Text(item['title'] ?? '', maxLines: 1, style: const TextStyle(fontSize: 8)),
        ]),
      )).toList()),
    );
  }

  Widget _mobileStackPreview(List<Map<String, dynamic>> items) {
    return Center(
      child: SizedBox(
        height: 150,
        child: Stack(children: items.asMap().entries.map((e) => Positioned(
          top: e.key * 10.0,
          left: e.key * 10.0,
          child: Container(width: 100, height: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]), child: _previewImage(e.value)),
        )).toList()),
      ),
    );
  }

  // Widget _previewImage(Map<String, dynamic> item) {
  //   return item['image'] != null ? Image.network(item['image'].toString(), fit: BoxFit.cover) : Container(color: Colors.grey);
  // }

  Widget _previewImage(Map<String, dynamic> item) {
    final img = item['image'];

    if (img is Uint8List) {
      return Image.memory(img, fit: BoxFit.cover);
    }

    if (img != null && img.toString().isNotEmpty) {
      return Image.network(
        img.toString(),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: Colors.grey),
      );
    }

    return Container(color: Colors.grey);
  }

  Widget _buildEmptyState() {
    return Center(child: Column(children: [
      const SizedBox(height: 50),
      Lottie.asset('assets/Animation - 1749442430422.json', height: 180),
      Text("No items found", style: GoogleFonts.poppins(color: Colors.grey)),
    ]));
  }

  Widget _mobileBottomNavPreview() {
    if (navLoading) {
      return const SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          return _navItem(
            getIcon(item['icon'] ?? ''),
            item['label'] ?? '',
            navItems.indexOf(item) == 0,
          );
        }).toList(),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool selected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: selected ? Colors.blueAccent : Colors.grey,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 7,
            color: selected ? Colors.blueAccent : Colors.grey,
          ),
        ),
      ],
    );
  }

  IconData getIcon(String name) {
    switch (name.toLowerCase()) {
      case "home":
        return Iconsax.home;
      case "clock":
        return Iconsax.clock;
      case "video":
        return Iconsax.video;
      case "book":
        return Iconsax.book;
      case "wallet_check":
        return Iconsax.wallet_check;
      default:
        return Icons.help_outline;
    }
  }
}