import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/Stats.dart';


// Create a Data Source class by extending DataTableSource
class StatsDataSource extends DataTableSource {
  List<Stats> _stats;
  int _selectedCount = 0;
  //var deleteStatsById;

  StatsDataSource(this._stats,);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _stats.length) return null;
    final Stats stats = _stats[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(stats.year)),
        DataCell(Text(stats.month)),
        DataCell(Text(stats.noOfBookings.toString())),
        DataCell(Text(stats.noOfZiyarats.toString())),
        DataCell(Text(stats.noOfPackages.toString())),
        DataCell(Text(stats.revenue.toString())),
        // DataCell(
        //   IconButton(
        //     icon: Icon(
        //       Icons.delete,
        //       color: Colors.red,
        //     ),
        //     onPressed: () {
        //       deleteStatsById(stats.id);
        //     },
        //   ),
        // ),
      ],
    );
  }

  void search(String searchText) {
    if (searchText.isEmpty) {
      // If the search text is empty, do not filter the customers
      _stats = List.from(_stats);
    } else {
      // Filter the customers based on the search text
      _stats = _stats
          .where((stats) =>
      stats.year.toLowerCase().contains(searchText.toLowerCase()) ||
          stats.month
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
          stats.noOfBookings.toString().toLowerCase().contains(searchText.toLowerCase()) ||
          stats.noOfZiyarats.toString().toLowerCase().contains(searchText.toLowerCase()) ||
          stats.noOfPackages.toString().toLowerCase().contains(searchText.toLowerCase()) ||
          stats.revenue.toString().toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  @override
  int get rowCount => _stats.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void sort<T>(Comparable<T> Function(Stats c) getField, bool ascending) {
    _stats.sort((Stats a, Stats b) {
      if (!ascending) {
        final Stats c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }
}
