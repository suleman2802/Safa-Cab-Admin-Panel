import 'dart:convert';

import 'package:http/http.dart' as https;
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import '../../../Utilis/config.dart';
import '../Model/car.dart';

class CarProvider extends ChangeNotifier {
  Future<String> deleteCarById(int carId) async {
    print("id : $carId");
    try {
      print("inside delete car ");
      final uri = Uri.parse(
          //'https://${baseUrl + delCarByIdUrl + carId.toString()}'
          'https://server.safacab.com/admin/cars/delete?carId=${carId}');

      // Configure the request headers with authentication
      final headers = {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await https.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        print('Car deleted successfully');
        return 'Car deleted successfully';
      } else {
        print('Failed to delete the car. Status code: ${response.statusCode}');
        print(response.body);
        return "Unable to delete car try again later";
      }
    } catch (error) {
      print(error);
      return "Unable to delete car try again later";
    }
  }

  Future<String> updateCarRecord(Car car, var _carImage, int id) async {
    var uri =
        Uri.parse('https://server.safacab.com/admin/cars/update?carId=$id');
    if (_carImage != null) {
      var request = https.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.fields['type'] = car.carName;
      request.fields['number_plate'] = car.carNumber;
      request.fields['seating_capacity'] = car.noOfSeats.toString();
      request.fields['luggage_capacity'] = car.noOfLuggage.toString();
      request.fields['driver_name'] = car.driverName;
      request.fields['model'] = car.carModel.toString();
      request.fields['saved_qty'] = car.totalQyt.toString();

      var imageStream = https.ByteStream(_carImage!.openRead());
      var imageLength = await _carImage!.length();

      var multipartFile = https.MultipartFile(
        'car_image',
        imageStream,
        imageLength,
        filename: _carImage!.path.split('/').last,
      );

      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Car record updated successfully');
        return "Car record updated successfully";
      } else {
        print('Failed to update car');
        return 'Failed to update car record try again later';
      }
    } else {
      try {
        final headers = {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $accessToken"
        };
        var response = await https.put(uri,
            headers: headers,
            body: jsonEncode({
              'type': car.carName,
              'number_plate': car.carNumber,
              'seating_capacity': car.noOfSeats,
              'luggage_capacity': car.noOfLuggage,
              'driver_name': car.driverName,
              'model': car.carModel,
              'saved_qty': car.totalQyt
            }));
        print("body :" + response.body);
        if (response.statusCode == 200) {
          print('Car record updated successfully');
          return 'Car record updated successfully';
        } else if (response.statusCode == 403) {
          print('unable to update car because of quantity issue');
          return 'Unable to update car as currently this car is booked';
        } else {
          print('Failed to update car');
          return "unable to update Car record  try again later";
        }
      } catch (error) {
        print(error);
        return error.toString();
      }
    }
  }

  Future<List<Car>> fetchCarRecord() async {
    try {
      const String apiUrl = 'https://${baseUrl + getCarUrl}';
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };
      final response = await https.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        print("car api hit successfully");

        List<dynamic> carsJson = jsonDecode(response.body)['data'];

        List<Car> list = carsJson.map((json) => Car.fromJson(json)).toList();
        print(list);
        return list;
      } else {
        print(response.body);
        print("Failed to load cars");
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  //Future<List<String>>
  Future<List<String>> fetchCarList() async {
    List<String>? list;
    try {
      const String apiUrl = 'https://${baseUrl + getCarUrl}';
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };
      final response = await https.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> carsJson = jsonDecode(response.body)['data'];

        list = carsJson.map((json) => json['type']).cast<String>().toList();
        // print(list);
        return list;
      } else {
        //throw Exception('Failed to load cars');
        print("else failed");
        return [];
      }
    } catch (error) {
      print(error);
      return [];
      // return "g";
    }
  }

  Future<String> addMenuItem(Car car, XFile file) async {
    try {
      // var url = Uri.https(baseUrl, addCarUrl);
      // final headers = {
      //   'Content-Type': 'application/json',
      //   "Authorization": "Bearer $accessToken"
      // };
      // final body = json.encode({
      //   "type": car.carName,
      //   "number_plate": car.carNumber,
      //   "seating_capacity": car.noOfSeats,
      //   "car_image": _image!,
      //   "luggage_capacity": car.noOfLuggage,
      //   "driver_name": car.driverName,
      //   "model": car.carModel,
      // });
      // print(car.toString());
      // var response = await https.post(url, headers: headers, body: body);
      // print(response.body);
      // print(response.statusCode);
      // URL of the API endpoint

      //
      // var uri = Uri.parse('https://server.safacab.com/admin/cars/create');
      //
      // // Create a multipart request
      // var request = https.MultipartRequest('POST', uri);
      //
      // // Add headers
      // request.headers['Authorization'] = 'Bearer $accessToken';
      // request.headers['Content-Type'] = 'multipart/form-data';
      //
      // // Attach the file in the request
      // var multipartFile = await https.MultipartFile.fromPath(
      //   'car_image', // key must match the server side
      //   imageFile!.toString(),
      //   filename: basename(imageFile.toString()),
      //   contentType: MediaType('image', 'jpeg'), // adjust the contentType as needed
      // );
      //
      // // Add the file to the request
      // request.files.add(multipartFile);
      //
      // // Add other fields
      // request.fields['type'] = car.carName;
      // request.fields['number_plate'] = car.carNumber;
      // request.fields['seating_capacity'] = car.noOfSeats.toString();
      // request.fields['luggage_capacity'] =  car.noOfLuggage.toString();
      // request.fields['driver_name'] = car.driverName;
      // request.fields['model'] = car.carModel.toString();
      //
      // // Send the request
      // var response = await request.send();
      //
      // // Listen for response
      // response.stream.transform(utf8.decoder).listen((value) {
      //   print(value);
      // });
      // if (response.statusCode == 200) {
      //   print("Data uploaded successfully");
      // } else {
      //   print("Failed to upload data. Status code: ${response.statusCode}");
      // }
      //working
      final uri = Uri.parse('https://${baseUrl + addCarUrl}');
      final request = https.MultipartRequest('POST', uri);

      // Adding headers
      //String accessToken = 'YourAccessTokenHere';
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Prepare the file to upload
      Uint8List imageData = await file.readAsBytes();
      List<int> list = imageData.cast<int>();
      request.files.add(https.MultipartFile.fromBytes(
        'car_image',
        list,
        filename: basename(file.path),
        // MediaType('image', fileExtension.replaceFirst(
        //     '.', '')),
        contentType: MediaType('image', 'png'),
      ));

      // Add other fields
      request.fields['type'] = car.carName;
      request.fields['number_plate'] = car.carNumber;
      request.fields['seating_capacity'] = car.noOfSeats.toString();
      request.fields['luggage_capacity'] = car.noOfLuggage.toString();
      request.fields['driver_name'] = car.driverName;
      request.fields['model'] = car.carModel.toString();
      request.fields['saved_qty'] = car.totalQyt.toString();

      // Send the request
      try {
        final response = await request.send();
        if (response.statusCode == 200) {
          print('Image uploaded successfully');
          return "Car Record added successfully";
        } else {
          print('Failed to upload image. Status code: ${response.statusCode}');
          return "Unable to add car record, try again later";
        }
      } catch (e) {
        print('Error occurred: $e');
        return "Unable to add car record, try again later";
      }
    } catch (error) {
      print(error);
      return "Unable to add car record, try again later";
    }
  }
}
//}
