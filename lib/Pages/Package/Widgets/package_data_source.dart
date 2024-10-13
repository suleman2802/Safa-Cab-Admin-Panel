import 'package:flutter/material.dart';
import '../Model/package.dart';
import './package_dialogue.dart';

// Create a Data Source class by extending DataTableSource
class PackageDataSource extends DataTableSource {
  List<Package> _packages;
  BuildContext context;
  int _selectedCount = 0;
  var deletePackageById;

  PackageDataSource(this._packages, this.context,this.deletePackageById);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _packages.length) return null;
    final Package package = _packages[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        // DataCell(
        //   FittedBox(
        //       child: Image.network(
        //     package.carImageUrl,
        //     width: 90,
        //   )),
        // ),
        DataCell(Text(package.packageName)),
        DataCell(Text(package.carName)),
        DataCell(Text(package.carNumber)),
        DataCell(Text(package.driverName)),
        //DataCell(Text(package.driverNumber)),
        DataCell(Text('${package.noOfSeats}')),
        DataCell(Text('${package.price}')),
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
                  return PackageDialog(
                      false,
                      package.id,
                      package.packageName,
                      package.carId,
                     // package.carImageUrl,
                      package.carName,
                      package.carNumber,
                      package.driverName,
                      //package.driverNumber,
                      package.noOfLuaggage,
                      package.noOfSeats,
                      package.price,
                      package.points);
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
              deletePackageById(package.id);
            },
          ),
        ),
      ],
    );
  }

  void search(String searchText) {
    if (searchText.isEmpty) {
      // If the search text is empty, do not filter the customers
      _packages = List.from(_packages);
    } else {
      // Filter the customers based on the search text
      _packages = _packages
          .where((car) =>
              car.carName.toLowerCase().contains(searchText.toLowerCase())
              //    || car.carNumber.toLowerCase().contains(searchText.toLowerCase())
      )
          .toList();
    }
    notifyListeners();
  }

  @override
  int get rowCount => _packages.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void sort<T>(Comparable<T> Function(Package c) getField, bool ascending) {
    _packages.sort((Package a, Package b) {
      if (!ascending) {
        final Package c = a;
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
