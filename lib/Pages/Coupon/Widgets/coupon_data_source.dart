import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Pages/Coupon/Widgets/coupon_dialogue.dart';
import '../Model/coupon.dart';

// Create a Data Source class by extending DataTableSource
class CouponDataSource extends DataTableSource {
  List<Coupon> _coupons;
  BuildContext context;
  int _selectedCount = 0;
  var deleteCouponById;

  CouponDataSource(this._coupons, this.context,this.deleteCouponById);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _coupons.length) return null;
    final Coupon coupon = _coupons[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(coupon.couponCode)),
        DataCell(Text(coupon.couponDiscountAmount.toString())),
        DataCell(Text(coupon.validFrom)),
        DataCell(Text(coupon.validTo)),
        DataCell(
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor:
                  coupon.status == "active" ? Colors.purpleAccent : Colors.red,
              foregroundColor:
                  //booking.status == "confirmed"
                  //  ? Colors.purpleAccent
                  //:
                  Colors.white,
            ),
            child: Text(
              coupon.status == "active" ? "active" : "inactive",
            ),
            onPressed: () {},
          ),
        ),
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
                  return CouponDialog(
                    false,
                    coupon.id,
                    coupon.couponCode,
                    coupon.couponDiscountAmount,
                    coupon.validFrom,
                    coupon.validTo,
                    coupon.status,
                  );
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
              deleteCouponById(coupon.id);
            },
          ),
        ),
      ],
    );
  }

  void search(String searchText) {
    if (searchText.isEmpty) {
      // If the search text is empty, do not filter the customers
      _coupons = List.from(_coupons);
    } else {
      // Filter the customers based on the search text
      _coupons = _coupons
          .where((coupon) =>
              coupon.couponCode
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              coupon.validFrom
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              coupon.validTo.toLowerCase().contains(searchText.toLowerCase()) ||
              coupon.couponDiscountAmount
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  @override
  int get rowCount => _coupons.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void sort<T>(Comparable<T> Function(Coupon c) getField, bool ascending) {
    _coupons.sort((Coupon a, Coupon b) {
      if (!ascending) {
        final Coupon c = a;
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
