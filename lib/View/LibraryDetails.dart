import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LibraryDetails extends StatefulWidget {
  const LibraryDetails({super.key});

  @override
  State<LibraryDetails> createState() => _LibraryDetailsState();
}

class _LibraryDetailsState extends State<LibraryDetails> {
  final TextEditingController _dateController = TextEditingController();

  String mediaitemid = "68c7b2162e689b810a405344";
  // Example data for chart
  final List<_ChartData> chartData = [
    _ChartData("Mon", 5),
    _ChartData("Tue", 8),
    _ChartData("Wed", 6),
    _ChartData("Thu", 10),
    _ChartData("Fri", 7),
  ];
  final List<String> speakers = ["Speaker 1", "Speaker 2", "Speaker 3", "Speaker 4"];
  // Tooltip behavior for chart
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      color: Colors.blueAccent.withOpacity(0.9),
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      format: 'point.x : point.y views', // Customize content
    );
  }

  // Date picker
  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // 🔹 Chart + Stats Section
          Container(
            width: size.width * 0.84,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Chart
                SizedBox(
                  height: size.height * 0.25,
                  child: SfCartesianChart(
                    title: ChartTitle(text: 'Analytics'),
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(),
                    tooltipBehavior: _tooltipBehavior,
                    legend: const Legend(isVisible: false),
                    series: <CartesianSeries<_ChartData, String>>[
                      ColumnSeries<_ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (data, _) => data.day,
                        yValueMapper: (data, _) => data.views,
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(6),
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                        enableTooltip: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // All Time Plays
                    Text(
                      'Media Item id : $mediaitemid',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.remove_red_eye, color: Colors.black54),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '0',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'All time plays',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Peak Traffic Plays
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.bar_chart, color: Colors.black54),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '0 on Sep 28, 2025',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Peak traffic plays',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: size.height * 0.02),

          // 🔹 Form Section
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// SECTION: Basic Details
                      Text(
                        "Basic Details",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      _buildLabel("Title"),
                      const SizedBox(height: 6),
                      _buildInputField(hint: "Enter title"),
                      const SizedBox(height: 16),

                      // Row: Author + Date
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Author"),
                                const SizedBox(height: 6),
                                _buildInputField(hint: "Enter author"),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Date"),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _dateController,
                                  readOnly: true,
                                  onTap: () => _selectDate(context),
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Iconsax.calendar_1),
                                    hintText: "Select date",
                                    filled: false,
                                    fillColor: Colors.black12, // background color
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.blueAccent),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      _buildLabel("Description"),
                      const SizedBox(height: 6),
                      _buildInputField(hint: "Enter description", maxLines: 4),
                      const SizedBox(height: 24),

                      /// SECTION: Tags
                      Text(
                        "Tags",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Speakers
                      _buildTagLabel(
                        "Speakers",
                        tooltipMessage: "Enter the speakers for this session",
                      ),
                      const SizedBox(height: 6),
                      _buildInputField(hint: "Add speakers"),
                      const SizedBox(height: 16),

                      // Scripture
                      _buildTagLabel(
                        "Scripture",
                        tooltipMessage: "Mention relevant scripture references",
                      ),
                      const SizedBox(height: 6),
                      _buildInputField(hint: "Add scripture"),
                      const SizedBox(height: 16),

                      // Topics
                      _buildTagLabel(
                        "Topics",
                        tooltipMessage: "Add main topics covered",
                      ),
                      const SizedBox(height: 6),
                      _buildInputField(hint: "Add topics"),
                      const SizedBox(height: 32),

                      // Video Section
                      Text(
                        "Video",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        height: size.height * 0.2,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Audio Section
                      Text(
                        "Audio",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        height: size.height * 0.1,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper: Label
  Widget _buildLabel(String text) => Text(
    text,
    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
  );

  /// Helper: Tag Label with Info Icon and Tooltip
  Widget _buildTagLabel(String text, {String? tooltipMessage}) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      _buildLabel(text),
      const SizedBox(width: 4),
      Tooltip(
        message: tooltipMessage ?? "More info about $text",
        waitDuration: const Duration(milliseconds: 300),
        showDuration: const Duration(seconds: 3),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(6),
        ),
        textStyle: const TextStyle(color: Colors.white, fontSize: 12),
        child: const Icon(Iconsax.info_circle, size: 14, color: Colors.grey),
      ),
    ],
  );

  /// Helper: Input Field
  Widget _buildInputField({String? hint, int maxLines = 1}) => TextFormField(
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hint,
      filled: false,
      fillColor: Colors.black12, // background color
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black12),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  );
}

/// Dummy data model for chart
class _ChartData {
  final String day;
  final double views;
  _ChartData(this.day, this.views);
}



// use this package drop_down_list