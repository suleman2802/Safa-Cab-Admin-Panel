import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

import '../Pages/Car/Model/car.dart';
import '../Pages/Car/Provider/Car_provider.dart';

class CarSelectionDialogue extends StatefulWidget {
  Function selectCar;

  CarSelectionDialogue(this.selectCar);

  @override
  State<CarSelectionDialogue> createState() => _CarSelectionDialogueState();
}

class _CarSelectionDialogueState extends State<CarSelectionDialogue> {
  Future<List<Car>> getCarRecord() async {
    return await Provider.of<CarProvider>(context, listen: false)
        .fetchCarRecord();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.8),
      title: const Text(
        "Select Car",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      content: SizedBox(
        height: 230,
        width: 250,
        child: FutureBuilder<List<Car>>(
          future: getCarRecord(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Car car = snapshot.data![index];
                    return Column(
                      children: [
                        ListTile(
                          //hoverColor: Theme.of(context).scaffoldBackgroundColor,
                          titleTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          shape: LinearBorder(
                            //borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          leading: const Icon(
                            Icons.car_rental,
                            size: 40,
                          ),
                          title: Text(
                            car.carName,
                          ),
                          subtitle: Text(car.carNumber),
                          onTap: () {
                            widget.selectCar(car.carId,car.carName,car.carNumber);
                            Navigator.of(context).pop();
                          },
                        ),
                        const Divider(),
                      ],
                    );
                  },
                );
              } else {
                return const SizedBox(
                  child: Text("Add car first "),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
