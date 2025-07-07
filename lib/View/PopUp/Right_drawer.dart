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

class _CustomRightDrawerState extends State<CustomRightDrawer> {
  DrawerSelection selected = DrawerSelection.list;
  List<ListModel> recentLists = [];
  ListModel? selectedList;
  bool showCreateForm = false;
  String newTitle = '';
  String newSubtitle = '';
  Uint8List? pickedImage;
  bool isLoading = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  Future<void> _loadLists() async {
    setState(() => isLoading = true);
    try {
      if (widget.isInSublist) {
        final lists = await ListController.fetchLists(parentId: widget.parentId);
        setState(() => recentLists = lists);
      } else {
        final items = await ItemService.fetchItems();
        final List<ListModel> lists = items.where((i) => i.type == 'list').map((i) => ListModel(
          id: i.id,
          title: i.title,
          subtitle: i.subtitle,
          image: i.image ?? '',
          parentId: i.parentId,
          index: i.index ?? 0,
        )).toList();
        setState(() => recentLists = lists);
      }
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

  Future<void> _handleCreateNewList() async {
    if (newTitle.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required')),
      );
      return;
    }

    try {
      ListModel newList;
      if (widget.isInSublist) {
        newList = await ListController.createList(
          newTitle.trim(),
          newSubtitle.trim(),
          imageBytes: pickedImage,
          parentId: widget.parentId,
        );
      } else {
        final item = await ItemService.createItem(
          title: newTitle,
          subtitle: newSubtitle,
          url: '',
          type: 'list',
          imageBytes: pickedImage,
          parentId: null,
        );

        newList = ListModel(
          id: item.id,
          title: item.title,
          subtitle: item.subtitle,
          image: item.image ?? '',
          parentId: null,
          index: item.index ?? 0,
        );
      }

      final newItem = ItemModel(
        id: newList.id,
        title: newList.title,
        subtitle: newList.subtitle,
        image: newList.image,
        type: 'list',
        parentId: newList.parentId,
        index: newList.index,
      );

      widget.onAddItemToHome?.call(newItem);

      setState(() {
        showCreateForm = false;
        newTitle = '';
        newSubtitle = '';
        pickedImage = null;
      });

      await _loadLists();
    } catch (e) {
      debugPrint("Create list failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredLists = recentLists.where((list) =>
        list.title.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();

    return SizedBox(
      width: 400,
      child: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: showCreateForm ? _buildCreateForm() : _buildMainDrawer(filteredLists),
          ),
        ),
      ),
    );
  }

  Widget _buildMainDrawer(List<ListModel> filteredLists) {
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
            onChanged: (val) => setState(() => selected = val!),
          ),
        const Divider(),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Search Lists',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: (val) => setState(() => searchQuery = val),
        ),
        const SizedBox(height: 12),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (filteredLists.isEmpty)
          Text("No lists found", style: GoogleFonts.poppins(color: Colors.grey))
        else
          ...filteredLists.map((list) => ListTile(
            leading: list.image.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                list.image,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
              ),
            )
                : const Icon(Iconsax.image, size: 30),
            title: Text(list.title, style: GoogleFonts.poppins()),
            subtitle: Text(list.subtitle ?? '', style: GoogleFonts.poppins(fontSize: 12)),
            onTap: () {
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
                    rootItem: widget.rootItem ??
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
            },
          )),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          icon: const Icon(Iconsax.add_circle),
          onPressed: () => setState(() => showCreateForm = true),
          label: Text(
            "Create ${widget.isInSublist ? "Sublist" : "Top-Level List"}",
            style: GoogleFonts.poppins(),
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
