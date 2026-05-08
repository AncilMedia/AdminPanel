// // // // // // // // // import 'dart:ui';
// // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // // // // // import 'package:lottie/lottie.dart';
// // // // // // // // // import 'package:iconsax/iconsax.dart';
// // // // // // // // // import 'package:shimmer/shimmer.dart';
// // // // // // // // // import 'package:intl/intl.dart';
// // // // // // // // // import '../Controller/Get_all_item_controller.dart';
// // // // // // // // // import '../Model/Item_Model.dart';
// // // // // // // // //
// // // // // // // // // class Events extends StatefulWidget {
// // // // // // // // //   const Events({super.key});
// // // // // // // // //
// // // // // // // // //   @override
// // // // // // // // //   State<Events> createState() => _EventsState();
// // // // // // // // // }
// // // // // // // // //
// // // // // // // // // class _EventsState extends State<Events> {
// // // // // // // // //   List<ItemModel> events = [];
// // // // // // // // //   bool isLoading = true;
// // // // // // // // //
// // // // // // // // //   String formatTo12Hour(String? dateTimeString) {
// // // // // // // // //     try {
// // // // // // // // //       if (dateTimeString == null || dateTimeString.isEmpty) return 'No time';
// // // // // // // // //
// // // // // // // // //       final dateTime = DateTime.parse(dateTimeString).toLocal();
// // // // // // // // //       return DateFormat('hh:mm a').format(dateTime);
// // // // // // // // //     } catch (e) {
// // // // // // // // //       return 'Invalid';
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   @override
// // // // // // // // //   void initState() {
// // // // // // // // //     super.initState();
// // // // // // // // //     _loadEvents();
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   // Future<void> _loadEvents() async {
// // // // // // // // //   //   if (!mounted) return;
// // // // // // // // //   //   setState(() => isLoading = true);
// // // // // // // // //   //   try {
// // // // // // // // //   //     // ✅ Fetching using your ItemService
// // // // // // // // //   //     final allItems = await ItemService.fetchItems();
// // // // // // // // //   //
// // // // // // // // //   //     if (mounted) {
// // // // // // // // //   //       setState(() {
// // // // // // // // //   //         // ✅ FILTER: Only items where type is 'event'
// // // // // // // // //   //         events = allItems.where((item) => item.type == 'event').toList();
// // // // // // // // //   //         isLoading = false;
// // // // // // // // //   //       });
// // // // // // // // //   //     }
// // // // // // // // //   //   } catch (e) {
// // // // // // // // //   //     debugPrint("❌ Error Loading Events: $e");
// // // // // // // // //   //     if (mounted) setState(() => isLoading = false);
// // // // // // // // //   //   }
// // // // // // // // //   // }
// // // // // // // // //
// // // // // // // // //   Future<void> _loadEvents() async {
// // // // // // // // //     if (!mounted) return;
// // // // // // // // //
// // // // // // // // //     setState(() => isLoading = true);
// // // // // // // // //
// // // // // // // // //     try {
// // // // // // // // //       final allItems = await ItemService.fetchItems();
// // // // // // // // //
// // // // // // // // //       if (!mounted) return;
// // // // // // // // //
// // // // // // // // //       final eventItems =
// // // // // // // // //       allItems.where((item) => item.type == 'event').toList();
// // // // // // // // //
// // // // // // // // //       print("📅 Total events: ${eventItems.length}");
// // // // // // // // //
// // // // // // // // //       for (var item in eventItems) {
// // // // // // // // //         print("🟢 Event:");
// // // // // // // // //         print("   ID: ${item.id}");
// // // // // // // // //         print("   Title: ${item.title}");
// // // // // // // // //         print("   Type: ${item.type}");
// // // // // // // // //         print("   Raw Start: ${item.startDateTime}");
// // // // // // // // //         print("   Raw End: ${item.endDateTime}");
// // // // // // // // //         print("   Start (12h): ${formatTo12Hour(item.startDateTime)}");
// // // // // // // // //         print("   End (12h): ${formatTo12Hour(item.endDateTime)}");
// // // // // // // // //         print("----------------------");
// // // // // // // // //       }
// // // // // // // // //
// // // // // // // // //       setState(() {
// // // // // // // // //         events = eventItems;
// // // // // // // // //         isLoading = false;
// // // // // // // // //       });
// // // // // // // // //
// // // // // // // // //     } catch (e) {
// // // // // // // // //       debugPrint("❌ Error Loading Events: $e");
// // // // // // // // //
// // // // // // // // //       if (mounted) {
// // // // // // // // //         setState(() => isLoading = false);
// // // // // // // // //       }
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   @override
// // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // //     final size = MediaQuery.of(context).size;
// // // // // // // // //     final isDesktop = size.width >= 1100;
// // // // // // // // //
// // // // // // // // //     return Scaffold(
// // // // // // // // //       backgroundColor: const Color(0xFFF8F9FD),
// // // // // // // // //       body: RefreshIndicator(
// // // // // // // // //         onRefresh: _loadEvents,
// // // // // // // // //         color: Colors.cyan,
// // // // // // // // //         child: CustomScrollView(
// // // // // // // // //           physics: const AlwaysScrollableScrollPhysics(),
// // // // // // // // //           slivers: [
// // // // // // // // //             _buildHeader(isDesktop),
// // // // // // // // //             if (isLoading)
// // // // // // // // //               _buildShimmerGrid(isDesktop)
// // // // // // // // //             else if (events.isEmpty)
// // // // // // // // //               SliverFillRemaining(child: _buildEmptyState())
// // // // // // // // //             else
// // // // // // // // //               _buildEventGrid(isDesktop),
// // // // // // // // //           ],
// // // // // // // // //         ),
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   Widget _buildHeader(bool isDesktop) {
// // // // // // // // //     return SliverPadding(
// // // // // // // // //       padding: EdgeInsets.fromLTRB(24, isDesktop ? 40 : 20, 24, 20),
// // // // // // // // //       sliver: SliverToBoxAdapter(
// // // // // // // // //         child: Row(
// // // // // // // // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // // // // //           children: [
// // // // // // // // //             Column(
// // // // // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // // //               children: [
// // // // // // // // //                 Text(
// // // // // // // // //                   "Organization Events",
// // // // // // // // //                   style: GoogleFonts.poppins(
// // // // // // // // //                     fontSize: 28,
// // // // // // // // //                     fontWeight: FontWeight.bold,
// // // // // // // // //                     color: const Color(0xFF1A1D1E),
// // // // // // // // //                   ),
// // // // // // // // //                 ),
// // // // // // // // //                 Text(
// // // // // // // // //                   "Filtered by event type • ${events.length} items found",
// // // // // // // // //                   style: GoogleFonts.poppins(
// // // // // // // // //                     fontSize: 14,
// // // // // // // // //                     color: Colors.blueGrey.shade400,
// // // // // // // // //                   ),
// // // // // // // // //                 ),
// // // // // // // // //               ],
// // // // // // // // //             ),
// // // // // // // // //             // Optional: Refresh Button for Desktop
// // // // // // // // //             if (isDesktop)
// // // // // // // // //               IconButton(
// // // // // // // // //                 onPressed: _loadEvents,
// // // // // // // // //                 icon: const Icon(Iconsax.refresh, color: Colors.cyan),
// // // // // // // // //               )
// // // // // // // // //           ],
// // // // // // // // //         ),
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   Widget _buildEventGrid(bool isDesktop) {
// // // // // // // // //     return SliverPadding(
// // // // // // // // //       padding: const EdgeInsets.symmetric(horizontal: 24),
// // // // // // // // //       sliver: SliverGrid(
// // // // // // // // //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // // // // // // // //           crossAxisCount: isDesktop ? 4 : 1,
// // // // // // // // //           mainAxisSpacing: 24,
// // // // // // // // //           crossAxisSpacing: 24,
// // // // // // // // //           childAspectRatio: isDesktop ? 0.78 : 1.1,
// // // // // // // // //         ),
// // // // // // // // //         delegate: SliverChildBuilderDelegate(
// // // // // // // // //               (context, index) => _buildAttractiveCard(events[index]),
// // // // // // // // //           childCount: events.length,
// // // // // // // // //         ),
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   Widget _buildAttractiveCard(ItemModel item) {
// // // // // // // // //     // 📅 Date Parsing Logic
// // // // // // // // //     DateTime eventDate = DateTime.tryParse(item.startDateTime ?? "") ?? DateTime.now();
// // // // // // // // //     String day = DateFormat('dd').format(eventDate);
// // // // // // // // //     String month = DateFormat('MMM').format(eventDate).toUpperCase();
// // // // // // // // //     String time = DateFormat('hh:mm a').format(eventDate);
// // // // // // // // //
// // // // // // // // //     return Container(
// // // // // // // // //       decoration: BoxDecoration(
// // // // // // // // //         color: Colors.white,
// // // // // // // // //         borderRadius: BorderRadius.circular(24),
// // // // // // // // //         boxShadow: [
// // // // // // // // //           BoxShadow(
// // // // // // // // //             color: Colors.black.withOpacity(0.04),
// // // // // // // // //             blurRadius: 20,
// // // // // // // // //             offset: const Offset(0, 10),
// // // // // // // // //           )
// // // // // // // // //         ],
// // // // // // // // //       ),
// // // // // // // // //       child: Column(
// // // // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // // //         children: [
// // // // // // // // //           // --- Image Section (Fixed Flex) ---
// // // // // // // // //           Expanded(
// // // // // // // // //             flex: 5,
// // // // // // // // //             child: Stack(
// // // // // // // // //               children: [
// // // // // // // // //                 Container(
// // // // // // // // //                   width: double.infinity,
// // // // // // // // //                   decoration: BoxDecoration(
// // // // // // // // //                     borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
// // // // // // // // //                     image: DecorationImage(
// // // // // // // // //                       image: NetworkImage(item.image ?? 'https://via.placeholder.com/400'),
// // // // // // // // //                       fit: BoxFit.cover,
// // // // // // // // //                     ),
// // // // // // // // //                   ),
// // // // // // // // //                 ),
// // // // // // // // //                 Positioned(
// // // // // // // // //                   top: 12,
// // // // // // // // //                   left: 12,
// // // // // // // // //                   child: ClipRRect(
// // // // // // // // //                     borderRadius: BorderRadius.circular(12),
// // // // // // // // //                     child: BackdropFilter(
// // // // // // // // //                       filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
// // // // // // // // //                       child: Container(
// // // // // // // // //                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// // // // // // // // //                         color: Colors.white.withOpacity(0.8),
// // // // // // // // //                         child: Column(
// // // // // // // // //                           mainAxisSize: MainAxisSize.min,
// // // // // // // // //                           children: [
// // // // // // // // //                             Text(day, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, height: 1.1)),
// // // // // // // // //                             Text(month, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.cyan.shade800)),
// // // // // // // // //                           ],
// // // // // // // // //                         ),
// // // // // // // // //                       ),
// // // // // // // // //                     ),
// // // // // // // // //                   ),
// // // // // // // // //                 ),
// // // // // // // // //               ],
// // // // // // // // //             ),
// // // // // // // // //           ),
// // // // // // // // //
// // // // // // // // //           // --- Content Details (Tighter Spacing) ---
// // // // // // // // //           Padding(
// // // // // // // // //             padding: const EdgeInsets.fromLTRB(16, 16, 16, 12), // Reduced bottom padding
// // // // // // // // //             child: Column(
// // // // // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // // //               mainAxisSize: MainAxisSize.min, // Takes only needed space
// // // // // // // // //               children: [
// // // // // // // // //                 Text(
// // // // // // // // //                   item.title,
// // // // // // // // //                   maxLines: 1,
// // // // // // // // //                   overflow: TextOverflow.ellipsis,
// // // // // // // // //                   style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
// // // // // // // // //                 ),
// // // // // // // // //                 const SizedBox(height: 6), // Reduced from 8
// // // // // // // // //
// // // // // // // // //                 Row(
// // // // // // // // //                   children: [
// // // // // // // // //                     Icon(Iconsax.clock, size: 14, color: Colors.cyan.shade600),
// // // // // // // // //                     const SizedBox(width: 6),
// // // // // // // // //                     Text(time, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blueGrey.shade600)),
// // // // // // // // //                   ],
// // // // // // // // //                 ),
// // // // // // // // //                 const SizedBox(height: 4),
// // // // // // // // //
// // // // // // // // //                 Row(
// // // // // // // // //                   children: [
// // // // // // // // //                     Icon(Iconsax.location, size: 14, color: Colors.blueGrey.shade300),
// // // // // // // // //                     const SizedBox(width: 6),
// // // // // // // // //                     Expanded(
// // // // // // // // //                       child: Text(
// // // // // // // // //                         item.subtitle ?? "Location TBD",
// // // // // // // // //                         maxLines: 1,
// // // // // // // // //                         overflow: TextOverflow.ellipsis,
// // // // // // // // //                         style: GoogleFonts.poppins(fontSize: 12, color: Colors.blueGrey.shade400),
// // // // // // // // //                       ),
// // // // // // // // //                     ),
// // // // // // // // //                   ],
// // // // // // // // //                 ),
// // // // // // // // //
// // // // // // // // //                 const SizedBox(height: 12), // Controlled space before footer
// // // // // // // // //                 Container(height: 1, color: Colors.grey.shade100), // Thinner, cleaner divider
// // // // // // // // //                 const SizedBox(height: 10), // Reduced space after divider
// // // // // // // // //
// // // // // // // // //                 Row(
// // // // // // // // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // // // // //                   children: [
// // // // // // // // //                     Text("Manage Event",
// // // // // // // // //                         style: GoogleFonts.poppins(
// // // // // // // // //                             color: Colors.cyan.shade800,
// // // // // // // // //                             fontWeight: FontWeight.bold,
// // // // // // // // //                             fontSize: 11
// // // // // // // // //                         )
// // // // // // // // //                     ),
// // // // // // // // //                     const Icon(Iconsax.setting_4, color: Colors.cyan, size: 16),
// // // // // // // // //                   ],
// // // // // // // // //                 ),
// // // // // // // // //               ],
// // // // // // // // //             ),
// // // // // // // // //           ),
// // // // // // // // //         ],
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }
// // // // // // // // //   Widget _buildEmptyState() {
// // // // // // // // //     return Center(
// // // // // // // // //       child: Column(
// // // // // // // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // // //         children: [
// // // // // // // // //           Lottie.network(
// // // // // // // // //             'https://res.cloudinary.com/dggylwwqk/raw/upload/v1756718657/events_awyqe9.json',
// // // // // // // // //             height: 200,
// // // // // // // // //           ),
// // // // // // // // //           const SizedBox(height: 16),
// // // // // // // // //           Text(
// // // // // // // // //             "No events scheduled yet",
// // // // // // // // //             style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blueGrey),
// // // // // // // // //           ),
// // // // // // // // //         ],
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   Widget _buildShimmerGrid(bool isDesktop) {
// // // // // // // // //     return SliverPadding(
// // // // // // // // //       padding: const EdgeInsets.all(24),
// // // // // // // // //       sliver: SliverGrid(
// // // // // // // // //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // // // // // // // //           crossAxisCount: isDesktop ? 4 : 1,
// // // // // // // // //           mainAxisSpacing: 24,
// // // // // // // // //           crossAxisSpacing: 24,
// // // // // // // // //           childAspectRatio: isDesktop ? 0.78 : 1.1,
// // // // // // // // //         ),
// // // // // // // // //         delegate: SliverChildBuilderDelegate(
// // // // // // // // //               (context, index) => Shimmer.fromColors(
// // // // // // // // //             baseColor: Colors.grey.shade200,
// // // // // // // // //             highlightColor: Colors.white,
// // // // // // // // //             child: Container(
// // // // // // // // //               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
// // // // // // // // //             ),
// // // // // // // // //           ),
// // // // // // // // //           childCount: 8,
// // // // // // // // //         ),
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }
// // // // // // // // // }
// // // // // // // //
// // // // // // // // import 'dart:ui';
// // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // // // // import 'package:lottie/lottie.dart';
// // // // // // // // import 'package:iconsax/iconsax.dart';
// // // // // // // // import 'package:shimmer/shimmer.dart';
// // // // // // // // import 'package:intl/intl.dart';
// // // // // // // // import '../Controller/Get_all_item_controller.dart';
// // // // // // // // import '../Model/Item_Model.dart';
// // // // // // // // import 'PopUp/Right_drawer.dart';
// // // // // // // //
// // // // // // // // class Events extends StatefulWidget {
// // // // // // // //   const Events({super.key});
// // // // // // // //
// // // // // // // //   @override
// // // // // // // //   State<Events> createState() => _EventsState();
// // // // // // // // }
// // // // // // // //
// // // // // // // // class _EventsState extends State<Events> {
// // // // // // // //   List<ItemModel> events = [];
// // // // // // // //   bool isLoading = true;
// // // // // // // //
// // // // // // // //   String formatTo12Hour(String? dateTimeString) {
// // // // // // // //     try {
// // // // // // // //       if (dateTimeString == null || dateTimeString.isEmpty) return 'No time';
// // // // // // // //       final dateTime = DateTime.parse(dateTimeString).toLocal();
// // // // // // // //       return DateFormat('hh:mm a').format(dateTime);
// // // // // // // //     } catch (e) {
// // // // // // // //       return 'Invalid';
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   @override
// // // // // // // //   void initState() {
// // // // // // // //     super.initState();
// // // // // // // //     _loadEvents();
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Future<void> _loadEvents() async {
// // // // // // // //     if (!mounted) return;
// // // // // // // //     setState(() => isLoading = true);
// // // // // // // //     try {
// // // // // // // //       final allItems = await ItemService.fetchItems();
// // // // // // // //       if (!mounted) return;
// // // // // // // //       final eventItems = allItems
// // // // // // // //           .where((item) => item.type == 'event')
// // // // // // // //           .toList();
// // // // // // // //       setState(() {
// // // // // // // //         events = eventItems;
// // // // // // // //         isLoading = false;
// // // // // // // //       });
// // // // // // // //     } catch (e) {
// // // // // // // //       debugPrint("❌ Error Loading Events: $e");
// // // // // // // //       if (mounted) setState(() => isLoading = false);
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   @override
// // // // // // // //   Widget build(BuildContext context) {
// // // // // // // //     final size = MediaQuery.of(context).size;
// // // // // // // //     final isDesktop = size.width >= 1100;
// // // // // // // //
// // // // // // // //     return Scaffold(
// // // // // // // //       backgroundColor: const Color(0xFFF8F9FD),
// // // // // // // //       // ADDED END DRAWER HERE
// // // // // // // //       endDrawer: CustomRightDrawer(
// // // // // // // //         isInSublist: false,
// // // // // // // //         initialSelection: DrawerSelection.event, // Locks drawer to events
// // // // // // // //         onAddItemToHome: (newItem) {
// // // // // // // //           _loadEvents(); // Refresh page when new event added
// // // // // // // //         },
// // // // // // // //       ),
// // // // // // // //       body: Builder(
// // // // // // // //         // Used builder to provide correct context for opening drawer
// // // // // // // //         builder: (context) {
// // // // // // // //           return RefreshIndicator(
// // // // // // // //             onRefresh: _loadEvents,
// // // // // // // //             color: Colors.cyan,
// // // // // // // //             child: CustomScrollView(
// // // // // // // //               physics: const AlwaysScrollableScrollPhysics(),
// // // // // // // //               slivers: [
// // // // // // // //                 _buildHeader(isDesktop, context),
// // // // // // // //                 if (isLoading)
// // // // // // // //                   _buildShimmerGrid(isDesktop)
// // // // // // // //                 else if (events.isEmpty)
// // // // // // // //                   SliverFillRemaining(child: _buildEmptyState())
// // // // // // // //                 else
// // // // // // // //                   _buildEventGrid(isDesktop),
// // // // // // // //               ],
// // // // // // // //             ),
// // // // // // // //           );
// // // // // // // //         },
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Widget _buildHeader(bool isDesktop, BuildContext context) {
// // // // // // // //     return SliverPadding(
// // // // // // // //       padding: EdgeInsets.fromLTRB(24, isDesktop ? 40 : 20, 24, 20),
// // // // // // // //       sliver: SliverToBoxAdapter(
// // // // // // // //         child: Row(
// // // // // // // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // // // //           children: [
// // // // // // // //             Column(
// // // // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //               children: [
// // // // // // // //                 Text(
// // // // // // // //                   "Organization Events",
// // // // // // // //                   style: GoogleFonts.poppins(
// // // // // // // //                     fontSize: 28,
// // // // // // // //                     fontWeight: FontWeight.bold,
// // // // // // // //                     color: const Color(0xFF1A1D1E),
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //                 Text(
// // // // // // // //                   "Filtered by event type • ${events.length} items found",
// // // // // // // //                   style: GoogleFonts.poppins(
// // // // // // // //                     fontSize: 14,
// // // // // // // //                     color: Colors.blueGrey.shade400,
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //               ],
// // // // // // // //             ),
// // // // // // // //             Row(
// // // // // // // //               children: [
// // // // // // // //                 if (isDesktop)
// // // // // // // //                   IconButton(
// // // // // // // //                     onPressed: _loadEvents,
// // // // // // // //                     icon: const Icon(Iconsax.refresh, color: Colors.cyan),
// // // // // // // //                   ),
// // // // // // // //                 const SizedBox(width: 8),
// // // // // // // //                 // ADDED CREATE BUTTON IN HEADER
// // // // // // // //                 ElevatedButton.icon(
// // // // // // // //                   onPressed: () => Scaffold.of(context).openEndDrawer(),
// // // // // // // //                   style: ElevatedButton.styleFrom(
// // // // // // // //                     backgroundColor: Colors.cyan,
// // // // // // // //                     foregroundColor: Colors.white,
// // // // // // // //                     shape: RoundedRectangleBorder(
// // // // // // // //                       borderRadius: BorderRadius.circular(12),
// // // // // // // //                     ),
// // // // // // // //                   ),
// // // // // // // //                   icon: const Icon(Iconsax.add, size: 18),
// // // // // // // //                   label: const Text("Add Event"),
// // // // // // // //                 ),
// // // // // // // //               ],
// // // // // // // //             ),
// // // // // // // //           ],
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Widget _buildEventGrid(bool isDesktop) {
// // // // // // // //     return SliverPadding(
// // // // // // // //       padding: const EdgeInsets.symmetric(horizontal: 24),
// // // // // // // //       sliver: SliverGrid(
// // // // // // // //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // // // // // // //           crossAxisCount: isDesktop ? 4 : 1,
// // // // // // // //           mainAxisSpacing: 24,
// // // // // // // //           crossAxisSpacing: 24,
// // // // // // // //           childAspectRatio: isDesktop ? 0.78 : 1.1,
// // // // // // // //         ),
// // // // // // // //         delegate: SliverChildBuilderDelegate(
// // // // // // // //           (context, index) => _buildAttractiveCard(events[index]),
// // // // // // // //           childCount: events.length,
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Widget _buildAttractiveCard(ItemModel item) {
// // // // // // // //     DateTime eventDate =
// // // // // // // //         DateTime.tryParse(item.startDateTime ?? "") ?? DateTime.now();
// // // // // // // //     String day = DateFormat('dd').format(eventDate);
// // // // // // // //     String month = DateFormat('MMM').format(eventDate).toUpperCase();
// // // // // // // //     String time = DateFormat('hh:mm a').format(eventDate);
// // // // // // // //
// // // // // // // //     return Container(
// // // // // // // //       decoration: BoxDecoration(
// // // // // // // //         color: Colors.white,
// // // // // // // //         borderRadius: BorderRadius.circular(24),
// // // // // // // //         boxShadow: [
// // // // // // // //           BoxShadow(
// // // // // // // //             color: Colors.black.withOpacity(0.04),
// // // // // // // //             blurRadius: 20,
// // // // // // // //             offset: const Offset(0, 10),
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //       child: Column(
// // // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //         children: [
// // // // // // // //           Expanded(
// // // // // // // //             flex: 5,
// // // // // // // //             child: Stack(
// // // // // // // //               children: [
// // // // // // // //                 Container(
// // // // // // // //                   width: double.infinity,
// // // // // // // //                   decoration: BoxDecoration(
// // // // // // // //                     borderRadius: const BorderRadius.vertical(
// // // // // // // //                       top: Radius.circular(24),
// // // // // // // //                     ),
// // // // // // // //                     image: DecorationImage(
// // // // // // // //                       image: NetworkImage(
// // // // // // // //                         item.image ?? 'https://via.placeholder.com/400',
// // // // // // // //                       ),
// // // // // // // //                       fit: BoxFit.cover,
// // // // // // // //                     ),
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //                 Positioned(
// // // // // // // //                   top: 12,
// // // // // // // //                   left: 12,
// // // // // // // //                   child: ClipRRect(
// // // // // // // //                     borderRadius: BorderRadius.circular(12),
// // // // // // // //                     child: BackdropFilter(
// // // // // // // //                       filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
// // // // // // // //                       child: Container(
// // // // // // // //                         padding: const EdgeInsets.symmetric(
// // // // // // // //                           horizontal: 10,
// // // // // // // //                           vertical: 6,
// // // // // // // //                         ),
// // // // // // // //                         color: Colors.white.withOpacity(0.8),
// // // // // // // //                         child: Column(
// // // // // // // //                           mainAxisSize: MainAxisSize.min,
// // // // // // // //                           children: [
// // // // // // // //                             Text(
// // // // // // // //                               day,
// // // // // // // //                               style: GoogleFonts.poppins(
// // // // // // // //                                 fontWeight: FontWeight.bold,
// // // // // // // //                                 fontSize: 16,
// // // // // // // //                                 height: 1.1,
// // // // // // // //                               ),
// // // // // // // //                             ),
// // // // // // // //                             Text(
// // // // // // // //                               month,
// // // // // // // //                               style: GoogleFonts.poppins(
// // // // // // // //                                 fontWeight: FontWeight.bold,
// // // // // // // //                                 fontSize: 10,
// // // // // // // //                                 color: Colors.cyan.shade800,
// // // // // // // //                               ),
// // // // // // // //                             ),
// // // // // // // //                           ],
// // // // // // // //                         ),
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //               ],
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //           Padding(
// // // // // // // //             padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
// // // // // // // //             child: Column(
// // // // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //               mainAxisSize: MainAxisSize.min,
// // // // // // // //               children: [
// // // // // // // //                 Text(
// // // // // // // //                   item.title,
// // // // // // // //                   maxLines: 1,
// // // // // // // //                   overflow: TextOverflow.ellipsis,
// // // // // // // //                   style: GoogleFonts.poppins(
// // // // // // // //                     fontWeight: FontWeight.bold,
// // // // // // // //                     fontSize: 16,
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //                 const SizedBox(height: 6),
// // // // // // // //                 Row(
// // // // // // // //                   children: [
// // // // // // // //                     Icon(Iconsax.clock, size: 14, color: Colors.cyan.shade600),
// // // // // // // //                     const SizedBox(width: 6),
// // // // // // // //                     Text(
// // // // // // // //                       time,
// // // // // // // //                       style: GoogleFonts.poppins(
// // // // // // // //                         fontSize: 12,
// // // // // // // //                         fontWeight: FontWeight.w500,
// // // // // // // //                         color: Colors.blueGrey.shade600,
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                   ],
// // // // // // // //                 ),
// // // // // // // //                 const SizedBox(height: 4),
// // // // // // // //                 Row(
// // // // // // // //                   children: [
// // // // // // // //                     Icon(
// // // // // // // //                       Iconsax.location,
// // // // // // // //                       size: 14,
// // // // // // // //                       color: Colors.blueGrey.shade300,
// // // // // // // //                     ),
// // // // // // // //                     const SizedBox(width: 6),
// // // // // // // //                     Expanded(
// // // // // // // //                       child: Text(
// // // // // // // //                         item.subtitle ?? "Location TBD",
// // // // // // // //                         maxLines: 1,
// // // // // // // //                         overflow: TextOverflow.ellipsis,
// // // // // // // //                         style: GoogleFonts.poppins(
// // // // // // // //                           fontSize: 12,
// // // // // // // //                           color: Colors.blueGrey.shade400,
// // // // // // // //                         ),
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                   ],
// // // // // // // //                 ),
// // // // // // // //                 const SizedBox(height: 12),
// // // // // // // //                 Container(height: 1, color: Colors.grey.shade100),
// // // // // // // //                 const SizedBox(height: 10),
// // // // // // // //                 Row(
// // // // // // // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // // // //                   children: [
// // // // // // // //                     Row(
// // // // // // // //                       children: [
// // // // // // // //                         Text(
// // // // // // // //                           "Manage Event",
// // // // // // // //                           style: GoogleFonts.poppins(
// // // // // // // //                             color: Colors.cyan.shade800,
// // // // // // // //                             fontWeight: FontWeight.bold,
// // // // // // // //                             fontSize: 11,
// // // // // // // //                           ),
// // // // // // // //                         ),
// // // // // // // //                         SizedBox(width: 10),
// // // // // // // //                         const Icon(
// // // // // // // //                           Iconsax.setting_4,
// // // // // // // //                           color: Colors.cyan,
// // // // // // // //                           size: 16,
// // // // // // // //                         ),
// // // // // // // //                       ],
// // // // // // // //                     ),
// // // // // // // //                     Row(
// // // // // // // //                       children: [
// // // // // // // //                         GestureDetector(
// // // // // // // //                           onTap: () {},
// // // // // // // //                           child: Container(
// // // // // // // //                             child: Icon(
// // // // // // // //                               Iconsax.edit,
// // // // // // // //                               color: Colors.green,
// // // // // // // //                               size: 20,
// // // // // // // //                             ),
// // // // // // // //                           ),
// // // // // // // //                         ),
// // // // // // // //                         SizedBox(width: 10,),
// // // // // // // //                         GestureDetector(
// // // // // // // //                           onTap: () {},
// // // // // // // //                           child: Container(
// // // // // // // //                             child: Icon(
// // // // // // // //                               Iconsax.trash,
// // // // // // // //                               color: Colors.red,
// // // // // // // //                               size: 20,
// // // // // // // //                             ),
// // // // // // // //                           ),
// // // // // // // //                         ),
// // // // // // // //                       ],
// // // // // // // //                     ),
// // // // // // // //                   ],
// // // // // // // //                 ),
// // // // // // // //               ],
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Widget _buildEmptyState() {
// // // // // // // //     return Center(
// // // // // // // //       child: Column(
// // // // // // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // //         children: [
// // // // // // // //           Lottie.network(
// // // // // // // //             'https://res.cloudinary.com/dggylwwqk/raw/upload/v1756718657/events_awyqe9.json',
// // // // // // // //             height: 200,
// // // // // // // //           ),
// // // // // // // //           const SizedBox(height: 16),
// // // // // // // //           Text(
// // // // // // // //             "No events scheduled yet",
// // // // // // // //             style: GoogleFonts.poppins(
// // // // // // // //               fontSize: 16,
// // // // // // // //               fontWeight: FontWeight.w500,
// // // // // // // //               color: Colors.blueGrey,
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Widget _buildShimmerGrid(bool isDesktop) {
// // // // // // // //     return SliverPadding(
// // // // // // // //       padding: const EdgeInsets.all(24),
// // // // // // // //       sliver: SliverGrid(
// // // // // // // //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // // // // // // //           crossAxisCount: isDesktop ? 4 : 1,
// // // // // // // //           mainAxisSpacing: 24,
// // // // // // // //           crossAxisSpacing: 24,
// // // // // // // //           childAspectRatio: isDesktop ? 0.78 : 1.1,
// // // // // // // //         ),
// // // // // // // //         delegate: SliverChildBuilderDelegate(
// // // // // // // //           (context, index) => Shimmer.fromColors(
// // // // // // // //             baseColor: Colors.grey.shade200,
// // // // // // // //             highlightColor: Colors.white,
// // // // // // // //             child: Container(
// // // // // // // //               decoration: BoxDecoration(
// // // // // // // //                 color: Colors.white,
// // // // // // // //                 borderRadius: BorderRadius.circular(24),
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //           childCount: 8,
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // // }
// // // // // // //
// // // // // // //
// // // // // // // import 'dart:ui';
// // // // // // // import 'package:flutter/material.dart';
// // // // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // // // import 'package:lottie/lottie.dart';
// // // // // // // import 'package:iconsax/iconsax.dart';
// // // // // // // import 'package:shimmer/shimmer.dart';
// // // // // // // import 'package:intl/intl.dart';
// // // // // // // import '../Controller/Get_all_item_controller.dart';
// // // // // // // import '../Model/Item_Model.dart';
// // // // // // // import 'PopUp/Right_drawer.dart';
// // // // // // //
// // // // // // // class Events extends StatefulWidget {
// // // // // // //   const Events({super.key});
// // // // // // //
// // // // // // //   @override
// // // // // // //   State<Events> createState() => _EventsState();
// // // // // // // }
// // // // // // //
// // // // // // // class _EventsState extends State<Events> {
// // // // // // //   List<ItemModel> events = [];
// // // // // // //   bool isLoading = true;
// // // // // // //
// // // // // // //   @override
// // // // // // //   void initState() {
// // // // // // //     super.initState();
// // // // // // //     _loadEvents();
// // // // // // //   }
// // // // // // //
// // // // // // //   Future<void> _loadEvents() async {
// // // // // // //     if (!mounted) return;
// // // // // // //     setState(() => isLoading = true);
// // // // // // //     try {
// // // // // // //       final allItems = await ItemService.fetchItems();
// // // // // // //       if (!mounted) return;
// // // // // // //
// // // // // // //       // Filter only items of type 'event'
// // // // // // //       final eventItems = allItems.where((item) => item.type == 'event').toList();
// // // // // // //
// // // // // // //       setState(() {
// // // // // // //         events = eventItems;
// // // // // // //         isLoading = false;
// // // // // // //       });
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint("❌ Error Loading Events: $e");
// // // // // // //       if (mounted) setState(() => isLoading = false);
// // // // // // //     }
// // // // // // //   }
// // // // // // //
// // // // // // //   // Helper to show ICS Import Dialog
// // // // // // //   void _showIcsImportDialog() {
// // // // // // //     showDialog(
// // // // // // //       context: context,
// // // // // // //       builder: (context) => AlertDialog(
// // // // // // //         title: Text("Sync External Calendar", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
// // // // // // //         content: Column(
// // // // // // //           mainAxisSize: MainAxisSize.min,
// // // // // // //           children: [
// // // // // // //             Text("Enter the .ics link to sync your organization's external calendar events.",
// // // // // // //                 style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600)),
// // // // // // //             const SizedBox(height: 16),
// // // // // // //             TextField(
// // // // // // //               decoration: InputDecoration(
// // // // // // //                 hintText: "https://example.com/calendar.ics",
// // // // // // //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
// // // // // // //                 prefixIcon: const Icon(Iconsax.link),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //         actions: [
// // // // // // //           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
// // // // // // //           ElevatedButton(
// // // // // // //             onPressed: () => Navigator.pop(context),
// // // // // // //             style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
// // // // // // //             child: const Text("Sync Now", style: TextStyle(color: Colors.white)),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     final size = MediaQuery.of(context).size;
// // // // // // //     final isDesktop = size.width >= 1100;
// // // // // // //
// // // // // // //     return Scaffold(
// // // // // // //       backgroundColor: const Color(0xFFF8F9FD),
// // // // // // //       endDrawer: CustomRightDrawer(
// // // // // // //         isInSublist: false,
// // // // // // //         initialSelection: DrawerSelection.event,
// // // // // // //         onAddItemToHome: (newItem) => _loadEvents(),
// // // // // // //       ),
// // // // // // //       body: Builder(
// // // // // // //         builder: (context) {
// // // // // // //           return RefreshIndicator(
// // // // // // //             onRefresh: _loadEvents,
// // // // // // //             color: Colors.cyan,
// // // // // // //             child: CustomScrollView(
// // // // // // //               physics: const AlwaysScrollableScrollPhysics(),
// // // // // // //               slivers: [
// // // // // // //                 _buildHeader(isDesktop, context),
// // // // // // //                 if (isLoading)
// // // // // // //                   _buildShimmerGrid(isDesktop)
// // // // // // //                 else if (events.isEmpty)
// // // // // // //                   SliverFillRemaining(child: _buildEmptyState())
// // // // // // //                 else
// // // // // // //                   _buildEventGrid(isDesktop),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //           );
// // // // // // //         },
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _buildHeader(bool isDesktop, BuildContext context) {
// // // // // // //     return SliverPadding(
// // // // // // //       padding: EdgeInsets.fromLTRB(24, isDesktop ? 40 : 20, 24, 20),
// // // // // // //       sliver: SliverToBoxAdapter(
// // // // // // //         child: Row(
// // // // // // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // // //           crossAxisAlignment: CrossAxisAlignment.end,
// // // // // // //           children: [
// // // // // // //             Column(
// // // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //               children: [
// // // // // // //                 Text(
// // // // // // //                   "Organization Events",
// // // // // // //                   style: GoogleFonts.poppins(
// // // // // // //                     fontSize: 28,
// // // // // // //                     fontWeight: FontWeight.bold,
// // // // // // //                     color: const Color(0xFF1A1D1E),
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //                 Text(
// // // // // // //                   "Manual & ICS Synced • ${events.length} items found",
// // // // // // //                   style: GoogleFonts.poppins(
// // // // // // //                     fontSize: 14,
// // // // // // //                     color: Colors.blueGrey.shade400,
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //             Row(
// // // // // // //               children: [
// // // // // // //                 if (isDesktop)
// // // // // // //                   IconButton(
// // // // // // //                     onPressed: _loadEvents,
// // // // // // //                     icon: const Icon(Iconsax.refresh, color: Colors.cyan),
// // // // // // //                   ),
// // // // // // //                 const SizedBox(width: 8),
// // // // // // //                 // ICS SYNC BUTTON
// // // // // // //                 OutlinedButton.icon(
// // // // // // //                   onPressed: _showIcsImportDialog,
// // // // // // //                   style: OutlinedButton.styleFrom(
// // // // // // //                     side: BorderSide(color: Colors.orange.shade300),
// // // // // // //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // // // // // //                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // // // // // //                   ),
// // // // // // //                   icon: Icon(Iconsax.import, size: 18, color: Colors.orange.shade700),
// // // // // // //                   label: Text("Sync ICS", style: GoogleFonts.poppins(color: Colors.orange.shade700, fontWeight: FontWeight.w600)),
// // // // // // //                 ),
// // // // // // //                 const SizedBox(width: 12),
// // // // // // //                 // CREATE BUTTON
// // // // // // //                 ElevatedButton.icon(
// // // // // // //                   onPressed: () => Scaffold.of(context).openEndDrawer(),
// // // // // // //                   style: ElevatedButton.styleFrom(
// // // // // // //                     backgroundColor: Colors.cyan,
// // // // // // //                     foregroundColor: Colors.white,
// // // // // // //                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // // // // // //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // // // // // //                   ),
// // // // // // //                   icon: const Icon(Iconsax.add, size: 18),
// // // // // // //                   label: Text("Add Event", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
// // // // // // //                 ),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _buildEventGrid(bool isDesktop) {
// // // // // // //     return SliverPadding(
// // // // // // //       padding: const EdgeInsets.symmetric(horizontal: 24),
// // // // // // //       sliver: SliverGrid(
// // // // // // //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // // // // // //           crossAxisCount: isDesktop ? 4 : 1,
// // // // // // //           mainAxisSpacing: 24,
// // // // // // //           crossAxisSpacing: 24,
// // // // // // //           childAspectRatio: isDesktop ? 0.75 : 1.1,
// // // // // // //         ),
// // // // // // //         delegate: SliverChildBuilderDelegate(
// // // // // // //               (context, index) => _buildAttractiveCard(events[index]),
// // // // // // //           childCount: events.length,
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _buildAttractiveCard(ItemModel item) {
// // // // // // //     // Determine if event is from ICS (Assuming sourceType exists or link starts with http)
// // // // // // //     final bool isIcs = item.subtitle?.contains("http") ?? false; // Fallback check logic
// // // // // // //
// // // // // // //     DateTime eventDate = DateTime.tryParse(item.startDateTime ?? "") ?? DateTime.now();
// // // // // // //     String day = DateFormat('dd').format(eventDate);
// // // // // // //     String month = DateFormat('MMM').format(eventDate).toUpperCase();
// // // // // // //     String time = DateFormat('hh:mm a').format(eventDate);
// // // // // // //
// // // // // // //     return Container(
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         color: Colors.white,
// // // // // // //         borderRadius: BorderRadius.circular(24),
// // // // // // //         boxShadow: [
// // // // // // //           BoxShadow(
// // // // // // //             color: Colors.black.withOpacity(0.04),
// // // // // // //             blurRadius: 20,
// // // // // // //             offset: const Offset(0, 10),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         children: [
// // // // // // //           Expanded(
// // // // // // //             flex: 5,
// // // // // // //             child: Stack(
// // // // // // //               children: [
// // // // // // //                 Container(
// // // // // // //                   width: double.infinity,
// // // // // // //                   decoration: BoxDecoration(
// // // // // // //                     borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
// // // // // // //                     image: DecorationImage(
// // // // // // //                       image: NetworkImage(item.image ?? 'https://via.placeholder.com/400'),
// // // // // // //                       fit: BoxFit.cover,
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //                 // Date Badge
// // // // // // //                 Positioned(
// // // // // // //                   top: 12,
// // // // // // //                   left: 12,
// // // // // // //                   child: _buildGlassDateBadge(day, month),
// // // // // // //                 ),
// // // // // // //                 // Source Label
// // // // // // //                 if (isIcs)
// // // // // // //                   Positioned(
// // // // // // //                     top: 12,
// // // // // // //                     right: 12,
// // // // // // //                     child: Container(
// // // // // // //                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// // // // // // //                       decoration: BoxDecoration(
// // // // // // //                         color: Colors.orange,
// // // // // // //                         borderRadius: BorderRadius.circular(8),
// // // // // // //                       ),
// // // // // // //                       child: Text("EXTERNAL", style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //           Padding(
// // // // // // //             padding: const EdgeInsets.all(16),
// // // // // // //             child: Column(
// // // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //               children: [
// // // // // // //                 Text(
// // // // // // //                   item.title,
// // // // // // //                   maxLines: 1,
// // // // // // //                   overflow: TextOverflow.ellipsis,
// // // // // // //                   style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
// // // // // // //                 ),
// // // // // // //                 const SizedBox(height: 8),
// // // // // // //                 Row(
// // // // // // //                   children: [
// // // // // // //                     Icon(Iconsax.clock, size: 14, color: isIcs ? Colors.orange : Colors.cyan),
// // // // // // //                     const SizedBox(width: 6),
// // // // // // //                     Text(time, style: GoogleFonts.poppins(fontSize: 12, color: Colors.blueGrey.shade600)),
// // // // // // //                   ],
// // // // // // //                 ),
// // // // // // //                 const SizedBox(height: 12),
// // // // // // //                 Row(
// // // // // // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // // //                   children: [
// // // // // // //                     Text(
// // // // // // //                       isIcs ? "Synced via ICS" : "Manual Event",
// // // // // // //                       style: GoogleFonts.poppins(
// // // // // // //                         color: isIcs ? Colors.orange.shade700 : Colors.cyan.shade700,
// // // // // // //                         fontWeight: FontWeight.w600,
// // // // // // //                         fontSize: 11,
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                     Row(
// // // // // // //                       children: [
// // // // // // //                         // Only show edit/delete for non-ICS events
// // // // // // //                         if (!isIcs) ...[
// // // // // // //                           _buildActionButton(Iconsax.edit, Colors.green, () {}),
// // // // // // //                           const SizedBox(width: 8),
// // // // // // //                           _buildActionButton(Iconsax.trash, Colors.red, () {}),
// // // // // // //                         ] else
// // // // // // //                           Icon(Iconsax.cloud_notif, color: Colors.orange.shade300, size: 20),
// // // // // // //                       ],
// // // // // // //                     ),
// // // // // // //                   ],
// // // // // // //                 ),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _buildGlassDateBadge(String day, String month) {
// // // // // // //     return ClipRRect(
// // // // // // //       borderRadius: BorderRadius.circular(12),
// // // // // // //       child: BackdropFilter(
// // // // // // //         filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
// // // // // // //         child: Container(
// // // // // // //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// // // // // // //           color: Colors.white.withOpacity(0.8),
// // // // // // //           child: Column(
// // // // // // //             mainAxisSize: MainAxisSize.min,
// // // // // // //             children: [
// // // // // // //               Text(day, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, height: 1.1)),
// // // // // // //               Text(month, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.cyan.shade800)),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
// // // // // // //     return GestureDetector(
// // // // // // //       onTap: onTap,
// // // // // // //       child: Container(
// // // // // // //         padding: const EdgeInsets.all(6),
// // // // // // //         decoration: BoxDecoration(
// // // // // // //           color: color.withOpacity(0.1),
// // // // // // //           borderRadius: BorderRadius.circular(8),
// // // // // // //         ),
// // // // // // //         child: Icon(icon, color: color, size: 18),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _buildEmptyState() {
// // // // // // //     return Center(
// // // // // // //       child: Column(
// // // // // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //         children: [
// // // // // // //           Lottie.network('https://res.cloudinary.com/dggylwwqk/raw/upload/v1756718657/events_awyqe9.json', height: 200),
// // // // // // //           const SizedBox(height: 16),
// // // // // // //           Text("No events scheduled yet", style: GoogleFonts.poppins(fontSize: 16, color: Colors.blueGrey)),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _buildShimmerGrid(bool isDesktop) {
// // // // // // //     return SliverPadding(
// // // // // // //       padding: const EdgeInsets.all(24),
// // // // // // //       sliver: SliverGrid(
// // // // // // //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // // // // // //           crossAxisCount: isDesktop ? 4 : 1,
// // // // // // //           mainAxisSpacing: 24,
// // // // // // //           crossAxisSpacing: 24,
// // // // // // //           childAspectRatio: isDesktop ? 0.75 : 1.1,
// // // // // // //         ),
// // // // // // //         delegate: SliverChildBuilderDelegate(
// // // // // // //               (context, index) => Shimmer.fromColors(
// // // // // // //             baseColor: Colors.grey.shade200,
// // // // // // //             highlightColor: Colors.white,
// // // // // // //             child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24))),
// // // // // // //           ),
// // // // // // //           childCount: 8,
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }
// // // // // //
// // // // // // import 'dart:ui';
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // // import 'package:lottie/lottie.dart';
// // // // // // import 'package:iconsax/iconsax.dart';
// // // // // // import 'package:shimmer/shimmer.dart';
// // // // // // import 'package:intl/intl.dart';
// // // // // // // import 'package:file_picker/file_picker.dart'; // Add this to pubspec.yaml
// // // // // //
// // // // // // import '../Controller/Get_all_item_controller.dart';
// // // // // // import '../Model/Item_Model.dart';
// // // // // // import 'PopUp/Right_drawer.dart';
// // // // // //
// // // // // // class Events extends StatefulWidget {
// // // // // //   const Events({super.key});
// // // // // //
// // // // // //   @override
// // // // // //   State<Events> createState() => _EventsState();
// // // // // // }
// // // // // //
// // // // // // class _EventsState extends State<Events> {
// // // // // //   List<ItemModel> events = [];
// // // // // //   bool isLoading = true;
// // // // // //
// // // // // //   @override
// // // // // //   void initState() {
// // // // // //     super.initState();
// // // // // //     _loadEvents();
// // // // // //   }
// // // // // //
// // // // // //   Future<void> _loadEvents() async {
// // // // // //     if (!mounted) return;
// // // // // //     setState(() => isLoading = true);
// // // // // //     try {
// // // // // //       final allItems = await ItemService.fetchItems();
// // // // // //       if (!mounted) return;
// // // // // //
// // // // // //       final eventItems = allItems.where((item) => item.type == 'event').toList();
// // // // // //
// // // // // //       setState(() {
// // // // // //         events = eventItems;
// // // // // //         isLoading = false;
// // // // // //       });
// // // // // //     } catch (e) {
// // // // // //       debugPrint("❌ Error Loading Events: $e");
// // // // // //       if (mounted) setState(() => isLoading = false);
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   // --- NEW IMPORT DIALOG LOGIC ---
// // // // // //   void _showIcsImportDialog() {
// // // // // //     final TextEditingController urlController = TextEditingController();
// // // // // //     int selectedTab = 0; // 0 for Link, 1 for File
// // // // // //
// // // // // //     showDialog(
// // // // // //       context: context,
// // // // // //       builder: (context) => StatefulBuilder(
// // // // // //         builder: (context, setDialogState) {
// // // // // //           return AlertDialog(
// // // // // //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// // // // // //             title: Text("Import Calendar", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
// // // // // //             content: Column(
// // // // // //               mainAxisSize: MainAxisSize.min,
// // // // // //               children: [
// // // // // //                 // Toggle Tab
// // // // // //                 Container(
// // // // // //                   padding: const EdgeInsets.all(4),
// // // // // //                   decoration: BoxDecoration(
// // // // // //                     color: Colors.grey.shade100,
// // // // // //                     borderRadius: BorderRadius.circular(12),
// // // // // //                   ),
// // // // // //                   child: Row(
// // // // // //                     children: [
// // // // // //                       _buildTabItem("Link", selectedTab == 0, () => setDialogState(() => selectedTab = 0)),
// // // // // //                       _buildTabItem("File", selectedTab == 1, () => setDialogState(() => selectedTab = 1)),
// // // // // //                     ],
// // // // // //                   ),
// // // // // //                 ),
// // // // // //                 const SizedBox(height: 20),
// // // // // //
// // // // // //                 if (selectedTab == 0)
// // // // // //                   TextField(
// // // // // //                     controller: urlController,
// // // // // //                     decoration: InputDecoration(
// // // // // //                       hintText: "Paste .ics link here",
// // // // // //                       prefixIcon: const Icon(Iconsax.link),
// // // // // //                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
// // // // // //                     ),
// // // // // //                   )
// // // // // //                 else
// // // // // //                   InkWell(
// // // // // //                     onTap: () {
// // // // // //                       // Logic for FilePicker.platform.pickFiles()
// // // // // //                     },
// // // // // //                     child: Container(
// // // // // //                       padding: const EdgeInsets.symmetric(vertical: 30),
// // // // // //                       width: double.infinity,
// // // // // //                       decoration: BoxDecoration(
// // // // // //                         border: Border.all(color: Colors.cyan.withOpacity(0.5), style: BorderStyle.solid),
// // // // // //                         borderRadius: BorderRadius.circular(12),
// // // // // //                         color: Colors.cyan.withOpacity(0.05),
// // // // // //                       ),
// // // // // //                       child: const Column(
// // // // // //                         children: [
// // // // // //                           Icon(Iconsax.document_upload, color: Colors.cyan),
// // // // // //                           SizedBox(height: 8),
// // // // // //                           Text("Choose ICS File"),
// // // // // //                         ],
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //               ],
// // // // // //             ),
// // // // // //             actions: [
// // // // // //               TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
// // // // // //               ElevatedButton(
// // // // // //                 onPressed: () {
// // // // // //                   final link = urlController.text;
// // // // // //                   if (selectedTab == 0 && link.isNotEmpty) {
// // // // // //                     print("Syncing link: $link");
// // // // // //                     // CALL YOUR API HERE to send the link
// // // // // //                     Navigator.pop(context);
// // // // // //                     _loadEvents(); // Refresh
// // // // // //                   } else if (selectedTab == 1) {
// // // // // //                     print("Handle file upload logic");
// // // // // //                   }
// // // // // //                 },
// // // // // //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
// // // // // //                 child: const Text("Import Now", style: TextStyle(color: Colors.white)),
// // // // // //               ),
// // // // // //             ],
// // // // // //           );
// // // // // //         },
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildTabItem(String title, bool isSelected, VoidCallback onTap) {
// // // // // //     return Expanded(
// // // // // //       child: GestureDetector(
// // // // // //         onTap: onTap,
// // // // // //         child: Container(
// // // // // //           padding: const EdgeInsets.symmetric(vertical: 8),
// // // // // //           decoration: BoxDecoration(
// // // // // //             color: isSelected ? Colors.white : Colors.transparent,
// // // // // //             borderRadius: BorderRadius.circular(8),
// // // // // //             boxShadow: isSelected ? [BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
// // // // // //           ),
// // // // // //           child: Center(
// // // // // //             child: Text(title, style: GoogleFonts.poppins(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.cyan : Colors.grey)),
// // // // // //           ),
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     final size = MediaQuery.of(context).size;
// // // // // //     final isDesktop = size.width >= 1100;
// // // // // //
// // // // // //     return Scaffold(
// // // // // //       backgroundColor: const Color(0xFFF8F9FD),
// // // // // //       endDrawer: CustomRightDrawer(
// // // // // //         isInSublist: false,
// // // // // //         initialSelection: DrawerSelection.event,
// // // // // //         onAddItemToHome: (newItem) => _loadEvents(),
// // // // // //       ),
// // // // // //       body: Builder(
// // // // // //         builder: (context) {
// // // // // //           return RefreshIndicator(
// // // // // //             onRefresh: _loadEvents,
// // // // // //             color: Colors.cyan,
// // // // // //             child: CustomScrollView(
// // // // // //               physics: const AlwaysScrollableScrollPhysics(),
// // // // // //               slivers: [
// // // // // //                 _buildHeader(isDesktop, context),
// // // // // //                 if (isLoading)
// // // // // //                   _buildShimmerGrid(isDesktop)
// // // // // //                 else if (events.isEmpty)
// // // // // //                   SliverFillRemaining(child: _buildEmptyState())
// // // // // //                 else
// // // // // //                   _buildEventGrid(isDesktop),
// // // // // //               ],
// // // // // //             ),
// // // // // //           );
// // // // // //         },
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildHeader(bool isDesktop, BuildContext context) {
// // // // // //     return SliverPadding(
// // // // // //       padding: EdgeInsets.fromLTRB(24, isDesktop ? 40 : 20, 24, 20),
// // // // // //       sliver: SliverToBoxAdapter(
// // // // // //         child: Row(
// // // // // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // //           crossAxisAlignment: CrossAxisAlignment.end,
// // // // // //           children: [
// // // // // //             Column(
// // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //               children: [
// // // // // //                 Text(
// // // // // //                   "Organization Events",
// // // // // //                   style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF1A1D1E)),
// // // // // //                 ),
// // // // // //                 Text(
// // // // // //                   "Manual & ICS Synced • ${events.length} items found",
// // // // // //                   style: GoogleFonts.poppins(fontSize: 14, color: Colors.blueGrey.shade400),
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //             Row(
// // // // // //               children: [
// // // // // //                 if (isDesktop)
// // // // // //                   IconButton(onPressed: _loadEvents, icon: const Icon(Iconsax.refresh, color: Colors.cyan)),
// // // // // //                 const SizedBox(width: 8),
// // // // // //                 OutlinedButton.icon(
// // // // // //                   onPressed: _showIcsImportDialog,
// // // // // //                   style: OutlinedButton.styleFrom(
// // // // // //                     side: BorderSide(color: Colors.orange.shade300),
// // // // // //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // // // // //                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // // // // //                   ),
// // // // // //                   icon: Icon(Iconsax.import, size: 18, color: Colors.orange.shade700),
// // // // // //                   label: Text("Sync ICS", style: GoogleFonts.poppins(color: Colors.orange.shade700, fontWeight: FontWeight.w600)),
// // // // // //                 ),
// // // // // //                 const SizedBox(width: 12),
// // // // // //                 ElevatedButton.icon(
// // // // // //                   onPressed: () => Scaffold.of(context).openEndDrawer(),
// // // // // //                   style: ElevatedButton.styleFrom(
// // // // // //                     backgroundColor: Colors.cyan,
// // // // // //                     foregroundColor: Colors.white,
// // // // // //                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // // // // //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // // // // //                   ),
// // // // // //                   icon: const Icon(Iconsax.add, size: 18),
// // // // // //                   label: Text("Add Event", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildEventGrid(bool isDesktop) {
// // // // // //     return SliverPadding(
// // // // // //       padding: const EdgeInsets.symmetric(horizontal: 24),
// // // // // //       sliver: SliverGrid(
// // // // // //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // // // // //           crossAxisCount: isDesktop ? 4 : 1,
// // // // // //           mainAxisSpacing: 24,
// // // // // //           crossAxisSpacing: 24,
// // // // // //           childAspectRatio: isDesktop ? 0.75 : 1.1,
// // // // // //         ),
// // // // // //         delegate: SliverChildBuilderDelegate(
// // // // // //               (context, index) => _buildAttractiveCard(events[index]),
// // // // // //           childCount: events.length,
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildAttractiveCard(ItemModel item) {
// // // // // //     // Check if external (Logic based on your item structure)
// // // // // //     final bool isIcs = item.subtitle?.contains("http") ?? false;
// // // // // //
// // // // // //     DateTime eventDate = DateTime.tryParse(item.startDateTime ?? "") ?? DateTime.now();
// // // // // //     String day = DateFormat('dd').format(eventDate);
// // // // // //     String month = DateFormat('MMM').format(eventDate).toUpperCase();
// // // // // //     String time = DateFormat('hh:mm a').format(eventDate);
// // // // // //
// // // // // //     return Container(
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: Colors.white,
// // // // // //         borderRadius: BorderRadius.circular(24),
// // // // // //         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
// // // // // //       ),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           Expanded(
// // // // // //             flex: 5,
// // // // // //             child: Stack(
// // // // // //               children: [
// // // // // //                 Container(
// // // // // //                   width: double.infinity,
// // // // // //                   decoration: BoxDecoration(
// // // // // //                     borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
// // // // // //                     image: DecorationImage(image: NetworkImage(item.image ?? 'https://via.placeholder.com/400'), fit: BoxFit.cover),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //                 Positioned(top: 12, left: 12, child: _buildGlassDateBadge(day, month)),
// // // // // //                 if (isIcs)
// // // // // //                   Positioned(
// // // // // //                     top: 12,
// // // // // //                     right: 12,
// // // // // //                     child: Container(
// // // // // //                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// // // // // //                       decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
// // // // // //                       child: Text("EXTERNAL", style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //           Padding(
// // // // // //             padding: const EdgeInsets.all(16),
// // // // // //             child: Column(
// // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //               children: [
// // // // // //                 Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
// // // // // //                 const SizedBox(height: 8),
// // // // // //                 Row(
// // // // // //                   children: [
// // // // // //                     Icon(Iconsax.clock, size: 14, color: isIcs ? Colors.orange : Colors.cyan),
// // // // // //                     const SizedBox(width: 6),
// // // // // //                     Text(time, style: GoogleFonts.poppins(fontSize: 12, color: Colors.blueGrey.shade600)),
// // // // // //                   ],
// // // // // //                 ),
// // // // // //                 const SizedBox(height: 12),
// // // // // //                 Row(
// // // // // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // //                   children: [
// // // // // //                     Text(
// // // // // //                       isIcs ? "Synced via ICS" : "Manual Event",
// // // // // //                       style: GoogleFonts.poppins(color: isIcs ? Colors.orange.shade700 : Colors.cyan.shade700, fontWeight: FontWeight.w600, fontSize: 11),
// // // // // //                     ),
// // // // // //                     Row(
// // // // // //                       children: [
// // // // // //                         if (!isIcs) ...[
// // // // // //                           _buildActionButton(Iconsax.edit, Colors.green, () {}),
// // // // // //                           const SizedBox(width: 8),
// // // // // //                           _buildActionButton(Iconsax.trash, Colors.red, () {}),
// // // // // //                         ] else
// // // // // //                           Icon(Iconsax.cloud_notif, color: Colors.orange.shade300, size: 20),
// // // // // //                       ],
// // // // // //                     ),
// // // // // //                   ],
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildGlassDateBadge(String day, String month) {
// // // // // //     return ClipRRect(
// // // // // //       borderRadius: BorderRadius.circular(12),
// // // // // //       child: BackdropFilter(
// // // // // //         filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
// // // // // //         child: Container(
// // // // // //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// // // // // //           color: Colors.white.withOpacity(0.8),
// // // // // //           child: Column(
// // // // // //             mainAxisSize: MainAxisSize.min,
// // // // // //             children: [
// // // // // //               Text(day, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, height: 1.1)),
// // // // // //               Text(month, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.cyan.shade800)),
// // // // // //             ],
// // // // // //           ),
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
// // // // // //     return GestureDetector(
// // // // // //       onTap: onTap,
// // // // // //       child: Container(
// // // // // //         padding: const EdgeInsets.all(6),
// // // // // //         decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
// // // // // //         child: Icon(icon, color: color, size: 18),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildEmptyState() {
// // // // // //     return Center(
// // // // // //       child: Column(
// // // // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // // // //         children: [
// // // // // //           Lottie.network('https://res.cloudinary.com/dggylwwqk/raw/upload/v1756718657/events_awyqe9.json', height: 200),
// // // // // //           const SizedBox(height: 16),
// // // // // //           Text("No events scheduled yet", style: GoogleFonts.poppins(fontSize: 16, color: Colors.blueGrey)),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildShimmerGrid(bool isDesktop) {
// // // // // //     return SliverPadding(
// // // // // //       padding: const EdgeInsets.all(24),
// // // // // //       sliver: SliverGrid(
// // // // // //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // // // // //           crossAxisCount: isDesktop ? 4 : 1,
// // // // // //           mainAxisSpacing: 24,
// // // // // //           crossAxisSpacing: 24,
// // // // // //           childAspectRatio: isDesktop ? 0.75 : 1.1,
// // // // // //         ),
// // // // // //         delegate: SliverChildBuilderDelegate(
// // // // // //               (context, index) => Shimmer.fromColors(
// // // // // //             baseColor: Colors.grey.shade200,
// // // // // //             highlightColor: Colors.white,
// // // // // //             child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24))),
// // // // // //           ),
// // // // // //           childCount: 8,
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // //
// // // // // import 'dart:ui';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // import 'package:lottie/lottie.dart';
// // // // // import 'package:iconsax/iconsax.dart';
// // // // // import 'package:shimmer/shimmer.dart';
// // // // // import 'package:intl/intl.dart';
// // // // // import 'package:file_picker/file_picker.dart'; // REQUIRED
// // // // //
// // // // // import '../Controller/Get_all_item_controller.dart';
// // // // // import '../Model/Item_Model.dart';
// // // // // import 'PopUp/Right_drawer.dart';
// // // // //
// // // // // class Events extends StatefulWidget {
// // // // //   const Events({super.key});
// // // // //
// // // // //   @override
// // // // //   State<Events> createState() => _EventsState();
// // // // // }
// // // // //
// // // // // class _EventsState extends State<Events> {
// // // // //   List<ItemModel> events = [];
// // // // //   bool isLoading = true;
// // // // //
// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _loadEvents();
// // // // //   }
// // // // //
// // // // //   Future<void> _loadEvents() async {
// // // // //     if (!mounted) return;
// // // // //     setState(() => isLoading = true);
// // // // //     try {
// // // // //       final allItems = await ItemService.fetchItems();
// // // // //       if (!mounted) return;
// // // // //
// // // // //       final eventItems = allItems.where((item) => item.type == 'event').toList();
// // // // //
// // // // //       setState(() {
// // // // //         events = eventItems;
// // // // //         isLoading = false;
// // // // //       });
// // // // //     } catch (e) {
// // // // //       debugPrint("❌ Error Loading Events: $e");
// // // // //       if (mounted) setState(() => isLoading = false);
// // // // //     }
// // // // //   }
// // // // //
// // // // //   // Logic to handle the link or file
// // // // //   Future<void> _processSync({String? url, PlatformFile? file}) async {
// // // // //     setState(() => isLoading = true);
// // // // //
// // // // //     // Simulate Network/Parsing delay
// // // // //     await Future.delayed(const Duration(seconds: 2));
// // // // //
// // // // //     // MOCK DATA: In a real app, your backend would parse the ICS and return these
// // // // //     final mockSyncEvent = ItemModel(
// // // // //       id: "sync_${DateTime.now().millisecondsSinceEpoch}",
// // // // //       title: url != null ? "Google Holiday (Synced)" : "Imported File Event",
// // // // //       subtitle: url ?? "Source: Local ICS File",
// // // // //       type: "event",
// // // // //       startDateTime: DateTime.now().add(const Duration(days: 5)).toIso8601String(),
// // // // //       image: "https://images.unsplash.com/photo-1506784919141-935049915272?q=80&w=400",
// // // // //     );
// // // // //
// // // // //     setState(() {
// // // // //       events.insert(0, mockSyncEvent); // Add to top of list
// // // // //       isLoading = false;
// // // // //     });
// // // // //
// // // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // // //       SnackBar(content: Text(url != null ? "Calendar Synced!" : "File Imported Successfully!")),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   void _showIcsImportDialog() {
// // // // //     final TextEditingController urlController = TextEditingController();
// // // // //     int selectedTab = 0;
// // // // //     PlatformFile? pickedFile;
// // // // //
// // // // //     showDialog(
// // // // //       context: context,
// // // // //       builder: (context) => StatefulBuilder(
// // // // //         builder: (context, setDialogState) {
// // // // //           return AlertDialog(
// // // // //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// // // // //             title: Text("Import Calendar", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
// // // // //             content: Column(
// // // // //               mainAxisSize: MainAxisSize.min,
// // // // //               children: [
// // // // //                 Container(
// // // // //                   padding: const EdgeInsets.all(4),
// // // // //                   decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
// // // // //                   child: Row(
// // // // //                     children: [
// // // // //                       _buildTabItem("Link", selectedTab == 0, () => setDialogState(() => selectedTab = 0)),
// // // // //                       _buildTabItem("File", selectedTab == 1, () => setDialogState(() => selectedTab = 1)),
// // // // //                     ],
// // // // //                   ),
// // // // //                 ),
// // // // //                 const SizedBox(height: 20),
// // // // //
// // // // //                 if (selectedTab == 0)
// // // // //                   TextField(
// // // // //                     controller: urlController,
// // // // //                     decoration: InputDecoration(
// // // // //                       hintText: "Paste .ics link here",
// // // // //                       prefixIcon: const Icon(Iconsax.link),
// // // // //                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
// // // // //                     ),
// // // // //                   )
// // // // //                 else
// // // // //                   InkWell(
// // // // //                     onTap: () async {
// // // // //                       // REAL FILE PICKER LOGIC
// // // // //                       FilePickerResult? result = await FilePicker.platform.pickFiles(
// // // // //                         type: FileType.custom,
// // // // //                         allowedExtensions: ['ics'],
// // // // //                       );
// // // // //
// // // // //                       if (result != null) {
// // // // //                         setDialogState(() {
// // // // //                           pickedFile = result.files.first;
// // // // //                         });
// // // // //                       }
// // // // //                     },
// // // // //                     child: Container(
// // // // //                       padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
// // // // //                       width: double.infinity,
// // // // //                       decoration: BoxDecoration(
// // // // //                         border: Border.all(color: Colors.cyan.withOpacity(0.5), style: BorderStyle.solid),
// // // // //                         borderRadius: BorderRadius.circular(12),
// // // // //                         color: Colors.cyan.withOpacity(0.05),
// // // // //                       ),
// // // // //                       child: Column(
// // // // //                         children: [
// // // // //                           Icon(pickedFile == null ? Iconsax.document_upload : Iconsax.document_text, color: Colors.cyan),
// // // // //                           const SizedBox(height: 8),
// // // // //                           Text(
// // // // //                             pickedFile == null ? "Choose ICS File" : pickedFile!.name,
// // // // //                             textAlign: TextAlign.center,
// // // // //                             style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
// // // // //                           ),
// // // // //                         ],
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //               ],
// // // // //             ),
// // // // //             actions: [
// // // // //               TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
// // // // //               ElevatedButton(
// // // // //                 onPressed: () {
// // // // //                   if (selectedTab == 0 && urlController.text.isNotEmpty) {
// // // // //                     Navigator.pop(context);
// // // // //                     _processSync(url: urlController.text);
// // // // //                   } else if (selectedTab == 1 && pickedFile != null) {
// // // // //                     Navigator.pop(context);
// // // // //                     _processSync(file: pickedFile);
// // // // //                   }
// // // // //                 },
// // // // //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
// // // // //                 child: const Text("Import Now", style: TextStyle(color: Colors.white)),
// // // // //               ),
// // // // //             ],
// // // // //           );
// // // // //         },
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   Widget _buildTabItem(String title, bool isSelected, VoidCallback onTap) {
// // // // //     return Expanded(
// // // // //       child: GestureDetector(
// // // // //         onTap: onTap,
// // // // //         child: Container(
// // // // //           padding: const EdgeInsets.symmetric(vertical: 8),
// // // // //           decoration: BoxDecoration(
// // // // //             color: isSelected ? Colors.white : Colors.transparent,
// // // // //             borderRadius: BorderRadius.circular(8),
// // // // //             boxShadow: isSelected ? [BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
// // // // //           ),
// // // // //           child: Center(
// // // // //             child: Text(title, style: GoogleFonts.poppins(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.cyan : Colors.grey)),
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final size = MediaQuery.of(context).size;
// // // // //     final isDesktop = size.width >= 1100;
// // // // //
// // // // //     return Scaffold(
// // // // //       backgroundColor: const Color(0xFFF8F9FD),
// // // // //       endDrawer: CustomRightDrawer(
// // // // //         isInSublist: false,
// // // // //         initialSelection: DrawerSelection.event,
// // // // //         onAddItemToHome: (newItem) => _loadEvents(),
// // // // //       ),
// // // // //       body: Builder(
// // // // //         builder: (context) {
// // // // //           return RefreshIndicator(
// // // // //             onRefresh: _loadEvents,
// // // // //             color: Colors.cyan,
// // // // //             child: CustomScrollView(
// // // // //               physics: const AlwaysScrollableScrollPhysics(),
// // // // //               slivers: [
// // // // //                 _buildHeader(isDesktop, context),
// // // // //                 if (isLoading)
// // // // //                   _buildShimmerGrid(isDesktop)
// // // // //                 else if (events.isEmpty)
// // // // //                   SliverFillRemaining(child: _buildEmptyState())
// // // // //                 else
// // // // //                   _buildEventGrid(isDesktop),
// // // // //               ],
// // // // //             ),
// // // // //           );
// // // // //         },
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   Widget _buildHeader(bool isDesktop, BuildContext context) {
// // // // //     return SliverPadding(
// // // // //       padding: EdgeInsets.fromLTRB(24, isDesktop ? 40 : 20, 24, 20),
// // // // //       sliver: SliverToBoxAdapter(
// // // // //         child: Row(
// // // // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // //           crossAxisAlignment: CrossAxisAlignment.end,
// // // // //           children: [
// // // // //             Column(
// // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // //               children: [
// // // // //                 Text("Organization Events", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF1A1D1E))),
// // // // //                 Text("Manual & ICS Synced • ${events.length} items found", style: GoogleFonts.poppins(fontSize: 14, color: Colors.blueGrey.shade400)),
// // // // //               ],
// // // // //             ),
// // // // //             Row(
// // // // //               children: [
// // // // //                 if (isDesktop) IconButton(onPressed: _loadEvents, icon: const Icon(Iconsax.refresh, color: Colors.cyan)),
// // // // //                 const SizedBox(width: 8),
// // // // //                 OutlinedButton.icon(
// // // // //                   onPressed: _showIcsImportDialog,
// // // // //                   style: OutlinedButton.styleFrom(
// // // // //                     side: BorderSide(color: Colors.orange.shade300),
// // // // //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // // // //                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // // // //                   ),
// // // // //                   icon: Icon(Iconsax.import, size: 18, color: Colors.orange.shade700),
// // // // //                   label: Text("Sync ICS", style: GoogleFonts.poppins(color: Colors.orange.shade700, fontWeight: FontWeight.w600)),
// // // // //                 ),
// // // // //                 const SizedBox(width: 12),
// // // // //                 ElevatedButton.icon(
// // // // //                   onPressed: () => Scaffold.of(context).openEndDrawer(),
// // // // //                   style: ElevatedButton.styleFrom(
// // // // //                     backgroundColor: Colors.cyan,
// // // // //                     foregroundColor: Colors.white,
// // // // //                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // // // //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // // // //                   ),
// // // // //                   icon: const Icon(Iconsax.add, size: 18),
// // // // //                   label: Text("Add Event", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   Widget _buildEventGrid(bool isDesktop) {
// // // // //     return SliverPadding(
// // // // //       padding: const EdgeInsets.symmetric(horizontal: 24),
// // // // //       sliver: SliverGrid(
// // // // //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // // // //           crossAxisCount: isDesktop ? 4 : 1,
// // // // //           mainAxisSpacing: 24,
// // // // //           crossAxisSpacing: 24,
// // // // //           childAspectRatio: isDesktop ? 0.75 : 1.1,
// // // // //         ),
// // // // //         delegate: SliverChildBuilderDelegate(
// // // // //               (context, index) => _buildAttractiveCard(events[index]),
// // // // //           childCount: events.length,
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   Widget _buildAttractiveCard(ItemModel item) {
// // // // //     // Check if the subtitle looks like a URL
// // // // //     final bool isIcs = item.subtitle?.startsWith("http") ?? false;
// // // // //
// // // // //     DateTime eventDate = DateTime.tryParse(item.startDateTime ?? "") ?? DateTime.now();
// // // // //     String day = DateFormat('dd').format(eventDate);
// // // // //     String month = DateFormat('MMM').format(eventDate).toUpperCase();
// // // // //     String time = DateFormat('hh:mm a').format(eventDate);
// // // // //
// // // // //     return Container(
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.white,
// // // // //         borderRadius: BorderRadius.circular(24),
// // // // //         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
// // // // //       ),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           Expanded(
// // // // //             flex: 5,
// // // // //             child: Stack(
// // // // //               children: [
// // // // //                 Container(
// // // // //                   width: double.infinity,
// // // // //                   decoration: BoxDecoration(
// // // // //                     borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
// // // // //                     image: DecorationImage(image: NetworkImage(item.image ?? 'https://via.placeholder.com/400'), fit: BoxFit.cover),
// // // // //                   ),
// // // // //                 ),
// // // // //                 Positioned(top: 12, left: 12, child: _buildGlassDateBadge(day, month)),
// // // // //                 if (isIcs)
// // // // //                   Positioned(
// // // // //                     top: 12,
// // // // //                     right: 12,
// // // // //                     child: Container(
// // // // //                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// // // // //                       decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
// // // // //                       child: Text("SYNCED", style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
// // // // //                     ),
// // // // //                   ),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //           Padding(
// // // // //             padding: const EdgeInsets.all(16),
// // // // //             child: Column(
// // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // //               children: [
// // // // //                 Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
// // // // //                 const SizedBox(height: 8),
// // // // //                 Row(
// // // // //                   children: [
// // // // //                     Icon(Iconsax.clock, size: 14, color: isIcs ? Colors.orange : Colors.cyan),
// // // // //                     const SizedBox(width: 6),
// // // // //                     Text(time, style: GoogleFonts.poppins(fontSize: 12, color: Colors.blueGrey.shade600)),
// // // // //                   ],
// // // // //                 ),
// // // // //                 const SizedBox(height: 12),
// // // // //                 Row(
// // // // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // //                   children: [
// // // // //                     Expanded(
// // // // //                       child: Text(
// // // // //                         isIcs ? "Google Calendar Sync" : "Manual Event",
// // // // //                         style: GoogleFonts.poppins(color: isIcs ? Colors.orange.shade700 : Colors.cyan.shade700, fontWeight: FontWeight.w600, fontSize: 11),
// // // // //                       ),
// // // // //                     ),
// // // // //                     if (!isIcs) ...[
// // // // //                       _buildActionButton(Iconsax.edit, Colors.green, () {}),
// // // // //                       const SizedBox(width: 8),
// // // // //                       _buildActionButton(Iconsax.trash, Colors.red, () {}),
// // // // //                     ] else
// // // // //                       Icon(Iconsax.refresh, color: Colors.orange.shade300, size: 18),
// // // // //                   ],
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   Widget _buildGlassDateBadge(String day, String month) {
// // // // //     return ClipRRect(
// // // // //       borderRadius: BorderRadius.circular(12),
// // // // //       child: BackdropFilter(
// // // // //         filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
// // // // //         child: Container(
// // // // //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// // // // //           color: Colors.white.withOpacity(0.8),
// // // // //           child: Column(
// // // // //             mainAxisSize: MainAxisSize.min,
// // // // //             children: [
// // // // //               Text(day, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, height: 1.1)),
// // // // //               Text(month, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.cyan.shade800)),
// // // // //             ],
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
// // // // //     return GestureDetector(
// // // // //       onTap: onTap,
// // // // //       child: Container(
// // // // //         padding: const EdgeInsets.all(6),
// // // // //         decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
// // // // //         child: Icon(icon, color: color, size: 18),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   Widget _buildEmptyState() {
// // // // //     return Center(
// // // // //       child: Column(
// // // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // // //         children: [
// // // // //           Lottie.network('https://res.cloudinary.com/dggylwwqk/raw/upload/v1756718657/events_awyqe9.json', height: 200),
// // // // //           const SizedBox(height: 16),
// // // // //           Text("No events scheduled yet", style: GoogleFonts.poppins(fontSize: 16, color: Colors.blueGrey)),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   Widget _buildShimmerGrid(bool isDesktop) {
// // // // //     return SliverPadding(
// // // // //       padding: const EdgeInsets.all(24),
// // // // //       sliver: SliverGrid(
// // // // //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // // // //           crossAxisCount: isDesktop ? 4 : 1,
// // // // //           mainAxisSpacing: 24,
// // // // //           crossAxisSpacing: 24,
// // // // //           childAspectRatio: isDesktop ? 0.75 : 1.1,
// // // // //         ),
// // // // //         delegate: SliverChildBuilderDelegate(
// // // // //               (context, index) => Shimmer.fromColors(
// // // // //             baseColor: Colors.grey.shade200,
// // // // //             highlightColor: Colors.white,
// // // // //             child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24))),
// // // // //           ),
// // // // //           childCount: 8,
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // //
// // // // import 'dart:ui';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:google_fonts/google_fonts.dart';
// // // // import 'package:iconsax/iconsax.dart';
// // // // import 'package:intl/intl.dart';
// // // // import 'package:file_picker/file_picker.dart';
// // // // import 'package:shimmer/shimmer.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'package:icalendar_parser/icalendar_parser.dart';
// // // //
// // // // import '../Controller/Get_all_item_controller.dart';
// // // // import '../Model/Item_Model.dart';
// // // // import 'PopUp/Right_drawer.dart';
// // // //
// // // // class Events extends StatefulWidget {
// // // //   const Events({super.key});
// // // //
// // // //   @override
// // // //   State<Events> createState() => _EventsState();
// // // // }
// // // //
// // // // class _EventsState extends State<Events> {
// // // //   List<ItemModel> manualEvents = [];
// // // //   List<ItemModel> syncedEventsData = [];
// // // //   List<Map<String, dynamic>> syncedSources = [];
// // // //
// // // //   bool isLoading = true;
// // // //   int activeTab = 0;
// // // //   Map<String, dynamic>? selectedSource;
// // // //   int currentYear = DateTime.now().year;
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _loadManualEvents();
// // // //   }
// // // //
// // // //   Future<void> _loadManualEvents() async {
// // // //     setState(() => isLoading = true);
// // // //     try {
// // // //       final allItems = await ItemService.fetchItems();
// // // //       setState(() {
// // // //         manualEvents = allItems.where((item) => item.type == 'event').toList();
// // // //         isLoading = false;
// // // //       });
// // // //     } catch (e) {
// // // //       debugPrint("Error: $e");
// // // //       if (mounted) setState(() => isLoading = false);
// // // //     }
// // // //   }
// // // //
// // // //   // --- THE LOGIC THAT FETCHES DATA FROM THE LINK ---
// // // //   Future<void> _fetchIcsFromUrl(String url) async {
// // // //     setState(() => isLoading = true);
// // // //     try {
// // // //       final response = await http.get(Uri.parse(url));
// // // //
// // // //       if (response.statusCode == 200) {
// // // //         // Parse the raw text string into ICS objects
// // // //         final icard = ICalendar.fromString(response.body);
// // // //         List<ItemModel> parsedEvents = [];
// // // //
// // // //         for (var entry in icard.data) {
// // // //           if (entry['type'] == 'VEVENT') {
// // // //             // Correctly access the start date from the ICS object
// // // //             IcsDateTime? dtStart = entry['dtstart'];
// // // //             DateTime? eventDate = dtStart?.toDateTime();
// // // //
// // // //             if (eventDate != null) {
// // // //               parsedEvents.add(
// // // //                 ItemModel(
// // // //                   id: entry['uid'] ?? UniqueKey().toString(),
// // // //                   title: entry['summary'] ?? 'Busy',
// // // //                   startDateTime: eventDate.toIso8601String(),
// // // //                   type: 'event',
// // // //                 ),
// // // //               );
// // // //             }
// // // //           }
// // // //         }
// // // //
// // // //         setState(() {
// // // //           syncedEventsData = parsedEvents;
// // // //           isLoading = false;
// // // //         });
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint("Sync Error: $e");
// // // //       if (mounted) setState(() => isLoading = false);
// // // //     }
// // // //   }
// // // //
// // // //   void _showImportDialog() {
// // // //     final TextEditingController urlController = TextEditingController();
// // // //     int dialogTab = 0;
// // // //     PlatformFile? pickedFile;
// // // //
// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (context) => StatefulBuilder(
// // // //         builder: (context, setDialogState) {
// // // //           return AlertDialog(
// // // //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
// // // //             title: Text("Connect Calendar", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
// // // //             content: Column(
// // // //               mainAxisSize: MainAxisSize.min,
// // // //               children: [
// // // //                 _buildToggle(dialogTab, (v) => setDialogState(() => dialogTab = v)),
// // // //                 const SizedBox(height: 20),
// // // //                 if (dialogTab == 0)
// // // //                   TextField(
// // // //                     controller: urlController,
// // // //                     decoration: InputDecoration(
// // // //                       hintText: "Paste .ics URL link",
// // // //                       filled: true,
// // // //                       fillColor: Colors.grey.shade100,
// // // //                       prefixIcon: const Icon(Iconsax.link),
// // // //                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
// // // //                     ),
// // // //                   )
// // // //                 else
// // // //                   InkWell(
// // // //                     onTap: () async {
// // // //                       FilePickerResult? result = await FilePicker.platform.pickFiles(
// // // //                         type: FileType.custom,
// // // //                         allowedExtensions: ['ics'],
// // // //                       );
// // // //                       if (result != null) setDialogState(() => pickedFile = result.files.first);
// // // //                     },
// // // //                     child: Container(
// // // //                       height: 120,
// // // //                       width: double.infinity,
// // // //                       decoration: BoxDecoration(
// // // //                         color: Colors.cyan.withOpacity(0.05),
// // // //                         borderRadius: BorderRadius.circular(15),
// // // //                         border: Border.all(color: Colors.cyan.withOpacity(0.2)),
// // // //                       ),
// // // //                       child: Column(
// // // //                         mainAxisAlignment: MainAxisAlignment.center,
// // // //                         children: [
// // // //                           Icon(pickedFile == null ? Iconsax.document_upload : Iconsax.document_text, color: Colors.cyan),
// // // //                           const SizedBox(height: 10),
// // // //                           Text(pickedFile == null ? "Select .ics File" : pickedFile!.name, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //               ],
// // // //             ),
// // // //             actions: [
// // // //               TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
// // // //               ElevatedButton(
// // // //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
// // // //                 onPressed: () async {
// // // //                   String title = dialogTab == 0 ? "Cloud Sync" : (pickedFile?.name ?? "Import");
// // // //
// // // //                   if (dialogTab == 0 && urlController.text.isNotEmpty) {
// // // //                     // Logic to fetch and parse
// // // //                     await _fetchIcsFromUrl(urlController.text);
// // // //                   }
// // // //
// // // //                   setState(() {
// // // //                     syncedSources.add({'title': title, 'url': urlController.text});
// // // //                     activeTab = 1;
// // // //                   });
// // // //                   Navigator.pop(context);
// // // //                 },
// // // //                 child: const Text("Import", style: TextStyle(color: Colors.white)),
// // // //               ),
// // // //             ],
// // // //           );
// // // //         },
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final isDesktop = MediaQuery.of(context).size.width >= 1100;
// // // //
// // // //     return Scaffold(
// // // //       backgroundColor: const Color(0xFFF8F9FD),
// // // //       endDrawer: CustomRightDrawer(
// // // //         isInSublist: false,
// // // //         initialSelection: DrawerSelection.event,
// // // //         onAddItemToHome: (newItem) => _loadManualEvents(),
// // // //       ),
// // // //       body: CustomScrollView(
// // // //         slivers: [
// // // //           _buildHeader(),
// // // //           if (selectedSource == null) _buildTabNavigation(),
// // // //           if (isLoading)
// // // //             _buildShimmer(isDesktop)
// // // //           else if (selectedSource != null)
// // // //             _buildYearlyCalendar(isDesktop)
// // // //           else if (activeTab == 0)
// // // //               _buildManualGrid(isDesktop)
// // // //             else
// // // //               _buildSourcesList(),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   // --- UI: YEARLY CALENDAR RENDERER ---
// // // //   Widget _buildYearlyCalendar(bool isDesktop) {
// // // //     return SliverPadding(
// // // //       padding: const EdgeInsets.all(30),
// // // //       sliver: SliverGrid(
// // // //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // // //           crossAxisCount: isDesktop ? 3 : 1,
// // // //           mainAxisSpacing: 30,
// // // //           crossAxisSpacing: 30,
// // // //           childAspectRatio: 0.65,
// // // //         ),
// // // //         delegate: SliverChildBuilderDelegate((context, index) => _buildMonthCard(index + 1), childCount: 12),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildMonthCard(int month) {
// // // //     final monthName = DateFormat('MMMM').format(DateTime(currentYear, month));
// // // //     final daysInMonth = DateTime(currentYear, month + 1, 0).day;
// // // //     final firstDay = DateTime(currentYear, month, 1).weekday % 7;
// // // //
// // // //     return Container(
// // // //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
// // // //       child: Column(
// // // //         children: [
// // // //           Container(padding: const EdgeInsets.all(12), width: double.infinity, decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.05), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))), child: Center(child: Text(monthName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan)))),
// // // //           Expanded(
// // // //             child: GridView.builder(
// // // //               padding: const EdgeInsets.all(8),
// // // //               physics: const NeverScrollableScrollPhysics(),
// // // //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 8),
// // // //               itemCount: daysInMonth + firstDay,
// // // //               itemBuilder: (context, index) {
// // // //                 if (index < firstDay) return const SizedBox();
// // // //                 int day = index - firstDay + 1;
// // // //
// // // //                 // Checks parsed ICS data for matches
// // // //                 final dayEvents = syncedEventsData.where((e) {
// // // //                   final d = DateTime.tryParse(e.startDateTime ?? "");
// // // //                   return d?.year == currentYear && d?.month == month && d?.day == day;
// // // //                 }).toList();
// // // //
// // // //                 return Column(
// // // //                   mainAxisSize: MainAxisSize.min,
// // // //                   children: [
// // // //                     Container(
// // // //                       width: 24, height: 24,
// // // //                       decoration: BoxDecoration(
// // // //                           color: dayEvents.isNotEmpty ? Colors.cyan : Colors.transparent,
// // // //                           shape: BoxShape.circle
// // // //                       ),
// // // //                       child: Center(child: Text("$day", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: dayEvents.isNotEmpty ? Colors.white : Colors.black))),
// // // //                     ),
// // // //                     if (dayEvents.isNotEmpty)
// // // //                       Flexible(
// // // //                         child: Text(dayEvents.first.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.cyan)),
// // // //                       ),
// // // //                   ],
// // // //                 );
// // // //               },
// // // //             ),
// // // //           )
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   // --- UI: HEADER, TABS, LISTS ---
// // // //   Widget _buildHeader() {
// // // //     return SliverPadding(
// // // //       padding: const EdgeInsets.fromLTRB(30, 40, 30, 10),
// // // //       sliver: SliverToBoxAdapter(
// // // //         child: Row(
// // // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //           children: [
// // // //             Column(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 Text(selectedSource != null ? selectedSource!['title'] : "Events", style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w800)),
// // // //                 Text("Management & External Sync", style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey)),
// // // //               ],
// // // //             ),
// // // //             if (selectedSource != null)
// // // //               IconButton(onPressed: () => setState(() => selectedSource = null), icon: const Icon(Iconsax.close_circle, size: 30))
// // // //             else
// // // //               Row(
// // // //                 children: [
// // // //                   _buildHeaderBtn(Iconsax.import, Colors.orange, "Sync ICS", _showImportDialog),
// // // //                   const SizedBox(width: 12),
// // // //                   _buildHeaderBtn(Iconsax.add, Colors.cyan, "Create", () => Scaffold.of(context).openEndDrawer()),
// // // //                 ],
// // // //               ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildHeaderBtn(IconData icon, Color color, String label, VoidCallback onTap) {
// // // //     return ElevatedButton.icon(
// // // //       onPressed: onTap,
// // // //       style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
// // // //       icon: Icon(icon, size: 18),
// // // //       label: Text(label),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildTabNavigation() {
// // // //     return SliverToBoxAdapter(
// // // //       child: Padding(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), child: Row(children: [_tab(0, "Manual"), const SizedBox(width: 20), _tab(1, "Synced Sources")])),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _tab(int i, String t) {
// // // //     bool s = activeTab == i;
// // // //     return GestureDetector(
// // // //       onTap: () => setState(() => activeTab = i),
// // // //       child: Column(children: [Text(t, style: GoogleFonts.plusJakartaSans(fontWeight: s ? FontWeight.bold : FontWeight.normal, color: s ? Colors.cyan : Colors.grey)), if (s) Container(margin: const EdgeInsets.only(top: 4), height: 2, width: 20, color: Colors.cyan)]),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildSourcesList() {
// // // //     return SliverPadding(
// // // //       padding: const EdgeInsets.symmetric(horizontal: 30),
// // // //       sliver: SliverList(
// // // //         delegate: SliverChildBuilderDelegate(
// // // //               (context, index) => Card(
// // // //             margin: const EdgeInsets.only(bottom: 12),
// // // //             child: ListTile(
// // // //               leading: const Icon(Iconsax.cloud, color: Colors.orange),
// // // //               title: Text(syncedSources[index]['title']),
// // // //               trailing: const Icon(Iconsax.arrow_right_3),
// // // //               onTap: () => setState(() => selectedSource = syncedSources[index]),
// // // //             ),
// // // //           ),
// // // //           childCount: syncedSources.length,
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildManualGrid(bool isDesktop) {
// // // //     return SliverPadding(
// // // //       padding: const EdgeInsets.all(30),
// // // //       sliver: SliverGrid(
// // // //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 4 : 1, mainAxisSpacing: 25, crossAxisSpacing: 25, childAspectRatio: 0.8),
// // // //         delegate: SliverChildBuilderDelegate((context, index) => _buildCard(manualEvents[index]), childCount: manualEvents.length),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildCard(ItemModel item) {
// // // //     return Container(
// // // //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
// // // //       child: Column(children: [Expanded(child: Container(decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), image: DecorationImage(image: NetworkImage(item.image ?? ""), fit: BoxFit.cover)))), Padding(padding: const EdgeInsets.all(12), child: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)))]),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildToggle(int c, Function(int) o) {
// // // //     return Row(children: [Expanded(child: _tItem("Link", c == 0, () => o(0))), Expanded(child: _tItem("File", c == 1, () => o(1)))]);
// // // //   }
// // // //
// // // //   Widget _tItem(String t, bool s, VoidCallback o) {
// // // //     return GestureDetector(onTap: o, child: Container(padding: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(color: s ? Colors.cyan : Colors.transparent, borderRadius: BorderRadius.circular(10)), child: Center(child: Text(t, style: TextStyle(color: s ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)))));
// // // //   }
// // // //
// // // //   Widget _buildShimmer(bool isDesktop) {
// // // //     return SliverPadding(padding: const EdgeInsets.all(30), sliver: SliverGrid(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 4 : 1, mainAxisSpacing: 25, crossAxisSpacing: 25, childAspectRatio: 0.8), delegate: SliverChildBuilderDelegate((context, index) => Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.white, child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)))), childCount: 8)));
// // // //   }
// // // // }
// // //
// // // import 'dart:ui';
// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:iconsax/iconsax.dart';
// // // import 'package:intl/intl.dart';
// // // import 'package:file_picker/file_picker.dart';
// // // import 'package:shimmer/shimmer.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:icalendar_parser/icalendar_parser.dart';
// // //
// // // import '../Controller/Get_all_item_controller.dart';
// // // import '../Model/Item_Model.dart';
// // // import 'PopUp/Right_drawer.dart';
// // //
// // // class Events extends StatefulWidget {
// // //   const Events({super.key});
// // //
// // //   @override
// // //   State<Events> createState() => _EventsState();
// // // }
// // //
// // // class _EventsState extends State<Events> {
// // //   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
// // //
// // //   List<ItemModel> manualEvents = [];
// // //   List<ItemModel> syncedEventsData = [];
// // //
// // //   List<Map<String, dynamic>> syncedSources = [];
// // //
// // //   bool isLoading = true;
// // //
// // //   int activeTab = 0;
// // //
// // //   Map<String, dynamic>? selectedSource;
// // //
// // //   int currentYear = DateTime.now().year;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadManualEvents();
// // //   }
// // //
// // //   Future<void> _loadManualEvents() async {
// // //     if (!mounted) return;
// // //
// // //     setState(() => isLoading = true);
// // //
// // //     try {
// // //       final allItems = await ItemService.fetchItems();
// // //
// // //       if (mounted) {
// // //         setState(() {
// // //           manualEvents = allItems.where((e) => e.type == 'event').toList();
// // //
// // //           isLoading = false;
// // //         });
// // //       }
// // //     } catch (e) {
// // //       debugPrint("LOAD ERROR: $e");
// // //
// // //       if (mounted) {
// // //         setState(() => isLoading = false);
// // //       }
// // //     }
// // //   }
// // //
// // //   // =========================
// // //   // WEB SAFE ICS FETCHER
// // //   // =========================
// // //
// // //   Future<List<ItemModel>> _fetchIcsFromUrl(String url) async {
// // //     try {
// // //       final cleanUrl = url.trim();
// // //
// // //       // CORS SAFE FOR FLUTTER WEB
// // //       final proxyUrl = "https://corsproxy.io/?${Uri.encodeComponent(cleanUrl)}";
// // //
// // //       debugPrint("FETCHING: $proxyUrl");
// // //
// // //       final response = await http.get(
// // //         Uri.parse(proxyUrl),
// // //         headers: {'Accept': 'text/calendar', 'User-Agent': 'Mozilla/5.0'},
// // //       );
// // //
// // //       debugPrint("STATUS CODE: ${response.statusCode}");
// // //
// // //       if (response.statusCode != 200) {
// // //         debugPrint("INVALID STATUS CODE");
// // //
// // //         return [];
// // //       }
// // //
// // //       final body = response.body;
// // //
// // //       debugPrint(body.substring(0, body.length > 150 ? 150 : body.length));
// // //
// // //       // VALIDATE ICS FORMAT
// // //       if (!body.contains('BEGIN:VCALENDAR')) {
// // //         debugPrint("NOT VALID ICS DATA");
// // //
// // //         return [];
// // //       }
// // //
// // //       final calendar = ICalendar.fromString(body);
// // //
// // //       List<ItemModel> parsedEvents = [];
// // //
// // //       for (var entry in calendar.data) {
// // //         try {
// // //           if (entry['type'] == 'VEVENT') {
// // //             IcsDateTime? dtStart = entry['dtstart'];
// // //
// // //             DateTime? eventDate = dtStart?.toDateTime();
// // //
// // //             parsedEvents.add(
// // //               ItemModel(
// // //                 id: entry['uid']?.toString() ?? UniqueKey().toString(),
// // //
// // //                 title: entry['summary']?.toString() ?? 'Busy',
// // //
// // //                 startDateTime: eventDate?.toIso8601String(),
// // //
// // //                 type: 'event',
// // //               ),
// // //             );
// // //           }
// // //         } catch (e) {
// // //           debugPrint("EVENT PARSE ERROR: $e");
// // //         }
// // //       }
// // //
// // //       debugPrint("TOTAL EVENTS: ${parsedEvents.length}");
// // //
// // //       return parsedEvents;
// // //     } catch (e) {
// // //       debugPrint("ICS FETCH ERROR: $e");
// // //
// // //       return [];
// // //     }
// // //   }
// // //
// // //   void _showImportDialog() {
// // //     final TextEditingController urlController = TextEditingController();
// // //
// // //     int dialogTab = 0;
// // //
// // //     PlatformFile? pickedFile;
// // //
// // //     showDialog(
// // //       context: context,
// // //       builder: (context) => StatefulBuilder(
// // //         builder: (context, setDialogState) {
// // //           return AlertDialog(
// // //             shape: RoundedRectangleBorder(
// // //               borderRadius: BorderRadius.circular(25),
// // //             ),
// // //             title: Text(
// // //               "Connect Calendar",
// // //               style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
// // //             ),
// // //             content: Column(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 _buildToggle(
// // //                   dialogTab,
// // //                   (v) => setDialogState(() => dialogTab = v),
// // //                 ),
// // //
// // //                 const SizedBox(height: 20),
// // //
// // //                 if (dialogTab == 0)
// // //                   TextField(
// // //                     controller: urlController,
// // //                     decoration: InputDecoration(
// // //                       hintText: "Paste .ics URL link",
// // //                       filled: true,
// // //                       fillColor: Colors.grey.shade100,
// // //                       prefixIcon: const Icon(Iconsax.link),
// // //                       border: OutlineInputBorder(
// // //                         borderRadius: BorderRadius.circular(15),
// // //                         borderSide: BorderSide.none,
// // //                       ),
// // //                     ),
// // //                   )
// // //                 else
// // //                   InkWell(
// // //                     onTap: () async {
// // //                       FilePickerResult? result = await FilePicker.platform
// // //                           .pickFiles(
// // //                             type: FileType.custom,
// // //                             allowedExtensions: ['ics'],
// // //                             withData: true,
// // //                           );
// // //
// // //                       if (result != null) {
// // //                         setDialogState(() => pickedFile = result.files.first);
// // //                       }
// // //                     },
// // //                     child: Container(
// // //                       height: 120,
// // //                       width: double.infinity,
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.cyan.withOpacity(0.05),
// // //                         borderRadius: BorderRadius.circular(15),
// // //                         border: Border.all(color: Colors.cyan.withOpacity(0.2)),
// // //                       ),
// // //                       child: Column(
// // //                         mainAxisAlignment: MainAxisAlignment.center,
// // //                         children: [
// // //                           Icon(
// // //                             pickedFile == null
// // //                                 ? Iconsax.document_upload
// // //                                 : Iconsax.document_text,
// // //                             color: Colors.cyan,
// // //                           ),
// // //
// // //                           const SizedBox(height: 10),
// // //
// // //                           Text(
// // //                             pickedFile == null
// // //                                 ? "Select .ics File"
// // //                                 : pickedFile!.name,
// // //                             style: const TextStyle(fontSize: 12),
// // //                             textAlign: TextAlign.center,
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //               ],
// // //             ),
// // //             actions: [
// // //               TextButton(
// // //                 onPressed: () => Navigator.pop(context),
// // //                 child: const Text("Cancel"),
// // //               ),
// // //
// // //               ElevatedButton(
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: Colors.cyan,
// // //                   shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(12),
// // //                   ),
// // //                 ),
// // //
// // //                 onPressed: () async {
// // //                   if (!mounted) return;
// // //
// // //                   setState(() => isLoading = true);
// // //
// // //                   List<ItemModel> importedEvents = [];
// // //
// // //                   String title = dialogTab == 0
// // //                       ? "Cloud Sync"
// // //                       : (pickedFile?.name ?? "Import");
// // //
// // //                   try {
// // //                     // URL IMPORT
// // //                     if (dialogTab == 0 && urlController.text.isNotEmpty) {
// // //                       importedEvents = await _fetchIcsFromUrl(
// // //                         urlController.text,
// // //                       );
// // //                     }
// // //                     // FILE IMPORT
// // //                     else if (dialogTab == 1 && pickedFile != null) {
// // //                       final bytes = pickedFile!.bytes;
// // //
// // //                       if (bytes != null) {
// // //                         final content = String.fromCharCodes(bytes);
// // //
// // //                         final icard = ICalendar.fromString(content);
// // //
// // //                         for (var entry in icard.data) {
// // //                           try {
// // //                             if (entry['type'] == 'VEVENT') {
// // //                               IcsDateTime? dtStart = entry['dtstart'];
// // //
// // //                               DateTime? eventDate = dtStart?.toDateTime();
// // //
// // //                               importedEvents.add(
// // //                                 ItemModel(
// // //                                   id:
// // //                                       entry['uid']?.toString() ??
// // //                                       UniqueKey().toString(),
// // //
// // //                                   title: entry['summary']?.toString() ?? 'Busy',
// // //
// // //                                   startDateTime: eventDate?.toIso8601String(),
// // //
// // //                                   type: 'event',
// // //                                 ),
// // //                               );
// // //                             }
// // //                           } catch (e) {
// // //                             debugPrint("FILE EVENT ERROR: $e");
// // //                           }
// // //                         }
// // //                       }
// // //                     }
// // //
// // //                     if (!mounted) return;
// // //
// // //                     setState(() {
// // //                       syncedSources.add({
// // //                         'title': title,
// // //                         'url': dialogTab == 0
// // //                             ? urlController.text
// // //                             : pickedFile?.name,
// // //                         'events': importedEvents,
// // //                       });
// // //
// // //                       syncedEventsData = importedEvents;
// // //
// // //                       selectedSource = syncedSources.last;
// // //
// // //                       activeTab = 1;
// // //
// // //                       isLoading = false;
// // //                     });
// // //
// // //                     Navigator.pop(context);
// // //                   } catch (e) {
// // //                     debugPrint("IMPORT ERROR: $e");
// // //
// // //                     if (mounted) {
// // //                       setState(() => isLoading = false);
// // //                     }
// // //                   }
// // //                 },
// // //
// // //                 child: const Text(
// // //                   "Import",
// // //                   style: TextStyle(color: Colors.white),
// // //                 ),
// // //               ),
// // //             ],
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final isDesktop = MediaQuery.of(context).size.width >= 1100;
// // //
// // //     return Scaffold(
// // //       key: scaffoldKey,
// // //
// // //       backgroundColor: const Color(0xFFF8F9FD),
// // //
// // //       endDrawer: CustomRightDrawer(
// // //         isInSublist: false,
// // //         initialSelection: DrawerSelection.event,
// // //         onAddItemToHome: (newItem) => _loadManualEvents(),
// // //       ),
// // //
// // //       body: CustomScrollView(
// // //         slivers: [
// // //           _buildHeader(),
// // //
// // //           if (selectedSource == null) _buildTabNavigation(),
// // //
// // //           if (isLoading)
// // //             _buildShimmer(isDesktop)
// // //           else if (selectedSource != null)
// // //             _buildYearlyCalendar(isDesktop)
// // //           else if (activeTab == 0)
// // //             _buildManualGrid(isDesktop)
// // //           else
// // //             _buildSourcesList(),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   // =========================
// // //   // YEARLY CALENDAR
// // //   // =========================
// // //
// // //   Widget _buildYearlyCalendar(bool isDesktop) {
// // //     return SliverPadding(
// // //       padding: const EdgeInsets.all(30),
// // //
// // //       sliver: SliverGrid(
// // //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // //           crossAxisCount: isDesktop ? 3 : 1,
// // //
// // //           mainAxisSpacing: 30,
// // //
// // //           crossAxisSpacing: 30,
// // //
// // //           childAspectRatio: 0.65,
// // //         ),
// // //
// // //         delegate: SliverChildBuilderDelegate(
// // //           (context, index) => _buildMonthCard(index + 1),
// // //
// // //           childCount: 12,
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildMonthCard(int month) {
// // //     final monthName = DateFormat('MMMM').format(DateTime(currentYear, month));
// // //
// // //     final daysInMonth = DateTime(currentYear, month + 1, 0).day;
// // //
// // //     final firstDay = DateTime(currentYear, month, 1).weekday % 7;
// // //
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //
// // //         borderRadius: BorderRadius.circular(20),
// // //
// // //         boxShadow: [
// // //           BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
// // //         ],
// // //       ),
// // //
// // //       child: Column(
// // //         children: [
// // //           Container(
// // //             padding: const EdgeInsets.all(12),
// // //
// // //             width: double.infinity,
// // //
// // //             decoration: BoxDecoration(
// // //               color: Colors.cyan.withOpacity(0.05),
// // //
// // //               borderRadius: const BorderRadius.vertical(
// // //                 top: Radius.circular(20),
// // //               ),
// // //             ),
// // //
// // //             child: Center(
// // //               child: Text(
// // //                 monthName,
// // //
// // //                 style: const TextStyle(
// // //                   fontWeight: FontWeight.bold,
// // //
// // //                   color: Colors.cyan,
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //
// // //           Expanded(
// // //             child: GridView.builder(
// // //               padding: const EdgeInsets.all(8),
// // //
// // //               physics: const NeverScrollableScrollPhysics(),
// // //
// // //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // //                 crossAxisCount: 7,
// // //
// // //                 mainAxisSpacing: 8,
// // //               ),
// // //
// // //               itemCount: daysInMonth + firstDay,
// // //
// // //               itemBuilder: (context, index) {
// // //                 if (index < firstDay) {
// // //                   return const SizedBox();
// // //                 }
// // //
// // //                 int day = index - firstDay + 1;
// // //
// // //                 final dayEvents = syncedEventsData.where((e) {
// // //                   final d = DateTime.tryParse(e.startDateTime ?? "");
// // //
// // //                   return d?.year == currentYear &&
// // //                       d?.month == month &&
// // //                       d?.day == day;
// // //                 }).toList();
// // //
// // //                 return Column(
// // //                   mainAxisSize: MainAxisSize.min,
// // //
// // //                   children: [
// // //                     Container(
// // //                       width: 24,
// // //                       height: 24,
// // //
// // //                       decoration: BoxDecoration(
// // //                         color: dayEvents.isNotEmpty
// // //                             ? Colors.cyan
// // //                             : Colors.transparent,
// // //
// // //                         shape: BoxShape.circle,
// // //                       ),
// // //
// // //                       child: Center(
// // //                         child: Text(
// // //                           "$day",
// // //
// // //                           style: TextStyle(
// // //                             fontSize: 10,
// // //
// // //                             fontWeight: FontWeight.bold,
// // //
// // //                             color: dayEvents.isNotEmpty
// // //                                 ? Colors.white
// // //                                 : Colors.black,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
// // //
// // //                     if (dayEvents.isNotEmpty)
// // //                       Flexible(
// // //                         child: Text(
// // //                           dayEvents.first.title,
// // //
// // //                           maxLines: 1,
// // //
// // //                           overflow: TextOverflow.ellipsis,
// // //
// // //                           style: const TextStyle(
// // //                             fontSize: 7,
// // //
// // //                             fontWeight: FontWeight.bold,
// // //
// // //                             color: Colors.cyan,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                   ],
// // //                 );
// // //               },
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildHeader() {
// // //     return SliverPadding(
// // //       padding: const EdgeInsets.fromLTRB(30, 40, 30, 10),
// // //
// // //       sliver: SliverToBoxAdapter(
// // //         child: Row(
// // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //
// // //           children: [
// // //             Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //
// // //               children: [
// // //                 Text(
// // //                   selectedSource != null ? selectedSource!['title'] : "Events",
// // //
// // //                   style: GoogleFonts.plusJakartaSans(
// // //                     fontSize: 28,
// // //
// // //                     fontWeight: FontWeight.w800,
// // //                   ),
// // //                 ),
// // //
// // //                 Text(
// // //                   "Management & External Sync",
// // //
// // //                   style: GoogleFonts.plusJakartaSans(
// // //                     fontSize: 13,
// // //
// // //                     color: Colors.grey,
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //
// // //             if (selectedSource != null)
// // //               IconButton(
// // //                 onPressed: () {
// // //                   setState(() {
// // //                     selectedSource = null;
// // //                   });
// // //                 },
// // //
// // //                 icon: const Icon(Iconsax.close_circle, size: 30),
// // //               )
// // //             else
// // //               Row(
// // //                 children: [
// // //                   _buildHeaderBtn(
// // //                     Iconsax.import,
// // //
// // //                     Colors.orange,
// // //
// // //                     "Sync ICS",
// // //
// // //                     _showImportDialog,
// // //                   ),
// // //
// // //                   const SizedBox(width: 12),
// // //
// // //                   _buildHeaderBtn(
// // //                     Iconsax.add,
// // //
// // //                     Colors.cyan,
// // //
// // //                     "Create",
// // //
// // //                     () => scaffoldKey.currentState?.openEndDrawer(),
// // //                   ),
// // //                 ],
// // //               ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildHeaderBtn(
// // //     IconData icon,
// // //     Color color,
// // //     String label,
// // //     VoidCallback onTap,
// // //   ) {
// // //     return ElevatedButton.icon(
// // //       onPressed: onTap,
// // //
// // //       style: ElevatedButton.styleFrom(
// // //         backgroundColor: color,
// // //
// // //         foregroundColor: Colors.white,
// // //
// // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //       ),
// // //
// // //       icon: Icon(icon, size: 18),
// // //
// // //       label: Text(label),
// // //     );
// // //   }
// // //
// // //   Widget _buildTabNavigation() {
// // //     return SliverToBoxAdapter(
// // //       child: Padding(
// // //         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
// // //
// // //         child: Row(
// // //           children: [
// // //             _tab(0, "Manual"),
// // //
// // //             const SizedBox(width: 20),
// // //
// // //             _tab(1, "Synced Sources"),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _tab(int i, String t) {
// // //     bool s = activeTab == i;
// // //
// // //     return GestureDetector(
// // //       onTap: () => setState(() => activeTab = i),
// // //
// // //       child: Column(
// // //         children: [
// // //           Text(
// // //             t,
// // //
// // //             style: GoogleFonts.plusJakartaSans(
// // //               fontWeight: s ? FontWeight.bold : FontWeight.normal,
// // //
// // //               color: s ? Colors.cyan : Colors.grey,
// // //             ),
// // //           ),
// // //
// // //           if (s)
// // //             Container(
// // //               margin: const EdgeInsets.only(top: 4),
// // //
// // //               height: 2,
// // //
// // //               width: 20,
// // //
// // //               color: Colors.cyan,
// // //             ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildSourcesList() {
// // //     return SliverPadding(
// // //       padding: const EdgeInsets.symmetric(horizontal: 30),
// // //
// // //       sliver: SliverList(
// // //         delegate: SliverChildBuilderDelegate(
// // //           (context, index) => Card(
// // //             margin: const EdgeInsets.only(bottom: 12),
// // //
// // //             child: ListTile(
// // //               leading: const Icon(Iconsax.link, color: Colors.orange),
// // //
// // //               title: Text(syncedSources[index]['title']),
// // //
// // //               subtitle: Text(
// // //                 syncedSources[index]['url'],
// // //
// // //                 maxLines: 1,
// // //
// // //                 overflow: TextOverflow.ellipsis,
// // //               ),
// // //
// // //               trailing: const Icon(Iconsax.arrow_right_3),
// // //
// // //               onTap: () {
// // //                 setState(() {
// // //                   selectedSource = syncedSources[index];
// // //
// // //                   syncedEventsData = List<ItemModel>.from(
// // //                     syncedSources[index]['events'],
// // //                   );
// // //                 });
// // //               },
// // //             ),
// // //           ),
// // //
// // //           childCount: syncedSources.length,
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildManualGrid(bool isDesktop) {
// // //     return SliverPadding(
// // //       padding: const EdgeInsets.all(30),
// // //
// // //       sliver: SliverGrid(
// // //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // //           crossAxisCount: isDesktop ? 4 : 1,
// // //
// // //           mainAxisSpacing: 25,
// // //
// // //           crossAxisSpacing: 25,
// // //
// // //           childAspectRatio: 0.8,
// // //         ),
// // //
// // //         delegate: SliverChildBuilderDelegate(
// // //           (context, index) => _buildCard(manualEvents[index]),
// // //
// // //           childCount: manualEvents.length,
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildCard(ItemModel item) {
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //
// // //         borderRadius: BorderRadius.circular(20),
// // //
// // //         boxShadow: [
// // //           BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
// // //         ],
// // //       ),
// // //
// // //       child: Column(
// // //         children: [
// // //           Expanded(
// // //             child: Container(
// // //               decoration: BoxDecoration(
// // //                 borderRadius: const BorderRadius.vertical(
// // //                   top: Radius.circular(20),
// // //                 ),
// // //
// // //                 image: (item.image != null && item.image!.isNotEmpty)
// // //                     ? DecorationImage(
// // //                         image: NetworkImage(item.image!),
// // //
// // //                         fit: BoxFit.cover,
// // //                       )
// // //                     : null,
// // //               ),
// // //
// // //               child: (item.image == null || item.image!.isEmpty)
// // //                   ? const Center(
// // //                       child: Icon(
// // //                         Iconsax.calendar,
// // //                         size: 50,
// // //                         color: Colors.cyan,
// // //                       ),
// // //                     )
// // //                   : null,
// // //             ),
// // //           ),
// // //
// // //           Padding(
// // //             padding: const EdgeInsets.all(12),
// // //
// // //             child: Text(
// // //               item.title,
// // //
// // //               style: const TextStyle(fontWeight: FontWeight.bold),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildToggle(int current, Function(int) onChange) {
// // //     return Row(
// // //       children: [
// // //         Expanded(child: _tItem("Link", current == 0, () => onChange(0))),
// // //
// // //         Expanded(child: _tItem("File", current == 1, () => onChange(1))),
// // //       ],
// // //     );
// // //   }
// // //
// // //   Widget _tItem(String text, bool selected, VoidCallback onTap) {
// // //     return GestureDetector(
// // //       onTap: onTap,
// // //
// // //       child: Container(
// // //         padding: const EdgeInsets.symmetric(vertical: 8),
// // //
// // //         decoration: BoxDecoration(
// // //           color: selected ? Colors.cyan : Colors.transparent,
// // //
// // //           borderRadius: BorderRadius.circular(10),
// // //         ),
// // //
// // //         child: Center(
// // //           child: Text(
// // //             text,
// // //
// // //             style: TextStyle(
// // //               color: selected ? Colors.white : Colors.grey,
// // //
// // //               fontWeight: FontWeight.bold,
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildShimmer(bool isDesktop) {
// // //     return SliverPadding(
// // //       padding: const EdgeInsets.all(30),
// // //
// // //       sliver: SliverGrid(
// // //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // //           crossAxisCount: isDesktop ? 4 : 1,
// // //
// // //           mainAxisSpacing: 25,
// // //
// // //           crossAxisSpacing: 25,
// // //
// // //           childAspectRatio: 0.8,
// // //         ),
// // //
// // //         delegate: SliverChildBuilderDelegate(
// // //           (context, index) => Shimmer.fromColors(
// // //             baseColor: Colors.grey.shade200,
// // //
// // //             highlightColor: Colors.white,
// // //
// // //             child: Container(
// // //               decoration: BoxDecoration(
// // //                 color: Colors.white,
// // //
// // //                 borderRadius: BorderRadius.circular(20),
// // //               ),
// // //             ),
// // //           ),
// // //
// // //           childCount: 8,
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// // import 'dart:ui';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:intl/intl.dart';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:shimmer/shimmer.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:icalendar_parser/icalendar_parser.dart';
// //
// // import '../Controller/Get_all_item_controller.dart';
// // import '../Model/Item_Model.dart';
// //
// // // Ensure these match your local project structure
// // // import '../Controller/Get_all_item_controller.dart';
// // // import '../Model/Item_Model.dart';
// // // import 'PopUp/Right_drawer.dart';
// //
// // class Events extends StatefulWidget {
// //   const Events({super.key});
// //
// //   @override
// //   State<Events> createState() => _EventsState();
// // }
// //
// // class _EventsState extends State<Events> {
// //   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
// //
// //   List<ItemModel> manualEvents = [];
// //   List<ItemModel> syncedEventsData = [];
// //   List<Map<String, dynamic>> syncedSources = [];
// //
// //   bool isLoading = true;
// //   int activeTab = 0;
// //   Map<String, dynamic>? selectedSource;
// //   int currentYear = DateTime.now().year;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadManualEvents();
// //   }
// //
// //   Future<void> _loadManualEvents() async {
// //     if (!mounted) return;
// //     setState(() => isLoading = true);
// //     try {
// //       final allItems = await ItemService.fetchItems();
// //       if (mounted) {
// //         setState(() {
// //           manualEvents = allItems.where((e) => e.type == 'event').toList();
// //           isLoading = false;
// //         });
// //       }
// //     } catch (e) {
// //       if (mounted) setState(() => isLoading = false);
// //     }
// //   }
// //
// //   // =========================
// //   // ICS SYNC LOGIC (FIXED)
// //   // =========================
// //
// //   void _showImportDialog() {
// //     final TextEditingController urlController = TextEditingController();
// //     int dialogTab = 0;
// //     PlatformFile? pickedFile;
// //
// //     showDialog(
// //       context: context,
// //       builder: (context) => StatefulBuilder(
// //         builder: (context, setDialogState) {
// //           return AlertDialog(
// //             backgroundColor: Colors.white,
// //             surfaceTintColor: Colors.white,
// //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
// //             title: Text("Connect Calendar", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
// //             content: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 _buildToggle(dialogTab, (v) => setDialogState(() => dialogTab = v)),
// //                 const SizedBox(height: 25),
// //                 if (dialogTab == 0)
// //                   TextField(
// //                     controller: urlController,
// //                     decoration: InputDecoration(
// //                       hintText: "Paste .ics URL link",
// //                       filled: true,
// //                       fillColor: const Color(0xFFF1F5F9),
// //                       prefixIcon: const Icon(Iconsax.link, color: Color(0xFF00C2D1)),
// //                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
// //                     ),
// //                   )
// //                 else
// //                   InkWell(
// //                     onTap: () async {
// //                       FilePickerResult? result = await FilePicker.platform.pickFiles(
// //                         type: FileType.custom,
// //                         allowedExtensions: ['ics'],
// //                         withData: true,
// //                       );
// //                       if (result != null) setDialogState(() => pickedFile = result.files.first);
// //                     },
// //                     child: Container(
// //                       height: 120,
// //                       width: double.infinity,
// //                       decoration: BoxDecoration(
// //                         color: const Color(0xFFF1F5F9),
// //                         borderRadius: BorderRadius.circular(20),
// //                         border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
// //                       ),
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Icon(pickedFile == null ? Iconsax.document_upload : Iconsax.document_text, color: const Color(0xFF00C2D1)),
// //                           const SizedBox(height: 10),
// //                           Text(pickedFile == null ? "Select .ics File" : pickedFile!.name, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold)),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //               ],
// //             ),
// //             actions: [
// //               TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
// //               ElevatedButton(
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: const Color(0xFF00C2D1),
// //                   foregroundColor: Colors.white,
// //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                 ),
// //                 onPressed: () async {
// //                   setState(() => isLoading = true);
// //                   String content = "";
// //                   try {
// //                     if (dialogTab == 0 && urlController.text.isNotEmpty) {
// //                       final proxyUrl = "https://corsproxy.io/?${Uri.encodeComponent(urlController.text.trim())}";
// //                       final response = await http.get(Uri.parse(proxyUrl));
// //                       if (response.statusCode == 200) content = response.body;
// //                     } else if (dialogTab == 1 && pickedFile != null) {
// //                       content = String.fromCharCodes(pickedFile!.bytes!);
// //                     }
// //
// //                     if (content.contains('BEGIN:VCALENDAR')) {
// //                       final calendar = ICalendar.fromString(content);
// //                       List<ItemModel> parsed = [];
// //                       for (var entry in calendar.data) {
// //                         if (entry['type'] == 'VEVENT') {
// //                           IcsDateTime? dt = entry['dtstart'];
// //                           parsed.add(ItemModel(
// //                             id: entry['uid']?.toString() ?? UniqueKey().toString(),
// //                             title: entry['summary']?.toString() ?? 'Busy',
// //                             startDateTime: dt?.toDateTime()?.toIso8601String(),
// //                             type: 'event',
// //                           ));
// //                         }
// //                       }
// //                       setState(() {
// //                         syncedSources.add({'title': dialogTab == 0 ? "Cloud Sync" : pickedFile!.name, 'url': urlController.text, 'events': parsed});
// //                         syncedEventsData = parsed;
// //                         selectedSource = syncedSources.last;
// //                         activeTab = 1;
// //                         isLoading = false;
// //                       });
// //                     }
// //                   } catch (e) {
// //                     debugPrint("Sync Error: $e");
// //                   }
// //                   setState(() => isLoading = false);
// //                   Navigator.pop(context);
// //                 },
// //                 child: const Text("Import"),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   // =========================
// //   // MAIN UI BUILDER
// //   // =========================
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final isDesktop = MediaQuery.of(context).size.width >= 1100;
// //
// //     return Scaffold(
// //       key: scaffoldKey,
// //       backgroundColor: const Color(0xFFF8FAFC),
// //       endDrawer: const Drawer(), // Replace with your CustomRightDrawer
// //       body: CustomScrollView(
// //         slivers: [
// //           _buildSpaciousHeader(),
// //           _buildPremiumTabs(),
// //           SliverPadding(
// //             padding: EdgeInsets.symmetric(horizontal: isDesktop ? 50 : 20, vertical: 20),
// //             sliver: isLoading ? _buildShimmer(isDesktop) : _buildBodyContent(isDesktop),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBodyContent(bool isDesktop) {
// //     if (selectedSource != null) return _buildModernYearlyCalendar(isDesktop);
// //     return activeTab == 0 ? _buildManualGrid(isDesktop) : _buildSyncedSourcesGrid(isDesktop);
// //   }
// //
// //   Widget _buildSpaciousHeader() {
// //     return SliverToBoxAdapter(
// //       child: Padding(
// //         padding: const EdgeInsets.fromLTRB(50, 60, 50, 20),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   selectedSource != null ? selectedSource!['title'] : "Organization Events",
// //                   style: GoogleFonts.plusJakartaSans(fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1, color: const Color(0xFF1E293B)),
// //                 ),
// //                 const SizedBox(height: 6),
// //                 _statusPill("Overview • ${activeTab == 0 ? manualEvents.length : syncedSources.length} items found"),
// //               ],
// //             ),
// //             if (selectedSource != null)
// //               _circularActionBtn(Iconsax.close_circle, Colors.redAccent, () => setState(() => selectedSource = null))
// //             else
// //               Row(
// //                 children: [
// //                   _mainBtn(Iconsax.import, "Sync ICS", Colors.orange.shade600, _showImportDialog),
// //                   const SizedBox(width: 15),
// //                   _mainBtn(Iconsax.add, "Add Event", const Color(0xFF00C2D1), () => scaffoldKey.currentState?.openEndDrawer()),
// //                 ],
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildPremiumTabs() {
// //     return SliverToBoxAdapter(
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
// //         child: Row(children: [_tabItem(0, "Manual"), const SizedBox(width: 40), _tabItem(1, "Synced Sources")]),
// //       ),
// //     );
// //   }
// //
// //   // =========================
// //   // GRIDS & CALENDAR
// //   // =========================
// //
// //   Widget _buildManualGrid(bool isDesktop) {
// //     return SliverGrid(
// //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //         crossAxisCount: isDesktop ? 4 : 1,
// //         mainAxisSpacing: 30,
// //         crossAxisSpacing: 30,
// //         childAspectRatio: 0.85,
// //       ),
// //       delegate: SliverChildBuilderDelegate((context, index) => _buildEventCard(manualEvents[index]), childCount: manualEvents.length),
// //     );
// //   }
// //
// //   Widget _buildEventCard(ItemModel item) {
// //     DateTime? date = DateTime.tryParse(item.startDateTime ?? "");
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(28),
// //         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 12))],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Expanded(
// //             flex: 5,
// //             child: Stack(
// //               children: [
// //                 Container(
// //                   margin: const EdgeInsets.all(10),
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(22),
// //                     image: (item.image != null) ? DecorationImage(image: NetworkImage(item.image!), fit: BoxFit.cover) : null,
// //                     color: const Color(0xFFF1F5F9),
// //                   ),
// //                 ),
// //                 Positioned(top: 25, left: 25, child: _buildDateBadge(date)),
// //               ],
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.fromLTRB(25, 5, 25, 20),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18, color: const Color(0xFF1E293B))),
// //                 const SizedBox(height: 10),
// //                 _rowDetail(Iconsax.clock, date != null ? DateFormat('hh:mm a').format(date) : "--:--"),
// //                 _rowDetail(Iconsax.location, "Event Location"),
// //                 const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(color: Color(0xFFF1F5F9))),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text("Manage Event", style: GoogleFonts.plusJakartaSans(color: const Color(0xFF007BFF), fontWeight: FontWeight.w700, fontSize: 13)),
// //                     Row(children: [const Icon(Iconsax.edit, size: 20, color: Colors.green), const SizedBox(width: 15), const Icon(Iconsax.trash, size: 20, color: Colors.redAccent)])
// //                   ],
// //                 )
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSyncedSourcesGrid(bool isDesktop) {
// //     return SliverGrid(
// //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 3 : 1, mainAxisSpacing: 25, crossAxisSpacing: 25, childAspectRatio: 2.2),
// //       delegate: SliverChildBuilderDelegate((context, index) => _buildSourceTile(syncedSources[index]), childCount: syncedSources.length),
// //     );
// //   }
// //
// //   Widget _buildSourceTile(Map<String, dynamic> source) {
// //     return InkWell(
// //       onTap: () => setState(() { selectedSource = source; syncedEventsData = List<ItemModel>.from(source['events']); }),
// //       child: Container(
// //         padding: const EdgeInsets.all(20),
// //         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE2E8F0))),
// //         child: Row(
// //           children: [
// //             Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(18)), child: const Icon(Iconsax.link, color: Colors.orange, size: 28)),
// //             const SizedBox(width: 20),
// //             Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(source['title'], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18)), const SizedBox(height: 4), Text(source['url'], maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 12))])),
// //             const Icon(Iconsax.arrow_right_3, color: Color(0xFF00C2D1)),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildModernYearlyCalendar(bool isDesktop) {
// //     return SliverGrid(
// //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 3 : 1, mainAxisSpacing: 40, crossAxisSpacing: 40, childAspectRatio: 0.75),
// //       delegate: SliverChildBuilderDelegate((context, index) => _buildCalendarMonthCard(index + 1), childCount: 12),
// //     );
// //   }
// //
// //   Widget _buildCalendarMonthCard(int month) {
// //     final monthName = DateFormat('MMMM').format(DateTime(currentYear, month));
// //     final daysInMonth = DateTime(currentYear, month + 1, 0).day;
// //     final firstDay = DateTime(currentYear, month, 1).weekday % 7;
// //
// //     return Container(
// //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: const Color(0xFF00C2D1).withOpacity(0.05), blurRadius: 30, offset: const Offset(0, 15))]),
// //       child: Column(
// //         children: [
// //           Padding(padding: const EdgeInsets.all(25), child: Text(monthName, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 20, color: const Color(0xFF1E293B)))),
// //           const Divider(height: 1, color: Color(0xFFF1F5F9)),
// //           Expanded(
// //             child: GridView.builder(
// //               padding: const EdgeInsets.all(20),
// //               physics: const NeverScrollableScrollPhysics(),
// //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8),
// //               itemCount: daysInMonth + firstDay,
// //               itemBuilder: (context, index) {
// //                 if (index < firstDay) return const SizedBox();
// //                 int day = index - firstDay + 1;
// //                 bool hasEvent = syncedEventsData.any((e) {
// //                   final d = DateTime.tryParse(e.startDateTime ?? "");
// //                   return d?.year == currentYear && d?.month == month && d?.day == day;
// //                 });
// //                 return Container(
// //                   decoration: BoxDecoration(color: hasEvent ? const Color(0xFF00C2D1) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
// //                   child: Center(child: Text("$day", style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: hasEvent ? FontWeight.w800 : FontWeight.w500, color: hasEvent ? Colors.white : const Color(0xFF64748B)))),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // =========================
// //   // UTILS
// //   // =========================
// //
// //   Widget _statusPill(String text) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100), border: Border.all(color: const Color(0xFFE2E8F0))),
// //       child: Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
// //     );
// //   }
// //
// //   Widget _tabItem(int index, String label) {
// //     bool isSelected = activeTab == index;
// //     return GestureDetector(
// //       onTap: () => setState(() { activeTab = index; selectedSource = null; }),
// //       child: Column(children: [
// //         Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500, color: isSelected ? const Color(0xFF1E293B) : Colors.grey)),
// //         const SizedBox(height: 8),
// //         AnimatedContainer(duration: const Duration(milliseconds: 300), height: 4, width: isSelected ? 30 : 0, decoration: BoxDecoration(color: const Color(0xFF00C2D1), borderRadius: BorderRadius.circular(10))),
// //       ]),
// //     );
// //   }
// //
// //   Widget _buildToggle(int current, Function(int) onChange) {
// //     return Container(
// //       padding: const EdgeInsets.all(4),
// //       decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
// //       child: Row(children: [
// //         Expanded(child: _toggleItem("URL Link", current == 0, () => onChange(0))),
// //         Expanded(child: _toggleItem("Local File", current == 1, () => onChange(1))),
// //       ]),
// //     );
// //   }
// //
// //   Widget _toggleItem(String label, bool s, VoidCallback onTap) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(vertical: 10),
// //         decoration: BoxDecoration(color: s ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(10), boxShadow: s ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : null),
// //         child: Center(child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: s ? const Color(0xFF00C2D1) : Colors.grey))),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildDateBadge(DateTime? date) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //       decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(14),
// //           // backdropFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8)
// //       ),
// //       child: Column(children: [
// //         Text(date != null ? DateFormat('dd').format(date) : "01", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 18, color: const Color(0xFF1E293B))),
// //         Text(date != null ? DateFormat('MMM').format(date).toUpperCase() : "MAY", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 11, color: const Color(0xFF00C2D1))),
// //       ]),
// //     );
// //   }
// //
// //   Widget _mainBtn(IconData icon, String label, Color color, VoidCallback onTap) {
// //     return ElevatedButton.icon(
// //       onPressed: onTap, icon: Icon(icon, size: 20), label: Text(label),
// //       style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
// //     );
// //   }
// //
// //   Widget _rowDetail(IconData icon, String label) {
// //     return Row(children: [Icon(icon, size: 16, color: const Color(0xFF00C2D1)), const SizedBox(width: 10), Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF64748B), fontWeight: FontWeight.w500))]);
// //   }
// //
// //   Widget _circularActionBtn(IconData icon, Color color, VoidCallback onTap) => IconButton(onPressed: onTap, icon: Icon(icon, color: color, size: 34));
// //
// //   Widget _buildShimmer(bool isDesktop) {
// //     return SliverGrid(
// //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 4 : 1, mainAxisSpacing: 30, crossAxisSpacing: 30, childAspectRatio: 0.8),
// //       delegate: SliverChildBuilderDelegate((context, index) => Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.white, child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)))), childCount: 8),
// //     );
// //   }
// // }
//
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:http/http.dart' as http;
// import 'package:icalendar_parser/icalendar_parser.dart';
//
// // Ensure these match your local project structure
// import '../Controller/Get_all_item_controller.dart';
// import '../Model/Item_Model.dart';
//
// class Events extends StatefulWidget {
//   const Events({super.key});
//
//   @override
//   State<Events> createState() => _EventsState();
// }
//
// class _EventsState extends State<Events> {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//
//   List<ItemModel> manualEvents = [];
//   List<ItemModel> syncedEventsData = [];
//   List<Map<String, dynamic>> syncedSources = [];
//
//   bool isLoading = true;
//   int activeTab = 0;
//   Map<String, dynamic>? selectedSource;
//   int currentYear = DateTime.now().year;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadManualEvents();
//   }
//
//   Future<void> _loadManualEvents() async {
//     if (!mounted) return;
//     setState(() => isLoading = true);
//     try {
//       final allItems = await ItemService.fetchItems();
//       if (mounted) {
//         setState(() {
//           manualEvents = allItems.where((e) => e.type == 'event').toList();
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }
//
//   void _showImportDialog() {
//     final TextEditingController urlController = TextEditingController();
//     int dialogTab = 0;
//     PlatformFile? pickedFile;
//
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setDialogState) {
//           return AlertDialog(
//             backgroundColor: Colors.white,
//             surfaceTintColor: Colors.white,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
//             title: Text("Connect Calendar", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildToggle(dialogTab, (v) => setDialogState(() => dialogTab = v)),
//                 const SizedBox(height: 25),
//                 if (dialogTab == 0)
//                   TextField(
//                     controller: urlController,
//                     decoration: InputDecoration(
//                       hintText: "Paste .ics URL link",
//                       filled: true,
//                       fillColor: const Color(0xFFF1F5F9),
//                       prefixIcon: const Icon(Iconsax.link, color: Color(0xFF00C2D1)),
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
//                     ),
//                   )
//                 else
//                   InkWell(
//                     onTap: () async {
//                       FilePickerResult? result = await FilePicker.platform.pickFiles(
//                         type: FileType.custom,
//                         allowedExtensions: ['ics'],
//                         withData: true,
//                       );
//                       if (result != null) setDialogState(() => pickedFile = result.files.first);
//                     },
//                     child: Container(
//                       height: 120,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF1F5F9),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(pickedFile == null ? Iconsax.document_upload : Iconsax.document_text, color: const Color(0xFF00C2D1)),
//                           const SizedBox(height: 10),
//                           Text(pickedFile == null ? "Select .ics File" : pickedFile!.name, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             actions: [
//               TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF00C2D1),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 onPressed: () async {
//                   setState(() => isLoading = true);
//                   String content = "";
//                   try {
//                     if (dialogTab == 0 && urlController.text.isNotEmpty) {
//                       final proxyUrl = "https://corsproxy.io/?${Uri.encodeComponent(urlController.text.trim())}";
//                       final response = await http.get(Uri.parse(proxyUrl));
//                       if (response.statusCode == 200) content = response.body;
//                     } else if (dialogTab == 1 && pickedFile != null) {
//                       content = String.fromCharCodes(pickedFile!.bytes!);
//                     }
//
//                     if (content.contains('BEGIN:VCALENDAR')) {
//                       final calendar = ICalendar.fromString(content);
//                       List<ItemModel> parsed = [];
//                       for (var entry in calendar.data) {
//                         if (entry['type'] == 'VEVENT') {
//                           IcsDateTime? dt = entry['dtstart'];
//                           parsed.add(ItemModel(
//                             id: entry['uid']?.toString() ?? UniqueKey().toString(),
//                             title: entry['summary']?.toString() ?? 'Busy',
//                             startDateTime: dt?.toDateTime()?.toIso8601String(),
//                             type: 'event',
//                           ));
//                         }
//                       }
//                       setState(() {
//                         syncedSources.add({'title': dialogTab == 0 ? "Cloud Sync" : pickedFile!.name, 'url': urlController.text, 'events': parsed});
//                         syncedEventsData = parsed;
//                         selectedSource = syncedSources.last;
//                         activeTab = 1;
//                         isLoading = false;
//                       });
//                     }
//                   } catch (e) {
//                     debugPrint("Sync Error: $e");
//                   }
//                   setState(() => isLoading = false);
//                   Navigator.pop(context);
//                 },
//                 child: const Text("Import"),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = MediaQuery.of(context).size.width >= 1100;
//
//     return Scaffold(
//       key: scaffoldKey,
//       backgroundColor: const Color(0xFFF8FAFC),
//       endDrawer: const Drawer(),
//       body: CustomScrollView(
//         slivers: [
//           _buildSpaciousHeader(),
//           _buildPremiumTabs(),
//           SliverPadding(
//             padding: EdgeInsets.symmetric(horizontal: isDesktop ? 50 : 20, vertical: 20),
//             sliver: isLoading ? _buildShimmer(isDesktop) : _buildBodyContent(isDesktop),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBodyContent(bool isDesktop) {
//     if (selectedSource != null) return _buildModernYearlyCalendar(isDesktop);
//     return activeTab == 0 ? _buildManualGrid(isDesktop) : _buildSyncedSourcesGrid(isDesktop);
//   }
//
//   Widget _buildSpaciousHeader() {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(50, 60, 50, 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   selectedSource != null ? selectedSource!['title'] : "Organization Events",
//                   style: GoogleFonts.plusJakartaSans(fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1, color: const Color(0xFF1E293B)),
//                 ),
//                 const SizedBox(height: 6),
//                 _statusPill("Overview • ${activeTab == 0 ? manualEvents.length : syncedSources.length} items found"),
//               ],
//             ),
//             if (selectedSource != null)
//               _circularActionBtn(Iconsax.close_circle, Colors.redAccent, () => setState(() => selectedSource = null))
//             else
//               Row(
//                 children: [
//                   _mainBtn(Iconsax.import, "Sync ICS", Colors.orange.shade600, _showImportDialog),
//                   const SizedBox(width: 15),
//                   _mainBtn(Iconsax.add, "Add Event", const Color(0xFF00C2D1), () => scaffoldKey.currentState?.openEndDrawer()),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPremiumTabs() {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
//         child: Row(children: [_tabItem(0, "Manual"), const SizedBox(width: 40), _tabItem(1, "Synced Sources")]),
//       ),
//     );
//   }
//
//   Widget _buildManualGrid(bool isDesktop) {
//     return SliverGrid(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: isDesktop ? 4 : 1,
//         mainAxisSpacing: 30,
//         crossAxisSpacing: 30,
//         childAspectRatio: 0.85,
//       ),
//       delegate: SliverChildBuilderDelegate((context, index) => _buildEventCard(manualEvents[index]), childCount: manualEvents.length),
//     );
//   }
//
//   Widget _buildEventCard(ItemModel item) {
//     DateTime? date = DateTime.tryParse(item.startDateTime ?? "");
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(28),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 12))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 5,
//             child: Stack(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(22),
//                     image: (item.image != null) ? DecorationImage(image: NetworkImage(item.image!), fit: BoxFit.cover) : null,
//                     color: const Color(0xFFF1F5F9),
//                   ),
//                 ),
//                 Positioned(top: 25, left: 25, child: _buildDateBadge(date)),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(25, 5, 25, 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18, color: const Color(0xFF1E293B))),
//                 const SizedBox(height: 10),
//                 _rowDetail(Iconsax.clock, date != null ? DateFormat('hh:mm a').format(date) : "--:--"),
//                 _rowDetail(Iconsax.location, "Event Location"),
//                 const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(color: Color(0xFFF1F5F9))),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Manage Event", style: GoogleFonts.plusJakartaSans(color: const Color(0xFF007BFF), fontWeight: FontWeight.w700, fontSize: 13)),
//                     Row(children: [const Icon(Iconsax.edit, size: 20, color: Colors.green), const SizedBox(width: 15), const Icon(Iconsax.trash, size: 20, color: Colors.redAccent)])
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSyncedSourcesGrid(bool isDesktop) {
//     return SliverGrid(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 3 : 1, mainAxisSpacing: 25, crossAxisSpacing: 25, childAspectRatio: 2.2),
//       delegate: SliverChildBuilderDelegate((context, index) => _buildSourceTile(syncedSources[index]), childCount: syncedSources.length),
//     );
//   }
//
//   Widget _buildSourceTile(Map<String, dynamic> source) {
//     return InkWell(
//       onTap: () => setState(() { selectedSource = source; syncedEventsData = List<ItemModel>.from(source['events']); }),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE2E8F0))),
//         child: Row(
//           children: [
//             Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(18)), child: const Icon(Iconsax.link, color: Colors.orange, size: 28)),
//             const SizedBox(width: 20),
//             Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(source['title'], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18)), const SizedBox(height: 4), Text(source['url'], maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 12))])),
//             const Icon(Iconsax.arrow_right_3, color: Color(0xFF00C2D1)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildModernYearlyCalendar(bool isDesktop) {
//     return SliverGrid(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 3 : 1, mainAxisSpacing: 40, crossAxisSpacing: 40, childAspectRatio: 0.75),
//       delegate: SliverChildBuilderDelegate((context, index) => _buildCalendarMonthCard(index + 1), childCount: 12),
//     );
//   }
//
//   Widget _buildCalendarMonthCard(int month) {
//     final monthName = DateFormat('MMMM').format(DateTime(currentYear, month));
//     final daysInMonth = DateTime(currentYear, month + 1, 0).day;
//     final firstDay = DateTime(currentYear, month, 1).weekday % 7;
//
//     final List<String> dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
//
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//                 color: const Color(0xFF00C2D1).withOpacity(0.05),
//                 blurRadius: 30,
//                 offset: const Offset(0, 15)
//             )
//           ]
//       ),
//       child: Column(
//         children: [
//           Padding(
//               padding: const EdgeInsets.all(25),
//               child: Text(
//                   monthName,
//                   style: GoogleFonts.plusJakartaSans(
//                       fontWeight: FontWeight.w900,
//                       fontSize: 20,
//                       color: const Color(0xFF1E293B)
//                   )
//               )
//           ),
//           const Divider(height: 1, color: Color(0xFFF1F5F9)),
//
//           // Day Labels Row
//           Padding(
//             padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: List.generate(7, (index) {
//                 bool isSunday = index == 0;
//                 return Expanded(
//                   child: Center(
//                     child: Text(
//                       dayLabels[index],
//                       style: GoogleFonts.plusJakartaSans(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w800,
//                         color: isSunday ? Colors.redAccent : const Color(0xFF94A3B8),
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//
//           Expanded(
//             child: GridView.builder(
//               padding: const EdgeInsets.all(15),
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 7,
//                 mainAxisSpacing: 4,
//                 crossAxisSpacing: 4,
//                 childAspectRatio: 0.8, // Slightly taller to fit labels
//               ),
//               itemCount: daysInMonth + firstDay,
//               itemBuilder: (context, index) {
//                 if (index < firstDay) return const SizedBox();
//                 int day = index - firstDay + 1;
//                 bool isSunday = index % 7 == 0;
//
//                 // Find events for this specific day
//                 final dayEvents = syncedEventsData.where((e) {
//                   final d = DateTime.tryParse(e.startDateTime ?? "");
//                   return d?.year == currentYear && d?.month == month && d?.day == day;
//                 }).toList();
//
//                 bool hasEvent = dayEvents.isNotEmpty;
//
//                 return Container(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   decoration: BoxDecoration(
//                     color: hasEvent ? const Color(0xFF00C2D1).withOpacity(0.1) : Colors.transparent,
//                     borderRadius: BorderRadius.circular(12),
//                     border: hasEvent ? Border.all(color: const Color(0xFF00C2D1).withOpacity(0.2)) : null,
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "$day",
//                         style: GoogleFonts.plusJakartaSans(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w800,
//                             color: hasEvent
//                                 ? const Color(0xFF00C2D1)
//                                 : (isSunday ? Colors.redAccent : const Color(0xFF64748B))
//                         ),
//                       ),
//                       if (hasEvent)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 4),
//                           child: Text(
//                             dayEvents.first.title,
//                             maxLines: 1,
//                             textAlign: TextAlign.center,
//                             overflow: TextOverflow.ellipsis,
//                             style: GoogleFonts.plusJakartaSans(
//                               fontSize: 7,
//                               fontWeight: FontWeight.w700,
//                               color: const Color(0xFF00C2D1),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _statusPill(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100), border: Border.all(color: const Color(0xFFE2E8F0))),
//       child: Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
//     );
//   }
//
//   Widget _tabItem(int index, String label) {
//     bool isSelected = activeTab == index;
//     return GestureDetector(
//       onTap: () => setState(() { activeTab = index; selectedSource = null; }),
//       child: Column(children: [
//         Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500, color: isSelected ? const Color(0xFF1E293B) : Colors.grey)),
//         const SizedBox(height: 8),
//         AnimatedContainer(duration: const Duration(milliseconds: 300), height: 4, width: isSelected ? 30 : 0, decoration: BoxDecoration(color: const Color(0xFF00C2D1), borderRadius: BorderRadius.circular(10))),
//       ]),
//     );
//   }
//
//   Widget _buildToggle(int current, Function(int) onChange) {
//     return Container(
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
//       child: Row(children: [
//         Expanded(child: _toggleItem("URL Link", current == 0, () => onChange(0))),
//         Expanded(child: _toggleItem("Local File", current == 1, () => onChange(1))),
//       ]),
//     );
//   }
//
//   Widget _toggleItem(String label, bool s, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(color: s ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(10), boxShadow: s ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : null),
//         child: Center(child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: s ? const Color(0xFF00C2D1) : Colors.grey))),
//       ),
//     );
//   }
//
//   // FIXED METHOD
//   Widget _buildDateBadge(DateTime? date) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(14),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           color: Colors.white.withOpacity(0.8), // Reduced opacity for better blur effect
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 date != null ? DateFormat('dd').format(date) : "01",
//                 style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 18, color: const Color(0xFF1E293B)),
//               ),
//               Text(
//                 date != null ? DateFormat('MMM').format(date).toUpperCase() : "MAY",
//                 style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 11, color: const Color(0xFF00C2D1)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _mainBtn(IconData icon, String label, Color color, VoidCallback onTap) {
//     return ElevatedButton.icon(
//       onPressed: onTap, icon: Icon(icon, size: 20), label: Text(label),
//       style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
//     );
//   }
//
//   Widget _rowDetail(IconData icon, String label) {
//     return Row(children: [Icon(icon, size: 16, color: const Color(0xFF00C2D1)), const SizedBox(width: 10), Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF64748B), fontWeight: FontWeight.w500))]);
//   }
//
//   Widget _circularActionBtn(IconData icon, Color color, VoidCallback onTap) => IconButton(onPressed: onTap, icon: Icon(icon, color: color, size: 34));
//
//   Widget _buildShimmer(bool isDesktop) {
//     return SliverGrid(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 4 : 1, mainAxisSpacing: 30, crossAxisSpacing: 30, childAspectRatio: 0.8),
//       delegate: SliverChildBuilderDelegate((context, index) => Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.white, child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)))), childCount: 8),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';

// Ensure these match your local project structure
import '../Controller/Get_all_item_controller.dart';
import '../Model/Item_Model.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<ItemModel> manualEvents = [];
  List<ItemModel> syncedEventsData = [];
  List<Map<String, dynamic>> syncedSources = [];

  bool isLoading = true;
  int activeTab = 0;
  Map<String, dynamic>? selectedSource;
  int currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _loadManualEvents();
  }

  Future<void> _loadManualEvents() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final allItems = await ItemService.fetchItems();
      if (mounted) {
        setState(() {
          manualEvents = allItems.where((e) => e.type == 'event').toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showImportDialog() {
    final TextEditingController urlController = TextEditingController();
    int dialogTab = 0;
    PlatformFile? pickedFile;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            title: Text("Connect Calendar", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildToggle(dialogTab, (v) => setDialogState(() => dialogTab = v)),
                const SizedBox(height: 25),
                if (dialogTab == 0)
                  TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintText: "Paste .ics URL link",
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      prefixIcon: const Icon(Iconsax.link, color: Color(0xFF00C2D1)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    ),
                  )
                else
                  InkWell(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['ics'],
                        withData: true,
                      );
                      if (result != null) setDialogState(() => pickedFile = result.files.first);
                    },
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(pickedFile == null ? Iconsax.document_upload : Iconsax.document_text, color: const Color(0xFF00C2D1)),
                          const SizedBox(height: 10),
                          Text(pickedFile == null ? "Select .ics File" : pickedFile!.name, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C2D1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  setState(() => isLoading = true);
                  String content = "";
                  try {
                    if (dialogTab == 0 && urlController.text.isNotEmpty) {
                      final proxyUrl = "https://corsproxy.io/?${Uri.encodeComponent(urlController.text.trim())}";
                      final response = await http.get(Uri.parse(proxyUrl));
                      if (response.statusCode == 200) content = response.body;
                    } else if (dialogTab == 1 && pickedFile != null) {
                      content = String.fromCharCodes(pickedFile!.bytes!);
                    }

                    if (content.contains('BEGIN:VCALENDAR')) {
                      final calendar = ICalendar.fromString(content);
                      List<ItemModel> parsed = [];
                      for (var entry in calendar.data) {
                        if (entry['type'] == 'VEVENT') {
                          IcsDateTime? dt = entry['dtstart'];
                          parsed.add(ItemModel(
                            id: entry['uid']?.toString() ?? UniqueKey().toString(),
                            title: entry['summary']?.toString() ?? 'Busy',
                            startDateTime: dt?.toDateTime()?.toIso8601String(),
                            type: 'event',
                          ));
                        }
                      }
                      setState(() {
                        syncedSources.add({'title': dialogTab == 0 ? "Cloud Sync" : pickedFile!.name, 'url': urlController.text, 'events': parsed});
                        syncedEventsData = parsed;
                        selectedSource = syncedSources.last;
                        activeTab = 1;
                        isLoading = false;
                      });
                    }
                  } catch (e) {
                    debugPrint("Sync Error: $e");
                  }
                  setState(() => isLoading = false);
                  Navigator.pop(context);
                },
                child: const Text("Import"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1100;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildSpaciousHeader(),
          _buildPremiumTabs(),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 50 : 20, vertical: 20),
            sliver: isLoading ? _buildShimmer(isDesktop) : _buildBodyContent(isDesktop),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent(bool isDesktop) {
    if (selectedSource != null) return _buildModernYearlyCalendar(isDesktop);
    return activeTab == 0 ? _buildManualGrid(isDesktop) : _buildSyncedSourcesGrid(isDesktop);
  }

  Widget _buildSpaciousHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(50, 60, 50, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedSource != null ? selectedSource!['title'] : "Organization Events",
                  style: GoogleFonts.plusJakartaSans(fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1, color: const Color(0xFF1E293B)),
                ),
                const SizedBox(height: 6),
                _statusPill("Overview • ${activeTab == 0 ? manualEvents.length : syncedSources.length} items found"),
              ],
            ),
            if (selectedSource != null)
              _circularActionBtn(Iconsax.close_circle, Colors.redAccent, () => setState(() => selectedSource = null))
            else
              Row(
                children: [
                  _mainBtn(Iconsax.import, "Sync ICS", Colors.orange.shade600, _showImportDialog),
                  const SizedBox(width: 15),
                  _mainBtn(Iconsax.add, "Add Event", const Color(0xFF00C2D1), () {}),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumTabs() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        child: Row(children: [_tabItem(0, "Manual"), const SizedBox(width: 40), _tabItem(1, "Synced Sources")]),
      ),
    );
  }

  Widget _buildManualGrid(bool isDesktop) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 4 : 1,
        mainAxisSpacing: 30,
        crossAxisSpacing: 30,
        childAspectRatio: 0.85,
      ),
      delegate: SliverChildBuilderDelegate((context, index) => _buildEventCard(manualEvents[index]), childCount: manualEvents.length),
    );
  }

  Widget _buildEventCard(ItemModel item) {
    DateTime? date = DateTime.tryParse(item.startDateTime ?? "");
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    image: (item.image != null) ? DecorationImage(image: NetworkImage(item.image!), fit: BoxFit.cover) : null,
                    color: const Color(0xFFF1F5F9),
                  ),
                ),
                Positioned(top: 25, left: 25, child: _buildDateBadge(date)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 5, 25, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18, color: const Color(0xFF1E293B))),
                const SizedBox(height: 10),
                _rowDetail(Iconsax.clock, date != null ? DateFormat('hh:mm a').format(date) : "--:--"),
                _rowDetail(Iconsax.location, "Event Location"),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(color: Color(0xFFF1F5F9))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Manage Event", style: GoogleFonts.plusJakartaSans(color: const Color(0xFF007BFF), fontWeight: FontWeight.w700, fontSize: 13)),
                    Row(children: [const Icon(Iconsax.edit, size: 20, color: Colors.green), const SizedBox(width: 15), const Icon(Iconsax.trash, size: 20, color: Colors.redAccent)])
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncedSourcesGrid(bool isDesktop) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 3 : 1, mainAxisSpacing: 25, crossAxisSpacing: 25, childAspectRatio: 2.2),
      delegate: SliverChildBuilderDelegate((context, index) => _buildSourceTile(syncedSources[index]), childCount: syncedSources.length),
    );
  }

  Widget _buildSourceTile(Map<String, dynamic> source) {
    return InkWell(
      onTap: () => setState(() { selectedSource = source; syncedEventsData = List<ItemModel>.from(source['events']); }),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(18)), child: const Icon(Iconsax.link, color: Colors.orange, size: 28)),
            const SizedBox(width: 20),
            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(source['title'], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18)), const SizedBox(height: 4), Text(source['url'], maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 12))])),
            const Icon(Iconsax.arrow_right_3, color: Color(0xFF00C2D1)),
          ],
        ),
      ),
    );
  }

  Widget _buildModernYearlyCalendar(bool isDesktop) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 3 : 1, mainAxisSpacing: 40, crossAxisSpacing: 40, childAspectRatio: 0.75),
      delegate: SliverChildBuilderDelegate((context, index) => _buildCalendarMonthCard(index + 1), childCount: 12),
    );
  }

  Widget _buildCalendarMonthCard(int month) {
    final monthName = DateFormat('MMMM').format(DateTime(currentYear, month));
    final daysInMonth = DateTime(currentYear, month + 1, 0).day;
    final firstDay = DateTime(currentYear, month, 1).weekday % 7;

    final List<String> dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF00C2D1).withOpacity(0.05),
                blurRadius: 30,
                offset: const Offset(0, 15)
            )
          ]
      ),
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(25),
              child: Text(
                  monthName,
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 20, color: const Color(0xFF1E293B))
              )
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                bool isSunday = index == 0;
                return Expanded(
                  child: Center(
                    child: Text(
                      dayLabels[index],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isSunday ? Colors.redAccent : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(15),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 0.8,
              ),
              itemCount: daysInMonth + firstDay,
              itemBuilder: (context, index) {
                if (index < firstDay) return const SizedBox();
                int day = index - firstDay + 1;
                bool isSunday = index % 7 == 0;

                final dayEvents = syncedEventsData.where((e) {
                  final d = DateTime.tryParse(e.startDateTime ?? "");
                  return d?.year == currentYear && d?.month == month && d?.day == day;
                }).toList();

                bool hasEvent = dayEvents.isNotEmpty;
                String fullTitle = hasEvent ? dayEvents.first.title : "";

                return Tooltip(
                  message: hasEvent ? fullTitle : "$monthName $day",
                  verticalOffset: 20,
                  preferBelow: false,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: HoverMagnifier(
                    hasEvent: hasEvent,
                    isSunday: isSunday,
                    day: day,
                    eventTitle: fullTitle,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
    );
  }

  Widget _tabItem(int index, String label) {
    bool isSelected = activeTab == index;
    return GestureDetector(
      onTap: () => setState(() { activeTab = index; selectedSource = null; }),
      child: Column(children: [
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500, color: isSelected ? const Color(0xFF1E293B) : Colors.grey)),
        const SizedBox(height: 8),
        AnimatedContainer(duration: const Duration(milliseconds: 300), height: 4, width: isSelected ? 30 : 0, decoration: BoxDecoration(color: const Color(0xFF00C2D1), borderRadius: BorderRadius.circular(10))),
      ]),
    );
  }

  Widget _buildToggle(int current, Function(int) onChange) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Expanded(child: _toggleItem("URL Link", current == 0, () => onChange(0))),
        Expanded(child: _toggleItem("Local File", current == 1, () => onChange(1))),
      ]),
    );
  }

  Widget _toggleItem(String label, bool s, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: s ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(10), boxShadow: s ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : null),
        child: Center(child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: s ? const Color(0xFF00C2D1) : Colors.grey))),
      ),
    );
  }

  Widget _buildDateBadge(DateTime? date) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.white.withOpacity(0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(date != null ? DateFormat('dd').format(date) : "01", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 18, color: const Color(0xFF1E293B))),
              Text(date != null ? DateFormat('MMM').format(date).toUpperCase() : "MAY", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 11, color: const Color(0xFF00C2D1))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap, icon: Icon(icon, size: 20), label: Text(label),
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
    );
  }

  Widget _rowDetail(IconData icon, String label) {
    return Row(children: [Icon(icon, size: 16, color: const Color(0xFF00C2D1)), const SizedBox(width: 10), Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF64748B), fontWeight: FontWeight.w500))]);
  }

  Widget _circularActionBtn(IconData icon, Color color, VoidCallback onTap) => IconButton(onPressed: onTap, icon: Icon(icon, color: color, size: 34));

  Widget _buildShimmer(bool isDesktop) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 4 : 1, mainAxisSpacing: 30, crossAxisSpacing: 30, childAspectRatio: 0.8),
      delegate: SliverChildBuilderDelegate((context, index) => Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.white, child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)))), childCount: 8),
    );
  }
}

class HoverMagnifier extends StatefulWidget {
  final bool hasEvent;
  final bool isSunday;
  final int day;
  final String eventTitle;

  const HoverMagnifier({
    super.key,
    required this.hasEvent,
    required this.isSunday,
    required this.day,
    required this.eventTitle,
  });

  @override
  State<HoverMagnifier> createState() => _HoverMagnifierState();
}

class _HoverMagnifierState extends State<HoverMagnifier> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: isHovered ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isHovered
                ? const Color(0xFF00C2D1).withOpacity(0.2)
                : (widget.hasEvent ? const Color(0xFF00C2D1).withOpacity(0.1) : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isHovered || widget.hasEvent
                    ? const Color(0xFF00C2D1).withOpacity(0.3)
                    : Colors.transparent
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.day}",
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: widget.hasEvent
                        ? const Color(0xFF00C2D1)
                        : (widget.isSunday ? Colors.redAccent : const Color(0xFF64748B))
                ),
              ),
              if (widget.hasEvent)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    widget.eventTitle,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00C2D1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}