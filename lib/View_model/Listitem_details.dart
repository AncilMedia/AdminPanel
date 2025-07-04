import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../Model/Item_Model.dart';
import '../../Controller/Get_all_item_controller.dart';
import '../View/PopUp/Right_drawer.dart';

class ListItemDetailsPage extends StatefulWidget {
  final ItemModel parentItem;
  final ItemModel? rootItem;

  const ListItemDetailsPage({
    super.key,
    required this.parentItem,
    this.rootItem,
  });

  @override
  State<ListItemDetailsPage> createState() => _ListItemDetailsPageState();
}

class _ListItemDetailsPageState extends State<ListItemDetailsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ItemModel> subItems = [];
  bool isLoading = false;
  late ItemModel rootItem;

  @override
  void initState() {
    super.initState();
    rootItem = widget.rootItem ?? widget.parentItem;
    _resolveRootItem();
    _loadSubItems();
  }

  Future<void> _resolveRootItem() async {
    ItemModel current = widget.parentItem;
    while (current.parentId != null) {
      final fetchedParent = await ItemService.fetchItemById(current.parentId!);
      if (fetchedParent != null) {
        current = fetchedParent;
      } else {
        break;
      }
    }
    setState(() => rootItem = current);
  }

  Future<void> _loadSubItems() async {
    setState(() => isLoading = true);
    try {
      final fetched = await ItemService.fetchItems(parentId: widget.parentItem.id);
      setState(() => subItems = fetched);
    } catch (e, stackTrace) {
      debugPrint('Failed to fetch subitems: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    final filtered = subItems.where((i) => i.parentId == widget.parentItem.id).toList();
    final item = filtered.removeAt(oldIndex);
    filtered.insert(newIndex, item);

    setState(() {
      subItems = [
        ...subItems.where((i) => i.parentId != widget.parentItem.id),
        ...filtered,
      ];
    });

    try {
      await ItemService.reorderItems(filtered);
    } catch (e, stackTrace) {
      debugPrint('Failed to reorder: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _onRemoveItem(int index) async {
    final filtered = subItems.where((i) => i.parentId == widget.parentItem.id).toList();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this item?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );

    if (confirm == true) {
      final toDelete = filtered[index];
      try {
        await ItemService.deleteItem(toDelete.id);
        setState(() => subItems.removeWhere((i) => i.id == toDelete.id));
      } catch (e) {
        debugPrint('Delete failed: $e');
      }
    }
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _addSubItem(ItemModel newItem) {
    if (newItem.parentId == widget.parentItem.id &&
        !subItems.any((i) => i.id == newItem.id)) {
      setState(() => subItems.insert(0, newItem));
    }
  }

  @override
  Widget build(BuildContext context) {
    final parent = widget.parentItem;
    final filteredSubItems = subItems.where((i) => i.parentId == parent.id).toList();

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CustomRightDrawer(
        parentId: parent.id,
        rootItem: rootItem,
        onAddItemToHome: (newItem) {
          setState(() {
            subItems.insert(0, newItem);
          });
        },
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: Colors.grey.shade100,
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text("List: ${parent.title}", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                const Divider(),
                const Expanded(child: Center(child: Text("Sidebar widgets here"))),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Basic Info", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: parent.title,
                          decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                          readOnly: true,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: parent.subtitle,
                          decoration: const InputDecoration(labelText: 'Subtitle', border: OutlineInputBorder()),
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Iconsax.document),
                              const SizedBox(width: 8),
                              Text("Items in ${parent.title}", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _openEndDrawer,
                            child: Row(
                              children: [
                                const Icon(Iconsax.add_circle),
                                const SizedBox(width: 8),
                                Text("Add Item", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : filteredSubItems.isEmpty
                                ? const Center(child: Text("No items found"))
                                : ReorderableListView.builder(
                              itemCount: filteredSubItems.length,
                              onReorder: _onReorder,
                              itemBuilder: (context, index) {
                                final item = filteredSubItems[index];
                                return ListTile(
                                  key: ValueKey(item.id),
                                  leading: const Icon(Iconsax.element_3),
                                  title: Text(item.title, style: GoogleFonts.poppins()),
                                  subtitle: Text(item.subtitle ?? '', style: GoogleFonts.poppins(fontSize: 12)),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (item.type == 'list')
                                        IconButton(
                                          icon: const Icon(Iconsax.arrow_right_34),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ListItemDetailsPage(
                                                  parentItem: item,
                                                  rootItem: rootItem,
                                                ),
                                              ),
                                            ).then((_) => _loadSubItems());
                                          },
                                        ),
                                      IconButton(
                                        icon: const Icon(Iconsax.trash),
                                        onPressed: () => _onRemoveItem(index),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
