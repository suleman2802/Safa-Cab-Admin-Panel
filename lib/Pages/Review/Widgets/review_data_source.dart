import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Model/review.dart';

// Create a Data Source class by extending DataTableSource
class ReviewDataSource extends DataTableSource {
  List<Review> _reviews;
  int _selectedCount = 0;
  BuildContext context;
  var deleteReviewById;

  ReviewDataSource(this._reviews,this.context,this.deleteReviewById);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _reviews.length) return null;
    final Review review = _reviews[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        // DataCell(FittedBox(
        //   child: CircleAvatar(
        //     backgroundColor: Colors.yellow,
        //     backgroundImage: NetworkImage(review.imageUrl),
        //     radius: 20,
        //   ),
        // )),
        DataCell(Text(review.bookingType)),
        DataCell(Text(review.name)),
        DataCell(Text(review.review)),
        DataCell(
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              deleteReviewById(review.id);
            },
          ),
        ),
      ],
    );
  }

  void search(String searchText) {
    if (searchText.isEmpty) {
      // If the search text is empty, do not filter the customers
      _reviews = List.from(_reviews);
    } else {
      // Filter the customers based on the search text
      _reviews = _reviews
          .where((review) =>
              review.name.toLowerCase().contains(searchText.toLowerCase()) ||
              review.review.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  @override
  int get rowCount => _reviews.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void sort<T>(Comparable<T> Function(Review c) getField, bool ascending) {
    _reviews.sort((Review a, Review b) {
      if (!ascending) {
        final Review c = a;
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
