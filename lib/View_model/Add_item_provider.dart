// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'dart:typed_data';
// import 'package:adminpanel/View/PopUp/Mobile_app _additem.dart';
// import 'package:adminpanel/View_model/Add_item_mobapp.dart';
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
//   void showItemDetailsDialog(BuildContext context, Map<String, dynamic> item) {
//     showDialog(
//       context: context,
//       builder: (context) => ItemDetailsDialog(item: item),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return Column(
//             children: [
//               _buildTopCards(context),
//               Expanded(
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(constraints.maxWidth * 0.02),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Left Panel
//                         Expanded(
//                           flex: 2,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Content",
//                                   style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
//                               const Divider(),
//                               const SizedBox(height: 16),
//                               Expanded(
//                                 child: items.isEmpty
//                                     ? const Center(child: Text("No items yet."))
//                                     : ReorderableListView.builder(
//                                   buildDefaultDragHandles: false,
//                                   itemCount: items.length,
//                                   onReorder: (oldIndex, newIndex) {
//                                     if (newIndex > oldIndex) newIndex -= 1;
//                                     setState(() {
//                                       final item = items.removeAt(oldIndex);
//                                       items.insert(newIndex, item);
//                                     });
//                                   },
//                                   itemBuilder: (context, index) {
//                                     final item = items[index];
//                                     final imageWidget = item['image'] is Uint8List
//                                         ? Image.memory(item['image'], height: 50, width: 50, fit: BoxFit.cover)
//                                         : Image.network(
//                                       item['image'],
//                                       height: 50,
//                                       width: 50,
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (context, error, stackTrace) => Container(
//                                         width: 50,
//                                         height: 50,
//                                         color: Colors.grey.shade300,
//                                         child: const Icon(Icons.broken_image),
//                                       ),
//                                     );
//
//                                     return ListTile(
//                                       key: ValueKey(item['title']),
//                                       onTap: () => showItemDetailsDialog(context, item),
//                                       leading: ReorderableDragStartListener(
//                                         index: index,
//                                         child: MouseRegion(
//                                           cursor: SystemMouseCursors.grab,
//                                           child: const Icon(Iconsax.element_3),
//                                         ),
//                                       ),
//                                       title: Row(
//                                         children: [
//                                           ClipRRect(
//                                             borderRadius: BorderRadius.circular(12),
//                                             child: imageWidget,
//                                           ),
//                                           const SizedBox(width: 12),
//                                           Expanded(
//                                             child: Text(
//                                               item['title'],
//                                               style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
//                                             ),
//                                           ),
//                                           PopupMenuButton<String>(
//                                             icon: const Icon(Iconsax.more),
//                                             onSelected: (value) {
//                                               if (value == 'Remove') {
//                                                 setState(() {
//                                                   items.removeAt(index);
//                                                 });
//                                               }
//                                             },
//                                             itemBuilder: (context) => [
//                                               const PopupMenuItem<String>(
//                                                 value: 'Remove',
//                                                 child: Text('Remove'),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         // Right Panel
//                         Expanded(
//                           flex: 1,
//                           child: Column(
//                             children: [
//                               _placeholderBox(context),
//                               const SizedBox(height: 16),
//                               _placeholderBox(context),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _placeholderBox(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * .3,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.grey.shade50,
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
//                   .map((item) => buildAppCard(item["label"].toString(), item["icon"] as IconData, context))
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
//         child: Container(
//           height: cardHeight,
//           width: cardWidth,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             color: isSelected ? Colors.grey.shade400 : Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 4,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(icon, size: 28, color: Colors.black87),
//                 const SizedBox(height: 8),
//                 Text(
//                   shortLabel,
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
