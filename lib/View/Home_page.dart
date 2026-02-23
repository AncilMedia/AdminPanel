import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../Controller/Media_analytics_controller.dart';
import 'Media_Analytics_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AnalyticsService analyticsService = AnalyticsService();
  Map<String, dynamic>? dashboardData;
  bool isLoading = true;
  String? error;
  late TooltipBehavior _tooltipBehavior;
  bool _usedGlobalFallback = false;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    fetchDashboard();
  }

  // ================= DATA LOGIC (FIXES ERRORS) =================

  Future<void> fetchDashboard() async {
    setState(() {
      isLoading = true;
      error = null;
      _usedGlobalFallback = false;
    });

    try {
      Map<String, dynamic> data;
      try {
        data = await analyticsService.getAllMediaAnalyticsByOrganization(useDashboard: true);
      } catch (e) {
        final msg = e.toString();
        if (msg.contains('404') || msg.toLowerCase().contains('not found')) {
          _usedGlobalFallback = true;
          data = await analyticsService.getAllMediaAnalytics(useDashboard: true);
        } else {
          rethrow;
        }
      }

      final rawChart = List<Map<String, dynamic>>.from(data['chartData'] ?? []);
      final df = DateFormat('MMM yyyy');

      final processed = rawChart.map((d) {
        final monthStr = (d['month'] ?? d['label'] ?? '').toString();
        DateTime parsed;
        try {
          parsed = df.parse(monthStr);
        } catch (_) {
          parsed = DateTime.now();
        }
        return {...d, 'monthLabel': monthStr, 'dateObj': parsed};
      }).toList();

      processed.sort((a, b) => (a['dateObj'] as DateTime).compareTo(b['dateObj'] as DateTime));
      data['chartData'] = processed;

      setState(() {
        dashboardData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Analytics unavailable: $e';
        isLoading = false;
      });
    }
  }

  int _safeInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  String _fmt(int value) => NumberFormat.compact().format(value);

  // --- Getters ---
  int get totalPlays {
    if (dashboardData == null) return 0;
    return _safeInt(dashboardData!['totalPlays'] ?? dashboardData!['totalViews']);
  }

  int get mediaCount {
    if (dashboardData == null) return 0;
    return _safeInt(dashboardData!['mediaCount'] ?? (dashboardData!['mediaList'] as List?)?.length);
  }

  List<Map<String, dynamic>> get monthlySeries {
    final chart = List<Map<String, dynamic>>.from(dashboardData?['chartData'] ?? []);
    return chart.map((m) {
      int t = m['total'] != null ? _safeInt(m['total']) : 0;
      if (t == 0) {
        m.forEach((k, v) {
          if (k != 'month' && k != 'monthLabel' && k != 'dateObj') t += _safeInt(v);
        });
      }
      return {'month': m['monthLabel'] ?? '', 'value': t};
    }).toList();
  }

  int get peakPlays {
    if (monthlySeries.isEmpty) return 0;
    return monthlySeries.map((e) => _safeInt(e['value'])).reduce((a, b) => a > b ? a : b);
  }

  String get peakMonth {
    if (monthlySeries.isEmpty) return '-';
    return monthlySeries.reduce((a, b) => _safeInt(a['value']) >= _safeInt(b['value']) ? a : b)['month'];
  }

  Map<String, int> get deviceDistribution {
    final Map<String, int> out = {};
    final chart = List<Map<String, dynamic>>.from(dashboardData?['chartData'] ?? []);
    for (var m in chart) {
      m.forEach((k, v) {
        if (!['month', 'monthLabel', 'dateObj', 'total'].contains(k)) {
          out[k] = (out[k] ?? 0) + _safeInt(v);
        }
      });
    }
    return out;
  }

  // ================= UI BUILDER =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: isLoading
          ? _buildLoadingState()
          : error != null
          ? _buildErrorState()
          : SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Plays', _fmt(totalPlays), Iconsax.play_circle, [Colors.blue.shade700, Colors.blue.shade400])),
                const SizedBox(width: 24),
                Expanded(child: _buildStatCard('Peak Plays', _fmt(peakPlays), Iconsax.graph, [Colors.purple.shade700, Colors.purple.shade400], subtitle: "Top Month: $peakMonth")),
                const SizedBox(width: 24),
                Expanded(child: _buildStatCard('Media Items', _fmt(mediaCount), Iconsax.video_play, [Colors.teal.shade700, Colors.teal.shade400])),
              ],
            ),
            const SizedBox(height: 32),
            if (_usedGlobalFallback) _buildFallbackBanner(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildDashboardCard(
                    title: 'Monthly Performance',
                    subtitle: 'Trend of content engagement',
                    action: TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyticsPage())),
                      child: const Text("View All"),
                    ),
                    child: SizedBox(height: 300, child: _buildMainChart()),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: _buildDashboardCard(
                    title: 'Platforms',
                    subtitle: 'Device distribution',
                    child: SizedBox(height: 300, child: _buildCircularChart()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _buildHeader() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Overview", style: GoogleFonts.poppins(fontSize: 14, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
      Text("Analytics Dashboard", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade900)),
    ]);
  }

  Widget _buildStatCard(String title, String value, IconData icon, List<Color> gradient, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)]),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(gradient: LinearGradient(colors: gradient), borderRadius: BorderRadius.circular(18)),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 20),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 14, color: Colors.blueGrey)),
          Text(value, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
          if (subtitle != null) Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600)),
        ]),
      ]),
    );
  }

  Widget _buildDashboardCard({required String title, required String subtitle, required Widget child, Widget? action}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(subtitle, style: GoogleFonts.poppins(fontSize: 13, color: Colors.blueGrey)),
          ]),
          if (action != null) action,
        ]),
        const SizedBox(height: 24),
        child,
      ]),
    );
  }

  Widget _buildMainChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(axisLine: const AxisLine(width: 0), majorTickLines: const MajorTickLines(size: 0)),
      tooltipBehavior: _tooltipBehavior,
      series: <CartesianSeries<Map<String, dynamic>, String>>[
        SplineAreaSeries<Map<String, dynamic>, String>(
          dataSource: monthlySeries,
          xValueMapper: (d, _) => d['month'],
          yValueMapper: (d, _) => d['value'],
          gradient: LinearGradient(colors: [Colors.indigo.withOpacity(0.3), Colors.indigo.withOpacity(0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderColor: Colors.indigo,
          borderWidth: 2,
        ),
      ],
    );
  }

  Widget _buildCircularChart() {
    return SfCircularChart(
      legend: Legend(isVisible: true, position: LegendPosition.bottom),
      series: <CircularSeries>[
        DoughnutSeries<MapEntry<String, int>, String>(
          dataSource: deviceDistribution.entries.toList(),
          xValueMapper: (e, _) => e.key.toUpperCase(),
          yValueMapper: (e, _) => e.value,
          innerRadius: '70%',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(error ?? "Unknown Error"),
      ElevatedButton(onPressed: fetchDashboard, child: const Text("Retry"))
    ]));
  }

  Widget _buildFallbackBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12)),
      child: Text("Showing global analytics fallback.", style: TextStyle(color: Colors.orange.shade900)),
    );
  }
}