import 'package:flutter/material.dart';

class ParkingCancellationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Cancellation'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: 3, // TODO: Replace with actual count
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('Booking $index'),
              // TODO: Display relevant booking details
              trailing: ElevatedButton(
                onPressed: () {
                  // TODO: Implement cancellation logic
                },
                child: Text('Cancel'),
              ),
            );
          },
        ),
      ),
    );
  }
}
