import 'dart:convert';

class Package {
  final int id;
  final String packageName;

  //final String carImageUrl;
  final int carId;
  final String carName;
  final String carNumber;
  final String driverName;

  //final String driverNumber;
  final int noOfLuaggage;
  final int noOfSeats;
  final double price;
  List<String> points;

  Package(
      this.id,
      this.packageName,
      //this.carImageUrl,
      this.carId,
      this.carName,
      this.carNumber,
      this.driverName,
      //    this.driverNumber,
      this.noOfLuaggage,
      this.noOfSeats,
      this.price,
      this.points);

  factory Package.fromJson(Map<String, dynamic> json) {
    //List<String> points= [];
    var details = json['details']; // != null
    details = details.substring(1, details.length - 1);
    List<String> points = details.split(", ");
    // ? List<String>.from(jsonDecode(json['details']))
    // : [];
    //if (details is List) {
    // var  point =  List<String>.from(details.map((item) => item.toString()));
    //  print("point : "+point.runtimeType.toString());
    //  points = point;
    // }
    var car = json['cars'][0]; // Assuming each package has at least one car

    return Package(
      json['id'],
      json['name'],
      car['id'],
      car['type'],
      car['number_plate'],
      car['driver_name'],
      car['luggage_capacity'],
      car['seating_capacity'],
      car['car_package']['price'].toDouble(),
      points,
    );
  }
}
