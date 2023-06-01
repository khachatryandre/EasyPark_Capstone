import 'package:capstone_project/Databases/parkingSpaces/parking_spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({Key? key}) : super(key: key);
  TextEditingController textEditingController = TextEditingController();
  TextEditingController numberOfLotsController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.red,
                Colors.blue,
              ],
            )),
        child: Padding(
          padding: const EdgeInsets.all(00),
          child: Center(
            heightFactor: BorderSide.strokeAlignCenter,
            widthFactor: BorderSide.strokeAlignCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              width: 400,
              height: 400,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Add parking Space", style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                  ),),
                  const SizedBox(height: 16,),
                  TextFormField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter parking Space name',
                    ),
                  ),
                  const SizedBox(height: 16,),
                  TextFormField(
                    controller: numberOfLotsController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter number of lots',
                    ),
                  ),
                  const SizedBox(height: 25,),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
                    ),
                    onPressed: () { ParkingSpacesDB.addParkingSpace(textEditingController.text, int.parse(numberOfLotsController.text)); },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        )
      )
    );
  }
}
