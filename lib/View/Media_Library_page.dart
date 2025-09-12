// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Controller/Media_Item_controller.dart';
// import '../Controller/Media_Series_controller.dart';
// import '../View_model/Create_media_popup.dart';
// import 'package:ancilmediaadminpanel/View_model/Create_media_Series.dart';
//
// class LibraryPage extends StatefulWidget {
//   const LibraryPage({super.key});
//
//   @override
//   State<LibraryPage> createState() => _LibraryPageState();
// }
//
// class _LibraryPageState extends State<LibraryPage> {
//   final MediaItemService _itemService = MediaItemService();
//   final MediaSeriesService _seriesService = MediaSeriesService();
//
//   List<dynamic> _mediaItems = [];
//   List<dynamic> _mediaSeries = [];
//   bool _loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUserMedia();
//   }
//
//   Future<void> _fetchUserMedia() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString("userId") ?? "68a7f7cd27471122559a1016"; // fallback for debug
//     final orgId = prefs.getString("organizationId");
//
//     try {
//       // 🔹 fetch items with filter
//       final items = await _itemService.getMediaItemsByUserOrOrg(
//         userId: userId,
//         organizationId: orgId,
//       );
//
//       // 🔹 fetch series with filter
//       final seriesList = await _seriesService.getSeriesByFilter(
//         userId: userId,
//         organizationId: orgId,
//       );
//
//       setState(() {
//         _mediaItems = items;
//         _mediaSeries = seriesList;
//         _loading = false;
//       });
//     } catch (e) {
//       debugPrint("❌ Error fetching media: $e");
//       setState(() => _loading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.only(
//           left: MediaQuery.of(context).size.width * .2,
//           right: MediaQuery.of(context).size.width * .1,
//           top: MediaQuery.of(context).size.height * .05,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// 🔹 Top Row with Dropdown
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   PopupMenuButton<String>(
//                     onSelected: (value) {
//                       if (value == "item") {
//                         showCreateMediaItemDialog(context);
//                       } else if (value == "series") {
//                         showCreateMediaSeriesDialog(context);
//                       }
//                     },
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     offset: const Offset(0, 50),
//                     itemBuilder: (context) => [
//                       PopupMenuItem(
//                         value: "item",
//                         child: Row(
//                           children: [
//                             const Icon(
//                               Iconsax.video,
//                               size: 18,
//                               color: Colors.purple,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               "Create Media Item",
//                               style: GoogleFonts.poppins(fontSize: 14),
//                             ),
//                           ],
//                         ),
//                       ),
//                       PopupMenuItem(
//                         value: "series",
//                         child: Row(
//                           children: [
//                             const Icon(
//                               Iconsax.video_add,
//                               size: 18,
//                               color: Colors.purple,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               "Create Media Series",
//                               style: GoogleFonts.poppins(fontSize: 14),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.purple,
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Iconsax.video, color: Colors.white),
//                           const SizedBox(width: 8),
//                           Text(
//                             "Create Media",
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                           const Icon(
//                             Icons.keyboard_arrow_down,
//                             color: Colors.white,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // 🔹 Bulk Edit Card
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.black12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(Iconsax.information, color: Colors.blue, size: 35),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Save time and add tags to your media library in bulk",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           "Make the most of your media and get your entire media library tagged with topics,\nscripture, and speakers quickly with Bulk Edit.",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w400,
//                             fontSize: 16,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Row(
//                     children: [
//                       Container(
//                         height: MediaQuery.of(context).size.height * .04,
//                         width: MediaQuery.of(context).size.width * .07,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(color: Colors.black12),
//                           color: Colors.white,
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Get started",
//                             style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {},
//                         icon: const Icon(Iconsax.close_circle),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // 🔹 Upload Component
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.black12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Iconsax.add_circle, color: Colors.green, size: 28),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Text(
//                       "Upload a video or audio file to create a Media item",
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       // TODO: Add file picker logic here
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Text(
//                       "Upload",
//                       style: GoogleFonts.poppins(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // 🔹 Recent Media Items
//             Container(
//               height: MediaQuery.of(context).size.height * .3,
//               width: MediaQuery.of(context).size.width * .8,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.white,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Recent Media Items",
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * .005),
//                     const Divider(),
//                     _mediaItems.isEmpty
//                         ? const Text("No media items yet.")
//                         : Column(
//                       children: _mediaItems.take(5).map((item) {
//                         final String? thumbnailUrl = item["thumbnailUrl"];
//                         final String seriesName = item["seriesId"]?["title"] ?? "No Series";
//                         final String createdDate = item["createdAt"] != null
//                             ? DateTime.parse(item["createdAt"])
//                             .toLocal()
//                             .toString()
//                             .substring(0, 16) // yyyy-MM-dd HH:mm
//                             : "Unknown Date";
//
//                         return ListTile(
//                           leading: thumbnailUrl != null && thumbnailUrl.isNotEmpty
//                               ? ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               thumbnailUrl,
//                               width: 75,
//                               height: 200,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) =>
//                               const Icon(Iconsax.video, size: 40, color: Colors.grey),
//                             ),
//                           )
//                               : const Icon(Iconsax.video, size: 40, color: Colors.grey),
//                           title: Text(item["title"] ?? "Untitled"),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               if (item["description"] != null &&
//                                   item["description"].toString().isNotEmpty)
//                                 Text(item["description"]),
//                               const SizedBox(height: 4),
//                               Row(
//                                 spacing: 10,
//                                 children: [
//                                   Text(
//                                     "Series: $seriesName",
//                                     overflow: TextOverflow.ellipsis,
//                                     style:  GoogleFonts.poppins(fontSize: 12, color: Colors.grey,fontWeight: FontWeight.w600),
//                                   ),
//                                   Text('--->',style: GoogleFonts.poppins(
//                                     color: Colors.grey
//                                   ),),
//                                   Text(
//                                     createdDate,
//                                     style:  GoogleFonts.poppins(fontSize: 12, color: Colors.grey,fontWeight: FontWeight.w600),
//                                   ),
//                                 ],
//                               ),
//                               Divider()
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // 🔹 Recent Media Series
//             Container(
//               width: MediaQuery.of(context).size.width * .8,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.white,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Recent Media Series",
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * .01),
//                     // Wrap(
//                     //   spacing: 16,
//                     //   runSpacing: 16,
//                     //   children: List.generate(5, (index) {
//                     //     return SizedBox(
//                     //       width: 200,
//                     //       child: Column(
//                     //         crossAxisAlignment: CrossAxisAlignment.start,
//                     //         children: [
//                     //           ClipRRect(
//                     //             borderRadius: BorderRadius.circular(16),
//                     //             child: Image.network(
//                     //               'https://images.unsplash.com/photo-1657632843433-e6a8b7451ac6?q=80&w=712&auto=format&fit=crop&ixlib=rb-4.1.0',
//                     //               height: 200,
//                     //               width: 200,
//                     //               fit: BoxFit.cover,
//                     //             ),
//                     //           ),
//                     //           const SizedBox(height: 8),
//                     //           Row(
//                     //             mainAxisAlignment:
//                     //                 MainAxisAlignment.spaceBetween,
//                     //             children: [
//                     //               Expanded(
//                     //                 child: Text(
//                     //                   "Redhill sermons",
//                     //                   style: GoogleFonts.poppins(
//                     //                     fontSize: 14,
//                     //                     fontWeight: FontWeight.w400,
//                     //                     color: Colors.grey,
//                     //                   ),
//                     //                   overflow: TextOverflow.ellipsis,
//                     //                 ),
//                     //               ),
//                     //               PopupMenuButton<String>(
//                     //                 icon: const Icon(
//                     //                   Iconsax.more,
//                     //                   color: Colors.grey,
//                     //                 ),
//                     //                 onSelected: (value) {
//                     //                   if (value == "add") {
//                     //                     debugPrint("Add to List tapped");
//                     //                   } else if (value == "remove") {
//                     //                     debugPrint("Remove tapped");
//                     //                   }
//                     //                 },
//                     //                 itemBuilder: (context) => [
//                     //                   const PopupMenuItem(
//                     //                     value: "add",
//                     //                     child: Text("Add to List"),
//                     //                   ),
//                     //                   const PopupMenuItem(
//                     //                     value: "remove",
//                     //                     child: Text("Remove"),
//                     //                   ),
//                     //                 ],
//                     //               ),
//                     //             ],
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     );
//                     //   }),
//                     // ),
//                     _mediaSeries.isEmpty
//                         ? const Text("No media series yet.")
//                         : Wrap(
//                       spacing: 16,
//                       runSpacing: 16,
//                       children: _mediaSeries.take(5).map((series) {
//                         final String createdDate =
//                         series["createdAt"] != null
//                             ? DateTime.parse(series["createdAt"])
//                             .toLocal()
//                             .toString()
//                             .substring(0, 16)
//                             : "Unknown Date";
//
//                         return SizedBox(
//                           width: 200,
//                           child: Column(
//                             crossAxisAlignment:
//                             CrossAxisAlignment.start,
//                             children: [
//                               ClipRRect(
//                                 borderRadius:
//                                 BorderRadius.circular(16),
//                                 child: Image.network(
//                                   series["thumbnail"] ??
//                                       "https://via.placeholder.com/200",
//                                   height: 120,
//                                   width: 200,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Text(series["title"] ?? "Untitled",
//                                         style: GoogleFonts.poppins(
//                                             fontWeight: FontWeight.w500)),
//                                   ),
//                                   PopupMenuButton<String>(
//                                     icon: const Icon(
//                                       Iconsax.more,
//                                       color: Colors.grey,
//                                     ),
//                                     onSelected: (value) {
//                                       if (value == "add") {
//                                         debugPrint("Add to List tapped");
//                                       } else if (value == "remove") {
//                                         debugPrint("Remove tapped");
//                                       }
//                                     },
//                                     itemBuilder: (context) => [
//                                       const PopupMenuItem(
//                                         value: "add",
//                                         child: Text("Add to List"),
//                                       ),
//                                       const PopupMenuItem(
//                                         value: "remove",
//                                         child: Text("Remove"),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               height: MediaQuery.of(context).size.height * .3,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/Media_Item_controller.dart';
import '../Controller/Media_Series_controller.dart';
import '../View_model/Create_media_popup.dart';
import 'package:ancilmediaadminpanel/View_model/Create_media_Series.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final MediaItemService _itemService = MediaItemService();
  final MediaSeriesService _seriesService = MediaSeriesService();

  List<dynamic> _mediaItems = [];
  List<dynamic> _mediaSeries = [];
  bool _loading = true;

  String? userId;
  String? orgId;
  String? roleId;

  @override
  void initState() {
    super.initState();
    _fetchUserMedia();
    _localstorage();
  }

  Future<void> _localstorage() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString("userId");
    final orgId = prefs.getString("organizationId");
    final roleId = prefs.getString("roleId");
    print("🔹 LocalStorage loaded: userId=$userId, orgId=$orgId, roleId=$roleId");

  }

  Future<void> _fetchUserMedia() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId"); // fallback for debug
    final orgId = prefs.getString("organizationId");

    try {
      // 🔹 fetch items with filter
      final items = await _itemService.getMediaItemsByUserOrOrg(
        userId: userId,
        organizationId: orgId,
      );

      // 🔹 fetch series with filter
      final seriesList = await _seriesService.getSeriesByFilter(
        userId: userId,
        organizationId: orgId,
      );

      setState(() {
        _mediaItems = items;
        _mediaSeries = seriesList;
        _loading = false;
      });
    } catch (e) {
      debugPrint("❌ Error fetching media: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(
      child: CircularProgressIndicator(
        color: Colors.purple,
      ),
    )
        : SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * .2,
          right: MediaQuery.of(context).size.width * .1,
          top: MediaQuery.of(context).size.height * .05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Top Row with Dropdown
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "item") {
                        showCreateMediaItemDialog(context,_itemService,_seriesService);
                      } else if (value == "series") {
                        showCreateMediaSeriesDialog(context,_seriesService);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    offset: const Offset(0, 50),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "item",
                        child: Row(
                          children: [
                            const Icon(
                              Iconsax.video,
                              size: 18,
                              color: Colors.purple,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Create Media Item",
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "series",
                        child: Row(
                          children: [
                            const Icon(
                              Iconsax.video_add,
                              size: 18,
                              color: Colors.purple,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Create Media Series",
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purple,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          const Icon(Iconsax.video, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            "Create Media",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Bulk Edit Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Iconsax.information, color: Colors.blue, size: 35),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Save time and add tags to your media library in bulk",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Make the most of your media and get your entire media library tagged with topics,\nscripture, and speakers quickly with Bulk Edit.",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .04,
                        width: MediaQuery.of(context).size.width * .07,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black12),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            "Get started",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Iconsax.close_circle),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Upload Component
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.add_circle, color: Colors.green, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Upload a video or audio file to create a Media item",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Add file picker logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Upload",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Recent Media Items
            Container(
              height: MediaQuery.of(context).size.height * .3,
              width: MediaQuery.of(context).size.width * .8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recent Media Items",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .005),
                    const Divider(),
                    _mediaItems.isEmpty
                        ? const Text("No media items yet.")
                        : Column(
                      children: _mediaItems.take(5).map((item) {
                        final String? thumbnailUrl = item["thumbnailUrl"];
                        final String seriesName = item["seriesId"]?["title"] ?? "No Series";
                        final String createdDate = item["createdAt"] != null
                            ? DateTime.parse(item["createdAt"])
                            .toLocal()
                            .toString()
                            .substring(0, 16)
                            : "Unknown Date";

                        return ListTile(
                          leading: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              thumbnailUrl,
                              width: 75,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Iconsax.video, size: 40, color: Colors.grey),
                            ),
                          )
                              : const Icon(Iconsax.video, size: 40, color: Colors.grey),
                          title: Text(item["title"] ?? "Untitled"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item["description"] != null &&
                                  item["description"].toString().isNotEmpty)
                                Text(item["description"]),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    "Series: $seriesName",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                                  ),
                                  Text('--->', style: GoogleFonts.poppins(color: Colors.grey)),
                                  Text(
                                    createdDate,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const Divider()
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Recent Media Series
            Container(
              width: MediaQuery.of(context).size.width * .8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recent Media Series",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .01),
                    _mediaSeries.isEmpty
                        ? const Text("No media series yet.")
                        : Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: _mediaSeries.take(5).map((series) {
                        final String createdDate = series["createdAt"] != null
                            ? DateTime.parse(series["createdAt"]).toLocal().toString().substring(0, 16)
                            : "Unknown Date";

                        return SizedBox(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  series["thumbnail"] ?? Icon(Iconsax.image),
                                  height: 120,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(series["title"] ?? "Untitled",
                                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(
                                      Iconsax.more,
                                      color: Colors.grey,
                                    ),
                                    onSelected: (value) {
                                      if (value == "add") {
                                        debugPrint("Add to List tapped");
                                      } else if (value == "remove") {
                                        debugPrint("Remove tapped");
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: "add",
                                        child: Text("Add to List"),
                                      ),
                                      const PopupMenuItem(
                                        value: "remove",
                                        child: Text("Remove"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .3,
            ),
          ],
        ),
      ),
    );
  }}
