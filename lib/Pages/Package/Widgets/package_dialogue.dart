import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Routes/navigation_methods.dart';
import 'package:provider/provider.dart';

import '../../../General Widgets/car_selection_dialogue.dart';
import '../../../General Widgets/custom_card.dart';
import '../Provider/package_provider.dart';

class PackageDialog extends StatefulWidget {
  bool isAddedNewImage = false;
  bool isNew;
  int id;
  String packageName;

  //String carImageUrl;
  int carId;
  String carName;
  String carNumber;
  String driverName;

//  String driverNumber;
  int noOfLuaggage;
  int noOfSeats;
  double price;
  List<String> variantsData;

  PackageDialog(
      this.isNew,
      this.id,
      this.packageName,
      this.carId,
      //this.carImageUrl,
      this.carName,
      this.carNumber,
      this.driverName,
      //    this.driverNumber,
      this.noOfLuaggage,
      this.noOfSeats,
      this.price,
      this.variantsData);

  @override
  _PackageDialogState createState() => _PackageDialogState();
}

class _PackageDialogState extends State<PackageDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController packageNameController = TextEditingController();

//  final TextEditingController driverNameController = TextEditingController();
//  final TextEditingController driverNumberController = TextEditingController();
//  final TextEditingController carNameController = TextEditingController();
//  final TextEditingController carNumberController = TextEditingController();
//  final TextEditingController noOfSeatsController = TextEditingController();
//  final TextEditingController noOfLuggageController = TextEditingController();
  final TextEditingController packagePointController = TextEditingController();
  final TextEditingController priceController = TextEditingController();


  List<String> variants = [];
  List<String> carList = [];
  int? carSelectedId;
  String? carSelectedName;
  String? carSelectedNumber;

  void _addVariant() {
    setState(() {
      variants.add(packagePointController.text);
      packagePointController.clear();
    });
  }

  void selectCar(int carId, String carName, String carNumber) {
    setState(() {
      carSelectedId = carId;
      carSelectedName = carName;
      carSelectedNumber = carNumber;
    });
  }

  Future<void> _saveMenu(BuildContext context) async {
    if (validate()) {
      final menuProvider = Provider.of<PackageProvider>(context, listen: false);

      String result = await menuProvider.addMenuItem(
          packageNameController.text.trim(),
          double.parse(priceController.text.trim()),
          carSelectedId!,
          variants);
      if(result == "Ok"){
        result = "Package record updated Successfully";
      }
      showSnackBar(result);
      navigateToPackage(context);
    }
  }

  updatePackageRecord() async {
    if (validate()) {
      final menuProvider = Provider.of<PackageProvider>(context, listen: false);

      String result = await menuProvider.updatePackageRecord(
        widget.id,
        packageNameController.text.trim(),
        double.parse(priceController.text.trim()),
        carSelectedId!,
        variants,
        //carSelectedNumber!,
      );
      if(result == "Ok"){
        result = "Package record updated Successfully";
      }
      showSnackBar(result);
      navigateToPackage(context);
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
      carSelectedName = widget.carName;
      carSelectedNumber = widget.carNumber;
      carSelectedId = widget.carId;

      packageNameController.text = widget.packageName;
      //carNameController.text = widget.carName;
      //driverNameController.text = widget.driverName;
      //   driverNumberController.text = widget.driverNumber;
      //noOfLuggageController.text = widget.noOfLuaggage.toString();
      // noOfSeatsController.text = widget.noOfSeats.toString();
      priceController.text = widget.price.toString();
      variants = widget.variantsData;
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
        'Package',
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
                //             : const Text("File Selected Successfully"),
                //       )
                //     : !widget.isAddedNewImage
                //         ? CustomCard(
                //             child: Image.network(
                //               widget.carImageUrl,
                //             ),
                //           )
                //         : const CustomCard(
                //             child: Text("File Selected Successfully"),
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
                                  icon: const Icon(Icons.edit),
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
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                TextFormField(
                  controller: packageNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Package Name";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Package Name',
                    labelText: 'Package Name',
                  ),
                ),
                TextFormField(
                  controller: priceController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Package Price";
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
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Package Record',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 15,
                ),
                for (int i = 0; i < variants.length; i++)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black54,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  color: Theme.of(context).primaryColor,
                                  height: 15,
                                  width: 15,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  variants[i],
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // IconButton(
                        //   icon: const Icon(
                        //     Icons.edit,
                        //     color: Colors.green,
                        //   ),
                        //   onPressed: () {
                        //     //edit
                        //     setState(() {
                        //       variants.removeAt(i);
                        //     });
                        //   },
                        // ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              variants.removeAt(i);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: packagePointController,
                        decoration: const InputDecoration(
                          hintText: 'Add Package details',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addVariant,
                    ),
                  ],
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
              widget.isNew ? _saveMenu(context) : updatePackageRecord(),
        ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
