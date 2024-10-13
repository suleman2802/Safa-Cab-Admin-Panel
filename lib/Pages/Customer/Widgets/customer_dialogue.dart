import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../../Routes/navigation_methods.dart';
import '../Provider/customer_provider.dart';

class CustomerDialog extends StatefulWidget {
  //bool isAddedNewImage = false;
  int id;
  String name;
  String number;
  String customerType;
  String email;

  CustomerDialog(
    this.id,
    this.name,
    this.number,
    this.email,
    this.customerType,
  );

  @override
  _CustomerDialogState createState() => _CustomerDialogState();
}

class _CustomerDialogState extends State<CustomerDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailsController = TextEditingController();
  String type = "customer";

  final _formKey = GlobalKey<FormState>();

  File? _image;

  void loadData() {
    nameController.text = widget.name;
    numberController.text = widget.number;
    type = widget.customerType;
    emailsController.text = widget.email;
  }

  Future<void> _updateCustomer() async {
    if (validate()) {
      print("validation successfully");
      final customerProvider =
          Provider.of<CustomerProvider>(context, listen: false);

      String result = await customerProvider.updateCustomerRecord(
          widget.id,
          emailsController.text.trim(),
          nameController.text.trim(),
          numberController.text.trim(),
          type);

      showSnackBar(result);

      navigateToCustomer(context);
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
    // if (_image == null) {
    //   showSnackBar("Please add image of customer");
    //   return false;
    // }
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  // Future getImage() async {
  //   final pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       //print('No image selected.');
  //     }
  //   });
  // }

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
        'Customer Details',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: ListBody(
              children: <Widget>[
                // !widget.isAddedNewImage
                //     ? CustomCard(
                //         child: Image.network(
                //           widget.imageUrl,
                //         ),
                //       )
                //     : const CustomCard(
                //         child: Text("File Selected Successfully"),
                //       ),
                // const SizedBox(
                //   height: 8,
                // ),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Customer Name";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Customer Name',
                    labelText: "Customer Name",
                  ),
                ),
                TextFormField(
                  controller: numberController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Driver Number";
                    } else if (value.contains(RegExp(r'[a-z]'))) {
                      return "Driver Number doesn't need any alphabets";
                    } else if (value.length != 13) {
                      return "Enter valid phone number";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Customer Number',
                    labelText: "Customer Number",
                  ),
                ),
                TextFormField(
                  controller: emailsController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter customer email";
                    } else if (!value.contains("@")) {
                      return "Enter valid email address";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Please enter customer email',
                    labelText: "Please enter customer email",
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Customer Type"),
                    DropdownButton<String>(
                      value: type,
                      items: <String>['customer', 'agency'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        // print("on change method");
                        // print(newValue);
                        setState(() {
                          type = newValue!;
                          // print(type);
                        });
                      },
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
          child: Text("Update"),
          onPressed: _updateCustomer,
        ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
