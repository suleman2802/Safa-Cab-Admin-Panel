import 'dart:convert';

import 'package:http/http.dart' as https;
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import '../../Car/Model/car.dart';
import '../../../Utilis/config.dart';
import '../Model/Airport.dart';

class AirportProvider extends ChangeNotifier {
  List<Airport> _bookings = [];

  List<Airport> get bookingsList => _bookings;

  Future<String> addMenuItem(String pickup_location, String drop_location,
      int car_id, double fare) async {
    final uri = Uri.parse('https://${baseUrl + addAirportUrl}');
    try {
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };
      var response = await https.post(uri,
          headers: headers,
          body: jsonEncode({
            'pickup_location': pickup_location,
            'drop_location': drop_location,
            'car_id': car_id,
            'fare': fare,
          }));
      print("body :" + response.body);
      if (response.statusCode == 200) {
        print('Airport record added successfully');
        return 'Airport record added successfully';
      } else {
        print('Failed to update car');
        return "unable to update Airport record, try again later";
      }
    } catch (error) {
      print(error);
      return "unable to update Airport record, try again later";
    }
  }

  Future<Car> getCarById(int id) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };
      String apiUrl =
          'https://server.safacab.com/admin/cars/car?carId=${id}'; //'https://${baseUrl+getCarByIdUrl}';
      final response = await https.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body)['data'];
        return Car.fromJson(jsonResponse);
      } else {
        print(
            'Failed to load car with ID $id, Status code: ${response.statusCode}');
        return Car(-1, "", "", -2, "", "", -1, -1, -1);
      }
    } catch (error) {
      return Car(-1, "", "", -2, "", "", -1, -1, -1);
    }
  }

  Future<String> deleteAirportById(int id) async {
    try {
      final uri = Uri.parse(
          'https://server.safacab.com/admin/airport-fares/delete?airportFareId=${id}');

      // Configure the request headers with authentication
      final headers = {
        //'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await https.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        print('Airport fare deleted successfully');
        return 'Airport fare deleted successfully';
      } else {
        print(response.body);
        print('Failed to delete the car. Status code: ${response.statusCode}');
        return 'Unable to delete airport fare, try again later';
      }
    } catch (error) {
      print(error);
      return 'Unable to delete airport fare, try again later';
    }
  }

  Future<String> deleteAllAirport() async {
    try {
      final uri = Uri.parse(
          'https://server.safacab.com/admin/airport-fares/delete-all');

      // Configure the request headers with authentication
      final headers = {
        //'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await https.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        print('Airport fare deleted successfully');
        return 'All Airport fare deleted successfully';
      } else {
        print(response.body);
        print('Failed to delete the car. Status code: ${response.statusCode}');
        return 'Unable to delete all airport fare, try again later';
      }
    } catch (error) {
      print(error);
      return 'Unable to delete all airport fare, try again later';
    }
  }

  Future<String> updateAirportRecord(int id, String pickup_location,
      String drop_location, int car_id, double fare) async {
    var uri = Uri.parse(
        'https://server.safacab.com/admin/airport-fares/update?airportFareId=$id');
    // if (file != null) {
    //   var request = https.MultipartRequest('PUT', uri);
    //   request.headers['Authorization'] = 'Bearer $accessToken';
    //
    //   request.fields['pickup_location'] = pickup_location;
    //   request.fields['drop_location'] = drop_location;
    //   request.fields['car_id'] = car_id.toString();
    //   request.fields['fare'] = fare.toString();
    //
    //   var imageStream = https.ByteStream(file!.openRead());
    //   var imageLength = await file!.length();
    //
    //   var multipartFile = https.MultipartFile(
    //     'airport_image',
    //     imageStream,
    //     imageLength,
    //     filename: file!.path.split('/').last,
    //   );
    //
    //   request.files.add(multipartFile);
    //
    //   var response = await request.send();
    //
    //   if (response.statusCode == 200) {
    //     print('Airport record updated successfully');
    //     return 'Airport record updated successfully';
    //   } else {
    //     print('Failed to update car');
    //     return "unable to update Airport record right now try again later";
    //   }
    // } else {
    try {
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };
      var response = await https.put(uri,
          headers: headers,
          body: jsonEncode({
            'pickup_location': pickup_location,
            'drop_location': drop_location,
            'car_id': car_id,
            'fare': fare,
          }));
      print("body :" + response.body);
      if (response.statusCode == 200) {
        print('Airport record updated successfully');
        return 'Airport record updated successfully';
      } else {
        print('Failed to update car');
        return "unable to update Airport record, try again later";
      }
    } catch (error) {
      print(error);
      return "unable to update Airport record, try again later";
    }
  }

  Future<List<Airport>> fetchAirportRecord() async {
    try {
      const String apiUrl = 'https://${baseUrl + getAirportUrl}';
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };
      final response = await https.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        List<Airport> faresList = [];
        List<dynamic> faresJson = jsonDecode(response.body)['data'];

        for (var fareData in faresJson) {
          Car car = await getCarById(fareData['car_id']);
          if (car.carId >= 0) {
            Airport fare = Airport(
              fareData["id"],
              // "https://server.safacab.com/${fareData["image"]}",
              car.carName,
              car.carId,
              car.carNumber,
              car.noOfSeats,
              car.noOfLuggage,
              car.driverName,
              fareData['pickup_location'],
              fareData['drop_location'],
              fareData['fare'].toDouble(),
            );
            faresList.add(fare);
          }
        }
        return faresList;
      } else {
        print(response.body);
        print(
            'Failed to load airport fares, Status code: ${response.statusCode}');
        print(response.body);
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }
}
