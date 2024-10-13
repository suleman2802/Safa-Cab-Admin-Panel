import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Routes/navigation_methods.dart';
import 'package:provider/provider.dart';

import '../../../General Widgets/car_selection_dialogue.dart';
import '../../../General Widgets/custom_card.dart';

import '../Provider/booking_provider.dart';

class BookingDialog extends StatefulWidget {
  bool isNew;
  int id;
  String bookingId;
  String bookingType;
  String customerName;
  String driverName;
  String carType;
  int carId;
  String carNumber;
  String pickup;
  String dropoff;
  String dateTime;
  String status;
  double discount;
  double price;

  BookingDialog(
      this.isNew,
      this.id,
      this.bookingId,
      this.bookingType,
      this.customerName,
      this.driverName,
      this.carType,
      this.carId,
      this.carNumber,
      this.pickup,
      this.dropoff,
      this.dateTime,
      this.status,
      this.discount,
      this.price);

  @override
  _BookingDialogState createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController bookingIdController = TextEditingController();
  final TextEditingController bookingTypeController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController pickUpController = TextEditingController();
  final TextEditingController dropOfController = TextEditingController();
  String bookingStatus = 'pending approval';
  List<String> carList = [];
  int? carSelectedId;
  String? carSelectedName;
  String? carSelectedNumber;

  void selectCar(int carId, String carName, String carNumber) {
    setState(() {
      carSelectedId = carId;
      carSelectedName = carName;
      carSelectedNumber = carNumber;
    });
  }

