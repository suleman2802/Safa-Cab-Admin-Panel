import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Routes/navigation_methods.dart';
import 'package:provider/provider.dart';

import '../../../General Widgets/Responsive.dart';
import '../Model/Airport.dart';
import '../Provider/Airport_Provider.dart';
import "../Widgets/airport_booking_data_source.dart";
import './airport_dialogue.dart';

class AirportBookingTable extends StatefulWidget {
  @override
  _AirportBookingTableState createState() => _AirportBookingTableState();
}

class _AirportBookingTableState extends State<AirportBookingTable> {
  final TextEditingController _searchController = TextEditingController();
  AirportBookingDataSource? _AirportBookingDataSource;
  List<Airport>? list;
  List<Airport>? filteredAirport;

  deleteAirportRecord(int id) async {
    String result = await Provider.of<AirportProvider>(context, listen: false)
        .deleteAirportById(id);
    showSnackBar(result);
    navigateToAirport(context);
  }

  deleteAllAirportRecord() async {
    String result = await Provider.of<AirportProvider>(context, listen: false)
        .deleteAllAirport();
    showSnackBar(result);
    navigateToAirport(context);
  }

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  void _filterAirportFare() {
    setState(() {
      if (_searchController.text.isEmpty) {
        filteredAirport = list;
      } else {
        filteredAirport = list!.where((airport) {
          return airport.carName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              airport.carNumber
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              airport.pickup
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              airport.dropoff
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              airport.driverName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase());
        }).toList();
      }
      _AirportBookingDataSource = AirportBookingDataSource(
          filteredAirport!, context, deleteAirportRecord);
    });
  }

  @override
  void initState() {
    super.initState();
    // Set up a listener to perform search whenever the text changes
    // _searchController.addListener(() {
    //   _trainBookingDataSource!.search(_searchController.text);
    _searchController.addListener(_filterAirportFare);
  }

  Future<void> getTrainRecord() async {
    list = [];
    list = await Provider.of<AirportProvider>(context, listen: true)
        .fetchAirportRecord();
    _AirportBookingDataSource =
        AirportBookingDataSource(list!, context, deleteAirportRecord);
  }

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  bool _sortAscending = true;

  void _sort<T>(Comparable<T> Function(Airport d) getField, int columnIndex,
      bool ascending) {
    _AirportBookingDataSource!.sort(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed from the widget tree
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              constraints: const BoxConstraints(maxWidth: 500),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2)),
              labelText: 'Search',
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                },
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: FutureBuilder(
              future: list == null ? getTrainRecord() : null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return PaginatedDataTable(
                    //showEmptyRows: false,
                    headingRowColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                    horizontalMargin: !Responsive.isMobile(context) ? 45 : 20,
                    columnSpacing: !Responsive.isMobile(context) ? 85 : 20,
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AirportDialog(
                                  true, -1, "", -1, "", "", "", 0.0);
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Icon(Icons.add),
                      ),
                      ElevatedButton(
                        onPressed: deleteAllAirportRecord,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Delete All"),
                      ),
                    ],
                    header: const Text('Airport Station Fares List'),
                    rowsPerPage: _rowsPerPage,
                    onRowsPerPageChanged: (r) {
                      setState(() {
                        _rowsPerPage = r!;
                      });
                    },
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    columns: <DataColumn>[
                      // const DataColumn(
                      //   label: Text('Image'),
                      //   // onSort: (columnIndex, ascending) => _sort<String>(
                      //   //         (Airport d) => d.carName, columnIndex, ascending),
                      // ),
                      DataColumn(
                        label: const Text('Car Type'),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (Airport d) => d.carName, columnIndex, ascending),
                      ),
                      DataColumn(
                        label: const Text('Car Number'),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (Airport d) => d.carNumber, columnIndex, ascending),
                      ),
                      DataColumn(
                        label: const Text('Driver Name'),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (Airport d) => d.driverName,
                            columnIndex,
                            ascending),
                      ),
                      // DataColumn(
                      //   label: const Text('Driver Number'),
                      //   onSort: (columnIndex, ascending) => _sort<String>(
                      //       (Airport d) => d.driverNumber, columnIndex, ascending),
                      // ),
                      DataColumn(
                        label: const Text('Pick up'),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (Airport d) => d.pickup, columnIndex, ascending),
                      ),
                      DataColumn(
                        label: const Text('Drop off'),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (Airport d) => d.dropoff, columnIndex, ascending),
                      ),
                      DataColumn(
                        label: const Text('Fare'),
                        numeric: true,
                        onSort: (columnIndex, ascending) => _sort<num>(
                            (Airport d) => d.faire, columnIndex, ascending),
                      ),
                      const DataColumn(
                        label: Text('Edit'),
                      ),
                      const DataColumn(
                        label: Text('Delete'),
                      ),
                    ],
                    source: _AirportBookingDataSource!,
                  );
                }
              }),
        ),
      ],
    );
  }
