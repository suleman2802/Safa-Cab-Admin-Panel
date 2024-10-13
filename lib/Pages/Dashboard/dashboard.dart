import 'package:flutter/material.dart';
import '../../General Widgets/menu.dart';
import '../../General Widgets/Responsive.dart';
import './Widgets/car_avaliablity_stats.dart';

import '../home/home_page.dart';

class DashBoard extends StatelessWidget {
  DashBoard({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: !Responsive.isDesktop(context)
            ? SizedBox(
                width: 230,
                child: Menu(
                  scaffoldKey: _scaffoldKey,
                  selected: 0,
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
                      selected: 0,
                    ),
                  ),
                ),
              Expanded(flex: 5, child: HomePage(scaffoldKey: _scaffoldKey)),
              // if (!Responsive.isMobile(context))
              //   Expanded(
              //     flex: 3,
              //     child: CarAvaliabilityStats(
              //       scaffoldKey: _scaffoldKey,
              //     ),
              //   ),
            ],
          ),
        ));
  }
}
