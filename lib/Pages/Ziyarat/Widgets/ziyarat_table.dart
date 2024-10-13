import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Pages/Ziyarat/Provider/ziyarat_provider.dart';
import 'package:flutter_dashboard/Routes/navigation_methods.dart';
import 'package:provider/provider.dart';
import '../../../General Widgets/Responsive.dart';
import './ziyarat_data_source.dart';
import '../Model/ziyarat.dart';
import './ziyarat_dialogue.dart';

class ZiyaratTable extends StatefulWidget {
  const ZiyaratTable({super.key});

  @override
  State<ZiyaratTable> createState() => _ZiyaratTableState();
}

class _ZiyaratTableState extends State<ZiyaratTable> {
  final TextEditingController _searchController = TextEditingController();
  ZiyaratDataSource? _ziyaratDataSource;
  List<Ziyarat>? list;
  List<Ziyarat>? filteredZiyaratRecord;

  @override
  void initState() {
    super.initState();
    // Set up a listener to perform search whenever the text changes for search
    // _searchController.addListener(() {
    _searchController.addListener(_filterZiyarat);
    // });
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed from the widget tree
    _searchController.dispose();
    super.dispose();
  }

  deleteZiyaratById(int id) async {
    String result = await Provider.of<ZiyaratProvider>(context, listen: false)
        .deleteZiyaratById(id);

    showSnackBar(result);
    navigateToZiyarat(context);
  }

  deleteAllZiyaratRecord() async {
    String result = await Provider.of<ZiyaratProvider>(context, listen: false)
        .deleteAllZiyarat();

    showSnackBar(result);
    navigateToZiyarat(context);
  }

  Future<void> getZiyaratRecord() async {
    list = [];
    list = await Provider.of<ZiyaratProvider>(context).fetchZiyaratRecord();
    _ziyaratDataSource = ZiyaratDataSource(list!, context, deleteZiyaratById);
  }

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  bool _sortAscending = true;

  void _sort<T>(Comparable<T> Function(Ziyarat d) getField, int columnIndex,
      bool ascending) {
    _ziyaratDataSource!.sort(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  void _filterZiyarat() {
    setState(() {
      if (_searchController.text.isEmpty) {
        filteredZiyaratRecord = list;
      } else {
        filteredZiyaratRecord = list!.where((ziyarat) {
          return ziyarat.carName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              ziyarat.carNumber
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              ziyarat.ziyaratName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              ziyarat.driverName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase());
        }).toList();
      }
      _ziyaratDataSource =
          ZiyaratDataSource(filteredZiyaratRecord!, context, deleteZiyaratById);
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
              future: list == null ? getZiyaratRecord() : null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return PaginatedDataTable(
                    headingRowColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                    horizontalMargin: !Responsive.isMobile(context) ? 30 : 20,
                    columnSpacing: !Responsive.isMobile(context) ? 80 : 20,
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ZiyaratDialog(true, -1, "", -1, "", "", "",
                                  "", 0.0, const []);
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
                        onPressed: deleteAllZiyaratRecord,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Delete All"),
                      ),
                    ],
                    header: const Text('Ziyarat Record'),
                    rowsPerPage: _rowsPerPage,
                    onRowsPerPageChanged: (r) {
                      setState(() {
                        _rowsPerPage = r!;
                      });
                    },
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    columns: <DataColumn>[
                      //const DataColumn(
                      //label: Text('Image'),
                      // onSort: (columnIndex, ascending) => _sort<String>(
                      //     (Car d) => d.carImageUrl, columnIndex, ascending),
                      // ),
                      DataColumn(
                        label: const Text('Ziyarat Name'),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (Ziyarat d) => d.ziyaratName,
                            columnIndex,
                            ascending),
                      ),
                      DataColumn(
                        label: const Text('Car Name'),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (Ziyarat d) => d.carName, columnIndex, ascending),
                      ),
                      DataColumn(
                        label: const Text('Car Number'),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (Ziyarat d) => d.carNumber, columnIndex, ascending),
                      ),
                      DataColumn(
                        label: const Text('Driver Name'),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (Ziyarat d) => d.driverName,
                            columnIndex,
                            ascending),
                      ),
                      // DataColumn(
                      //   label: const Text('Driver Number'),
                      //   onSort: (columnIndex, ascending) => _sort<String>(
                      //       (Ziyarat d) => d.driverNumber, columnIndex, ascending),
                      // ),
                      DataColumn(
                        label: const Text('No. of Seats'),
                        numeric: true,
                        onSort: (columnIndex, ascending) => _sort<num>(
                            (Ziyarat d) => d.noOfSeats, columnIndex, ascending),
                      ),
                      DataColumn(
                        label: const Text('Price'),
                        numeric: true,
                        onSort: (columnIndex, ascending) => _sort<num>(
                            (Ziyarat d) => d.price, columnIndex, ascending),
                      ),
                      const DataColumn(
                        label: Text('Action'),
                      ),
                      const DataColumn(
                        label: Text('Delete'),
                      ),
                    ],
                    source: _ziyaratDataSource!,
                  );
                }
              }),
        ),
      ],
    );
  }
}
