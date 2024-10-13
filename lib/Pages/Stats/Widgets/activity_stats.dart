// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
//
// import '../../../General Widgets/Responsive.dart';
// import '../../../General Widgets/custom_card.dart';
//
// class ActivityStats extends StatefulWidget {
//   @override
//   State<ActivityStats> createState() => _ActivityStatsState();
// }
//
// class _ActivityStatsState extends State<ActivityStats> {
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView(
//       shrinkWrap: true,
//       physics: const ScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
//           crossAxisSpacing: !Responsive.isMobile(context) ? 15 : 12,
//           mainAxisSpacing: 12.0),
//       children: [
//         activityCard("assets/Icons/car.png", "Car Booked", "50"),
//         activityCard("assets/Icons/package.png", "Package Booked", "50"),
//         activityCard("assets/Icons/ziyarat.png", "Ziya-rat Booked", "50"),
//         activityCard("assets/Icons/stats.png", "Yearly Revenue", "50"),
//       ],
//     );
//
//     //   Container(
//     //   color: Colors.red,
//     //   child: Column(
//     //     children: [
//     //       Row(
//     //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     //         children: [
//     //           activityCard("assets/Icons/car.png", "Car Avaliable", "50"),
//     //           activityCard("assets/Icons/package.png", "Package Booked", "50"),
//     //           Responsive.isDesktop(context)
//     //               ? activityCard(
//     //                   "assets/Icons/ziyarat.png", "Ziyarat Booked", "50")
//     //               : SizedBox(),
//     //           Responsive.isDesktop(context)
//     //               ? activityCard(
//     //                   "assets/Icons/stats.png", "Last Year Revenue", "50")
//     //               : SizedBox(),
//     //         ],
//     //       ),
//     //       !Responsive.isDesktop(context)
//     //           ? Row(
//     //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     //               children: [
//     //                 activityCard(
//     //                     "assets/Icons/ziyarat.png", "Ziyarat Booked", "50"),
//     //                 SizedBox(),
//     //                 activityCard(
//     //                     "assets/Icons/stats.png", "Last Year Revenue", "50"),
//     //                 SizedBox(),
//     //               ],
//     //             )
//     //           : SizedBox(),
//     //     ],
//     //   ),
//     // );
//   }
//
//   Widget activityCard(String asset, String title, String number) {
//     return CustomCard(
//       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//       child: Column(
//         children: [
//           //SizedBox(height: 10,),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   width: 45,
//                   height: 25,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(
//                       color: Colors.red,
//                     ),
//                   ),
//                   child: Text(
//                     textAlign: TextAlign.center,
//                     "Live",
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//                 // SizedBox(
//                 //   width: !Responsive.isDesktop(context) ? 40 : 80,
//                 // ),
//                 CircleAvatar(
//                   radius: !Responsive.isDesktop(context) ? 30 : 20,
//                   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                   child: Image.asset(
//                     fit: BoxFit.contain,
//                     asset,
//                     width: 15,// !Responsive.isDesktop(context) ? 30 :30 ,
//                     height: 15,//  !Responsive.isDesktop(context) ? 30 : 30,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             number,
//             style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   fontSize: Responsive.isMobile(context) ? 20 : 28,
//                   color: Theme.of(context).primaryColor,
//                 ),
//           ),
//           Text(
//             title,
//             style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   fontSize: Responsive.isMobile(context) ? 16 : 20,
//                 ),
//           ),
//
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;

import '../../../General Widgets/Responsive.dart';
import '../../../General Widgets/custom_card.dart';
import '../../../Utilis/config.dart';

class ActivityStats extends StatefulWidget {
  @override
  State<ActivityStats> createState() => _ActivityStatsState();
}

class _ActivityStatsState extends State<ActivityStats> {
  Future<Map<String, dynamic>> fetchBookingData() async {
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $accessToken"
    };
    final response = await https.get(
        Uri.parse('https://server.safacab.com/admin/reports/bookings'),
        headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'][DateTime.now().year.toString()];
    } else {
      print('Failed to load booking data ${response.statusCode}');
      print(response.body);
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchBookingData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        } else {
          final data = snapshot.data!;
          final currentMonth = DateTime.now().month;
          final monthNames = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec'
          ];
          final currentMonthData = data[monthNames[currentMonth - 1]];

          double yearlyRevenue = data.values
              .fold(0, (sum, monthData) => sum + monthData['total_revenue']);

          return GridView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
                crossAxisSpacing: !Responsive.isMobile(context) ? 15 : 12,
                mainAxisSpacing: 12.0),
            children: [
              activityCard("assets/Icons/car.png", "Booking Canceled",
                  currentMonthData['cancelled'].toString()),
              activityCard("assets/Icons/package.png", "Package Booked",
                  currentMonthData['total_packages'].toString()),
              activityCard("assets/Icons/ziyarat.png", "Ziyarat Booked",
                  currentMonthData['total_ziyarats'].toString()),
              activityCard("assets/Icons/stats.png", "Yearly Revenue",
                  yearlyRevenue.toString()),
            ],
          );
        }
      },
    );
  }

  Widget activityCard(String asset, String title, String number) {
    return CustomCard(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 45,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.red,
                    ),
                  ),
                  child: const Text(
                    textAlign: TextAlign.center,
                    "Live",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                CircleAvatar(
                  radius: !Responsive.isDesktop(context) ? 30 : 20,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: Image.asset(
                    fit: BoxFit.contain,
                    asset,
                    width: 15,
                    height: 15,
                  ),
                ),
              ],
            ),
          ),
          Text(
            number,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: Responsive.isMobile(context) ? 20 : 28,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: Responsive.isMobile(context) ? 16 : 20,
                ),
          ),
        ],
      ),
    );
  }
}
