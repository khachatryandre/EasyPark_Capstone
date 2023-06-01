import 'package:capstone_project/Databases/user/parking_reservation.dart';
import 'package:capstone_project/dashboard/bottom.dart';
import 'package:flutter/material.dart';

import '../Databases/user/user.dart';

class ActiveReservationsScreen extends StatefulWidget {
  @override
  State<ActiveReservationsScreen> createState() =>
      _ActiveReservationsScreenState();
}

class _ActiveReservationsScreenState extends State<ActiveReservationsScreen> {

  @override
  Widget build(BuildContext context) {
    print(User.activeReservations.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Reservations'),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: User.activeReservations.length,
              itemBuilder: (BuildContext context, int index) {
                final ParkingReservation item = User.activeReservations[index];
                return Dismissible(
                  key: Key(User.activeReservations[index].ParkingLotNumber.toString()),
                  onDismissed: (direction) {
                    setState(
                      () {
                        User.activeReservations.removeAt(index);
                      },
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Reservation of parking lot $index removed")));
                  },
                  background: Container(color: Colors.red),
                  child: ListTile(
                    title: Text('${User.activeReservations[index].parkingSpaceName} Parking lot ${User.activeReservations[index].ParkingLotNumber} \n Starts at: ${User.activeReservations[index].startTime}', style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),),
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(
                          () {
                            User.activeReservations.removeAt(index);
                          },
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("$item removed")));
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomDashboardScreen(currentIndex: 1),
    );
  }
}
