// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import '../PopUp/Add_item_mobapp.dart';
// import '../PopUp/Mobile_app _additem.dart';
// import 'Home_mobapp.dart';
//
// class MobileApps extends StatefulWidget {
//   const MobileApps({super.key});
//
//   @override
//   State<MobileApps> createState() => _MobileAppsState();
// }
//
// class _MobileAppsState extends State<MobileApps> {
//   String selectedLabel = "Home";
//
//   List<Map<String, dynamic>> items = [
//     {
//       'title': "Congrats Graduate",
//       'image': 'https://images.unsplash.com/photo-1536126750180-3c7d59643f99?q=80&w=870&auto=format&fit=crop',
//     },
//     {
//       'title': "School for growth",
//       'image': 'https://images.unsplash.com/photo-1535440216424-0e374e613ee5?q=80&w=1033&auto=format&fit=crop',
//     },
//   ];
//
//   void showAddItemDialog(BuildContext context) async {
//     final result = await showDialog<Map<String, dynamic>>(
//       context: context,
//       builder: (context) => const AddItemDialog(),
//     );
//
//     if (result != null) {
//       final String title = result['title']?.toString() ?? '';
//       final dynamic image = result['image'];
//
//       setState(() {
//         items.add({'title': title, 'image': image});
//       });
//     }
//   }
//
//   void showItemDetailsDialog(BuildContext context, int index) async {
//     final updatedItem = await showDialog<Map<String, dynamic>>(
//       context: context,
//       builder: (context) => ItemDetailsDialog(item: items[index]),
//     );
//
//     if (updatedItem != null) {
//       setState(() {
//         items[index] = {
//           ...items[index],
//           ...updatedItem,
//         };
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildTopCards(context),
//                 const SizedBox(height: 16),
//                 _buildSelectedContent(constraints),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildTopCards(BuildContext context) {
//     final cardLabels = [
//       {"label": "Home", "icon": Iconsax.home},
//       {"label": "Service Time", "icon": Iconsax.clock},
//       {"label": "Sermons/live", "icon": Iconsax.video},
//       {"label": "Bible", "icon": Iconsax.book},
//       {"label": "Give", "icon": Iconsax.wallet_check},
//     ];
//
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: MediaQuery.of(context).size.width * 0.01,
//         vertical: MediaQuery.of(context).size.width * 0.01,
//       ),
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: Colors.white,
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: MediaQuery.of(context).size.width * 0.02,
//             vertical: MediaQuery.of(context).size.height * 0.02,
//           ),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Wrap(
//               spacing: 16,
//               runSpacing: 16,
//               children: cardLabels
//                   .map((item) => buildAppCard(
//                 item["label"].toString(),
//                 item["icon"] as IconData,
//                 context,
//               ))
//                   .toList(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildAppCard(String label, IconData icon, BuildContext context) {
//     double cardWidth = MediaQuery.of(context).size.width * 0.10;
//     double cardHeight = MediaQuery.of(context).size.height * 0.09;
//
//     final String shortLabel = label.length > 11 ? '${label.substring(0, 11)}...' : label;
//     final bool isSelected = selectedLabel == label;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedLabel = label;
//         });
//       },
//       child: Tooltip(
//         message: label,
//         child: MouseRegion(
//           cursor: SystemMouseCursors.click,
//           child: Container(
//             height: cardHeight,
//             width: cardWidth,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: isSelected ? Colors.grey.shade400 : Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(icon, size: 28, color: Colors.black87),
//                   const SizedBox(height: 8),
//                   Text(
//                     shortLabel,
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black87,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSelectedContent(BoxConstraints constraints) {
//     switch (selectedLabel) {
//       case "Home":
//         return _buildHomeContent(constraints);
//       case "Service Time":
//         return _buildServiceTimeContent();
//       case "Sermons/live":
//         return _buildSermonsContent();
//       case "Bible":
//         return _buildBibleContent();
//       case "Give":
//         return _buildGiveContent();
//       default:
//         return const SizedBox(); // fallback
//     }
//   }
//
//   Widget _buildHomeContent(BoxConstraints constraints) {
//     return HomeContent(
//       constraints: constraints,
//       items: items,
//       onAddItem: () => showAddItemDialog(context),
//       onShowItemDetails: (index) => showItemDetailsDialog(context, index),
//       onReorder: (oldIndex, newIndex) {
//         if (newIndex > oldIndex) newIndex -= 1;
//         setState(() {
//           final item = items.removeAt(oldIndex);
//           items.insert(newIndex, item);
//         });
//       },
//       onRemoveItem: (index) {
//         setState(() {
//           items.removeAt(index);
//         });
//       },
//     );
//   }
//   Widget _buildServiceTimeContent() {
//     return const Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Text(
//         "Service Time Details",
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
//
//   Widget _buildSermonsContent() {
//     return const Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Text(
//         "Sermons / Live Stream Section",
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
//
//   Widget _buildBibleContent() {
//     return const Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Text(
//         "Bible Section",
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
//
//   Widget _buildGiveContent() {
//     return const Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Text(
//         "Donation and Giving Options",
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../Controller/Get_all_item_controller.dart';
import '../../Model/Item_Model.dart';
import '../PopUp/Add_item_mobapp.dart';
import '../PopUp/Mobile_app _additem.dart';
import 'Home_mobapp.dart';

class MobileApps extends StatefulWidget {
  const MobileApps({super.key});

  @override
  State<MobileApps> createState() => _MobileAppsState();
}

class _MobileAppsState extends State<MobileApps> {
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

  void showAddItemDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddItemDialog(),
    );

    if (result != null) {
      setState(() {
        items.add(ItemModel(id: DateTime.now().toString(), title: result['title'], image: result['image']));
      });
    }
  }

  void showItemDetailsDialog(BuildContext context, int index) async {
    final updatedItem = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ItemDetailsDialog(
        item: {
          '_id': items[index].id, // ✅ Include ID here
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

  Widget _buildHomeContent(BoxConstraints constraints) {
    return HomeContent(
      constraints: constraints,
      items: items.map((item) => {
        'title': item.title,
        'image': item.image ?? '',
      }).toList(),
      onAddItem: () => showAddItemDialog(context),
      onShowItemDetails: (index) => showItemDetailsDialog(context, index),
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
