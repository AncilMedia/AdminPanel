// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../Controller/PushNotification_controller.dart';
// import '../../Controller/right_drawer_controller.dart';
// import '../../Controller/Get_all_item_controller.dart';
// import '../../Model/list_model.dart';
// import '../../Model/Item_Model.dart';
// import '../../View_model/Listitem_details.dart';
//
// enum DrawerSelection { list, link, event }
//
// extension StringCasing on String {
//   String capitalize() => length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : this;
// }
//
// extension DrawerSelectionExtension on DrawerSelection {
//   bool get isList => this == DrawerSelection.list;
//   bool get isLink => this == DrawerSelection.link;
//   bool get isEvent => this == DrawerSelection.event;
// }
//
// void showCustomSnackBar(BuildContext context, String message, bool isSuccess) {
//   final screenWidth = MediaQuery.of(context).size.width;
//
//   final snackBar = SnackBar(
//     backgroundColor: Colors.transparent,
//     elevation: 0,
//     behavior: SnackBarBehavior.floating,
//     content: Center(
//       child: Container(
//         width: screenWidth * 1,
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
//         decoration: BoxDecoration(
//           color: isSuccess ? Colors.green : Colors.red,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Text(
//           message,
//           textAlign: TextAlign.center,
//           style: const TextStyle(color: Colors.white, fontSize: 16),
//         ),
//       ),
//     ),
//     duration: const Duration(seconds: 3),
//   );
//
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }
//
// class CustomRightDrawer extends StatefulWidget {
//   final void Function(ItemModel newItem)? onAddItemToHome;
//   final String? parentId;
//   final ItemModel? rootItem;
//   final bool isInSublist;
//
//   const CustomRightDrawer({
//     super.key,
//     this.onAddItemToHome,
//     this.parentId,
//     this.rootItem,
//     required this.isInSublist,
//   });
//
//   @override
//   State<CustomRightDrawer> createState() => _CustomRightDrawerState();
// }
//
// class _CustomRightDrawerState extends State<CustomRightDrawer> with SingleTickerProviderStateMixin {
//   DrawerSelection selected = DrawerSelection.list;
//   List<ListModel> recentLists = [];
//   bool showCreateForm = false;
//   String newTitle = '';
//   String newSubtitle = '';
//   String newUrl = '';
//   Uint8List? pickedImage;
//   bool isLoading = false;
//   bool isSaving = false;
//   String searchQuery = '';
//   bool animateButton = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadLists();
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (mounted) setState(() => animateButton = true);
//     });
//   }
//
//
//   Future<void> _loadLists() async {
//     setState(() => isLoading = true);
//     try {
//       if (widget.isInSublist) {
//         final lists = await ListController.fetchLists(parentId: widget.parentId);
//         setState(() => recentLists = lists.where((l) => l.type == selected.name).toList());
//       } else {
//         final items = await ItemService.fetchItems(parentId: null); // ✅ FIXED
//         setState(() {
//           recentLists = items
//               .where((i) => i.type == selected.name)
//               .map((i) => ListModel(
//             id: i.id,
//             title: i.title,
//             subtitle: i.subtitle,
//             image: i.image ?? '',
//             parentId: i.parentId,
//             index: i.index ?? 0,
//             type: i.type,
//           ))
//               .toList();
//         });
//       }
//     } catch (e) {
//       debugPrint('Failed to load items: $e');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> _pickImage() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
//     if (result != null && result.files.single.bytes != null) {
//       setState(() => pickedImage = result.files.single.bytes!);
//     }
//   }
//
//   // Future<void> _handleCreateNewList() async {
//   //   if (newTitle.trim().isEmpty) {
//   //     showCustomSnackBar(context, 'Title is required', false);
//   //     return;
//   //   }
//   //
//   //   setState(() => isSaving = true);
//   //
//   //   try {
//   //     ItemModel newItem;
//   //
//   //     debugPrint("📥 Creating new item:");
//   //     debugPrint("  title: $newTitle");
//   //     debugPrint("  subtitle: $newSubtitle");
//   //     debugPrint("  type: ${selected.name}");
//   //     debugPrint("  parentId: ${widget.parentId}");
//   //     debugPrint("  isSublist: ${widget.isInSublist}");
//   //
//   //     if (widget.isInSublist) {
//   //       // ✅ Create sublist item (ListController)
//   //       final newList = await ListController.createList(
//   //         newTitle.trim(),
//   //         newSubtitle.trim(),
//   //         imageBytes: pickedImage,
//   //         parentId: widget.parentId,
//   //         type: selected.name,
//   //         url: selected.isLink ? newUrl.trim() : null,
//   //       );
//   //
//   //       newItem = ItemModel(
//   //         id: newList.id,
//   //         title: newList.title,
//   //         subtitle: newList.subtitle,
//   //         image: newList.image,
//   //         type: newList.type ?? selected.name,
//   //         parentId: newList.parentId,
//   //         index: newList.index,
//   //       );
//   //     } else {
//   //       // ✅ Create top-level item (ItemService)
//   //       newItem = await ItemService.createItem(
//   //         title: newTitle.trim(),
//   //         subtitle: newSubtitle.trim(),
//   //         imageBytes: pickedImage,
//   //         type: selected.name,
//   //         url: selected.isLink ? newUrl.trim() : null,
//   //       );
//   //     }
//   //
//   //     widget.onAddItemToHome?.call(newItem);
//   //
//   //     setState(() {
//   //       showCreateForm = false;
//   //       newTitle = '';
//   //       newSubtitle = '';
//   //       newUrl = '';
//   //       pickedImage = null;
//   //     });
//   //
//   //     showCustomSnackBar(context, "Item created successfully!", true);
//   //     await _loadLists();
//   //   } catch (e) {
//   //     debugPrint("❌ Create item failed: $e");
//   //     showCustomSnackBar(context, "Failed to save", false);
//   //   } finally {
//   //     setState(() => isSaving = false);
//   //   }
//   // }
//
//   // Future<void> _handleCreateNewList() async {
//   //   if (newTitle.trim().isEmpty) {
//   //     showCustomSnackBar(context, 'Title is required', false);
//   //     return;
//   //   }
//   //
//   //   setState(() => isSaving = true);
//   //
//   //   try {
//   //     ItemModel newItem;
//   //
//   //     debugPrint("📥 Creating new item:");
//   //     debugPrint("  title: $newTitle");
//   //     debugPrint("  subtitle: $newSubtitle");
//   //     debugPrint("  type: ${selected.name}");
//   //     debugPrint("  parentId: ${widget.parentId}");
//   //     debugPrint("  isSublist: ${widget.isInSublist}");
//   //
//   //     if (widget.isInSublist) {
//   //       final newList = await ListController.createList(
//   //         newTitle.trim(),
//   //         newSubtitle.trim(),
//   //         imageBytes: pickedImage,
//   //         parentId: widget.parentId,
//   //         type: selected.name,
//   //         url: selected.isLink ? newUrl.trim() : null,
//   //       );
//   //
//   //       newItem = ItemModel(
//   //         id: newList.id,
//   //         title: newList.title,
//   //         subtitle: newList.subtitle,
//   //         image: newList.image,
//   //         type: newList.type ?? selected.name,
//   //         parentId: newList.parentId,
//   //         index: newList.index,
//   //       );
//   //     } else {
//   //       newItem = await ItemService.createItem(
//   //         title: newTitle.trim(),
//   //         subtitle: newSubtitle.trim(),
//   //         imageBytes: pickedImage,
//   //         type: selected.name,
//   //         url: selected.isLink ? newUrl.trim() : null,
//   //       );
//   //     }
//   //
//   //     // ✅ Get organizationId from local storage
//   //     final prefs = await SharedPreferences.getInstance();
//   //     final organizationId = prefs.getString("organizationId");
//   //
//   //     if (organizationId != null) {
//   //       await PushNotificationController.sendNotification(
//   //         title: "New ${selected.name.capitalize()} Added",
//   //         body: "A new ${selected.name} has been created: $newTitle",
//   //         event: "create_${selected.name}",
//   //         type: selected.name,
//   //         organizationId: organizationId,
//   //       );
//   //       debugPrint("📢 Notification sent to organization: $organizationId");
//   //     } else {
//   //       debugPrint("⚠️ No organizationId found in local storage");
//   //     }
//   //
//   //     widget.onAddItemToHome?.call(newItem);
//   //
//   //     setState(() {
//   //       showCreateForm = false;
//   //       newTitle = '';
//   //       newSubtitle = '';
//   //       newUrl = '';
//   //       pickedImage = null;
//   //     });
//   //
//   //     showCustomSnackBar(context, "Item created successfully!", true);
//   //     await _loadLists();
//   //   } catch (e) {
//   //     debugPrint("❌ Create item failed: $e");
//   //     showCustomSnackBar(context, "Failed to save", false);
//   //   } finally {
//   //     setState(() => isSaving = false);
//   //   }
//   // }
//
//   Future<void> _handleCreateNewList() async {
//     if (newTitle.trim().isEmpty) {
//       showCustomSnackBar(context, 'Title is required', false);
//       return;
//     }
//
//     setState(() => isSaving = true);
//
//     try {
//       ItemModel newItem;
//
//       debugPrint("📥 Creating new item:");
//       debugPrint("  title: $newTitle");
//       debugPrint("  subtitle: $newSubtitle");
//       debugPrint("  type: ${selected.name}");
//       debugPrint("  parentId: ${widget.parentId}");
//       debugPrint("  isSublist: ${widget.isInSublist}");
//
//       if (widget.isInSublist) {
//         final newList = await ListController.createList(
//           newTitle.trim(),
//           newSubtitle.trim(),
//           imageBytes: pickedImage,
//           parentId: widget.parentId,
//           type: selected.name,
//           url: selected.isLink ? newUrl.trim() : null,
//         );
//
//         newItem = ItemModel(
//           id: newList.id,
//           title: newList.title,
//           subtitle: newList.subtitle,
//           image: newList.image,
//           type: newList.type ?? selected.name,
//           parentId: newList.parentId,
//           index: newList.index,
//         );
//       } else {
//         newItem = await ItemService.createItem(
//           title: newTitle.trim(),
//           subtitle: newSubtitle.trim(),
//           imageBytes: pickedImage,
//           type: selected.name,
//           url: selected.isLink ? newUrl.trim() : null,
//         );
//       }
//
//       // ✅ Get organizationId from local storage
//       final prefs = await SharedPreferences.getInstance();
//       final organizationId = prefs.getString("organizationId");
//
//       if (organizationId != null) {
//         final notifResponse = await PushNotificationController.sendNotification(
//           title: "New ${selected.name.capitalize()} Added",
//           body: "A new ${selected.name} has been created: $newTitle",
//           event: "create_${selected.name}",
//           type: selected.name,
//           organizationId: organizationId,
//         );
//
//         final status = notifResponse['status'];
//         final data = notifResponse['data'];
//
//         if (status == 200) {
//           debugPrint("📢 Notification sent to organization: $organizationId");
//           showCustomSnackBar(context, "Created Successfully !!", true);
//         } else if (status == 400 &&
//             data['message'].toString().contains("No FCM tokens")) {
//           debugPrint("⚠️ No FCM tokens found → cannot send notification");
//           showCustomSnackBar(context,
//               "⚠️ No mobile devices registered. Notification not sent.", false);
//         } else {
//           debugPrint("❌ Notification failed: $data");
//           showCustomSnackBar(
//               context, "❌ Notification failed: ${data['message']}", false);
//         }
//       } else {
//         debugPrint("⚠️ No organizationId found in local storage");
//         showCustomSnackBar(context, "Item created, but no organization found for notification", false);
//       }
//
//       widget.onAddItemToHome?.call(newItem);
//
//       setState(() {
//         showCreateForm = false;
//         newTitle = '';
//         newSubtitle = '';
//         newUrl = '';
//         pickedImage = null;
//       });
//
//       await _loadLists();
//     } catch (e) {
//       debugPrint("❌ Create item failed: $e");
//       showCustomSnackBar(context, "❌ Failed to save item: $e", false);
//     } finally {
//       setState(() => isSaving = false);
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final filteredLists = recentLists
//         .where((list) => list.title.toLowerCase().contains(searchQuery.toLowerCase()))
//         .toList();
//
//     return SizedBox(
//       width: 400,
//       child: Drawer(
//         backgroundColor: Colors.white,
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: showCreateForm ? _buildCreateForm() : _buildMainDrawer(filteredLists),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMainDrawer(List<ListModel> filteredLists) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Select Type:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
//         for (var option in DrawerSelection.values)
//           RadioListTile<DrawerSelection>(
//             title: Text(option.name.capitalize(), style: GoogleFonts.poppins()),
//             value: option,
//             groupValue: selected,
//             onChanged: (val) {
//               setState(() {
//                 selected = val!;
//                 _loadLists();
//               });
//             },
//           ),
//         const Divider(),
//         TextFormField(
//           decoration: InputDecoration(
//             labelText: 'Search',
//             prefixIcon: const Icon(Icons.search),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//           onChanged: (val) => setState(() => searchQuery = val),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           children: [
//             Expanded(child: Divider(color: Colors.grey)),
//             const SizedBox(width: 10),
//             Expanded(child: Divider(color: Colors.grey)),
//           ],
//         ),
//         const SizedBox(height: 10),
//         AnimatedOpacity(
//           duration: const Duration(milliseconds: 600),
//           opacity: animateButton ? 1.0 : 0.0,
//           child: AnimatedScale(
//             duration: const Duration(milliseconds: 600),
//             scale: animateButton ? 1.0 : 0.8,
//             curve: Curves.easeOutBack,
//             child: Center(
//               child: GestureDetector(
//                 onTap: () => setState(() => showCreateForm = true),
//                 child: MouseRegion(
//                   cursor: SystemMouseCursors.click,
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * .0400,
//                     width: MediaQuery.of(context).size.width * .110,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.purpleAccent.shade100,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Iconsax.add_circle),
//                         const SizedBox(width: 8),
//                         Text("Create ${selected.name.capitalize()}", style: GoogleFonts.poppins()),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Divider(thickness: 2, color: Colors.purple.shade200),
//         const SizedBox(height: 16),
//         if (isLoading)
//           Center(child: Lottie.asset('assets/Loading star.json',options: LottieOptions(enableMergePaths: false),))
//         else if (filteredLists.isEmpty)
//           Text("No items found", style: GoogleFonts.poppins(color: Colors.grey))
//         else
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: filteredLists.length,
//             itemBuilder: (context, index) {
//               final list = filteredLists[index];
//               return FallingListItem(
//                 delay: Duration(milliseconds: 100 * index),
//                 child: ListTile(
//                   leading: list.image.isNotEmpty
//                       ? ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.network(
//                       list.image,
//                       width: 40,
//                       height: 40,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) =>
//                       const Icon(Icons.image_not_supported),
//                     ),
//                   )
//                       : const Icon(Iconsax.image, size: 30),
//                   title: Text(list.title, style: GoogleFonts.poppins()),
//                   subtitle: Text(list.subtitle ?? '', style: GoogleFonts.poppins(fontSize: 12)),
//                   onTap: () {
//                     if ((list.type ?? 'list') == 'list') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => ListItemDetailsPage(
//                             parentItem: ItemModel(
//                               id: list.id,
//                               title: list.title,
//                               subtitle: list.subtitle,
//                               image: list.image,
//                               type: 'list',
//                               parentId: list.parentId,
//                               index: list.index,
//                             ),
//                             rootItem: widget.rootItem ??
//                                 ItemModel(
//                                   id: list.id,
//                                   title: list.title,
//                                   subtitle: list.subtitle,
//                                   image: list.image,
//                                   type: 'list',
//                                   parentId: list.parentId,
//                                   index: list.index,
//                                 ),
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               );
//             },
//           ),
//       ],
//     );
//   }
//
//   Widget _buildCreateForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             IconButton(
//               icon: const Icon(Iconsax.arrow_left),
//               onPressed: () => setState(() {
//                 showCreateForm = false;
//                 newTitle = '';
//                 newSubtitle = '';
//                 newUrl = '';
//                 pickedImage = null;
//               }),
//             ),
//             Text(
//               "Create New ${selected.name.capitalize()}",
//               style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         TextFormField(
//           decoration: InputDecoration(
//             labelText: 'Title',
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//           onChanged: (val) => setState(() => newTitle = val),
//         ),
//         const SizedBox(height: 12),
//         TextFormField(
//           decoration: InputDecoration(
//             labelText: 'Subtitle',
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//           onChanged: (val) => setState(() => newSubtitle = val),
//         ),
//         if (selected.isLink) ...[
//           const SizedBox(height: 12),
//           TextFormField(
//             decoration: InputDecoration(
//               labelText: 'URL',
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//             ),
//             onChanged: (val) => setState(() => newUrl = val),
//           ),
//         ],
//         const SizedBox(height: 12),
//         GestureDetector(
//           onTap: _pickImage,
//           child: Container(
//             width: double.infinity,
//             height: 150,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.grey.shade100,
//             ),
//             child: pickedImage == null
//                 ? Center(child: Text("Tap to pick image", style: GoogleFonts.poppins()))
//                 : ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.memory(pickedImage!, fit: BoxFit.cover),
//             ),
//           ),
//         ),
//         const SizedBox(height: 24),
//         Row(
//           children: [
//             Expanded(
//               child: ElevatedButton.icon(
//                 icon: isSaving
//                     ? SizedBox(
//                   height: 24,
//                   width: 24,
//                   child: Lottie.asset('assets/Bouncing_dots.json',options: LottieOptions(enableMergePaths: false),),
//                 )
//                     : const Icon(Iconsax.save_2),
//                 onPressed: isSaving || newTitle.trim().isEmpty ? null : _handleCreateNewList,
//                 label: Text(isSaving ? "Saving..." : "Save", style: GoogleFonts.poppins()),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: OutlinedButton.icon(
//                 icon: const Icon(Iconsax.close_circle),
//                 onPressed: () => setState(() {
//                   showCreateForm = false;
//                   newTitle = '';
//                   newSubtitle = '';
//                   newUrl = '';
//                   pickedImage = null;
//                 }),
//                 label: Text("Cancel", style: GoogleFonts.poppins()),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// class FallingListItem extends StatefulWidget {
//   final Widget child;
//   final Duration delay;
//
//   const FallingListItem({super.key, required this.child, required this.delay});
//
//   @override
//   State<FallingListItem> createState() => _FallingListItemState();
// }
//
// class _FallingListItemState extends State<FallingListItem> with SingleTickerProviderStateMixin {
//   bool _visible = false;
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(widget.delay, () {
//       if (mounted) setState(() => _visible = true);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSlide(
//       offset: _visible ? Offset.zero : const Offset(0, -0.3),
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeOutBack,
//       child: AnimatedOpacity(
//         opacity: _visible ? 1.0 : 0.0,
//         duration: const Duration(milliseconds: 500),
//         child: widget.child,
//       ),
//     );
//   }
// }


import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/PushNotification_controller.dart';
import '../../Controller/right_drawer_controller.dart';
import '../../Controller/Get_all_item_controller.dart';
import '../../Model/list_model.dart';
import '../../Model/Item_Model.dart';
import '../../View_model/Listitem_details.dart';

enum DrawerSelection { list, link, event }

extension StringCasing on String {
  String capitalize() => length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : this;
}

extension DrawerSelectionExtension on DrawerSelection {
  bool get isList => this == DrawerSelection.list;
  bool get isLink => this == DrawerSelection.link;
  bool get isEvent => this == DrawerSelection.event;
}

void showCustomSnackBar(BuildContext context, String message, bool isSuccess) {
  final screenWidth = MediaQuery.of(context).size.width;

  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    content: Center(
      child: Container(
        width: screenWidth * 1,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: isSuccess ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

class _CustomRightDrawerState extends State<CustomRightDrawer> with SingleTickerProviderStateMixin {
  DrawerSelection selected = DrawerSelection.list;
  List<ListModel> recentLists = [];
  bool showCreateForm = false;
  String newTitle = '';
  String newSubtitle = '';
  String newUrl = '';
  Uint8List? pickedImage;
  bool isLoading = false;
  bool isSaving = false;
  String searchQuery = '';
  bool animateButton = false;

  // // ===== EVENT VARIABLES =====
  // DateTime? startDate;
  // DateTime? endDate;
  // TimeOfDay? startTime;
  // TimeOfDay? endTime;
  // bool isAllDay = false;
  // String selectedCalendar = 'Church Calendar';

  // ===== EVENT VARIABLES =====
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isAllDay = false;
  String selectedCalendar = 'Church Calendar';

  // ===== COMBINED DATETIME =====
  DateTime? get startDateTime {
    if (startDate == null) return null;
    return DateTime(
      startDate!.year,
      startDate!.month,
      startDate!.day,
      startTime?.hour ?? 0,
      startTime?.minute ?? 0,
    );
  }

  DateTime? get endDateTime {
    if (endDate == null) return null;
    return DateTime(
      endDate!.year,
      endDate!.month,
      endDate!.day,
      endTime?.hour ?? 0,
      endTime?.minute ?? 0,
    );
  }
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
        final lists = await ListController.fetchLists(parentId: widget.parentId);
        setState(() => recentLists = lists.where((l) => l.type == selected.name).toList());
      } else {
        final items = await ItemService.fetchItems(parentId: null); // ✅ FIXED
        setState(() {
          recentLists = items
              .where((i) => i.type == selected.name)
              .map((i) => ListModel(
            id: i.id,
            title: i.title,
            subtitle: i.subtitle,
            image: i.image ?? '',
            parentId: i.parentId,
            index: i.index ?? 0,
            type: i.type,
          ))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Failed to load items: $e');
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

  // Future<void> _handleCreateNewList() async {
  //   if (newTitle.trim().isEmpty) {
  //     showCustomSnackBar(context, 'Title is required', false);
  //     return;
  //   }
  //
  //   setState(() => isSaving = true);
  //
  //   try {
  //     ItemModel newItem;
  //
  //     debugPrint("📥 Creating new item:");
  //     debugPrint("  title: $newTitle");
  //     debugPrint("  subtitle: $newSubtitle");
  //     debugPrint("  type: ${selected.name}");
  //     debugPrint("  parentId: ${widget.parentId}");
  //     debugPrint("  isSublist: ${widget.isInSublist}");
  //
  //     if (widget.isInSublist) {
  //       final newList = await ListController.createList(
  //         newTitle.trim(),
  //         newSubtitle.trim(),
  //         imageBytes: pickedImage,
  //         parentId: widget.parentId,
  //         type: selected.name,
  //         url: selected.isLink ? newUrl.trim() : null,
  //       );
  //
  //       newItem = ItemModel(
  //         id: newList.id,
  //         title: newList.title,
  //         subtitle: newList.subtitle,
  //         image: newList.image,
  //         type: newList.type ?? selected.name,
  //         parentId: newList.parentId,
  //         index: newList.index,
  //       );
  //     } else {
  //       newItem = await ItemService.createItem(
  //         title: newTitle.trim(),
  //         subtitle: newSubtitle.trim(),
  //         imageBytes: pickedImage,
  //         type: selected.name,
  //         url: selected.isLink ? newUrl.trim() : null,
  //       );
  //     }
  //
  //     // ✅ Get organizationId from local storage
  //     final prefs = await SharedPreferences.getInstance();
  //     final organizationId = prefs.getString("organizationId");
  //
  //     if (organizationId != null) {
  //       final notifResponse = await PushNotificationController.sendNotification(
  //         title: "New ${selected.name.capitalize()} Added",
  //         body: "A new ${selected.name} has been created: $newTitle",
  //         event: "create_${selected.name}",
  //         type: selected.name,
  //         organizationId: organizationId,
  //       );
  //
  //       final status = notifResponse['status'];
  //       final data = notifResponse['data'];
  //
  //       if (status == 200) {
  //         debugPrint("📢 Notification sent to organization: $organizationId");
  //         showCustomSnackBar(context, "Created Successfully !!", true);
  //       } else if (status == 400 &&
  //           data['message'].toString().contains("No FCM tokens")) {
  //         debugPrint("⚠️ No FCM tokens found → cannot send notification");
  //         showCustomSnackBar(context,
  //             "⚠️ No mobile devices registered. Notification not sent.", false);
  //       } else {
  //         debugPrint("❌ Notification failed: $data");
  //         showCustomSnackBar(
  //             context, "❌ Notification failed: ${data['message']}", false);
  //       }
  //     } else {
  //       debugPrint("⚠️ No organizationId found in local storage");
  //       showCustomSnackBar(context, "Item created, but no organization found for notification", false);
  //     }
  //
  //     widget.onAddItemToHome?.call(newItem);
  //
  //     setState(() {
  //       showCreateForm = false;
  //       newTitle = '';
  //       newSubtitle = '';
  //       newUrl = '';
  //       pickedImage = null;
  //     });
  //
  //     await _loadLists();
  //   } catch (e) {
  //     debugPrint("❌ Create item failed: $e");
  //     showCustomSnackBar(context, "❌ Failed to save item: $e", false);
  //   } finally {
  //     setState(() => isSaving = false);
  //   }
  // }

  // ================= CREATE =================
  Future<void> _handleCreateNewList() async {
    if (newTitle.trim().isEmpty) {
      _snack("Title required", false);
      return;
    }

    if (selected.isEvent && startDateTime == null) {
      _snack("Start date required", false);
      return;
    }

    setState(() => isSaving = true);

    try {
      ItemModel newItem;

      if (widget.isInSublist) {
        final newList = await ListController.createList(
          newTitle.trim(),
          newSubtitle.trim(),
          imageBytes: pickedImage,
          parentId: widget.parentId,
          type: selected.name,
          url: selected.isLink ? newUrl.trim() : null,
        );

        newItem = ItemModel(
          id: newList.id,
          title: newList.title,
          subtitle: newList.subtitle,
          image: newList.image,
          type: newList.type ?? selected.name,
          parentId: newList.parentId,
          index: newList.index,
        );
      } else {
        newItem = await ItemService.createItem(
          title: newTitle.trim(),
          subtitle: newSubtitle.trim(),
          imageBytes: pickedImage,
          type: selected.name,
          url: selected.isLink ? newUrl.trim() : null,

          // ✅ FIXED HERE (IMPORTANT)
          startDateTime: selected.isEvent && startDateTime != null
              ? startDateTime!.toIso8601String()
              : null,

          endDateTime: selected.isEvent && endDateTime != null
              ? endDateTime!.toIso8601String()
              : null,

          isAllDay: selected.isEvent ? isAllDay : null,
          calendar: selected.isEvent ? selectedCalendar : null,
        );
      }

      final prefs = await SharedPreferences.getInstance();
      final orgId = prefs.getString("organizationId");

      if (orgId != null) {
        await PushNotificationController.sendNotification(
          title: "New ${selected.name.capitalize()} Added",
          body: "$newTitle created",
          event: "create_${selected.name}",
          type: selected.name,
          organizationId: orgId,
        );
      }

      widget.onAddItemToHome?.call(newItem);

      setState(() {
        showCreateForm = false;
        newTitle = '';
        newSubtitle = '';
        newUrl = '';
        pickedImage = null;

        // reset event fields
        startDate = null;
        endDate = null;
        startTime = null;
        endTime = null;
        isAllDay = false;
        selectedCalendar = 'Church Calendar';
      });

      await _loadLists();
      _snack("Created Successfully", true);
    } catch (e) {
      _snack("Error: $e", false);
    }

    setState(() => isSaving = false);
  }
  void _snack(String msg, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: success ? Colors.green : Colors.red),
    );
  }


  @override
  Widget build(BuildContext context) {
    final filteredLists = recentLists
        .where((list) => list.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- TYPE SELECTION (Chips instead of Radio) ---
          Text("Select Type", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DrawerSelection.values.map((option) {
              bool isSelected = selected == option;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selected = option;
                    _loadLists();
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.purpleAccent.shade100.withOpacity(0.2) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? Colors.purpleAccent.shade200 : Colors.transparent),
                  ),
                  child: Text(
                    option.name.capitalize(),
                    style: GoogleFonts.poppins(
                      color: isSelected ? Colors.purple.shade700 : Colors.grey.shade600,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // --- MODERN SEARCH BAR ---
          _input("Search items...", (val) => setState(() => searchQuery = val), icon: Iconsax.search_normal),

          const SizedBox(height: 20),

          // --- ANIMATED CREATE BUTTON ---
          AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            opacity: animateButton ? 1.0 : 0.0,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 600),
              scale: animateButton ? 1.0 : 0.9,
              curve: Curves.easeOutBack,
              child: InkWell(
                onTap: () => setState(() => showCreateForm = true),
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purpleAccent.shade100, Colors.deepPurpleAccent.shade100],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.purpleAccent.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Iconsax.add_square, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        "Create ${selected.name.capitalize()}",
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              Text("Existing Records", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
              const Spacer(),
              Container(height: 1, width: 40, color: Colors.grey.shade300),
            ],
          ),
          const SizedBox(height: 12),

          // --- LIST VIEW WITH MODERN CARDS ---
          if (isLoading)
            Center(child: Lottie.asset('assets/Loading star.json', height: 100))
          else if (filteredLists.isEmpty)
            _buildEmptyState()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredLists.length,
              itemBuilder: (context, index) {
                final list = filteredLists[index];
                return FallingListItem(
                  delay: Duration(milliseconds: 80 * index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      leading: _buildListImage(list.image),
                      title: Text(list.title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                      subtitle: Text(list.subtitle ?? '', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                      trailing: const Icon(Iconsax.arrow_right_3, size: 16, color: Colors.grey),
                      onTap: () => _handleNavigation(list),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _searchField(String hint, Function(String) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Iconsax.search_normal, size: 20, color: Colors.purpleAccent),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
      ),
    );
  }
// --- HELPER TO BUILD IMAGE OR PLACEHOLDER ---
  Widget _buildListImage(String imageUrl) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: imageUrl.isNotEmpty
          ? ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Iconsax.image)),
      )
          : const Icon(Iconsax.image, color: Colors.grey),
    );
  }

// --- EMPTY STATE UI ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Iconsax.ghost, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          Text("No results found", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
// --- MISSING PICKER LOGIC ---
  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => isStart ? startDate = picked : endDate = picked);
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => isStart ? startTime = picked : endTime = picked);
    }
  }

// --- UPDATED UI FORM ---
  Widget _eventFormUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _glassCard(
            child: Column(
              children: [
                _sectionHeader(Iconsax.info_circle, "Basic Details"),
                const SizedBox(height: 16),
                // Fixed icon name to 'document_text'
                _input("Event Title", (v) => newTitle = v, icon: Iconsax.document_text),
                // Fixed icon name to 'text'
                _input("Subtitle", (v) => newSubtitle = v, icon: Iconsax.text),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _glassCard(
            child: Column(
              children: [
                _sectionHeader(Iconsax.calendar, "Date & Time"),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Fixed icon to 'calendar'
                    Expanded(child: _modernPicker("Starts", startDate == null ? "Set Date" : "${startDate!.day}/${startDate!.month}/${startDate!.year}", Iconsax.calendar, () => _pickDate(true))),
                    const SizedBox(width: 12),
                    Expanded(child: _modernPicker("At", startTime?.format(context) ?? "Set Time", Iconsax.clock, () => _pickTime(true))),
                  ],
                ),
                const Divider(height: 32, color: Colors.black12),
                Row(
                  children: [
                    Expanded(child: _modernPicker("Ends", endDate == null ? "Set Date" : "${endDate!.day}/${endDate!.month}/${endDate!.year}", Iconsax.calendar, () => _pickDate(false))),
                    const SizedBox(width: 12),
                    Expanded(child: _modernPicker("At", endTime?.format(context) ?? "Set Time", Iconsax.clock, () => _pickTime(false))),
                  ],
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text("All Day", style: GoogleFonts.poppins(fontSize: 14)),
                  value: isAllDay,
                  onChanged: (v) => setState(() => isAllDay = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _glassCard(
            child: Column(
              children: [
                _sectionHeader(Iconsax.folder_2, "Calendar"),
                const SizedBox(height: 12),
                _modernCalendarPicker(), // Definition provided below
              ],
            ),
          ),

          const SizedBox(height: 32),
          _actionButtons(),
        ],
      ),
    );
  }

// --- NEW STYLING HELPERS ---

  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: child,
    );
  }

  Widget _modernCalendarPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedCalendar,
          items: ['Church Calendar', 'Personal', 'Work']
              .map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.poppins(fontSize: 14))))
              .toList(),
          onChanged: (v) => setState(() => selectedCalendar = v!),
        ),
      ),
    );
  }
  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueAccent),
        const SizedBox(width: 8),
        Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.blueGrey.shade700)),
      ],
    );
  }

  Widget _input(String hint, Function(String) onChanged, {IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 20, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _modernPicker(String label, String value, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    // Determine the label based on the state
    String buttonLabel = isSaving
        ? "Saving..."
        : "Create ${selected.name.capitalize()}";

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 0,
            ),
            // Disable button if title is empty or if currently saving
            onPressed: isSaving || newTitle.trim().isEmpty ? null : _handleCreateNewList,
            child: isSaving
                ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            )
                : Text(buttonLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => showCreateForm = false),
          child: Text("Discard", style: TextStyle(color: Colors.red.shade400)),
        ),
      ],
    );
  }

