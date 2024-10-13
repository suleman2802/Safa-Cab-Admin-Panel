class Car {
  final int carId;
  final String carImageUrl;
  final String carName;
  final String carNumber;
  final String driverName;

//  final String driverNumber;
  final int carModel;
  final int noOfSeats;
  final int noOfLuggage;
  final int totalQyt;

  Car(
    this.carId,
    this.carImageUrl,
    this.carName,
    this.carModel,
    this.driverName,
//      this.driverNumber,
    this.carNumber,
    this.noOfSeats,
    this.noOfLuggage,
    this.totalQyt,
  );

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      json['id'],
      "https://server.safacab.com/${json['image']}",
      //"https://images.unsplash.com/photo-1544502062-f82887f03d1c?q=80&w=3359&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      json['type'],
      int.parse(json['model']),
      json['driver_name'],
      json['number_plate'],
      json['seating_capacity'],
      json['luggage_capacity'],
      json['saved_qty'],
    );
  }
}
