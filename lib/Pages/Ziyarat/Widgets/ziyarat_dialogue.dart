import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Routes/navigation_methods.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../General Widgets/car_selection_dialogue.dart';
import '../../../General Widgets/custom_card.dart';
import '../Provider/ziyarat_provider.dart';

class ZiyaratDialog extends StatefulWidget {
  bool isAddedNewImage = false;
  bool isNew;
  int id;
  String ziyaratName;

  String imageUrl;
  int carId;
  String carName;
  String carNumber;
  String driverName;

//  String driverNumber;
//   int noOfLuaggage;
//   int noOfSeats;
  double price;
  List<String> variantsData;

  ZiyaratDialog(
      this.isNew,
      this.id,
      this.ziyaratName,
      this.carId,
      this.imageUrl,
      this.carName,
      this.carNumber,
      this.driverName,
      //    this.driverNumber,
      // this.noOfLuaggage,
      // this.noOfSeats,
      this.price,
      this.variantsData);

  @override
  _ZiyaratDialogState createState() => _ZiyaratDialogState();
}

class _ZiyaratDialogState extends State<ZiyaratDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController ziyaratNameController = TextEditingController();

//  final TextEditingController driverNameController = TextEditingController();
//  final TextEditingController driverNumberController = TextEditingController();
//  final TextEditingController carNameController = TextEditingController();
//  final TextEditingController carNumberController = TextEditingController();
//  final TextEditingController noOfSeatsController = TextEditingController();
//  final TextEditingController noOfLuggageController = TextEditingController();
  final TextEditingController ziyaratPointController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  XFile? _image;
  List<String> variants = [];
  List<String> carList = [];
  int? carSelectedId;
  String? carSelectedName;
  String? carSelectedNumber;

  void _addVariant() {
    setState(() {
      variants.add(ziyaratPointController.text);
      ziyaratPointController.clear();
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
      final menuProvider = Provider.of<ZiyaratProvider>(context, listen: false);

      String result = await menuProvider.addZiyarat(
          _image!,
          ziyaratNameController.text.trim(),
          double.parse(priceController.text.trim()),
          carSelectedId!,
          variants);
      showSnackBar(result);
      navigateToZiyarat(context);
    }
  }

  updatePackageRecord() async {
    if (validate()) {
      final menuProvider = Provider.of<ZiyaratProvider>(context, listen: false);

      String result = await menuProvider.updateZiyaratRecord(
        _image,
        widget.id,
        ziyaratNameController.text.trim(),
        double.parse(priceController.text.trim()),
        carSelectedId!,
        variants,
        carSelectedNumber!,
      );
      showSnackBar(result);
      navigateToZiyarat(context);
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
        showSnackBar("Please add image of Ziyarat Point");
        return false;
      }
    }
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

      ziyaratNameController.text = widget.ziyaratName;
      //carNameController.text = widget.carName;
      //driverNameController.text = widget.driverName;
      //   driverNumberController.text = widget.driverNumber;
      //noOfLuggageController.text = widget.noOfLuaggage.toString();
      // noOfSeatsController.text = widget.noOfSeats.toString();
      priceController.text = widget.price.toString();
      variants = widget.variantsData;
    }
  }

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile; //File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Ziyarat Package Record',
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

                // TextFormField(
                //   controller: carNameController,
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return "Please enter Car Name";
                //     }
                //     return null;
                //   },
                //   decoration: const InputDecoration(
                //     hintText: 'Car Type',
                //     labelText: "Car Type",
                //   ),
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
                  controller: ziyaratNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Ziyarat Name";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Ziyarat Name',
                  ),
                ),
                TextFormField(
                  controller: priceController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please specify Price of Ziyarat Package";
                    } else if (!RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')
                        .hasMatch(value)) {
                      return "Price of Ziyarat contain only numeric data";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Price',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Ziya-rats Points',
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
                        controller: ziyaratPointController,
                        decoration: const InputDecoration(
                          hintText: 'Add Ziya-rat points',
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
