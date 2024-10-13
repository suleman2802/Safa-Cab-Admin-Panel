import 'dart:convert';

import '../../Car/Model/car.dart';

class Ziyarat {
  final int id;
  final String ziyaratName;

  final String imageUrl;
  final int carId;
  final String carName;
  final String carNumber;
  final String driverName;

//final String driverNumber;
  final int noOfLuaggage;
  final int noOfSeats;
  final double price;
  List<String> points;

  Ziyarat(
      this.id,
      this.ziyaratName,
      this.imageUrl,
      this.carId,
      this.carName,
      this.carNumber,
      this.driverName,
      this.noOfLuaggage,
      this.noOfSeats,
      this.price,
      this.points);

  // factory Ziyarat.fromJson(Map<String, dynamic> json, Car car) {
  //   String details = json['sub_categories'][0]["ziyarat_points"]; // != null
  //   print(details);
  //   //details = details.substring(1, details.length - 1);
  //   //print(details);
  //   List<String> points = details.split(", ");
  //   print(points.length);
  //   print(points);
  //
  //   return Ziyarat(
  //     json['id'],
  //     json['name'],
  //     json['image'],
  //     car.carId,
  //     car.carName,
  //     car.carNumber,
  //     car.driverName,
  //     car.noOfLuggage,
  //     car.noOfSeats,
  //     json["price"].toDouble,
  //     points,
  //   );
  // }
  factory Ziyarat.fromJson(Map<String, dynamic> json, Car car) {
    // String details = json['sub_categories'][0]['ziyarat_points'];
    // print(details);
    // details = details.substring(1, details.length - 1);
    // print(details);
    // List<String> points = details.split(", ");
    // print(points);
    List<dynamic> jsonResponse = jsonDecode(json['sub_categories'][0]['ziyarat_points']);
    List<String> points = List<String>.from(jsonResponse);
    return Ziyarat(
      json['id'],
      json['ziyarat_name'],
      "https://server.safacab.com/${json['image']}",
      json['car_id'],
      car.carName,
      car.carNumber,
      car.driverName,
      car.noOfLuggage,
      car.noOfSeats,
      json['price'].toDouble(),
      // (json['sub_categories'][0]['ziyarat_points'] as String).split(','),
      points,
    );
  }
}
