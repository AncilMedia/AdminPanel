// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:iconsax/iconsax.dart';
// //
// // import '../../Controller/Get_all_item_controller.dart';
// // import '../../Controller/Organization_Controller.dart';
// // import '../../Model/Item_Model.dart';
// // import '../../View_model/Listitem_details.dart';
// // import '../PopUp/Add_item_mobapp.dart';
// // import '../PopUp/Mobile_app_additem.dart';
// // import '../PopUp/Right_drawer.dart';
// // import 'Home_mobapp.dart';
// //
// // class MobileApps extends StatefulWidget {
// //   const MobileApps({super.key});
// //
// //   @override
// //   State<MobileApps> createState() => _MobileAppsState();
// // }
// //
// // class _MobileAppsState extends State<MobileApps> {
// //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// //   String selectedLabel = "Home";
// //   List<ItemModel> items = [];
// //   Map<String, String> orgNames = {}; // organizationId => name
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadItems();
// //   }
// //
// //   Future<void> _loadItems() async {
// //     try {
// //       final fetched = await ItemService.fetchItems();
// //       setState(() => items = fetched);
// //       await _fetchOrgNames();
// //     } catch (e) {
// //       debugPrint('Failed to load items: $e');
// //     }
// //   }
// //
// //   Future<void> _fetchOrgNames() async {
// //     for (var item in items) {
// //       final orgId = item.organizationId;
// //       if (orgId != null && !orgNames.containsKey(orgId)) {
// //         final org = await OrganizationController.fetchOrganizationById(orgId);
// //         if (org != null && org['name'] != null) {
// //           orgNames[orgId] = org['name'];
// //         }
// //       }
// //     }
// //     setState(() {});
// //   }
// //
// //   Widget _buildHomeContent(BoxConstraints constraints) {
// //     return HomeContent(
// //       constraints: constraints,
// //       items: items.map((itm) => {
// //         '_id': itm.id,
// //         'title': itm.title,
// //         'subtitle': itm.subtitle ?? '',
// //         'image': itm.image ?? '',
// //         'type': itm.type ?? '',
// //         'organizationName': orgNames[itm.organizationId] ?? '',
// //       }).toList(),
// //       onShowItemDetails: (idx) async {
// //         final it = items[idx];
// //         final type = it.type ?? 'list';
// //
// //         if (type == 'list') {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //               builder: (_) => ListItemDetailsPage(parentItem: it),
// //             ),
// //           );
// //         } else {
// //           final result = await showDialog<Map<String, dynamic>>(
// //             context: context,
// //             builder: (_) => AddItemDialog(
// //               initialTitle: it.title,
// //               initialSubtitle: it.subtitle ?? '',
// //               initialImage: it.image ?? '',
// //               initialUrl: it.url ?? '',
// //               initialType: it.type ?? 'link',
// //               itemId: it.id,
// //             ),
// //           );
// //
// //           if (result != null) {
// //             setState(() {
// //               it.title = result['title'];
// //               it.subtitle = result['subtitle'];
// //               it.image = result['image'];
// //               it.type = result['type'];
// //               it.url = result['externalUrl'];
// //               it.imageName = result['imageName'];
// //             });
// //
// //             try {
// //               await ItemService.updateItem(
// //                 itemId: it.id,
// //                 title: it.title,
// //                 subtitle: it.subtitle,
// //                 imageUrl: it.image,
// //                 externalUrl: it.url,
// //                 type: it.type,
// //               );
// //             } catch (e) {
// //               debugPrint('Failed to update item: $e');
// //             }
// //           }
// //         }
// //       },
// //       onReorder: (oldIndex, newIndex) async {
// //         if (newIndex > oldIndex) newIndex -= 1;
// //         setState(() {
// //           final item = items.removeAt(oldIndex);
// //           items.insert(newIndex, item);
// //         });
// //
// //         try {
// //           await ItemService.reorderItems(items);
// //         } catch (e) {
// //           debugPrint('Failed to update order: $e');
// //         }
// //       },
// //       onRemoveItem: (index) async {
// //         try {
// //           await ItemService.deleteItem(items[index].id);
// //           setState(() {
// //             items.removeAt(index);
// //           });
// //         } catch (e) {
// //           debugPrint('Failed to delete item: $e');
// //         }
// //       },
// //       onOpenDrawer: () => _scaffoldKey.currentState?.openEndDrawer(),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       key: _scaffoldKey,
// //       endDrawer: CustomRightDrawer(
// //         isInSublist: false,
// //         parentId: null,
// //         rootItem: null,
// //         onAddItemToHome: (ItemModel newItem) {
// //           setState(() {
// //             items.add(newItem);
// //             _fetchOrgNames();
// //           });
// //         },
// //       ),
// //       body: LayoutBuilder(
// //         builder: (context, constraints) {
// //           return SingleChildScrollView(
// //             child: Column(
// //               children: [
// //                 _buildTopCards(context),
// //                 const SizedBox(height: 16),
// //                 _buildSelectedContent(constraints),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTopCards(BuildContext context) {
// //     final cardLabels = [
// //       {"label": "Home", "icon": Iconsax.home},
// //       {"label": "Service Time", "icon": Iconsax.clock},
// //       {"label": "Sermons/live", "icon": Iconsax.video},
// //       {"label": "Bible", "icon": Iconsax.book},
// //       {"label": "Give", "icon": Iconsax.wallet_check},
// //     ];
// //
// //     return Padding(
// //       padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
// //       child: Container(
// //         width: MediaQuery.of(context).size.width,
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(20),
// //           color: Colors.white,
// //         ),
// //         child: Padding(
// //           padding: EdgeInsets.symmetric(
// //             horizontal: MediaQuery.of(context).size.width * 0.02,
// //             vertical: MediaQuery.of(context).size.height * 0.02,
// //           ),
// //           child: SingleChildScrollView(
// //             scrollDirection: Axis.horizontal,
// //             child: Wrap(
// //               spacing: 16,
// //               runSpacing: 16,
// //               children: cardLabels.map((item) {
// //                 return buildAppCard(
// //                   item["label"].toString(),
// //                   item["icon"] as IconData,
// //                   context,
// //                 );
// //               }).toList(),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget buildAppCard(String label, IconData icon, BuildContext context) {
// //     double cardWidth = MediaQuery.of(context).size.width * 0.10;
// //     double cardHeight = MediaQuery.of(context).size.height * 0.09;
// //     final bool isSelected = selectedLabel == label;
// //     final String shortLabel = label.length > 11 ? '${label.substring(0, 11)}...' : label;
// //
// //     return GestureDetector(
// //       onTap: () {
// //         setState(() {
// //           selectedLabel = label;
// //         });
// //       },
// //       child: Tooltip(
// //         message: label,
// //         child: MouseRegion(
// //           cursor: SystemMouseCursors.click,
// //           child: Container(
// //             height: cardHeight,
// //             width: cardWidth,
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(8),
// //               color: isSelected ? Colors.grey.shade400 : Colors.white,
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.05),
// //                   blurRadius: 4,
// //                   offset: const Offset(0, 2),
// //                 ),
// //               ],
// //             ),
// //             child: Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(icon, size: 28, color: Colors.black87),
// //                   const SizedBox(height: 8),
// //                   Text(
// //                     shortLabel,
// //                     textAlign: TextAlign.center,
// //                     style: GoogleFonts.poppins(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w500,
// //                       color: Colors.black87,
// //                     ),
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSelectedContent(BoxConstraints constraints) {
// //     switch (selectedLabel) {
// //       case "Home":
// //         return _buildHomeContent(constraints);
// //       case "Service Time":
// //         return const Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Text("Service Time Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
// //         );
// //       case "Sermons/live":
// //         return const Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Text("Sermons / Live Stream Section", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
// //         );
// //       case "Bible":
// //         return const Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Text("Bible Section", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
// //         );
// //       case "Give":
// //         return const Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Text("Donation and Giving Options", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
// //         );
// //       default:
// //         return const SizedBox();
// //     }
// //   }
// // }
//
//
//
//
// // lib/View/MobileApps/MobileApps.dart
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:http/http.dart' as http;
//
// import '../../Controller/Get_all_item_controller.dart';
// import '../../Controller/Navigation_controller.dart';
// import '../../Controller/Organization_Controller.dart';
// import '../../Model/Item_Model.dart';
// import '../../Model/Navigation_model.dart';
// import '../../Services/Icon_mapper.dart';
// import '../../View_model/Listitem_details.dart';
// import '../PopUp/Add_item_mobapp.dart';
// import '../PopUp/Mobile_app_additem.dart';
// import '../PopUp/Right_drawer.dart';
// import 'Home_mobapp.dart';
// import '../../environmental variables.dart'; // contains baseUrl
// // NOTE: Adjust import paths above to match your project structure.
//
// class MobileApps extends StatefulWidget {
//   const MobileApps({super.key});
//
//   @override
//   State<MobileApps> createState() => _MobileAppsState();
// }
//
// class _MobileAppsState extends State<MobileApps> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   String selectedLabel = "Home";
//   List<ItemModel> items = [];
//   Map<String, String> orgNames = {};
//
//   // now comes from API
//   List<NavigationModel> cardItems = [];
//   bool isLoadingNav = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadItems();
//     _loadNavItems();
//   }
//
//   Future<void> _loadItems() async {
//     try {
//       final fetched = await ItemService.fetchItems();
//       setState(() => items = fetched);
//       await _fetchOrgNames();
//     } catch (e) {
//       debugPrint('Failed to load items: $e');
//     }
//   }
//
//   Future<void> _fetchOrgNames() async {
//     for (var item in items) {
//       final orgId = item.organizationId;
//       if (orgId != null && !orgNames.containsKey(orgId)) {
//         final org = await OrganizationController.fetchOrganizationById(orgId);
//         if (org != null && org['name'] != null) {
//           orgNames[orgId] = org['name'];
//         }
//       }
//     }
//     setState(() {});
//   }
//
//   Future<void> _loadNavItems() async {
//     setState(() => isLoadingNav = true);
//
//     try {
//       final nav = await NavigationController.fetchNavigation();
//       setState(() {
//         cardItems = nav;
//
//         if (!cardItems.any((c) => c.label == selectedLabel) &&
//             cardItems.isNotEmpty) {
//           selectedLabel = cardItems.first.label;
//         }
//       });
//     } catch (e) {
//       debugPrint("Navigation load error: $e");
//     }
//
//     setState(() => isLoadingNav = false);
//   }
//
//   Future<void> _saveNavOrder() async {
//     try {
//       await NavigationController.updateNavigationItem(item);
//     } catch (e) {
//       debugPrint("Save order error: $e");
//     }
//   }
//
//
//   Widget _buildHomeContent(BoxConstraints constraints) {
//     return HomeContent(
//       constraints: constraints,
//       items: items
//           .map((itm) => {
//         '_id': itm.id,
//         'title': itm.title,
//         'subtitle': itm.subtitle ?? '',
//         'image': itm.image ?? '',
//         'type': itm.type ?? '',
//         'organizationName': orgNames[itm.organizationId] ?? '',
//       })
//           .toList(),
//       onShowItemDetails: (idx) async {
//         final it = items[idx];
//         final type = it.type ?? 'list';
//
//         if (type == 'list') {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ListItemDetailsPage(parentItem: it),
//             ),
//           );
//         } else {
//           final result = await showDialog<Map<String, dynamic>>(
//             context: context,
//             builder: (_) => AddItemDialog(
//               initialTitle: it.title,
//               initialSubtitle: it.subtitle ?? '',
//               initialImage: it.image ?? '',
//               initialUrl: it.url ?? '',
//               initialType: it.type ?? 'link',
//               itemId: it.id,
//             ),
//           );
//
//           if (result != null) {
//             setState(() {
//               it.title = result['title'];
//               it.subtitle = result['subtitle'];
//               it.image = result['image'];
//               it.type = result['type'];
//               it.url = result['externalUrl'];
//               it.imageName = result['imageName'];
//             });
//
//             try {
//               await ItemService.updateItem(
//                 itemId: it.id,
//                 title: it.title,
//                 subtitle: it.subtitle,
//                 imageUrl: it.image,
//                 externalUrl: it.url,
//                 type: it.type,
//               );
//             } catch (e) {
//               debugPrint('Failed to update item: $e');
//             }
//           }
//         }
//       },
//       // onReorder: (oldIndex, newIndex) async {
//       //   if (newIndex > oldIndex) newIndex -= 1;
//       //   setState(() {
//       //     final item = items.removeAt(oldIndex);
//       //     items.insert(newIndex, item);
//       //   });
//       //
//       //   try {
//       //     await ItemService.reorderItems(items);
//       //   } catch (e) {
//       //     debugPrint('Failed to update order: $e');
//       //   }
//       // },
//       onReorder: (oldIndex, newIndex) async {
//         setState(() {
//           if (newIndex > oldIndex) newIndex -= 1;
//           final moved = cardItems.removeAt(oldIndex);
//           cardItems.insert(newIndex, moved);
//         });
//
//         await _saveNavOrder();
//       },
//
//       onRemoveItem: (index) async {
//         try {
//           await ItemService.deleteItem(items[index].id);
//           setState(() {
//             items.removeAt(index);
//           });
//         } catch (e) {
//           debugPrint('Failed to delete item: $e');
//         }
//       },
//       onOpenDrawer: () => _scaffoldKey.currentState?.openEndDrawer(),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       endDrawer: CustomRightDrawer(
//         isInSublist: false,
//         parentId: null,
//         rootItem: null,
//         onAddItemToHome: (ItemModel newItem) {
//           setState(() {
//             items.add(newItem);
//             _fetchOrgNames();
//           });
//         },
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return Column(
//             children: [
//               _buildTopCards(context),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: _buildSelectedContent(constraints),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   /// ---------------------------------------------------------------------
//   /// Top cards: Reorderable (horizontal), loaded from API
//   /// ---------------------------------------------------------------------
//   Widget _buildTopCards(BuildContext context) {
//     final double cardHeight = MediaQuery.of(context).size.height * 0.09;
//
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.white,
//       ),
//       child: SizedBox(
//         height: cardHeight + 30, // Safe drag height
//         child: isLoadingNav
//             ? const Center(child: CircularProgressIndicator())
//             : ReorderableListView.builder(
//           scrollDirection: Axis.horizontal,
//           buildDefaultDragHandles: false,
//           itemCount: cardItems.length,
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           proxyDecorator: (child, index, animation) =>
//               Transform.scale(scale: 1.04, child: child),
//           onReorder: (oldIndex, newIndex) async {
//             setState(() {
//               if (newIndex > oldIndex) newIndex -= 1;
//               final moved = cardItems.removeAt(oldIndex);
//               cardItems.insert(newIndex, moved);
//             });
//
//             // save order to API
//             await _saveNavOrder();
//           },
//           itemBuilder: (context, index) {
//             final item = cardItems[index];
//             final label = item.label;
//             final iconData = mapIcon(item.icon);
//
//             return ReorderableDragStartListener(
//               key: ValueKey(item.id),
//               index: index,
//               child: GestureDetector(
//                 onTap: () => setState(() => selectedLabel = label),
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 8),
//                   height: cardHeight,
//                   width: 140, // FIXED WIDTH → FIXES DRAG ERRORS
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: selectedLabel == label
//                         ? Colors.grey.shade400
//                         : Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26.withOpacity(0.08),
//                         blurRadius: 4,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(iconData, size: 26, color: Colors.black87),
//                       const SizedBox(height: 6),
//                       Text(
//                         label.length > 11 ? "${label.substring(0, 11)}..." : label,
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black87,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSelectedContent(BoxConstraints constraints) {
//     // Match on navigation label. If you prefer matching by `type` or `id` change logic here.
//     switch (selectedLabel) {
//       case "Home":
//         return _buildHomeContent(constraints);
//
//       case "Service Time":
//         return const Padding(
//           padding: EdgeInsets.all(16),
//           child: Text("Service Time Details",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
//         );
//
//       case "Sermons/live":
//         return const Padding(
//           padding: EdgeInsets.all(16),
//           child: Text("Sermons / Live Stream Section",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
//         );
//
//       case "Bible":
//         return const Padding(
//           padding: EdgeInsets.all(16),
//           child: Text("Bible Section",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
//         );
//
//       case "Give":
//         return const Padding(
//           padding: EdgeInsets.all(16),
//           child: Text("Donation and Giving Options",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
//         );
//
//       default:
//       // If nav item is 'static' and has content, show it
//         final nav = cardItems.firstWhere(
//                 (c) => c.label == selectedLabel,
//             orElse: () => NavigationModel.empty());
//         if (nav.type == 'static' && (nav.content?.isNotEmpty ?? false)) {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(nav.content ?? '',
//                 style: const TextStyle(fontSize: 16)),
//           );
//         }
//
//         return const SizedBox();
//     }
//   }
// }


// lib/View/MobileApps/MobileApps.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/Get_all_item_controller.dart';
import '../../Controller/Navigation_controller.dart';
import '../../Controller/Organization_Controller.dart';
import '../../Model/Item_Model.dart';
import '../../Model/Navigation_model.dart';
import '../../Services/Icon_mapper.dart';
import '../../View_model/Listitem_details.dart';
import '../PopUp/Add_item_mobapp.dart';
import '../PopUp/Mobile_app_additem.dart';
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
  Map<String, String> orgNames = {};

  // Navigation cards loaded from API (organization-based)
  List<NavigationModel> cardItems = [];
  bool isLoadingNav = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
    _loadNavItems();
  }

  // -----------------------
  // Load items (home content)
  // -----------------------
  Future<void> _loadItems() async {
    try {
      final fetched = await ItemService.fetchItems();
      setState(() => items = fetched);
      await _fetchOrgNames();
    } catch (e) {
      debugPrint('Failed to load items: $e');
    }
  }

  // Fetch organization names for items (caching locally)
  Future<void> _fetchOrgNames() async {
    for (var item in items) {
      final orgId = item.organizationId;
      if (orgId != null && !orgNames.containsKey(orgId)) {
        final org = await OrganizationController.fetchOrganizationById(orgId);
        if (org != null && org['name'] != null) {
          orgNames[orgId] = org['name'];
        }
      }
    }
    setState(() {});
  }

  // -----------------------
  // Load navigation (org-based)
  // -----------------------
  Future<void> _loadNavItems() async {
    setState(() => isLoadingNav = true);

    try {
      final nav = await NavigationController.fetchNavigation();
      setState(() {
        cardItems = nav;

        // Ensure selectedLabel exists (fallback to first nav label)
        if (!cardItems.any((c) => c.label == selectedLabel) &&
            cardItems.isNotEmpty) {
          selectedLabel = cardItems.first.label;
        }
      });
    } catch (e) {
      debugPrint("Navigation load error: $e");
    } finally {
      setState(() => isLoadingNav = false);
    }
  }

  // -----------------------
  // Save navigation order to backend (bulk)
  // -----------------------
  Future<void> _saveNavOrder() async {
    try {
      await NavigationController.reorderNavigation(cardItems);
    } catch (e) {
      debugPrint("Save order error: $e");
    }
  }

  // -----------------------
  // Home content widget
  // -----------------------
  Widget _buildHomeContent(BoxConstraints constraints) {
    return HomeContent(
      constraints: constraints,
      items: items
          .map((itm) => {
        '_id': itm.id,
        'title': itm.title,
        'subtitle': itm.subtitle ?? '',
        'image': itm.image ?? '',
        'type': itm.type ?? '',
        'organizationName': orgNames[itm.organizationId] ?? '',
      })
          .toList(),
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
            setState(() {
              it.title = result['title'];
              it.subtitle = result['subtitle'];
              it.image = result['image'];
              it.type = result['type'];
              it.url = result['externalUrl'];
              it.imageName = result['imageName'];
            });

            try {
              await ItemService.updateItem(
                itemId: it.id,
                title: it.title,
                subtitle: it.subtitle,
                imageUrl: it.image,
                externalUrl: it.url,
                type: it.type,
              );
            } catch (e) {
              debugPrint('Failed to update item: $e');
            }
          }
        }
      },
      onReorder: (oldIndex, newIndex) async {
        // This reorders the navigation cards list (cardItems)
        setState(() {
          if (newIndex > oldIndex) newIndex -= 1;
          final moved = cardItems.removeAt(oldIndex);
          cardItems.insert(newIndex, moved);
        });

        await _saveNavOrder();
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

  // -----------------------
  // Build
  // -----------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CustomRightDrawer(
        isInSublist: false,
        parentId: null,
        rootItem: null,
        onAddItemToHome: (ItemModel newItem) {
          setState(() {
            items.add(newItem);
            _fetchOrgNames();
          });
        },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              _buildTopCards(context),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildSelectedContent(constraints),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// ---------------------------------------------------------------------
  /// Top cards: Reorderable (horizontal), loaded from API
  /// ---------------------------------------------------------------------
  Widget _buildTopCards(BuildContext context) {
    final double cardHeight = MediaQuery.of(context).size.height * 0.09;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: SizedBox(
        height: cardHeight + 30, // Safe drag height
        child: isLoadingNav
            ? const Center(child: CircularProgressIndicator())
            : ReorderableListView.builder(
          scrollDirection: Axis.horizontal,
          buildDefaultDragHandles: false,
          itemCount: cardItems.length,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          proxyDecorator: (child, index, animation) =>
              Transform.scale(scale: 1.04, child: child),
          onReorder: (oldIndex, newIndex) async {
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
              final moved = cardItems.removeAt(oldIndex);
              cardItems.insert(newIndex, moved);
            });

            // save order to API (bulk)
            await _saveNavOrder();
          },
          itemBuilder: (context, index) {
            final item = cardItems[index];
            final label = item.label;
            final iconData = mapIcon(item.icon);

            return ReorderableDragStartListener(
              key: ValueKey(item.id),
              index: index,
              child: GestureDetector(
                onTap: () => setState(() => selectedLabel = label),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  height: cardHeight,
                  width: 140, // FIXED WIDTH → FIXES DRAG ERRORS
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: selectedLabel == label
                        ? Colors.grey.shade400
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(iconData, size: 26, color: Colors.black87),
                      const SizedBox(height: 6),
                      Text(
                        label.length > 11
                            ? "${label.substring(0, 11)}..."
                            : label,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // -----------------------
  // Selected content (by label)
  // -----------------------
  Widget _buildSelectedContent(BoxConstraints constraints) {
    // Match on navigation label. If you prefer matching by `type` or `id` change logic here.
    switch (selectedLabel) {
      case "Home":
        return _buildHomeContent(constraints);

      case "Service Time":
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Service Time Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        );

      case "sermons":
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Sermons / Live Stream Section",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        );

      case "Bible":
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Bible Section",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        );

      case "Give":
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Donation and Giving Options",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        );

      default:
      // If nav item is 'static' and has content, show it
        final nav = cardItems.firstWhere(
              (c) => c.label == selectedLabel,
          orElse: () => NavigationModel(
            id: '',
            label: '',
            icon: '',
            type: '',
            content: '',
            order: 0,
            isActive: false,
          ),
        );

        if (nav.type == 'static' && (nav.content?.isNotEmpty ?? false)) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(nav.content ?? '', style: const TextStyle(fontSize: 16)),
          );
        }

        return const SizedBox();
    }
  }
}
