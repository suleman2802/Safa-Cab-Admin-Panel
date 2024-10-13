import 'dart:convert';

import 'package:http/http.dart' as https;
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import '../../../Utilis/config.dart';
import '../../Car/Model/car.dart';
import '../Model/Train.dart';

class TrainProvider extends ChangeNotifier {
  List<Train> _bookings = [];

  List<Train> get bookingList => _bookings;

  Future<String> addMenuItem(String pickup_location, String drop_location,
      int car_id, double fare) async {
    final uri = Uri.parse('https://${baseUrl + addTrainUrl}');
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
        print('Railway Station record added successfully');
        return 'Railway Station fare record added successfully';
      } else {
        print(
            'Failed to update railway station record status record : ${response.statusCode}');
        return "unable to add Railway Station fare, try again later";
      }
    } catch (error) {
      print(error);
      return "unable to add Railway Station fare, try again later";
    }
  }

  Future<String> updateTrainRecord(int id, String pickup_location,
      String drop_location, int car_id, double fare) async {
    var uri = Uri.parse(
        'https://server.safacab.com/admin/railway-fares/update?railwayFareId=$id');
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
        print('Railway Station record updated successfully');
        return 'Railway Station record updated successfully';
      } else {
        print(
            'Failed to update railway stattion record status record : ${response.statusCode}');
        return "unable to update Railway Station record right now try again later";
      }
    } catch (error) {
      print(error);
      return "unable to update Railway Station record right now try again later";
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

  Future<String> deleteTrainById(int id) async {
    try {
      final uri = Uri.parse(
          'https://server.safacab.com/admin/railway-fares/delete?railwayFareId=${id}');

      // Configure the request headers with authentication
      final headers = {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await https.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        print('Railway Station deleted successfully');
        return "Railway Station fare deleted successfully";
      } else {
        print(
            'Failed to delete the train. Status code: ${response.statusCode}');
        return "Unable to delete train record, Try again later";
      }
    } catch (error) {
      print(error);
      return "Unable to delete train record, Try again later";
    }
  }

  Future<List<Train>> fetchTrainRecord() async {
    try {
      const String apiUrl = 'https://${baseUrl + getTrainUrl}';
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };
      final response = await https.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        List<Train> faresList = [];
        List<dynamic> faresJson = jsonDecode(response.body)['data'];

        for (var fareData in faresJson) {
          Car car = await getCarById(fareData['car_id']);
          if (car.carId >= 0) {
            Train fare = Train(
              fareData["id"],
              //"https://server.safacab.com/${fareData["image"]}",
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
        print(
            'Failed to load Railway Station fares, Status code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<String> deleteAllTrainRecord() async {
    try {
      final uri = Uri.parse(
          "https://server.safacab.com/admin/railway-fares/delete-all");

      // Configure the request headers with authentication
      final headers = {
        //'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await https.delete(
        uri, headers: headers, // body: body
      );
      print(response.body);
      if (response.statusCode == 200) {
        print('Train api hit  successfully');
        return "All Train fare deleted successfully";
      } else {
        print(response.body);
        print(
            'Failed to hit Train delete all api  Status code: ${response.statusCode}');
        return "Unable to delete all Train Fare record";
      }
    } catch (error) {
      print(error);
      return "Unable to delete all Train Fare record";
    }
  }
}
