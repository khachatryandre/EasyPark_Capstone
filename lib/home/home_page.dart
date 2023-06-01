import 'package:capstone_project/dashboard/bottom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../parking_space/parking_booking.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the App?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final parkingSpacesRef =
        FirebaseFirestore.instance.collection('ParkingSpaces');

    Future<List<String>> fetchParkingSpaceNames() {
      return parkingSpacesRef.get().then((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => doc.get('name') as String)
            .toList();
      });
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xfff6dccb),
                Colors.white12,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 70),
                Image.asset('assets/logo-transparent.png'),
                const SizedBox(height: 60),
                const Text(
                  'List of Parking Spaces:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder<List<String>>(
                    future: fetchParkingSpaceNames(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final names = snapshot.data!;

                        return ListView.builder(
                          itemCount: names.length,
                          itemBuilder: (context, index) {
                            String name = names[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              // Add space between the tiles
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to another widget
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ParkingBookingScreen(name),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        const Color(0xffa45f24)
                                            .withOpacity(0.5),
                                        Colors.blue.shade200,
                                      ],
                                    ),
                                    color: const Color(0xffa45f24)
                                        .withOpacity(0.5),
                                    border: Border.all(
                                      color: Colors.blueGrey,
                                      width: 0.07,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.blueGrey.withOpacity(0.05),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Text(name),
                                    trailing: const Icon(Icons.arrow_right),
                                    visualDensity:
                                        const VisualDensity(vertical: -3),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomDashboardScreen(currentIndex: 0),
      ),
    );
  }
}