// ================= CREATE FORM HEADER =================
  Widget _buildCreateForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Row(
            children: [
              // Styled back button
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Iconsax.arrow_left_2, color: Colors.blueAccent, size: 20),
                  onPressed: () => setState(() {
                    showCreateForm = false;
                    newTitle = '';
                    newSubtitle = '';
                    newUrl = '';
                    pickedImage = null;
                  }),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                "New ${selected.name.capitalize()}",
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade900),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Colors.black12),
        const SizedBox(height: 16),

        // Toggle between Event and Default
        if (selected.isEvent) _eventFormUI() else _defaultFormUI(),
      ],
    );
  }

// ================= MODERN DEFAULT FORM =================
  Widget _defaultFormUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _glassCard(
            child: Column(
              children: [
                _sectionHeader(Iconsax.document_text, "Content Info"),
                const SizedBox(height: 16),
                _input("Title", (v) => setState(() => newTitle = v), icon: Iconsax.edit),
                _input("Subtitle", (v) => setState(() => newSubtitle = v), icon: Iconsax.note),

                if (selected.isLink) ...[
                  const SizedBox(height: 8),
                  _input("URL (https://...)", (v) => setState(() => newUrl = v), icon: Iconsax.link),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Modern Image Picker Card
          _glassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(Iconsax.image, "Cover Image"),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blueAccent.withOpacity(0.2), style: BorderStyle.solid),
                    ),
                    child: pickedImage == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.cloud_add, size: 40, color: Colors.blueAccent),
                        const SizedBox(height: 8),
                        Text("Upload Image", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.blueAccent)),
                        Text("PNG, JPG up to 5MB", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                      ],
                    )
                        : Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.memory(pickedImage!, fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.5),
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 18),
                              onPressed: () => setState(() => pickedImage = null),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          _actionButtons(),
        ],
      ),
    );
  }

  void _handleNavigation(ListModel list) {
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
    }
  }
}





class FallingListItem extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const FallingListItem({super.key, required this.child, required this.delay});

  @override
  State<FallingListItem> createState() => _FallingListItemState();
}

class _FallingListItemState extends State<FallingListItem> with SingleTickerProviderStateMixin {
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