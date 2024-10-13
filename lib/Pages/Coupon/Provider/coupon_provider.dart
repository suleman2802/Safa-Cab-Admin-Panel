import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Utilis/config.dart';
import 'package:http/http.dart' as https;
import '../Model/coupon.dart';

class CouponProvider extends ChangeNotifier {
  List<Coupon> _coupons = [];

  List<Coupon> get couponsList => _coupons;

  Future<String> addCouponItem(Coupon coupon) async {
    try {
      final uri = Uri.parse("https://${baseUrl + addCouponUrl}");

      // Configure the request headers with authentication
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
      final body = jsonEncode({
        'code': coupon.couponCode,
        'valid_from': coupon.validFrom,
        'valid_to': coupon.validTo,
        'discount': coupon.couponDiscountAmount,
        'status': coupon.status,
      });

      final response = await https.post(uri, headers: headers, body: body);
      print(response.body);
      if (response.statusCode == 200) {
        print('Coupon api hit  successfully');
        return "Coupon record added successfully";
      } else {
        print(response.body);
        print('Failed to hit coupon api  Status code: ${response.statusCode}');
        print(response.body);
        return "Unable to add coupon record";
      }
    } catch (error) {
      print(error);
      return "Unable to add coupon record";
    }
  }

  Future<String> updateCoupon(Coupon coupon, int id) async {
    try {
      final uri = Uri.parse(
          "https://server.safacab.com/admin/coupons/update?couponId=$id");

      // Configure the request headers with authentication
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
      final body = jsonEncode({
        'code': coupon.couponCode,
        'valid_from': coupon.validFrom,
        'valid_to': coupon.validTo,
        'discount': coupon.couponDiscountAmount,
        'status': coupon.status,
      });

      final response = await https.put(uri, headers: headers, body: body);
      print(response.body);
      if (response.statusCode == 200) {
        print('Coupon api hit  successfully');
        return "Coupon record updated successfully";
      } else {
        print(response.body);
        print('Failed to hit coupon api  Status code: ${response.statusCode}');
        print(response.body);
        return "Unable to update coupon record";
      }
    } catch (error) {
      print(error);
      return "Unable to update coupon record";
    }
  }

  Future<String> deleteCoupon(int id) async {
    try {
      final uri = Uri.parse(
          "https://server.safacab.com/admin/coupons/delete?couponId=$id");

      // Configure the request headers with authentication
      final headers = {
        //  'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
      final body = jsonEncode({
        'couponId': id,
      });

      final response = await https.delete(
        uri, headers: headers, // body: body
      );
      print(response.body);
      if (response.statusCode == 200) {
        print('Coupon api hit  successfully');
        return "Coupon record deleted successfully";
      } else {
        print(response.body);
        print('Failed to hit coupon api  Status code: ${response.statusCode}');
        print(response.body);
        return "Unable to delete coupon record";
      }
    } catch (error) {
      print(error);
      return "Unable to delete coupon record";
    }
  }

  Future<List<Coupon>> fetchCouponRecord() async {
    try {
      const String apiUrl = 'https://${baseUrl + getCouponUrl}';
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };
      final response = await https.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        print("car api hit successfully");

        List<dynamic> carsJson = jsonDecode(response.body)['data'];

        List<Coupon> list =
            carsJson.map((json) => Coupon.fromJson(json)).toList();
        print(list);
        return list;
      } else {
        print(response.body);
        print("Failed to load Coupons");
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
          Uri.parse("https://server.safacab.com/admin/coupons/delete-all");

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
        print('Coupon api hit  successfully');
        return "All coupon record deleted successfully";
      } else {
        print(response.body);
        print(
            'Failed to hit coupon delete all api  Status code: ${response.statusCode}');
        print(response.body);
        return "Unable to delete all coupon record";
      }
    } catch (error) {
      print(error);
      return "Unable to delete all coupon record";
    }
  }
}
