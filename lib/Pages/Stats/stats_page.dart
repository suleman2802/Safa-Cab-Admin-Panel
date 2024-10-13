import 'package:flutter/material.dart';
import './Widgets/activity_stats.dart';
import '../home/widgets/line_chart_card.dart';

import '../../General Widgets/Responsive.dart';
import '../../General Widgets/header_widget.dart';
import '../../General Widgets/menu.dart';
import '../Dashboard/Widgets/car_avaliablity_stats.dart';
import './Widgets/stats_table.dart';

class StatsPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    SizedBox _height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );
    return Scaffold(
        key: _scaffoldKey,
        drawer: !Responsive.isDesktop(context)
            ? SizedBox(
                width: 230,
                child: Menu(
                  scaffoldKey: _scaffoldKey,
                  selected: 9,
                ))
            : null,
        endDrawer: Responsive.isMobile(context)
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: CarAvaliabilityStats(
                  scaffoldKey: _scaffoldKey,
                ),
              )
            : null,
        body: SafeArea(
          child: Row(
            children: [
              if (Responsive.isDesktop(context))
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Menu(
                      scaffoldKey: _scaffoldKey,
                      selected: 9,
                    ),
                  ),
                ),
              Expanded(
                flex: 5,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  // color: Colors.white,
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
                            scaffoldKey: _scaffoldKey,
                            title: "Stats",
                          ),
                          _height(context),
                          ActivityStats(),
                          _height(context),
                          LineChartCard(),
                          StatsTable(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
