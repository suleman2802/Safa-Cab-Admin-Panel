import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Routes/navigation_methods.dart';
import '../Model/coupon.dart';
import '../Provider/coupon_provider.dart';

class CouponDialog extends StatefulWidget {
  bool isNew;
  int id;
  String couponCode;
  double couponDiscountAmount;
  String validFrom;
  String validTo;
  String status;

  CouponDialog(this.isNew, this.id, this.couponCode, this.couponDiscountAmount,
      this.validFrom, this.validTo, this.status);

  @override
  _CouponDialogState createState() => _CouponDialogState();
}

class _CouponDialogState extends State<CouponDialog> {
  final TextEditingController couponCodeController = TextEditingController();
  final TextEditingController couponDiscountAmountController =
      TextEditingController();
  final TextEditingController validFromController = TextEditingController();
  final TextEditingController validToController = TextEditingController();
  String couponStatus = 'active';
  final _formKey = GlobalKey<FormState>();

  Future<void> _saveMenu(BuildContext context) async {
    if (validate()) {
      print("validation successfully");
      final couponProvider =
          Provider.of<CouponProvider>(context, listen: false);
      try {
        final couponItem = Coupon(
          -1,
          couponCodeController.text,
          double.parse(couponDiscountAmountController.text),
          validFromController.text,
          validToController.text,
          couponStatus,
        );
        print(couponItem);
        final result = await couponProvider.addCouponItem(couponItem);

        showSnackBar(result);
      } catch (error) {
        print(error);
        showSnackBar("unable to add coupon record");
      }
      navigateToCoupon(context);
    }
  }

  Future<void> _updateCoupon() async {
    if (validate()) {
      print("validation successfully");
      final couponProvider =
          Provider.of<CouponProvider>(context, listen: false);
      try {
        final couponItem = Coupon(
          -1,
          couponCodeController.text,
          double.parse(couponDiscountAmountController.text),
          validFromController.text,
          validToController.text,
          couponStatus,
        );
        print(couponItem);
        final result = await couponProvider.updateCoupon(couponItem, widget.id);
        if (result == "Ok") {
          showSnackBar("Coupon Updated Successfully");
        } else {
          showSnackBar(result);
        }
      } catch (error) {
        print(error);
      }
      navigateToCoupon(context);
    }
  }

  void _validFromDatePicker() {
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
          validFromController.text =
              DateFormat("yyyy-MM-dd").format(pickedDate);
        });
      }
    });
  }

  void _validToDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(3000),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          validToController.text = DateFormat("yyyy-MM-dd").format(pickedDate);
        });
      }
    });
  }

  showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  bool validate() {
    final isValid = _formKey.currentState!.validate();

    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  void loadData() {
    if (!widget.isNew) {
      couponCodeController.text = widget.couponCode;
      couponDiscountAmountController.text =
          widget.couponDiscountAmount.toString();
      validFromController.text = widget.validFrom;
      validToController.text = widget.validTo;
      couponStatus = widget.status;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Coupon',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: couponCodeController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please specify coupon code";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Coupon Code',
                    labelText: "Coupon Code",
                  ),
                ),
                TextFormField(
                  controller: couponDiscountAmountController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Coupon amount";
                    } else if (!RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')
                        .hasMatch(value)) {
                      return "Coupon Amount should be in digits";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Coupon Discount Amount',
                    labelText: 'Coupon Discount Amount',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: validFromController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please specify valid from date";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Valid from',
                    labelText: "Valid from",
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.date_range_sharp,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: _validFromDatePicker,
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  controller: validToController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please specify valid to date";
                    } else if (DateFormat("dd-MM-yyyy")
                        .parse(validFromController.text)
                        .isAfter(DateFormat("dd-MM-yyyy").parse(value))) {
                      return "Valid date must be after valid from date";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Valid to',
                    labelText: "Valid to",
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.date_range_sharp,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: _validToDatePicker,
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Status"),
                      DropdownButton<String>(
                        value: couponStatus,
                        items:
                            <String>['active', 'inactive'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          print("on change method");
                          print(newValue);
                          setState(() {
                            couponStatus = newValue!;
                            print(couponStatus);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text(widget.isNew ? 'Save' : "Update"),
          onPressed: () => widget.isNew ? _saveMenu(context) : _updateCoupon(),
        ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
