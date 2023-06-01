import 'package:capstone_project/Databases/parkingSpaces/parkingLot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSpacesDB {
  static Map<String, List<ParkingLot>> parkingSpace = {};

  ParkingSpacesDB(String name, int number) {
    List<ParkingLot> parkingLots = [];
    for (int i = 0; i < number; i++) {
      parkingLots.add(ParkingLot(i, true));
    }
    parkingSpace[name] = parkingLots;
  }

  static void addParkingSpace(String name, int count) async {
    CollectionReference parkingSpacesCollection =
        FirebaseFirestore.instance.collection('ParkingSpaces');

    try {
      List<Map<String, dynamic>> updatedObjects = [];
      for (int i = 0; i < count; i++) {
        updatedObjects.add({'booleanValue': true, 'intValue': i});
      }

      await parkingSpacesCollection.doc(name).set({
        'name': name,
        'lots': updatedObjects,
      });

      print('Parking spaces added successfully!');
    } catch (e) {
      print('Error adding parking spaces: $e');
    }
  }
}
