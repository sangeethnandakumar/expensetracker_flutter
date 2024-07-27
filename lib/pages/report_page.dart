import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Api.dart';
import '../models/Report.dart';
import '../widgets/currencyeditor.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late Future<Report> reportData = Future.value(Report(
    start: DateTime.now(),
    end: DateTime.now(),
    total: 0,
    breakdown: {},
  ));

  void fetchReportData() {
    Api.get(
      '/reports?start=2024-07-01T19:25:14.573Z&end=2024-07-30T20:32:14.165Z',
          (data) {
        setState(() {
          reportData = Future.value(Report.fromJson(data));
        });
      },
          (error) {
        setState(() {
          reportData = Future.error(error);
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Report>(
        future: reportData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final report = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CurrencyEditor(
                    money: report.total.round().toString(),
                    fontSize: 50,
                    textColor: Colors.orange,
                  ),
                ),
                SizedBox(height: 20),
                // Commenting out the PieChart
                // Container(
                //   height: 300,
                //   child: PieChart(
                //     PieChartData(
                //       sections: _getPieChartSections(report.breakdown),
                //       borderData: FlBorderData(show: false),
                //       centerSpaceRadius: 50,
                //     ),
                //   ),
                // ),
                SizedBox(height: 20),
                Container(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40, // Reserve space for the rotated titles
                            getTitlesWidget: (value, meta) {
                              return Transform.rotate(
                                angle: -90 * (3.141592653589793 / 180), // Rotate by 90 degrees
                                child: Text(
                                  _getBarTitle(value.toInt(), report.breakdown),
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40, // Adjust if needed
                          ),
                        ),
                        topTitles: const AxisTitles(), // Disable top titles
                        rightTitles: const AxisTitles(), // Disable right titles
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: _getBarChartGroups(report.breakdown),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            );
          }
          return Text('No data available');
        },
      ),
    );
  }

  // Commenting out the PieChart section data method
  // List<PieChartSectionData> _getPieChartSections(Map<String, Breakdown> breakdown) {
  //   if (breakdown.isEmpty) {
  //     return [];
  //   }

  //   var sortedBreakdown = breakdown.entries.toList()
  //     ..sort((a, b) => b.value.total.compareTo(a.value.total));

  //   List<PieChartSectionData> sections = [];
  //   for (int i = 0; i < sortedBreakdown.length; i++) {
  //     final entry = sortedBreakdown[i];
  //     final breakdownData = entry.value;

  //     double saturationFactor = 1 - (i * 0.2).clamp(0.0, 1.0);
  //     Color color = _getSaturatedColor(saturationFactor);

  //     sections.add(PieChartSectionData(
  //       color: color,
  //       value: breakdownData.total.toDouble(),
  //       title: breakdownData.title,
  //       radius: 100,
  //       titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //     ));
  //   }

  //   return sections;
  // }

  List<BarChartGroupData> _getBarChartGroups(Map<String, Breakdown> breakdown) {
    List<BarChartGroupData> barGroups = [];
    int index = 0;

    breakdown.forEach((category, value) {
      double totalAmount = value.tracks.fold(0, (sum, track) => sum + track.exp.toDouble());
      barGroups.add(BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(
            toY: totalAmount,
            color: _getRandomColor(),
          ),
        ],
      ));
    });

    return barGroups;
  }

  String _getBarTitle(int index, Map<String, Breakdown> breakdown) {
    List<String> titles = breakdown.keys.toList();
    return index < titles.length ? titles[index] : ''; // Return category name based on index
  }

  Color _getSaturatedColor(double saturation) {
    Color baseColor = Color(0xFFFF5722);
    int red = (baseColor.red * saturation).toInt();
    int green = (baseColor.green * saturation).toInt();
    int blue = (baseColor.blue * saturation).toInt();
    return Color.fromARGB(255, red, green, blue);
  }

  Color _getRandomColor() {
    return Color((0xFFFFFFFF & (0xFF000000 | (0xFF0000 + (255 * 255 + 255) * 2))));
  }
}

class Expense {
  final DateTime date;
  final double amount;

  Expense({required this.date, required this.amount});
}
