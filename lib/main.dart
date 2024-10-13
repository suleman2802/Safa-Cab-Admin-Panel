import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Pages/Airport/airport_page.dart';
import '../Pages/Login/login_page.dart';
import '../Pages/Package/package_page.dart';
import '../Pages/Review/review.dart';
import '../Pages/Stats/stats_page.dart';
import '../Pages/Ziyarat/ziyarat_page.dart';
import '../Pages/Customer/customer_page.dart';
import '../Pages/Car/car_page.dart';
import '../Routes/routes_name.dart';
import '../Pages/Booking/booking_page.dart';
import '../Pages/Dashboard/dashboard.dart';
import '../Pages/Coupon/coupon_page.dart';
import '../Pages/Train/train_page.dart';
import './Change Providers/providers_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providersList(),
      child: MaterialApp(
        title: 'Safa Cab',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              // color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 255, 245, 190),
          //Color.fromARGB(255, 246, 240, 185),
          primaryColor: Colors.yellow,
          canvasColor: Colors.white,
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: Colors.yellow,
            contentTextStyle: TextStyle(
              color: Colors.black,
            ),
            //actionTextColor: Colors.black,
          ),
          fontFamily: 'IBMPlexSans',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
          // brightness: Brightness.dark,
        ),
        // routes: {
        //   dashboardPage: (context) => DashBoard(),
        //   bookingPage: (context) => BookingPage(),
        //   carPage: (context) => CarPage(),
        //   customerPage: (context) => CustomerPage(),
        //   ziyaratPage: (context) => ZiyaratPage(),
        //   reviewPage: (context) => ReviewPage(),
        //   loginPage: (context) => LoginPage(),
        //   trainPage: (context) => TrainPage(),
        //   airportPage: (context) => AirportPage(),
        //   statsPage: (context) => StatsPage(),
        //   packagePage: (context) => PackagePage(),
        //   couponPage: (context) => CouponPage(),
        // },
        home: LoginPage(),
      ),
    );
  }
}
