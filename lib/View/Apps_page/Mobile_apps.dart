import 'dart:typed_data';
import 'package:ancilmediaadminpanel/View/PopUp/Mobile_app_additem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../Controller/Get_all_item_controller.dart';
import '../../Model/Item_Model.dart';
import '../../View_model/Listitem_details.dart';
import '../PopUp/Add_item_mobapp.dart';
import '../PopUp/Right_drawer.dart';
import 'Home_mobapp.dart';

class MobileApps extends StatefulWidget {
  const MobileApps({super.key});

  @override
  State<MobileApps> createState() => _MobileAppsState();
}

class _MobileAppsState extends State<MobileApps> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedLabel = "Home";
  List<ItemModel> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final fetched = await ItemService.fetchItems();
      setState(() {
        items = fetched;
      });
    } catch (e) {
      debugPrint('Failed to load items: $e');
    }
  }

  void showItemDetailsDialog(BuildContext context, int index) async {
    final updatedItem = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ItemDetailsDialog(
        item: {
          '_id': items[index].id,
          'title': items[index].title,
          'subtitle': items[index].subtitle,
          'url': items[index].url,
          'image': items[index].image,
          'imageName': items[index].imageName,
        },
      ),
    );

    if (updatedItem != null) {
      setState(() {
        items[index] = ItemModel(
          id: updatedItem['_id'] ?? items[index].id,
          title: updatedItem['title'],
          subtitle: updatedItem['subtitle'],
          url: updatedItem['url'],
          image: updatedItem['image'],
          imageName: updatedItem['imageName'],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CustomRightDrawer(
        isInSublist: false,  // Because this is the root "Home" page
        parentId: null,      // No parent ID at root level
        rootItem: null,      // No rootItem at the root level
        onAddItemToHome: (ItemModel newItem) {
          setState(() {
            items.add(newItem);
          });
        },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopCards(context),
                const SizedBox(height: 16),
                _buildSelectedContent(constraints),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopCards(BuildContext context) {
    final cardLabels = [
      {"label": "Home", "icon": Iconsax.home},
      {"label": "Service Time", "icon": Iconsax.clock},
      {"label": "Sermons/live", "icon": Iconsax.video},
      {"label": "Bible", "icon": Iconsax.book},
      {"label": "Give", "icon": Iconsax.wallet_check},
    ];

    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: cardLabels.map((item) {
                return buildAppCard(
                  item["label"].toString(),
                  item["icon"] as IconData,
                  context,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppCard(String label, IconData icon, BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.10;
    double cardHeight = MediaQuery.of(context).size.height * 0.09;
    final bool isSelected = selectedLabel == label;
    final String shortLabel = label.length > 11 ? '${label.substring(0, 11)}...' : label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLabel = label;
        });
      },
      child: Tooltip(
        message: label,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            height: cardHeight,
            width: cardWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? Colors.grey.shade400 : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 28, color: Colors.black87),
                  const SizedBox(height: 8),
                  Text(
                    shortLabel,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedContent(BoxConstraints constraints) {
    switch (selectedLabel) {
      case "Home":
        return _buildHomeContent(constraints);
      case "Service Time":
        return _buildServiceTimeContent();
      case "Sermons/live":
        return _buildSermonsContent();
      case "Bible":
        return _buildBibleContent();
      case "Give":
        return _buildGiveContent();
      default:
        return const SizedBox();
    }
  }

  // Widget _buildHomeContent(BoxConstraints constraints) {
  //   return HomeContent(
  //     constraints: constraints,
  //     items: items.map((itm) => {
  //       '_id': itm.id,
  //       'title': itm.title,
  //       'subtitle': itm.subtitle ?? '',
  //       'image': itm.image ?? '',
  //       'type': itm.type ?? '',
  //     }).toList(),
  //     onShowItemDetails: (idx) {
  //       final it = items[idx];
  //       if (it.type == 'list') {
  //         Navigator.push(context, MaterialPageRoute(
  //           builder: (_) => ListItemDetailsPage(parentItem: it),
  //         ));
  //       }
  //     },
  //     onReorder: (oldIndex, newIndex) async {
  //       if (newIndex > oldIndex) newIndex -= 1;
  //       setState(() {
  //         final item = items.removeAt(oldIndex);
  //         items.insert(newIndex, item);
  //       });
  //
  //       try {
  //         await ItemService.reorderItems(items);
  //       } catch (e) {
  //         debugPrint('Failed to update order: $e');
  //       }
  //     },
  //     onRemoveItem: (index) async {
  //       try {
  //         await ItemService.deleteItem(items[index].id);
  //         setState(() {
  //           items.removeAt(index);
  //         });
  //       } catch (e) {
  //         debugPrint('Failed to delete item: $e');
  //       }
  //     },
  //     onOpenDrawer: () => _scaffoldKey.currentState?.openEndDrawer(),
  //   );
  // }
  Widget _buildHomeContent(BoxConstraints constraints) {
    return HomeContent(
      constraints: constraints,
      items: items.map((itm) => {
        '_id': itm.id,
        'title': itm.title,
        'subtitle': itm.subtitle ?? '',
        'image': itm.image ?? '',
        'type': itm.type ?? '',
      }).toList(),
      onShowItemDetails: (idx) async {
        final it = items[idx];
        final type = it.type ?? 'list';

        if (type == 'list') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ListItemDetailsPage(parentItem: it),
            ),
          );
        } else {
          final result = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (_) => AddItemDialog(
              initialTitle: it.title,
              initialSubtitle: it.subtitle ?? '',
              initialImage: it.image ?? '',
              initialUrl: it.url ?? '',
              initialType: it.type ?? 'link',
              itemId: it.id,
            ),
          );

          if (result != null) {
            // Handle updated values
            setState(() {
              it.title = result['title'];
              it.subtitle = result['subtitle'];
              it.image = result['image'];
              it.type = result['type'];
              it.url = result['externalUrl']; // Ensure this is passed correctly
              it.imageName = result['imageName'];
            });

            // Optional: send update to backend
            try {
              await ItemService.updateItem(it); // ← Implement this if needed
            } catch (e) {
              debugPrint('Failed to update item: $e');
            }
          }
        }
      },
      onReorder: (oldIndex, newIndex) async {
        if (newIndex > oldIndex) newIndex -= 1;
        setState(() {
          final item = items.removeAt(oldIndex);
          items.insert(newIndex, item);
        });

        try {
          await ItemService.reorderItems(items);
        } catch (e) {
          debugPrint('Failed to update order: $e');
        }
      },
      onRemoveItem: (index) async {
        try {
          await ItemService.deleteItem(items[index].id);
          setState(() {
            items.removeAt(index);
          });
        } catch (e) {
          debugPrint('Failed to delete item: $e');
        }
      },
      onOpenDrawer: () => _scaffoldKey.currentState?.openEndDrawer(),
    );
  }

  Widget _buildServiceTimeContent() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text("Service Time Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildSermonsContent() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text("Sermons / Live Stream Section", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildBibleContent() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text("Bible Section", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildGiveContent() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text("Donation and Giving Options", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
    );
  }
}
