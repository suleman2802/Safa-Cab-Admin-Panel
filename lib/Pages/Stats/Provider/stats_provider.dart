import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import '../../../Utilis/config.dart';
import '../Model/Stats.dart';

class StatsProvider extends ChangeNotifier {
  Future<List<Stats>> fetchReviewRecord() async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      };
      final response = await https.get(
          Uri.parse('https://server.safacab.com/admin/reports/bookings'),
          headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'][DateTime.now().year.toString()];
        List<Stats> tempList = [];
        int idCounter = 1;
        String currentYear = DateTime.now().year.toString();

        data.forEach((month, details) {
          Stats stats = Stats(
            idCounter,
            month,
            currentYear,
            details['total_bookings'],
            details['total_ziyarats'],
            details['total_packages'],
            details['total_revenue'].toDouble(),
          );
          tempList.add(stats);
          idCounter++;
        });

        return tempList;
      } else {
        print('Failed to load stats ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print(error.toString());
      return [];
    }
  }
}
