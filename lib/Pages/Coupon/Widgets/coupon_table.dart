import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Routes/navigation_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../General Widgets/Responsive.dart';
import '../Model/coupon.dart';
import '../Provider/coupon_provider.dart';
import "../Widgets/coupon_data_source.dart";
import './coupon_dialogue.dart';

class CouponTable extends StatefulWidget {
  @override
  _CouponTableState createState() => _CouponTableState();
}

class _CouponTableState extends State<CouponTable> {
  final TextEditingController _searchController = TextEditingController();
  CouponDataSource? _couponsDataSource;
  DateTime? _pickFromDate;
  DateTime? _pickToDate;

  List<Coupon>? couponRecord;
  List<Coupon>? filteredCouponRecord;

  void _filterCoupon() {
    setState(() {
      if (_searchController.text.isEmpty) {
        filteredCouponRecord = couponRecord;
      } else {
        filteredCouponRecord = couponRecord!.where((coupon) {
          return coupon.couponCode
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              coupon.status
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              coupon.validFrom
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              coupon.validTo
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase());
        }).toList();
      }
      _couponsDataSource =
          CouponDataSource(filteredCouponRecord!, context, deleteCouponRecord);
    });
  }

  Future<void> getCouponRecord() async {
    couponRecord = [];
    couponRecord =
        await Provider.of<CouponProvider>(context).fetchCouponRecord();

    _couponsDataSource = CouponDataSource(
      couponRecord!,
      context,
      deleteCouponRecord,
    );
  }

  deleteCouponRecord(int id) async {
    String result = await Provider.of<CouponProvider>(context, listen: false)
        .deleteCoupon(id);

    showSnackBar(result);

    navigateToCoupon(context);
  }

  deleteAllCouponRecord() async {
    String result = await Provider.of<CouponProvider>(context, listen: false)
        .deleteAllCouponRecord();

    showSnackBar(result);

    navigateToCoupon(context);
  }

  // deleteCouponRecord(int id) async {
  //   bool result = await Provider.of<CouponProvider>(context, listen: false)
  //       .deleteCarById(id);
  //   if (result) {
  //     showSnackBar("Car record delete successfully");
  //   } else {
  //     showSnackBar("Unable to delete car record Try again later!");
  //   }
  // }

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

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  bool _sortAscending = true;

  void _sort<T>(Comparable<T> Function(Coupon d) getField, int columnIndex,
      bool ascending) {
    _couponsDataSource!.sort(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(_filterCoupon);
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
        // filters(context),
        SingleChildScrollView(
          child: FutureBuilder(
              future: couponRecord == null ? getCouponRecord() : null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return PaginatedDataTable(
                    headingRowColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                    horizontalMargin: !Responsive.isMobile(context) ? 45 : 20,
                    columnSpacing: !Responsive.isMobile(context) ? 95 : 20,
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CouponDialog(
                                true,
                                -1,
                                "",
                                0.0,
                                "",
                                "",
                                "",
                              );
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
                        onPressed: deleteAllCouponRecord,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Delete All"),
                      ),
                    ],
                    header: const Text('Coupon Record'),
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
                        label: const Text("Coupon Code"),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (Coupon d) => d.couponCode, columnIndex, ascending),
                      ),
                      DataColumn(
                        label: const Text('Discount Amount'),
                        onSort: (columnIndex, ascending) => _sort<num>(
                            (Coupon d) => d.couponDiscountAmount,
                            columnIndex,
                            ascending),
                      ),
                      DataColumn(
                        label: const Text('Valid From'),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (Coupon d) => d.validFrom, columnIndex, ascending),
                      ),
                      DataColumn(
                        label: const Text('Valid To'),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (Coupon d) => d.validTo, columnIndex, ascending),
                      ),
                      DataColumn(
                        label: const Text('Status'),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (Coupon d) => d.status, columnIndex, ascending),
                      ),
                      const DataColumn(
                        label: Text('Edit'),
                      ),
                      const DataColumn(
                        label: Text('Delete'),
                      ),
                    ],
                    source: _couponsDataSource!,
                  );
                }
              }),
        ),
      ],
    );
  }

  void _pickFromDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _pickFromDate = pickedDate;
        });
      }
    });
  }

  void _pickToDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _pickToDate = pickedDate;
        });
      }
    });
  }

  Row filters(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: _pickFromDatePicker,
                icon: Icon(
                  Icons.calendar_month,
                  color: Theme.of(context).primaryColor,
                )),
            Text(
              _pickFromDate == null
                  ? "Date From "
                  : DateFormat("dd-MM-yyyy").format(_pickFromDate!),
            ),
          ],
        ),
        const SizedBox(
          width: 5,
        ),
        Row(
          children: [
            IconButton(
                onPressed: _pickToDatePicker,
                icon: Icon(
                  Icons.calendar_month,
                  color: Theme.of(context).primaryColor,
                )),
            Text(
              _pickToDate == null
                  ? "Date To "
                  : DateFormat("dd-MM-yyyy").format(_pickToDate!),
            ),
          ],
        ),
        const SizedBox(
          width: 5,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: () {},
          child: const Text("Apply Filter"),
        ),
        const SizedBox(
          width: 5,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {},
          child: const Text("Reset"),
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
