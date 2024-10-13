import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../General Widgets/custom_card.dart';
import '../../../Routes/navigation_methods.dart';
import '../../../Routes/routes_name.dart';
import '../Model/car.dart';
import '../Provider/Car_provider.dart';

class CarDialog extends StatefulWidget {
  bool isAddedNewImage = false;
  bool isNew;
  int carId;
  String imageUrl;
  String carName;
  String carModel;
  String carNumber;
  String driverName;

//  String driverNumber;
  String noOfSeat;
  String noOfLuagge;
  int qyt;

  CarDialog(
      this.isNew,
      this.carId,
      this.imageUrl,
      this.carName,
      this.carNumber,
      this.carModel,
      this.driverName,
      //    this.driverNumber,
      this.noOfSeat,
      this.noOfLuagge,
      this.qyt);

  @override
  _CarDialogState createState() => _CarDialogState();
}

class _CarDialogState extends State<CarDialog> {
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carNumberController = TextEditingController();
  final TextEditingController noOfSeatsController = TextEditingController();
  final TextEditingController noOfLuggageController = TextEditingController();
  final TextEditingController driveNameController = TextEditingController();
  final TextEditingController qytController = TextEditingController();

//  final TextEditingController driverNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  XFile? _image;

  void _saveMenu(BuildContext context) async {
    if (validate()) {
      final menuProvider = Provider.of<CarProvider>(context, listen: false);

      final newItem = Car(
        0,
        "https://images.unsplash.com/photo-1544502062-f82887f03d1c?q=80&w=3359&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        carNameController.text,
        int.parse(carModelController.text.trim()),
        driveNameController.text,
        //    driverNumberController.text,
        carNumberController.text,

        int.parse(noOfSeatsController.text.trim()),
        int.parse(noOfLuggageController.text.trim()),
        int.parse(qytController.text.trim()),
      );
      String result = await menuProvider.addMenuItem(newItem, _image!);
      showSnackBar(result);
      navigateToCar(context);
    }
  }

  void loadData() {
    if (!widget.isNew) {
      carNameController.text = widget.carName;
      carModelController.text = widget.carModel;
      carNumberController.text = widget.carNumber;
      driveNameController.text = widget.driverName;
      //    driverNumberController.text = widget.driverNumber;
      noOfSeatsController.text = widget.noOfSeat;
      noOfLuggageController.text = widget.noOfLuagge;
      qytController.text = widget.qyt.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
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
    if (widget.isNew) {
      if (_image == null) {
        showSnackBar("Please add image of car");
        return false;
      }
    }
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile; //File(pickedFile.path);
      } else {
        //print('No image selected.');
      }
    });
  }

  Future<void> updateCarRecord() async {
    if (validate()) {
      final carProvider = Provider.of<CarProvider>(context, listen: false);
      final newCar = Car(
        0,
        "https://images.unsplash.com/photo-1544502062-f82887f03d1c?q=80&w=3359&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        carNameController.text,
        int.parse(carModelController.text),
        driveNameController.text,
        //    driverNumberController.text,
        carNumberController.text,

        int.parse(noOfSeatsController.text),
        int.parse(noOfLuggageController.text),
        int.parse(qytController.text),
      );

      String result =
          (await carProvider.updateCarRecord(newCar, _image, widget.carId));

      showSnackBar(result);

      navigateToCar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Car Details',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: ListBody(
              children: <Widget>[
                widget.isNew
                    ? CustomCard(
                        child: _image == null
                            ? TextButton(
                                onPressed: getImage,
                                child: const Text('Upload Image'),
                              )
                            : const Text("Image Selected Successfully"),
                      )
                    : !widget.isAddedNewImage
                        ? CustomCard(
                            child: Image.network(
                              height: 170,
                              width: 100,
                              fit: BoxFit.contain,
                              widget.imageUrl,
                            ),
                          )
                        : const CustomCard(
                            child: Text("Image Selected Successfully"),
                          ),
                const SizedBox(
                  height: 8,
                ),
                !widget.isNew
                    ? ElevatedButton(
                        onPressed: () {
                          getImage().then((value) => setState(() {
                                widget.isAddedNewImage = true;
                              }));
                        },
                        child: const Text("Change Image"),
                      )
                    : const SizedBox(),
                TextFormField(
                  controller: carNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Car Name";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Car Type',
                    labelText: "Car Type",
                  ),
                ),
                TextFormField(
                  controller: carNumberController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Car Number";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Car Number',
                    labelText: "Car Number",
                  ),
                ),
                TextFormField(
                  controller: driveNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Driver Name";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Driver Name',
                    labelText: "Driver Name",
                  ),
                ),
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
                //   keyboardType: TextInputType.phone,
                // ),
                TextFormField(
                  controller: carModelController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please specify model of car";
                    } else if (!RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')
                        .hasMatch(value)) {
                      return "Model of car contain only numeric data";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Car Model',
                    labelText: "Car Model",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: qytController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please specify number of cars";
                    } else if (!RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')
                        .hasMatch(value)) {
                      return "Number of cars must be in numbers";
                    } else if (value == "0") {
                      return "The Quantity of car can't be 0";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Number of cars',
                    labelText: "Number of cars",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: noOfSeatsController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please specify number of seats";
                    } else if (!RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')
                        .hasMatch(value)) {
                      return "Number of seats must be in numbers";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Car Number of Seats',
                    labelText: "Car Number of Seats",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: noOfLuggageController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please specify number of luggage's";
                    } else if (!RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')
                        .hasMatch(value)) {
                      return "Number of Luggage must be in numbers";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Number of Luggage',
                    labelText: "Car number of Luggage Storage Capacity",
                  ),
                  keyboardType: TextInputType.number,
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
          child: Text(widget.isNew ? 'Add' : "Update"),
          onPressed: () =>
              widget.isNew ? _saveMenu(context) : updateCarRecord(),
        ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