//working
// final TextEditingController _searchController = TextEditingController();
// AirportBookingDataSource? _airportBookingDataSource;
// List<Airport>? list;
//
// deleteAirportRecord(int id) async {
//   bool result = await Provider.of<AirportProvider>(context, listen: false)
//       .deleteAirportById(id);
//   if (result) {
//     showSnackBar("Airport Fare record delete successfully");
//   } else {
//     showSnackBar("Unable to delete Airport Fare record Try again later!");
//   }
// }
//
// void showSnackBar(String content) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(content),
//     ),
//   );
// }
//
// @override
// void initState() {
//   super.initState();
//   // Set up a listener to perform search whenever the text changes
//   // _searchController.addListener(() {
//   //   _airportBookingDataSource!.search(_searchController.text);
//   // });
//   //getAirportRecord();
// }
//
// @override
// void dispose() {
//   // Dispose the controller when the widget is removed from the widget tree
//   _searchController.dispose();
//   super.dispose();
// }
//
// Future<void> getAirportRecord() async {
//   list = [];
//   // try {
//   list = await Provider.of<AirportProvider>(context).fetchAirportRecord();
//   print(list);
//   _airportBookingDataSource =
//       AirportBookingDataSource(list!, context, deleteAirportRecord);
//   // }catch(error){
//   //   print(error);
//   // }
// }
//
// int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
// int? _sortColumnIndex;
// bool _sortAscending = true;
//
// void _sort<T>(Comparable<T> Function(Airport d) getField, int columnIndex,
//     bool ascending) {
//   _airportBookingDataSource!.sort(getField, ascending);
//   setState(() {
//     _sortColumnIndex = columnIndex;
//     _sortAscending = ascending;
//   });
// }
//
// @override
// Widget build(BuildContext context) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: TextField(
//           controller: _searchController,
//           decoration: InputDecoration(
//             constraints: const BoxConstraints(maxWidth: 500),
//             enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                     color: Theme.of(context).primaryColor, width: 2)),
//             labelText: 'Search',
//             suffixIcon: IconButton(
//               icon: const Icon(Icons.clear),
//               onPressed: () {
//                 _searchController.clear();
//               },
//             ),
//           ),
//         ),
//       ),
//       SingleChildScrollView(
//         child: FutureBuilder(
//           future: getAirportRecord(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               return PaginatedDataTable(
//                 //showEmptyRows: false,
//                 headingRowColor: MaterialStateProperty.all<Color>(
//                     Theme.of(context).primaryColor),
//                 horizontalMargin: !Responsive.isMobile(context) ? 45 : 20,
//                 //columnSpacing: !Responsive.isMobile(context) ? 65 : 20,
//                 actions: [
//                   ElevatedButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AirportDialog(
//                               true, -1, "", "", -1, "", "", "", 0.0);
//                         },
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       foregroundColor: Colors.white,
//                     ),
//                     child: const Icon(Icons.add),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       foregroundColor: Colors.white,
//                     ),
//                     child: const Text("Delete All"),
//                   ),
//                 ],
//                 header: const Text('Airport Fares List'),
//                 rowsPerPage: _rowsPerPage,
//                 onRowsPerPageChanged: (r) {
//                   setState(() {
//                     _rowsPerPage = r!;
//                   });
//                 },
//                 sortColumnIndex: _sortColumnIndex,
//                 sortAscending: _sortAscending,
//                 columns: <DataColumn>[
//                   // DataColumn(
//                   //   label: const Text('Image'),
//                   //   // onSort: (columnIndex, ascending) => _sort<String>(
//                   //   //         (Airport d) => d.carName, columnIndex, ascending),
//                   // ),
//                   DataColumn(
//                     label: const Text('Car Type'),
//                     onSort: (columnIndex, ascending) => _sort<String>(
//                         (Airport d) => d.carName, columnIndex, ascending),
//                   ),
//                   DataColumn(
//                     label: const Text('Car Number'),
//                     onSort: (columnIndex, ascending) => _sort<String>(
//                         (Airport d) => d.carNumber, columnIndex, ascending),
//                   ),
//                   DataColumn(
//                     label: const Text('Driver Name'),
//                     onSort: (columnIndex, ascending) => _sort<String>(
//                         (Airport d) => d.driverName, columnIndex, ascending),
//                   ),
//                   // DataColumn(
//                   //   label: const Text('Driver Number'),
//                   //   onSort: (columnIndex, ascending) => _sort<String>(
//                   //       (Airport d) => d.driverNumber, columnIndex, ascending),
//                   // ),
//                   DataColumn(
//                     label: const Text('Pick up'),
//                     onSort: (columnIndex, ascending) => _sort<String>(
//                         (Airport d) => d.pickup, columnIndex, ascending),
//                   ),
//                   DataColumn(
//                     label: const Text('Drop off'),
//                     onSort: (columnIndex, ascending) => _sort<String>(
//                         (Airport d) => d.dropoff, columnIndex, ascending),
//                   ),
//                   DataColumn(
//                     label: const Text('Fare'),
//                     numeric: true,
//                     onSort: (columnIndex, ascending) => _sort<num>(
//                         (Airport d) => d.faire, columnIndex, ascending),
//                   ),
//                   const DataColumn(
//                     label: Text('Edit'),
//                   ),
//                   const DataColumn(
//                     label: Text('Delete'),
//                   ),
//                 ],
//                 source: _airportBookingDataSource!,
//               );
//             }
//           },
//         ),
//       ),
//     ],
//   );
// }
}

