import 'package:flutter/material.dart';
import '../Routes/navigation_methods.dart';
import '../Pages/home/model/menu_modal.dart';
import './Responsive.dart';

class Menu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  int selected;

  Menu({super.key, required this.scaffoldKey, required this.selected});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<MenuModel> menu = [
    MenuModel(icon: 'assets/navbar/dashboard.png', title: "Dashboard"),
    MenuModel(icon: 'assets/navbar/booking.png', title: "Bookings"),
    MenuModel(icon: 'assets/navbar/car.png', title: "Cars"),
    MenuModel(icon: 'assets/navbar/ziyarat.png', title: "Ziyarat"),
    MenuModel(icon: 'assets/navbar/package.png', title: "Packages"),
    MenuModel(icon: 'assets/navbar/airport.png', title: "Airport Fare"),
    MenuModel(icon: 'assets/navbar/train.png', title: "Train Fare"),
    MenuModel(icon: 'assets/navbar/customer.png', title: "Customers"),
    MenuModel(icon: 'assets/navbar/coupon.png', title: "Coupon"),
    MenuModel(icon: 'assets/navbar/stats.png', title: "Sales Stats"),
    MenuModel(icon: 'assets/navbar/review.png', title: "Reviews"),
    MenuModel(icon: 'assets/navbar/logout.png', title: "Logout"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
          ),
          color: Theme.of(context).primaryColor),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Responsive.isMobile(context) ? 40 : 55,
              ),
              for (var i = 0; i < menu.length; i++)
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.selected = i;
                    });
                    navigateUsingIndex(context, widget.selected);
                    widget.scaffoldKey.currentState!.closeDrawer();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                      color: widget.selected == i
                          // ? Theme.of(context).primaryColor
                          // : Colors.transparent,
                          ? Theme.of(context).canvasColor
                          : Theme.of(context).primaryColor,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 7),
                              child:
                                  //SizedBox(),
                                  Image.asset(
                                menu[i].icon,
                                color: widget.selected == i
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                            Text(
                              menu[i].title,
                              style: TextStyle(
                                  fontSize: 24,
                                  color: widget.selected == i
                                      ? Colors.black
                                      : Colors.grey,
                                  fontWeight: widget.selected == i
                                      ? FontWeight.w600
                                      : FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
