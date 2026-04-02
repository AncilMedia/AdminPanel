import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/Media_Item_controller.dart';
import '../Controller/Media_Series_controller.dart';
import '../View_model/Create_media_popup.dart';
import 'package:ancilmediaadminpanel/View_model/Create_media_Series.dart';
import 'LibraryDetails.dart';

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
    _initData();
  }

  Future<void> _initData() async {
    await _localstorage();
    await _fetchUserMedia();
  }

  Future<void> _localstorage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
      orgId = prefs.getString("organizationId");
      roleId = prefs.getString("roleId");
    });
  }

  Future<void> _fetchUserMedia() async {
    setState(() => _loading = true);
    try {
      final items = await _itemService.getMediaItemsByUserOrOrg(
        userId: userId,
        organizationId: orgId,
      );
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

  Future<void> _deleteMediaItem(Map<String, dynamic> item) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Media"),
        content: const Text("Are you sure you want to delete this media item?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final itemId = item["_id"];

    try {
      await _itemService.deleteMediaItem(itemId);
      setState(() => _mediaItems.remove(item));
      _showSnack("Media deleted successfully", true);
    } catch (e) {
      _showSnack("Failed to delete media item", false);
    }
  }

  Future<void> _deleteSeries(Map<String, dynamic> series) async {
    final seriesId = series["_id"] ?? series["id"];
    try {
      await _seriesService.deleteSeries(seriesId);
      setState(() => _mediaSeries.remove(series));
      _showSnack("Series deleted successfully", true);
    } catch (e) {
      _showSnack("Failed to delete series", false);
    }
  }

  void _showSnack(String msg, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: _loading
          ? Center(child: Lottie.asset('assets/circular.json', height: 150))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildFeatureSection(),
                  const SizedBox(height: 40),
                  _buildSectionTitle("Recent Media Items", Iconsax.video_play),
                  _buildMediaItemList(),
                  const SizedBox(height: 48),
                  _buildSectionTitle("Media Series", Iconsax.folder_2),
                  _buildSeriesGrid(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  // ================= UI COMPONENTS =================

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Media Library",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade900,
              ),
            ),
            Text(
              "Manage your uploads and series collections",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.blueGrey.shade400,
              ),
            ),
          ],
        ),
        _buildCreateMenu(),
      ],
    );
  }

  Widget _buildCreateMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == "item") {
          await showCreateMediaItemDialog(
            context,
            _itemService,
            _seriesService,
          );
        } else if (value == "series") {
          await showCreateMediaSeriesDialog(context, _seriesService);
        }
        _fetchUserMedia();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      itemBuilder: (context) => [
        _buildPopupItem("item", Iconsax.video, "New Media Item"),
        _buildPopupItem("series", Iconsax.video_add, "New Series"),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade600, Colors.purple.shade600],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Iconsax.add_square, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              "Create",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSection() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _featureCard(
            "Bulk Metadata Editor",
            "Tag topics, scriptures, and speakers across multiple items instantly.",
            Iconsax.magicpen,
            Colors.blue.shade900,
            "Get Started",
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: _featureCard(
            "Quick Upload",
            "Drop files to auto-create items.",
            Iconsax.cloud_add,
            Colors.teal.shade700,
            "Upload",
          ),
        ),
      ],
    );
  }

  Widget _featureCard(
    String title,
    String desc,
    IconData icon,
    Color color,
    String btnText,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 40),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white24,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(btnText),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.indigo),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  // ================= BALANCED UI COMPONENTS =================
  Widget _buildMediaItemList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: _mediaItems.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text("No media items found")),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _mediaItems.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: Colors.grey.shade100,
                indent: 20,
                endIndent: 20,
              ),
              itemBuilder: (context, index) {
                final item = _mediaItems[index];

                // Use InkWell for the tap effect and Row for the layout

                // return InkWell(
                //   onTap: () => Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (_) => LibraryDetails(mediaitemid: item["_id"]))
                //   ),
                //   borderRadius: BorderRadius.circular(24),
                //   child: Padding(
                //     padding: const EdgeInsets.all(20), // Controlled spacing
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.center, // Vertically center text with image
                //       children: [
                //         // --- FIXED SQUARE THUMBNAIL: 150 x 150 ---
                //         Container(
                //           width: 100,
                //           height: 80, // Height will now be respected
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(20), // Modern curved edges
                //             border: Border.all(color: Colors.grey.shade200, width: 1),
                //             color: Colors.indigo.withOpacity(0.05),
                //           ),
                //           child: ClipRRect(
                //             borderRadius: BorderRadius.circular(19),
                //             child: item["thumbnailUrl"] != null
                //                 ? Image.network(
                //               item["thumbnailUrl"],
                //               fit: BoxFit.cover,
                //               loadingBuilder: (context, child, loadingProgress) {
                //                 if (loadingProgress == null) return child;
                //                 return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                //               },
                //             )
                //                 : const Icon(Iconsax.video, color: Colors.indigo, size: 40),
                //           ),
                //         ),
                //
                //         const SizedBox(width: 22), // Space between image and text
                //
                //         // --- TEXT CONTENT ---
                //         Expanded(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 item["title"] ?? "Untitled",
                //                 style: GoogleFonts.poppins(
                //                     fontWeight: FontWeight.bold,
                //                     fontSize: 15, // Slightly larger to match big image
                //                     color: Colors.blueGrey.shade900
                //                 ),
                //               ),
                //               const SizedBox(height: 10),
                //               Row(
                //                 children: [
                //                   const Icon(Iconsax.folder_open, size: 18, color: Colors.indigo),
                //                   const SizedBox(width: 8),
                //                   Text(
                //                       item["seriesId"]?["title"] ?? "No Series",
                //                       style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blueGrey.shade600)
                //                   ),
                //                 ],
                //               ),
                //               const SizedBox(height: 8),
                //               Row(
                //                 children: [
                //                   const Icon(Iconsax.calendar_1, size: 18, color: Colors.blueGrey),
                //                   const SizedBox(width: 8),
                //                   Text(
                //                       "Created: ${item["createdAt"]?.toString().split('T').first ?? 'N/A'}",
                //                       style: GoogleFonts.poppins(fontSize: 13, color: Colors.blueGrey.shade400)
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         ),
                //
                //         // --- TRAILING ICON ---
                //         // Icon(Iconsax.arrow_right_3, color: Colors.indigo.shade300),
                //         Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Icon(Iconsax.arrow_right_3, color: Colors.indigo.shade300),
                //             const SizedBox(width: 8),
                //             PopupMenuButton<String>(
                //               icon: const Icon(Iconsax.more, size: 18, color: Colors.grey),
                //               onSelected: (value) {
                //                 if (value == "delete") {
                //                   _deleteMediaItem(item);
                //                 }
                //               },
                //               itemBuilder: (_) => [
                //                 const PopupMenuItem(
                //                   value: "delete",
                //                   child: Row(
                //                     children: [
                //                       Icon(Icons.delete, color: Colors.red, size: 18),
                //                       SizedBox(width: 8),
                //                       Text("Delete", style: TextStyle(color: Colors.red)),
                //                     ],
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // );
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LibraryDetails(mediaitemid: item["_id"]),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 1,
                                  ),
                                  color: Colors.indigo.withOpacity(0.05),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(19),
                                  child: item["thumbnailUrl"] != null
                                      ? Image.network(
                                          item["thumbnailUrl"],
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                );
                                              },
                                        )
                                      : const Icon(
                                          Iconsax.video,
                                          color: Colors.indigo,
                                          size: 40,
                                        ),
                                ),
                              ),

                              const SizedBox(width: 22),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["title"] ?? "Untitled",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.blueGrey.shade900,
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    Row(
                                      children: [
                                        const Icon(
                                          Iconsax.folder_open,
                                          size: 18,
                                          color: Colors.indigo,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          item["seriesId"]?["title"] ??
                                              "No Series",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blueGrey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    Row(
                                      children: [
                                        const Icon(
                                          Iconsax.calendar_1,
                                          size: 18,
                                          color: Colors.blueGrey,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Created: ${item["createdAt"]?.toString().split('T').first ?? 'N/A'}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: Colors.blueGrey.shade400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.arrow_right_3,
                            color: Colors.indigo.shade300,
                          ),
                          const SizedBox(width: 8),

                          PopupMenuButton<String>(
                            icon: const Icon(
                              Iconsax.more,
                              size: 18,
                              color: Colors.grey,
                            ),
                            onSelected: (value) {
                              if (value == "delete") {
                                _deleteMediaItem(item);
                              }
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                value: "delete",
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSeriesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // DECREASED SIZE: Increased crossAxisCount from 5 to 7 to make items smaller
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio:
            0.85, // Adjusted to keep the cards from looking too tall
      ),
      itemCount: _mediaSeries.length,
      itemBuilder: (context, index) {
        final series = _mediaSeries[index];
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: series["thumbnail"] != null
                        ? Image.network(
                            series["thumbnail"],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.indigo.withOpacity(0.05),
                            child: const Icon(
                              Iconsax.folder_open,
                              color: Colors.indigo,
                              size: 20,
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          series["title"] ?? "Untitled",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: Colors.blueGrey.shade800,
                          ),
                        ),
                      ),
                      // Small menu for compact size
                      SizedBox(
                        width: 20,
                        child: PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Iconsax.more,
                            size: 14,
                            color: Colors.grey,
                          ),
                          onSelected: (v) {
                            if (v == "del") _deleteSeries(series);
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              value: "del",
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PopupMenuItem<String> _buildPopupItem(
    String value,
    IconData icon,
    String label,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.indigo),
          const SizedBox(width: 10),
          Text(label, style: GoogleFonts.poppins(fontSize: 13)),
        ],
      ),
    );
  }
}
