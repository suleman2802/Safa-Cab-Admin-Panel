import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Routes/navigation_methods.dart';
import 'package:provider/provider.dart';
import '../../../General Widgets/Responsive.dart';
import '../Model/review.dart';
import '../Provider/review_provider.dart';
import "../Widgets/review_data_source.dart";

class ReviewTable extends StatefulWidget {
  @override
  _CustomerTableState createState() => _CustomerTableState();
}

class _CustomerTableState extends State<ReviewTable> {
  TextEditingController _searchController = TextEditingController();
  List<Review>? list;
  List<Review>? filteredList;
  ReviewDataSource? _reviewsDataSource;

  void _filterReview() {
    setState(() {
      if (_searchController.text.isEmpty) {
        filteredList = list;
      } else {
        filteredList = list!.where((review) {
          return review.name
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              review.review
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              review.bookingType
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase());
        }).toList();
      }
      _reviewsDataSource =
          ReviewDataSource(filteredList!, context, deleteReviewRecord);
    });
  }

  @override
  void initState() {
    super.initState();
    // Set up a listener to perform search whenever the text changes
    // _searchController.addListener(() {
    //   _reviewsDataSource!.search(_searchController.text);
    // });
  }

  deleteReviewRecord(int id) async {
    String result = await Provider.of<ReviewProvider>(context, listen: false)
        .deleteReviewById(id);

    showSnackBar(result);

    navigateToReview(context);
  }

  deleteAllReviewRecord() async {
    String result = await Provider.of<ReviewProvider>(context, listen: false)
        .deleteAllReviewRecord();

    showSnackBar(result);

    navigateToReview(context);
  }

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed from the widget tree
    _searchController.dispose();
    super.dispose();
  }

  Future<void> getReviewRecord() async {
    list = [];
    list = await Provider.of<ReviewProvider>(context).fetchReviewRecord();
    _reviewsDataSource = ReviewDataSource(list!, context, deleteReviewRecord);
  }

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  bool _sortAscending = true;

  void _sort<T>(Comparable<T> Function(Review d) getField, int columnIndex,
      bool ascending) {
    _reviewsDataSource!.sort(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
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
              constraints: BoxConstraints(maxWidth: 500),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2)),
              labelText: 'Search',
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                },
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: FutureBuilder(
              future: list == null ? getReviewRecord() : null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return SizedBox(
                    width: !Responsive.isMobile(context)
                        ? MediaQuery.of(context).size.width * 0.6
                        : MediaQuery.of(context).size.width * 0.93,
                    child: PaginatedDataTable(
                      headingRowColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                      columnSpacing: !Responsive.isMobile(context) ? 105 : 20,
                      actions: [
                        ElevatedButton(
                          onPressed: deleteAllReviewRecord,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("Delete All"),
                        ),
                      ],
                      header: Text('Review Record'),
                      rowsPerPage: _rowsPerPage,
                      onRowsPerPageChanged: (r) {
                        setState(() {
                          _rowsPerPage = r!;
                        });
                      },
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAscending,
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text('Booking Type'),
                          onSort: (columnIndex, ascending) => _sort<String>(
                              (Review d) => d.bookingType,
                              columnIndex,
                              ascending),
                        ),
                        DataColumn(
                          label: Text('Customer Name'),
                          onSort: (columnIndex, ascending) => _sort<String>(
                              (Review d) => d.name, columnIndex, ascending),
                        ),
                        DataColumn(
                          label: const Text('Review'),
                          onSort: (columnIndex, ascending) => _sort<String>(
                              (Review d) => d.review, columnIndex, ascending),
                        ),
                        const DataColumn(
                          label: Text('Delete'),
                        ),
                      ],
                      source: _reviewsDataSource!,
                    ),
                  );
                }
              }),
        ),
      ],
    );
  }
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
