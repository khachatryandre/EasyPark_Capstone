import 'package:flutter/material.dart';

class ParkingHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking History'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: 5, // TODO: Replace with actual count
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('Booking $index'),
              // TODO: Display relevant booking details
            );
          },
        ),
      ),
    );
  }
}
