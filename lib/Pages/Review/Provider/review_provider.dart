import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import '../../../Utilis/config.dart';
import '../../Customer/Model/customer.dart';
import '../Model/review.dart';

class ReviewProvider extends ChangeNotifier {
  Future<String> deleteReviewById(int id) async {
    try {
      final uri = Uri.parse(
          'https://server.safacab.com/reviews/delete-review?reviewId=${id}');

      // Configure the request headers with authentication
      final headers = {
        //'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await https.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        print('Review record deleted successfully');
        return "Review deleted successfully";
      } else {
        print(
            'Failed to delete the Review. Status code: ${response.statusCode}');
        return "Unable to delete Review record, Try again later";
      }
    } catch (error) {
      print(error);
      return "Unable to delete Review record, Try again later";
    }
  }

  Future<List<Review>> fetchReviewRecord() async {
    try {
      const String apiUrl = 'https://${baseUrl + getReviewUrl}';
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };
      final response = await https.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        List<Review> reviewList = [];
        List<dynamic> faresJson = jsonDecode(response.body)['data'];

        for (var fareData in faresJson) {
          String customerName = await getCustomerById(fareData['user_id']);
          if (customerName.isNotEmpty) {
            Review fare = Review(
              fareData["id"],
              fareData['booking_type'],
              customerName,
              fareData['review'],
            );
            reviewList.add(fare);
          }
        }
        return reviewList;
      } else {
        print(
            'Failed to load review record, Status code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<String> deleteAllReviewRecord() async {
    try {
      final uri = Uri.parse("https://server.safacab.com/reviews/delete-all");

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
        print('Review api hit  successfully');
        return "All review record deleted successfully";
      } else {
        print(response.body);
        print(
            'Failed to hit Review delete all api  Status code: ${response.statusCode}');
        return "Unable to delete all Review Fare record";
      }
    } catch (error) {
      print(error);
      return "Unable to delete all Review Fare record";
    }
  }

  Future<String> getCustomerById(int id) async {
    final uri =
        Uri.parse("https://server.safacab.com/admin/users/user?userId=${id}");
    final headers = {
      //'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    final response = await https.get(
      uri, headers: headers, // body: body
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body)['data'];
      return jsonResponse["username"];
    } else {
      print(
          'Failed to load customer with ID $id, Status code: ${response.statusCode}');
      return "";
    }
  }
}
