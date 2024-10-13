import 'package:flutter/material.dart';
import '../Model/Train.dart';
import '../Widgets/train_dialogue.dart';

// Create a Data Source class by extending DataTableSource
class TrainBookingDataSource extends DataTableSource {
  List<Train> _bookings;
  int _selectedCount = 0;
  BuildContext context;
  var deleteTrainById;

  TrainBookingDataSource(this._bookings,this.context,this.deleteTrainById);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _bookings.length) return null;
    final Train booking = _bookings[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        // DataCell(
        //   FittedBox(
        //       child: Image.network(
        //         booking.carImageUrl,
        //         width: 90,
        //       )),
        // ),
        DataCell(Text(booking.carName)),
        DataCell(Text(booking.carNumber)),
        DataCell(Text(booking.driverName)),
        //  DataCell(Text(booking.driverNumber)),
        DataCell(Text(booking.pickup)),
        DataCell(Text(booking.dropoff)),
        DataCell(Text(booking.faire.toString())),
        DataCell(
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.green,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return TrainDialog(
                    false,
                    booking.id,
                    //booking.imageUrl,
                    booking.carName,
                    booking.carId,
                    booking.carNumber,
                    // booking.driverName,
                    //  booking.driverNumber,
                    //   booking.carNoOfSeats.toString(),
                    //   booking.carNoOfLuaggage.toString(),
                    booking.pickup,
                    booking.dropoff,
                    booking.faire,
                  );
                },
              );
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              deleteTrainById(booking.id);
            },
          ),
        ),
      ],
    );
  }

  void search(String searchText) {
    if (searchText.isEmpty) {
      // If the search text is empty, do not filter the customers
      _bookings = List.from(_bookings);
    } else {
      // Filter the customers based on the search text
      _bookings = _bookings
          .where((booking) =>
              booking.carName
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              booking.pickup.toLowerCase().contains(searchText.toLowerCase()) ||
              booking.driverName
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
          // booking.driverNumber
          // .toLowerCase()
          // .contains(searchText.toLowerCase()) ||
          // booking.carNumber
          // .toLowerCase()
          // .contains(searchText.toLowerCase()) ||
          booking.pickup
          .toLowerCase()
          .contains(searchText.toLowerCase()) ||
              booking.dropoff.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  @override
  int get rowCount => _bookings.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void sort<T>(Comparable<T> Function(Train c) getField, bool ascending) {
    _bookings.sort((Train a, Train b) {
      if (!ascending) {
        final Train c = a;
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
