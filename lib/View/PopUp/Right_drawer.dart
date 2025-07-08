import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Controller/right_drawer_controller.dart';
import '../../Controller/Get_all_item_controller.dart';
import '../../Model/list_model.dart';
import '../../Model/Item_Model.dart';
import '../../View_model/Listitem_details.dart';

enum DrawerSelection { list, link, event }

extension StringCasing on String {
  String capitalize() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : this;
}

class CustomRightDrawer extends StatefulWidget {
  final void Function(ItemModel newItem)? onAddItemToHome;
  final String? parentId;
  final ItemModel? rootItem;
  final bool isInSublist;

  const CustomRightDrawer({
    super.key,
    this.onAddItemToHome,
    this.parentId,
    this.rootItem,
    required this.isInSublist,
  });

  @override
  State<CustomRightDrawer> createState() => _CustomRightDrawerState();
}

class _CustomRightDrawerState extends State<CustomRightDrawer>
    with SingleTickerProviderStateMixin {
  DrawerSelection selected = DrawerSelection.list;
  List<ListModel> recentLists = [];
  bool showCreateForm = false;
  String newTitle = '';
  String newSubtitle = '';
  String newUrl = '';
  Uint8List? pickedImage;
  bool isLoading = false;
  String searchQuery = '';

  // Animation flags
  bool animateButton = false;

  @override
  void initState() {
    super.initState();
    _loadLists();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => animateButton = true);
    });
  }

  Future<void> _loadLists() async {
    setState(() => isLoading = true);
    try {
      if (widget.isInSublist) {
        final lists = await ListController.fetchLists(
          parentId: widget.parentId,
        );
        final filtered = lists.where((l) => l.type == selected.name).toList();
        setState(() => recentLists = filtered);
      } else {
        final items = await ItemService.fetchItems();
        final lists = items
            .where((i) => i.type == selected.name)
            .map(
              (i) => ListModel(
                id: i.id,
                title: i.title,
                subtitle: i.subtitle,
                image: i.image ?? '',
                parentId: i.parentId,
                index: i.index ?? 0,
                type: i.type,
              ),
            )
            .toList();
        setState(() => recentLists = lists);
      }
    } catch (e) {
      debugPrint('Failed to load items: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      setState(() => pickedImage = result.files.single.bytes!);
    }
  }

  Future<void> _handleCreateNewList() async {
    if (newTitle.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Title is required')));
      return;
    }

    try {
      ListModel newList;

      if (widget.isInSublist && selected == DrawerSelection.list) {
        newList = await ListController.createList(
          newTitle.trim(),
          newSubtitle.trim(),
          imageBytes: pickedImage,
          parentId: widget.parentId,
        );
      } else {
        final item = await ItemService.createItem(
          title: newTitle.trim(),
          subtitle: newSubtitle.trim(),
          url: selected == DrawerSelection.link ? newUrl.trim() : '',
          type: selected.name,
          imageBytes: pickedImage,
          parentId: widget.isInSublist ? widget.parentId : null,
        );

        newList = ListModel(
          id: item.id,
          title: item.title,
          subtitle: item.subtitle,
          image: item.image ?? '',
          parentId: item.parentId,
          index: item.index ?? 0,
          type: item.type,
        );
      }

      final newItem = ItemModel(
        id: newList.id,
        title: newList.title,
        subtitle: newList.subtitle,
        image: newList.image,
        type: newList.type ?? selected.name,
        parentId: newList.parentId,
        index: newList.index,
      );

      widget.onAddItemToHome?.call(newItem);

      setState(() {
        showCreateForm = false;
        newTitle = '';
        newSubtitle = '';
        newUrl = '';
        pickedImage = null;
      });

      await _loadLists();
    } catch (e) {
      debugPrint("Create item failed: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredLists = recentLists
        .where(
          (list) =>
              list.title.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    return SizedBox(
      width: 400,
      child: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: showCreateForm
                ? _buildCreateForm()
                : _buildMainDrawer(filteredLists),
          ),
        ),
      ),
    );
  }

  Widget _buildMainDrawer(List<ListModel> filteredLists) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Type:",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        for (var option in DrawerSelection.values)
          RadioListTile<DrawerSelection>(
            title: Text(option.name.capitalize(), style: GoogleFonts.poppins()),
            value: option,
            groupValue: selected,
            onChanged: (val) {
              setState(() {
                selected = val!;
                _loadLists();
              });
            },
          ),
        const Divider(),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Search',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: (val) => setState(() => searchQuery = val),
        ),
        const SizedBox(height: 10),

        /// ⏬ Animated divider + button combo
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: Column(
            children: [
              // Top divider
              Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: 1,
                      color: Colors.grey,
                      margin: EdgeInsets.only(
                        right: animateButton
                            ? 8
                            : MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: 1,
                      color: Colors.grey,
                      margin: EdgeInsets.only(
                        left: animateButton
                            ? 8
                            : MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Button animation
              AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: animateButton ? 1.0 : 0.0,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 600),
                  scale: animateButton ? 1.0 : 0.8,
                  curve: Curves.easeOutBack,
                  child: GestureDetector(
                    onTap: () => setState(() => showCreateForm = true),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        height: MediaQuery.of(context).size.height * .0400,
                        width: MediaQuery.of(context).size.width * .110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.purpleAccent.shade100,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Iconsax.add_circle),
                            const SizedBox(width: 8),
                            Text(
                              "Create ${selected.name.capitalize()}",
                              style: GoogleFonts.poppins(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                child: Divider(thickness: 2, color: Colors.purple.shade200),
              ),
              const SizedBox(height: 16),

              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (filteredLists.isEmpty)
                Text(
                  "No items found",
                  style: GoogleFonts.poppins(color: Colors.grey),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredLists.length,
                  itemBuilder: (context, index) {
                    final list = filteredLists[index];
                    return FallingListItem(
                      delay: Duration(milliseconds: 100 * index),
                      child: ListTile(
                        leading: list.image.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  list.image,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image_not_supported),
                                ),
                              )
                            : const Icon(Iconsax.image, size: 30),
                        title: Text(list.title, style: GoogleFonts.poppins()),
                        subtitle: Text(
                          list.subtitle ?? '',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        onTap: () {
                          if ((list.type ?? 'list') == 'list') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ListItemDetailsPage(
                                  parentItem: ItemModel(
                                    id: list.id,
                                    title: list.title,
                                    subtitle: list.subtitle,
                                    image: list.image,
                                    type: 'list',
                                    parentId: list.parentId,
                                    index: list.index,
                                  ),
                                  rootItem:
                                      widget.rootItem ??
                                      ItemModel(
                                        id: list.id,
                                        title: list.title,
                                        subtitle: list.subtitle,
                                        image: list.image,
                                        type: 'list',
                                        parentId: list.parentId,
                                        index: list.index,
                                      ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Iconsax.arrow_left),
              onPressed: () => setState(() {
                showCreateForm = false;
                newTitle = '';
                newSubtitle = '';
                newUrl = '';
                pickedImage = null;
              }),
            ),
            Text(
              "Create New ${selected.name.capitalize()}",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: (val) => setState(() => newTitle = val),
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Subtitle',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: (val) => setState(() => newSubtitle = val),
        ),
        if (selected == DrawerSelection.link) ...[
          const SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'URL',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (val) => setState(() => newUrl = val),
          ),
        ],
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            child: pickedImage == null
                ? Center(
                    child: Text(
                      "Tap to pick image",
                      style: GoogleFonts.poppins(),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(pickedImage!, fit: BoxFit.cover),
                  ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Iconsax.save_2),
                onPressed: _handleCreateNewList,
                label: Text("Save", style: GoogleFonts.poppins()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Iconsax.close_circle),
                onPressed: () => setState(() {
                  showCreateForm = false;
                  newTitle = '';
                  newSubtitle = '';
                  newUrl = '';
                  pickedImage = null;
                }),
                label: Text("Cancel", style: GoogleFonts.poppins()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FallingListItem extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const FallingListItem({super.key, required this.child, required this.delay});

  @override
  State<FallingListItem> createState() => _FallingListItemState();
}

class _FallingListItemState extends State<FallingListItem>
    with SingleTickerProviderStateMixin {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : const Offset(0, -0.3),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: widget.child,
      ),
    );
  }
}
