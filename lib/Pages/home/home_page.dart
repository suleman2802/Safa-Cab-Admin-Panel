import 'package:flutter/material.dart';
import '../Stats/Widgets/activity_stats.dart';
import './widgets/activity_details_card.dart';
import '../../General Widgets/header_widget.dart';
import './widgets/line_chart_card.dart';

import '../../General Widgets/responsive.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomePage({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    SizedBox _height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 15 : 18),
          child: Column(
            children: [
              SizedBox(
                height: Responsive.isMobile(context) ? 5 : 18,
              ),
              Header(
                scaffoldKey: scaffoldKey,
                title: "Dashboard",
              ),
              _height(context),
              Column(
                children: [
                  //const ActivityDetailsCard(),
                  ActivityStats(),
                  _height(context),
                  LineChartCard(),
                  _height(context),
                ],
              ),
              //BarGraphCard(),
              //_height(context),
            ],
          ),
        ),
      ),
    );
  }
}
