// import 'package:flutter/material.dart';
// import './routes_name.dart';
//
// List<String> navbarList = [
//   dashboardPage,
//   bookingPage,
//   carPage,
//   ziyaratPage,
//   packagePage,
//   airportPage,
//   trainPage,
//   customerPage,
//   couponPage,
//   statsPage,
//   reviewPage,
//   loginPage,
// ];
//
// navigateToDashboard(BuildContext context) =>
//     Navigator.of(context).pushNamed(dashboardPage);
//
// navigateToBooking(BuildContext context) =>
//     Navigator.of(context).pushNamed(bookingPage);
//
// navigateToCar(BuildContext context) => Navigator.of(context).pushNamed(carPage);
//
// navigateToCoupon(BuildContext context) =>
//     Navigator.of(context).pushNamed(couponPage);
//
// navigateToCustomer(BuildContext context) =>
//     Navigator.of(context).pushNamed(customerPage);
//
// navigateToZiyarat(BuildContext context) =>
//     Navigator.of(context).pushNamed(ziyaratPage);
//
// navigateToReview(BuildContext context) =>
//     Navigator.of(context).pushNamed(reviewPage);
//
// navigateToStats(BuildContext context) =>
//     Navigator.of(context).pushNamed(statsPage);
//
// navigateToPackage(BuildContext context) =>
//     Navigator.of(context).pushNamed(packagePage);
//
// navigateToTrain(BuildContext context) =>
//     Navigator.of(context).pushNamed(trainPage);
//
// navigateToAirport(BuildContext context) =>
//     Navigator.of(context).pushNamed(airportPage);
//
// navigateUsingIndex(BuildContext context, int index) =>
//     Navigator.of(context).pushNamed(navbarList[index]);
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Pages/Login/login_page.dart';
import '../Pages/Airport/airport_page.dart';
import '../Pages/Booking/booking_page.dart';
import '../Pages/Car/car_page.dart';
import '../Pages/Coupon/coupon_page.dart';
import '../Pages/Customer/customer_page.dart';
import '../Pages/Dashboard/dashboard.dart';
import '../Pages/Package/package_page.dart';
import '../Pages/Review/review.dart';
import '../Pages/Stats/stats_page.dart';
import '../Pages/Train/train_page.dart';
import '../Pages/Ziyarat/ziyarat_page.dart';
import './routes_name.dart';

List<String> navbarList = [
  dashboardPage,
  bookingPage,
  carPage,
  ziyaratPage,
  packagePage,
  airportPage,
  trainPage,
  customerPage,
  couponPage,
  statsPage,
  reviewPage,
  loginPage,
];

void _navigateWithoutAnimation(BuildContext context, Widget page) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          child,
    ),
  );
}

navigateToDashboard(BuildContext context) =>
    _navigateWithoutAnimation(context, DashBoard());

navigateToBooking(BuildContext context) =>
    _navigateWithoutAnimation(context, BookingPage());

navigateToCar(BuildContext context) =>
    _navigateWithoutAnimation(context, CarPage());

navigateToCoupon(BuildContext context) =>
    _navigateWithoutAnimation(context, CouponPage());

navigateToCustomer(BuildContext context) =>
    _navigateWithoutAnimation(context, CustomerPage());

navigateToZiyarat(BuildContext context) =>
    _navigateWithoutAnimation(context, ZiyaratPage());

navigateToReview(BuildContext context) =>
    _navigateWithoutAnimation(context, ReviewPage());

navigateToStats(BuildContext context) =>
    _navigateWithoutAnimation(context, StatsPage());

navigateToPackage(BuildContext context) =>
    _navigateWithoutAnimation(context, PackagePage());

navigateToTrain(BuildContext context) =>
    _navigateWithoutAnimation(context, TrainPage());

navigateToAirport(BuildContext context) =>
    _navigateWithoutAnimation(context, AirportPage());

navigateToLogin(BuildContext context) =>
    _navigateWithoutAnimation(context, LoginPage());

navigateUsingIndex(BuildContext context, int index) {
  switch (navbarList[index]) {
    case dashboardPage:
      navigateToDashboard(context);
      break;
    case bookingPage:
      navigateToBooking(context);
      break;
    case carPage:
      navigateToCar(context);
      break;
    case ziyaratPage:
      navigateToZiyarat(context);
      break;
    case packagePage:
      navigateToPackage(context);
      break;
    case airportPage:
      navigateToAirport(context);
      break;
    case trainPage:
      navigateToTrain(context);
      break;
    case customerPage:
      navigateToCustomer(context);
      break;
    case couponPage:
      navigateToCoupon(context);
      break;
    case statsPage:
      navigateToStats(context);
      break;
    case reviewPage:
      navigateToReview(context);
      break;
    case loginPage:
      navigateToLogin(context);
      break;
    default:
      break;
  }
}
