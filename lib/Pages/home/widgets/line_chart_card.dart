// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import '../../../General Widgets/responsive.dart';
// import '../../../General Widgets/custom_card.dart';
//
// class LineChartCard extends StatelessWidget {
//   LineChartCard({super.key});
//
//   final List<FlSpot> spots = const [
//     FlSpot(1.68, 21.04),
//     FlSpot(2.84, 26.23),
//     FlSpot(5.19, 19.82),
//     FlSpot(6.01, 24.49),
//     FlSpot(7.81, 19.82),
//     FlSpot(9.49, 23.50),
//     FlSpot(12.26, 19.57),
//     FlSpot(15.63, 20.90),
//     FlSpot(20.39, 39.20),
//     FlSpot(23.69, 75.62),
//     FlSpot(26.21, 46.58),
//     FlSpot(29.87, 42.97),
//     FlSpot(32.49, 46.54),
//     FlSpot(35.09, 40.72),
//     FlSpot(38.74, 43.18),
//     FlSpot(41.47, 59.91),
//     FlSpot(43.12, 53.18),
//     FlSpot(46.30, 90.10),
//     FlSpot(47.88, 81.59),
//     FlSpot(51.71, 75.53),
//     FlSpot(54.21, 78.95),
//     FlSpot(55.23, 86.94),
//     FlSpot(57.40, 78.98),
//     FlSpot(60.49, 74.38),
//     FlSpot(64.30, 48.34),
//     FlSpot(67.17, 70.74),
//     FlSpot(70.35, 75.43),
//     FlSpot(73.39, 69.88),
//     FlSpot(75.87, 80.04),
//     FlSpot(77.32, 74.38),
//     FlSpot(81.43, 68.43),
//     FlSpot(86.12, 69.45),
//     FlSpot(90.06, 78.60),
//     FlSpot(94.68, 46.05),
//     FlSpot(98.35, 42.80),
//     FlSpot(101.25, 53.05),
//     FlSpot(103.07, 46.06),
//     FlSpot(106.65, 42.31),
//     FlSpot(108.20, 32.64),
//     FlSpot(110.40, 45.14),
//     FlSpot(114.24, 53.27),
//     FlSpot(116.60, 42.13),
//     FlSpot(118.52, 57.60),
//   ];
//
//   final leftTitle = {
//     0: '0',
//     20: '2K',
//     40: '4K',
//     60: '6K',
//     80: '8K',
//     100: '10K'
//   };
//   final bottomTitle = {
//     0: 'Jan',
//     10: 'Feb',
//     20: 'Mar',
//     30: 'Apr',
//     40: 'May',
//     50: 'Jun',
//     60: 'Jul',
//     70: 'Aug',
//     80: 'Sep',
//     90: 'Oct',
//     100: 'Nov',
//     110: 'Dec',
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Steps Overview",
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           AspectRatio(
//             aspectRatio: Responsive.isMobile(context) ? 9 / 4 : 16 / 6,
//             child: LineChart(
//               LineChartData(
//                 lineTouchData: LineTouchData(
//                   handleBuiltInTouches: true,
//                 ),
//                 gridData: FlGridData(show: false),
//                 titlesData: FlTitlesData(
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 32,
//                       interval: 1,
//                       getTitlesWidget: (double value, TitleMeta meta) {
//                         return bottomTitle[value.toInt()] != null
//                             ? SideTitleWidget(
//                                 axisSide: meta.axisSide,
//                                 space: 10,
//                                 child: Text(
//                                     bottomTitle[value.toInt()].toString(),
//                                     style: TextStyle(
//                                         fontSize: Responsive.isMobile(context)
//                                             ? 9
//                                             : 12,
//                                         color: Colors.grey[400])),
//                               )
//                             : const SizedBox();
//                       },
//                     ),
//                   ),
//                   rightTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       getTitlesWidget: (double value, TitleMeta meta) {
//                         return leftTitle[value.toInt()] != null
//                             ? Text(leftTitle[value.toInt()].toString(),
//                                 style: TextStyle(
//                                     fontSize:
//                                         Responsive.isMobile(context) ? 9 : 12,
//                                     color: Colors.grey[400]))
//                             : const SizedBox();
//                       },
//                       showTitles: true,
//                       interval: 1,
//                       reservedSize: 40,
//                     ),
//                   ),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 lineBarsData: [
//                   LineChartBarData(
//                       isCurved: true,
//                       curveSmoothness: 0,
//                       color: Theme.of(context).primaryColor,
//                       barWidth: 2.5,
//                       isStrokeCapRound: true,
//                       belowBarData: BarAreaData(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Theme.of(context).primaryColor.withOpacity(0.5),
//                             Colors.transparent
//                           ],
//                         ),
//                         show: true,
//                         color: Theme.of(context).primaryColor.withOpacity(0.5),
//                       ),
//                       dotData: FlDotData(show: false),
//                       spots: spots)
//                 ],
//                 minX: 0,
//                 maxX: 120,
//                 maxY: 105,
//                 minY: -5,
//               ),duration: const Duration(milliseconds: 250),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_dashboard/General%20Widgets/custom_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../Utilis/config.dart';

class LineChartCard extends StatefulWidget {
  @override
  _LineChartCardState createState() => _LineChartCardState();
}

class _LineChartCardState extends State<LineChartCard> {
  List<FlSpot> dataPoints = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    final response = await http.get(
        Uri.parse('https://server.safacab.com/admin/reports/bookings'),
        headers: headers);

    if (response.statusCode == 200) {
      print("Api hit successfully");

      final jsonData = json.decode(response.body);
      final data = jsonData['data'][DateTime.now().year.toString()];
      List<FlSpot> tempDataPoints = [];

      Map<String, double> monthMap = {
        "Jan": 1,
        "Feb": 2,
        "Mar": 3,
        "Apr": 4,
        "May": 5,
        "Jun": 6,
        "Jul": 7,
        "Aug": 8,
        "Sep": 9,
        "Oct": 10,
        "Nov": 11,
        "Dec": 12,
      };

      data.forEach((month, values) {
        double totalRevenue = values['total_revenue'].toDouble();
        double xValue = monthMap[month]!;
        tempDataPoints.add(FlSpot(xValue, totalRevenue));
      });

      dataPoints = tempDataPoints;
    } else {
      print('Failed to load data status code : ${response.statusCode}');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.all(12),
      child: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Container(
              height: 300, // set a definite height
              child: LineChart(
                LineChartData(
                  minX: 1,
                  maxX: 12,
                  minY: 0,
                  maxY: 10000,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          );
                          return Text('${value.toInt() / 1000}K', style: style);
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1, // Ensure only one label per month
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          );
                          Widget text;
                          switch (value.toInt()) {
                            case 1:
                              text = Text('Jan', style: style);
                              break;
                            case 2:
                              text = Text('Feb', style: style);
                              break;
                            case 3:
                              text = Text('Mar', style: style);
                              break;
                            case 4:
                              text = Text('Apr', style: style);
                              break;
                            case 5:
                              text = Text('May', style: style);
                              break;
                            case 6:
                              text = Text('Jun', style: style);
                              break;
                            case 7:
                              text = Text('Jul', style: style);
                              break;
                            case 8:
                              text = Text('Aug', style: style);
                              break;
                            case 9:
                              text = Text('Sep', style: style);
                              break;
                            case 10:
                              text = Text('Oct', style: style);
                              break;
                            case 11:
                              text = Text('Nov', style: style);
                              break;
                            case 12:
                              text = Text('Dec', style: style);
                              break;
                            default:
                              text = Text('', style: style);
                              break;
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 4,
                            child: text,
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: dataPoints,
                      isCurved: true,
                      barWidth: 4,
                      color: Colors.yellow,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.yellow.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