// import 'package:flutter/material.dart';
// import 'package:scrollable_table_view/scrollable_table_view.dart';
// var products = [
//   {
//     "product_id": "PR1000",
//     "product_name": "KFC Chicken",
//     "product_type": "consumable",
//     "product_category": "PC1002",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "yes",
//     "sales_price": "0",
//     "cost": "20",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "yes",
//   },
//   {
//     "product_id": "PR1001",
//     "product_name": "Italian Pizza",
//     "product_type": "consumable",
//     "product_category": "PC1002",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "60",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1002",
//     "product_name": "Bar Soap",
//     "product_type": "consumable",
//     "product_category": "PC1002",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "20",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1003",
//     "product_name": "Brookside Milk  1L",
//     "product_type": "consumable",
//     "product_category": "PC1002",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "120",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1004",
//     "product_name": "Butter 500g",
//     "product_type": "consumable",
//     "product_category": "PC1002",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "500",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1005",
//     "product_name": "Juice 1L",
//     "product_type": "consumable",
//     "product_category": "PC1002",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "120",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
// ];
//
// var many_products = [
//   {
//     "product_id": "PR1000",
//     "product_name": "KFC Chicken",
//     "product_type": "consumable",
//     "product_category": "PC1002",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "yes",
//     "sales_price": "0",
//     "cost": "20",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "yes",
//   },
//   {
//     "product_id": "PR1001",
//     "product_name": "Italian Pizza",
//     "product_type": "consumable",
//     "product_category": "PC1002",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "60",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1002",
//     "product_name": "Bar Soap",
//     "product_type": "consumable",
//     "product_category": "PC1002",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "20",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1003",
//     "product_name": "Brookside Milk  1L",
//     "product_type": "consumable",
//     "product_category": "PC1002",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "120",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1004",
//     "product_name": "Butter 500g",
//     "product_type": "consumable",
//     "product_category": "PC1002",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "500",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1005",
//     "product_name": "Juice 1L",
//     "product_type": "consumable",
//     "product_category": "PC1002",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "120",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1006",
//     "product_name": "Cake 1kg",
//     "product_type": "consumable",
//     "product_category": "PC1002",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "1200",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1007",
//     "product_name": "Tomato Sauce 700g",
//     "product_type": "consumable",
//     "product_category": "PC1006",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "300",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1008",
//     "product_name": "Cheese",
//     "product_type": "consumable",
//     "product_category": "PC1006",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "500",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1009",
//     "product_name": "Baking Flour",
//     "product_type": "consumable",
//     "product_category": "PC1006",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "200",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1010",
//     "product_name": "Toothpick",
//     "product_type": "consumable",
//     "product_category": "PC1008",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "50",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1011",
//     "product_name": "Bag",
//     "product_type": "consumable",
//     "product_category": "PC1009",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "250",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1012",
//     "product_name": "Eggs",
//     "product_type": "consumable",
//     "product_category": "PC1004",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "450",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1013",
//     "product_name": "Butter",
//     "product_type": "consumable",
//     "product_category": "PC1003",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "500",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1014",
//     "product_name": "Yeast",
//     "product_type": "consumable",
//     "product_category": "PC1003",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "70",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1015",
//     "product_name": "Rice",
//     "product_type": "consumable",
//     "product_category": "PC1007",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "700",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1016",
//     "product_name": "Plates",
//     "product_type": "consumable",
//     "product_category": "PC1010",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "300",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1017",
//     "product_name": "TV",
//     "product_type": "consumable",
//     "product_category": "PC1010",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "20,000",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1018",
//     "product_name": "Radio",
//     "product_type": "consumable",
//     "product_category": "PC1011",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "2,000",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1019",
//     "product_name": "Table",
//     "product_type": "consumable",
//     "product_category": "PC1012",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "3,500",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1020",
//     "product_name": "Chair",
//     "product_type": "consumable",
//     "product_category": "PC1012",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "2,500",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
//   {
//     "product_id": "PR1021",
//     "product_name": "Fan",
//     "product_type": "consumable",
//     "product_category": "PC1012",
//     "upc": null,
//     "sku": null,
//     "income_account": null,
//     "expense_account": null,
//     "available_in_pos": "no",
//     "sales_price": "2,200",
//     "cost": "0",
//     "weight": "0",
//     "volume": "0",
//     "vendor_lead_time": "0",
//     "customer_lead_time": "0",
//     "quantity_on_hand": "0",
//     "archived": "no",
//   },
// ];
// //
// // import 'package:flutter/material.dart';
// // import 'package:scrollable_table_view/scrollable_table_view.dart';
// //
// // import 'model.dart';
//
// class BookingTable extends StatefulWidget {
//   @override
//   State<BookingTable> createState() => _BookingTableState();
// }
//
// class _BookingTableState extends State<BookingTable> with TickerProviderStateMixin {
//   final PaginationController _paginationController = PaginationController(
//     rowCount: many_products.length,
//     rowsPerPage: 10, );
//   var tabController;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     tabController = TabController(length: many_products.length, initialIndex: 0,
//         vsync: this);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var columns = products.first.keys.toList();
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.8,
//       color: Colors.red,
//       child: TabBarView(controller: tabController,
//         children: [
//           // simple
//           ScrollableTableView(
//             headers: columns.map((column) {
//               return TableViewHeader(
//                 label: column,
//               );
//             }).toList(),
//             rows: products.map((product) {
//               return TableViewRow(
//                 height: 60,
//                 cells: columns.map((column) {
//                   return TableViewCell(
//                     child: Text(product[column] ?? ""),
//                   );
//                 }).toList(),
//               );
//             }).toList(),
//           ),
//           // paginated
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 25),
//                 child: ValueListenableBuilder(
//                     valueListenable: _paginationController,
//                     builder: (context, value, child) {
//                       return Row(
//                         children: [
//                           Text(
//                               "${_paginationController.currentPage}  of ${_paginationController.pageCount}"),
//                           Row(
//                             children: [
//                               IconButton(
//                                 onPressed: _paginationController.currentPage <= 1
//                                     ? null
//                                     : () {
//                                         _paginationController.previous();
//                                       },
//                                 iconSize: 20,
//                                 splashRadius: 20,
//                                 icon: Icon(
//                                   Icons.arrow_back_ios_new_rounded,
//                                   color: _paginationController.currentPage <= 1
//                                       ? Colors.black26
//                                       : Theme.of(context).primaryColor,
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: _paginationController.currentPage >=
//                                         _paginationController.pageCount
//                                     ? null
//                                     : () {
//                                         _paginationController.next();
//                                       },
//                                 iconSize: 20,
//                                 splashRadius: 20,
//                                 icon: Icon(
//                                   Icons.arrow_forward_ios_rounded,
//                                   color: _paginationController.currentPage >=
//                                           _paginationController.pageCount
//                                       ? Colors.black26
//                                       : Theme.of(context).primaryColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       );
//                     }),
//               ),
//               Expanded(
//                 child: ScrollableTableView(
//                   paginationController: _paginationController,
//                   headers: columns.map((column) {
//                     return TableViewHeader(
//                       label: column,
//                     );
//                   }).toList(),
//                   rows: many_products.map((product) {
//                     return TableViewRow(
//                       height: 60,
//                       cells: columns.map((column) {
//                         return TableViewCell(
//                           child: Text(product[column] ?? ""),
//                         );
//                       }).toList(),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
//
// /// The home page of the application which hosts the datagrid.
// class BookingTable extends StatefulWidget {
//   /// Creates the home page.
//   BookingTable({Key? key}) : super(key: key);
//
//   @override
//   _BookingTableState createState() => _BookingTableState();
// }
//
// class _BookingTableState extends State<BookingTable> {
//   List<Employee> employees = <Employee>[];
//   late EmployeeDataSource employeeDataSource;
//
//   @override
//   void initState() {
//     super.initState();
//     employees = getEmployeeData();
//     employeeDataSource = EmployeeDataSource(employeeData: employees);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SfDataGrid(
//       allowSorting: true,
//       allowFiltering: true,
//       allowPullToRefresh: true,
//       allowColumnsResizing: true,
//       headerGridLinesVisibility: GridLinesVisibility.both,
//       gridLinesVisibility: GridLinesVisibility.horizontal,
//       source: employeeDataSource,
//       columnWidthMode: ColumnWidthMode.fill,
//       columns: <GridColumn>[
//         GridColumn(
//           columnName: 'id',
//           label: Container(
//             color: Theme.of(context).primaryColor,
//             padding: EdgeInsets.all(16.0),
//             alignment: Alignment.center,
//             child: Text(
//               'ID',
//               style: TextStyle(
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//         GridColumn(
//           columnName: 'name',
//           label: Container(
//             color: Theme.of(context).primaryColor,
//             padding: EdgeInsets.all(8.0),
//             alignment: Alignment.center,
//             child: Text(
//               'Name',
//               style: TextStyle(
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//         GridColumn(
//           columnName: 'designation',
//           label: Container(
//             color: Theme.of(context).primaryColor,
//             padding: EdgeInsets.all(8.0),
//             alignment: Alignment.center,
//             child: Text(
//               'Designation',
//               style: TextStyle(
//                 color: Colors.black,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ),
//         GridColumn(
//           columnName: 'salary',
//           label: Container(
//             color: Theme.of(context).primaryColor,
//             padding: EdgeInsets.all(8.0),
//             alignment: Alignment.center,
//             child: Text(
//               'Salary',
//               style: TextStyle(
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   List<Employee> getEmployeeData() {
//     return [
//       Employee(10001, 'James', 'Project Lead', 20000),
//       Employee(10002, 'Kathryn', 'Manager', 30000),
//       Employee(10003, 'Lara', 'Developer', 15000),
//       Employee(10004, 'Michael', 'Designer', 15000),
//       Employee(10005, 'Martin', 'Developer', 15000),
//       Employee(10006, 'Newberry', 'Developer', 15000),
//       Employee(10007, 'Balnc', 'Developer', 15000),
//       Employee(10008, 'Perry', 'Developer', 15000),
//       Employee(10009, 'Gable', 'Developer', 15000),
//       Employee(10010, 'Grimes', 'Developer', 15000)
//     ];
//   }
// }
//
// /// Custom business object class which contains properties to hold the detailed
// /// information about the employee which will be rendered in datagrid.
// class Employee {
//   /// Creates the employee class with required details.
//   Employee(this.id, this.name, this.designation, this.salary);
//
//   /// Id of an employee.
//   final int id;
//
//   /// Name of an employee.
//   final String name;
//
//   /// Designation of an employee.
//   final String designation;
//
//   /// Salary of an employee.
//   final int salary;
// }
//
// /// An object to set the employee collection data source to the datagrid. This
// /// is used to map the employee data to the datagrid widget.
// class EmployeeDataSource extends DataGridSource {
//   /// Creates the employee data source class with required details.
//   EmployeeDataSource({required List<Employee> employeeData}) {
//     _employeeData = employeeData
//         .map<DataGridRow>((e) => DataGridRow(cells: [
//               DataGridCell<int>(columnName: 'id', value: e.id),
//               DataGridCell<String>(columnName: 'name', value: e.name),
//               DataGridCell<String>(
//                   columnName: 'designation', value: e.designation),
//               DataGridCell<int>(columnName: 'salary', value: e.salary),
//             ],),)
//         .toList();
//   }
//
//   List<DataGridRow> _employeeData = [];
//
//   @override
//   List<DataGridRow> get rows => _employeeData;
//
//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((e) {
//       return Container(
//         color: Colors.white,
//         alignment: Alignment.center,
//         padding: EdgeInsets.all(8.0),
//         child: Text(
//           e.value.toString(),
//           style: TextStyle(color: Colors.black),
//         ),
//       );
//     }).toList());
//   }
// }
