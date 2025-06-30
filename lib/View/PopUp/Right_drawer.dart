import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../Controller/right_drawer_controller.dart';
import '../../Model/list_model.dart';


enum DrawerSelection { list, links, events }

class CustomRightDrawer extends StatefulWidget {
  final void Function(String title, String subtitle)? onAddItemToHome;

  const CustomRightDrawer({super.key, this.onAddItemToHome});

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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  Future<void> _loadLists() async {
    setState(() => isLoading = true);
    try {
      final lists = await ListController.fetchLists();
      setState(() => recentLists = lists);
    } catch (e) {
      debugPrint('Failed to load lists: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: showCreateForm ? _buildCreateListForm() : _buildMainDrawer(),
        ),
      ),
    );
  }

  Widget _buildMainDrawer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Type:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        for (DrawerSelection option in DrawerSelection.values)
          RadioListTile<DrawerSelection>(
            title: Text(option.name[0].toUpperCase() + option.name.substring(1)),
            value: option,
            groupValue: selected,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selected = value;
                  selectedList = null;
                });
              }
            },
          ),
        const Divider(),

        if (selected == DrawerSelection.list) ...[
          const SizedBox(height: 12),
          const Text("Recently Added Lists", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            for (var list in recentLists)
              ListTile(
                title: Text(list.title),
                subtitle: Text(list.subtitle),
                tileColor: selectedList == list ? Colors.grey.shade300 : null,
                onTap: () => setState(() => selectedList = list),
              ),

          if (selectedList != null) ...[
            const SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                minimumSize: const Size(double.infinity, 40),
              ),
              onPressed: () {
                widget.onAddItemToHome?.call(
                  selectedList!.title,
                  selectedList!.subtitle,
                );
                Navigator.pop(context);
              },
              icon: const Icon(Iconsax.add),
              label: const Text("Add to Home"),
            ),
          ],

          const SizedBox(height: 32),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => setState(() => showCreateForm = true),
              icon: const Icon(Iconsax.add_square),
              label: const Text("Create New List"),
            ),
          ),
        ],

        if (selected != DrawerSelection.list)
          const Padding(
            padding: EdgeInsets.only(top: 32),
            child: Center(child: Text("Feature coming soon")),
          ),
      ],
    );
  }

  Widget _buildCreateListForm() {
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
              }),
            ),
            const Text("Create New List", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),

        TextFormField(
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (val) => setState(() => newTitle = val),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Subtitle'),
          onChanged: (val) => setState(() => newSubtitle = val),
        ),
        const SizedBox(height: 24),

        if (newTitle.isNotEmpty || newSubtitle.isNotEmpty)
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Iconsax.save_2),
                  onPressed: () async {
                    try {
                      final newList = await ListController.createList(newTitle, newSubtitle);
                      setState(() {
                        recentLists.insert(0, newList);
                        newTitle = '';
                        newSubtitle = '';
                        showCreateForm = false;
                      });
                    } catch (e) {
                      debugPrint('Create failed: $e');
                    }
                  },
                  label: const Text("Save"),
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
                  }),
                  label: const Text("Cancel"),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
