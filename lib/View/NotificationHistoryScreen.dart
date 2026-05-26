import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../Controller/PushNotification_controller.dart';
import 'PushNotification.dart';

class MasterIntelligenceHub extends StatefulWidget {
  const MasterIntelligenceHub({super.key});

  @override
  State<MasterIntelligenceHub> createState() => _MasterIntelligenceHubState();
}

class _MasterIntelligenceHubState extends State<MasterIntelligenceHub> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isSocketConnected = true;
  int activeTab = 0; // 0: Scheduled, 1: History
  final Color primaryTeal = const Color(0xFF0D9488);
  final Color darkSlate = const Color(0xFF0F172A);
  final Color bgLight = const Color(0xFFF8FAFC);

  Map<String, dynamic>? selectedNotification;

  void _handleCancel(String id) async {
    try {
      await PushNotificationController.cancelNotification(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Notification successfully cancelled", style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
            backgroundColor: Colors.amber.shade800,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e", style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          )
      );
    }
  }

  String _formatToIST(String? utcString) {
    if (utcString == null || utcString.isEmpty) return "Instant Send";
    DateTime utcTime = DateTime.parse(utcString);
    DateTime istTime = utcTime.add(const Duration(hours: 5, minutes: 30));
    return DateFormat('dd MMM yyyy • hh:mm a').format(istTime);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          bool isLargeScreen = constraints.maxWidth > 950;

          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: bgLight,
            drawer: isLargeScreen ? null : _buildHistoryDrawer(isMobile: true),
            body: Stack(
              children: [
                _buildBackgroundAesthetic(),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SafeArea(
                        child: CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            _buildModernAppBar(isLargeScreen),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isLargeScreen ? 40 : 20,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSocketMonitor(),
                                    const SizedBox(height: 28),
                                    _buildSegmentedToggle(),
                                    const SizedBox(height: 28),
                                    _buildDataView(isLargeScreen),
                                    const SizedBox(height: 80),
                                    _buildWatermarkLogo(),
                                    const SizedBox(height: 40),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isLargeScreen && selectedNotification != null)
                      Container(
                        width: 380,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(-4, 0))
                          ],
                          border: Border(left: BorderSide(color: Colors.grey.shade100, width: 1)),
                        ),
                        child: _buildHistoryDrawer(isMobile: false),
                      ).animate().slideX(begin: 0.2, end: 0, curve: Curves.easeOutCubic, duration: 250.ms).fadeIn(),
                  ],
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildDataView(bool isLargeScreen) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: PushNotificationController.fetchNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(child: CircularProgressIndicator(color: primaryTeal, strokeWidth: 3)),
          );
        }

        final allData = snapshot.data ?? [];
        final now = DateTime.now();

        final scheduled = allData.where((n) {
          if (n['status'] != 'pending' || n['scheduledAt'] == null) return false;
          return DateTime.parse(n['scheduledAt']).toLocal().isAfter(now);
        }).toList();

        final history = allData.where((n) {
          if (n['isScheduled'] == false) return true;
          if (['completed', 'processing', 'sent', 'failed', 'cancelled'].contains(n['status'])) return true;
          if (n['scheduledAt'] != null) {
            return DateTime.parse(n['scheduledAt']).toLocal().isBefore(now);
          }
          return false;
        }).toList();

        final currentList = activeTab == 0 ? scheduled : history;
        if (currentList.isEmpty) return _emptyState();

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: currentList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isLargeScreen ? 2 : 1,
            mainAxisExtent: activeTab == 0 ? 230 : 225,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            final n = currentList[index];
            return activeTab == 0
                ? _actionCard(n).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1, end: 0)
                : _statsCard(n).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1, end: 0);
          },
        );
      },
    );
  }

  // Widget _buildHistoryDrawer({required bool isMobile}) {
  //   if (selectedNotification == null) return const SizedBox.shrink();
  //   return Container(
  //     color: Colors.white,
  //     child: Column(
  //       children: [
  //         _drawerHeader(isMobile),
  //         Expanded(
  //           child: Container(
  //             color: bgLight.withOpacity(0.5),
  //             child: ListView.builder(
  //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
  //               itemCount: (selectedNotification!['fcmTokens'] as List?)?.length ?? 0,
  //               itemBuilder: (context, index) {
  //                 final dynamic tokenData = selectedNotification!['fcmTokens'][index];
  //
  //                 String displayName = "Unknown User";
  //                 String subDetails = "Dispatched via FCM network";
  //                 String platformType = "unknown";
  //
  //                 // Extract data seamlessly if it's an expanded object map or simple token string
  //                 if (tokenData is Map<String, dynamic>) {
  //                   platformType = (tokenData['platform'] ?? 'unknown').toString().toLowerCase();
  //
  //                   if (tokenData.containsKey('name') && tokenData['name'] != null) {
  //                     displayName = tokenData['name'];
  //                   } else if (tokenData.containsKey('userName') && tokenData['userName'] != null) {
  //                     displayName = tokenData['userName'];
  //                   } else if (tokenData.containsKey('userId') && tokenData['userId'] != null) {
  //                     String rawId = tokenData['userId'].toString();
  //                     displayName = "User ID: ...${rawId.substring(rawId.length > 6 ? rawId.length - 6 : 0)}";
  //                   }
  //
  //                   if (tokenData.containsKey('token') && tokenData['token'] != null) {
  //                     String rToken = tokenData['token'].toString();
  //                     subDetails = "FCM Key: ...${rToken.substring(rToken.length > 6 ? rToken.length - 6 : 0)}";
  //                   }
  //                 } else {
  //                   // Fallback to old behavior if raw string token array is passed
  //                   String tString = tokenData.toString();
  //                   displayName = "Token Account";
  //                   subDetails = "...${tString.substring(tString.length > 10 ? tString.length - 10 : 0)}";
  //                 }
  //
  //                 IconData platformIcon = Iconsax.user_tick;
  //                 if (platformType == 'android') platformIcon = Icons.android;
  //                 if (platformType == 'ios') platformIcon = Icons.apple;
  //
  //                 return Container(
  //                   margin: const EdgeInsets.only(bottom: 10),
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(14),
  //                     border: Border.all(color: Colors.grey.shade100),
  //                   ),
  //                   child: ListTile(
  //                     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  //                     leading: Container(
  //                       padding: const EdgeInsets.all(8),
  //                       decoration: BoxDecoration(color: primaryTeal.withOpacity(0.1), shape: BoxShape.circle),
  //                       child: Icon(platformIcon, color: primaryTeal, size: 18),
  //                     ),
  //                     title: Text(
  //                       displayName,
  //                       style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: darkSlate),
  //                     ),
  //                     subtitle: Text(subDetails, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500)),
  //                   ),
  //                 ).animate().fadeIn(delay: (index * 30).ms).slideX(begin: 0.1, end: 0);
  //               },
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildHistoryDrawer({required bool isMobile}) {

    if (selectedNotification == null) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.white,

      child: Column(
        children: [

          _drawerHeader(isMobile),

          Expanded(
            child: Container(
              color: bgLight.withOpacity(0.5),

              child: ListView.builder(

                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),

                itemCount:
                (selectedNotification!['fcmTokens'] as List?)
                    ?.length ?? 0,

                itemBuilder: (context, index) {

                  final dynamic tokenData =
                  selectedNotification!['fcmTokens'][index];

                  String displayName = "Unknown User";
                  String subDetails =
                      "Dispatched via FCM network";

                  String platformType = "unknown";
                  String userId = "N/A";
                  String tokenPreview = "";
                  String status = "sent";

                  /* =====================================================
                   MAP OBJECT SUPPORT
                ===================================================== */

                  if (tokenData is Map<String, dynamic>) {

                    platformType =
                        (tokenData['platform'] ?? 'unknown')
                            .toString()
                            .toLowerCase();

                    status =
                        (tokenData['status'] ?? 'sent')
                            .toString()
                            .toLowerCase();

                    /* ================= USER ID ================= */

                    if (tokenData['userId'] != null) {

                      userId =
                          tokenData['userId'].toString();
                    }

                    /* ================= DISPLAY NAME ================= */

                    if (tokenData['name'] != null) {

                      displayName =
                          tokenData['name'].toString();

                    } else if (tokenData['userName'] != null) {

                      displayName =
                          tokenData['userName'].toString();

                    } else {

                      displayName =
                      "User • ${userId.length > 6
                          ? userId.substring(
                          userId.length - 6)
                          : userId}";
                    }

                    /* ================= TOKEN ================= */

                    if (tokenData['token'] != null) {

                      final rawToken =
                      tokenData['token'].toString();

                      tokenPreview =
                      rawToken.length > 12
                          ? "...${rawToken.substring(
                          rawToken.length - 12)}"
                          : rawToken;

                      subDetails =
                      "FCM • $tokenPreview";
                    }

                  } else {

                    /* =====================================================
                     OLD STRING TOKEN SUPPORT
                  ===================================================== */

                    String rawToken =
                    tokenData.toString();

                    displayName = "Token Device";

                    tokenPreview =
                    rawToken.length > 12
                        ? "...${rawToken.substring(
                        rawToken.length - 12)}"
                        : rawToken;

                    subDetails =
                    "FCM • $tokenPreview";
                  }

                  /* =====================================================
                   PLATFORM ICON
                ===================================================== */

                  IconData platformIcon =
                      Iconsax.mobile;

                  if (platformType == 'android') {
                    platformIcon = Icons.android;
                  }

                  if (platformType == 'ios') {
                    platformIcon = Icons.apple;
                  }

                  bool failed =
                      status == 'failed';

                  return Container(

                    margin:
                    const EdgeInsets.only(bottom: 12),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(16),

                      border: Border.all(

                        color: failed
                            ? Colors.red.withOpacity(0.12)
                            : Colors.grey.shade100,
                      ),
                    ),

                    child: Padding(

                      padding: const EdgeInsets.all(14),

                      child: Row(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          /* ================= ICON ================= */

                          Container(

                            padding:
                            const EdgeInsets.all(10),

                            decoration: BoxDecoration(

                              color: failed
                                  ? Colors.red.withOpacity(0.08)
                                  : primaryTeal.withOpacity(0.08),

                              shape: BoxShape.circle,
                            ),

                            child: Icon(

                              platformIcon,

                              color: failed
                                  ? Colors.red
                                  : primaryTeal,

                              size: 18,
                            ),
                          ),

                          const SizedBox(width: 14),

                          /* ================= CONTENT ================= */

                          Expanded(

                            child: Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                /* ================= NAME ================= */

                                Text(

                                  displayName,

                                  style:
                                  GoogleFonts.plusJakartaSans(

                                    fontSize: 13,

                                    fontWeight:
                                    FontWeight.w700,

                                    color: darkSlate,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                /* ================= USER ID ================= */

                                SelectableText(

                                  "User ID: $userId",

                                  style:
                                  GoogleFonts.inter(

                                    fontSize: 11,

                                    fontWeight:
                                    FontWeight.w600,

                                    color: primaryTeal,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                /* ================= TOKEN ================= */

                                SelectableText(

                                  subDetails,

                                  style:
                                  GoogleFonts.inter(

                                    fontSize: 10.5,

                                    color:
                                    Colors.grey.shade500,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                /* ================= STATUS ================= */

                                Container(

                                  padding:
                                  const EdgeInsets.symmetric(

                                    horizontal: 10,
                                    vertical: 5,
                                  ),

                                  decoration: BoxDecoration(

                                    color: failed
                                        ? Colors.red.withOpacity(0.08)
                                        : Colors.green.withOpacity(0.08),

                                    borderRadius:
                                    BorderRadius.circular(30),
                                  ),

                                  child: Text(

                                    status.toUpperCase(),

                                    style:
                                    GoogleFonts.inter(

                                      fontSize: 10,

                                      fontWeight:
                                      FontWeight.w700,

                                      color: failed
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(
                      delay: (index * 30).ms)
                      .slideX(
                      begin: 0.08,
                      end: 0);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, isMobile ? 60 : 32, 24, 32),
      width: double.infinity,
      decoration: BoxDecoration(
        color: darkSlate,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) ...[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Iconsax.close_circle, color: Colors.white38, size: 22),
                onPressed: () => setState(() => selectedNotification = null),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.tealAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Iconsax.user_octagon, color: Colors.tealAccent, size: 24),
          ),
          const SizedBox(height: 20),
          Text(
            selectedNotification!['title'] ?? "Audience Tracking",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, height: 1.3),
          ),
          const SizedBox(height: 6),
          Text(
            "Recipient Payload Hierarchy • ${selectedNotification!['type'] ?? 'Broadcast'}",
            style: GoogleFonts.inter(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _actionCard(Map<String, dynamic> n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.015), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Iconsax.timer_1, color: Colors.amber, size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                      n['title'] ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 15, color: darkSlate)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Text(
                  n['body'] ?? "",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600, height: 1.5)
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Colors.grey.shade100, height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _cardFooter("SCHEDULED RELEASE", _formatToIST(n['scheduledAt'])),
                _editDeleteControls(n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statsCard(Map<String, dynamic> n) {
    bool isCurrentSelected = selectedNotification?['_id'] == n['_id'];
    bool isScheduledType = n['isScheduled'] ?? (n['scheduledAt'] != null);
    String messageType = (n['type'] ?? (isScheduledType ? 'Scheduled Campaign' : 'Instant Broadcast')).toString();

    return GestureDetector(
      onTap: () {
        setState(() => selectedNotification = n);
        if (MediaQuery.of(context).size.width <= 950) {
          _scaffoldKey.currentState?.openDrawer();
        }
      },
      child: AnimatedContainer(
        duration: 200.ms,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isCurrentSelected ? primaryTeal.withOpacity(0.5) : Colors.grey.shade100, width: isCurrentSelected ? 1.5 : 1),
          boxShadow: [
            BoxShadow(
                color: isCurrentSelected ? primaryTeal.withOpacity(0.04) : Colors.black.withOpacity(0.01),
                blurRadius: 16,
                offset: const Offset(0, 4)
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: primaryTeal.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                    child: Icon(Iconsax.notification_bing, color: primaryTeal, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            n['title'] ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14, color: darkSlate)
                        ),
                        const SizedBox(height: 2),
                        Text(
                          messageType.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.bold, color: isScheduledType ? Colors.amber.shade700 : primaryTeal, letterSpacing: 0.3),
                        ),
                      ],
                    ),
                  ),
                  Icon(Iconsax.arrow_right_3, size: 14, color: Colors.grey.shade300),
                ],
              ),
              const Spacer(),
              _buildStatBadges(n['_id']),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: bgLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade100)
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.calendar_1, size: 12, color: Colors.blueGrey.shade400),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _formatToIST(n['scheduledAt']),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade700),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey.shade200)),
                      child: Text(
                          (n['status'] ?? 'sent').toString().toUpperCase(),
                          style: GoogleFonts.inter(fontSize: 8.5, fontWeight: FontWeight.bold, color: darkSlate)
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar(bool isLargeScreen) => SliverAppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    floating: true,
    automaticallyImplyLeading: false,
    title: Padding(
      padding: EdgeInsets.symmetric(horizontal: isLargeScreen ? 24 : 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]
            ),
            child: Icon(Iconsax.chart_21, color: primaryTeal, size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Intelligence Hub", style: GoogleFonts.plusJakartaSans(color: darkSlate, fontWeight: FontWeight.w800, fontSize: 22)),
              Text("Automated Campaign Control Tower", style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w400)),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildSocketMonitor() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    decoration: BoxDecoration(
        color: darkSlate,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: darkSlate.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 6))]
    ),
    child: Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: isSocketConnected ? Colors.tealAccent : Colors.redAccent, shape: BoxShape.circle))
                .animate(onPlay: (c) => c.repeat()).scale(end: const Offset(2.2, 2.2)).fadeOut(duration: 1000.ms),
            Container(width: 10, height: 10, decoration: BoxDecoration(color: isSocketConnected ? Colors.tealAccent : Colors.redAccent, shape: BoxShape.circle)),
          ],
        ),
        const SizedBox(width: 14),
        Text(
            isSocketConnected ? "SYSTEM STREAM ACTIVE" : "STREAM OFFLINE",
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.7)
        ),
        const Spacer(),
        Text("V2.4 LIVE", style: GoogleFonts.inter(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        const Icon(Iconsax.radar, color: Colors.white38, size: 18),
      ],
    ),
  );

  Widget _badge(String val, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.15), width: 1)
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(color == Colors.green ? Iconsax.verify : Iconsax.danger, color: color, size: 14),
        const SizedBox(width: 6),
        Text(val, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 11, color: color.withOpacity(0.9))),
      ],
    ),
  );

  Widget _buildStatBadges(String id) {
    return FutureBuilder<Map<String, dynamic>>(
      future: PushNotificationController.getDeliveryStats(id),
      builder: (context, snapshot) {
        final sent = snapshot.data?['sent'] ?? 0;
        final failed = snapshot.data?['failed'] ?? 0;
        return Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            _badge("$sent Delivered", Colors.green),
            _badge("$failed Dropped", Colors.red.shade400),
          ],
        );
      },
    );
  }

  Widget _editDeleteControls(Map<String, dynamic> n) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _iconActionButton(icon: Iconsax.edit, color: Colors.blue.shade600, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PushNotification(initialData: n)))),
        const SizedBox(width: 6),
        _iconActionButton(icon: Iconsax.close_circle, color: Colors.orange.shade600, onTap: () => _handleCancel(n['_id'])),
        const SizedBox(width: 6),
        _iconActionButton(icon: Iconsax.trash, color: Colors.red.shade600, onTap: () => _confirmDelete(n['_id'])),
      ],
    );
  }

  Widget _iconActionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 15),
      ),
    );
  }

  Widget _cardFooter(String label, String time) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: GoogleFonts.plusJakartaSans(color: Colors.blueGrey.shade400, fontWeight: FontWeight.bold, fontSize: 9, letterSpacing: 0.3)),
      const SizedBox(height: 2),
      Text(time, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: primaryTeal)),
    ],
  );

  Widget _buildSegmentedToggle() => Container(
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
    child: Row(children: [_toggleButton("Scheduled Desk", 0), _toggleButton("Broadcast Logs", 1)]),
  );

  Widget _toggleButton(String label, int index) {
    bool isSelected = activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          activeTab = index;
          selectedNotification = null;
        }),
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))] : null
          ),
          child: Center(
            child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? primaryTeal : Colors.blueGrey.shade500)
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWatermarkLogo() => Opacity(
    opacity: 0.15,
    child: Column(
      children: [
        Icon(Iconsax.setting_5, size: 36, color: Colors.blueGrey.shade400),
        const SizedBox(height: 6),
        Text("ANCIL MEDIA SYSTEM", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 5, color: Colors.blueGrey.shade600)),
      ],
    ),
  );

  Widget _buildBackgroundAesthetic() => Positioned(
      top: -150,
      left: -150,
      child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(color: primaryTeal.withOpacity(0.035), shape: BoxShape.circle)
      )
  );

  Widget _emptyState() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            Icon(Iconsax.box, size: 40, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text("No active deployments tracked", style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      )
  );

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Purge Record?", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: darkSlate)),
        content: Text("This action permanently erases data history across execution trees.", style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Dismiss", style: GoogleFonts.inter(color: Colors.grey.shade600, fontWeight: FontWeight.w600))
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
              onPressed: () async {
                await PushNotificationController.deleteNotification(id);
                Navigator.pop(context);
                setState(() {});
              },
              child: Text("Purge", style: GoogleFonts.inter(color: Colors.red.shade700, fontWeight: FontWeight.bold))
          ),
        ],
      ),
    );
  }
}