import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controller/Media_analytics_controller.dart';
import 'Sidebar.dart';
import 'Media_Analytics_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double sidebarWidth = 250;

  final AnalyticsService analyticsService = AnalyticsService();
  Map<String, dynamic>? dashboardData;
  bool isLoading = true;
  String? error;
  late TooltipBehavior _tooltipBehavior;
  bool _usedGlobalFallback = false; // show friendly banner when we used global fallback

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    setState(() {
      isLoading = true;
      error = null;
      _usedGlobalFallback = false;
    });

    try {
      Map<String, dynamic> data;

      // Try org-scoped dashboard endpoint first. If backend doesn't expose
      // it (404), fall back to the global dashboard endpoint which accepts
      // organizationId as a query parameter.
      try {
        data = await analyticsService.getAllMediaAnalyticsByOrganization(useDashboard: true);
      } catch (e) {
        final msg = e.toString();
        print('[Home] org-specific dashboard failed: $msg');
        // Be permissive in matching 404 / not found errors from the service
        if (msg.contains('404') || msg.toLowerCase().contains('not found') || msg.contains('Failed: 404')) {
          print('[Home] falling back to global dashboard endpoint');
          _usedGlobalFallback = true;
          data = await analyticsService.getAllMediaAnalytics(useDashboard: true);
        } else {
          rethrow;
        }
      }

      // Normalize and sort chartData by date (support common backend shapes)
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
        error = 'Analytics unavailable. ${e.toString()}';
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

  int get totalPlays {
    if (dashboardData == null) return 0;
    if (dashboardData!['totalPlays'] != null) return _safeInt(dashboardData!['totalPlays']);
    if (dashboardData!['totalViews'] != null) return _safeInt(dashboardData!['totalViews']);

    final chart = List<Map<String, dynamic>>.from(dashboardData!['chartData'] ?? []);
    int sum = 0;
    for (final m in chart) {
      if (m['total'] != null) {
        sum += _safeInt(m['total']);
      } else {
        for (final k in m.keys) {
          if (k == 'month' || k == 'monthLabel' || k == 'dateObj') continue;
          sum += _safeInt(m[k]);
        }
      }
    }
    return sum;
  }

  Map<String, int> get deviceDistribution {
    final Map<String, int> out = {};
    final chart = List<Map<String, dynamic>>.from(dashboardData?['chartData'] ?? []);
    final known = <String>{'ios', 'android', 'webApp', 'appleTv', 'roku', 'webEmbed', 'other'};

    for (final m in chart) {
      for (final entry in m.entries) {
        final k = entry.key;
        if (k == 'month' || k == 'monthLabel' || k == 'dateObj' || k == 'total') continue;
        if (known.contains(k) || entry.value is num) {
          out[k] = (out[k] ?? 0) + _safeInt(entry.value);
        }
      }
    }

    // If backend returned a neat distribution, merge it
    final Map<String, dynamic>? backendDist = dashboardData?['deviceDistribution'] as Map<String, dynamic>?;
    if (backendDist != null) {
      backendDist.forEach((k, v) => out[k] = _safeInt(v));
    }

    return out;
  }

  List<Map<String, dynamic>> get monthlySeries {
    final chart = List<Map<String, dynamic>>.from(dashboardData?['chartData'] ?? []);
    return chart.map((m) {
      // compute total per month
      int t = 0;
      if (m['total'] != null) t = _safeInt(m['total']);
      else {
        for (final e in m.entries) {
          if (e.key == 'month' || e.key == 'monthLabel' || e.key == 'dateObj') continue;
          t += _safeInt(e.value);
        }
      }
      return {'month': m['monthLabel'] ?? m['month'] ?? '', 'value': t, 'date': m['dateObj']};
    }).toList();
  }

  int get peakPlays {
    final series = monthlySeries;
    if (series.isEmpty) return 0;
    return series.map((e) => _safeInt(e['value'])).reduce((a, b) => a > b ? a : b);
  }

  String get peakMonth {
    final series = monthlySeries;
    if (series.isEmpty) return '-';
    final top = series.reduce((a, b) => _safeInt(a['value']) >= _safeInt(b['value']) ? a : b);
    return top['month'] ?? '-';
  }

  int get mediaCount {
    if (dashboardData == null) return 0;
    if (dashboardData!['mediaCount'] != null) return _safeInt(dashboardData!['mediaCount']);
    final list = List.from(dashboardData!['mediaList'] ?? []);
    return list.length;
  }

  String _fmt(int value) => NumberFormat.compact().format(value);

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: isLargeScreen ? null : AppBar(title: const Text("Home")),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_circle_outline, size: 96, color: Colors.grey),
                  const SizedBox(height: 12),
                  const CircularProgressIndicator(),
                ],
              ),
            )
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 8),
                      ElevatedButton(onPressed: fetchDashboard, child: const Text('Retry')),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard('Total Plays', _fmt(totalPlays), Icons.play_arrow),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard('Peak Plays', '${_fmt(peakPlays)} • $peakMonth', Icons.show_chart),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard('Media Items', _fmt(mediaCount), Icons.movie),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      if (_usedGlobalFallback)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Organization-specific dashboard not available — showing global analytics.',
                              style: TextStyle(color: Colors.orange.shade800, fontSize: 13),
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Chart & Distribution
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Monthly Plays', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      height: 300,
                                      child: monthlySeries.isEmpty
                                          ? const Center(child: Text('No monthly plays data', style: TextStyle(color: Colors.grey)))
                                          : SfCartesianChart(
                                              primaryXAxis: CategoryAxis(labelRotation: -45),
                                              tooltipBehavior: _tooltipBehavior,
                                              series: <CartesianSeries<Map<String, dynamic>, String>>[
                                                ColumnSeries<Map<String, dynamic>, String>(
                                                  dataSource: monthlySeries,
                                                  xValueMapper: (d, _) => d['month']?.toString() ?? '',
                                                  yValueMapper: (d, _) => d['value'] ?? 0,
                                                  color: Colors.cyan,
                                                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                                                ),
                                              ],
                                            ),
                                    ),
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnalyticsPage())),
                                        child: const Text('View full analytics →'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            flex: 2,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Device Distribution', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      height: 220,
                                      child: deviceDistribution.isEmpty
                                          ? const Center(child: Text('No device distribution data', style: TextStyle(color: Colors.grey)))
                                          : SfCircularChart(
                                              legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                                              series: <CircularSeries>[
                                                PieSeries<MapEntry<String, int>, String>(
                                                  dataSource: deviceDistribution.entries.toList(),
                                                  xValueMapper: (e, _) => e.key,
                                                  yValueMapper: (e, _) => e.value,
                                                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                                                ),
                                              ],
                                            ),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton.icon(
                                      onPressed: fetchDashboard,
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Refresh'),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 6))]),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.cyan),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600)),
              const SizedBox(height: 6),
              Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
