// // // // // //
// // // // // //
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // // import 'package:iconsax/iconsax.dart';
// // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // //
// // // // // // import '../Controller/Media_Item_controller.dart';
// // // // // // import '../Controller/Media_Series_controller.dart';
// // // // // // import '../View_model/Create_media_popup.dart';
// // // // // // import '../View_model/Create_media_Series.dart';
// // // // // //
// // // // // // class LibraryPage extends StatefulWidget {
// // // // // //   const LibraryPage({super.key});
// // // // // //
// // // // // //   @override
// // // // // //   State<LibraryPage> createState() => _LibraryPageState();
// // // // // // }
// // // // // //
// // // // // // class _LibraryPageState extends State<LibraryPage> {
// // // // // //   final MediaItemService _itemService = MediaItemService();
// // // // // //   final MediaSeriesService _seriesService = MediaSeriesService();
// // // // // //
// // // // // //   List<dynamic> _mediaItems = [];
// // // // // //   List<dynamic> _mediaSeries = [];
// // // // // //   bool _loading = true;
// // // // // //
// // // // // //   @override
// // // // // //   void initState() {
// // // // // //     super.initState();
// // // // // //     _fetchUserMedia();
// // // // // //   }
// // // // // //
// // // // // //   Future<void> _fetchUserMedia() async {
// // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // //     // final userId = prefs.getString("userId");
// // // // // //     final userId = "68a7f7cd27471122559a1016";
// // // // // //
// // // // // //     if (userId == null) return;
// // // // // //
// // // // // //     try {
// // // // // //       // fetch items
// // // // // //       final items = await _itemService.getMediaItemsByUserOrOrg(userId: userId);
// // // // // //
// // // // // //       // fetch series (filter locally by createdBy)
// // // // // //       final seriesList = await _seriesService.getSeries();
// // // // // //       final userSeries =
// // // // // //       seriesList.where((s) => s["createdBy"] == userId).toList();
// // // // // //
// // // // // //       setState(() {
// // // // // //         _mediaItems = items;
// // // // // //         _mediaSeries = userSeries;
// // // // // //         _loading = false;
// // // // // //       });
// // // // // //     } catch (e) {
// // // // // //       debugPrint("Error fetching media: $e");
// // // // // //       setState(() => _loading = false);
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return _loading
// // // // // //         ? const Center(child: CircularProgressIndicator())
// // // // // //         : SingleChildScrollView(
// // // // // //       child: Padding(
// // // // // //         padding: EdgeInsets.only(
// // // // // //           left: MediaQuery.of(context).size.width * .2,
// // // // // //           right: MediaQuery.of(context).size.width * .1,
// // // // // //           top: MediaQuery.of(context).size.height * .05,
// // // // // //         ),
// // // // // //         child: Column(
// // // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //           children: [
// // // // // //             /// 🔹 Create Media Dropdown
// // // // // //             Row(
// // // // // //               mainAxisAlignment: MainAxisAlignment.end,
// // // // // //               children: [
// // // // // //                 PopupMenuButton<String>(
// // // // // //                   onSelected: (value) {
// // // // // //                     if (value == "item") {
// // // // // //                       showCreateMediaItemDialog(context);
// // // // // //                     } else if (value == "series") {
// // // // // //                       showCreateMediaSeriesDialog(context);
// // // // // //                     }
// // // // // //                   },
// // // // // //                   shape: RoundedRectangleBorder(
// // // // // //                     borderRadius: BorderRadius.circular(12),
// // // // // //                   ),
// // // // // //                   offset: const Offset(0, 50),
// // // // // //                   itemBuilder: (context) => [
// // // // // //                     PopupMenuItem(
// // // // // //                       value: "item",
// // // // // //                       child: Row(
// // // // // //                         children: [
// // // // // //                           const Icon(Iconsax.video,
// // // // // //                               size: 18, color: Colors.purple),
// // // // // //                           const SizedBox(width: 8),
// // // // // //                           Text("Create Media Item",
// // // // // //                               style: GoogleFonts.poppins(fontSize: 14)),
// // // // // //                         ],
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                     PopupMenuItem(
// // // // // //                       value: "series",
// // // // // //                       child: Row(
// // // // // //                         children: [
// // // // // //                           const Icon(Iconsax.video_add,
// // // // // //                               size: 18, color: Colors.purple),
// // // // // //                           const SizedBox(width: 8),
// // // // // //                           Text("Create Media Series",
// // // // // //                               style: GoogleFonts.poppins(fontSize: 14)),
// // // // // //                         ],
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ],
// // // // // //                   child: Container(
// // // // // //                     decoration: BoxDecoration(
// // // // // //                       borderRadius: BorderRadius.circular(10),
// // // // // //                       color: Colors.purple,
// // // // // //                     ),
// // // // // //                     padding: const EdgeInsets.symmetric(
// // // // // //                         horizontal: 16, vertical: 12),
// // // // // //                     child: Row(
// // // // // //                       children: [
// // // // // //                         const Icon(Iconsax.video, color: Colors.white),
// // // // // //                         const SizedBox(width: 8),
// // // // // //                         Text(
// // // // // //                           "Create Media",
// // // // // //                           style: GoogleFonts.poppins(
// // // // // //                             fontWeight: FontWeight.w500,
// // // // // //                             fontSize: 14,
// // // // // //                             color: Colors.white,
// // // // // //                           ),
// // // // // //                         ),
// // // // // //                         const Icon(Icons.keyboard_arrow_down,
// // // // // //                             color: Colors.white),
// // // // // //                       ],
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //
// // // // // //             const SizedBox(height: 20),
// // // // // //
// // // // // //             /// 🔹 Recent Media Items
// // // // // //             Container(
// // // // // //               padding: const EdgeInsets.all(16),
// // // // // //               decoration: BoxDecoration(
// // // // // //                 borderRadius: BorderRadius.circular(20),
// // // // // //                 color: Colors.white,
// // // // // //                 boxShadow: [
// // // // // //                   BoxShadow(
// // // // // //                       color: Colors.black.withOpacity(0.05),
// // // // // //                       blurRadius: 6,
// // // // // //                       offset: const Offset(0, 4))
// // // // // //                 ],
// // // // // //               ),
// // // // // //               child: Column(
// // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //                 children: [
// // // // // //                   Text("Recent Media Items",
// // // // // //                       style: GoogleFonts.poppins(
// // // // // //                           fontWeight: FontWeight.w600, fontSize: 16)),
// // // // // //                   const Divider(),
// // // // // //                   _mediaItems.isEmpty
// // // // // //                       ? const Text("No media items yet.")
// // // // // //                       : Column(
// // // // // //                     children: _mediaItems.take(5).map((item) {
// // // // // //                       return ListTile(
// // // // // //                         leading: const Icon(Iconsax.video),
// // // // // //                         title: Text(item["title"] ?? "Untitled"),
// // // // // //                         subtitle: Text(item["description"] ?? ""),
// // // // // //                       );
// // // // // //                     }).toList(),
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             ),
// // // // // //
// // // // // //             const SizedBox(height: 30),
// // // // // //
// // // // // //             /// 🔹 Recent Media Series
// // // // // //             Container(
// // // // // //               padding: const EdgeInsets.all(16),
// // // // // //               decoration: BoxDecoration(
// // // // // //                 borderRadius: BorderRadius.circular(20),
// // // // // //                 color: Colors.white,
// // // // // //                 boxShadow: [
// // // // // //                   BoxShadow(
// // // // // //                       color: Colors.black.withOpacity(0.05),
// // // // // //                       blurRadius: 6,
// // // // // //                       offset: const Offset(0, 4))
// // // // // //                 ],
// // // // // //               ),
// // // // // //               child: Column(
// // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //                 children: [
// // // // // //                   Text("Recent Media Series",
// // // // // //                       style: GoogleFonts.poppins(
// // // // // //                           fontWeight: FontWeight.w600, fontSize: 16)),
// // // // // //                   const Divider(),
// // // // // //                   _mediaSeries.isEmpty
// // // // // //                       ? const Text("No media series yet.")
// // // // // //                       : Wrap(
// // // // // //                     spacing: 16,
// // // // // //                     runSpacing: 16,
// // // // // //                     children: _mediaSeries.take(5).map((series) {
// // // // // //                       return SizedBox(
// // // // // //                         width: 200,
// // // // // //                         child: Column(
// // // // // //                           crossAxisAlignment:
// // // // // //                           CrossAxisAlignment.start,
// // // // // //                           children: [
// // // // // //                             ClipRRect(
// // // // // //                               borderRadius:
// // // // // //                               BorderRadius.circular(16),
// // // // // //                               child: Image.network(
// // // // // //                                 series["thumbnail"] ??
// // // // // //                                     "https://via.placeholder.com/200",
// // // // // //                                 height: 120,
// // // // // //                                 width: 200,
// // // // // //                                 fit: BoxFit.cover,
// // // // // //                               ),
// // // // // //                             ),
// // // // // //                             const SizedBox(height: 8),
// // // // // //                             Text(
// // // // // //                               series["title"] ?? "Untitled",
// // // // // //                               style: GoogleFonts.poppins(
// // // // // //                                   fontWeight: FontWeight.w500),
// // // // // //                             ),
// // // // // //                           ],
// // // // // //                         ),
// // // // // //                       );
// // // // // //                     }).toList(),
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // //
// // // // //
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // import 'package:iconsax/iconsax.dart';
// // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // //
// // // // // import '../Controller/Media_Item_controller.dart';
// // // // // import '../Controller/Media_Series_controller.dart';
// // // // // import '../View_model/Create_media_popup.dart';
// // // // // import '../View_model/Create_media_Series.dart';
// // // // //
// // // // // class LibraryPage extends StatefulWidget {
// // // // //   const LibraryPage({super.key});
// // // // //
// // // // //   @override
// // // // //   State<LibraryPage> createState() => _LibraryPageState();
// // // // // }
// // // // //
// // // // // class _LibraryPageState extends State<LibraryPage> {
// // // // //   final MediaItemService _itemService = MediaItemService();
// // // // //   final MediaSeriesService _seriesService = MediaSeriesService();
// // // // //
// // // // //   List<dynamic> _mediaItems = [];
// // // // //   List<dynamic> _mediaSeries = [];
// // // // //   bool _loading = true;
// // // // //
// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _fetchUserMedia();
// // // // //   }
// // // // //
// // // // //   Future<void> _fetchUserMedia() async {
// // // // //     final prefs = await SharedPreferences.getInstance();
// // // // //     final userId = prefs.getString("userId") ?? "68a7f7cd27471122559a1016"; // fallback for debug
// // // // //     final orgId = prefs.getString("organizationId");
// // // // //
// // // // //     try {
// // // // //       // 🔹 fetch items with filter
// // // // //       final items = await _itemService.getMediaItemsByUserOrOrg(
// // // // //         userId: userId,
// // // // //         organizationId: orgId,
// // // // //       );
// // // // //
// // // // //       // 🔹 fetch series with filter
// // // // //       final seriesList = await _seriesService.getSeriesByFilter(
// // // // //         userId: userId,
// // // // //         organizationId: orgId,
// // // // //       );
// // // // //
// // // // //       setState(() {
// // // // //         _mediaItems = items;
// // // // //         _mediaSeries = seriesList;
// // // // //         _loading = false;
// // // // //       });
// // // // //     } catch (e) {
// // // // //       debugPrint("❌ Error fetching media: $e");
// // // // //       setState(() => _loading = false);
// // // // //     }
// // // // //   }
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return _loading
// // // // //         ? const Center(child: CircularProgressIndicator())
// // // // //         : SingleChildScrollView(
// // // // //       child: Padding(
// // // // //         padding: EdgeInsets.only(
// // // // //           left: MediaQuery.of(context).size.width * .2,
// // // // //           right: MediaQuery.of(context).size.width * .1,
// // // // //           top: MediaQuery.of(context).size.height * .05,
// // // // //         ),
// // // // //         child: Column(
// // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // //           children: [
// // // // //             /// 🔹 Create Media Dropdown
// // // // //             Padding(
// // // // //               padding: const EdgeInsets.all(12.0),
// // // // //               child: Row(
// // // // //                 mainAxisAlignment: MainAxisAlignment.end,
// // // // //                 children: [
// // // // //                   PopupMenuButton<String>(
// // // // //                     onSelected: (value) {
// // // // //                       if (value == "item") {
// // // // //                         showCreateMediaItemDialog(context);
// // // // //                       } else if (value == "series") {
// // // // //                         showCreateMediaSeriesDialog(context);
// // // // //                       }
// // // // //                     },
// // // // //                     shape: RoundedRectangleBorder(
// // // // //                       borderRadius: BorderRadius.circular(12),
// // // // //                     ),
// // // // //                     offset: const Offset(0, 50),
// // // // //                     itemBuilder: (context) => [
// // // // //                       PopupMenuItem(
// // // // //                         value: "item",
// // // // //                         child: Row(
// // // // //                           children: [
// // // // //                             const Icon(Iconsax.video,
// // // // //                                 size: 18, color: Colors.purple),
// // // // //                             const SizedBox(width: 8),
// // // // //                             Text("Create Media Item",
// // // // //                                 style: GoogleFonts.poppins(fontSize: 14)),
// // // // //                           ],
// // // // //                         ),
// // // // //                       ),
// // // // //                       PopupMenuItem(
// // // // //                         value: "series",
// // // // //                         child: Row(
// // // // //                           children: [
// // // // //                             const Icon(Iconsax.video_add,
// // // // //                                 size: 18, color: Colors.purple),
// // // // //                             const SizedBox(width: 8),
// // // // //                             Text("Create Media Series",
// // // // //                                 style: GoogleFonts.poppins(fontSize: 14)),
// // // // //                           ],
// // // // //                         ),
// // // // //                       ),
// // // // //                     ],
// // // // //                     child: Container(
// // // // //                       decoration: BoxDecoration(
// // // // //                         borderRadius: BorderRadius.circular(10),
// // // // //                         color: Colors.purple,
// // // // //                       ),
// // // // //                       padding: const EdgeInsets.symmetric(
// // // // //                           horizontal: 16, vertical: 12),
// // // // //                       child: Row(
// // // // //                         children: [
// // // // //                           const Icon(Iconsax.video, color: Colors.white),
// // // // //                           const SizedBox(width: 8),
// // // // //                           Text(
// // // // //                             "Create Media",
// // // // //                             style: GoogleFonts.poppins(
// // // // //                               fontWeight: FontWeight.w500,
// // // // //                               fontSize: 14,
// // // // //                               color: Colors.white,
// // // // //                             ),
// // // // //                           ),
// // // // //                           const SizedBox(width: 6),
// // // // //                           const Icon(Icons.keyboard_arrow_down,
// // // // //                               color: Colors.white),
// // // // //                         ],
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //
// // // // //             const SizedBox(height: 30),
// // // // //
// // // // //             // 🔹 Recent Media Items
// // // // //             Container(
// // // // //               width: MediaQuery.of(context).size.width * .8,
// // // // //               padding: const EdgeInsets.all(12),
// // // // //               decoration: BoxDecoration(
// // // // //                 borderRadius: BorderRadius.circular(20),
// // // // //                 color: Colors.white,
// // // // //                 border: Border.all(color: Colors.black12),
// // // // //               ),
// // // // //               child: Column(
// // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                 children: [
// // // // //                   Text("Recent Media Items",
// // // // //                       style: GoogleFonts.poppins(
// // // // //                           fontWeight: FontWeight.w600, fontSize: 16)),
// // // // //                   const Divider(),
// // // // //                   _mediaItems.isEmpty
// // // // //                       ? const Text("No media items yet.")
// // // // //                       : Column(
// // // // //                     children: _mediaItems.take(5).map((item) {
// // // // //                       final String? thumbnailUrl =
// // // // //                       item["thumbnailUrl"];
// // // // //                       final String seriesName =
// // // // //                           item["seriesId"]?["title"] ??
// // // // //                               "No Series";
// // // // //                       final String createdDate =
// // // // //                       item["createdAt"] != null
// // // // //                           ? DateTime.parse(item["createdAt"])
// // // // //                           .toLocal()
// // // // //                           .toString()
// // // // //                           .substring(0, 16)
// // // // //                           : "Unknown Date";
// // // // //
// // // // //                       return ListTile(
// // // // //                         leading: thumbnailUrl != null &&
// // // // //                             thumbnailUrl.isNotEmpty
// // // // //                             ? ClipRRect(
// // // // //                           borderRadius:
// // // // //                           BorderRadius.circular(8),
// // // // //                           child: Image.network(
// // // // //                             thumbnailUrl,
// // // // //                             width: 75,
// // // // //                             height: 200,
// // // // //                             fit: BoxFit.cover,
// // // // //                             errorBuilder: (context, error,
// // // // //                                 stackTrace) =>
// // // // //                             const Icon(Iconsax.video,
// // // // //                                 size: 40,
// // // // //                                 color: Colors.grey),
// // // // //                           ),
// // // // //                         )
// // // // //                             : const Icon(Iconsax.video,
// // // // //                             size: 40, color: Colors.grey),
// // // // //                         title: Text(item["title"] ?? "Untitled"),
// // // // //                         subtitle: Row(
// // // // //                           spacing: 10,
// // // // //                           children: [
// // // // //                             Text("Series: $seriesName",
// // // // //                                 style: GoogleFonts.poppins(
// // // // //                                     fontSize: 12,
// // // // //                                     color: Colors.grey,
// // // // //                                     fontWeight: FontWeight.w600)),
// // // // //                             const Text("--->",
// // // // //                                 style:
// // // // //                                 TextStyle(color: Colors.grey)),
// // // // //                             Text(createdDate,
// // // // //                                 style: GoogleFonts.poppins(
// // // // //                                     fontSize: 12,
// // // // //                                     color: Colors.grey,
// // // // //                                     fontWeight: FontWeight.w600)),
// // // // //                           ],
// // // // //                         ),
// // // // //                       );
// // // // //                     }).toList(),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //
// // // // //             const SizedBox(height: 30),
// // // // //
// // // // //             // 🔹 Recent Media Series
// // // // //             Container(
// // // // //               width: MediaQuery.of(context).size.width * .8,
// // // // //               height: MediaQuery.of(context).size.height *.3,
// // // // //               padding: const EdgeInsets.all(12),
// // // // //               decoration: BoxDecoration(
// // // // //                 borderRadius: BorderRadius.circular(20),
// // // // //                 color: Colors.white,
// // // // //                 border: Border.all(color: Colors.black12),
// // // // //               ),
// // // // //               child: Column(
// // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                 children: [
// // // // //                   Text("Recent Media Series",
// // // // //                       style: GoogleFonts.poppins(
// // // // //                           fontWeight: FontWeight.w600, fontSize: 16)),
// // // // //                   const Divider(),
// // // // //                   _mediaSeries.isEmpty
// // // // //                       ? const Text("No media series yet.")
// // // // //                       : Wrap(
// // // // //                     spacing: 16,
// // // // //                     runSpacing: 16,
// // // // //                     children: _mediaSeries.take(5).map((series) {
// // // // //                       final String createdDate =
// // // // //                       series["createdAt"] != null
// // // // //                           ? DateTime.parse(series["createdAt"])
// // // // //                           .toLocal()
// // // // //                           .toString()
// // // // //                           .substring(0, 16)
// // // // //                           : "Unknown Date";
// // // // //
// // // // //                       return SizedBox(
// // // // //                         width: 200,
// // // // //                         child: Column(
// // // // //                           crossAxisAlignment:
// // // // //                           CrossAxisAlignment.start,
// // // // //                           children: [
// // // // //                             ClipRRect(
// // // // //                               borderRadius:
// // // // //                               BorderRadius.circular(16),
// // // // //                               child: Image.network(
// // // // //                                 series["thumbnail"] ??
// // // // //                                     "https://via.placeholder.com/200",
// // // // //                                 height: 120,
// // // // //                                 width: 200,
// // // // //                                 fit: BoxFit.cover,
// // // // //                               ),
// // // // //                             ),
// // // // //                             const SizedBox(height: 8),
// // // // //                             Text(series["title"] ?? "Untitled",
// // // // //                                 style: GoogleFonts.poppins(
// // // // //                                     fontWeight: FontWeight.w500)),
// // // // //                             Text(createdDate,
// // // // //                                 style: GoogleFonts.poppins(
// // // // //                                     fontSize: 12,
// // // // //                                     color: Colors.grey,
// // // // //                                     fontWeight: FontWeight.w600)),
// // // // //                           ],
// // // // //                         ),
// // // // //                       );
// // // // //                     }).toList(),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // //
// // // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:google_fonts/google_fonts.dart';
// // // // import 'package:iconsax/iconsax.dart';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import '../Controller/Media_Item_controller.dart';
// // // // import '../Controller/Media_Series_controller.dart';
// // // // import '../View_model/Create_media_popup.dart';
// // // // import 'package:ancilmediaadminpanel/View_model/Create_media_Series.dart';
// // // //
// // // // class LibraryPage extends StatefulWidget {
// // // //   const LibraryPage({super.key});
// // // //
// // // //   @override
// // // //   State<LibraryPage> createState() => _LibraryPageState();
// // // // }
// // // //
// // // // class _LibraryPageState extends State<LibraryPage> {
// // // //   final MediaItemService _itemService = MediaItemService();
// // // //   final MediaSeriesService _seriesService = MediaSeriesService();
// // // //
// // // //   List<dynamic> _mediaItems = [];
// // // //   List<dynamic> _mediaSeries = [];
// // // //   bool _loading = true;
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _fetchUserMedia();
// // // //   }
// // // //
// // // //   Future<void> _fetchUserMedia() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     final userId = prefs.getString("userId") ?? "68a7f7cd27471122559a1016"; // fallback for debug
// // // //     final orgId = prefs.getString("organizationId");
// // // //
// // // //     try {
// // // //       // 🔹 fetch items with filter
// // // //       final items = await _itemService.getMediaItemsByUserOrOrg(
// // // //         userId: userId,
// // // //         organizationId: orgId,
// // // //       );
// // // //
// // // //       // 🔹 fetch series with filter
// // // //       final seriesList = await _seriesService.getSeriesByFilter(
// // // //         userId: userId,
// // // //         organizationId: orgId,
// // // //       );
// // // //
// // // //       setState(() {
// // // //         _mediaItems = items;
// // // //         _mediaSeries = seriesList;
// // // //         _loading = false;
// // // //       });
// // // //     } catch (e) {
// // // //       debugPrint("❌ Error fetching media: $e");
// // // //       setState(() => _loading = false);
// // // //     }
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return SingleChildScrollView(
// // // //       child: Padding(
// // // //         padding: EdgeInsets.only(
// // // //           left: MediaQuery.of(context).size.width * .2,
// // // //           right: MediaQuery.of(context).size.width * .1,
// // // //           top: MediaQuery.of(context).size.height * .05,
// // // //         ),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             /// 🔹 Top Row with Dropdown
// // // //             Padding(
// // // //               padding: const EdgeInsets.all(12.0),
// // // //               child: Row(
// // // //                 mainAxisAlignment: MainAxisAlignment.end,
// // // //                 children: [
// // // //                   PopupMenuButton<String>(
// // // //                     onSelected: (value) {
// // // //                       if (value == "item") {
// // // //                         showCreateMediaItemDialog(context);
// // // //                       } else if (value == "series") {
// // // //                         showCreateMediaSeriesDialog(context);
// // // //                       }
// // // //                     },
// // // //                     shape: RoundedRectangleBorder(
// // // //                       borderRadius: BorderRadius.circular(12),
// // // //                     ),
// // // //                     offset: const Offset(0, 50),
// // // //                     itemBuilder: (context) => [
// // // //                       PopupMenuItem(
// // // //                         value: "item",
// // // //                         child: Row(
// // // //                           children: [
// // // //                             const Icon(
// // // //                               Iconsax.video,
// // // //                               size: 18,
// // // //                               color: Colors.purple,
// // // //                             ),
// // // //                             const SizedBox(width: 8),
// // // //                             Text(
// // // //                               "Create Media Item",
// // // //                               style: GoogleFonts.poppins(fontSize: 14),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                       PopupMenuItem(
// // // //                         value: "series",
// // // //                         child: Row(
// // // //                           children: [
// // // //                             const Icon(
// // // //                               Iconsax.video_add,
// // // //                               size: 18,
// // // //                               color: Colors.purple,
// // // //                             ),
// // // //                             const SizedBox(width: 8),
// // // //                             Text(
// // // //                               "Create Media Series",
// // // //                               style: GoogleFonts.poppins(fontSize: 14),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                     child: Container(
// // // //                       decoration: BoxDecoration(
// // // //                         borderRadius: BorderRadius.circular(10),
// // // //                         color: Colors.purple,
// // // //                       ),
// // // //                       padding: const EdgeInsets.symmetric(
// // // //                         horizontal: 16,
// // // //                         vertical: 12,
// // // //                       ),
// // // //                       child: Row(
// // // //                         children: [
// // // //                           const Icon(Iconsax.video, color: Colors.white),
// // // //                           const SizedBox(width: 8),
// // // //                           Text(
// // // //                             "Create Media",
// // // //                             style: GoogleFonts.poppins(
// // // //                               fontWeight: FontWeight.w500,
// // // //                               fontSize: 14,
// // // //                               color: Colors.white,
// // // //                             ),
// // // //                           ),
// // // //                           const SizedBox(width: 6),
// // // //                           const Icon(
// // // //                             Icons.keyboard_arrow_down,
// // // //                             color: Colors.white,
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //
// // // //             // 🔹 Bulk Edit Card
// // // //             Container(
// // // //               padding: const EdgeInsets.all(20),
// // // //               decoration: BoxDecoration(
// // // //                 color: Colors.white,
// // // //                 borderRadius: BorderRadius.circular(16),
// // // //                 border: Border.all(color: Colors.black12),
// // // //                 boxShadow: [
// // // //                   BoxShadow(
// // // //                     color: Colors.black.withOpacity(0.05),
// // // //                     blurRadius: 10,
// // // //                     offset: const Offset(0, 4),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //               child: Row(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   const Icon(Iconsax.information, color: Colors.blue, size: 35),
// // // //                   const SizedBox(width: 16),
// // // //                   Expanded(
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         Text(
// // // //                           "Save time and add tags to your media library in bulk",
// // // //                           style: GoogleFonts.poppins(
// // // //                             fontWeight: FontWeight.w600,
// // // //                             fontSize: 16,
// // // //                           ),
// // // //                         ),
// // // //                         const SizedBox(height: 8),
// // // //                         Text(
// // // //                           "Make the most of your media and get your entire media library tagged with topics,\nscripture, and speakers quickly with Bulk Edit.",
// // // //                           style: GoogleFonts.poppins(
// // // //                             fontWeight: FontWeight.w400,
// // // //                             fontSize: 16,
// // // //                             color: Colors.grey,
// // // //                           ),
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(width: 16),
// // // //                   Row(
// // // //                     children: [
// // // //                       Container(
// // // //                         height: MediaQuery.of(context).size.height * .04,
// // // //                         width: MediaQuery.of(context).size.width * .07,
// // // //                         decoration: BoxDecoration(
// // // //                           borderRadius: BorderRadius.circular(20),
// // // //                           border: Border.all(color: Colors.black12),
// // // //                           color: Colors.white,
// // // //                         ),
// // // //                         child: Center(
// // // //                           child: Text(
// // // //                             "Get started",
// // // //                             style: GoogleFonts.poppins(
// // // //                               fontSize: 16,
// // // //                               fontWeight: FontWeight.w400,
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                       IconButton(
// // // //                         onPressed: () {},
// // // //                         icon: const Icon(Iconsax.close_circle),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //
// // // //             const SizedBox(height: 30),
// // // //
// // // //             // 🔹 Upload Component
// // // //             Container(
// // // //               padding: const EdgeInsets.all(20),
// // // //               decoration: BoxDecoration(
// // // //                 color: Colors.white,
// // // //                 borderRadius: BorderRadius.circular(16),
// // // //                 border: Border.all(color: Colors.black12),
// // // //                 boxShadow: [
// // // //                   BoxShadow(
// // // //                     color: Colors.black.withOpacity(0.05),
// // // //                     blurRadius: 10,
// // // //                     offset: const Offset(0, 4),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //               child: Row(
// // // //                 children: [
// // // //                   const Icon(Iconsax.add_circle, color: Colors.green, size: 28),
// // // //                   const SizedBox(width: 16),
// // // //                   Expanded(
// // // //                     child: Text(
// // // //                       "Upload a video or audio file to create a Media item",
// // // //                       style: GoogleFonts.poppins(
// // // //                         fontSize: 16,
// // // //                         fontWeight: FontWeight.w500,
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                   ElevatedButton(
// // // //                     onPressed: () {
// // // //                       // TODO: Add file picker logic here
// // // //                     },
// // // //                     style: ElevatedButton.styleFrom(
// // // //                       backgroundColor: Colors.blue,
// // // //                       shape: RoundedRectangleBorder(
// // // //                         borderRadius: BorderRadius.circular(12),
// // // //                       ),
// // // //                     ),
// // // //                     child: Text(
// // // //                       "Upload",
// // // //                       style: GoogleFonts.poppins(
// // // //                         fontSize: 14,
// // // //                         fontWeight: FontWeight.w500,
// // // //                         color: Colors.white,
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //
// // // //             const SizedBox(height: 30),
// // // //
// // // //             // 🔹 Recent Media Items
// // // //             Container(
// // // //               height: MediaQuery.of(context).size.height * .3,
// // // //               width: MediaQuery.of(context).size.width * .8,
// // // //               decoration: BoxDecoration(
// // // //                 borderRadius: BorderRadius.circular(20),
// // // //                 color: Colors.white,
// // // //               ),
// // // //               child: Padding(
// // // //                 padding: const EdgeInsets.all(12),
// // // //                 child: Column(
// // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // //                   children: [
// // // //                     Text(
// // // //                       "Recent Media Items",
// // // //                       style: GoogleFonts.poppins(
// // // //                         fontWeight: FontWeight.w600,
// // // //                         fontSize: 16,
// // // //                       ),
// // // //                     ),
// // // //                     SizedBox(height: MediaQuery.of(context).size.height * .005),
// // // //                     const Divider(),
// // // //                     _mediaItems.isEmpty
// // // //                         ? const Text("No media items yet.")
// // // //                         : Column(
// // // //                       children: _mediaItems.take(5).map((item) {
// // // //                         final String? thumbnailUrl = item["thumbnailUrl"];
// // // //                         final String seriesName = item["seriesId"]?["title"] ?? "No Series";
// // // //                         final String createdDate = item["createdAt"] != null
// // // //                             ? DateTime.parse(item["createdAt"])
// // // //                             .toLocal()
// // // //                             .toString()
// // // //                             .substring(0, 16) // yyyy-MM-dd HH:mm
// // // //                             : "Unknown Date";
// // // //
// // // //                         return ListTile(
// // // //                           leading: thumbnailUrl != null && thumbnailUrl.isNotEmpty
// // // //                               ? ClipRRect(
// // // //                             borderRadius: BorderRadius.circular(8),
// // // //                             child: Image.network(
// // // //                               thumbnailUrl,
// // // //                               width: 75,
// // // //                               height: 200,
// // // //                               fit: BoxFit.cover,
// // // //                               errorBuilder: (context, error, stackTrace) =>
// // // //                               const Icon(Iconsax.video, size: 40, color: Colors.grey),
// // // //                             ),
// // // //                           )
// // // //                               : const Icon(Iconsax.video, size: 40, color: Colors.grey),
// // // //                           title: Text(item["title"] ?? "Untitled"),
// // // //                           subtitle: Column(
// // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // //                             children: [
// // // //                               if (item["description"] != null &&
// // // //                                   item["description"].toString().isNotEmpty)
// // // //                                 Text(item["description"]),
// // // //                               const SizedBox(height: 4),
// // // //                               Row(
// // // //                                 spacing: 10,
// // // //                                 children: [
// // // //                                   Text(
// // // //                                     "Series: $seriesName",
// // // //                                     overflow: TextOverflow.ellipsis,
// // // //                                     style:  GoogleFonts.poppins(fontSize: 12, color: Colors.grey,fontWeight: FontWeight.w600),
// // // //                                   ),
// // // //                                   Text('--->',style: GoogleFonts.poppins(
// // // //                                       color: Colors.grey
// // // //                                   ),),
// // // //                                   Text(
// // // //                                     createdDate,
// // // //                                     style:  GoogleFonts.poppins(fontSize: 12, color: Colors.grey,fontWeight: FontWeight.w600),
// // // //                                   ),
// // // //                                 ],
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                         );
// // // //                       }).toList(),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //
// // // //             const SizedBox(height: 30),
// // // //
// // // //             // 🔹 Recent Media Series
// // // //             Container(
// // // //               width: MediaQuery.of(context).size.width * .8,
// // // //               decoration: BoxDecoration(
// // // //                 borderRadius: BorderRadius.circular(20),
// // // //                 color: Colors.white,
// // // //               ),
// // // //               child: Padding(
// // // //                 padding: const EdgeInsets.all(12),
// // // //                 child: Column(
// // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // //                   children: [
// // // //                     Text(
// // // //                       "Recent Media Series",
// // // //                       style: GoogleFonts.poppins(
// // // //                         fontWeight: FontWeight.w600,
// // // //                         fontSize: 16,
// // // //                       ),
// // // //                     ),
// // // //                     SizedBox(height: MediaQuery.of(context).size.height * .01),
// // // //                     // Wrap(
// // // //                     //   spacing: 16,
// // // //                     //   runSpacing: 16,
// // // //                     //   children: List.generate(5, (index) {
// // // //                     //     return SizedBox(
// // // //                     //       width: 200,
// // // //                     //       child: Column(
// // // //                     //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     //         children: [
// // // //                     //           ClipRRect(
// // // //                     //             borderRadius: BorderRadius.circular(16),
// // // //                     //             child: Image.network(
// // // //                     //               'https://images.unsplash.com/photo-1657632843433-e6a8b7451ac6?q=80&w=712&auto=format&fit=crop&ixlib=rb-4.1.0',
// // // //                     //               height: 200,
// // // //                     //               width: 200,
// // // //                     //               fit: BoxFit.cover,
// // // //                     //             ),
// // // //                     //           ),
// // // //                     //           const SizedBox(height: 8),
// // // //                     //           Row(
// // // //                     //             mainAxisAlignment:
// // // //                     //                 MainAxisAlignment.spaceBetween,
// // // //                     //             children: [
// // // //                     //               Expanded(
// // // //                     //                 child: Text(
// // // //                     //                   "Redhill sermons",
// // // //                     //                   style: GoogleFonts.poppins(
// // // //                     //                     fontSize: 14,
// // // //                     //                     fontWeight: FontWeight.w400,
// // // //                     //                     color: Colors.grey,
// // // //                     //                   ),
// // // //                     //                   overflow: TextOverflow.ellipsis,
// // // //                     //                 ),
// // // //                     //               ),
// // // //                     //               PopupMenuButton<String>(
// // // //                     //                 icon: const Icon(
// // // //                     //                   Iconsax.more,
// // // //                     //                   color: Colors.grey,
// // // //                     //                 ),
// // // //                     //                 onSelected: (value) {
// // // //                     //                   if (value == "add") {
// // // //                     //                     debugPrint("Add to List tapped");
// // // //                     //                   } else if (value == "remove") {
// // // //                     //                     debugPrint("Remove tapped");
// // // //                     //                   }
// // // //                     //                 },
// // // //                     //                 itemBuilder: (context) => [
// // // //                     //                   const PopupMenuItem(
// // // //                     //                     value: "add",
// // // //                     //                     child: Text("Add to List"),
// // // //                     //                   ),
// // // //                     //                   const PopupMenuItem(
// // // //                     //                     value: "remove",
// // // //                     //                     child: Text("Remove"),
// // // //                     //                   ),
// // // //                     //                 ],
// // // //                     //               ),
// // // //                     //             ],
// // // //                     //           ),
// // // //                     //         ],
// // // //                     //       ),
// // // //                     //     );
// // // //                     //   }),
// // // //                     // ),
// // // //                     _mediaSeries.isEmpty
// // // //                         ? const Text("No media series yet.")
// // // //                         : Wrap(
// // // //                       spacing: 16,
// // // //                       runSpacing: 16,
// // // //                       children: _mediaSeries.take(5).map((series) {
// // // //                         final String createdDate =
// // // //                         series["createdAt"] != null
// // // //                             ? DateTime.parse(series["createdAt"])
// // // //                             .toLocal()
// // // //                             .toString()
// // // //                             .substring(0, 16)
// // // //                             : "Unknown Date";
// // // //
// // // //                         return SizedBox(
// // // //                           width: 200,
// // // //                           child: Column(
// // // //                             crossAxisAlignment:
// // // //                             CrossAxisAlignment.start,
// // // //                             children: [
// // // //                               ClipRRect(
// // // //                                 borderRadius:
// // // //                                 BorderRadius.circular(16),
// // // //                                 child: Image.network(
// // // //                                   series["thumbnail"] ??
// // // //                                       "https://via.placeholder.com/200",
// // // //                                   height: 120,
// // // //                                   width: 200,
// // // //                                   fit: BoxFit.cover,
// // // //                                 ),
// // // //                               ),
// // // //                               const SizedBox(height: 8),
// // // //                               Text(series["title"] ?? "Untitled",
// // // //                                   style: GoogleFonts.poppins(
// // // //                                       fontWeight: FontWeight.w500)),
// // // //                               Text(createdDate,
// // // //                                   style: GoogleFonts.poppins(
// // // //                                       fontSize: 12,
// // // //                                       color: Colors.grey,
// // // //                                       fontWeight: FontWeight.w600)),
// // // //                             ],
// // // //                           ),
// // // //                         );
// // // //                       }).toList(),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             Container(
// // // //               height: MediaQuery.of(context).size.height *.3,
// // // //             )
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // //
// // //
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:google_fonts/google_fonts.dart';
// // // // // import 'package:iconsax/iconsax.dart';
// // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // import '../Controller/Media_Item_controller.dart';
// // // // // import '../Controller/Media_Series_controller.dart';
// // // // // import '../View_model/Create_media_popup.dart';
// // // // // import 'package:ancilmediaadminpanel/View_model/Create_media_Series.dart';
// // // // //
// // // // // class LibraryPage extends StatefulWidget {
// // // // //   const LibraryPage({super.key});
// // // // //
// // // // //   @override
// // // // //   State<LibraryPage> createState() => _LibraryPageState();
// // // // // }
// // // // //
// // // // // class _LibraryPageState extends State<LibraryPage> {
// // // // //   final MediaItemService _itemService = MediaItemService();
// // // // //   final MediaSeriesService _seriesService = MediaSeriesService();
// // // // //
// // // // //   List<dynamic> _mediaItems = [];
// // // // //   List<dynamic> _mediaSeries = [];
// // // // //   bool _loading = true;
// // // // //
// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _fetchUserMedia();
// // // // //   }
// // // // //
// // // // //   Future<void> _fetchUserMedia() async {
// // // // //     final prefs = await SharedPreferences.getInstance();
// // // // //     final userId = prefs.getString("userId") ?? "68a7f7cd27471122559a1016"; // fallback for debug
// // // // //     final orgId = prefs.getString("organizationId");
// // // // //
// // // // //     try {
// // // // //       // 🔹 fetch items with filter
// // // // //       final items = await _itemService.getMediaItemsByUserOrOrg(
// // // // //         userId: userId,
// // // // //         organizationId: orgId,
// // // // //       );
// // // // //
// // // // //       // 🔹 fetch series with filter
// // // // //       final seriesList = await _seriesService.getSeriesByFilter(
// // // // //         userId: userId,
// // // // //         organizationId: orgId,
// // // // //       );
// // // // //
// // // // //       setState(() {
// // // // //         _mediaItems = items;
// // // // //         _mediaSeries = seriesList;
// // // // //         _loading = false;
// // // // //       });
// // // // //     } catch (e) {
// // // // //       debugPrint("❌ Error fetching media: $e");
// // // // //       setState(() => _loading = false);
// // // // //     }
// // // // //   }
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return SingleChildScrollView(
// // // // //       child: Padding(
// // // // //         padding: EdgeInsets.only(
// // // // //           left: MediaQuery.of(context).size.width * .2,
// // // // //           right: MediaQuery.of(context).size.width * .1,
// // // // //           top: MediaQuery.of(context).size.height * .05,
// // // // //         ),
// // // // //         child: Column(
// // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // //           children: [
// // // // //             /// 🔹 Top Row with Dropdown
// // // // //             Padding(
// // // // //               padding: const EdgeInsets.all(12.0),
// // // // //               child: Row(
// // // // //                 mainAxisAlignment: MainAxisAlignment.end,
// // // // //                 children: [
// // // // //                   PopupMenuButton<String>(
// // // // //                     onSelected: (value) {
// // // // //                       if (value == "item") {
// // // // //                         showCreateMediaItemDialog(context);
// // // // //                       } else if (value == "series") {
// // // // //                         showCreateMediaSeriesDialog(context);
// // // // //                       }
// // // // //                     },
// // // // //                     shape: RoundedRectangleBorder(
// // // // //                       borderRadius: BorderRadius.circular(12),
// // // // //                     ),
// // // // //                     offset: const Offset(0, 50),
// // // // //                     itemBuilder: (context) => [
// // // // //                       PopupMenuItem(
// // // // //                         value: "item",
// // // // //                         child: Row(
// // // // //                           children: [
// // // // //                             const Icon(
// // // // //                               Iconsax.video,
// // // // //                               size: 18,
// // // // //                               color: Colors.purple,
// // // // //                             ),
// // // // //                             const SizedBox(width: 8),
// // // // //                             Text(
// // // // //                               "Create Media Item",
// // // // //                               style: GoogleFonts.poppins(fontSize: 14),
// // // // //                             ),
// // // // //                           ],
// // // // //                         ),
// // // // //                       ),
// // // // //                       PopupMenuItem(
// // // // //                         value: "series",
// // // // //                         child: Row(
// // // // //                           children: [
// // // // //                             const Icon(
// // // // //                               Iconsax.video_add,
// // // // //                               size: 18,
// // // // //                               color: Colors.purple,
// // // // //                             ),
// // // // //                             const SizedBox(width: 8),
// // // // //                             Text(
// // // // //                               "Create Media Series",
// // // // //                               style: GoogleFonts.poppins(fontSize: 14),
// // // // //                             ),
// // // // //                           ],
// // // // //                         ),
// // // // //                       ),
// // // // //                     ],
// // // // //                     child: Container(
// // // // //                       decoration: BoxDecoration(
// // // // //                         borderRadius: BorderRadius.circular(10),
// // // // //                         color: Colors.purple,
// // // // //                       ),
// // // // //                       padding: const EdgeInsets.symmetric(
// // // // //                         horizontal: 16,
// // // // //                         vertical: 12,
// // // // //                       ),
// // // // //                       child: Row(
// // // // //                         children: [
// // // // //                           const Icon(Iconsax.video, color: Colors.white),
// // // // //                           const SizedBox(width: 8),
// // // // //                           Text(
// // // // //                             "Create Media",
// // // // //                             style: GoogleFonts.poppins(
// // // // //                               fontWeight: FontWeight.w500,
// // // // //                               fontSize: 14,
// // // // //                               color: Colors.white,
// // // // //                             ),
// // // // //                           ),
// // // // //                           const SizedBox(width: 6),
// // // // //                           const Icon(
// // // // //                             Icons.keyboard_arrow_down,
// // // // //                             color: Colors.white,
// // // // //                           ),
// // // // //                         ],
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //
// // // // //             // 🔹 Bulk Edit Card
// // // // //             Container(
// // // // //               padding: const EdgeInsets.all(20),
// // // // //               decoration: BoxDecoration(
// // // // //                 color: Colors.white,
// // // // //                 borderRadius: BorderRadius.circular(16),
// // // // //                 border: Border.all(color: Colors.black12),
// // // // //                 boxShadow: [
// // // // //                   BoxShadow(
// // // // //                     color: Colors.black.withOpacity(0.05),
// // // // //                     blurRadius: 10,
// // // // //                     offset: const Offset(0, 4),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //               child: Row(
// // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                 children: [
// // // // //                   const Icon(Iconsax.information, color: Colors.blue, size: 35),
// // // // //                   const SizedBox(width: 16),
// // // // //                   Expanded(
// // // // //                     child: Column(
// // // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                       children: [
// // // // //                         Text(
// // // // //                           "Save time and add tags to your media library in bulk",
// // // // //                           style: GoogleFonts.poppins(
// // // // //                             fontWeight: FontWeight.w600,
// // // // //                             fontSize: 16,
// // // // //                           ),
// // // // //                         ),
// // // // //                         const SizedBox(height: 8),
// // // // //                         Text(
// // // // //                           "Make the most of your media and get your entire media library tagged with topics,\nscripture, and speakers quickly with Bulk Edit.",
// // // // //                           style: GoogleFonts.poppins(
// // // // //                             fontWeight: FontWeight.w400,
// // // // //                             fontSize: 16,
// // // // //                             color: Colors.grey,
// // // // //                           ),
// // // // //                         ),
// // // // //                       ],
// // // // //                     ),
// // // // //                   ),
// // // // //                   const SizedBox(width: 16),
// // // // //                   Row(
// // // // //                     children: [
// // // // //                       Container(
// // // // //                         height: MediaQuery.of(context).size.height * .04,
// // // // //                         width: MediaQuery.of(context).size.width * .07,
// // // // //                         decoration: BoxDecoration(
// // // // //                           borderRadius: BorderRadius.circular(20),
// // // // //                           border: Border.all(color: Colors.black12),
// // // // //                           color: Colors.white,
// // // // //                         ),
// // // // //                         child: Center(
// // // // //                           child: Text(
// // // // //                             "Get started",
// // // // //                             style: GoogleFonts.poppins(
// // // // //                               fontSize: 16,
// // // // //                               fontWeight: FontWeight.w400,
// // // // //                             ),
// // // // //                           ),
// // // // //                         ),
// // // // //                       ),
// // // // //                       IconButton(
// // // // //                         onPressed: () {},
// // // // //                         icon: const Icon(Iconsax.close_circle),
// // // // //                       ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //
// // // // //             const SizedBox(height: 30),
// // // // //
// // // // //             // 🔹 Upload Component
// // // // //             Container(
// // // // //               padding: const EdgeInsets.all(20),
// // // // //               decoration: BoxDecoration(
// // // // //                 color: Colors.white,
// // // // //                 borderRadius: BorderRadius.circular(16),
// // // // //                 border: Border.all(color: Colors.black12),
// // // // //                 boxShadow: [
// // // // //                   BoxShadow(
// // // // //                     color: Colors.black.withOpacity(0.05),
// // // // //                     blurRadius: 10,
// // // // //                     offset: const Offset(0, 4),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //               child: Row(
// // // // //                 children: [
// // // // //                   const Icon(Iconsax.add_circle, color: Colors.green, size: 28),
// // // // //                   const SizedBox(width: 16),
// // // // //                   Expanded(
// // // // //                     child: Text(
// // // // //                       "Upload a video or audio file to create a Media item",
// // // // //                       style: GoogleFonts.poppins(
// // // // //                         fontSize: 16,
// // // // //                         fontWeight: FontWeight.w500,
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                   ElevatedButton(
// // // // //                     onPressed: () {
// // // // //                       // TODO: Add file picker logic here
// // // // //                     },
// // // // //                     style: ElevatedButton.styleFrom(
// // // // //                       backgroundColor: Colors.blue,
// // // // //                       shape: RoundedRectangleBorder(
// // // // //                         borderRadius: BorderRadius.circular(12),
// // // // //                       ),
// // // // //                     ),
// // // // //                     child: Text(
// // // // //                       "Upload",
// // // // //                       style: GoogleFonts.poppins(
// // // // //                         fontSize: 14,
// // // // //                         fontWeight: FontWeight.w500,
// // // // //                         color: Colors.white,
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //
// // // // //             const SizedBox(height: 30),
// // // // //
// // // // //             // 🔹 Recent Media Items
// // // // //             Container(
// // // // //               height: MediaQuery.of(context).size.height * .3,
// // // // //               width: MediaQuery.of(context).size.width * .8,
// // // // //               decoration: BoxDecoration(
// // // // //                 borderRadius: BorderRadius.circular(20),
// // // // //                 color: Colors.white,
// // // // //               ),
// // // // //               child: Padding(
// // // // //                 padding: const EdgeInsets.all(12),
// // // // //                 child: Column(
// // // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                   children: [
// // // // //                     Text(
// // // // //                       "Recent Media Items",
// // // // //                       style: GoogleFonts.poppins(
// // // // //                         fontWeight: FontWeight.w600,
// // // // //                         fontSize: 16,
// // // // //                       ),
// // // // //                     ),
// // // // //                     SizedBox(height: MediaQuery.of(context).size.height * .005),
// // // // //                     const Divider(),
// // // // //                     _mediaItems.isEmpty
// // // // //                         ? const Text("No media items yet.")
// // // // //                         : Column(
// // // // //                       children: _mediaItems.take(5).map((item) {
// // // // //                         final String? thumbnailUrl = item["thumbnailUrl"];
// // // // //                         final String seriesName = item["seriesId"]?["title"] ?? "No Series";
// // // // //                         final String createdDate = item["createdAt"] != null
// // // // //                             ? DateTime.parse(item["createdAt"])
// // // // //                             .toLocal()
// // // // //                             .toString()
// // // // //                             .substring(0, 16) // yyyy-MM-dd HH:mm
// // // // //                             : "Unknown Date";
// // // // //
// // // // //                         return ListTile(
// // // // //                           leading: thumbnailUrl != null && thumbnailUrl.isNotEmpty
// // // // //                               ? ClipRRect(
// // // // //                             borderRadius: BorderRadius.circular(8),
// // // // //                             child: Image.network(
// // // // //                               thumbnailUrl,
// // // // //                               width: 75,
// // // // //                               height: 200,
// // // // //                               fit: BoxFit.cover,
// // // // //                               errorBuilder: (context, error, stackTrace) =>
// // // // //                               const Icon(Iconsax.video, size: 40, color: Colors.grey),
// // // // //                             ),
// // // // //                           )
// // // // //                               : const Icon(Iconsax.video, size: 40, color: Colors.grey),
// // // // //                           title: Text(item["title"] ?? "Untitled"),
// // // // //                           subtitle: Column(
// // // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                             children: [
// // // // //                               if (item["description"] != null &&
// // // // //                                   item["description"].toString().isNotEmpty)
// // // // //                                 Text(item["description"]),
// // // // //                               const SizedBox(height: 4),
// // // // //                               Row(
// // // // //                                 spacing: 10,
// // // // //                                 children: [
// // // // //                                   Text(
// // // // //                                     "Series: $seriesName",
// // // // //                                     overflow: TextOverflow.ellipsis,
// // // // //                                     style:  GoogleFonts.poppins(fontSize: 12, color: Colors.grey,fontWeight: FontWeight.w600),
// // // // //                                   ),
// // // // //                                   Text('--->',style: GoogleFonts.poppins(
// // // // //                                     color: Colors.grey
// // // // //                                   ),),
// // // // //                                   Text(
// // // // //                                     createdDate,
// // // // //                                     style:  GoogleFonts.poppins(fontSize: 12, color: Colors.grey,fontWeight: FontWeight.w600),
// // // // //                                   ),
// // // // //                                 ],
// // // // //                               ),
// // // // //                               Divider()
// // // // //                             ],
// // // // //                           ),
// // // // //                         );
// // // // //                       }).toList(),
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //
// // // // //             const SizedBox(height: 30),
// // // // //
// // // // //             // 🔹 Recent Media Series
// // // // //             Container(
// // // // //               width: MediaQuery.of(context).size.width * .8,
// // // // //               decoration: BoxDecoration(
// // // // //                 borderRadius: BorderRadius.circular(20),
// // // // //                 color: Colors.white,
// // // // //               ),
// // // // //               child: Padding(
// // // // //                 padding: const EdgeInsets.all(12),
// // // // //                 child: Column(
// // // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                   children: [
// // // // //                     Text(
// // // // //                       "Recent Media Series",
// // // // //                       style: GoogleFonts.poppins(
// // // // //                         fontWeight: FontWeight.w600,
// // // // //                         fontSize: 16,
// // // // //                       ),
// // // // //                     ),
// // // // //                     SizedBox(height: MediaQuery.of(context).size.height * .01),
// // // // //                     // Wrap(
// // // // //                     //   spacing: 16,
// // // // //                     //   runSpacing: 16,
// // // // //                     //   children: List.generate(5, (index) {
// // // // //                     //     return SizedBox(
// // // // //                     //       width: 200,
// // // // //                     //       child: Column(
// // // // //                     //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                     //         children: [
// // // // //                     //           ClipRRect(
// // // // //                     //             borderRadius: BorderRadius.circular(16),
// // // // //                     //             child: Image.network(
// // // // //                     //               'https://images.unsplash.com/photo-1657632843433-e6a8b7451ac6?q=80&w=712&auto=format&fit=crop&ixlib=rb-4.1.0',
// // // // //                     //               height: 200,
// // // // //                     //               width: 200,
// // // // //                     //               fit: BoxFit.cover,
// // // // //                     //             ),
// // // // //                     //           ),
// // // // //                     //           const SizedBox(height: 8),
// // // // //                     //           Row(
// // // // //                     //             mainAxisAlignment:
// // // // //                     //                 MainAxisAlignment.spaceBetween,
// // // // //                     //             children: [
// // // // //                     //               Expanded(
// // // // //                     //                 child: Text(
// // // // //                     //                   "Redhill sermons",
// // // // //                     //                   style: GoogleFonts.poppins(
// // // // //                     //                     fontSize: 14,
// // // // //                     //                     fontWeight: FontWeight.w400,
// // // // //                     //                     color: Colors.grey,
// // // // //                     //                   ),
// // // // //                     //                   overflow: TextOverflow.ellipsis,
// // // // //                     //                 ),
// // // // //                     //               ),
// // // // //                     //               PopupMenuButton<String>(
// // // // //                     //                 icon: const Icon(
// // // // //                     //                   Iconsax.more,
// // // // //                     //                   color: Colors.grey,
// // // // //                     //                 ),
// // // // //                     //                 onSelected: (value) {
// // // // //                     //                   if (value == "add") {
// // // // //                     //                     debugPrint("Add to List tapped");
// // // // //                     //                   } else if (value == "remove") {
// // // // //                     //                     debugPrint("Remove tapped");
// // // // //                     //                   }
// // // // //                     //                 },
// // // // //                     //                 itemBuilder: (context) => [
// // // // //                     //                   const PopupMenuItem(
// // // // //                     //                     value: "add",
// // // // //                     //                     child: Text("Add to List"),
// // // // //                     //                   ),
// // // // //                     //                   const PopupMenuItem(
// // // // //                     //                     value: "remove",
// // // // //                     //                     child: Text("Remove"),
// // // // //                     //                   ),
// // // // //                     //                 ],
// // // // //                     //               ),
// // // // //                     //             ],
// // // // //                     //           ),
// // // // //                     //         ],
// // // // //                     //       ),
// // // // //                     //     );
// // // // //                     //   }),
// // // // //                     // ),
// // // // //                     _mediaSeries.isEmpty
// // // // //                         ? const Text("No media series yet.")
// // // // //                         : Wrap(
// // // // //                       spacing: 16,
// // // // //                       runSpacing: 16,
// // // // //                       children: _mediaSeries.take(5).map((series) {
// // // // //                         final String createdDate =
// // // // //                         series["createdAt"] != null
// // // // //                             ? DateTime.parse(series["createdAt"])
// // // // //                             .toLocal()
// // // // //                             .toString()
// // // // //                             .substring(0, 16)
// // // // //                             : "Unknown Date";
// // // // //
// // // // //                         return SizedBox(
// // // // //                           width: 200,
// // // // //                           child: Column(
// // // // //                             crossAxisAlignment:
// // // // //                             CrossAxisAlignment.start,
// // // // //                             children: [
// // // // //                               ClipRRect(
// // // // //                                 borderRadius:
// // // // //                                 BorderRadius.circular(16),
// // // // //                                 child: Image.network(
// // // // //                                   series["thumbnail"] ??
// // // // //                                       "https://via.placeholder.com/200",
// // // // //                                   height: 120,
// // // // //                                   width: 200,
// // // // //                                   fit: BoxFit.cover,
// // // // //                                 ),
// // // // //                               ),
// // // // //                               const SizedBox(height: 8),
// // // // //                               Row(
// // // // //                                 children: [
// // // // //                                   Expanded(
// // // // //                                     child: Text(series["title"] ?? "Untitled",
// // // // //                                         style: GoogleFonts.poppins(
// // // // //                                             fontWeight: FontWeight.w500)),
// // // // //                                   ),
// // // // //                                   PopupMenuButton<String>(
// // // // //                                     icon: const Icon(
// // // // //                                       Iconsax.more,
// // // // //                                       color: Colors.grey,
// // // // //                                     ),
// // // // //                                     onSelected: (value) {
// // // // //                                       if (value == "add") {
// // // // //                                         debugPrint("Add to List tapped");
// // // // //                                       } else if (value == "remove") {
// // // // //                                         debugPrint("Remove tapped");
// // // // //                                       }
// // // // //                                     },
// // // // //                                     itemBuilder: (context) => [
// // // // //                                       const PopupMenuItem(
// // // // //                                         value: "add",
// // // // //                                         child: Text("Add to List"),
// // // // //                                       ),
// // // // //                                       const PopupMenuItem(
// // // // //                                         value: "remove",
// // // // //                                         child: Text("Remove"),
// // // // //                                       ),
// // // // //                                     ],
// // // // //                                   ),
// // // // //                                 ],
// // // // //                               ),
// // // // //                             ],
// // // // //                           ),
// // // // //                         );
// // // // //                       }).toList(),
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //             Container(
// // // // //               height: MediaQuery.of(context).size.height * .3,
// // // // //             )
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // //
// // // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:google_fonts/google_fonts.dart';
// // // // import 'package:iconsax/iconsax.dart';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import '../Controller/Media_Item_controller.dart';
// // // // import '../Controller/Media_Series_controller.dart';
// // // // import '../View_model/Create_media_popup.dart';
// // // // import 'package:ancilmediaadminpanel/View_model/Create_media_Series.dart';
// // // //
// // // // class LibraryPage extends StatefulWidget {
// // // //   const LibraryPage({super.key});
// // // //
// // // //   @override
// // // //   State<LibraryPage> createState() => _LibraryPageState();
// // // // }
// // // //
// // // // class _LibraryPageState extends State<LibraryPage> {
// // // //   final MediaItemService _itemService = MediaItemService();
// // // //   final MediaSeriesService _seriesService = MediaSeriesService();
// // // //
// // // //   List<dynamic> _mediaItems = [];
// // // //   List<dynamic> _mediaSeries = [];
// // // //   bool _loading = true;
// // // //
// // // //   String? userId;
// // // //   String? orgId;
// // // //   String? roleId;
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _fetchUserMedia();
// // // //     _localstorage();
// // // //   }
// // // //
// // // //   Future<void> _localstorage() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //
// // // //     final userId = prefs.getString("userId");
// // // //     final orgId = prefs.getString("organizationId");
// // // //     final roleId = prefs.getString("roleId");
// // // //     print("🔹 LocalStorage loaded: userId=$userId, orgId=$orgId, roleId=$roleId");
// // // //
// // // //   }
// // // //
// // // //   Future<void> _fetchUserMedia() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     final userId = prefs.getString("userId"); // fallback for debug
// // // //     final orgId = prefs.getString("organizationId");
// // // //
// // // //     try {
// // // //       // 🔹 fetch items with filter
// // // //       final items = await _itemService.getMediaItemsByUserOrOrg(
// // // //         userId: userId,
// // // //         organizationId: orgId,
// // // //       );
// // // //
// // // //       // 🔹 fetch series with filter
// // // //       final seriesList = await _seriesService.getSeriesByFilter(
// // // //         userId: userId,
// // // //         organizationId: orgId,
// // // //       );
// // // //
// // // //       setState(() {
// // // //         _mediaItems = items;
// // // //         _mediaSeries = seriesList;
// // // //         _loading = false;
// // // //       });
// // // //     } catch (e) {
// // // //       debugPrint("❌ Error fetching media: $e");
// // // //       setState(() => _loading = false);
// // // //     }
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return _loading
// // // //         ? const Center(
// // // //       child: CircularProgressIndicator(
// // // //         color: Colors.purple,
// // // //       ),
// // // //     )
// // // //         : SingleChildScrollView(
// // // //       child: Padding(
// // // //         padding: EdgeInsets.only(
// // // //           left: MediaQuery.of(context).size.width * .1,
// // // //           right: MediaQuery.of(context).size.width * .1,
// // // //           top: MediaQuery.of(context).size.height * .05,
// // // //         ),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             /// 🔹 Top Row with Dropdown
// // // //             Padding(
// // // //               padding: const EdgeInsets.all(12.0),
// // // //               child: Row(
// // // //                 mainAxisAlignment: MainAxisAlignment.end,
// // // //                 children: [
// // // //                   PopupMenuButton<String>(
// // // //                     onSelected: (value) {
// // // //                       if (value == "item") {
// // // //                         showCreateMediaItemDialog(context,_itemService,_seriesService);
// // // //                       } else if (value == "series") {
// // // //                         showCreateMediaSeriesDialog(context,_seriesService);
// // // //                       }
// // // //                     },
// // // //                     shape: RoundedRectangleBorder(
// // // //                       borderRadius: BorderRadius.circular(12),
// // // //                     ),
// // // //                     offset: const Offset(0, 50),
// // // //                     itemBuilder: (context) => [
// // // //                       PopupMenuItem(
// // // //                         value: "item",
// // // //                         child: Row(
// // // //                           children: [
// // // //                             const Icon(
// // // //                               Iconsax.video,
// // // //                               size: 18,
// // // //                               color: Colors.purple,
// // // //                             ),
// // // //                             const SizedBox(width: 8),
// // // //                             Text(
// // // //                               "Create Media Item",
// // // //                               style: GoogleFonts.poppins(fontSize: 14),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                       PopupMenuItem(
// // // //                         value: "series",
// // // //                         child: Row(
// // // //                           children: [
// // // //                             const Icon(
// // // //                               Iconsax.video_add,
// // // //                               size: 18,
// // // //                               color: Colors.purple,
// // // //                             ),
// // // //                             const SizedBox(width: 8),
// // // //                             Text(
// // // //                               "Create Media Series",
// // // //                               style: GoogleFonts.poppins(fontSize: 14),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                     child: Container(
// // // //                       decoration: BoxDecoration(
// // // //                         borderRadius: BorderRadius.circular(10),
// // // //                         color: Colors.purple,
// // // //                       ),
// // // //                       padding: const EdgeInsets.symmetric(
// // // //                         horizontal: 16,
// // // //                         vertical: 12,
// // // //                       ),
// // // //                       child: Row(
// // // //                         children: [
// // // //                           const Icon(Iconsax.video, color: Colors.white),
// // // //                           const SizedBox(width: 8),
// // // //                           Text(
// // // //                             "Create Media",
// // // //                             style: GoogleFonts.poppins(
// // // //                               fontWeight: FontWeight.w500,
// // // //                               fontSize: 14,
// // // //                               color: Colors.white,
// // // //                             ),
// // // //                           ),
// // // //                           const SizedBox(width: 6),
// // // //                           const Icon(
// // // //                             Icons.keyboard_arrow_down,
// // // //                             color: Colors.white,
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //
// // // //             // 🔹 Bulk Edit Card
// // // //             Container(
// // // //               padding: const EdgeInsets.all(20),
// // // //               decoration: BoxDecoration(
// // // //                 color: Colors.white,
// // // //                 borderRadius: BorderRadius.circular(16),
// // // //                 border: Border.all(color: Colors.black12),
// // // //                 boxShadow: [
// // // //                   BoxShadow(
// // // //                     color: Colors.black.withOpacity(0.05),
// // // //                     blurRadius: 10,
// // // //                     offset: const Offset(0, 4),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //               child: Row(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   const Icon(Iconsax.information, color: Colors.blue, size: 35),
// // // //                   const SizedBox(width: 16),
// // // //                   Expanded(
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         Text(
// // // //                           "Save time and add tags to your media library in bulk",
// // // //                           style: GoogleFonts.poppins(
// // // //                             fontWeight: FontWeight.w600,
// // // //                             fontSize: 16,
// // // //                           ),
// // // //                         ),
// // // //                         const SizedBox(height: 8),
// // // //                         Text(
// // // //                           "Make the most of your media and get your entire media library tagged with topics,\nscripture, and speakers quickly with Bulk Edit.",
// // // //                           style: GoogleFonts.poppins(
// // // //                             fontWeight: FontWeight.w400,
// // // //                             fontSize: 16,
// // // //                             color: Colors.grey,
// // // //                           ),
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(width: 16),
// // // //                   Row(
// // // //                     children: [
// // // //                       Container(
// // // //                         height: MediaQuery.of(context).size.height * .04,
// // // //                         width: MediaQuery.of(context).size.width * .07,
// // // //                         decoration: BoxDecoration(
// // // //                           borderRadius: BorderRadius.circular(20),
// // // //                           border: Border.all(color: Colors.black12),
// // // //                           color: Colors.white,
// // // //                         ),
// // // //                         child: Center(
// // // //                           child: Text(
// // // //                             "Get started",
// // // //                             style: GoogleFonts.poppins(
// // // //                               fontSize: 16,
// // // //                               fontWeight: FontWeight.w400,
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                       IconButton(
// // // //                         onPressed: () {},
// // // //                         icon: const Icon(Iconsax.close_circle),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //
// // // //             const SizedBox(height: 30),
// // // //
// // // //             // 🔹 Upload Component
// // // //             Container(
// // // //               padding: const EdgeInsets.all(20),
// // // //               decoration: BoxDecoration(
// // // //                 color: Colors.white,
// // // //                 borderRadius: BorderRadius.circular(16),
// // // //                 border: Border.all(color: Colors.black12),
// // // //                 boxShadow: [
// // // //                   BoxShadow(
// // // //                     color: Colors.black.withOpacity(0.05),
// // // //                     blurRadius: 10,
// // // //                     offset: const Offset(0, 4),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //               child: Row(
// // // //                 children: [
// // // //                   const Icon(Iconsax.add_circle, color: Colors.green, size: 28),
// // // //                   const SizedBox(width: 16),
// // // //                   Expanded(
// // // //                     child: Text(
// // // //                       "Upload a video or audio file to create a Media item",
// // // //                       style: GoogleFonts.poppins(
// // // //                         fontSize: 16,
// // // //                         fontWeight: FontWeight.w500,
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                   ElevatedButton(
// // // //                     onPressed: () {
// // // //                       // TODO: Add file picker logic here
// // // //                     },
// // // //                     style: ElevatedButton.styleFrom(
// // // //                       backgroundColor: Colors.blue,
// // // //                       shape: RoundedRectangleBorder(
// // // //                         borderRadius: BorderRadius.circular(12),
// // // //                       ),
// // // //                     ),
// // // //                     child: Text(
// // // //                       "Upload",
// // // //                       style: GoogleFonts.poppins(
// // // //                         fontSize: 14,
// // // //                         fontWeight: FontWeight.w500,
// // // //                         color: Colors.white,
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //
// // // //             const SizedBox(height: 30),
// // // //
// // // //             // 🔹 Recent Media Items
// // // //             Container(
// // // //               height: MediaQuery.of(context).size.height * .3,
// // // //               width: MediaQuery.of(context).size.width * .8,
// // // //               decoration: BoxDecoration(
// // // //                 borderRadius: BorderRadius.circular(20),
// // // //                 color: Colors.white,
// // // //               ),
// // // //               child: Padding(
// // // //                 padding: const EdgeInsets.all(12),
// // // //                 child: Column(
// // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // //                   children: [
// // // //                     Text(
// // // //                       "Recent Media Items",
// // // //                       style: GoogleFonts.poppins(
// // // //                         fontWeight: FontWeight.w600,
// // // //                         fontSize: 16,
// // // //                       ),
// // // //                     ),
// // // //                     SizedBox(height: MediaQuery.of(context).size.height * .005),
// // // //                     const Divider(),
// // // //                     Expanded( // ✅ makes the scrollview take available space
// // // //                       child: _mediaItems.isEmpty
// // // //                           ? const Center(child: Text("No media items yet."))
// // // //                           : SingleChildScrollView(
// // // //                         child: Column(
// // // //                           children: _mediaItems.take(5).map((item) {
// // // //                             final String? thumbnailUrl = item["thumbnailUrl"];
// // // //                             final String seriesName = item["seriesId"]?["title"] ?? "No Series";
// // // //                             final String createdDate = item["createdAt"] != null
// // // //                                 ? DateTime.parse(item["createdAt"])
// // // //                                 .toLocal()
// // // //                                 .toString()
// // // //                                 .substring(0, 16)
// // // //                                 : "Unknown Date";
// // // //
// // // //                             return ListTile(
// // // //                               leading: thumbnailUrl != null && thumbnailUrl.isNotEmpty
// // // //                                   ? ClipRRect(
// // // //                                 borderRadius: BorderRadius.circular(8),
// // // //                                 child: Image.network(
// // // //                                   thumbnailUrl,
// // // //                                   width: 75,
// // // //                                   height: 200,
// // // //                                   fit: BoxFit.cover,
// // // //                                   errorBuilder: (context, error, stackTrace) =>
// // // //                                   const Icon(Iconsax.video, size: 40, color: Colors.grey),
// // // //                                 ),
// // // //                               )
// // // //                                   : const Icon(Iconsax.video, size: 40, color: Colors.grey),
// // // //                               title: Text(item["title"] ?? "Untitled"),
// // // //                               subtitle: Column(
// // // //                                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                                 children: [
// // // //                                   if (item["description"] != null &&
// // // //                                       item["description"].toString().isNotEmpty)
// // // //                                     Text(item["description"]),
// // // //                                   const SizedBox(height: 4),
// // // //                                   Row(
// // // //                                     children: [
// // // //                                       Text(
// // // //                                         "Series: $seriesName",
// // // //                                         overflow: TextOverflow.ellipsis,
// // // //                                         style: GoogleFonts.poppins(
// // // //                                             fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
// // // //                                       ),
// // // //                                       Text('  →  ', style: GoogleFonts.poppins(color: Colors.grey)),
// // // //                                       Text(
// // // //                                         createdDate,
// // // //                                         style: GoogleFonts.poppins(
// // // //                                             fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
// // // //                                       ),
// // // //                                     ],
// // // //                                   ),
// // // //                                   const Divider()
// // // //                                 ],
// // // //                               ),
// // // //                             );
// // // //                           }).toList(),
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 30),
// // // //
// // // //             // 🔹 Recent Media Series
// // // //             Container(
// // // //               width: MediaQuery.of(context).size.width * .8,
// // // //               decoration: BoxDecoration(
// // // //                 borderRadius: BorderRadius.circular(20),
// // // //                 color: Colors.white,
// // // //               ),
// // // //               child: Padding(
// // // //                 padding: const EdgeInsets.all(12),
// // // //                 child: Column(
// // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // //                   children: [
// // // //                     Text(
// // // //                       "Recent Media Series",
// // // //                       style: GoogleFonts.poppins(
// // // //                         fontWeight: FontWeight.w600,
// // // //                         fontSize: 16,
// // // //                       ),
// // // //                     ),
// // // //                     SizedBox(height: MediaQuery.of(context).size.height * .01),
// // // //                     _mediaSeries.isEmpty
// // // //                         ? const Text("No media series yet.")
// // // //                         : Wrap(
// // // //                       spacing: 16,
// // // //                       runSpacing: 16,
// // // //                       children: _mediaSeries.take(5).map((series) {
// // // //                         final String createdDate = series["createdAt"] != null
// // // //                             ? DateTime.parse(series["createdAt"]).toLocal().toString().substring(0, 16)
// // // //                             : "Unknown Date";
// // // //
// // // //                         return SizedBox(
// // // //                           width: 200,
// // // //                           child: Column(
// // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // //                             children: [
// // // //                               ClipRRect(
// // // //                                 borderRadius: BorderRadius.circular(16),
// // // //                                 child: Image.network(
// // // //                                   series["thumbnail"] ?? Icon(Iconsax.image),
// // // //                                   height: 200,
// // // //                                   width: 250,
// // // //                                   fit: BoxFit.cover,
// // // //                                 ),
// // // //                               ),
// // // //                               const SizedBox(height: 8),
// // // //                               Row(
// // // //                                 children: [
// // // //                                   Expanded(
// // // //                                     child: Text(series["title"] ?? "Untitled",
// // // //                                         style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
// // // //                                   ),
// // // //                                   PopupMenuButton<String>(
// // // //                                     icon: const Icon(
// // // //                                       Iconsax.more,
// // // //                                       color: Colors.grey,
// // // //                                     ),
// // // //                                     onSelected: (value) {
// // // //                                       if (value == "add") {
// // // //                                         debugPrint("Add to List tapped");
// // // //                                       } else if (value == "remove") {
// // // //                                         debugPrint("Remove tapped");
// // // //                                       }
// // // //                                     },
// // // //                                     itemBuilder: (context) => [
// // // //                                       const PopupMenuItem(
// // // //                                         value: "add",
// // // //                                         child: Text("Add to List"),
// // // //                                       ),
// // // //                                       const PopupMenuItem(
// // // //                                         value: "remove",
// // // //                                         child: Text("Remove"),
// // // //                                       ),
// // // //                                     ],
// // // //                                   ),
// // // //                                 ],
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                         );
// // // //                       }).toList(),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             Container(
// // // //               height: MediaQuery.of(context).size.height * .3,
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }}
// // //
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:iconsax/iconsax.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import '../Controller/Media_Item_controller.dart';
// // // import '../Controller/Media_Series_controller.dart';
// // // import '../View_model/Create_media_popup.dart';
// // // import 'package:ancilmediaadminpanel/View_model/Create_media_Series.dart';
// // //
// // // class LibraryPage extends StatefulWidget {
// // //   const LibraryPage({super.key});
// // //
// // //   @override
// // //   State<LibraryPage> createState() => _LibraryPageState();
// // // }
// // //
// // // class _LibraryPageState extends State<LibraryPage> {
// // //   final MediaItemService _itemService = MediaItemService();
// // //   final MediaSeriesService _seriesService = MediaSeriesService();
// // //
// // //   List<dynamic> _mediaItems = [];
// // //   List<dynamic> _mediaSeries = [];
// // //   bool _loading = true;
// // //
// // //   String? userId;
// // //   String? orgId;
// // //   String? roleId;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _fetchUserMedia();
// // //     _loadLocalStorage();
// // //   }
// // //
// // //   Future<void> _loadLocalStorage() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //
// // //     userId = prefs.getString("userId");
// // //     orgId = prefs.getString("organizationId");
// // //     roleId = prefs.getString("roleId");
// // //
// // //     debugPrint(
// // //         "🔹 LocalStorage loaded: userId=$userId, orgId=$orgId, roleId=$roleId");
// // //   }
// // //
// // //   Future<void> _fetchUserMedia() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     final userId = prefs.getString("userId");
// // //     final orgId = prefs.getString("organizationId");
// // //
// // //     try {
// // //       // Fetch media items
// // //       final items = await _itemService.getMediaItemsByUserOrOrg(
// // //         userId: userId,
// // //         organizationId: orgId,
// // //       );
// // //
// // //       // Fetch media series
// // //       final seriesList = await _seriesService.getSeriesByFilter(
// // //         userId: userId,
// // //         organizationId: orgId,
// // //       );
// // //
// // //       setState(() {
// // //         _mediaItems = items;
// // //         _mediaSeries = seriesList;
// // //         _loading = false;
// // //       });
// // //     } catch (e) {
// // //       debugPrint("❌ Error fetching media: $e");
// // //       setState(() => _loading = false);
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return _loading
// // //         ? const Center(
// // //       child: CircularProgressIndicator(
// // //         color: Colors.purple,
// // //       ),
// // //     )
// // //         : SingleChildScrollView(
// // //       child: Padding(
// // //         padding: EdgeInsets.symmetric(
// // //           horizontal: MediaQuery.of(context).size.width * .1,
// // //           vertical: MediaQuery.of(context).size.height * .05,
// // //         ),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             /// 🔹 Top Row with Dropdown
// // //             Padding(
// // //               padding: const EdgeInsets.all(12.0),
// // //               child: Row(
// // //                 mainAxisAlignment: MainAxisAlignment.end,
// // //                 children: [
// // //                   PopupMenuButton<String>(
// // //                     onSelected: (value) {
// // //                       if (value == "item") {
// // //                         showCreateMediaItemDialog(
// // //                             context, _itemService, _seriesService);
// // //                       } else if (value == "series") {
// // //                         showCreateMediaSeriesDialog(
// // //                             context, _seriesService);
// // //                       }
// // //                     },
// // //                     shape: RoundedRectangleBorder(
// // //                       borderRadius: BorderRadius.circular(12),
// // //                     ),
// // //                     offset: const Offset(0, 50),
// // //                     itemBuilder: (context) => [
// // //                       PopupMenuItem(
// // //                         value: "item",
// // //                         child: Row(
// // //                           children: [
// // //                             const Icon(
// // //                               Iconsax.video,
// // //                               size: 18,
// // //                               color: Colors.purple,
// // //                             ),
// // //                             const SizedBox(width: 8),
// // //                             Text(
// // //                               "Create Media Item",
// // //                               style: GoogleFonts.poppins(fontSize: 14),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                       PopupMenuItem(
// // //                         value: "series",
// // //                         child: Row(
// // //                           children: [
// // //                             const Icon(
// // //                               Iconsax.video_add,
// // //                               size: 18,
// // //                               color: Colors.purple,
// // //                             ),
// // //                             const SizedBox(width: 8),
// // //                             Text(
// // //                               "Create Media Series",
// // //                               style: GoogleFonts.poppins(fontSize: 14),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     ],
// // //                     child: Container(
// // //                       decoration: BoxDecoration(
// // //                         borderRadius: BorderRadius.circular(10),
// // //                         color: Colors.purple,
// // //                       ),
// // //                       padding: const EdgeInsets.symmetric(
// // //                         horizontal: 16,
// // //                         vertical: 12,
// // //                       ),
// // //                       child: Row(
// // //                         children: [
// // //                           const Icon(Iconsax.video, color: Colors.white),
// // //                           const SizedBox(width: 8),
// // //                           Text(
// // //                             "Create Media",
// // //                             style: GoogleFonts.poppins(
// // //                               fontWeight: FontWeight.w500,
// // //                               fontSize: 14,
// // //                               color: Colors.white,
// // //                             ),
// // //                           ),
// // //                           const SizedBox(width: 6),
// // //                           const Icon(
// // //                             Icons.keyboard_arrow_down,
// // //                             color: Colors.white,
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //
// // //             const SizedBox(height: 30),
// // //
// // //             // 🔹 Recent Media Items
// // //             Text(
// // //               "Recent Media Items",
// // //               style: GoogleFonts.poppins(
// // //                   fontWeight: FontWeight.w600, fontSize: 16),
// // //             ),
// // //             const Divider(),
// // //             SizedBox(
// // //               height: MediaQuery.of(context).size.height * .3,
// // //               child: _mediaItems.isEmpty
// // //                   ? const Center(child: Text("No media items yet."))
// // //                   : ListView.builder(
// // //                 itemCount:
// // //                 _mediaItems.length > 5 ? 5 : _mediaItems.length,
// // //                 itemBuilder: (context, index) {
// // //                   final item = _mediaItems[index];
// // //                   final thumbnailUrl = item["thumbnailUrl"];
// // //                   final seriesName =
// // //                       item["seriesId"]?["title"] ?? "No Series";
// // //                   final createdDate = item["createdAt"] != null
// // //                       ? DateTime.parse(item["createdAt"])
// // //                       .toLocal()
// // //                       .toString()
// // //                       .substring(0, 16)
// // //                       : "Unknown Date";
// // //
// // //                   return ListTile(
// // //                     leading: thumbnailUrl != null &&
// // //                         thumbnailUrl.isNotEmpty
// // //                         ? ClipRRect(
// // //                       borderRadius: BorderRadius.circular(8),
// // //                       child: Image.network(
// // //                         thumbnailUrl,
// // //                         width: 75,
// // //                         height: 75,
// // //                         fit: BoxFit.cover,
// // //                         errorBuilder:
// // //                             (context, error, stackTrace) =>
// // //                         const Icon(Iconsax.video,
// // //                             size: 40,
// // //                             color: Colors.grey),
// // //                       ),
// // //                     )
// // //                         : const Icon(Iconsax.video,
// // //                         size: 40, color: Colors.grey),
// // //                     title: Text(item["title"] ?? "Untitled"),
// // //                     subtitle: Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         if (item["description"] != null &&
// // //                             item["description"]
// // //                                 .toString()
// // //                                 .isNotEmpty)
// // //                           Text(item["description"]),
// // //                         const SizedBox(height: 4),
// // //                         Row(
// // //                           children: [
// // //                             Text(
// // //                               "Series: $seriesName",
// // //                               style: GoogleFonts.poppins(
// // //                                   fontSize: 12,
// // //                                   color: Colors.grey,
// // //                                   fontWeight: FontWeight.w600),
// // //                             ),
// // //                             const SizedBox(width: 6),
// // //                             Text(
// // //                               createdDate,
// // //                               style: GoogleFonts.poppins(
// // //                                   fontSize: 12,
// // //                                   color: Colors.grey,
// // //                                   fontWeight: FontWeight.w600),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   );
// // //                 },
// // //               ),
// // //             ),
// // //
// // //             const SizedBox(height: 30),
// // //
// // //             // 🔹 Recent Media Series
// // //             Text(
// // //               "Recent Media Series",
// // //               style: GoogleFonts.poppins(
// // //                   fontWeight: FontWeight.w600, fontSize: 16),
// // //             ),
// // //             const Divider(),
// // //             Wrap(
// // //               spacing: 16,
// // //               runSpacing: 16,
// // //               children: _mediaSeries.take(5).map((series) {
// // //                 final createdDate = series["createdAt"] != null
// // //                     ? DateTime.parse(series["createdAt"])
// // //                     .toLocal()
// // //                     .toString()
// // //                     .substring(0, 16)
// // //                     : "Unknown Date";
// // //                 final thumbnail = series["thumbnail"];
// // //
// // //                 return SizedBox(
// // //                   width: 200,
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       ClipRRect(
// // //                         borderRadius: BorderRadius.circular(16),
// // //                         child: thumbnail != null && thumbnail.isNotEmpty
// // //                             ? Image.network(
// // //                           thumbnail,
// // //                           height: 200,
// // //                           width: 250,
// // //                           fit: BoxFit.cover,
// // //                           errorBuilder:
// // //                               (context, error, stackTrace) =>
// // //                               Container(
// // //                                 height: 200,
// // //                                 width: 250,
// // //                                 color: Colors.grey[200],
// // //                                 child: const Icon(Iconsax.image,
// // //                                     size: 40, color: Colors.grey),
// // //                               ),
// // //                         )
// // //                             : Container(
// // //                           height: 200,
// // //                           width: 250,
// // //                           color: Colors.grey[200],
// // //                           child: const Icon(Iconsax.image,
// // //                               size: 40, color: Colors.grey),
// // //                         ),
// // //                       ),
// // //                       const SizedBox(height: 8),
// // //                       Row(
// // //                         children: [
// // //                           Expanded(
// // //                             child: Text(series["title"] ?? "Untitled",
// // //                                 style: GoogleFonts.poppins(
// // //                                     fontWeight: FontWeight.w500)),
// // //                           ),
// // //                           PopupMenuButton<String>(
// // //                             icon: const Icon(
// // //                               Iconsax.more,
// // //                               color: Colors.grey,
// // //                             ),
// // //                             onSelected: (value) {
// // //                               if (value == "add") {
// // //                                 debugPrint("Add to List tapped");
// // //                               } else if (value == "remove") {
// // //                                 debugPrint("Remove tapped");
// // //                               }
// // //                             },
// // //                             itemBuilder: (context) => const [
// // //                               PopupMenuItem(
// // //                                 value: "add",
// // //                                 child: Text("Add to List"),
// // //                               ),
// // //                               PopupMenuItem(
// // //                                 value: "remove",
// // //                                 child: Text("Remove"),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 );
// // //               }).toList(),
// // //             ),
// // //             const SizedBox(height: 50),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// // // Keep your existing imports
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../Controller/Media_Item_controller.dart';
// // import '../Controller/Media_Series_controller.dart';
// // import '../View_model/Create_media_popup.dart';
// // import 'package:ancilmediaadminpanel/View_model/Create_media_Series.dart';
// //
// // class LibraryPage extends StatefulWidget {
// //   const LibraryPage({super.key});
// //
// //   @override
// //   State<LibraryPage> createState() => _LibraryPageState();
// // }
// //
// // class _LibraryPageState extends State<LibraryPage> {
// //   final MediaItemService _itemService = MediaItemService();
// //   final MediaSeriesService _seriesService = MediaSeriesService();
// //
// //   List<dynamic> _mediaItems = [];
// //   List<dynamic> _mediaSeries = [];
// //   bool _loading = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchUserMedia();
// //   }
// //
// //   Future<void> _deleteSeries(Map<String, dynamic> series) async {
// //     final seriesId = series["_id"] ?? series["id"];
// //     if (seriesId == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Series ID is missing. Cannot delete.")),
// //       );
// //       return;
// //     }
// //
// //     try {
// //       final deleted = await _seriesService.deleteSeries(seriesId);
// //       debugPrint("Deleted series response: $deleted");
// //
// //       setState(() {
// //         _mediaSeries.remove(series);
// //       });
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Series deleted successfully")),
// //       );
// //     } catch (e) {
// //       debugPrint("Error deleting series: $e");
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Failed to delete series")),
// //       );
// //     }
// //   }
// //
// //   Future<void> _fetchUserMedia() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final userId = prefs.getString("userId");
// //     final orgId = prefs.getString("organizationId");
// //
// //     try {
// //       final items = await _itemService.getMediaItemsByUserOrOrg(
// //         userId: userId,
// //         organizationId: orgId,
// //       );
// //
// //       final seriesList = await _seriesService.getSeriesByFilter(
// //         userId: userId,
// //         organizationId: orgId,
// //       );
// //
// //       setState(() {
// //         _mediaItems = items;
// //         _mediaSeries = seriesList;
// //         _loading = false;
// //       });
// //     } catch (e) {
// //       debugPrint("❌ Error fetching media: $e");
// //       setState(() => _loading = false);
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return _loading
// //         ? const Center(
// //       child: CircularProgressIndicator(
// //         color: Colors.purple,
// //       ),
// //     )
// //         : SingleChildScrollView(
// //       child: Padding(
// //         padding: EdgeInsets.only(
// //           left: MediaQuery.of(context).size.width * .1,
// //           right: MediaQuery.of(context).size.width * .1,
// //           top: MediaQuery.of(context).size.height * .05,
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             /// Top Row with Dropdown
// //             Padding(
// //               padding: const EdgeInsets.all(12.0),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.end,
// //                 children: [
// //                   PopupMenuButton<String>(
// //                     onSelected: (value) {
// //                       if (value == "item") {
// //                         showCreateMediaItemDialog(
// //                             context, _itemService, _seriesService);
// //                       } else if (value == "series") {
// //                         showCreateMediaSeriesDialog(
// //                             context, _seriesService);
// //                       }
// //                     },
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     offset: const Offset(0, 50),
// //                     itemBuilder: (context) => [
// //                       PopupMenuItem(
// //                         value: "item",
// //                         child: Row(
// //                           children: [
// //                             const Icon(
// //                               Iconsax.video,
// //                               size: 18,
// //                               color: Colors.purple,
// //                             ),
// //                             const SizedBox(width: 8),
// //                             Text(
// //                               "Create Media Item",
// //                               style: GoogleFonts.poppins(fontSize: 14),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       PopupMenuItem(
// //                         value: "series",
// //                         child: Row(
// //                           children: [
// //                             const Icon(
// //                               Iconsax.video_add,
// //                               size: 18,
// //                               color: Colors.purple,
// //                             ),
// //                             const SizedBox(width: 8),
// //                             Text(
// //                               "Create Media Series",
// //                               style: GoogleFonts.poppins(fontSize: 14),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                     child: Container(
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(10),
// //                         color: Colors.purple,
// //                       ),
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 16,
// //                         vertical: 12,
// //                       ),
// //                       child: Row(
// //                         children: [
// //                           const Icon(Iconsax.video, color: Colors.white),
// //                           const SizedBox(width: 8),
// //                           Text(
// //                             "Create Media",
// //                             style: GoogleFonts.poppins(
// //                               fontWeight: FontWeight.w500,
// //                               fontSize: 14,
// //                               color: Colors.white,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 6),
// //                           const Icon(
// //                             Icons.keyboard_arrow_down,
// //                             color: Colors.white,
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //             // 🔹 Recent Media Series (Image.network ensures web-safe)
// //             Text(
// //               "Recent Media Series",
// //               style: GoogleFonts.poppins(
// //                 fontWeight: FontWeight.w600,
// //                 fontSize: 16,
// //               ),
// //             ),
// //             SizedBox(height: MediaQuery.of(context).size.height * .01),
// //             _mediaSeries.isEmpty
// //                 ? const Text("No media series yet.")
// //                 : Wrap(
// //               spacing: 16,
// //               runSpacing: 16,
// //               children: _mediaSeries.take(5).map((series) {
// //                 final String createdDate =
// //                 series["createdAt"] != null
// //                     ? DateTime.parse(series["createdAt"])
// //                     .toLocal()
// //                     .toString()
// //                     .substring(0, 16)
// //                     : "Unknown Date";
// //
// //                 return SizedBox(
// //                   width: 200,
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       ClipRRect(
// //                         borderRadius: BorderRadius.circular(16),
// //                         child: series["thumbnail"] != null &&
// //                             series["thumbnail"].isNotEmpty
// //                             ? Image.network(
// //                           series["thumbnail"],
// //                           height: 120,
// //                           width: 200,
// //                           fit: BoxFit.cover,
// //                         )
// //                             : Container(
// //                           height: 120,
// //                           width: 200,
// //                           color: Colors.grey.shade300,
// //                           child: const Icon(Iconsax.image,
// //                               size: 40, color: Colors.grey),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: Text(series["title"] ?? "Untitled",
// //                                 style: GoogleFonts.poppins(
// //                                     fontWeight: FontWeight.w500)),
// //                           ),
// //                           PopupMenuButton<String>(
// //                             icon: const Icon(
// //                               Iconsax.more,
// //                               color: Colors.grey,
// //                             ),
// //                             onSelected: (value) async {
// //                               if (value == "add") {
// //                                 debugPrint("Add to List tapped");
// //                               } else if (value == "remove") {
// //                                 await _deleteSeries(series);
// //                               }
// //                             },
// //                             itemBuilder: (context) => [
// //                               const PopupMenuItem(
// //                                 value: "add",
// //                                 child: Text("Add to List"),
// //                               ),
// //                               const PopupMenuItem(
// //                                 value: "remove",
// //                                 child: Text("Remove"),
// //                               ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 );
// //               }).toList(),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
//
//
// // // // // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // // // // import 'package:http/http.dart' as http;
// // // // // // // // // // // // import 'dart:convert';
// // // // // // // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // // // // // // // import 'package:ancilmediaadminpanel/environmental%20variables.dart';
// // // // // // // // // // // //
// // // // // // // // // // // // class RolesController extends ChangeNotifier {
// // // // // // // // // // // //   bool isLoading = true;
// // // // // // // // // // // //
// // // // // // // // // // // //   // Permissions
// // // // // // // // // // // //   Map<String, List<Map<String, dynamic>>> permissionCategories = {};
// // // // // // // // // // // //   Map<String, bool> permissionStates = {};
// // // // // // // // // // // //
// // // // // // // // // // // //   // Sidebar permissions
// // // // // // // // // // // //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
// // // // // // // // // // // //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// // // // // // // // // // // //
// // // // // // // // // // // //   // Roles
// // // // // // // // // // // //   List<Map<String, dynamic>> rolesList = [];
// // // // // // // // // // // //
// // // // // // // // // // // //   String? roleId;
// // // // // // // // // // // //   String? token;
// // // // // // // // // // // //
// // // // // // // // // // // //   RolesController() {
// // // // // // // // // // // //     _initLoad();
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   Future<void> _initLoad() async {
// // // // // // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // // // // // //     roleId = prefs.getString('roleId');
// // // // // // // // // // // //     token = prefs.getString('accessToken');
// // // // // // // // // // // //     if (roleId != null && token != null) {
// // // // // // // // // // // //       await refreshRole(roleId!);
// // // // // // // // // // // //       await fetchRoles();
// // // // // // // // // // // //     } else {
// // // // // // // // // // // //       isLoading = false;
// // // // // // // // // // // //       notifyListeners();
// // // // // // // // // // // //     }
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// ==================== Roles API ====================
// // // // // // // // // // // //   Future<List<Map<String, dynamic>>> fetchRoles() async {
// // // // // // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // // // // // //     token = prefs.getString('accessToken');
// // // // // // // // // // // //     if (token == null) return [];
// // // // // // // // // // // //
// // // // // // // // // // // //     try {
// // // // // // // // // // // //       final response = await http.get(
// // // // // // // // // // // //         Uri.parse('$baseUrl/api/roles'),
// // // // // // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // // // // // //       );
// // // // // // // // // // // //
// // // // // // // // // // // //       print("🔹 fetchRoles response (${response.statusCode}): ${response.body}");
// // // // // // // // // // // //
// // // // // // // // // // // //       if (response.statusCode == 200) {
// // // // // // // // // // // //         final List data = json.decode(response.body);
// // // // // // // // // // // //         rolesList = data.map((role) {
// // // // // // // // // // // //           return {'id': role['_id'], 'name': role['name']};
// // // // // // // // // // // //         }).toList();
// // // // // // // // // // // //         notifyListeners();
// // // // // // // // // // // //         return rolesList;
// // // // // // // // // // // //       } else {
// // // // // // // // // // // //         print('Failed to fetch roles: ${response.statusCode}');
// // // // // // // // // // // //         return [];
// // // // // // // // // // // //       }
// // // // // // // // // // // //     } catch (e) {
// // // // // // // // // // // //       print('Error fetching roles: $e');
// // // // // // // // // // // //       return [];
// // // // // // // // // // // //     }
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// ===================== Permissions =====================
// // // // // // // // // // // //   Future<void> refreshRole(String roleId) async {
// // // // // // // // // // // //     this.roleId = roleId;
// // // // // // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // // // // // //     token = prefs.getString('accessToken');
// // // // // // // // // // // //
// // // // // // // // // // // //     if (token == null) return;
// // // // // // // // // // // //
// // // // // // // // // // // //     isLoading = true;
// // // // // // // // // // // //     notifyListeners();
// // // // // // // // // // // //
// // // // // // // // // // // //     await fetchPermissionsAndRole();
// // // // // // // // // // // //     await fetchSidebarItems();
// // // // // // // // // // // //
// // // // // // // // // // // //     isLoading = false;
// // // // // // // // // // // //     notifyListeners();
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   Future<void> fetchPermissionsAndRole() async {
// // // // // // // // // // // //     if (roleId == null || token == null) return;
// // // // // // // // // // // //
// // // // // // // // // // // //     try {
// // // // // // // // // // // //       final permResponse = await http.get(
// // // // // // // // // // // //         Uri.parse('$baseUrl/api/permissions'),
// // // // // // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // // // // // //       );
// // // // // // // // // // // //       print("🔹 fetchPermissions response (${permResponse.statusCode}): ${permResponse.body}");
// // // // // // // // // // // //
// // // // // // // // // // // //       if (permResponse.statusCode != 200) return;
// // // // // // // // // // // //       final List allPermissions = json.decode(permResponse.body);
// // // // // // // // // // // //
// // // // // // // // // // // //       final roleResponse = await http.get(
// // // // // // // // // // // //         Uri.parse('$baseUrl/api/permissions/$roleId'),
// // // // // // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // // // // // //       );
// // // // // // // // // // // //       print("🔹 role permissions response (${roleResponse.statusCode}): ${roleResponse.body}");
// // // // // // // // // // // //
// // // // // // // // // // // //       if (roleResponse.statusCode != 200) return;
// // // // // // // // // // // //       final roleData = json.decode(roleResponse.body);
// // // // // // // // // // // //
// // // // // // // // // // // //       final List<String> assignedKeys =
// // // // // // // // // // // //       List<String>.from(roleData['permissions'].map((p) => p['key']));
// // // // // // // // // // // //
// // // // // // // // // // // //       Map<String, List<Map<String, dynamic>>> grouped = {};
// // // // // // // // // // // //       permissionStates = {};
// // // // // // // // // // // //
// // // // // // // // // // // //       for (var perm in allPermissions) {
// // // // // // // // // // // //         String category = perm['key'].split(':')[0];
// // // // // // // // // // // //         grouped.putIfAbsent(category, () => []);
// // // // // // // // // // // //         grouped[category]!.add(perm);
// // // // // // // // // // // //         permissionStates[perm['key']] = assignedKeys.contains(perm['key']);
// // // // // // // // // // // //       }
// // // // // // // // // // // //
// // // // // // // // // // // //       permissionCategories = grouped;
// // // // // // // // // // // //     } catch (e) {
// // // // // // // // // // // //       print('Error fetching permissions: $e');
// // // // // // // // // // // //     }
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   Future<bool> updateRolePermissions() async {
// // // // // // // // // // // //     if (roleId == null || token == null) return false;
// // // // // // // // // // // //
// // // // // // // // // // // //     try {
// // // // // // // // // // // //       final selectedPermissions = permissionCategories.values
// // // // // // // // // // // //           .expand((list) => list)
// // // // // // // // // // // //           .where((p) => permissionStates[p['key']] == true)
// // // // // // // // // // // //           .map((p) => p['_id'])
// // // // // // // // // // // //           .toList();
// // // // // // // // // // // //
// // // // // // // // // // // //       final response = await http.put(
// // // // // // // // // // // //         Uri.parse('$baseUrl/api/permissions/assign/$roleId'),
// // // // // // // // // // // //         headers: {
// // // // // // // // // // // //           'Authorization': 'Bearer $token',
// // // // // // // // // // // //           'Content-Type': 'application/json'
// // // // // // // // // // // //         },
// // // // // // // // // // // //         body: json.encode({'permissions': selectedPermissions}),
// // // // // // // // // // // //       );
// // // // // // // // // // // //
// // // // // // // // // // // //       print("🔹 updateRolePermissions response (${response.statusCode}): ${response.body}");
// // // // // // // // // // // //
// // // // // // // // // // // //       return response.statusCode == 200;
// // // // // // // // // // // //     } catch (e) {
// // // // // // // // // // // //       print('Error updating permissions: $e');
// // // // // // // // // // // //       return false;
// // // // // // // // // // // //     }
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   /// ===================== Sidebar =====================
// // // // // // // // // // // //   Future<void> fetchSidebarItems() async {
// // // // // // // // // // // //     if (roleId == null || token == null) return;
// // // // // // // // // // // //
// // // // // // // // // // // //     try {
// // // // // // // // // // // //       // Fetch all sidebar items
// // // // // // // // // // // //       final response = await http.get(
// // // // // // // // // // // //         Uri.parse('$baseUrl/api/sidebar'),
// // // // // // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // // // // // //       );
// // // // // // // // // // // //       print("🔹 fetchSidebarItems (all items) (${response.statusCode}): ${response.body}");
// // // // // // // // // // // //       if (response.statusCode != 200) return;
// // // // // // // // // // // //       final List items = json.decode(response.body);
// // // // // // // // // // // //
// // // // // // // // // // // //       // Fetch role info to check if admin
// // // // // // // // // // // //       final roleResponse = await http.get(
// // // // // // // // // // // //         Uri.parse('$baseUrl/api/roles/$roleId'),
// // // // // // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // // // // // //       );
// // // // // // // // // // // //       print("🔹 fetchSidebarItems (role info) (${roleResponse.statusCode}): ${roleResponse.body}");
// // // // // // // // // // // //       if (roleResponse.statusCode != 200) return;
// // // // // // // // // // // //       final roleData = json.decode(roleResponse.body);
// // // // // // // // // // // //       final isAdmin = roleData['name'] == 'admin';
// // // // // // // // // // // //
// // // // // // // // // // // //       // Fetch assigned sidebar permissions for the role
// // // // // // // // // // // //       final sidebarPermResponse = await http.get(
// // // // // // // // // // // //         Uri.parse('$baseUrl/api/sidebar/assign/$roleId'),
// // // // // // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // // // // // //       );
// // // // // // // // // // // //       print("🔹 fetchSidebarItems (assigned) (${sidebarPermResponse.statusCode}): ${sidebarPermResponse.body}");
// // // // // // // // // // // //
// // // // // // // // // // // //       Map<String, dynamic> roleSidebar = {};
// // // // // // // // // // // //       if (sidebarPermResponse.statusCode == 200) {
// // // // // // // // // // // //         final sidebarData = json.decode(sidebarPermResponse.body);
// // // // // // // // // // // //         for (var sb in sidebarData['sidebarPermissions'] ?? []) {
// // // // // // // // // // // //           roleSidebar[sb['key']] = sb['permissions'];
// // // // // // // // // // // //         }
// // // // // // // // // // // //       }
// // // // // // // // // // // //
// // // // // // // // // // // //       Map<String, List<Map<String, dynamic>>> grouped = {};
// // // // // // // // // // // //       sidebarPermissionStates = {};
// // // // // // // // // // // //
// // // // // // // // // // // //       for (var item in items) {
// // // // // // // // // // // //         String key = item['key'];
// // // // // // // // // // // //         String category = item['category'] ?? 'General';
// // // // // // // // // // // //
// // // // // // // // // // // //         // Get permissions for the current item
// // // // // // // // // // // //         Map<String, dynamic> perms = roleSidebar[key] ?? {};
// // // // // // // // // // // //         bool view = perms['view'] ?? false;
// // // // // // // // // // // //         bool read = perms['read'] ?? false;
// // // // // // // // // // // //         bool manage = perms['manage'] ?? false;
// // // // // // // // // // // //
// // // // // // // // // // // //         // Admin sees all, non-admin sees only if 'manage' is true
// // // // // // // // // // // //         if (isAdmin || manage) {
// // // // // // // // // // // //           grouped.putIfAbsent(category, () => []);
// // // // // // // // // // // //           grouped[category]!.add(item);
// // // // // // // // // // // //
// // // // // // // // // // // //           sidebarPermissionStates[key] = {
// // // // // // // // // // // //             'view': view,
// // // // // // // // // // // //             'read': read,
// // // // // // // // // // // //             'manage': manage,
// // // // // // // // // // // //           };
// // // // // // // // // // // //         }
// // // // // // // // // // // //       }
// // // // // // // // // // // //
// // // // // // // // // // // //       sidebarCategories = grouped;
// // // // // // // // // // // //     } catch (e) {
// // // // // // // // // // // //       print('Error fetching sidebar items: $e');
// // // // // // // // // // // //     }
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   Future<bool> updateSidebarPermissions() async {
// // // // // // // // // // // //     if (roleId == null || token == null) return false;
// // // // // // // // // // // //
// // // // // // // // // // // //     try {
// // // // // // // // // // // //       final data = sidebarPermissionStates.entries
// // // // // // // // // // // //           .where((e) => e.value.values.any((v) => v))
// // // // // // // // // // // //           .map((e) => {
// // // // // // // // // // // //         'key': e.key,
// // // // // // // // // // // //         'permissions': e.value,
// // // // // // // // // // // //       })
// // // // // // // // // // // //           .toList();
// // // // // // // // // // // //
// // // // // // // // // // // //       final response = await http.put(
// // // // // // // // // // // //         Uri.parse('$baseUrl/api/sidebar/assign/$roleId'),
// // // // // // // // // // // //         headers: {
// // // // // // // // // // // //           'Authorization': 'Bearer $token',
// // // // // // // // // // // //           'Content-Type': 'application/json'
// // // // // // // // // // // //         },
// // // // // // // // // // // //         body: json.encode({'sidebar': data}),
// // // // // // // // // // // //       );
// // // // // // // // // // // //
// // // // // // // // // // // //       print("🔹 updateSidebarPermissions response (${response.statusCode}): ${response.body}");
// // // // // // // // // // // //
// // // // // // // // // // // //       return response.statusCode == 200;
// // // // // // // // // // // //     } catch (e) {
// // // // // // // // // // // //       print('Error updating sidebar: $e');
// // // // // // // // // // // //       return false;
// // // // // // // // // // // //     }
// // // // // // // // // // // //   }
// // // // // // // // // // // //   /// ===================== Sidebar Toggle Helpers =====================
// // // // // // // // // // // //   void toggleSidebarPermission(String key, String permType, bool value) {
// // // // // // // // // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // // // // // // // // //       sidebarPermissionStates[key]![permType] = value;
// // // // // // // // // // // //       notifyListeners();
// // // // // // // // // // // //     }
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   bool getSidebarAll(String key) {
// // // // // // // // // // // //     final perms = sidebarPermissionStates[key];
// // // // // // // // // // // //     if (perms == null) return false;
// // // // // // // // // // // //     return perms.values.every((v) => v);
// // // // // // // // // // // //   }
// // // // // // // // // // // //
// // // // // // // // // // // //   void toggleSidebarAll(String key, bool value) {
// // // // // // // // // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // // // // // // // // //       sidebarPermissionStates[key]!.updateAll((k, v) => value);
// // // // // // // // // // // //       notifyListeners();
// // // // // // // // // // // //     }
// // // // // // // // // // // //   }
// // // // // // // // // // // // }
// // // // // // // // // // //
// // // // // // // // // // //
// // // // // // // // // // // import 'dart:convert';
// // // // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // // // import 'package:http/http.dart' as http;
// // // // // // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // // // // // //
// // // // // // // // // // // import '../environmental variables.dart';
// // // // // // // // // // //
// // // // // // // // // // // // 🌍 Base API URL (update with your backend URL)
// // // // // // // // // // // // const String baseUrl = "$baseUrl/api/roles";
// // // // // // // // // // //
// // // // // // // // // // // class RolesController extends ChangeNotifier {
// // // // // // // // // // //   bool isLoading = false;
// // // // // // // // // // //   List<Map<String, dynamic>> roles = [];
// // // // // // // // // // //
// // // // // // // // // // //   /// ✅ Get Token from SharedPreferences
// // // // // // // // // // //   Future<String?> _getToken() async {
// // // // // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // // // // //     return prefs.getString("accessToken");
// // // // // // // // // // //   }
// // // // // // // // // // //
// // // // // // // // // // //   /// ✅ Create Role
// // // // // // // // // // //   Future<bool> createRole(String name, String description) async {
// // // // // // // // // // //     try {
// // // // // // // // // // //       isLoading = true;
// // // // // // // // // // //       notifyListeners();
// // // // // // // // // // //
// // // // // // // // // // //       final token = await _getToken();
// // // // // // // // // // //       final response = await http.post(
// // // // // // // // // // //         Uri.parse('$baseUrl/api/roles'),
// // // // // // // // // // //         headers: {
// // // // // // // // // // //           "Content-Type": "application/json",
// // // // // // // // // // //           "Authorization": "Bearer $token",
// // // // // // // // // // //         },
// // // // // // // // // // //         body: jsonEncode({"name": name, "description": description}),
// // // // // // // // // // //       );
// // // // // // // // // // //
// // // // // // // // // // //       if (response.statusCode == 201) {
// // // // // // // // // // //         await fetchRoles(); // refresh roles list
// // // // // // // // // // //         return true;
// // // // // // // // // // //       } else {
// // // // // // // // // // //         debugPrint("Create Role Failed: ${response.body}");
// // // // // // // // // // //         return false;
// // // // // // // // // // //       }
// // // // // // // // // // //     } catch (e) {
// // // // // // // // // // //       debugPrint("Create Role Error: $e");
// // // // // // // // // // //       return false;
// // // // // // // // // // //     } finally {
// // // // // // // // // // //       isLoading = false;
// // // // // // // // // // //       notifyListeners();
// // // // // // // // // // //     }
// // // // // // // // // // //   }
// // // // // // // // // // //
// // // // // // // // // // //   /// ✅ Get Roles
// // // // // // // // // // //   Future<void> fetchRoles() async {
// // // // // // // // // // //     try {
// // // // // // // // // // //       isLoading = true;
// // // // // // // // // // //       notifyListeners();
// // // // // // // // // // //
// // // // // // // // // // //       final token = await _getToken();
// // // // // // // // // // //       final response = await http.get(
// // // // // // // // // // //         Uri.parse('$baseUrl/api/roles'),
// // // // // // // // // // //         headers: {"Authorization": "Bearer $token"},
// // // // // // // // // // //       );
// // // // // // // // // // //
// // // // // // // // // // //       if (response.statusCode == 200) {
// // // // // // // // // // //         List<dynamic> data = jsonDecode(response.body);
// // // // // // // // // // //         roles = List<Map<String, dynamic>>.from(data);
// // // // // // // // // // //       } else {
// // // // // // // // // // //         debugPrint("Fetch Roles Failed: ${response.body}");
// // // // // // // // // // //       }
// // // // // // // // // // //     } catch (e) {
// // // // // // // // // // //       debugPrint("Fetch Roles Error: $e");
// // // // // // // // // // //     } finally {
// // // // // // // // // // //       isLoading = false;
// // // // // // // // // // //       notifyListeners();
// // // // // // // // // // //     }
// // // // // // // // // // //   }
// // // // // // // // // // //
// // // // // // // // // // //   /// ✅ Update Role
// // // // // // // // // // //   Future<bool> updateRole(String id, String name, String description) async {
// // // // // // // // // // //     try {
// // // // // // // // // // //       isLoading = true;
// // // // // // // // // // //       notifyListeners();
// // // // // // // // // // //
// // // // // // // // // // //       final token = await _getToken();
// // // // // // // // // // //       final response = await http.put(
// // // // // // // // // // //         Uri.parse("$baseUrl/api/roles/$id"),
// // // // // // // // // // //         headers: {
// // // // // // // // // // //           "Content-Type": "application/json",
// // // // // // // // // // //           "Authorization": "Bearer $token",
// // // // // // // // // // //         },
// // // // // // // // // // //         body: jsonEncode({"name": name, "description": description}),
// // // // // // // // // // //       );
// // // // // // // // // // //
// // // // // // // // // // //       if (response.statusCode == 200) {
// // // // // // // // // // //         await fetchRoles(); // refresh roles
// // // // // // // // // // //         return true;
// // // // // // // // // // //       } else {
// // // // // // // // // // //         debugPrint("Update Role Failed: ${response.body}");
// // // // // // // // // // //         return false;
// // // // // // // // // // //       }
// // // // // // // // // // //     } catch (e) {
// // // // // // // // // // //       debugPrint("Update Role Error: $e");
// // // // // // // // // // //       return false;
// // // // // // // // // // //     } finally {
// // // // // // // // // // //       isLoading = false;
// // // // // // // // // // //       notifyListeners();
// // // // // // // // // // //     }
// // // // // // // // // // //   }
// // // // // // // // // // //
// // // // // // // // // // //   /// ✅ Delete Role
// // // // // // // // // // //   Future<bool> deleteRole(String id) async {
// // // // // // // // // // //     try {
// // // // // // // // // // //       isLoading = true;
// // // // // // // // // // //       notifyListeners();
// // // // // // // // // // //
// // // // // // // // // // //       final token = await _getToken();
// // // // // // // // // // //       final response = await http.delete(
// // // // // // // // // // //         Uri.parse("$baseUrl/api/roles/$id"),
// // // // // // // // // // //         headers: {"Authorization": "Bearer $token"},
// // // // // // // // // // //       );
// // // // // // // // // // //
// // // // // // // // // // //       if (response.statusCode == 200) {
// // // // // // // // // // //         roles.removeWhere((role) => role["_id"] == id);
// // // // // // // // // // //         notifyListeners();
// // // // // // // // // // //         return true;
// // // // // // // // // // //       } else {
// // // // // // // // // // //         debugPrint("Delete Role Failed: ${response.body}");
// // // // // // // // // // //         return false;
// // // // // // // // // // //       }
// // // // // // // // // // //     } catch (e) {
// // // // // // // // // // //       debugPrint("Delete Role Error: $e");
// // // // // // // // // // //       return false;
// // // // // // // // // // //     } finally {
// // // // // // // // // // //       isLoading = false;
// // // // // // // // // // //       notifyListeners();
// // // // // // // // // // //     }
// // // // // // // // // // //   }
// // // // // // // // // // // }
// // // // // // // // // //
// // // // // // // // // //
// // // // // // // // // // // lib/Controller/Roles_controller.dart
// // // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // // import 'package:http/http.dart' as http;
// // // // // // // // // // import 'dart:convert';
// // // // // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // // // // // import 'package:ancilmediaadminpanel/environmental variables.dart';
// // // // // // // // // //
// // // // // // // // // // class RolesController extends ChangeNotifier {
// // // // // // // // // //   bool isLoading = true;
// // // // // // // // // //
// // // // // // // // // //   // ===== Roles =====
// // // // // // // // // //   List<dynamic> roles = [];
// // // // // // // // // //
// // // // // // // // // //   // ===== Permissions =====
// // // // // // // // // //   Map<String, List<Map<String, dynamic>>> permissionCategories = {};
// // // // // // // // // //   Map<String, bool> permissionStates = {};
// // // // // // // // // //
// // // // // // // // // //   // ===== Sidebar =====
// // // // // // // // // //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {
// // // // // // // // // //     "Dashboard": [
// // // // // // // // // //       {"key": "dashboard", "label": "Dashboard"},
// // // // // // // // // //     ],
// // // // // // // // // //     "Users": [
// // // // // // // // // //       {"key": "users", "label": "Users"},
// // // // // // // // // //       {"key": "roles", "label": "Roles"},
// // // // // // // // // //     ],
// // // // // // // // // //     "Settings": [
// // // // // // // // // //       {"key": "settings", "label": "Settings"},
// // // // // // // // // //     ],
// // // // // // // // // //   };
// // // // // // // // // //
// // // // // // // // // //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// // // // // // // // // //
// // // // // // // // // //   // ===== Token Helper =====
// // // // // // // // // //   Future<String?> _getToken() async {
// // // // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // // // //     return prefs.getString('accessToken');
// // // // // // // // // //   }
// // // // // // // // // //
// // // // // // // // // //   // ===== Roles CRUD =====
// // // // // // // // // //   Future<void> fetchRoles() async {
// // // // // // // // // //     isLoading = true;
// // // // // // // // // //     notifyListeners();
// // // // // // // // // //     try {
// // // // // // // // // //       final token = await _getToken();
// // // // // // // // // //       final res = await http.get(
// // // // // // // // // //         Uri.parse('$baseUrl/api/roles'),
// // // // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // // // //       );
// // // // // // // // // //
// // // // // // // // // //       debugPrint("📡 fetchRoles → ${res.statusCode} :: ${res.body}");
// // // // // // // // // //
// // // // // // // // // //       if (res.statusCode == 200) {
// // // // // // // // // //         roles = json.decode(res.body);
// // // // // // // // // //       }
// // // // // // // // // //     } catch (e) {
// // // // // // // // // //       debugPrint("❌ fetchRoles error: $e");
// // // // // // // // // //     }
// // // // // // // // // //     isLoading = false;
// // // // // // // // // //     notifyListeners();
// // // // // // // // // //   }
// // // // // // // // // //
// // // // // // // // // //   Future<bool> createRole(String name) async {
// // // // // // // // // //     try {
// // // // // // // // // //       final token = await _getToken();
// // // // // // // // // //       final res = await http.post(
// // // // // // // // // //         Uri.parse('$baseUrl/api/roles'),
// // // // // // // // // //         headers: {
// // // // // // // // // //           'Authorization': 'Bearer $token',
// // // // // // // // // //           'Content-Type': 'application/json',
// // // // // // // // // //         },
// // // // // // // // // //         body: json.encode({'name': name}),
// // // // // // // // // //       );
// // // // // // // // // //
// // // // // // // // // //       debugPrint("📡 createRole → ${res.statusCode} :: ${res.body}");
// // // // // // // // // //
// // // // // // // // // //       if (res.statusCode == 201) {
// // // // // // // // // //         await fetchRoles();
// // // // // // // // // //         return true;
// // // // // // // // // //       }
// // // // // // // // // //     } catch (e) {
// // // // // // // // // //       debugPrint("❌ createRole error: $e");
// // // // // // // // // //     }
// // // // // // // // // //     return false;
// // // // // // // // // //   }
// // // // // // // // // //
// // // // // // // // // //   Future<bool> deleteRole(String id) async {
// // // // // // // // // //     try {
// // // // // // // // // //       final token = await _getToken();
// // // // // // // // // //       final res = await http.delete(
// // // // // // // // // //         Uri.parse('$baseUrl/api/roles/$id'),
// // // // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // // // //       );
// // // // // // // // // //
// // // // // // // // // //       debugPrint("📡 deleteRole → ${res.statusCode} :: ${res.body}");
// // // // // // // // // //
// // // // // // // // // //       if (res.statusCode == 200) {
// // // // // // // // // //         roles.removeWhere((r) => r['_id'] == id);
// // // // // // // // // //         notifyListeners();
// // // // // // // // // //         return true;
// // // // // // // // // //       }
// // // // // // // // // //     } catch (e) {
// // // // // // // // // //       debugPrint("❌ deleteRole error: $e");
// // // // // // // // // //     }
// // // // // // // // // //     return false;
// // // // // // // // // //   }
// // // // // // // // // //
// // // // // // // // // //   // ===== Sidebar Permissions =====
// // // // // // // // // //
// // // // // // // // // //   Future<void> refreshRole(String roleId) async {
// // // // // // // // // //     isLoading = true;
// // // // // // // // // //     notifyListeners();
// // // // // // // // // //     try {
// // // // // // // // // //       final token = await _getToken();
// // // // // // // // // //       final res = await http.get(
// // // // // // // // // //         Uri.parse('$baseUrl/api/roles/$roleId'),
// // // // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // // // //       );
// // // // // // // // // //
// // // // // // // // // //       debugPrint("📡 refreshRole($roleId) → ${res.statusCode} :: ${res.body}");
// // // // // // // // // //
// // // // // // // // // //       if (res.statusCode == 200) {
// // // // // // // // // //         final data = json.decode(res.body);
// // // // // // // // // //         Map<String, dynamic> sidebar = data['sidebarPermissions'] ?? {};
// // // // // // // // // //
// // // // // // // // // //         sidebarPermissionStates = {};
// // // // // // // // // //         for (var entry in sidebar.entries) {
// // // // // // // // // //           sidebarPermissionStates[entry.key] = {
// // // // // // // // // //             'view': entry.value['view'] ?? false,
// // // // // // // // // //             'read': entry.value['read'] ?? false,
// // // // // // // // // //             'manage': entry.value['manage'] ?? false,
// // // // // // // // // //           };
// // // // // // // // // //         }
// // // // // // // // // //       }
// // // // // // // // // //     } catch (e) {
// // // // // // // // // //       debugPrint("❌ refreshRole error: $e");
// // // // // // // // // //     }
// // // // // // // // // //     isLoading = false;
// // // // // // // // // //     notifyListeners();
// // // // // // // // // //   }
// // // // // // // // // //
// // // // // // // // // //   void toggleSidebarPermission(String key, String perm, bool value) {
// // // // // // // // // //     sidebarPermissionStates[key] ??= {'view': false, 'read': false, 'manage': false};
// // // // // // // // // //     sidebarPermissionStates[key]![perm] = value;
// // // // // // // // // //     debugPrint("🔄 toggleSidebarPermission($key, $perm) → $value");
// // // // // // // // // //     notifyListeners();
// // // // // // // // // //   }
// // // // // // // // // //
// // // // // // // // // //   bool getSidebarAll(String key) {
// // // // // // // // // //     final perms = sidebarPermissionStates[key] ?? {};
// // // // // // // // // //     return (perms['view'] ?? false) &&
// // // // // // // // // //         (perms['read'] ?? false) &&
// // // // // // // // // //         (perms['manage'] ?? false);
// // // // // // // // // //   }
// // // // // // // // // //
// // // // // // // // // //   void toggleSidebarAll(String key, bool value) {
// // // // // // // // // //     sidebarPermissionStates[key] = {
// // // // // // // // // //       'view': value,
// // // // // // // // // //       'read': value,
// // // // // // // // // //       'manage': value,
// // // // // // // // // //     };
// // // // // // // // // //     debugPrint("🔄 toggleSidebarAll($key) → $value");
// // // // // // // // // //     notifyListeners();
// // // // // // // // // //   }
// // // // // // // // // //
// // // // // // // // // //   Future<bool> updateSidebarPermissions() async {
// // // // // // // // // //     try {
// // // // // // // // // //       final token = await _getToken();
// // // // // // // // // //       final res = await http.put(
// // // // // // // // // //         Uri.parse('$baseUrl/api/roles/sidebar'),
// // // // // // // // // //         headers: {
// // // // // // // // // //           'Authorization': 'Bearer $token',
// // // // // // // // // //           'Content-Type': 'application/json',
// // // // // // // // // //         },
// // // // // // // // // //         body: json.encode({'permissions': sidebarPermissionStates}),
// // // // // // // // // //       );
// // // // // // // // // //
// // // // // // // // // //       debugPrint("📡 updateSidebarPermissions → ${res.statusCode} :: ${res.body}");
// // // // // // // // // //
// // // // // // // // // //       return res.statusCode == 200;
// // // // // // // // // //     } catch (e) {
// // // // // // // // // //       debugPrint("❌ updateSidebarPermissions error: $e");
// // // // // // // // // //       return false;
// // // // // // // // // //     }
// // // // // // // // // //   }
// // // // // // // // // // }
// // // // // // // // //
// // // // // // // // //
// // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // import 'package:http/http.dart' as http;
// // // // // // // // // import 'dart:convert';
// // // // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // // // // import 'package:ancilmediaadminpanel/environmental variables.dart';
// // // // // // // // //
// // // // // // // // // class RolesController extends ChangeNotifier {
// // // // // // // // //   bool isLoading = true;
// // // // // // // // //
// // // // // // // // //   // Roles
// // // // // // // // //   List<Map<String, dynamic>> roles = [];
// // // // // // // // //
// // // // // // // // //   // Permissions
// // // // // // // // //   Map<String, List<Map<String, dynamic>>> permissionCategories = {};
// // // // // // // // //   Map<String, bool> permissionStates = {};
// // // // // // // // //
// // // // // // // // //   // Sidebar
// // // // // // // // //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
// // // // // // // // //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// // // // // // // // //
// // // // // // // // //   // ================= TOKEN =================
// // // // // // // // //   Future<String?> _getToken() async {
// // // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // // //     return prefs.getString("accessToken");
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   // ================= ROLES =================
// // // // // // // // //   Future<void> fetchRoles() async {
// // // // // // // // //     isLoading = true;
// // // // // // // // //     notifyListeners();
// // // // // // // // //     try {
// // // // // // // // //       final token = await _getToken();
// // // // // // // // //       final res = await http.get(
// // // // // // // // //         Uri.parse('$baseUrl/api/roles'),
// // // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // // //       );
// // // // // // // // //
// // // // // // // // //       debugPrint("📡 fetchRoles → ${res.statusCode} :: ${res.body}");
// // // // // // // // //
// // // // // // // // //       if (res.statusCode == 200) {
// // // // // // // // //         roles = List<Map<String, dynamic>>.from(json.decode(res.body));
// // // // // // // // //       }
// // // // // // // // //     } catch (e) {
// // // // // // // // //       debugPrint("❌ fetchRoles error: $e");
// // // // // // // // //     }
// // // // // // // // //     isLoading = false;
// // // // // // // // //     notifyListeners();
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   // ================= PERMISSIONS =================
// // // // // // // // //   Future<void> fetchPermissions(String roleId) async {
// // // // // // // // //     isLoading = true;
// // // // // // // // //     notifyListeners();
// // // // // // // // //     try {
// // // // // // // // //       final token = await _getToken();
// // // // // // // // //       final res = await http.get(
// // // // // // // // //         Uri.parse('$baseUrl/api/permissions/$roleId'),
// // // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // // //       );
// // // // // // // // //
// // // // // // // // //       debugPrint("📡 fetchPermissions($roleId) → ${res.statusCode} :: ${res.body}");
// // // // // // // // //
// // // // // // // // //       if (res.statusCode == 200) {
// // // // // // // // //         final data = json.decode(res.body);
// // // // // // // // //
// // // // // // // // //         permissionCategories = {};
// // // // // // // // //         permissionStates = {};
// // // // // // // // //
// // // // // // // // //         for (var item in data['permissions']) {
// // // // // // // // //           String category = item['category'] ?? "General";
// // // // // // // // //           permissionCategories[category] ??= [];
// // // // // // // // //           permissionCategories[category]!.add(item);
// // // // // // // // //
// // // // // // // // //           permissionStates[item['key']] = item['value'] ?? false;
// // // // // // // // //         }
// // // // // // // // //       }
// // // // // // // // //     } catch (e) {
// // // // // // // // //       debugPrint("❌ fetchPermissions error: $e");
// // // // // // // // //     }
// // // // // // // // //     isLoading = false;
// // // // // // // // //     notifyListeners();
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   void togglePermission(String key) {
// // // // // // // // //     permissionStates[key] = !(permissionStates[key] ?? false);
// // // // // // // // //     notifyListeners();
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   // ================= SIDEBAR =================
// // // // // // // // //   Future<void> fetchSidebarForRole(String roleId) async {
// // // // // // // // //     isLoading = true;
// // // // // // // // //     notifyListeners();
// // // // // // // // //     try {
// // // // // // // // //       final token = await _getToken();
// // // // // // // // //
// // // // // // // // //       // 🔹 Get logged-in role
// // // // // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // // // // //       final loggedInRole = prefs.getString("role")?.toLowerCase();
// // // // // // // // //       final isAdmin = loggedInRole == "admin";
// // // // // // // // //
// // // // // // // // //       final res = await http.get(
// // // // // // // // //         Uri.parse('$baseUrl/api/sidebar/$roleId'),
// // // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // // //       );
// // // // // // // // //
// // // // // // // // //       debugPrint("📡 fetchSidebarForRole($roleId) → ${res.statusCode} :: ${res.body}");
// // // // // // // // //
// // // // // // // // //       if (res.statusCode == 200) {
// // // // // // // // //         final data = json.decode(res.body);
// // // // // // // // //
// // // // // // // // //         List items = data['items'] ?? [];
// // // // // // // // //         List permissions = data['sidebarPermissions'] ?? [];
// // // // // // // // //
// // // // // // // // //         sidebarCategories = {};
// // // // // // // // //         sidebarPermissionStates = {};
// // // // // // // // //
// // // // // // // // //         for (var item in items) {
// // // // // // // // //           String category = "Default"; // or item['category']
// // // // // // // // //           String key = item['key'];
// // // // // // // // //           String label = item['label'];
// // // // // // // // //
// // // // // // // // //           sidebarCategories[category] ??= [];
// // // // // // // // //           sidebarCategories[category]!.add({
// // // // // // // // //             "key": key,
// // // // // // // // //             "label": label,
// // // // // // // // //             "icon": item['icon'] ?? "",
// // // // // // // // //           });
// // // // // // // // //
// // // // // // // // //           // ================= RULE =================
// // // // // // // // //           if (isAdmin) {
// // // // // // // // //             // Admin → show all items (with toggles, default = false if not set)
// // // // // // // // //             var match = permissions.firstWhere(
// // // // // // // // //                   (p) => p['key'] == key,
// // // // // // // // //               orElse: () => null,
// // // // // // // // //             );
// // // // // // // // //
// // // // // // // // //             sidebarPermissionStates[key] = {
// // // // // // // // //               'view': match?['permissions']?['view'] ?? false,
// // // // // // // // //               'read': match?['permissions']?['read'] ?? false,
// // // // // // // // //               'manage': match?['permissions']?['manage'] ?? false,
// // // // // // // // //             };
// // // // // // // // //           } else {
// // // // // // // // //             // Non-admin → only show items with explicit permissions
// // // // // // // // //             var match = permissions.firstWhere(
// // // // // // // // //                   (p) => p['key'] == key,
// // // // // // // // //               orElse: () => null,
// // // // // // // // //             );
// // // // // // // // //
// // // // // // // // //             if (match != null) {
// // // // // // // // //               sidebarPermissionStates[key] = {
// // // // // // // // //                 'view': match['permissions']?['view'] ?? false,
// // // // // // // // //                 'read': match['permissions']?['read'] ?? false,
// // // // // // // // //                 'manage': match['permissions']?['manage'] ?? false,
// // // // // // // // //               };
// // // // // // // // //             }
// // // // // // // // //           }
// // // // // // // // //         }
// // // // // // // // //       }
// // // // // // // // //     } catch (e) {
// // // // // // // // //       debugPrint("❌ fetchSidebarForRole error: $e");
// // // // // // // // //     }
// // // // // // // // //     isLoading = false;
// // // // // // // // //     notifyListeners();
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //
// // // // // // // // //   void toggleSidebarPermission(String key, String type) {
// // // // // // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // // // // // //       sidebarPermissionStates[key]![type] =
// // // // // // // // //       !(sidebarPermissionStates[key]![type] ?? false);
// // // // // // // // //       notifyListeners();
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   bool getSidebarAll(String key) {
// // // // // // // // //     if (!sidebarPermissionStates.containsKey(key)) return false;
// // // // // // // // //     return sidebarPermissionStates[key]!.values.every((v) => v);
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   void toggleSidebarAll(String key, bool value) {
// // // // // // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // // // // // //       sidebarPermissionStates[key] = {
// // // // // // // // //         'view': value,
// // // // // // // // //         'read': value,
// // // // // // // // //         'manage': value,
// // // // // // // // //       };
// // // // // // // // //       notifyListeners();
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   Future<void> updateSidebarPermissions(String roleId) async {
// // // // // // // // //     try {
// // // // // // // // //       final token = await _getToken();
// // // // // // // // //       final payload = {
// // // // // // // // //         "sidebarPermissions": sidebarPermissionStates.entries.map((e) {
// // // // // // // // //           return {
// // // // // // // // //             "key": e.key,
// // // // // // // // //             "permissions": e.value,
// // // // // // // // //           };
// // // // // // // // //         }).toList(),
// // // // // // // // //       };
// // // // // // // // //
// // // // // // // // //       debugPrint("📤 updateSidebarPermissions payload: ${json.encode(payload)}");
// // // // // // // // //
// // // // // // // // //       final res = await http.put(
// // // // // // // // //         Uri.parse('$baseUrl/api/sidebar/$roleId'),
// // // // // // // // //         headers: {
// // // // // // // // //           'Authorization': 'Bearer $token',
// // // // // // // // //           'Content-Type': 'application/json',
// // // // // // // // //         },
// // // // // // // // //         body: json.encode(payload),
// // // // // // // // //       );
// // // // // // // // //
// // // // // // // // //       debugPrint("📡 updateSidebarPermissions → ${res.statusCode} :: ${res.body}");
// // // // // // // // //     } catch (e) {
// // // // // // // // //       debugPrint("❌ updateSidebarPermissions error: $e");
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // // }
// // // // // // // //
// // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // import 'package:http/http.dart' as http;
// // // // // // // // import 'dart:convert';
// // // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // // // import 'package:ancilmediaadminpanel/environmental variables.dart';
// // // // // // // //
// // // // // // // // class RolesController extends ChangeNotifier {
// // // // // // // //   bool isLoading = true;
// // // // // // // //
// // // // // // // //   // Roles
// // // // // // // //   List<Map<String, dynamic>> roles = [];
// // // // // // // //
// // // // // // // //   // Permissions
// // // // // // // //   Map<String, List<Map<String, dynamic>>> permissionCategories = {};
// // // // // // // //   Map<String, bool> permissionStates = {};
// // // // // // // //
// // // // // // // //   // Sidebar
// // // // // // // //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
// // // // // // // //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// // // // // // // //
// // // // // // // //   // ================= TOKEN =================
// // // // // // // //   Future<String?> _getToken() async {
// // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // //     return prefs.getString("accessToken");
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   // ================= ROLES =================
// // // // // // // //   Future<void> fetchRoles() async {
// // // // // // // //     isLoading = true;
// // // // // // // //     notifyListeners();
// // // // // // // //     try {
// // // // // // // //       final token = await _getToken();
// // // // // // // //       final res = await http.get(
// // // // // // // //         Uri.parse('$baseUrl/api/roles'),
// // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // //       );
// // // // // // // //
// // // // // // // //       debugPrint("📡 fetchRoles → ${res.statusCode} :: ${res.body}");
// // // // // // // //
// // // // // // // //       if (res.statusCode == 200) {
// // // // // // // //         roles = List<Map<String, dynamic>>.from(json.decode(res.body));
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       debugPrint("❌ fetchRoles error: $e");
// // // // // // // //     }
// // // // // // // //     isLoading = false;
// // // // // // // //     notifyListeners();
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   // ================= PERMISSIONS =================
// // // // // // // //   Future<void> fetchPermissions(String roleId) async {
// // // // // // // //     isLoading = true;
// // // // // // // //     notifyListeners();
// // // // // // // //     try {
// // // // // // // //       final token = await _getToken();
// // // // // // // //       final res = await http.get(
// // // // // // // //         Uri.parse('$baseUrl/api/permissions/$roleId'),
// // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // //       );
// // // // // // // //
// // // // // // // //       debugPrint("📡 fetchPermissions($roleId) → ${res.statusCode} :: ${res.body}");
// // // // // // // //
// // // // // // // //       if (res.statusCode == 200) {
// // // // // // // //         final data = json.decode(res.body);
// // // // // // // //
// // // // // // // //         permissionCategories = {};
// // // // // // // //         permissionStates = {};
// // // // // // // //
// // // // // // // //         for (var item in data['permissions']) {
// // // // // // // //           String category = item['category'] ?? "General";
// // // // // // // //           permissionCategories[category] ??= [];
// // // // // // // //           permissionCategories[category]!.add(item);
// // // // // // // //
// // // // // // // //           permissionStates[item['key']] = item['value'] ?? false;
// // // // // // // //         }
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       debugPrint("❌ fetchPermissions error: $e");
// // // // // // // //     }
// // // // // // // //     isLoading = false;
// // // // // // // //     notifyListeners();
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   void togglePermission(String key) {
// // // // // // // //     permissionStates[key] = !(permissionStates[key] ?? false);
// // // // // // // //     notifyListeners();
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   // ================= SIDEBAR =================
// // // // // // // //   Future<void> fetchSidebarForRole(String roleId, {bool forceAll = false}) async {
// // // // // // // //     isLoading = true;
// // // // // // // //     notifyListeners();
// // // // // // // //     try {
// // // // // // // //       final token = await _getToken();
// // // // // // // //
// // // // // // // //       // 🔹 First, get logged-in user role from SharedPreferences
// // // // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // // // //       final loggedInRole = prefs.getString("userRole") ?? ""; // store userRole on login
// // // // // // // //
// // // // // // // //       final res = await http.get(
// // // // // // // //         Uri.parse('$baseUrl/api/sidebar/$roleId'),
// // // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // // //       );
// // // // // // // //
// // // // // // // //       debugPrint("📡 fetchSidebarForRole($roleId as $loggedInRole) → ${res.statusCode} :: ${res.body}");
// // // // // // // //
// // // // // // // //       if (res.statusCode == 200) {
// // // // // // // //         final data = json.decode(res.body);
// // // // // // // //
// // // // // // // //         List items = data['items'] ?? [];
// // // // // // // //         List permissions = data['sidebarPermissions'] ?? [];
// // // // // // // //
// // // // // // // //         // 🔹 If logged in user is ADMIN → ignore role’s items and fetch all sidebar items
// // // // // // // //         if (loggedInRole == "admin") {
// // // // // // // //           final allRes = await http.get(
// // // // // // // //             Uri.parse('$baseUrl/api/sidebar/all'),
// // // // // // // //             headers: {'Authorization': 'Bearer $token'},
// // // // // // // //           );
// // // // // // // //
// // // // // // // //           if (allRes.statusCode == 200) {
// // // // // // // //             final allData = json.decode(allRes.body);
// // // // // // // //             items = allData['items'] ?? [];
// // // // // // // //           }
// // // // // // // //         }
// // // // // // // //
// // // // // // // //         sidebarCategories = {};
// // // // // // // //         sidebarPermissionStates = {};
// // // // // // // //
// // // // // // // //         for (var item in items) {
// // // // // // // //           String category = "Default";
// // // // // // // //           String key = item['key'];
// // // // // // // //           String label = item['label'];
// // // // // // // //
// // // // // // // //           sidebarCategories[category] ??= [];
// // // // // // // //           sidebarCategories[category]!.add({
// // // // // // // //             "key": key,
// // // // // // // //             "label": label,
// // // // // // // //             "icon": item['icon'] ?? "",
// // // // // // // //           });
// // // // // // // //
// // // // // // // //           var match = permissions.firstWhere(
// // // // // // // //                 (p) => p['key'] == key,
// // // // // // // //             orElse: () => null,
// // // // // // // //           );
// // // // // // // //
// // // // // // // //           sidebarPermissionStates[key] = {
// // // // // // // //             'view': match?['permissions']?['view'] ?? false,
// // // // // // // //             'read': match?['permissions']?['read'] ?? false,
// // // // // // // //             'manage': match?['permissions']?['manage'] ?? false,
// // // // // // // //           };
// // // // // // // //         }
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       debugPrint("❌ fetchSidebarForRole error: $e");
// // // // // // // //     }
// // // // // // // //     isLoading = false;
// // // // // // // //     notifyListeners();
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   void toggleSidebarPermission(String key, String type) {
// // // // // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // // // // //       sidebarPermissionStates[key]![type] =
// // // // // // // //       !(sidebarPermissionStates[key]![type] ?? false);
// // // // // // // //       notifyListeners();
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   bool getSidebarAll(String key) {
// // // // // // // //     if (!sidebarPermissionStates.containsKey(key)) return false;
// // // // // // // //     return sidebarPermissionStates[key]!.values.every((v) => v);
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   void toggleSidebarAll(String key, bool value) {
// // // // // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // // // // //       sidebarPermissionStates[key] = {
// // // // // // // //         'view': value,
// // // // // // // //         'read': value,
// // // // // // // //         'manage': value,
// // // // // // // //       };
// // // // // // // //       notifyListeners();
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Future<void> updateSidebarPermissions(String roleId) async {
// // // // // // // //     try {
// // // // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // // // //       final token = prefs.getString('accessToken');
// // // // // // // //       if (token == null) return;
// // // // // // // //
// // // // // // // //       final sidebar = sidebarPermissionStates.entries.map((entry) {
// // // // // // // //         return {
// // // // // // // //           "key": entry.key,
// // // // // // // //           "permissions": {
// // // // // // // //             "view": entry.value["view"] ?? false,
// // // // // // // //             "read": entry.value["read"] ?? false,
// // // // // // // //             "manage": entry.value["manage"] ?? false,
// // // // // // // //           }
// // // // // // // //         };
// // // // // // // //       }).toList();
// // // // // // // //
// // // // // // // //       final res = await http.put(
// // // // // // // //         Uri.parse('$baseUrl/api/sidebar/assign/$roleId'), // 👈 correct endpoint
// // // // // // // //         headers: {
// // // // // // // //           'Content-Type': 'application/json',
// // // // // // // //           'Authorization': 'Bearer $token',
// // // // // // // //         },
// // // // // // // //         body: json.encode({"sidebar": sidebar}),
// // // // // // // //       );
// // // // // // // //
// // // // // // // //       if (res.statusCode == 200) {
// // // // // // // //         debugPrint("✅ Sidebar permissions updated for $roleId");
// // // // // // // //       } else {
// // // // // // // //         debugPrint("❌ Failed: ${res.statusCode} :: ${res.body}");
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       debugPrint("⚠️ updateSidebarPermissions error: $e");
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // // }
// // // // // // //
// // // // // // //
// // // // // // // import 'package:flutter/material.dart';
// // // // // // // import 'package:http/http.dart' as http;
// // // // // // // import 'dart:convert';
// // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // // import 'package:ancilmediaadminpanel/environmental variables.dart';
// // // // // // //
// // // // // // // class RolesController extends ChangeNotifier {
// // // // // // //   bool isLoading = true;
// // // // // // //
// // // // // // //   // Roles
// // // // // // //   List<Map<String, dynamic>> roles = [];
// // // // // // //
// // // // // // //   // Permissions
// // // // // // //   Map<String, List<Map<String, dynamic>>> permissionCategories = {};
// // // // // // //   Map<String, bool> permissionStates = {};
// // // // // // //
// // // // // // //   // Sidebar
// // // // // // //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
// // // // // // //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// // // // // // //
// // // // // // //   // ================= TOKEN =================
// // // // // // //   Future<String?> _getToken() async {
// // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // //     return prefs.getString("accessToken");
// // // // // // //   }
// // // // // // //
// // // // // // //   // ================= ROLES =================
// // // // // // //   Future<void> fetchRoles() async {
// // // // // // //     isLoading = true;
// // // // // // //     notifyListeners();
// // // // // // //     try {
// // // // // // //       final token = await _getToken();
// // // // // // //       final res = await http.get(
// // // // // // //         Uri.parse('$baseUrl/api/roles'),
// // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // //       );
// // // // // // //
// // // // // // //       debugPrint("📡 fetchRoles → ${res.statusCode} :: ${res.body}");
// // // // // // //
// // // // // // //       if (res.statusCode == 200) {
// // // // // // //         roles = List<Map<String, dynamic>>.from(json.decode(res.body));
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint("❌ fetchRoles error: $e");
// // // // // // //     }
// // // // // // //     isLoading = false;
// // // // // // //     notifyListeners();
// // // // // // //   }
// // // // // // //
// // // // // // //   // ================= PERMISSIONS =================
// // // // // // //   Future<void> fetchPermissions(String roleId) async {
// // // // // // //     isLoading = true;
// // // // // // //     notifyListeners();
// // // // // // //     try {
// // // // // // //       final token = await _getToken();
// // // // // // //       final res = await http.get(
// // // // // // //         Uri.parse('$baseUrl/api/permissions/$roleId'),
// // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // //       );
// // // // // // //
// // // // // // //       debugPrint("📡 fetchPermissions($roleId) → ${res.statusCode} :: ${res.body}");
// // // // // // //
// // // // // // //       if (res.statusCode == 200) {
// // // // // // //         final data = json.decode(res.body);
// // // // // // //
// // // // // // //         permissionCategories = {};
// // // // // // //         permissionStates = {};
// // // // // // //
// // // // // // //         for (var item in data['permissions']) {
// // // // // // //           String category = item['category'] ?? "General";
// // // // // // //           permissionCategories[category] ??= [];
// // // // // // //           permissionCategories[category]!.add(item);
// // // // // // //
// // // // // // //           permissionStates[item['key']] = item['value'] ?? false;
// // // // // // //         }
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint("❌ fetchPermissions error: $e");
// // // // // // //     }
// // // // // // //     isLoading = false;
// // // // // // //     notifyListeners();
// // // // // // //   }
// // // // // // //
// // // // // // //   void togglePermission(String key) {
// // // // // // //     permissionStates[key] = !(permissionStates[key] ?? false);
// // // // // // //     notifyListeners();
// // // // // // //   }
// // // // // // //
// // // // // // //   // ================= SIDEBAR =================
// // // // // // //   Future<void> fetchSidebarForRole(String roleId, {bool forceAll = false}) async {
// // // // // // //     isLoading = true;
// // // // // // //     notifyListeners();
// // // // // // //     try {
// // // // // // //       final token = await _getToken();
// // // // // // //
// // // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // // //       final loggedInRole = prefs.getString("userRole") ?? "";
// // // // // // //
// // // // // // //       final res = await http.get(
// // // // // // //         Uri.parse('$baseUrl/api/sidebar/$roleId'),
// // // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // // //       );
// // // // // // //
// // // // // // //       debugPrint("📡 fetchSidebarForRole($roleId as $loggedInRole) → ${res.statusCode} :: ${res.body}");
// // // // // // //
// // // // // // //       if (res.statusCode == 200) {
// // // // // // //         final data = json.decode(res.body);
// // // // // // //
// // // // // // //         List items = data['items'] ?? [];
// // // // // // //         List permissions = data['sidebarPermissions'] ?? [];
// // // // // // //
// // // // // // //         if (loggedInRole == "admin") {
// // // // // // //           final allRes = await http.get(
// // // // // // //             Uri.parse('$baseUrl/api/sidebar/all'),
// // // // // // //             headers: {'Authorization': 'Bearer $token'},
// // // // // // //           );
// // // // // // //
// // // // // // //           if (allRes.statusCode == 200) {
// // // // // // //             final allData = json.decode(allRes.body);
// // // // // // //             items = allData['items'] ?? [];
// // // // // // //           }
// // // // // // //         }
// // // // // // //
// // // // // // //         sidebarCategories = {};
// // // // // // //         sidebarPermissionStates = {};
// // // // // // //
// // // // // // //         for (var item in items) {
// // // // // // //           String category = "Default";
// // // // // // //           String key = item['key'];
// // // // // // //           String label = item['label'];
// // // // // // //
// // // // // // //           sidebarCategories[category] ??= [];
// // // // // // //           sidebarCategories[category]!.add({
// // // // // // //             "key": key,
// // // // // // //             "label": label,
// // // // // // //             "icon": item['icon'] ?? "",
// // // // // // //           });
// // // // // // //
// // // // // // //           var match = permissions.firstWhere(
// // // // // // //                 (p) => p['key'] == key,
// // // // // // //             orElse: () => null,
// // // // // // //           );
// // // // // // //
// // // // // // //           sidebarPermissionStates[key] = {
// // // // // // //             'view': match?['permissions']?['view'] ?? false,
// // // // // // //             'read': match?['permissions']?['read'] ?? false,
// // // // // // //             'manage': match?['permissions']?['manage'] ?? false,
// // // // // // //           };
// // // // // // //         }
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint("❌ fetchSidebarForRole error: $e");
// // // // // // //     }
// // // // // // //     isLoading = false;
// // // // // // //     notifyListeners();
// // // // // // //   }
// // // // // // //
// // // // // // //   void toggleSidebarPermission(String key, String type) {
// // // // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // // // //       sidebarPermissionStates[key]![type] =
// // // // // // //       !(sidebarPermissionStates[key]![type] ?? false);
// // // // // // //       notifyListeners();
// // // // // // //     }
// // // // // // //   }
// // // // // // //
// // // // // // //   bool getSidebarAll(String key) {
// // // // // // //     if (!sidebarPermissionStates.containsKey(key)) return false;
// // // // // // //     return sidebarPermissionStates[key]!.values.every((v) => v);
// // // // // // //   }
// // // // // // //
// // // // // // //   void toggleSidebarAll(String key, bool value) {
// // // // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // // // //       sidebarPermissionStates[key] = {
// // // // // // //         'view': value,
// // // // // // //         'read': value,
// // // // // // //         'manage': value,
// // // // // // //       };
// // // // // // //       notifyListeners();
// // // // // // //     }
// // // // // // //   }
// // // // // // //
// // // // // // //   // ================= UPDATE ONLY MARKED =================
// // // // // // //   Future<void> updateSidebarPermissions(String roleId) async {
// // // // // // //     try {
// // // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // // //       final token = prefs.getString('accessToken');
// // // // // // //       if (token == null) return;
// // // // // // //
// // // // // // //       final sidebar = sidebarPermissionStates.entries
// // // // // // //           .where((entry) =>
// // // // // // //       (entry.value["view"] ?? false) ||
// // // // // // //           (entry.value["read"] ?? false) ||
// // // // // // //           (entry.value["manage"] ?? false))
// // // // // // //           .map((entry) {
// // // // // // //         return {
// // // // // // //           "key": entry.key,
// // // // // // //           "permissions": {
// // // // // // //             "view": entry.value["view"] ?? false,
// // // // // // //             "read": entry.value["read"] ?? false,
// // // // // // //             "manage": entry.value["manage"] ?? false,
// // // // // // //           }
// // // // // // //         };
// // // // // // //       }).toList();
// // // // // // //
// // // // // // //       final res = await http.put(
// // // // // // //         Uri.parse('$baseUrl/api/sidebar/assign/$roleId'),
// // // // // // //         headers: {
// // // // // // //           'Content-Type': 'application/json',
// // // // // // //           'Authorization': 'Bearer $token',
// // // // // // //         },
// // // // // // //         body: json.encode({"sidebar": sidebar}),
// // // // // // //       );
// // // // // // //
// // // // // // //       if (res.statusCode == 200) {
// // // // // // //         debugPrint("✅ Sidebar permissions updated for $roleId");
// // // // // // //       } else {
// // // // // // //         debugPrint("❌ Failed: ${res.statusCode} :: ${res.body}");
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint("⚠️ updateSidebarPermissions error: $e");
// // // // // // //     }
// // // // // // //   }
// // // // // // // }
// // // // // //
// // // // // //
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:http/http.dart' as http;
// // // // // // import 'dart:convert';
// // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // import 'package:ancilmediaadminpanel/environmental variables.dart';
// // // // // //
// // // // // // class RolesController extends ChangeNotifier {
// // // // // //   bool isLoading = true;
// // // // // //
// // // // // //   // Roles
// // // // // //   List<Map<String, dynamic>> roles = [];
// // // // // //
// // // // // //   // Permissions
// // // // // //   Map<String, List<Map<String, dynamic>>> permissionCategories = {};
// // // // // //   Map<String, bool> permissionStates = {};
// // // // // //
// // // // // //   // Sidebar
// // // // // //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
// // // // // //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// // // // // //
// // // // // //   // ================= TOKEN =================
// // // // // //   Future<String?> _getToken() async {
// // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // //     return prefs.getString("accessToken");
// // // // // //   }
// // // // // //
// // // // // //   // ================= ROLES =================
// // // // // //   Future<void> fetchRoles() async {
// // // // // //     isLoading = true;
// // // // // //     notifyListeners();
// // // // // //     try {
// // // // // //       final token = await _getToken();
// // // // // //       final res = await http.get(
// // // // // //         Uri.parse('$baseUrl/api/roles'),
// // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // //       );
// // // // // //
// // // // // //       debugPrint("📡 fetchRoles → ${res.statusCode} :: ${res.body}");
// // // // // //
// // // // // //       if (res.statusCode == 200) {
// // // // // //         roles = List<Map<String, dynamic>>.from(json.decode(res.body));
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       debugPrint("❌ fetchRoles error: $e");
// // // // // //     }
// // // // // //     isLoading = false;
// // // // // //     notifyListeners();
// // // // // //   }
// // // // // //
// // // // // //   // ================= PERMISSIONS =================
// // // // // //   Future<void> fetchPermissions(String roleId) async {
// // // // // //     isLoading = true;
// // // // // //     notifyListeners();
// // // // // //     try {
// // // // // //       final token = await _getToken();
// // // // // //       final res = await http.get(
// // // // // //         Uri.parse('$baseUrl/api/permissions/$roleId'),
// // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // //       );
// // // // // //
// // // // // //       debugPrint("📡 fetchPermissions($roleId) → ${res.statusCode} :: ${res.body}");
// // // // // //
// // // // // //       if (res.statusCode == 200) {
// // // // // //         final data = json.decode(res.body);
// // // // // //
// // // // // //         permissionCategories = {};
// // // // // //         permissionStates = {};
// // // // // //
// // // // // //         for (var item in data['permissions']) {
// // // // // //           String category = item['category'] ?? "General";
// // // // // //           permissionCategories[category] ??= [];
// // // // // //           permissionCategories[category]!.add(item);
// // // // // //
// // // // // //           permissionStates[item['key']] = item['value'] ?? false;
// // // // // //         }
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       debugPrint("❌ fetchPermissions error: $e");
// // // // // //     }
// // // // // //     isLoading = false;
// // // // // //     notifyListeners();
// // // // // //   }
// // // // // //
// // // // // //   void togglePermission(String key) {
// // // // // //     permissionStates[key] = !(permissionStates[key] ?? false);
// // // // // //     notifyListeners();
// // // // // //   }
// // // // // //
// // // // // //   // ================= SIDEBAR =================
// // // // // //   // Future<void> fetchSidebarForRole(String roleId, {bool forceAll = false}) async {
// // // // // //   //   isLoading = true;
// // // // // //   //   notifyListeners();
// // // // // //   //   try {
// // // // // //   //     final token = await _getToken();
// // // // // //   //
// // // // // //   //     final prefs = await SharedPreferences.getInstance();
// // // // // //   //     final loggedInRole = prefs.getString("userRole") ?? "";
// // // // // //   //
// // // // // //   //     final res = await http.get(
// // // // // //   //       Uri.parse('$baseUrl/api/sidebar/$roleId'),
// // // // // //   //       headers: {'Authorization': 'Bearer $token'},
// // // // // //   //     );
// // // // // //   //
// // // // // //   //     debugPrint("📡 fetchSidebarForRole($roleId as $loggedInRole) → ${res.statusCode} :: ${res.body}");
// // // // // //   //
// // // // // //   //     if (res.statusCode == 200) {
// // // // // //   //       final data = json.decode(res.body);
// // // // // //   //
// // // // // //   //       List items = data['items'] ?? [];
// // // // // //   //       List permissions = data['sidebarPermissions'] ?? [];
// // // // // //   //
// // // // // //   //       if (loggedInRole == "admin") {
// // // // // //   //         final allRes = await http.get(
// // // // // //   //           Uri.parse('$baseUrl/api/sidebar/all'),
// // // // // //   //           headers: {'Authorization': 'Bearer $token'},
// // // // // //   //         );
// // // // // //   //
// // // // // //   //         if (allRes.statusCode == 200) {
// // // // // //   //           final allData = json.decode(allRes.body);
// // // // // //   //           items = allData['items'] ?? [];
// // // // // //   //         }
// // // // // //   //       }
// // // // // //   //
// // // // // //   //       sidebarCategories = {};
// // // // // //   //       sidebarPermissionStates = {};
// // // // // //   //
// // // // // //   //       for (var item in items) {
// // // // // //   //         String category = "Default";
// // // // // //   //         String key = item['key'];
// // // // // //   //         String label = item['label'];
// // // // // //   //
// // // // // //   //         sidebarCategories[category] ??= [];
// // // // // //   //         sidebarCategories[category]!.add({
// // // // // //   //           "key": key,
// // // // // //   //           "label": label,
// // // // // //   //           "icon": item['icon'] ?? "",
// // // // // //   //         });
// // // // // //   //
// // // // // //   //         var match = permissions.firstWhere(
// // // // // //   //               (p) => p['key'] == key,
// // // // // //   //           orElse: () => null,
// // // // // //   //         );
// // // // // //   //
// // // // // //   //         sidebarPermissionStates[key] = {
// // // // // //   //           'view': match?['permissions']?['view'] ?? false,
// // // // // //   //           'read': match?['permissions']?['read'] ?? false,
// // // // // //   //           'manage': match?['permissions']?['manage'] ?? false,
// // // // // //   //         };
// // // // // //   //       }
// // // // // //   //     }
// // // // // //   //   } catch (e) {
// // // // // //   //     debugPrint("❌ fetchSidebarForRole error: $e");
// // // // // //   //   }
// // // // // //   //   isLoading = false;
// // // // // //   //   notifyListeners();
// // // // // //   // }
// // // // // //
// // // // // //   Future<void> fetchSidebarForRole(String roleId) async {
// // // // // //     isLoading = true;
// // // // // //     notifyListeners();
// // // // // //
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       final token = prefs.getString('token');
// // // // // //       final response = await http.get(
// // // // // //         Uri.parse('$baseUrl/role/$roleId'),
// // // // // //         headers: {'Authorization': 'Bearer $token'},
// // // // // //       );
// // // // // //
// // // // // //       if (response.statusCode == 200) {
// // // // // //         final data = jsonDecode(response.body);
// // // // // //
// // // // // //         sidebarCategories.clear();
// // // // // //         sidebarPermissionStates.clear();
// // // // // //
// // // // // //         if (data['sidebarPermissions'] != null) {
// // // // // //           for (var item in data['sidebarPermissions']) {
// // // // // //             String key = item['key'];
// // // // // //             sidebarPermissionStates[key] = {
// // // // // //               'view': item['permissions']?['view'] ?? false,
// // // // // //               'read': item['permissions']?['read'] ?? false,
// // // // // //               'manage': item['permissions']?['manage'] ?? false,
// // // // // //             };
// // // // // //
// // // // // //             // Group by category (or just one default if no category)
// // // // // //             sidebarCategories.putIfAbsent("Sidebar", () => []).add(item);
// // // // // //           }
// // // // // //         }
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       debugPrint("❌ fetchSidebarForRole error: $e");
// // // // // //     }
// // // // // //
// // // // // //     isLoading = false;
// // // // // //     notifyListeners();
// // // // // //   }
// // // // // //
// // // // // //   void _setLoading(bool value) {
// // // // // //     isLoading = value;
// // // // // //     notifyListeners();
// // // // // //   }
// // // // // //
// // // // // //   void toggleSidebarPermission(String key, String type) {
// // // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // // //       sidebarPermissionStates[key]![type] =
// // // // // //       !(sidebarPermissionStates[key]![type] ?? false);
// // // // // //       notifyListeners();
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   bool getSidebarAll(String key) {
// // // // // //     if (!sidebarPermissionStates.containsKey(key)) return false;
// // // // // //     return sidebarPermissionStates[key]!.values.every((v) => v);
// // // // // //   }
// // // // // //
// // // // // //   void toggleSidebarAll(String key, bool value) {
// // // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // // //       sidebarPermissionStates[key] = {
// // // // // //         'view': value,
// // // // // //         'read': value,
// // // // // //         'manage': value,
// // // // // //       };
// // // // // //       notifyListeners();
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   /// 🔹 NEW: Get only the marked sidebar items
// // // // // //   List<Map<String, dynamic>> getMarkedSidebarItems() {
// // // // // //     return sidebarPermissionStates.entries
// // // // // //         .where((entry) =>
// // // // // //         entry.value.values.any((v) => v == true)) // keep only items with at least 1 true
// // // // // //         .map((entry) {
// // // // // //       return {
// // // // // //         "key": entry.key,
// // // // // //         "permissions": {
// // // // // //           "view": entry.value["view"] ?? false,
// // // // // //           "read": entry.value["read"] ?? false,
// // // // // //           "manage": entry.value["manage"] ?? false,
// // // // // //         }
// // // // // //       };
// // // // // //     })
// // // // // //         .toList();
// // // // // //   }
// // // // // //
// // // // // //   /// 🔹 API update → Only send marked items
// // // // // //   Future<void> updateSidebarPermissions(String roleId) async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       final token = prefs.getString('accessToken');
// // // // // //       if (token == null) return;
// // // // // //
// // // // // //       final sidebar = getMarkedSidebarItems(); // ✅ send only marked
// // // // // //
// // // // // //       final res = await http.put(
// // // // // //         Uri.parse('$baseUrl/api/sidebar/assign/$roleId'),
// // // // // //         headers: {
// // // // // //           'Content-Type': 'application/json',
// // // // // //           'Authorization': 'Bearer $token',
// // // // // //         },
// // // // // //         body: json.encode({"sidebar": sidebar}),
// // // // // //       );
// // // // // //
// // // // // //       if (res.statusCode == 200) {
// // // // // //         debugPrint("✅ Sidebar permissions updated for $roleId");
// // // // // //       } else {
// // // // // //         debugPrint("❌ Failed: ${res.statusCode} :: ${res.body}");
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       debugPrint("⚠️ updateSidebarPermissions error: $e");
// // // // // //     }
// // // // // //   }
// // // // // // }
// // // // //
// // // // //
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:http/http.dart' as http;
// // // // // import 'dart:convert';
// // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // import 'package:ancilmediaadminpanel/environmental variables.dart';
// // // // //
// // // // // class RolesController extends ChangeNotifier {
// // // // //   bool isLoading = true;
// // // // //
// // // // //   // Roles list
// // // // //   List<Map<String, dynamic>> roles = [];
// // // // //
// // // // //   // Sidebar categories (grouped items)
// // // // //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
// // // // //
// // // // //   // Sidebar states: { "dashboard": {"view": true, "read": false, "manage": false} }
// // // // //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// // // // //
// // // // //   /// 🔹 Fetch all roles
// // // // //   Future<void> fetchRoles() async {
// // // // //     try {
// // // // //       isLoading = true;
// // // // //       notifyListeners();
// // // // //
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       final token = prefs.getString("token");
// // // // //
// // // // //       final response = await http.get(
// // // // //         Uri.parse("$baseUrl/roles"),
// // // // //         headers: {"Authorization": "Bearer $token"},
// // // // //       );
// // // // //
// // // // //       if (response.statusCode == 200) {
// // // // //         final data = jsonDecode(response.body);
// // // // //         roles = List<Map<String, dynamic>>.from(data);
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint("Error fetching roles: $e");
// // // // //     } finally {
// // // // //       isLoading = false;
// // // // //       notifyListeners();
// // // // //     }
// // // // //   }
// // // // //
// // // // //   /// 🔹 Fetch sidebar permissions for a specific role
// // // // //   Future<void> fetchSidebarForRole(String roleId) async {
// // // // //     try {
// // // // //       isLoading = true;
// // // // //       notifyListeners();
// // // // //
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       final token = prefs.getString("token");
// // // // //
// // // // //       final response = await http.get(
// // // // //         Uri.parse("$baseUrl/roles/$roleId/sidebar"),
// // // // //         headers: {"Authorization": "Bearer $token"},
// // // // //       );
// // // // //
// // // // //       if (response.statusCode == 200) {
// // // // //         final data = jsonDecode(response.body);
// // // // //
// // // // //         // Expected structure: { "Category": [ { key, label, permissions } ] }
// // // // //         sidebarCategories = {};
// // // // //         sidebarPermissionStates = {};
// // // // //
// // // // //         for (var category in data.keys) {
// // // // //           final items = List<Map<String, dynamic>>.from(data[category]);
// // // // //
// // // // //           sidebarCategories[category] = items;
// // // // //
// // // // //           for (var item in items) {
// // // // //             sidebarPermissionStates[item['key']] = {
// // // // //               "view": item["permissions"]["view"] ?? false,
// // // // //               "read": item["permissions"]["read"] ?? false,
// // // // //               "manage": item["permissions"]["manage"] ?? false,
// // // // //             };
// // // // //           }
// // // // //         }
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint("Error fetching sidebar: $e");
// // // // //     } finally {
// // // // //       isLoading = false;
// // // // //       notifyListeners();
// // // // //     }
// // // // //   }
// // // // //
// // // // //   /// 🔹 Toggle a single sidebar permission
// // // // //   void toggleSidebarPermission(String key, String permission) {
// // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // //       sidebarPermissionStates[key]![permission] =
// // // // //       !(sidebarPermissionStates[key]![permission] ?? false);
// // // // //       notifyListeners();
// // // // //     }
// // // // //   }
// // // // //
// // // // //   /// 🔹 Toggle all (view, read, manage) for an item
// // // // //   void toggleSidebarAll(String key, bool value) {
// // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // //       sidebarPermissionStates[key] = {
// // // // //         "view": value,
// // // // //         "read": value,
// // // // //         "manage": value,
// // // // //       };
// // // // //       notifyListeners();
// // // // //     }
// // // // //   }
// // // // //
// // // // //   /// 🔹 Get whether "All" should be checked
// // // // //   bool getSidebarAll(String key) {
// // // // //     if (!sidebarPermissionStates.containsKey(key)) return false;
// // // // //     final perms = sidebarPermissionStates[key]!;
// // // // //     return perms["view"] == true &&
// // // // //         perms["read"] == true &&
// // // // //         perms["manage"] == true;
// // // // //   }
// // // // //
// // // // //   /// 🔹 Update sidebar permissions in backend
// // // // //   Future<bool> updateSidebarPermissions(String roleId) async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       final token = prefs.getString("token");
// // // // //
// // // // //       final response = await http.put(
// // // // //         Uri.parse("$baseUrl/roles/$roleId/sidebar"),
// // // // //         headers: {
// // // // //           "Content-Type": "application/json",
// // // // //           "Authorization": "Bearer $token",
// // // // //         },
// // // // //         body: jsonEncode(sidebarPermissionStates),
// // // // //       );
// // // // //
// // // // //       if (response.statusCode == 200) {
// // // // //         return true; // ✅ success
// // // // //       } else {
// // // // //         debugPrint("Update failed: ${response.body}");
// // // // //         return false; // ❌ failure
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint("Error updating sidebar: $e");
// // // // //       return false;
// // // // //     }
// // // // //   }
// // // // // }
// // // // //
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:http/http.dart' as http;
// // // // // import 'dart:convert';
// // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // import 'package:ancilmediaadminpanel/environmental variables.dart';
// // // // //
// // // // // class RolesController extends ChangeNotifier {
// // // // //   bool isLoading = true;
// // // // //
// // // // //   // Roles list
// // // // //   List<Map<String, dynamic>> roles = [];
// // // // //
// // // // //   // Sidebar categories
// // // // //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
// // // // //
// // // // //   // Sidebar permissions state
// // // // //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// // // // //
// // // // //   /// 🔹 Fetch all roles
// // // // //   Future<void> fetchRoles() async {
// // // // //     try {
// // // // //       isLoading = true;
// // // // //       notifyListeners();
// // // // //
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       final token = prefs.getString("accessToken"); // ✅ FIXED
// // // // //
// // // // //       final response = await http.get(
// // // // //         Uri.parse("$baseUrl/api/roles"), // ✅ FIXED endpoint
// // // // //         headers: {"Authorization": "Bearer $token"},
// // // // //       );
// // // // //
// // // // //       if (response.statusCode == 200) {
// // // // //         final data = jsonDecode(response.body);
// // // // //         roles = List<Map<String, dynamic>>.from(data);
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint("Error fetching roles: $e");
// // // // //     } finally {
// // // // //       isLoading = false;
// // // // //       notifyListeners();
// // // // //     }
// // // // //   }
// // // // //
// // // // //   /// 🔹 Fetch sidebar for specific role
// // // // //   Future<void> fetchSidebarForRole(String roleId) async {
// // // // //     try {
// // // // //       isLoading = true;
// // // // //       notifyListeners();
// // // // //
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       final token = prefs.getString("accessToken");
// // // // //
// // // // //       final response = await http.get(
// // // // //         Uri.parse("$baseUrl/api/sidebar/$roleId"),
// // // // //         headers: {"Authorization": "Bearer $token"},
// // // // //       );
// // // // //
// // // // //       if (response.statusCode == 200) {
// // // // //         final data = jsonDecode(response.body);
// // // // //
// // // // //         sidebarCategories = {};
// // // // //         sidebarPermissionStates = {};
// // // // //
// // // // //         data.forEach((category, items) {
// // // // //           // ✅ Ensure items is always a list
// // // // //           if (items is List) {
// // // // //             sidebarCategories[category] =
// // // // //             List<Map<String, dynamic>>.from(items);
// // // // //
// // // // //             for (var item in items) {
// // // // //               sidebarPermissionStates[item['key']] = {
// // // // //                 "view": item["permissions"]?["view"] ?? false,
// // // // //                 "read": item["permissions"]?["read"] ?? false,
// // // // //                 "manage": item["permissions"]?["manage"] ?? false,
// // // // //               };
// // // // //             }
// // // // //           }
// // // // //         });
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint("Error fetching sidebar: $e");
// // // // //     } finally {
// // // // //       isLoading = false;
// // // // //       notifyListeners();
// // // // //     }
// // // // //   }
// // // // //
// // // // //   /// 🔹 Toggle a single permission
// // // // //   void toggleSidebarPermission(String key, String permission) {
// // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // //       sidebarPermissionStates[key]![permission] =
// // // // //       !(sidebarPermissionStates[key]![permission] ?? false);
// // // // //       notifyListeners();
// // // // //     }
// // // // //   }
// // // // //
// // // // //   /// 🔹 Toggle all for one item
// // // // //   void toggleSidebarAll(String key, bool value) {
// // // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // // //       sidebarPermissionStates[key] = {
// // // // //         "view": value,
// // // // //         "read": value,
// // // // //         "manage": value,
// // // // //       };
// // // // //       notifyListeners();
// // // // //     }
// // // // //   }
// // // // //
// // // // //   /// 🔹 Check if all are true
// // // // //   bool getSidebarAll(String key) {
// // // // //     if (!sidebarPermissionStates.containsKey(key)) return false;
// // // // //     final perms = sidebarPermissionStates[key]!;
// // // // //     return perms["view"] == true &&
// // // // //         perms["read"] == true &&
// // // // //         perms["manage"] == true;
// // // // //   }
// // // // //
// // // // //   /// 🔹 Save sidebar permissions
// // // // //   Future<bool> updateSidebarPermissions(String roleId) async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       final token = prefs.getString("accessToken");
// // // // //
// // // // //       // 🔹 Transform sidebarPermissionStates into a list
// // // // //       final List<Map<String, dynamic>> payload = sidebarPermissionStates.entries
// // // // //           .map((entry) => {
// // // // //         "key": entry.key,
// // // // //         "permissions": {
// // // // //           "view": entry.value["view"] ?? false,
// // // // //           "read": entry.value["read"] ?? false,
// // // // //           "manage": entry.value["manage"] ?? false,
// // // // //         }
// // // // //       })
// // // // //           .toList();
// // // // //
// // // // //       final response = await http.put(
// // // // //         Uri.parse("$baseUrl/api/sidebar/$roleId"),
// // // // //         headers: {
// // // // //           "Content-Type": "application/json",
// // // // //           "Authorization": "Bearer $token",
// // // // //         },
// // // // //         body: jsonEncode(payload),
// // // // //       );
// // // // //
// // // // //       if (response.statusCode == 200) {
// // // // //         return true;
// // // // //       } else {
// // // // //         debugPrint("Update failed: ${response.body}");
// // // // //         return false;
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint("Error updating sidebar: $e");
// // // // //       return false;
// // // // //     }
// // // // //   }
// // // // // }
// // // //
// // // //
// // // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'dart:convert';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import 'package:ancilmediaadminpanel/environmental variables.dart';
// // // //
// // // // class RolesController extends ChangeNotifier {
// // // //   bool isLoading = true;
// // // //
// // // //   // Roles
// // // //   List<Map<String, dynamic>> roles = [];
// // // //
// // // //   // Permissions
// // // //   Map<String, List<Map<String, dynamic>>> permissionCategories = {};
// // // //   Map<String, bool> permissionStates = {};
// // // //
// // // //   // Sidebar
// // // //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
// // // //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// // // //
// // // //   // ================= TOKEN =================
// // // //   Future<String?> _getToken() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     return prefs.getString("accessToken");
// // // //   }
// // // //
// // // //   // ================= ROLES =================
// // // //   Future<void> fetchRoles() async {
// // // //     isLoading = true;
// // // //     notifyListeners();
// // // //     try {
// // // //       final token = await _getToken();
// // // //       final res = await http.get(
// // // //         Uri.parse('$baseUrl/api/roles'),
// // // //         headers: {'Authorization': 'Bearer $token'},
// // // //       );
// // // //
// // // //       debugPrint("📡 fetchRoles → ${res.statusCode} :: ${res.body}");
// // // //
// // // //       if (res.statusCode == 200) {
// // // //         roles = List<Map<String, dynamic>>.from(json.decode(res.body));
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint("❌ fetchRoles error: $e");
// // // //     }
// // // //     isLoading = false;
// // // //     notifyListeners();
// // // //   }
// // // //
// // // //   // ================= PERMISSIONS =================
// // // //   Future<void> fetchPermissions(String roleId) async {
// // // //     isLoading = true;
// // // //     notifyListeners();
// // // //     try {
// // // //       final token = await _getToken();
// // // //       final res = await http.get(
// // // //         Uri.parse('$baseUrl/api/permissions/$roleId'),
// // // //         headers: {'Authorization': 'Bearer $token'},
// // // //       );
// // // //
// // // //       debugPrint("📡 fetchPermissions($roleId) → ${res.statusCode} :: ${res.body}");
// // // //
// // // //       if (res.statusCode == 200) {
// // // //         final data = json.decode(res.body);
// // // //
// // // //         permissionCategories = {};
// // // //         permissionStates = {};
// // // //
// // // //         for (var item in data['permissions']) {
// // // //           String category = item['category'] ?? "General";
// // // //           permissionCategories[category] ??= [];
// // // //           permissionCategories[category]!.add(item);
// // // //
// // // //           permissionStates[item['key']] = item['value'] ?? false;
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint("❌ fetchPermissions error: $e");
// // // //     }
// // // //     isLoading = false;
// // // //     notifyListeners();
// // // //   }
// // // //
// // // //   void togglePermission(String key) {
// // // //     permissionStates[key] = !(permissionStates[key] ?? false);
// // // //     notifyListeners();
// // // //   }
// // // //
// // // //   // ================= SIDEBAR =================
// // // //   Future<void> fetchSidebarForRole(String roleId) async {
// // // //     try {
// // // //       isLoading = true;
// // // //       notifyListeners();
// // // //
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       final token = prefs.getString("accessToken");
// // // //
// // // //       final response = await http.get(
// // // //         Uri.parse("$baseUrl/api/sidebar/$roleId"),
// // // //         headers: {"Authorization": "Bearer $token"},
// // // //       );
// // // //
// // // //       if (response.statusCode == 200) {
// // // //         final data = jsonDecode(response.body);
// // // //
// // // //         sidebarCategories = {};
// // // //         sidebarPermissionStates = {};
// // // //
// // // //         data.forEach((category, items) {
// // // //           // ✅ Ensure items is always a list
// // // //           if (items is List) {
// // // //             sidebarCategories[category] =
// // // //             List<Map<String, dynamic>>.from(items);
// // // //
// // // //             for (var item in items) {
// // // //               sidebarPermissionStates[item['key']] = {
// // // //                 "view": item["permissions"]?["view"] ?? false,
// // // //                 "read": item["permissions"]?["read"] ?? false,
// // // //                 "manage": item["permissions"]?["manage"] ?? false,
// // // //               };
// // // //             }
// // // //           }
// // // //         });
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint("Error fetching sidebar: $e");
// // // //     } finally {
// // // //       isLoading = false;
// // // //       notifyListeners();
// // // //     }
// // // //   }
// // // //
// // // //   void toggleSidebarPermission(String key, String type) {
// // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // //       sidebarPermissionStates[key]![type] =
// // // //       !(sidebarPermissionStates[key]![type] ?? false);
// // // //       notifyListeners();
// // // //     }
// // // //   }
// // // //
// // // //   bool getSidebarAll(String key) {
// // // //     if (!sidebarPermissionStates.containsKey(key)) return false;
// // // //     return sidebarPermissionStates[key]!.values.every((v) => v);
// // // //   }
// // // //
// // // //   void toggleSidebarAll(String key, bool value) {
// // // //     if (sidebarPermissionStates.containsKey(key)) {
// // // //       sidebarPermissionStates[key] = {
// // // //         'view': value,
// // // //         'read': value,
// // // //         'manage': value,
// // // //       };
// // // //       notifyListeners();
// // // //     }
// // // //   }
// // // //
// // // //   /// 🔹 NEW: Get only the marked sidebar items
// // // //   List<Map<String, dynamic>> getMarkedSidebarItems() {
// // // //     return sidebarPermissionStates.entries
// // // //         .where((entry) =>
// // // //         entry.value.values.any((v) => v == true)) // keep only items with at least 1 true
// // // //         .map((entry) {
// // // //       return {
// // // //         "key": entry.key,
// // // //         "permissions": {
// // // //           "view": entry.value["view"] ?? false,
// // // //           "read": entry.value["read"] ?? false,
// // // //           "manage": entry.value["manage"] ?? false,
// // // //         }
// // // //       };
// // // //     })
// // // //         .toList();
// // // //   }
// // // //
// // // //   /// 🔹 API update → Only send marked items
// // // //   Future<void> updateSidebarPermissions(String roleId) async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       final token = prefs.getString('accessToken');
// // // //       if (token == null) return;
// // // //
// // // //       final sidebar = getMarkedSidebarItems(); // ✅ send only marked
// // // //
// // // //       final res = await http.put(
// // // //         Uri.parse('$baseUrl/api/sidebar/assign/$roleId'),
// // // //         headers: {
// // // //           'Content-Type': 'application/json',
// // // //           'Authorization': 'Bearer $token',
// // // //         },
// // // //         body: json.encode({"sidebar": sidebar}),
// // // //       );
// // // //
// // // //       if (res.statusCode == 200) {
// // // //         debugPrint("✅ Sidebar permissions updated for $roleId");
// // // //       } else {
// // // //         debugPrint("❌ Failed: ${res.statusCode} :: ${res.body}");
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint("⚠️ updateSidebarPermissions error: $e");
// // // //     }
// // // //   }
// // // // }
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'dart:convert';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:ancilmediaadminpanel/environmental variables.dart';
// // //
// // // class RolesController extends ChangeNotifier {
// // //   // ================= LOADING FLAGS =================
// // //   bool isRolesLoading = false;
// // //   bool isPermissionsLoading = false;
// // //   bool isSidebarLoading = false;
// // //
// // //   // ================= ROLES =================
// // //   List<Map<String, dynamic>> roles = [];
// // //
// // //   // ================= PERMISSIONS =================
// // //   Map<String, List<Map<String, dynamic>>> permissionCategories = {};
// // //   Map<String, bool> permissionStates = {};
// // //
// // //   // ================= SIDEBAR =================
// // //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
// // //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// // //
// // //   // ================= TOKEN =================
// // //   Future<String?> _getToken() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     return prefs.getString("accessToken");
// // //   }
// // //
// // //   // ================= ROLES =================
// // //   Future<void> fetchRoles() async {
// // //     isRolesLoading = true;
// // //     notifyListeners();
// // //
// // //     try {
// // //       final token = await _getToken();
// // //       if (token == null) throw Exception("No token found");
// // //
// // //       final res = await http.get(
// // //         Uri.parse('$baseUrl/api/roles'),
// // //         headers: {'Authorization': 'Bearer $token'},
// // //       );
// // //
// // //       debugPrint("📡 fetchRoles → ${res.statusCode} :: ${res.body}");
// // //
// // //       if (res.statusCode == 200) {
// // //         roles = List<Map<String, dynamic>>.from(json.decode(res.body));
// // //       } else {
// // //         debugPrint("❌ Failed to fetch roles: ${res.body}");
// // //       }
// // //     } catch (e) {
// // //       debugPrint("❌ fetchRoles error: $e");
// // //     } finally {
// // //       isRolesLoading = false;
// // //       notifyListeners();
// // //     }
// // //   }
// // //
// // //   // ================= PERMISSIONS =================
// // //   Future<void> fetchPermissions(String roleId) async {
// // //     isPermissionsLoading = true;
// // //     notifyListeners();
// // //
// // //     try {
// // //       final token = await _getToken();
// // //       if (token == null) throw Exception("No token found");
// // //
// // //       final res = await http.get(
// // //         Uri.parse('$baseUrl/api/permissions/$roleId'),
// // //         headers: {'Authorization': 'Bearer $token'},
// // //       );
// // //
// // //       debugPrint("📡 fetchPermissions($roleId) → ${res.statusCode} :: ${res.body}");
// // //
// // //       if (res.statusCode == 200) {
// // //         final data = json.decode(res.body);
// // //
// // //         permissionCategories = {};
// // //         permissionStates = {};
// // //
// // //         for (var item in data['permissions']) {
// // //           String category = item['category'] ?? "General";
// // //           permissionCategories[category] ??= [];
// // //           permissionCategories[category]!.add(item);
// // //
// // //           permissionStates[item['key']] = item['value'] ?? false;
// // //         }
// // //       } else {
// // //         debugPrint("❌ Failed to fetch permissions: ${res.body}");
// // //       }
// // //     } catch (e) {
// // //       debugPrint("❌ fetchPermissions error: $e");
// // //     } finally {
// // //       isPermissionsLoading = false;
// // //       notifyListeners();
// // //     }
// // //   }
// // //
// // //   void togglePermission(String key) {
// // //     permissionStates[key] = !(permissionStates[key] ?? false);
// // //     notifyListeners();
// // //   }
// // //
// // //   // ================= SIDEBAR =================
// // //   Future<void> fetchSidebarForRole(String roleId) async {
// // //     isSidebarLoading = true;
// // //     notifyListeners();
// // //
// // //     try {
// // //       final token = await _getToken();
// // //       if (token == null) throw Exception("No token found");
// // //
// // //       final response = await http.get(
// // //         Uri.parse("$baseUrl/api/sidebar/$roleId"),
// // //         headers: {"Authorization": "Bearer $token"},
// // //       );
// // //
// // //       debugPrint("📡 fetchSidebarForRole($roleId) → ${response.statusCode} :: ${response.body}");
// // //
// // //       if (response.statusCode == 200) {
// // //         final data = jsonDecode(response.body);
// // //
// // //         sidebarCategories = {};
// // //         sidebarPermissionStates = {};
// // //
// // //         data.forEach((category, items) {
// // //           if (items is List) {
// // //             sidebarCategories[category] = List<Map<String, dynamic>>.from(items);
// // //
// // //             for (var item in items) {
// // //               sidebarPermissionStates[item['key']] = {
// // //                 "view": item["permissions"]?["view"] ?? false,
// // //                 "read": item["permissions"]?["read"] ?? false,
// // //                 "manage": item["permissions"]?["manage"] ?? false,
// // //               };
// // //             }
// // //           }
// // //         });
// // //       } else {
// // //         debugPrint("❌ Failed to fetch sidebar: ${response.body}");
// // //       }
// // //     } catch (e) {
// // //       debugPrint("❌ fetchSidebarForRole error: $e");
// // //     } finally {
// // //       isSidebarLoading = false;
// // //       notifyListeners();
// // //     }
// // //   }
// // //
// // //   void toggleSidebarPermission(String key, String type) {
// // //     if (sidebarPermissionStates.containsKey(key)) {
// // //       sidebarPermissionStates[key]![type] = !(sidebarPermissionStates[key]![type] ?? false);
// // //       notifyListeners();
// // //     }
// // //   }
// // //
// // //   bool getSidebarAll(String key) {
// // //     if (!sidebarPermissionStates.containsKey(key)) return false;
// // //     return sidebarPermissionStates[key]!.values.every((v) => v);
// // //   }
// // //
// // //   void toggleSidebarAll(String key, bool value) {
// // //     if (sidebarPermissionStates.containsKey(key)) {
// // //       sidebarPermissionStates[key] = {
// // //         'view': value,
// // //         'read': value,
// // //         'manage': value,
// // //       };
// // //       notifyListeners();
// // //     }
// // //   }
// // //
// // //   // ================= MARKED SIDEBAR =================
// // //   List<Map<String, dynamic>> getMarkedSidebarItems() {
// // //     return sidebarPermissionStates.entries
// // //         .where((entry) => entry.value.values.any((v) => v))
// // //         .map((entry) {
// // //       return {
// // //         "key": entry.key,
// // //         "permissions": {
// // //           "view": entry.value["view"] ?? false,
// // //           "read": entry.value["read"] ?? false,
// // //           "manage": entry.value["manage"] ?? false,
// // //         }
// // //       };
// // //     }).toList();
// // //   }
// // //
// // //   Future<void> updateSidebarPermissions(String roleId) async {
// // //     try {
// // //       final token = await _getToken();
// // //       if (token == null) return;
// // //
// // //       final sidebar = getMarkedSidebarItems();
// // //       if (sidebar.isEmpty) return; // skip if nothing changed
// // //
// // //       final res = await http.put(
// // //         Uri.parse('$baseUrl/api/sidebar/assign/$roleId'),
// // //         headers: {
// // //           'Content-Type': 'application/json',
// // //           'Authorization': 'Bearer $token',
// // //         },
// // //         body: json.encode({"sidebar": sidebar}),
// // //       );
// // //
// // //       if (res.statusCode == 200) {
// // //         debugPrint("✅ Sidebar permissions updated for $roleId");
// // //       } else {
// // //         debugPrint("❌ Failed to update sidebar: ${res.statusCode} :: ${res.body}");
// // //       }
// // //     } catch (e) {
// // //       debugPrint("❌ updateSidebarPermissions error: $e");
// // //     }
// // //   }
// // // }
// //
// //
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // class RolesController extends ChangeNotifier {
// //   List<Map<String, dynamic>> roles = [];
// //   bool isRolesLoading = false;
// //
// //   final String baseUrl = '{{baseurl}}';
// //   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
// //   Map<String, Map<String, bool>> sidebarPermissionStates = {};
// //
// //   // Get accessToken from SharedPreferences
// //   Future<String?> _getToken() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString('accessToken'); // use 'accessToken' key
// //   }
// //
// //   // Fetch all roles
// //   Future<void> fetchRoles() async {
// //     isRolesLoading = true;
// //     notifyListeners();
// //
// //     final token = await _getToken();
// //     if (token == null) return;
// //
// //     final response = await http.get(
// //       Uri.parse('$baseUrl/api/roles'),
// //       headers: {'Authorization': 'Bearer $token'},
// //     );
// //
// //     if (response.statusCode == 200) {
// //       roles = List<Map<String, dynamic>>.from(json.decode(response.body));
// //     }
// //
// //     isRolesLoading = false;
// //     notifyListeners();
// //   }
// //
// //   // Fetch sidebar for role
// //   Future<void> fetchSidebarForRole(String roleId) async {
// //     // Implement your backend API call if needed
// //   }
// //
// //   // Update sidebar permissions
// //   Future<void> updateSidebarPermissions(String roleId) async {
// //     // Implement your backend API call if needed
// //   }
// //
// //   void toggleSidebarPermission(String key, String permission) {
// //     sidebarPermissionStates[key]?[permission] =
// //     !(sidebarPermissionStates[key]?[permission] ?? false);
// //     notifyListeners();
// //   }
// //
// //   void toggleSidebarAll(String key, bool value) {
// //     sidebarPermissionStates[key] = {
// //       'view': value,
// //       'read': value,
// //       'manage': value,
// //     };
// //     notifyListeners();
// //   }
// //
// //   bool getSidebarAll(String key) {
// //     final perms = sidebarPermissionStates[key];
// //     return perms != null && perms.values.every((v) => v == true);
// //   }
// //
// //   // Create Role
// //   Future<void> createRole({
// //     required String name,
// //     String? description,
// //   }) async {
// //     final token = await _getToken();
// //     if (token == null) throw Exception('Token not found');
// //
// //     final body = json.encode({
// //       'name': name,
// //       'description': description ?? '',
// //     });
// //
// //     final response = await http.post(
// //       Uri.parse('$baseUrl/api/roles'),
// //       headers: {
// //         'Authorization': 'Bearer $token',
// //         'Content-Type': 'application/json',
// //       },
// //       body: body,
// //     );
// //
// //     if (response.statusCode == 200 || response.statusCode == 201) {
// //       final newRole = json.decode(response.body);
// //       roles.add(newRole);
// //       notifyListeners();
// //     } else {
// //       throw Exception('Failed to create role: ${response.body}');
// //     }
// //   }
// // }
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../environmental variables.dart';
//
// class RolesController extends ChangeNotifier {
//   List<Map<String, dynamic>> roles = [];
//   bool isRolesLoading = false;
//
//   // final String baseUrl = 'https://your-api-base-url.com'; // <-- Replace with actual API base URL
//   Map<String, List<Map<String, dynamic>>> sidebarCategories = {};
//   Map<String, Map<String, bool>> sidebarPermissionStates = {};
//
//   // Get accessToken from SharedPreferences
//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('accessToken'); // use 'accessToken' key
//   }
//
//   // Fetch all roles
//   Future<void> fetchRoles() async {
//     isRolesLoading = true;
//     notifyListeners();
//
//     final token = await _getToken();
//     if (token == null) {
//       isRolesLoading = false;
//       notifyListeners();
//       throw Exception('Access token not found');
//     }
//
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/api/roles'),
//         headers: {'Authorization': 'Bearer $token'},
//       );
//
//       print('FETCH ROLES STATUS: ${response.statusCode}');
//       print('FETCH ROLES BODY: ${response.body}');
//
//       if (response.statusCode == 200) {
//         // Safely parse JSON
//         final body = response.body.trim();
//         if (body.startsWith('[')) {
//           roles = List<Map<String, dynamic>>.from(json.decode(body));
//         } else if (body.startsWith('{')) {
//           roles = [Map<String, dynamic>.from(json.decode(body))];
//         } else {
//           throw Exception('Invalid JSON format: $body');
//         }
//       } else {
//         throw Exception(
//           'Failed to fetch roles: ${response.statusCode}, ${response.body}',
//         );
//       }
//     } catch (e) {
//       debugPrint('Error fetching roles: $e');
//       rethrow;
//     }
//
//     isRolesLoading = false;
//     notifyListeners();
//   }
//
//   // Fetch sidebar for role
//   Future<void> fetchSidebarForRole(String roleId) async {
//     // Implement API call if needed
//   }
//
//   // Update sidebar permissions
//   Future<void> updateSidebarPermissions(String roleId) async {
//     // Implement API call if needed
//   }
//
//   void toggleSidebarPermission(String key, String permission) {
//     sidebarPermissionStates[key]?[permission] =
//     !(sidebarPermissionStates[key]?[permission] ?? false);
//     notifyListeners();
//   }
//
//   void toggleSidebarAll(String key, bool value) {
//     sidebarPermissionStates[key] = {
//       'view': value,
//       'read': value,
//       'manage': value,
//     };
//     notifyListeners();
//   }
//
//   bool getSidebarAll(String key) {
//     final perms = sidebarPermissionStates[key];
//     return perms != null && perms.values.every((v) => v == true);
//   }
//
//   // Create Role
//   Future<void> createRole({
//     required String name,
//     String? description,
//   }) async {
//     final token = await _getToken();
//     if (token == null) throw Exception('Access token not found');
//
//     final body = json.encode({
//       'name': name,
//       'description': description ?? '',
//     });
//
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/api/roles'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: body,
//       );
//
//       print('CREATE ROLE STATUS: ${response.statusCode}');
//       print('CREATE ROLE BODY: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final responseBody = response.body.trim();
//         Map<String, dynamic> newRole;
//         if (responseBody.startsWith('{')) {
//           newRole = Map<String, dynamic>.from(json.decode(responseBody));
//         } else {
//           throw Exception('Invalid JSON response: $responseBody');
//         }
//         roles.add(newRole);
//         notifyListeners();
//       } else {
//         throw Exception(
//           'Failed to create role: ${response.statusCode}, ${response.body}',
//         );
//       }
//     } catch (e) {
//       debugPrint('Error creating role: $e');
//       rethrow;
//     }
//   }
// }
