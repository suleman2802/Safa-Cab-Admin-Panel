import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Routes/navigation_methods.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../General Widgets/car_selection_dialogue.dart';
import '../../../General Widgets/custom_card.dart';
import '../Provider/Airport_Provider.dart';

class AirportDialog extends StatefulWidget {
  bool isAddedNewImage = false;
  bool isNew;
  int id;

  // String imageUrl;
  String carName;
  int carId;
  String carNumber;

  // String carNumber;
  // String driverName;

//  String driverNumber;
//    String noOfSeat;
//    String noOfLuaggage;
  String pickFrom;
  String dropOf;
  double faire;

  AirportDialog(
      this.isNew,
      this.id,
      // this.imageUrl,
      this.carName,
      this.carId,
      this.carNumber,
      //    this.carNumber,
      // this.driverName,
      //    this.driverNumber,
      //  this.noOfSeat,
      //  this.noOfLuaggage,
      this.pickFrom,
      this.dropOf,
      this.faire);

  @override
  _AirportDialogState createState() => _AirportDialogState();
}

class _AirportDialogState extends State<AirportDialog> {
  // final TextEditingController carNameController = TextEditingController();

//  final TextEditingController carNumberController = TextEditingController();
//   final TextEditingController noOfSeatsController = TextEditingController();
//   final TextEditingController noOfLuggageController = TextEditingController();
//   final TextEditingController driveNameController = TextEditingController();

//  final TextEditingController driverNumberController = TextEditingController();
  final TextEditingController pickUpController = TextEditingController();
  final TextEditingController dropOfController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  XFile? _image;
  List<String> carList = [];
  int? carSelectedId;
  String? carSelectedName;
  String? carSelectedNumber;

  Future<void> _saveMenu(BuildContext context) async {
    if (validate()) {
      final menuProvider = Provider.of<AirportProvider>(context, listen: false);

      String result = await menuProvider.addMenuItem(
          // _image!,
          pickUpController.text.trim(),
          dropOfController.text.trim(),
          carSelectedId!,
          double.parse(priceController.text.trim()));
      showSnackBar(result);
      navigateToAirport(context);
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
    //     showSnackBar("Please add image of Airport");
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
      carSelectedName = widget.carName;
      carSelectedNumber = widget.carNumber;
      carSelectedId = widget.carId;
      // carNameController.text = widget.carName;
      //    carNumberController.text = widget.carNumber;
      // driveNameController.text = widget.driverName;
      //    driverNumberController.text = widget.driverNumber;
      // noOfSeatsController.text = widget.noOfSeat;
      // noOfLuggageController.text = widget.noOfLuaggage;
      pickUpController.text = widget.pickFrom;
      dropOfController.text = widget.dropOf;
      priceController.text = widget.faire.toString();
    }
  }

  // Future getImage() async {
  //   final pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = pickedFile; //File(pickedFile.path);
  //     } else {
  //       //print('No image selected.');
  //     }
  //   });
  // }

  // fetchCarList() async {
  //   carList =
  //       await Provider.of<CarProvider>(context, listen: false).fetchCarList();
  //   print("a ${carList}");
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  fetchCarList();
    loadData();
  }

  Future<void> updateAirportRecord() async {
    if (validate()) {
      final menuProvider = Provider.of<AirportProvider>(context, listen: false);

      String result = await menuProvider.updateAirportRecord(
          // _image,
          widget.id,
          pickUpController.text.trim(),
          dropOfController.text.trim(),
          carSelectedId!,
          double.parse(priceController.text.trim()));

      showSnackBar(result);
      navigateToAirport(context);
    }
  }

  void selectCar(int carId, String carName, String carNumber) {
    setState(() {
      carSelectedId = carId;
      carSelectedName = carName;
      carSelectedNumber = carNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Airport Booking Faire',
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
                //         child: _image == null
                //             ? TextButton(
                //                 onPressed: getImage,
                //                 child: const Text('Upload Image'),
                //               )
                //             : const Text("Image Selected Successfully"),
                //       )
                //     : !widget.isAddedNewImage
                //         ? CustomCard(
                //             child: Image.network(
                //               widget.imageUrl,
                //             ),
                //           )
                //         : const CustomCard(
                //             child: Text("Image Selected Successfully"),
                //           ),
                // const SizedBox(
                //   height: 8,
                // ),
                // !widget.isNew
                //     ? ElevatedButton(
                //         onPressed: () {
                //           getImage().then((value) => setState(() {
                //                 widget.isAddedNewImage = true;
                //               }));
                //         },
                //         child: const Text("Change Image"),
                //       )
                //     : const SizedBox(),
                widget.isNew
                    ? CustomCard(
                        child: carSelectedId == null
                            ? TextButton(
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CarSelectionDialogue(selectCar);
                                  },
                                ),
                                child: const Text('Select Car'),
                              )
                            : ListTile(
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
                      )
                    : ListTile(
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
                //   controller: driveNameController,
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
                TextFormField(
                  controller: pickUpController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Specify Pick up point";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Pick Up',
                    labelText: "Pick Up",
                  ),
                ),
                TextFormField(
                  controller: dropOfController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Specify Drop of point";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Drop of',
                    labelText: "Drop of",
                  ),
                ),
                TextFormField(
                  controller: priceController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Faire amount";
                    } else if (!RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')
                        .hasMatch(value)) {
                      return "Faire should be in digits";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Faire',
                    labelText: "Faire",
                  ),
                  keyboardType: TextInputType.number,
                ),
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
          onPressed: () =>
              widget.isNew ? _saveMenu(context) : updateAirportRecord(),
        ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
