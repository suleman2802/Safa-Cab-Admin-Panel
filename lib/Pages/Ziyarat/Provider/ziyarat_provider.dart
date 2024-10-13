import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import '../../../Utilis/config.dart';
import '../../Car/Model/car.dart';
import '../Model/ziyarat.dart';

class ZiyaratProvider extends ChangeNotifier {
  Future<String> addZiyarat(XFile file, String ziyaratName, double price,
      int carId, List<String> points) async {
    print("name $ziyaratName");
    print("price $price");
    print(points);
    print("car id $carId");

    print(points.join(", ").toString());

    try {
      final uri = Uri.parse('https://server.safacab.com/admin/ziyarats/create');
      final request = https.MultipartRequest('POST', uri);

      // Adding headers
      //String accessToken = 'YourAccessTokenHere';
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Prepare the file to upload
      Uint8List imageData = await file.readAsBytes();
      List<int> list = imageData.cast<int>();
      request.files.add(https.MultipartFile.fromBytes(
        'ziyarat_image',
        list,
        filename: basename(file.path),
        // MediaType('image', fileExtension.replaceFirst(
        //     '.', '')),
        contentType: MediaType('image', 'png'),
      ));

      // Add other fields
      request.fields['car_id'] = carId.toString();
      request.fields['ziyarat_name'] = ziyaratName;
      request.fields['price'] = price.toString();
      request.fields['ziyarat_points'] =
          jsonEncode(points); //points.join(", ").toString();

      // Send the request
      try {
        final response = await request.send();

        // Read the response body
        final responseBody = await https.Response.fromStream(response);

        if (response.statusCode == 200) {
          print('Ziyarat Package api hit successfully');
          return "Ziyarat Record added successfully";
        } else {
          print(
              'Failed to hit ziyarat package image. Status code: ${response.statusCode}');
          print('Response body: ${responseBody.body}');
          return "Unable to add Ziyarat package, try again later";
        }
      } catch (e) {
        print('Error occurred: $e');
        return "Unable to add Ziyarat package, try again later";
      }
    } catch (error) {
      print(error);
      return "Unable to add Ziyarat package, try again later";
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

  Future<List<Ziyarat>> fetchZiyaratRecord() async {
    try {
      const String apiUrl = 'https://server.safacab.com/admin/ziyarats';
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };

      final response = await https.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        List<Ziyarat> ziyarats = [];
        List<dynamic> data = jsonDecode(response.body)['data'];

        for (var item in data) {
          int carId = item['car_id'];
          Car car = await getCarById(carId);
          Ziyarat ziyarat = Ziyarat.fromJson(item, car);
          ziyarats.add(ziyarat);
        }

        return ziyarats;
      } else {
        print(
            'Failed to load Ziyarat record, Status code: ${response.statusCode}');
        print(response.body);
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<String> deleteZiyaratById(int id) async {
    try {
      final uri = Uri.parse(
          'https://server.safacab.com/admin/ziyarats/delete?ziyaratId=${id}');

      // Configure the request headers with authentication
      final headers = {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await https.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        print('Ziyarat deleted successfully');
        return "Ziyarat Record deleted successfully";
      } else {
        print(
            'Failed to delete the Ziyarat. Status code: ${response.statusCode}');
        print(response.body);
        return "Unable to delete ziyarat record, try again later";
      }
    } catch (error) {
      print(error);
      return "Unable to delete ziyarat record, try again later";
    }
  }

  Future<String> deleteAllZiyarat() async {
    try {
      final uri =
          Uri.parse('https://server.safacab.com/admin/ziyarats/delete-all');

      // Configure the request headers with authentication
      final headers = {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await https.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        print('Ziyarat deleted successfully');
        return "Ziyarat all Record deleted successfully";
      } else {
        print(
            'Failed to delete all the Ziyarat. Status code: ${response.statusCode}');
        print(response.body);
        return "Unable to delete all ziyarat record, try again later";
      }
    } catch (error) {
      print(error);
      return "Unable to delete all ziyarat record, try again later";
    }
  }

  Future<String> updateZiyaratRecord(var file, int id, String ZiyaratName,
      double price, int carId, List<String> points, String carNumber) async {
    var uri = Uri.parse(
        'https://server.safacab.com/admin/ziyarats/update?ziyaratId=$id');
    if (file != null) {
      var request = https.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $accessToken';

      request.fields['car_id'] = carId.toString();
      request.fields['ziyarat_name'] = ZiyaratName;
      request.fields['price'] = price.toString();
      request.fields['ziyarat_points'] = jsonEncode(points);

      var imageStream = https.ByteStream(file!.openRead());
      var imageLength = await file!.length();

      var multipartFile = https.MultipartFile(
        'ziyarat_image',
        imageStream,
        imageLength,
        filename: file!.path.split('/').last,
      );

      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Ziyarat record updated successfully');
        return 'Ziyarat record updated successfully';
      } else {
        print('Failed to update car');

        return "unable to update Ziyarat record right now try again later";
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
              'car_id': carId,
              'ziyarat_name': ZiyaratName,
              'price': price,
              'ziyarat_points': jsonEncode(points),
            }));
        print("body :" + response.body);
        if (response.statusCode == 200) {
          print('Ziyarat record updated successfully');
          return 'Ziyarat record updated successfully';
        } else {
          print('Failed to update car');
          return "Unable to update Ziyarat record, try again later";
        }
      } catch (error) {
        print(error);
        return "Unable to update Ziyarat record, try again later";
      }
    }
  }
}
