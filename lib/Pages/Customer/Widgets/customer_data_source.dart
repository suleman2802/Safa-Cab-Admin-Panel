import 'package:flutter/material.dart';
import '../Model/customer.dart';
import './customer_dialogue.dart';

// Create a Data Source class by extending DataTableSource
class CustomerDataSource extends DataTableSource {
  List<Customer> _customers;
  int _selectedCount = 0;
  BuildContext context;
  var deleteCustomerById;

  CustomerDataSource(this._customers, this.context,this.deleteCustomerById);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _customers.length) return null;
    final Customer customer = _customers[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        // DataCell(FittedBox(
        //   child: CircleAvatar(
        //     backgroundColor: Colors.yellow,
        //     backgroundImage: NetworkImage(customer.imageUrl),
        //     radius: 20,
        //   ),
        // )),
        DataCell(Text(customer.name)),
        DataCell(Text(customer.phoneNumber)),
        DataCell(Text(customer.email)),
        DataCell(Text(customer.type)),
        // DataCell(
        //   IconButton(
        //       icon: const Icon(
        //         Icons.edit,
        //         color: Colors.green,
        //       ),
        //       onPressed: () {
        //         showDialog(
        //           context: context,
        //           builder: (BuildContext context) {
        //             return CustomerDialog(
        //                 customer.id,
        //                 customer.name,
        //                 customer.phoneNumber,
        //                 customer.email,
        //                 customer.type);
        //           },
        //         );
        //       }),
        // ),
        DataCell(
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              deleteCustomerById(customer.id);
            },
          ),
        ),
      ],
    );
  }

  void search(String searchText) {
    if (searchText.isEmpty) {
      // If the search text is empty, do not filter the customers
      _customers = List.from(_customers);
    } else {
      // Filter the customers based on the search text
      _customers = _customers
          .where((customer) =>
              customer.name.toLowerCase().contains(searchText.toLowerCase()) ||
              customer.phoneNumber
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              customer.email.toLowerCase().contains(searchText.toLowerCase()) ||
              customer.type.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  @override
  int get rowCount => _customers.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void sort<T>(Comparable<T> Function(Customer c) getField, bool ascending) {
    _customers.sort((Customer a, Customer b) {
      if (!ascending) {
        final Customer c = a;
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
