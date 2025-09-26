// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:intl/intl.dart';
// import '../Controller/Media_analytics_controller.dart';
//
// class MediaAnalyticsDashboard extends StatefulWidget {
//   const MediaAnalyticsDashboard({super.key});
//
//   @override
//   State<MediaAnalyticsDashboard> createState() =>
//       _MediaAnalyticsDashboardState();
// }
//
// class _MediaAnalyticsDashboardState extends State<MediaAnalyticsDashboard> {
//   Map<String, dynamic>? analyticsData;
//   bool isLoading = true;
//   String? error;
//   late TooltipBehavior _tooltipBehavior;
//
//   @override
//   void initState() {
//     super.initState();
//     _tooltipBehavior = TooltipBehavior(enable: true);
//     fetchAnalytics();
//   }
//
//   Future<void> fetchAnalytics() async {
//     setState(() {
//       isLoading = true;
//       error = null;
//     });
//
//     try {
//       final data = await AnalyticsService.getAllMediaAnalytics(limit: 200);
//       if (data != null) {
//         final mediaList = List<Map<String, dynamic>>.from(data['mediaList'] ?? []);
//         final Map<String, Map<String, dynamic>> aggregated = {};
//
//         for (final item in mediaList) {
//           final dateString = item['date']?.toString() ?? "";
//           DateTime date;
//           try {
//             date = DateTime.parse(dateString);
//           } catch (_) {
//             continue;
//           }
//
//           // Month key like "Sep 2025"
//           final monthKey = DateFormat('MMM yyyy').format(date);
//
//           if (!aggregated.containsKey(monthKey)) {
//             aggregated[monthKey] = {
//               'time': monthKey,
//               'ios': 0,
//               'android': 0,
//               'webApp': 0,
//               'appleTv': 0,
//               'roku': 0,
//               'webEmbed': 0,
//             };
//           }
//
//           final devices = Map<String, dynamic>.from(item['devices'] ?? {});
//
//           aggregated[monthKey]!['ios'] =
//               (aggregated[monthKey]!['ios'] ?? 0) + (devices['ios']?.toInt() ?? 0);
//           aggregated[monthKey]!['android'] =
//               (aggregated[monthKey]!['android'] ?? 0) + (devices['android']?.toInt() ?? 0);
//           aggregated[monthKey]!['webApp'] =
//               (aggregated[monthKey]!['webApp'] ?? 0) + (devices['webApp']?.toInt() ?? 0);
//           aggregated[monthKey]!['appleTv'] =
//               (aggregated[monthKey]!['appleTv'] ?? 0) + (devices['appleTv']?.toInt() ?? 0);
//           aggregated[monthKey]!['roku'] =
//               (aggregated[monthKey]!['roku'] ?? 0) + (devices['roku']?.toInt() ?? 0);
//           aggregated[monthKey]!['webEmbed'] =
//               (aggregated[monthKey]!['webEmbed'] ?? 0) + (devices['webEmbed']?.toInt() ?? 0);
//         }
//
//         // Sort months chronologically
//         final chartData = aggregated.values.toList()
//           ..sort((a, b) =>
//               DateFormat('MMM yyyy').parse(a['time'] as String).compareTo(
//                   DateFormat('MMM yyyy').parse(b['time'] as String)));
//
//         setState(() {
//           analyticsData = {...data, 'chartData': chartData};
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           error = "Failed to load analytics.";
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         error = "Error: $e";
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("📊 Media Analytics"),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : error != null
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(error!, style: const TextStyle(color: Colors.red)),
//             const SizedBox(height: 10),
//             ElevatedButton(
//                 onPressed: fetchAnalytics, child: const Text("Retry")),
//           ],
//         ),
//       )
//           : buildDashboard(),
//     );
//   }
//
//   Widget buildDashboard() {
//     final chartData =
//     List<Map<String, dynamic>>.from(analyticsData?['chartData'] ?? []);
//     final mediaList =
//     List<Map<String, dynamic>>.from(analyticsData?['mediaList'] ?? []);
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// 📈 Month-wise stacked chart
//           Card(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             elevation: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: SizedBox(
//                 height: 320,
//                 child: SfCartesianChart(
//                   primaryXAxis: CategoryAxis(labelRotation: -45),
//                   title: ChartTitle(text: 'Device Analytics (Month-wise)'),
//                   legend: Legend(isVisible: true),
//                   tooltipBehavior: _tooltipBehavior,
//                   series: <CartesianSeries>[
//                     StackedColumnSeries<Map<String, dynamic>, String>(
//                       dataSource: chartData,
//                       xValueMapper: (data, _) => data['time'] as String,
//                       yValueMapper: (data, _) => data['ios'] as int,
//                       name: 'iOS',
//                       color: Colors.amber,
//                       dataLabelSettings: const DataLabelSettings(isVisible: true),
//                     ),
//                     StackedColumnSeries<Map<String, dynamic>, String>(
//                       dataSource: chartData,
//                       xValueMapper: (data, _) => data['time'] as String,
//                       yValueMapper: (data, _) => data['android'] as int,
//                       name: 'Android',
//                       color: Colors.blue,
//                       dataLabelSettings: const DataLabelSettings(isVisible: true),
//                     ),
//                     StackedColumnSeries<Map<String, dynamic>, String>(
//                       dataSource: chartData,
//                       xValueMapper: (data, _) => data['time'] as String,
//                       yValueMapper: (data, _) => data['webApp'] as int,
//                       name: 'Web App',
//                       color: Colors.green,
//                       dataLabelSettings: const DataLabelSettings(isVisible: true),
//                     ),
//                     StackedColumnSeries<Map<String, dynamic>, String>(
//                       dataSource: chartData,
//                       xValueMapper: (data, _) => data['time'] as String,
//                       yValueMapper: (data, _) => data['appleTv'] as int,
//                       name: 'Apple TV',
//                       color: Colors.purple,
//                       dataLabelSettings: const DataLabelSettings(isVisible: true),
//                     ),
//                     StackedColumnSeries<Map<String, dynamic>, String>(
//                       dataSource: chartData,
//                       xValueMapper: (data, _) => data['time'] as String,
//                       yValueMapper: (data, _) => data['roku'] as int,
//                       name: 'Roku',
//                       color: Colors.orange,
//                       dataLabelSettings: const DataLabelSettings(isVisible: true),
//                     ),
//                     StackedColumnSeries<Map<String, dynamic>, String>(
//                       dataSource: chartData,
//                       xValueMapper: (data, _) => data['time'] as String,
//                       yValueMapper: (data, _) => data['webEmbed'] as int,
//                       name: 'Web Embed',
//                       color: Colors.teal,
//                       dataLabelSettings: const DataLabelSettings(isVisible: true),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           /// 📋 Media table
//           Text("Media", style: Theme.of(context).textTheme.titleMedium),
//           const SizedBox(height: 8),
//           Column(
//             children: mediaList.map((item) {
//               return Container(
//                 margin: const EdgeInsets.symmetric(vertical: 4),
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade200),
//                 ),
//                 child: Row(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(6),
//                       child: Image.network(
//                         item['thumbnailUrl'] ?? "",
//                         width: 60,
//                         height: 40,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) => Container(
//                           width: 60,
//                           height: 40,
//                           color: Colors.grey.shade300,
//                           child: const Icon(Icons.image_not_supported, size: 20),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       flex: 4,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(item['title'] ?? "",
//                               style:
//                               const TextStyle(fontWeight: FontWeight.w600)),
//                           Text(item['date'] ?? "",
//                               style: const TextStyle(
//                                   color: Colors.black54, fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                     Expanded(flex: 2, child: Text(item['plays'].toString())),
//                     Expanded(flex: 2, child: Text(item['uniqueViewers'].toString())),
//                     Expanded(flex: 3, child: Text(item['avgDuration'].toString())),
//                     Expanded(flex: 3, child: Text(item['totalPlayTime'].toString())),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }
