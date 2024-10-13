import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'dart:typed_data';
import '../../../Utilis/config.dart';
import '../../Car/Model/car.dart';
import '../Model/package.dart';
class PackageProvider extends ChangeNotifier {
  List<Package> _packages = [];

  List<Package> get packageList => _packages;

  Future<String> addMenuItem(String packageName,double price,int carId,List<String> points) async{
    // try {
    //   final uri = Uri.parse("https://server.safacab.com/admin/packages/create");
    //   final headers = {
    //     'Content-Type': 'application/json',
    //     "Authorization": "Bearer $accessToken"
    //   };
    //   var response = await https.post(uri,
    //       headers: headers,
    //       body: jsonEncode({
    //         'name': packageName,
    //         'price': price,
    //         'car_id':carId,
    //         'details': points,
    //       }));
    //   print("body :"+response.body);
    //   if (response.statusCode == 200) {
    //     print('Package record added successfully');
    //     return 'Package record added successfully';
    //   } else {
    //
    //     print('Failed to add Package record ${response.statusCode}');
    //     return "unable to add Package record try again later";
    //   }
    // } catch (error) {
    //   print(error);
    //   return "unable to add Package record try again later";
    // }
    final url = Uri.parse('https://server.safacab.com/admin/packages/create');
    final headers = {
      // 'Content-Type': 'application/x-www-form-urlencoded',
      //'Content-Type': 'application/json',
      "Authorization": "Bearer $accessToken",
    };
    final body = {
      'name': packageName,
      'details': points.join(", "),
      'car_id': carId.toString(),
      'price': price.toString(),
    };

    try {
      final response = await https.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Success: ${response.body}');
        return "Ok";
      } else {
        print('Error: ${response.reasonPhrase}');
        return "Unable to add package at time try again later";
      }
    } catch (e) {
      print('Exception: $e');
      return "Unable to add package at time try again later";
    }

  }
  Future<String> updatePackageRecord(int id,String packageName,double price,int carId,List<String> points) async{
    String result = await addMenuItem(packageName,price,carId,points);
    if(result =="Ok"){
      String result2 = await deletePackageById(id);
      if(result2 =="Ok"){
        return "Package Record updated successfully";
      }
    }
    return "unable to update package record";

  }
  Future<String> deletePackageById(int id) async {
    try {

      final uri = Uri.parse(
          'https://server.safacab.com/admin/packages/delete?packageId=${id}'
      );

      // Configure the request headers with authentication
      final headers = {
        //'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await https.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        print('Package deleted successfully');
        return "Ok";
      } else {
        print('Failed to delete the Package. Status code: ${response.statusCode}');
        print(response.body);
        return 'Failed to delete the Package try again later';
      }
    }catch(error){
      print(error);
      return 'Failed to delete the Package try again later';
    }

  }

  Future<List<Package>> fetchPackageRecord() async {
    try {
      const String apiUrl = 'https://${baseUrl + getPackageUrl}';
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };
      final response = await https.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List packagesData = data['data'];
        List<Package> _packages = [];
        _packages = packagesData.map((json) => Package.fromJson(json)).toList();
        return _packages;
      } else {
        print('Failed to load Package record, Status code: ${response.statusCode}');
        print(response.body);
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }
  Future<String> deleteAllPackage() async {
    try {
      final uri = Uri.parse(
          'https://server.safacab.com/admin/packages/delete-all');

      // Configure the request headers with authentication
      final headers = {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await https.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        print('Package deleted successfully');
        return "Package all Record deleted successfully";
      } else {
        print(
            'Failed to delete all the Package. Status code: ${response.statusCode}');
        print(response.body);
        return "Unable to delete all Package record, try again later";
      }
    } catch (error) {
      print(error);
      return "Unable to delete all Package record, try again later";
    }
  }

}