import 'package:flutter/material.dart';
import '../Model/car.dart';
import 'car_dialogue.dart';

// Create a Data Source class by extending DataTableSource
class CarDataSource extends DataTableSource {
  List<Car> _cars;
  BuildContext context;
  var deleteCarById;
  int _selectedCount = 0;

  CarDataSource(this._cars, this.context, this.deleteCarById);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _cars.length) return null;
    final Car car = _cars[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        // DataCell(
        //   FittedBox(
        //       child: Image.network(
        //     car.carImageUrl,
        //     width: 90,
        //   )),
        // ),
        DataCell(Text(car.carName)),
        DataCell(Text(car.carNumber)),
        DataCell(Text(car.driverName)),
        //DataCell(Text(car.driverNumber)),
        DataCell(Text('${car.carModel}')),
        DataCell(Text('${car.totalQyt}')),
        DataCell(Text('${car.noOfSeats}')),
        DataCell(Text('${car.noOfLuggage}')),
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
                  return CarDialog(
                      false,
                      car.carId,
                      car.carImageUrl,
                      car.carName,
                      car.carNumber,
                      car.carModel.toString(),
                      car.driverName,
                      //car.driverNumber,
                      car.noOfSeats.toString(),
                      car.noOfLuggage.toString(),
                      car.totalQyt);
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
              deleteCarById(car.carId);
            },
          ),
        ),
      ],
    );
  }

  void search(String searchText) {
    if (searchText.isEmpty) {
      // If the search text is empty, do not filter the customers
      _cars = List.from(_cars);
    } else {
      // Filter the customers based on the search text
      _cars = _cars
          .where((car) =>
                  car.carName.toLowerCase().contains(searchText.toLowerCase())
              //    || car.carNumber.toLowerCase().contains(searchText.toLowerCase())
              )
          .toList();
    }
    notifyListeners();
  }

  @override
  int get rowCount => _cars.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void sort<T>(Comparable<T> Function(Car c) getField, bool ascending) {
    _cars.sort((Car a, Car b) {
      if (!ascending) {
        final Car c = a;
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
