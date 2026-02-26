import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import '../Controller/Get_all_item_controller.dart';
import '../Model/Item_Model.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<ItemModel> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      // ✅ Fetching using your ItemService
      final allItems = await ItemService.fetchItems();

      if (mounted) {
        setState(() {
          // ✅ FILTER: Only items where type is 'event'
          events = allItems.where((item) => item.type == 'event').toList();
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("❌ Error Loading Events: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1100;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: RefreshIndicator(
        onRefresh: _loadEvents,
        color: Colors.cyan,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildHeader(isDesktop),
            if (isLoading)
              _buildShimmerGrid(isDesktop)
            else if (events.isEmpty)
              SliverFillRemaining(child: _buildEmptyState())
            else
              _buildEventGrid(isDesktop),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(24, isDesktop ? 40 : 20, 24, 20),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Organization Events",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1D1E),
                  ),
                ),
                Text(
                  "Filtered by event type • ${events.length} items found",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.blueGrey.shade400,
                  ),
                ),
              ],
            ),
            // Optional: Refresh Button for Desktop
            if (isDesktop)
              IconButton(
                onPressed: _loadEvents,
                icon: const Icon(Iconsax.refresh, color: Colors.cyan),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildEventGrid(bool isDesktop) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop ? 4 : 1,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: isDesktop ? 0.78 : 1.1,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) => _buildAttractiveCard(events[index]),
          childCount: events.length,
        ),
      ),
    );
  }

  Widget _buildAttractiveCard(ItemModel item) {
    // 📅 Date Parsing Logic
    DateTime eventDate = DateTime.tryParse(item.createdAt ?? "") ?? DateTime.now();
    String day = DateFormat('dd').format(eventDate);
    String month = DateFormat('MMM').format(eventDate).toUpperCase();
    String time = DateFormat('hh:mm a').format(eventDate);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Image Section (Fixed Flex) ---
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    image: DecorationImage(
                      image: NetworkImage(item.image ?? 'https://via.placeholder.com/400'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        color: Colors.white.withOpacity(0.8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(day, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, height: 1.1)),
                            Text(month, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.cyan.shade800)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- Content Details (Tighter Spacing) ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12), // Reduced bottom padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Takes only needed space
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6), // Reduced from 8

                Row(
                  children: [
                    Icon(Iconsax.clock, size: 14, color: Colors.cyan.shade600),
                    const SizedBox(width: 6),
                    Text(time, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blueGrey.shade600)),
                  ],
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(Iconsax.location, size: 14, color: Colors.blueGrey.shade300),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.subtitle ?? "Location TBD",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.blueGrey.shade400),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12), // Controlled space before footer
                Container(height: 1, color: Colors.grey.shade100), // Thinner, cleaner divider
                const SizedBox(height: 10), // Reduced space after divider

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Manage Event",
                        style: GoogleFonts.poppins(
                            color: Colors.cyan.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 11
                        )
                    ),
                    const Icon(Iconsax.setting_4, color: Colors.cyan, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
            'https://res.cloudinary.com/dggylwwqk/raw/upload/v1756718657/events_awyqe9.json',
            height: 200,
          ),
          const SizedBox(height: 16),
          Text(
            "No events scheduled yet",
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid(bool isDesktop) {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop ? 4 : 1,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: isDesktop ? 0.78 : 1.1,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.white,
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
            ),
          ),
          childCount: 8,
        ),
      ),
    );
  }
}