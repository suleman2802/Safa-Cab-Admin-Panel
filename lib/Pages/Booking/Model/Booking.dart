class Booking {
  final int id;
  final String bookingId;
  final String bookingType;
  final String customerName;
  final String driverName;
  final String carType;
  final int carId;
  final String carNumber;
  final String pickup;
  final String dropoff;
  final String dateTime;
  final String status;
  final double discount;
  final double price;

  Booking(
      this.id,
      this.bookingId,
      this.bookingType,
      this.customerName,
      this.driverName,
      this.carType,
      this.carId,
      this.carNumber,
      this.pickup,
      this.dropoff,
      this.dateTime,
      this.status,
      this.discount,
      this.price);
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      json['id'],
      json['booking_id'],
      json['booking_type'],
      json['user']['username'],
      json['car']['driver_name'],
      json['car']['type'],
      json['car']['id'],
      json['car']['number_plate'],
      json['pickup_point'] ?? '',
      json['drop_point'] ?? '',
      json['booking_date'],
      json['status'],
      json['discount'].toDouble(),
      json['total_price'].toDouble(),
    );
  }
}
