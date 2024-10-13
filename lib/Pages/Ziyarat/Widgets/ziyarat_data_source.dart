import 'package:flutter/material.dart';
import '../Model/ziyarat.dart';
import './ziyarat_dialogue.dart';

// Create a Data Source class by extending DataTableSource
class ZiyaratDataSource extends DataTableSource {
  List<Ziyarat> _ziyarat;
  BuildContext context;
  int _selectedCount = 0;
  var deleteZiyaratById;

  ZiyaratDataSource(this._ziyarat, this.context,this.deleteZiyaratById);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _ziyarat.length) return null;
    final Ziyarat ziyarat = _ziyarat[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        // DataCell(
        //   FittedBox(
        //       child: Image.network(
        //     Ziyarat.carImageUrl,
        //     width: 90,
        //   )),
        // ),
        DataCell(Text(ziyarat.ziyaratName)),
        DataCell(Text(ziyarat.carName)),
        DataCell(Text(ziyarat.carNumber)),
        DataCell(Text(ziyarat.driverName)),
        //DataCell(Text(Ziyarat.driverNumber)),
        DataCell(Text('${ziyarat.noOfSeats}')),
        DataCell(Text('${ziyarat.price}')),
        DataCell(
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.green,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ZiyaratDialog(
                      false,
                      ziyarat.id,
                      ziyarat.ziyaratName,
                      ziyarat.carId,
                      ziyarat.imageUrl,
                      ziyarat.carName,
                      ziyarat.carNumber,
                      ziyarat.driverName,
                      //Ziyarat.driverNumber,
                      // ziyarat.noOfLuaggage,
                      // ziyarat.noOfSeats,
                      ziyarat.price,
                      ziyarat.points);
                },
              );
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              deleteZiyaratById(ziyarat.id);
            },
          ),
        ),
      ],
    );
  }

  void search(String searchText) {
    if (searchText.isEmpty) {
      // If the search text is empty, do not filter the customers
      _ziyarat = List.from(_ziyarat);
    } else {
      // Filter the customers based on the search text
      // _ziyarat = _ziyarat
      //  .where((car) =>
      // car.carName.toLowerCase().contains(searchText.toLowerCase())
      //    || car.carNumber.toLowerCase().contains(searchText.toLowerCase())
      //   )
      //  .toList();
    }
    notifyListeners();
  }

  @override
  int get rowCount => _ziyarat.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void sort<T>(Comparable<T> Function(Ziyarat c) getField, bool ascending) {
    _ziyarat.sort((Ziyarat a, Ziyarat b) {
      if (!ascending) {
        final Ziyarat c = a;
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
