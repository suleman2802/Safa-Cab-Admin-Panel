import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:flutter/material.dart';
import '../../../Utilis/config.dart';
import '../Model/Booking.dart';

class BookingProvider extends ChangeNotifier {
  // List<Booking> _bookings = [];
  //
  // List<Booking> get bookingsList => _bookings;

  // Future<String> addBookingItem() async {
  //   //_bookings.add(booking);
  //   return "Ok";
  // }

  Future<String> updateBookingRecord(int id, String driver_name, int carId,
      double total_price, String status, bool isCarNotChanged) async {
    print("driver name : ${driver_name}");
    print("car id : ${carId}");
    print("price : ${total_price}");
    print("status : ${status}");
    var uri = Uri.parse(
        'https://server.safacab.com/admin/bookings/update-details?bookingId=$id');
    try {
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };
      var body;
      if (isCarNotChanged) {
        body = jsonEncode({
          'driver_name': driver_name,
          'total_price': total_price,
          'status': status
        });
      } else {
        body = jsonEncode({
          'driver_name': driver_name,
          'car_id': carId,
          'total_price': total_price,
          'status': status
        });
      }
      var response = await https.put(uri, headers: headers, body: body);
      print("body :" + response.body);
      if (response.statusCode == 200) {
        print('Booking record updated successfully');
        return 'Booking record updated successfully';
      } else {
        final jsonResponse = json.decode(response.body);
        print('Failed to update car');
        return jsonResponse["data"];
      }
    } catch (error) {
      print(error);
      return "unable to update Booking record, try again later";
    }
  }

  Future<String> deleteBookingById(int id) async {
    try {
      final uri = Uri.parse(
          'https://server.safacab.com/admin/bookings/delete?bookingId=${id}');

      // Configure the request headers with authentication
      final headers = {
        //'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await https.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        print('Booking deleted successfully');
        return 'Booking record deleted successfully';
      } else {
        print(response.body);
        print(
            'Failed to delete the Booking. Status code: ${response.statusCode}');
        return 'Unable to delete Booking, try again later';
      }
    } catch (error) {
      print(error);
      return 'Unable to delete Booking, try again later';
    }
  }

  Future<List<Booking>> fetchBookingRecord() async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };
      final response = await https.get(
          Uri.parse('https://server.safacab.com/admin/bookings/'),
          headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        List<Booking> list =
            data.map((booking) => Booking.fromJson(booking)).toList();
        return list;
      } else {
        print('Failed to load bookings ${response.statusCode}');
        print(response.body);
        return [];
      }
    } catch (error) {
      print(error.toString());
      return [];
    }
  }
}
