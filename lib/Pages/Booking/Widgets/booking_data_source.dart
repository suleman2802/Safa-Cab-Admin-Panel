import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Pages/Booking/Widgets/booking_dialogue.dart';
import '../Model/Booking.dart';

// Create a Data Source class by extending DataTableSource
class BookingDataSource extends DataTableSource {
  List<Booking> _bookings;
  BuildContext context;
  int _selectedCount = 0;
  var deleteBookingById;

  BookingDataSource(this._bookings, this.context, this.deleteBookingById);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _bookings.length) return null;
    final Booking booking = _bookings[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(booking.bookingId)),
        DataCell(Text(booking.bookingType)),
        DataCell(Text(booking.customerName)),
        DataCell(Text(booking.driverName)),
        DataCell(Text(booking.dateTime)),
        DataCell(
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor:
                  booking.status == "confirmed" || booking.status == "complete" || booking.status == "on route"
                      ? Colors.purpleAccent
                      : Colors.red,
              foregroundColor: //Text(booking.status),
                  //booking.status == "confirmed"
                  //  ? Colors.purpleAccent
                  //:
                  Colors.white,
            ),
            child: Text(
              booking.status,
            ),
            onPressed: () {},
          ),
        ),
        DataCell(Text(booking.discount.toString())),
        DataCell(Text(booking.price.toString())),
        DataCell(
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.green,
            ),
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BookingDialog(
                      false,
                      booking.id,
                      booking.bookingId,
                      booking.bookingType,
                      booking.customerName,
                      booking.driverName,
                      booking.carType,
                      booking.carId,
                      booking.carNumber,
                      booking.pickup,
                      booking.dropoff,
                      booking.dateTime,
                      booking.status,
                      booking.discount,
                      booking.price);
                }),
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              deleteBookingById(booking.id);
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
              booking.customerName
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              booking.pickup.toLowerCase().contains(searchText.toLowerCase()) ||
              booking.bookingId
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              booking.dropoff
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              booking.dateTime.toLowerCase().contains(searchText.toLowerCase()))
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

  void sort<T>(Comparable<T> Function(Booking c) getField, bool ascending) {
    _bookings.sort((Booking a, Booking b) {
      if (!ascending) {
        final Booking c = a;
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
