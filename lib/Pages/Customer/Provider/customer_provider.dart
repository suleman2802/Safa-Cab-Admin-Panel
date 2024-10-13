import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:flutter/material.dart';
import '../../../Utilis/config.dart';
import '../Model/customer.dart';

class CustomerProvider extends ChangeNotifier {
  List<Customer> _customers = [];

  List<Customer> get bookingList => _customers;

  Future<String> updateCustomerRecord(int id, String email, String username,
      String phone_no, String user_type) async {
    print(user_type);
    var uri =
        Uri.parse('https://server.safacab.com/admin/users/update?userId=$id');
    try {
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };
      var response = await https.put(uri,
          headers: headers,
          body: jsonEncode({
            'username': username,
            'email': email,
            'phone_no': phone_no,
            'user_type': user_type,
          }));
      print("body :" + response.body);
      if (response.statusCode == 200) {
        print('Customer record updated successfully');
        return 'Customer record updated successfully';
      } else {
        print('Failed to update car');
        return "unable to update Customer record right now try again later";
      }
    } catch (error) {
      print(error);
      return error.toString();
    }
  }

  Future<String> deleteCustomerById(int id) async {
    try {
      final uri = Uri.parse(
          'https://server.safacab.com/admin/users/delete?userId=${id}');

      // Configure the request headers with authentication
      final headers = {
        //'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await https.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        print('Railway Station deleted successfully');
        return "Customer record deleted successfully";
      } else {
        print('Failed to delete the car. Status code: ${response.statusCode}');
        print(response.body);
        return "Unable to delete Customer record";
      }
    } catch (error) {
      print(error);
      return "Unable to delete Customer record";
    }
  }

  Future<List<Customer>> fetchCustomerRecord() async {
    try {
      const String apiUrl = 'https://${baseUrl + getCustomerUrl}';
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };
      final response = await https.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        List<Customer> customers = [];

        for (var item in data) {
          if (item['user_type']['title'] != 'admin') {
            customers.add(Customer(
              item['id'],
              item['username'],
              item['phone_no'],
              item['email'],
              item['user_type']['title'],
            ));
          }
        }

        return customers;
      } else {
        print('Failed to load customers');
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<String> deleteAllCouponRecord() async {
    try {
      final uri =
          Uri.parse("https://server.safacab.com/admin/users/delete-all");

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
        print('Customer api hit  successfully');
        return "Customer all record deleted successfully";
      } else {
        print(response.body);
        print(
            'Failed to hit Customer delete all api  Status code: ${response.statusCode}');
        return "Unable to delete all Customer record";
      }
    } catch (error) {
      print(error);
      return "Unable to delete all Customer record";
    }
  }
}