  updateBookingRecord() async {
    if (validate()) {
      final menuProvider = Provider.of<BookingProvider>(context, listen: false);

      String result = await menuProvider.updateBookingRecord(
        widget.id,
        driverNameController.text.trim(),
        carSelectedId!,
        double.parse(priceController.text.trim()),
        bookingStatus,
        widget.carId == carSelectedId,
      );

      showSnackBar(result);
      navigateToBooking(context);
    }
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
    // if (widget.isNew) {
    //   if (_image == null) {
    //     showSnackBar("Please add image of Package Station");
    //     return false;
    //   }
    // }
    if (carSelectedId == null) {
      showSnackBar("Please Select car");
      return false;
    }
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  void loadData() {
    if (!widget.isNew) {
      carSelectedName = widget.carType;
      carSelectedNumber = widget.carNumber;
      carSelectedId = widget.carId;
      driverNameController.text = widget.driverName;
      discountController.text = widget.discount.toString();
      priceController.text = widget.price.toString();
      bookingIdController.text = widget.bookingId;
      bookingTypeController.text = widget.bookingType;
      customerNameController.text = widget.customerName;
      pickUpController.text = widget.pickup;
      dropOfController.text = widget.dropoff;
      bookingStatus = widget.status;
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
        'Booking',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: ListBody(
              children: <Widget>[
                // widget.isNew
                //     ? CustomCard(
                //         child: carSelectedId == null
                //             ? TextButton(
                //                 onPressed: () => showDialog(
                //                   context: context,
                //                   builder: (BuildContext context) {
                //                     return CarSelectionDialogue(selectCar);
                //                   },
                //                 ),
                //                 child: const Text('Select Car'),
                //               )
                //             : ListTile(
                //                 title: Text(carSelectedName!),
                //                 subtitle: Text(carSelectedNumber!),
                //                 trailing: IconButton(
                //                   onPressed: () => showDialog(
                //                     context: context,
                //                     builder: (BuildContext context) {
                //                       return CarSelectionDialogue(selectCar);
                //                     },
                //                   ),
                //                   icon: Icon(Icons.edit),
                //                 ),
                //               ),
                //       )
                //     :
                ListTile(
                  title: Text(carSelectedName!),
                  subtitle: Text(carSelectedNumber!),
                  trailing: IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CarSelectionDialogue(selectCar);
                      },
                    ),
                    icon: Icon(Icons.edit),
                  ),
                ),
                TextFormField(
                  controller: bookingIdController,
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: 'Booking Id',
                    labelText: 'Booking Id',
                  ),
                ),
                TextFormField(
                  controller: bookingTypeController,
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: 'Booking Type',
                    labelText: 'Booking Type',
                  ),
                ),
                TextFormField(
                  controller: customerNameController,
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: 'Customer Name',
                    labelText: 'Customer Name',
                  ),
                ),
                TextFormField(
                  controller: pickUpController,
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: 'Pick Up Controller',
                    labelText: 'Pick Up Controller',
                  ),
                ),
                TextFormField(
                  controller: dropOfController,
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: 'Drop of Controller',
                    labelText: 'Drop of Controller',
                  ),
                ),
                TextFormField(
                  controller: driverNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Driver Name";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Driver Name',
                    labelText: 'Driver Name',
                  ),
                ),
                TextFormField(
                  enabled: false,
                  controller: discountController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Booking Discount Price";
                    } else if (!RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')
                        .hasMatch(value)) {
                      return "Price should be in digits";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Discount',
                    labelText: 'Discount',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: priceController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Booking Price";
                    } else if (!RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')
                        .hasMatch(value)) {
                      return "Price should be in digits";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Price',
                    labelText: 'Price',
                  ),
                  keyboardType: TextInputType.number,
                ),
                // TextFormField(
                //   controller: carNameController,
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return "Please enter Car Name";
                //     }
                //     return null;
                //   },
                //   decoration: const InputDecoration(
                //     hintText: 'Car Name',
                //     labelText: "Car Name",
                //   ),
                // ),
                // TextFormField(
                //   controller: carNumberController,
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return "Please enter Car Number";
                //     }
                //     return null;
                //   },
                //   decoration: const InputDecoration(
                //     hintText: 'Car Number',
                //     labelText: "Car Number",
                //   ),
                //   keyboardType: TextInputType.number,
                // ),
                // TextFormField(
                //   controller: driverNameController,
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return "Please enter Driver Name";
                //     }
                //     return null;
                //   },
                //   decoration: const InputDecoration(
                //     hintText: 'Driver Name',
                //     labelText: "Driver Name",
                //   ),
                // ),
                // TextFormField(
                //   controller: driverNumberController,
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return "Please enter Driver Number";
                //     } else if (value.contains(RegExp(r'[a-z]'))) {
                //       return "Driver Number doesn't need any alphabets";
                //     } else if (value.length != 13) {
                //       return "Enter valid phone number";
                //     }
                //     return null;
                //   },
                //   decoration: const InputDecoration(
                //     hintText: 'Driver Number',
                //     labelText: "Driver Number",
                //   ),
                //   keyboardType: TextInputType.number,
                // ),
                // TextFormField(
                //   controller: noOfSeatsController,
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return "Please specify number of seats";
                //     } else if (!RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')
                //         .hasMatch(value)) {
                //       return "Number of seats must be in numbers";
                //     }
                //     return null;
                //   },
                //   decoration: const InputDecoration(
                //     hintText: 'Car Number of Seats',
                //     labelText: "Car Number of Seats",
                //   ),
                //   keyboardType: TextInputType.number,
                // ),
                // TextFormField(
                //   controller: noOfLuggageController,
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return "Please specify number of luggage's";
                //     } else if (!RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')
                //         .hasMatch(value)) {
                //       return "Number of Luggage must be in numbers";
                //     }
                //     return null;
                //   },
                //   decoration: const InputDecoration(
                //     hintText: 'Number of Luaggage',
                //     labelText: "Car number of Luaggage Storage Capacity",
                //   ),
                //   keyboardType: TextInputType.number,
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                // Text(
                //   'Booking includes',
                //   style: Theme.of(context).textTheme.titleLarge,
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                // for (int i = 0; i < variants.length; i++)
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Container(
                //           decoration: const BoxDecoration(
                //             border: Border(
                //               bottom: BorderSide(
                //                 color: Colors.black54,
                //                 width: 1,
                //               ),
                //             ),
                //           ),
                //           child: Row(
                //             children: [
                //               Container(
                //                 color: Theme.of(context).primaryColor,
                //                 height: 15,
                //                 width: 15,
                //               ),
                //               const SizedBox(
                //                 width: 8,
                //               ),
                //               Text(
                //                 variants[i],
                //                 style: const TextStyle(fontSize: 18),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //       IconButton(
                //         icon: const Icon(
                //           Icons.edit,
                //           color: Colors.green,
                //         ),
                //         onPressed: () {
                //           //edit
                //           // setState(() {
                //           //   variants.removeAt(i);
                //           // });
                //         },
                //       ),
                //       IconButton(
                //         icon: const Icon(
                //           Icons.delete,
                //           color: Colors.red,
                //         ),
                //         onPressed: () {
                //           setState(() {
                //             variants.removeAt(i);
                //           });
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: TextFormField(
                //         controller: BookingPointController,
                //         decoration: const InputDecoration(
                //           hintText: 'Add Booking details',
                //         ),
                //       ),
                //     ),
                //     IconButton(
                //       icon: const Icon(Icons.add),
                //       onPressed: _addVariant,
                //     ),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Status"),
                      DropdownButton<String>(
                        value: bookingStatus,
                        items: <String>[
                          'pending approval',
                          'confirmed',
                          'on route',
                          'complete',
                          'cancelled'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          print("on change method");
                          print(newValue);
                          setState(() {
                            bookingStatus = newValue!;
                            print(bookingStatus);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(child: Text("Update"), onPressed: updateBookingRecord
            //widget.isNew ? _saveMenu(context) : updateBookingRecord(),
            ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
