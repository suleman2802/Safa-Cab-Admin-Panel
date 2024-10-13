import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../General Widgets/custom_card.dart';
import '../../../General Widgets/responsive.dart';

class CarAvaliabilityStats extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  CarAvaliabilityStats({super.key, required this.scaffoldKey});

  //const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizedBox _height(BuildContext context) => SizedBox(
      height: Responsive.isDesktop(context) ? 30 : 20,
    );
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(Responsive.isMobile(context) ? 10 : 30.0),
          topLeft: Radius.circular(Responsive.isMobile(context) ? 10 : 30.0),
        ),
        //color: cardBackgroundColor,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Align(
              //   alignment: Alignment.topRight,
              //   child: InkWell(
              //     onTap: () => scaffoldKey.currentState!.openEndDrawer(),
              //     child: CircleAvatar(
              //       backgroundColor: Colors.transparent,
              //       child: Image.asset(
              //         "assets/images/avatar.png",
              //         width: 32,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 62,
              ),
              _height(context),
              Align(
                //alignment: Alignment.centerLeft,
                child: Expanded(
                  child: CustomCard(
                    //color: Theme.of(context).canvasColor,
                    // height: 450,
                    child: Column(
                      children: [
                        Text("Car Availability Stats",style: Theme.of(context).textTheme.titleLarge,),
                        SizedBox(
                          height: 250,
                          child: PieChart(
                            PieChartData(
                              sections: piechartsection(),
                              sectionsSpace: 0,
                              centerSpaceRadius: 80,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Container(
                              color: Colors.green,
                              width: 10,
                              height: 10,
                            ),
                            SizedBox(width: 10,),
                            Text(
                              "Avaliable",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Container(
                              color: Colors.blue,
                              width: 10,
                              height: 10,
                            ),
                            SizedBox(width: 10,),
                            Text(
                              "On Route",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Container(
                              color: Colors.red,
                              width: 10,
                              height: 10,
                            ),
                            SizedBox(width: 10,),
                            Text(
                              "Offline",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 32,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              // Container(
              //   //color: Theme.of(context).canvasColor,
              //   child: Column(
              //     children: [
              //
              //     ],
              //   ),
              // ),
              //   Image.asset(
              //     "assets/images/avatar.png",
              //   ),
              //   const SizedBox(
              //     height: 15,
              //   ),
              //   const Text(
              //     "Summer",
              //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              //   ),
              //   const SizedBox(
              //     height: 2,
              //   ),
              //   Text(
              //     "Edit health details",
              //     style: TextStyle(
              //       fontSize: 12,
              //       color: Theme.of(context).primaryColor,
              //     ),
              //   ),
              //   Padding(
              //     padding:
              //         EdgeInsets.all(Responsive.isMobile(context) ? 15 : 20.0),
              //     child: const WeightHeightBloodCard(),
              //   ),
              //   SizedBox(
              //     height: Responsive.isMobile(context) ? 20 : 40,
              //   ),
              //   Scheduled()
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> piechartsection() {
    List<Color> sectionColor = [
      Colors.red,
      Colors.blue,
      Colors.green,
    ];
    return List.generate(
      3,
      (index) {
        double value = (index + 1) * 10;
        return PieChartSectionData(
            radius: 20,
            value: value,
            title: "$value",
            color: sectionColor[index]);
      },
    );
  }
}
