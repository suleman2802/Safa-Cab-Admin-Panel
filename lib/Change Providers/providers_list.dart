import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

import '../../Pages/Airport/Provider/Airport_Provider.dart';
import '../../Pages/Booking/Provider/booking_provider.dart';
import '../../Pages/Car/Provider/Car_provider.dart';
import '../../Pages/Coupon/Provider/coupon_provider.dart';
import '../Pages/Customer/Provider/customer_provider.dart';
import '../../Pages/Package/Provider/package_provider.dart';
import '../../Pages/Stats/Provider/stats_provider.dart';
import '../../Pages/Train/Provider/Train_Provider.dart';
import '../Pages/Review/Provider/review_provider.dart';
import '../Pages/Ziyarat/Provider/ziyarat_provider.dart';



List<SingleChildWidget> providersList() {
  return [

    ChangeNotifierProvider(
      create: (_) => BookingProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => CarProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => CouponProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => CustomerProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => PackageProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => AirportProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => TrainProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => StatsProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => ReviewProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => ZiyaratProvider(),
    ),
  ];
}