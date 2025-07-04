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

enum DrawerSelection { list, links, events }

class CustomRightDrawer extends StatefulWidget {
  final void Function(ItemModel newItem)? onAddItemToHome;
  final String? parentId;
  final ItemModel? rootItem;

  const CustomRightDrawer({
    super.key,
    this.onAddItemToHome,
    this.parentId,
    this.rootItem,
  });

  @override
  State<CustomRightDrawer> createState() => _CustomRightDrawerState();
}

class _CustomRightDrawerState extends State<CustomRightDrawer> {
  DrawerSelection selected = DrawerSelection.list;
  List<ListModel> recentLists = [];
  ListModel? selectedList;
  bool showCreateForm = false;
  String newTitle = '';
  String newSubtitle = '';
  Uint8List? pickedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  Future<void> _loadLists() async {
    setState(() => isLoading = true);
    try {
      final lists = await ListController.fetchLists(parentId: widget.parentId);
      setState(() => recentLists = lists);
    } catch (e) {
      debugPrint('Failed to load lists: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (result != null && result.files.single.bytes != null) {
      setState(() => pickedImage = result.files.single.bytes!);
    }
  }

  Future<void> _handleAddToHome(ListModel list) async {
    final String targetParentId = selectedList?.id ?? widget.parentId ?? widget.rootItem?.id ?? '';

    try {
      final subItems = await ItemService.fetchItems(parentId: targetParentId);
      final alreadyExists = subItems.any((i) =>
      i.title.trim() == list.title.trim() &&
          i.parentId == targetParentId &&
          i.type == 'list');

      if (alreadyExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Already added to this list')),
        );
        return;
      }

      final item = await ItemService.createItem(
        title: list.title,
        subtitle: list.subtitle ?? '',
        url: '',
        type: 'list',
        imageBytes: null,
        imageUrl: list.image,
        parentId: targetParentId,
      );

      final newItem = ItemModel(
        id: item.id,
        title: item.title,
        subtitle: item.subtitle,
        url: item.url,
        image: item.image,
        imageName: item.imageName,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
        v: item.v,
        index: item.index,
        type: 'list',
        parentId: targetParentId,
      );

      widget.onAddItemToHome?.call(newItem);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${list.title} added')),
      );

      setState(() {
        selectedList = null;
        showCreateForm = false;
      });

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Add to list failed: $e');
    }
  }

  Future<void> _handleCreateNewList() async {
    if (newTitle.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required')),
      );
      return;
    }

    try {
      final newList = await ListController.createList(
        newTitle,
        newSubtitle,
        imageBytes: pickedImage,
        parentId: selectedList?.id ?? widget.parentId,
      );

      setState(() {
        recentLists.insert(0, newList);
        showCreateForm = false;
        newTitle = '';
        newSubtitle = '';
        pickedImage = null;
      });

      if (selectedList != null) {
        await _loadLists();
      }
    } catch (e) {
      debugPrint('Create failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: showCreateForm ? _buildCreateForm() : _buildMainDrawer(),
          ),
        ),
      ),
    );
  }

  Widget _buildMainDrawer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Type:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        for (var option in DrawerSelection.values)
          RadioListTile<DrawerSelection>(
            title: Text(option.name[0].toUpperCase() + option.name.substring(1),
                style: GoogleFonts.poppins()),
            value: option,
            groupValue: selected,
            onChanged: (val) {
              setState(() {
                selected = val!;
                selectedList = null;
              });
            },
          ),
        const Divider(),
        if (selected == DrawerSelection.list) ...[
          Text("Recently Added Lists", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (recentLists.isEmpty)
            Text("No lists found", style: GoogleFonts.poppins(color: Colors.grey))
          else
            for (final list in recentLists)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
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
                  subtitle: Text(list.subtitle ?? '', style: GoogleFonts.poppins(fontSize: 12)),
                  selected: selectedList == list,
                  onTap: () => setState(() => selectedList = list),
                  trailing: IconButton(
                    icon: const Icon(Iconsax.arrow_right_34),
                    onPressed: () {
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
                            ),
                            rootItem: widget.rootItem ??
                                ItemModel(
                                  id: list.id,
                                  title: list.title,
                                  subtitle: list.subtitle,
                                  image: list.image,
                                  type: 'list',
                                  parentId: list.parentId,
                                ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          if (selectedList != null)
            ElevatedButton.icon(
              icon: const Icon(Iconsax.add),
              onPressed: () => _handleAddToHome(selectedList!),
              label: Text("Add to This List", style: GoogleFonts.poppins()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                minimumSize: const Size.fromHeight(40),
              ),
            ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => setState(() => showCreateForm = true),
            icon: const Icon(Iconsax.add_circle),
            label: Text(
              selectedList != null
                  ? "Create Inside ${selectedList!.title}"
                  : "Create Top-Level List",
              style: GoogleFonts.poppins(),
            ),
          ),
        ]
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
                pickedImage = null;
              }),
            ),
            Text("Create New List", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
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
                ? Center(child: Text("Tap to pick image", style: GoogleFonts.poppins()))
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
