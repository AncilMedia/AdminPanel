


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

  bool isLoading = true;
  int activeTab = 0;
  Map<String, dynamic>? selectedSource;
  int currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _loadManualEvents();
  }

  // =========================================================
  // LOAD ICS SOURCES
  // =========================================================
  Future<void> _loadIcsSources() async {
    try {
      final data = await IcsController.getAllIcs();

      List<Map<String, dynamic>> loaded = [];

      for (final source in data) {
        try {
          String content = '';

          // =================================================
          // URL TYPE
          // =================================================
          if (source['type'] == 'url' && source['originalUrl'] != null) {
            final response = await http.get(Uri.parse(source['originalUrl']));

            if (response.statusCode == 200) {
              content = response.body;
            }
          }

          // =================================================
          // FILE TYPE
          // =================================================
          if (source['type'] == 'file' && source['cloudinaryUrl'] != null) {
            final response = await http.get(Uri.parse(source['cloudinaryUrl']));

            if (response.statusCode == 200) {
              content = response.body;
            }
          }

          // =================================================
          // PARSE ICS
          // =================================================
          if (content.contains('BEGIN:VCALENDAR')) {
            final calendar = ICalendar.fromString(content);

            List<ItemModel> parsed = [];

            for (var entry in calendar.data) {
              if (entry['type'] == 'VEVENT') {
                IcsDateTime? dt = entry['dtstart'];

                parsed.add(
                  ItemModel(
                    id: entry['uid']?.toString() ?? UniqueKey().toString(),

                    title: entry['summary']?.toString() ?? 'Busy',

                    startDateTime: dt?.toDateTime()?.toIso8601String(),

                    type: 'event',
                  ),
                );
              }
            }

            loaded.add({...source, 'events': parsed});
          }
        } catch (e) {
          debugPrint('ICS Parse Error: $e');
        }
      }

      if (mounted) {
        setState(() {
          syncedSources = loaded;
        });
      }
    } catch (e) {
      debugPrint('Load ICS Error: $e');
    }
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
                    // onTap: () async {
                    //   FilePickerResult? result = await FilePicker.platform.pickFiles(
                    //     type: FileType.custom,
                    //     allowedExtensions: ['ics'],
                    //     withData: true,
                    //   );
                    //   if (result != null) setDialogState(() => pickedFile = result.files.first);
                    // },
                    onTap: () async {
                      final file = await IcsController.pickIcsFile();

                      if (file != null) {
                        setDialogState(() {
                          pickedFile = file;
                        });
                      }
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
      endDrawer: CustomRightDrawer(
        isInSublist: false,
        initialSelection: DrawerSelection.event,
        onAddItemToHome: (newItem) => _loadManualEvents(),
      ),
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
                  _mainBtn(Iconsax.add, "Add Event", const Color(0xFF00C2D1), () => scaffoldKey.currentState?.openEndDrawer(),
                  ),
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