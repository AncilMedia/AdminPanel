// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:http/http.dart' as http;
// import 'package:icalendar_parser/icalendar_parser.dart';
// import '../Controller/Get_all_item_controller.dart';
// import '../Controller/ics_controller.dart';
// import '../Model/Item_Model.dart';
// import 'PopUp/Right_drawer.dart';
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
//   // HIGH PERFORMANCE: Index map for O(1) event lookups
//   Map<String, List<ItemModel>> _eventsByDate = {};
//
//   bool isLoading = true;
//   int activeTab = 0;
//   Map<String, dynamic>? selectedSource;
//   int currentYear = DateTime.now().year;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }
//
//   // =========================================================
//   // INDEXING LOGIC
//   // =========================================================
//   void _indexEvents() {
//     final Map<String, List<ItemModel>> newMap = {};
//     for (var event in syncedEventsData) {
//       final dt = DateTime.tryParse(event.startDateTime ?? "");
//       if (dt != null) {
//         final dateKey = "${dt.year}-${dt.month}-${dt.day}";
//         newMap.putIfAbsent(dateKey, () => []).add(event);
//       }
//     }
//     setState(() => _eventsByDate = newMap);
//   }
//
//   Future<void> _initializeData() async {
//     if (mounted) setState(() => isLoading = true);
//     try {
//       await _loadManualEvents();
//       await _loadIcsSources();
//     } catch (e) {
//       debugPrint("INITIALIZE ERROR : $e");
//     }
//     if (mounted) setState(() => isLoading = false);
//   }
//
//   Future<void> _loadIcsSources() async {
//     try {
//       final data = await IcsController.getAllIcs();
//       List<Map<String, dynamic>> loaded = [];
//
//       for (final source in data) {
//         try {
//           String content = '';
//           if (source['type'] == 'url' && source['originalUrl'] != null) {
//             final response = await http.get(Uri.parse(source['originalUrl']));
//             if (response.statusCode == 200) content = response.body;
//           } else if (source['type'] == 'file' && source['cloudinaryUrl'] != null) {
//             final response = await http.get(Uri.parse(source['cloudinaryUrl']));
//             if (response.statusCode == 200) content = response.body;
//           }
//
//           if (content.contains('BEGIN:VCALENDAR')) {
//             final calendar = ICalendar.fromString(content);
//             List<ItemModel> parsed = [];
//             for (var entry in calendar.data) {
//               if (entry['type'] == 'VEVENT') {
//                 IcsDateTime? dt = entry['dtstart'];
//                 parsed.add(ItemModel(
//                   id: entry['uid']?.toString() ?? UniqueKey().toString(),
//                   title: entry['summary']?.toString() ?? 'Busy',
//                   startDateTime: dt?.toDateTime()?.toIso8601String(),
//                   type: 'event',
//                 ));
//               }
//             }
//             loaded.add({...source, 'events': parsed});
//           }
//         } catch (e) {
//           debugPrint('ICS Parse Error: $e');
//         }
//       }
//       if (mounted) setState(() => syncedSources = loaded);
//     } catch (e) {
//       debugPrint('Load ICS Error: $e');
//     }
//   }
//
//   Future<void> _loadManualEvents() async {
//     if (!mounted) return;
//     try {
//       final allItems = await ItemService.fetchItems();
//       if (mounted) {
//         setState(() {
//           manualEvents = allItems.where((e) => e.type == 'event').toList();
//         });
//       }
//     } catch (e) {
//       debugPrint("Load Manual Error: $e");
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
//                       final file = await IcsController.pickIcsFile();
//                       if (file != null) setDialogState(() => pickedFile = file);
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
//                           Text(pickedFile == null ? "Select .ics File" : pickedFile!.name,
//                               style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold)),
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
//                   Navigator.pop(context);
//                   setState(() => isLoading = true);
//                   try {
//                     if (dialogTab == 0 && urlController.text.isNotEmpty) {
//                       await IcsController.createIcsFromUrl(title: 'Calendar Sync', originalUrl: urlController.text.trim());
//                     } else if (dialogTab == 1 && pickedFile != null) {
//                       await IcsController.createIcsFromFile(title: pickedFile!.name, file: pickedFile!);
//                     }
//                     await _loadIcsSources();
//                     if (mounted) setState(() => activeTab = 1);
//                   } catch (e) {
//                     debugPrint('Import Error: $e');
//                   }
//                   if (mounted) setState(() => isLoading = false);
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
//       endDrawer: CustomRightDrawer(
//         isInSublist: false,
//         initialSelection: DrawerSelection.event,
//         onAddItemToHome: (newItem) => _loadManualEvents(),
//       ),
//       key: scaffoldKey,
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: CustomScrollView(
//         cacheExtent: 3000, // PERFORMANCE: Pre-render off-screen months
//         slivers: [
//           _buildSpaciousHeader(),
//           _buildPremiumTabs(),
//           SliverPadding(
//             padding: EdgeInsets.symmetric(
//               horizontal: isDesktop ? 50 : 20,
//               vertical: 20,
//             ),
//             sliver: isLoading
//                 ? _buildShimmer(isDesktop)
//                 : _buildBodyContent(isDesktop),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBodyContent(bool isDesktop) {
//     if (selectedSource != null) {
//       return SliverGrid(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: isDesktop ? 3 : 1,
//           mainAxisSpacing: 30,
//           crossAxisSpacing: 30,
//           childAspectRatio: 0.78,
//         ),
//         delegate: SliverChildBuilderDelegate(
//               (context, index) => _MonthCard(
//             key: ValueKey('month-$index'),
//             month: index + 1,
//             year: currentYear,
//             eventsMap: _eventsByDate,
//           ),
//           childCount: 12,
//         ),
//       );
//     }
//     return activeTab == 0
//         ? _buildManualGrid(isDesktop)
//         : _buildSyncedSourcesGrid(isDesktop);
//   }
//
//   // =========================================================
//   // UI BUILDERS
//   // =========================================================
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
//                   style: GoogleFonts.plusJakartaSans(
//                     fontSize: 34,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: -1,
//                     color: const Color(0xFF1E293B),
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 _statusPill(
//                   "Overview • ${activeTab == 0 ? manualEvents.length : syncedSources.length} items found",
//                 ),
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
//         child: Row(
//           children: [
//             _tabItem(0, "Manual"),
//             const SizedBox(width: 40),
//             _tabItem(1, "Synced Sources"),
//           ],
//         ),
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
//       delegate: SliverChildBuilderDelegate(
//             (context, index) => _buildEventCard(manualEvents[index]),
//         childCount: manualEvents.length,
//       ),
//     );
//   }
//
//   Widget _buildEventCard(ItemModel item) {
//     DateTime? date = DateTime.tryParse(item.startDateTime ?? "");
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(28),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 12)),
//         ],
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
//                 Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis,
//                     style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18, color: const Color(0xFF1E293B))),
//                 const SizedBox(height: 10),
//                 _rowDetail(Iconsax.clock, date != null ? DateFormat('hh:mm a').format(date) : "--:--"),
//                 _rowDetail(Iconsax.location, "Event Location"),
//                 const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(color: Color(0xFFF1F5F9))),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Manage", style: GoogleFonts.plusJakartaSans(color: const Color(0xFF007BFF), fontWeight: FontWeight.w700, fontSize: 13)),
//                     Row(
//                       children: [
//                         const Icon(Iconsax.edit, size: 20, color: Colors.green),
//                         const SizedBox(width: 15),
//                         const Icon(Iconsax.trash, size: 20, color: Colors.redAccent),
//                       ],
//                     ),
//                   ],
//                 ),
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
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: isDesktop ? 3 : 1,
//         mainAxisSpacing: 25,
//         crossAxisSpacing: 25,
//         childAspectRatio: 2.2,
//       ),
//       delegate: SliverChildBuilderDelegate(
//             (context, index) => _buildSourceTile(syncedSources[index]),
//         childCount: syncedSources.length,
//       ),
//     );
//   }
//
//   Widget _buildSourceTile(Map<String, dynamic> source) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           selectedSource = source;
//           syncedEventsData = List<ItemModel>.from(source['events']);
//           _indexEvents();
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//           border: Border.all(color: const Color(0xFFE2E8F0)),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(15),
//               decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(18)),
//               child: const Icon(Iconsax.link, color: Colors.orange, size: 28),
//             ),
//             const SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(source['title'] ?? '', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18)),
//                   const SizedBox(height: 4),
//                   Text(source['originalUrl'] ?? 'ICS File', maxLines: 1, overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 12)),
//                 ],
//               ),
//             ),
//             IconButton(
//               onPressed: () async {
//                 try {
//                   await IcsController.deleteIcs(source['_id']);
//                   await _loadIcsSources();
//                 } catch (e) {
//                   debugPrint('Delete ICS Error: $e');
//                 }
//               },
//               icon: const Icon(Iconsax.trash, color: Colors.redAccent),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // =========================================================
//   // HELPER WIDGETS
//   // =========================================================
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
//       child: Column(
//         children: [
//           Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
//               color: isSelected ? const Color(0xFF1E293B) : Colors.grey)),
//           const SizedBox(height: 8),
//           AnimatedContainer(duration: const Duration(milliseconds: 300), height: 4, width: isSelected ? 30 : 0,
//               decoration: BoxDecoration(color: const Color(0xFF00C2D1), borderRadius: BorderRadius.circular(10))),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildToggle(int current, Function(int) onChange) {
//     return Container(
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
//       child: Row(
//         children: [
//           Expanded(child: _toggleItem("URL Link", current == 0, () => onChange(0))),
//           Expanded(child: _toggleItem("Local File", current == 1, () => onChange(1))),
//         ],
//       ),
//     );
//   }
//
//   Widget _toggleItem(String label, bool s, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(color: s ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(10),
//             boxShadow: s ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : null),
//         child: Center(child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: s ? const Color(0xFF00C2D1) : Colors.grey))),
//       ),
//     );
//   }
//
//   Widget _buildDateBadge(DateTime? date) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(14),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           color: Colors.white.withOpacity(0.8),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(date != null ? DateFormat('dd').format(date) : "01",
//                   style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 18, color: const Color(0xFF1E293B))),
//               Text(date != null ? DateFormat('MMM').format(date).toUpperCase() : "MAY",
//                   style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 11, color: const Color(0xFF00C2D1))),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _mainBtn(IconData icon, String label, Color color, VoidCallback onTap) {
//     return ElevatedButton.icon(
//       onPressed: onTap,
//       icon: Icon(icon, size: 20),
//       label: Text(label),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         foregroundColor: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         elevation: 0,
//       ),
//     );
//   }
//
//   Widget _rowDetail(IconData icon, String label) {
//     return Row(
//       children: [
//         Icon(icon, size: 16, color: const Color(0xFF00C2D1)),
//         const SizedBox(width: 10),
//         Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF64748B), fontWeight: FontWeight.w500)),
//       ],
//     );
//   }
//
//   Widget _circularActionBtn(IconData icon, Color color, VoidCallback onTap) =>
//       IconButton(onPressed: onTap, icon: Icon(icon, color: color, size: 34));
//
//   Widget _buildShimmer(bool isDesktop) {
//     return SliverGrid(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: isDesktop ? 4 : 1,
//         mainAxisSpacing: 30,
//         crossAxisSpacing: 30,
//         childAspectRatio: 0.8,
//       ),
//       delegate: SliverChildBuilderDelegate(
//             (context, index) => Shimmer.fromColors(
//           baseColor: Colors.grey.shade200,
//           highlightColor: Colors.white,
//           child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28))),
//         ),
//         childCount: 8,
//       ),
//     );
//   }
// }
//
// // =========================================================
// // HIGH PERFORMANCE MONTH CARD
// // =========================================================
// class _MonthCard extends StatefulWidget {
//   final int month;
//   final int year;
//   final Map<String, List<ItemModel>> eventsMap;
//
//   const _MonthCard({
//     super.key,
//     required this.month,
//     required this.year,
//     required this.eventsMap,
//   });
//
//   @override
//   State<_MonthCard> createState() => _MonthCardState();
// }
//
// class _MonthCardState extends State<_MonthCard> with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true; // PERFORMANCE: Caches the month in memory
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final monthName = DateFormat('MMMM').format(DateTime(widget.year, widget.month));
//     final daysInMonth = DateTime(widget.year, widget.month + 1, 0).day;
//     final firstDay = DateTime(widget.year, widget.month, 1).weekday % 7;
//     final List<String> dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
//
//     return RepaintBoundary( // PERFORMANCE: Isolates painting
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(color: const Color(0xFF00C2D1).withOpacity(0.05), blurRadius: 30, offset: const Offset(0, 15)),
//           ],
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(25),
//               child: Text(monthName, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 20, color: const Color(0xFF1E293B))),
//             ),
//             const Divider(height: 1, color: Color(0xFFF1F5F9)),
//             _buildDayLabels(dayLabels),
//             Expanded(
//               child: GridView.builder(
//                 padding: const EdgeInsets.all(15),
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 7,
//                   mainAxisSpacing: 4,
//                   crossAxisSpacing: 4,
//                   childAspectRatio: 0.8,
//                 ),
//                 itemCount: daysInMonth + firstDay,
//                 itemBuilder: (context, index) {
//                   if (index < firstDay) return const SizedBox.shrink();
//                   int day = index - firstDay + 1;
//                   bool isSunday = index % 7 == 0;
//
//                   final dateKey = "${widget.year}-${widget.month}-$day";
//                   final dayEvents = widget.eventsMap[dateKey] ?? [];
//
//                   bool hasEvent = dayEvents.isNotEmpty;
//                   String title = hasEvent ? dayEvents.first.title : "";
//
//                   return _DayCell(
//                     day: day,
//                     hasEvent: hasEvent,
//                     isSunday: isSunday,
//                     eventTitle: title,
//                     monthName: monthName,
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDayLabels(List<String> labels) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: labels.map((l) => Expanded(
//           child: Center(
//             child: Text(l, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: l == 'S' ? Colors.redAccent : const Color(0xFF94A3B8))),
//           ),
//         )).toList(),
//       ),
//     );
//   }
// }
//
// // =========================================================
// // OPTIMIZED DAY CELL
// // =========================================================
// class _DayCell extends StatelessWidget {
//   final int day;
//   final bool hasEvent;
//   final bool isSunday;
//   final String eventTitle;
//   final String monthName;
//
//   const _DayCell({
//     required this.day,
//     required this.hasEvent,
//     required this.isSunday,
//     required this.eventTitle,
//     required this.monthName,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Tooltip(
//       message: hasEvent ? eventTitle : "$monthName $day",
//       verticalOffset: 20,
//       preferBelow: false,
//       decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 4),
//         decoration: BoxDecoration(
//           color: hasEvent ? const Color(0xFF00C2D1).withOpacity(0.1) : Colors.transparent,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "$day",
//               style: GoogleFonts.plusJakartaSans(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w800,
//                 color: hasEvent ? const Color(0xFF00C2D1) : (isSunday ? Colors.redAccent : const Color(0xFF64748B)),
//               ),
//             ),
//             if (hasEvent)
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4),
//                 child: Text(
//                   eventTitle,
//                   maxLines: 1,
//                   textAlign: TextAlign.center,
//                   overflow: TextOverflow.ellipsis,
//                   style: GoogleFonts.plusJakartaSans(fontSize: 7, fontWeight: FontWeight.w700, color: const Color(0xFF00C2D1)),
//                 ),
//               ),
//           ],
//         ),
//       ),
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
import '../Controller/Get_all_item_controller.dart';
import '../Controller/ics_controller.dart';
import '../Model/Item_Model.dart';
import 'PopUp/Right_drawer.dart';

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

  Map<String, List<ItemModel>> _eventsByDate = {};

  bool isLoading = true;
  int activeTab = 0;
  Map<String, dynamic>? selectedSource;
  int currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // ================= DATA LOGIC (UNCHANGED) =================
  void _indexEvents() {
    final Map<String, List<ItemModel>> newMap = {};
    for (var event in syncedEventsData) {
      final dt = DateTime.tryParse(event.startDateTime ?? "");
      if (dt != null) {
        final dateKey = "${dt.year}-${dt.month}-${dt.day}";
        newMap.putIfAbsent(dateKey, () => []).add(event);
      }
    }
    setState(() => _eventsByDate = newMap);
  }

  Future<void> _initializeData() async {
    if (mounted) setState(() => isLoading = true);
    try {
      await _loadManualEvents();
      await _loadIcsSources();
    } catch (e) {
      debugPrint("INITIALIZE ERROR : $e");
    }
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _loadIcsSources() async {
    try {
      final data = await IcsController.getAllIcs();
      List<Map<String, dynamic>> loaded = [];

      for (final source in data) {
        try {
          String content = '';
          if (source['type'] == 'url' && source['originalUrl'] != null) {
            final response = await http.get(Uri.parse(source['originalUrl']));
            if (response.statusCode == 200) content = response.body;
          } else if (source['type'] == 'file' && source['cloudinaryUrl'] != null) {
            final response = await http.get(Uri.parse(source['cloudinaryUrl']));
            if (response.statusCode == 200) content = response.body;
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
            loaded.add({...source, 'events': parsed});
          }
        } catch (e) {
          debugPrint('ICS Parse Error: $e');
        }
      }
      if (mounted) setState(() => syncedSources = loaded);
    } catch (e) {
      debugPrint('Load ICS Error: $e');
    }
  }

  Future<void> _loadManualEvents() async {
    if (!mounted) return;
    try {
      final allItems = await ItemService.fetchItems();
      if (mounted) {
        setState(() {
          manualEvents = allItems.where((e) => e.type == 'event').toList();
        });
      }
    } catch (e) {
      debugPrint("Load Manual Error: $e");
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
          final width = MediaQuery.of(context).size.width;
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            insetPadding: EdgeInsets.symmetric(horizontal: width < 600 ? 15 : 40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            title: Text("Connect Calendar", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
            content: SizedBox(
              width: 500,
              child: Column(
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
                        final file = await IcsController.pickIcsFile();
                        if (file != null) setDialogState(() => pickedFile = file);
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
                            Text(pickedFile == null ? "Select .ics File" : pickedFile!.name,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
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
                  Navigator.pop(context);
                  setState(() => isLoading = true);
                  try {
                    if (dialogTab == 0 && urlController.text.isNotEmpty) {
                      await IcsController.createIcsFromUrl(title: 'Calendar Sync', originalUrl: urlController.text.trim());
                    } else if (dialogTab == 1 && pickedFile != null) {
                      await IcsController.createIcsFromFile(title: pickedFile!.name, file: pickedFile!);
                    }
                    await _loadIcsSources();
                    if (mounted) setState(() => activeTab = 1);
                  } catch (e) {
                    debugPrint('Import Error: $e');
                  }
                  if (mounted) setState(() => isLoading = false);
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1100;
        final isTablet = constraints.maxWidth < 1100 && constraints.maxWidth >= 700;
        final isMobile = constraints.maxWidth < 700;

        return Scaffold(
          endDrawer: CustomRightDrawer(
            isInSublist: false,
            initialSelection: DrawerSelection.event,
            onAddItemToHome: (newItem) => _loadManualEvents(),
          ),
          key: scaffoldKey,
          backgroundColor: const Color(0xFFF8FAFC),
          body: CustomScrollView(
            cacheExtent: 3000,
            slivers: [
              _buildSpaciousHeader(isMobile, isTablet),
              _buildPremiumTabs(isMobile),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 15 : (isTablet ? 30 : 50),
                  vertical: 20,
                ),
                sliver: isLoading
                    ? _buildShimmer(isDesktop, isTablet, isMobile)
                    : _buildBodyContent(isDesktop, isTablet, isMobile),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBodyContent(bool isDesktop, bool isTablet, bool isMobile) {
    int crossCount = isDesktop ? 3 : (isTablet ? 2 : 1);

    if (selectedSource != null) {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossCount,
          mainAxisSpacing: 25,
          crossAxisSpacing: 25,
          childAspectRatio: isMobile ? 0.85 : 0.78,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) => _MonthCard(
            key: ValueKey('month-$index'),
            month: index + 1,
            year: currentYear,
            eventsMap: _eventsByDate,
          ),
          childCount: 12,
        ),
      );
    }

    if (activeTab == 0) {
      int manualCrossCount = isDesktop ? 4 : (isTablet ? 2 : 1);
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: manualCrossCount,
          mainAxisSpacing: 25,
          crossAxisSpacing: 25,
          childAspectRatio: isMobile ? 1.1 : 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) => _buildEventCard(manualEvents[index], isMobile),
          childCount: manualEvents.length,
        ),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: isMobile ? 2.8 : 2.2,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) => _buildSourceTile(syncedSources[index]),
        childCount: syncedSources.length,
      ),
    );
  }

  // ================= RESPONSIVE UI BUILDERS =================
  Widget _buildSpaciousHeader(bool isMobile, bool isTablet) {
    double horizontalPad = isMobile ? 15 : (isTablet ? 30 : 50);
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(horizontalPad, isMobile ? 40 : 60, horizontalPad, 20),
        child: Wrap( // Changed to Wrap for mobile responsiveness
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedSource != null ? selectedSource!['title'] : "Organization Events",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isMobile ? 24 : 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                _statusPill(
                  "Overview • ${activeTab == 0 ? manualEvents.length : syncedSources.length} items",
                ),
              ],
            ),
            if (selectedSource != null)
              _circularActionBtn(Iconsax.close_circle, Colors.redAccent, () => setState(() => selectedSource = null))
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _mainBtn(Iconsax.import, isMobile ? "Sync" : "Sync ICS", Colors.orange.shade600, _showImportDialog, isMobile),
                  const SizedBox(width: 12),
                  _mainBtn(Iconsax.add, isMobile ? "Add" : "Add Event", const Color(0xFF00C2D1), () => scaffoldKey.currentState?.openEndDrawer(), isMobile),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumTabs(bool isMobile) {
    double horizontalPad = isMobile ? 15 : 50;
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 10),
        child: Row(
          children: [
            _tabItem(0, "Manual"),
            const SizedBox(width: 30),
            _tabItem(1, "Synced Sources"),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(ItemModel item, bool isMobile) {
    DateTime? date = DateTime.tryParse(item.startDateTime ?? "");
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 12)),
        ],
      ),
      child: isMobile
          ? Row( // On mobile, show a horizontal layout for manual events if desired, or keep vertical
        children: [
          _imageStack(item, date, isMobile),
          Expanded(child: _eventCardDetails(item, date, isMobile)),
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: _imageStack(item, date, isMobile)),
          _eventCardDetails(item, date, isMobile),
        ],
      ),
    );
  }

  Widget _imageStack(ItemModel item, DateTime? date, bool isMobile) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          width: isMobile ? 120 : double.infinity,
          height: isMobile ? double.infinity : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            image: (item.image != null) ? DecorationImage(image: NetworkImage(item.image!), fit: BoxFit.cover) : null,
            color: const Color(0xFFF1F5F9),
          ),
        ),
        Positioned(top: 20, left: 20, child: _buildDateBadge(date, isMobile)),
      ],
    );
  }

  Widget _eventCardDetails(ItemModel item, DateTime? date, bool isMobile) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isMobile ? 10 : 25, 5, 25, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: isMobile ? 16 : 18, color: const Color(0xFF1E293B))),
          const SizedBox(height: 8),
          _rowDetail(Iconsax.clock, date != null ? DateFormat('hh:mm a').format(date) : "--:--"),
          if (!isMobile) _rowDetail(Iconsax.location, "Event Location"),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(color: Color(0xFFF1F5F9))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Manage", style: GoogleFonts.plusJakartaSans(color: const Color(0xFF007BFF), fontWeight: FontWeight.w700, fontSize: 12)),
              Row(
                children: [
                  const Icon(Iconsax.edit, size: 18, color: Colors.green),
                  const SizedBox(width: 12),
                  const Icon(Iconsax.trash, size: 18, color: Colors.redAccent),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceTile(Map<String, dynamic> source) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedSource = source;
          syncedEventsData = List<ItemModel>.from(source['events']);
          _indexEvents();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Iconsax.link, color: Colors.orange, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(source['title'] ?? '', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16)),
                  Text(source['originalUrl'] ?? 'ICS File', maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await IcsController.deleteIcs(source['_id']);
                  await _loadIcsSources();
                } catch (e) {
                  debugPrint('Delete ICS Error: $e');
                }
              },
              icon: const Icon(Iconsax.trash, color: Colors.redAccent, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateBadge(DateTime? date, bool isMobile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12, vertical: isMobile ? 6 : 8),
          color: Colors.white.withOpacity(0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(date != null ? DateFormat('dd').format(date) : "01",
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: isMobile ? 14 : 18, color: const Color(0xFF1E293B))),
              Text(date != null ? DateFormat('MMM').format(date).toUpperCase() : "MAY",
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: isMobile ? 9 : 11, color: const Color(0xFF00C2D1))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainBtn(IconData icon, String label, Color color, VoidCallback onTap, bool isMobile) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: isMobile ? 18 : 20),
      label: Text(label, style: TextStyle(fontSize: isMobile ? 12 : 14)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 15 : 25, vertical: isMobile ? 15 : 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    );
  }

  // ================= HELPERS (UNCHANGED BUT REFINED) =================
  Widget _statusPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
    );
  }

  Widget _tabItem(int index, String label) {
    bool isSelected = activeTab == index;
    return GestureDetector(
      onTap: () => setState(() { activeTab = index; selectedSource = null; }),
      child: Column(
        children: [
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              color: isSelected ? const Color(0xFF1E293B) : Colors.grey)),
          const SizedBox(height: 6),
          AnimatedContainer(duration: const Duration(milliseconds: 300), height: 4, width: isSelected ? 25 : 0,
              decoration: BoxDecoration(color: const Color(0xFF00C2D1), borderRadius: BorderRadius.circular(10))),
        ],
      ),
    );
  }

  Widget _buildToggle(int current, Function(int) onChange) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(child: _toggleItem("URL Link", current == 0, () => onChange(0))),
          Expanded(child: _toggleItem("Local File", current == 1, () => onChange(1))),
        ],
      ),
    );
  }

  Widget _toggleItem(String label, bool s, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: s ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(10),
            boxShadow: s ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : null),
        child: Center(child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: s ? const Color(0xFF00C2D1) : Colors.grey))),
      ),
    );
  }

  Widget _rowDetail(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF00C2D1)),
        const SizedBox(width: 8),
        Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF64748B), fontWeight: FontWeight.w500))),
      ],
    );
  }

  Widget _circularActionBtn(IconData icon, Color color, VoidCallback onTap) =>
      IconButton(onPressed: onTap, icon: Icon(icon, color: color, size: 30));

  Widget _buildShimmer(bool isDesktop, bool isTablet, bool isMobile) {
    int count = isDesktop ? 4 : (isTablet ? 2 : 1);
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        mainAxisSpacing: 30,
        crossAxisSpacing: 30,
        childAspectRatio: 0.8,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.white,
          child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28))),
        ),
        childCount: 8,
      ),
    );
  }
}

// ================= MONTH CARD & DAY CELL (HIGH PERFORMANCE) =================
class _MonthCard extends StatefulWidget {
  final int month;
  final int year;
  final Map<String, List<ItemModel>> eventsMap;

  const _MonthCard({
    super.key,
    required this.month,
    required this.year,
    required this.eventsMap,
  });

  @override
  State<_MonthCard> createState() => _MonthCardState();
}

class _MonthCardState extends State<_MonthCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final monthName = DateFormat('MMMM').format(DateTime(widget.year, widget.month));
    final daysInMonth = DateTime(widget.year, widget.month + 1, 0).day;
    final firstDay = DateTime(widget.year, widget.month, 1).weekday % 7;
    final List<String> dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: const Color(0xFF00C2D1).withOpacity(0.05), blurRadius: 30, offset: const Offset(0, 15)),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(monthName, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 18, color: const Color(0xFF1E293B))),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            _buildDayLabels(dayLabels),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 0.85,
                ),
                itemCount: daysInMonth + firstDay,
                itemBuilder: (context, index) {
                  if (index < firstDay) return const SizedBox.shrink();
                  int day = index - firstDay + 1;
                  bool isSunday = index % 7 == 0;
                  final dateKey = "${widget.year}-${widget.month}-$day";
                  final dayEvents = widget.eventsMap[dateKey] ?? [];
                  return _DayCell(
                    day: day,
                    hasEvent: dayEvents.isNotEmpty,
                    isSunday: isSunday,
                    eventTitle: dayEvents.isNotEmpty ? dayEvents.first.title : "",
                    monthName: monthName,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayLabels(List<String> labels) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: labels.map((l) => Expanded(
          child: Center(
            child: Text(l, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: l == 'S' ? Colors.redAccent : const Color(0xFF94A3B8))),
          ),
        )).toList(),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool hasEvent;
  final bool isSunday;
  final String eventTitle;
  final String monthName;

  const _DayCell({
    required this.day,
    required this.hasEvent,
    required this.isSunday,
    required this.eventTitle,
    required this.monthName,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: hasEvent ? eventTitle : "$monthName $day",
      verticalOffset: 20,
      preferBelow: false,
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: hasEvent ? const Color(0xFF00C2D1).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$day",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: hasEvent ? const Color(0xFF00C2D1) : (isSunday ? Colors.redAccent : const Color(0xFF64748B)),
              ),
            ),
            if (hasEvent)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  width: 4, height: 4,
                  decoration: const BoxDecoration(color: Color(0xFF00C2D1), shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }
}