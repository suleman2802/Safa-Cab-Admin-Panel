import 'package:flutter/material.dart';

import '../../General Widgets/Responsive.dart';
import '../../General Widgets/header_widget.dart';
import '../../General Widgets/menu.dart';
import '../Dashboard/Widgets/car_avaliablity_stats.dart';
import 'Widgets/coupon_table.dart';



class CouponPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  //const BookingPage({super.key, required this.scaffoldKey});

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
              selected: 8,
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
                      selected: 8,
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
                            title: "Coupon",
                          ),
                          _height(context),
                          CouponTable(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Expanded(child:
              // Align(
              //   alignment: Alignment.topRight,
              //   child: Padding(
              //     padding: const EdgeInsets.all(12.0),
              //     child: InkWell(
              //       onTap: () => _scaffoldKey.currentState!.openEndDrawer(),
              //       child: CircleAvatar(
              //         backgroundColor: Colors.transparent,
              //         child: Image.asset(
              //           "assets/images/avatar.png",
              //           width: 32,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),),
            ],
          ),
        ));
  }
}
