// // // import 'package:flutter/material.dart';
// // // import 'package:mrx_charts/mrx_charts.dart';
// // //
// // // class MediaAnalyticsDashboard extends StatelessWidget {
// // //   const MediaAnalyticsDashboard({super.key});
// // //
// // //   // Mock data
// // //   final List<Map<String, dynamic>> chartData = const [
// // //     {"month": "Jan 2025", "ios": 2200, "android": 300, "web": 50},
// // //     {"month": "Feb 2025", "ios": 1000, "android": 150, "web": 20},
// // //     {"month": "Mar 2025", "ios": 1500, "android": 250, "web": 30},
// // //     {"month": "Apr 2025", "ios": 1550, "android": 400, "web": 40},
// // //     {"month": "May 2025", "ios": 1400, "android": 320, "web": 30},
// // //     {"month": "Jun 2025", "ios": 1350, "android": 450, "web": 25},
// // //     {"month": "Jul 2025", "ios": 1450, "android": 470, "web": 35},
// // //     {"month": "Aug 2025", "ios": 1430, "android": 430, "web": 28},
// // //     {"month": "Sep 2025", "ios": 900, "android": 250, "web": 20},
// // //   ];
// // //
// // //   final List<Map<String, dynamic>> mediaList = const [
// // //     {
// // //       "thumbnail": "https://images.pexels.com/photos/1496373/pexels-photo-1496373.jpeg",
// // //       "title": "RedHill (Live)",
// // //       "date": "May 28, 2021",
// // //       "plays": 2731,
// // //       "uniqueViewers": 570,
// // //       "avgDuration": "32m 4s",
// // //       "totalPlayTime": "1442h 58m",
// // //     },
// // //     {
// // //       "thumbnail": "https://images.pexels.com/photos/3052361/pexels-photo-3052361.jpeg",
// // //       "title": "Central Oahu (Live)",
// // //       "date": "May 28, 2021",
// // //       "plays": 46,
// // //       "uniqueViewers": 12,
// // //       "avgDuration": "15m 0s",
// // //       "totalPlayTime": "4h 0m",
// // //     },
// // //   ];
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text("📊 Media Analytics"),
// // //         backgroundColor: Colors.white,
// // //         foregroundColor: Colors.black87,
// // //         elevation: 0,
// // //       ),
// // //       body: SingleChildScrollView(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             /// 📈 Chart Section
// // //             Card(
// // //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //               elevation: 2,
// // //               child: Padding(
// // //                 padding: const EdgeInsets.all(16),
// // //                 child: SizedBox(
// // //                   height: 250,
// // //                   child: Chart(
// // //                     layers: [
// // //                       ChartAxisLayer(
// // //                         settings: ChartAxisSettings(
// // //                           x: ChartAxisSettingsAxis(
// // //                             frequency: 1.0,
// // //                             max: chartData.length.toDouble(),
// // //                             min: 0.0,
// // //                             textStyle: const TextStyle(fontSize: 10),
// // //                           ),
// // //                           y: const ChartAxisSettingsAxis(
// // //                             frequency: 500.0,
// // //                             max: 2500.0,
// // //                             min: 0.0,
// // //                             textStyle: TextStyle(fontSize: 10),
// // //                           ),
// // //                         ),
// // //                         labelX: (value) {
// // //                           final index = value.toInt();
// // //                           if (index < 0 || index >= chartData.length) return '';
// // //                           return chartData[index]['month'].toString().split(" ")[0];
// // //                         },
// // //                         labelY: (value) => value.toInt().toString(),
// // //                       ),
// // //                       ChartBarLayer(
// // //                         settings: const ChartBarSettings(
// // //                           thickness: 14,
// // //                           radius: BorderRadius.all(Radius.circular(4)),
// // //                         ),
// // //                         items: List.generate(chartData.length, (index) {
// // //                           final d = chartData[index];
// // //                           final ios = (d['ios'] as num).toDouble();
// // //                           return ChartBarDataItem(
// // //                             x: index.toDouble(),
// // //                             value: ios,
// // //                             color: Colors.amber,
// // //                           );
// // //                         }),
// // //                       ),
// // //                       ChartBarLayer(
// // //                         settings: const ChartBarSettings(
// // //                           thickness: 14,
// // //                           radius: BorderRadius.all(Radius.circular(4)),
// // //                         ),
// // //                         items: List.generate(chartData.length, (index) {
// // //                           final d = chartData[index];
// // //                           final android = (d['android'] as num).toDouble();
// // //                           return ChartBarDataItem(
// // //                             x: index.toDouble(),
// // //                             value: android,
// // //                             color: Colors.blue,
// // //                           );
// // //                         }),
// // //                       ),
// // //                       ChartBarLayer(
// // //                         settings: const ChartBarSettings(
// // //                           thickness: 14,
// // //                           radius: BorderRadius.all(Radius.circular(4)),
// // //                         ),
// // //                         items: List.generate(chartData.length, (index) {
// // //                           final d = chartData[index];
// // //                           final web = (d['web'] as num).toDouble();
// // //                           return ChartBarDataItem(
// // //                             x: index.toDouble(),
// // //                             value: web,
// // //                             color: Colors.green,
// // //                           );
// // //                         }),
// // //                       ),
// // //
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //             const SizedBox(height: 20),
// // //
// // //             /// 📌 Summary Cards
// // //             Row(
// // //               children: const [
// // //                 Expanded(
// // //                   child: _SummaryCard(
// // //                     title: "Total plays",
// // //                     value: "3,209",
// // //                     change: "-3%",
// // //                     positive: false,
// // //                     icon: Icons.remove_red_eye,
// // //                   ),
// // //                 ),
// // //                 SizedBox(width: 12),
// // //                 Expanded(
// // //                   child: _SummaryCard(
// // //                     title: "Unique viewers",
// // //                     value: "680",
// // //                     change: "+9%",
// // //                     positive: true,
// // //                     icon: Icons.people,
// // //                   ),
// // //                 ),
// // //                 SizedBox(width: 12),
// // //                 Expanded(
// // //                   child: _SummaryCard(
// // //                     title: "Avg viewer duration",
// // //                     value: "32m 17s",
// // //                     change: "-2%",
// // //                     positive: false,
// // //                     icon: Icons.access_time,
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //             const SizedBox(height: 20),
// // //
// // //             /// 📋 Media Table
// // //             Text("Media", style: Theme.of(context).textTheme.titleMedium),
// // //             const SizedBox(height: 8),
// // //             Column(
// // //               children: mediaList.map((item) {
// // //                 return Container(
// // //                   margin: const EdgeInsets.symmetric(vertical: 4),
// // //                   padding: const EdgeInsets.all(12),
// // //                   decoration: BoxDecoration(
// // //                     color: Colors.white,
// // //                     borderRadius: BorderRadius.circular(8),
// // //                     border: Border.all(color: Colors.grey.shade200),
// // //                   ),
// // //                   child: Row(
// // //                     children: [
// // //                       ClipRRect(
// // //                         borderRadius: BorderRadius.circular(6),
// // //                         child: Image.network(
// // //                           item['thumbnail']!,
// // //                           width: 60,
// // //                           height: 40,
// // //                           fit: BoxFit.cover,
// // //                         ),
// // //                       ),
// // //                       const SizedBox(width: 12),
// // //                       Expanded(
// // //                         flex: 4,
// // //                         child: Column(
// // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // //                           children: [
// // //                             Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.w600)),
// // //                             Text(item['date']!, style: const TextStyle(color: Colors.black54, fontSize: 12)),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                       Expanded(flex: 2, child: Text(item['plays'].toString())),
// // //                       Expanded(flex: 2, child: Text(item['uniqueViewers'].toString())),
// // //                       Expanded(flex: 3, child: Text(item['avgDuration'].toString())),
// // //                       Expanded(flex: 3, child: Text(item['totalPlayTime'].toString())),
// // //                     ],
// // //                   ),
// // //                 );
// // //               }).toList(),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // /// 📌 Summary Card Widget
// // // class _SummaryCard extends StatelessWidget {
// // //   final String title;
// // //   final String value;
// // //   final String change;
// // //   final bool positive;
// // //   final IconData icon;
// // //
// // //   const _SummaryCard({
// // //     required this.title,
// // //     required this.value,
// // //     required this.change,
// // //     required this.positive,
// // //     required this.icon,
// // //   });
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Card(
// // //       elevation: 1,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Icon(icon, color: Colors.black54),
// // //             const SizedBox(height: 8),
// // //             Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // //             Text(title, style: const TextStyle(color: Colors.black54)),
// // //             const SizedBox(height: 8),
// // //             Text(
// // //               change,
// // //               style: TextStyle(color: positive ? Colors.green : Colors.red, fontWeight: FontWeight.w600),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// // import 'package:flutter/material.dart';
// // import 'package:mrx_charts/mrx_charts.dart';
// // import '../Controller/Media_analytics_controller.dart';
// //
// // class MediaAnalyticsDashboard extends StatefulWidget {
// //   const MediaAnalyticsDashboard({super.key});
// //
// //   @override
// //   State<MediaAnalyticsDashboard> createState() => _MediaAnalyticsDashboardState();
// // }
// //
// // class _MediaAnalyticsDashboardState extends State<MediaAnalyticsDashboard> {
// //   Map<String, dynamic>? analyticsData;
// //   bool isLoading = true;
// //   String? error;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchAnalytics();
// //   }
// //
// //   Future<void> fetchAnalytics() async {
// //     setState(() {
// //       isLoading = true;
// //       error = null;
// //     });
// //
// //     try {
// //       final data = await AnalyticsService.getAllMediaAnalytics();
// //       if (data != null) {
// //         setState(() {
// //           analyticsData = data;
// //           isLoading = false;
// //         });
// //       } else {
// //         setState(() {
// //           error = "Failed to load analytics.";
// //           isLoading = false;
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         error = "Error: $e";
// //         isLoading = false;
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("📊 Media Analytics"),
// //         backgroundColor: Colors.white,
// //         foregroundColor: Colors.black87,
// //         elevation: 0,
// //       ),
// //       body: isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : error != null
// //           ? Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Text(error!, style: const TextStyle(color: Colors.red)),
// //             const SizedBox(height: 10),
// //             ElevatedButton(onPressed: fetchAnalytics, child: const Text("Retry")),
// //           ],
// //         ),
// //       )
// //           : buildDashboard(),
// //     );
// //   }
// //
// //   Widget buildDashboard() {
// //     final chartData = List<Map<String, dynamic>>.from(analyticsData?['chartData'] ?? []);
// //     final mediaList = List<Map<String, dynamic>>.from(analyticsData?['mediaList'] ?? []);
// //
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           /// 📈 Chart Section
// //           if (chartData.isNotEmpty)
// //             Card(
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //               elevation: 2,
// //               child: Padding(
// //                 padding: const EdgeInsets.all(16),
// //                 child: SizedBox(
// //                   height: 250,
// //                   child: Chart(
// //                     layers: [
// //                       ChartAxisLayer(
// //                         settings: ChartAxisSettings(
// //                           x: ChartAxisSettingsAxis(
// //                             frequency: 1.0,
// //                             max: chartData.length.toDouble(),
// //                             min: 0.0,
// //                             textStyle: const TextStyle(fontSize: 10),
// //                           ),
// //                           y: const ChartAxisSettingsAxis(
// //                             frequency: 500.0,
// //                             max: 2500.0,
// //                             min: 0.0,
// //                             textStyle: TextStyle(fontSize: 10),
// //                           ),
// //                         ),
// //                         labelX: (value) {
// //                           final index = value.toInt();
// //                           if (index < 0 || index >= chartData.length) return '';
// //                           return chartData[index]['month'].toString().split(" ")[0];
// //                         },
// //                         labelY: (value) => value.toInt().toString(),
// //                       ),
// //                       _buildBarLayer(chartData, "ios", Colors.amber),
// //                       _buildBarLayer(chartData, "android", Colors.blue),
// //                       _buildBarLayer(chartData, "web", Colors.green),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //
// //           const SizedBox(height: 20),
// //
// //           /// 📌 Summary Cards
// //           Row(
// //             children: const [
// //               Expanded(
// //                 child: _SummaryCard(
// //                   title: "Total plays",
// //                   value: "3,209",
// //                   change: "-3%",
// //                   positive: false,
// //                   icon: Icons.remove_red_eye,
// //                 ),
// //               ),
// //               SizedBox(width: 12),
// //               Expanded(
// //                 child: _SummaryCard(
// //                   title: "Unique viewers",
// //                   value: "680",
// //                   change: "+9%",
// //                   positive: true,
// //                   icon: Icons.people,
// //                 ),
// //               ),
// //               SizedBox(width: 12),
// //               Expanded(
// //                 child: _SummaryCard(
// //                   title: "Avg viewer duration",
// //                   value: "32m 17s",
// //                   change: "-2%",
// //                   positive: false,
// //                   icon: Icons.access_time,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 20),
// //
// //           /// 📋 Media Table
// //           Text("Media", style: Theme.of(context).textTheme.titleMedium),
// //           const SizedBox(height: 8),
// //           Column(
// //             children: mediaList.map((item) {
// //               return Container(
// //                 margin: const EdgeInsets.symmetric(vertical: 4),
// //                 padding: const EdgeInsets.all(12),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(8),
// //                   border: Border.all(color: Colors.grey.shade200),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     ClipRRect(
// //                       borderRadius: BorderRadius.circular(6),
// //                       child: Image.network(
// //                         item['thumbnailUrl'] ?? "",
// //                         width: 60,
// //                         height: 40,
// //                         fit: BoxFit.cover,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       flex: 4,
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(item['title'] ?? "", style: const TextStyle(fontWeight: FontWeight.w600)),
// //                           Text(item['date'] ?? "", style: const TextStyle(color: Colors.black54, fontSize: 12)),
// //                         ],
// //                       ),
// //                     ),
// //                     Expanded(flex: 2, child: Text(item['plays'].toString())),
// //                     Expanded(flex: 2, child: Text(item['uniqueViewers'].toString())),
// //                     Expanded(flex: 3, child: Text(item['avgDuration'].toString())),
// //                     Expanded(flex: 3, child: Text(item['totalPlayTime'].toString())),
// //                   ],
// //                 ),
// //               );
// //             }).toList(),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   ChartBarLayer _buildBarLayer(List<Map<String, dynamic>> data, String key, Color color) {
// //     return ChartBarLayer(
// //       settings: const ChartBarSettings(
// //         thickness: 14,
// //         radius: BorderRadius.all(Radius.circular(4)),
// //       ),
// //       items: List.generate(data.length, (index) {
// //         final d = data[index];
// //         final value = (d[key] as num).toDouble();
// //         return ChartBarDataItem(
// //           x: index.toDouble(),
// //           value: value,
// //           color: color,
// //         );
// //       }),
// //     );
// //   }
// // }
// //
// // /// 📌 Summary Card Widget
// // class _SummaryCard extends StatelessWidget {
// //   final String title;
// //   final String value;
// //   final String change;
// //   final bool positive;
// //   final IconData icon;
// //
// //   const _SummaryCard({
// //     required this.title,
// //     required this.value,
// //     required this.change,
// //     required this.positive,
// //     required this.icon,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Card(
// //       elevation: 1,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Icon(icon, color: Colors.black54),
// //             const SizedBox(height: 8),
// //             Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// //             Text(title, style: const TextStyle(color: Colors.black54)),
// //             const SizedBox(height: 8),
// //             Text(
// //               change,
// //               style: TextStyle(color: positive ? Colors.green : Colors.red, fontWeight: FontWeight.w600),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:mrx_charts/mrx_charts.dart';
// import '../Controller/Media_analytics_controller.dart';
//
// class MediaAnalyticsDashboard extends StatefulWidget {
//   const MediaAnalyticsDashboard({super.key});
//
//   @override
//   State<MediaAnalyticsDashboard> createState() => _MediaAnalyticsDashboardState();
// }
//
// class _MediaAnalyticsDashboardState extends State<MediaAnalyticsDashboard> {
//   Map<String, dynamic>? analyticsData;
//   bool isLoading = true;
//   String? error;
//
//   @override
//   void initState() {
//     super.initState();
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
//       final data = await AnalyticsService.getAllMediaAnalytics();
//       if (data != null) {
//         setState(() {
//           analyticsData = data;
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
//             ElevatedButton(onPressed: fetchAnalytics, child: const Text("Retry")),
//           ],
//         ),
//       )
//           : buildDashboard(),
//     );
//   }
//
//   Widget buildDashboard() {
//     final chartData = List<Map<String, dynamic>>.from(analyticsData?['chartData'] ?? []);
//     final mediaList = List<Map<String, dynamic>>.from(analyticsData?['mediaList'] ?? []);
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// 📈 Chart Section
//           Card(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             elevation: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: SizedBox(
//                 height: 250,
//                 child: chartData.isNotEmpty
//                     ? Chart(
//                   layers: [
//                     ChartAxisLayer(
//                       settings: ChartAxisSettings(
//                         x: ChartAxisSettingsAxis(
//                           frequency: 1.0,
//                           max: chartData.length.toDouble(),
//                           min: 0.0,
//                           textStyle: const TextStyle(fontSize: 10),
//                         ),
//                         y: const ChartAxisSettingsAxis(
//                           frequency: 500.0,
//                           max: 2500.0,
//                           min: 0.0,
//                           textStyle: TextStyle(fontSize: 10),
//                         ),
//                       ),
//                       labelX: (value) {
//                         final index = value.toInt();
//                         if (index < 0 || index >= chartData.length) return '';
//                         return chartData[index]['month'].toString().split(" ")[0];
//                       },
//                       labelY: (value) => value.toInt().toString(),
//                     ),
//                     _buildBarLayer(chartData, "ios", Colors.amber),
//                     _buildBarLayer(chartData, "android", Colors.blue),
//                     _buildBarLayer(chartData, "web", Colors.green),
//                   ],
//                 )
//                     : Center(
//                   child: Text(
//                     "No chart data available",
//                     style: TextStyle(color: Colors.black54),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           /// 📌 Summary Cards
//           Row(
//             children: [
//               Expanded(
//                 child: _SummaryCard(
//                   title: "Total plays",
//                   value: analyticsData?['summary']?['plays'].toString() ?? "0",
//                   change: "${analyticsData?['summary']?['playsChange'] ?? "0"}%",
//                   positive: (analyticsData?['summary']?['playsChange'] ?? 0) >= 0,
//                   icon: Icons.remove_red_eye,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _SummaryCard(
//                   title: "Unique viewers",
//                   value: analyticsData?['summary']?['uniqueViewers'].toString() ?? "0",
//                   change: "${analyticsData?['summary']?['uniqueViewersChange'] ?? "0"}%",
//                   positive: (analyticsData?['summary']?['uniqueViewersChange'] ?? 0) >= 0,
//                   icon: Icons.people,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _SummaryCard(
//                   title: "Avg viewer duration",
//                   value: analyticsData?['summary']?['avgDuration'] ?? "0m 0s",
//                   change: "${analyticsData?['summary']?['avgDurationChange'] ?? "0"}%",
//                   positive: (analyticsData?['summary']?['avgDurationChange'] ?? 0) >= 0,
//                   icon: Icons.access_time,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           /// 📋 Media Table
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
//                           Text(item['title'] ?? "", style: const TextStyle(fontWeight: FontWeight.w600)),
//                           Text(item['date'] ?? "", style: const TextStyle(color: Colors.black54, fontSize: 12)),
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
//
//   ChartBarLayer _buildBarLayer(List<Map<String, dynamic>> data, String key, Color color) {
//     return ChartBarLayer(
//       settings: const ChartBarSettings(
//         thickness: 14,
//         radius: BorderRadius.all(Radius.circular(4)),
//       ),
//       items: List.generate(data.length, (index) {
//         final d = data[index];
//         final value = (d[key] as num?)?.toDouble() ?? 0.0;
//         return ChartBarDataItem(
//           x: index.toDouble(),
//           value: value,
//           color: color,
//         );
//       }),
//     );
//   }
// }
//
// /// 📌 Summary Card Widget
// class _SummaryCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final String change;
//   final bool positive;
//   final IconData icon;
//
//   const _SummaryCard({
//     required this.title,
//     required this.value,
//     required this.change,
//     required this.positive,
//     required this.icon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, color: Colors.black54),
//             const SizedBox(height: 8),
//             Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             Text(title, style: const TextStyle(color: Colors.black54)),
//             const SizedBox(height: 8),
//             Text(
//               change,
//               style: TextStyle(color: positive ? Colors.green : Colors.red, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import '../Controller/Media_analytics_controller.dart';

class MediaAnalyticsDashboard extends StatefulWidget {
  const MediaAnalyticsDashboard({super.key});

  @override
  State<MediaAnalyticsDashboard> createState() => _MediaAnalyticsDashboardState();
}

class _MediaAnalyticsDashboardState extends State<MediaAnalyticsDashboard> {
  Map<String, dynamic>? analyticsData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await AnalyticsService.getAllMediaAnalytics();
      if (data != null) {
        // Rename chart keys for consistency
        final chartData = List<Map<String, dynamic>>.from(data['chartData'] ?? []).map((e) {
          return {
            'time': e['month'], // hourly/daily label
            'ios': e['ios'],
            'android': e['android'],
            'webApp': e['webApp'] ?? 0,
            'appleTv': e['appleTv'] ?? 0,
            'roku': e['roku'] ?? 0,
            'webEmbed': e['webEmbed'] ?? 0,
          };
        }).toList();

        setState(() {
          analyticsData = {...data, 'chartData': chartData};
          isLoading = false;
        });
      } else {
        setState(() {
          error = "Failed to load analytics.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📊 Media Analytics"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: fetchAnalytics, child: const Text("Retry")),
          ],
        ),
      )
          : buildDashboard(),
    );
  }

  Widget buildDashboard() {
    final chartData = List<Map<String, dynamic>>.from(analyticsData?['chartData'] ?? []);
    final mediaList = List<Map<String, dynamic>>.from(analyticsData?['mediaList'] ?? []);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 📈 Chart Section
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 250,
                child: chartData.isNotEmpty
                    ? Chart(
                  layers: [
                    ChartAxisLayer(
                      settings: ChartAxisSettings(
                        x: ChartAxisSettingsAxis(
                          frequency: 1.0,
                          max: chartData.length.toDouble(),
                          min: 0.0,
                          textStyle: const TextStyle(fontSize: 10),
                        ),
                        y: const ChartAxisSettingsAxis(
                          frequency: 5.0,
                          max: 50.0,
                          min: 0.0,
                          textStyle: TextStyle(fontSize: 10),
                        ),
                      ),
                      labelX: (value) {
                        final index = value.toInt();
                        if (index < 0 || index >= chartData.length) return '';
                        return chartData[index]['time'];
                      },
                      labelY: (value) => value.toInt().toString(),
                    ),
                    _buildBarLayer(chartData, "ios", Colors.amber),
                    _buildBarLayer(chartData, "android", Colors.blue),
                    _buildBarLayer(chartData, "webApp", Colors.green),
                    _buildBarLayer(chartData, "appleTv", Colors.purple),
                    _buildBarLayer(chartData, "roku", Colors.orange),
                    _buildBarLayer(chartData, "webEmbed", Colors.teal),
                  ],
                )
                    : Center(
                  child: Text(
                    "No chart data available",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// 📌 Summary Cards
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: "Total plays",
                  value: analyticsData?['summary']?['plays'].toString() ?? "0",
                  change: "${analyticsData?['summary']?['playsChange'] ?? "0"}%",
                  positive: (analyticsData?['summary']?['playsChange'] ?? 0) >= 0,
                  icon: Icons.remove_red_eye,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: "Unique viewers",
                  value: analyticsData?['summary']?['uniqueViewers'].toString() ?? "0",
                  change: "${analyticsData?['summary']?['uniqueViewersChange'] ?? "0"}%",
                  positive: (analyticsData?['summary']?['uniqueViewersChange'] ?? 0) >= 0,
                  icon: Icons.people,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: "Avg viewer duration",
                  value: analyticsData?['summary']?['avgDuration'] ?? "0m 0s",
                  change: "${analyticsData?['summary']?['avgDurationChange'] ?? "0"}%",
                  positive: (analyticsData?['summary']?['avgDurationChange'] ?? 0) >= 0,
                  icon: Icons.access_time,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// 📋 Media Table
          Text("Media", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Column(
            children: mediaList.map((item) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        item['thumbnailUrl'] ?? "",
                        width: 60,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60,
                          height: 40,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'] ?? "", style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(item['date'] ?? "", style: const TextStyle(color: Colors.black54, fontSize: 12)),
                        ],
                      ),
                    ),
                    Expanded(flex: 2, child: Text(item['plays'].toString())),
                    Expanded(flex: 2, child: Text(item['uniqueViewers'].toString())),
                    Expanded(flex: 3, child: Text(item['avgDuration'].toString())),
                    Expanded(flex: 3, child: Text(item['totalPlayTime'].toString())),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  ChartBarLayer _buildBarLayer(List<Map<String, dynamic>> data, String key, Color color) {
    return ChartBarLayer(
      settings: const ChartBarSettings(
        thickness: 14,
        radius: BorderRadius.all(Radius.circular(4)),
      ),
      items: List.generate(data.length, (index) {
        final d = data[index];
        final value = (d[key] as num?)?.toDouble() ?? 0.0;
        return ChartBarDataItem(
          x: index.toDouble(),
          value: value,
          color: color,
        );
      }),
    );
  }
}

/// 📌 Summary Card Widget
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool positive;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.change,
    required this.positive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Text(
              change,
              style: TextStyle(color: positive ? Colors.green : Colors.red, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
