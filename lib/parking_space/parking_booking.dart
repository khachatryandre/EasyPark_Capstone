import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import '../../dashboard/bottom.dart';
import '../Databases/user/parking_reservation.dart';
import '../Databases/user/user.dart' as DBUser;
import '../active_reservation/active_reservations.dart';

// class ParkingBookingScreen extends StatefulWidget {
//   final String parkingSpaceName;
//
//   ParkingBookingScreen(this.parkingSpaceName);
//
//   @override
//   _ParkingBookingScreenState createState() => _ParkingBookingScreenState();
// }
//
// class _ParkingBookingScreenState extends State<ParkingBookingScreen> {
//   final TextEditingController startTimeController = TextEditingController();
//   bool reservationCompleted = false;
//   Future<List<Map<String, dynamic>>> getParkingLots() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('Parking Spaces')
//         .doc(widget.parkingSpaceName)
//         .collection('parkingLots')
//         .get();
//
//     final parkingLots = snapshot.docs.map((doc) => doc.data()).toList();
//     return parkingLots;
//   }
//
//   void getParkingLotsLength() async {
//     List<Map<String, dynamic>> parkingLots = await getParkingLots();
//     var parkingLotsLength = parkingLots.length;
//     //print('Parking Lots Length: $parkingLotsLength');
//   }
//   //final lots = getParkingLots();
//
//
//   @override
//   Widget build(BuildContext context) {
//     var lots = getParkingLots();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Parking Space"),
//         elevation: 1,
//         backgroundColor: Colors.black,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topRight,
//             end: Alignment.bottomLeft,
//             colors: [
//               Color(0xfff6dccb),
//               Colors.white12,
//             ],
//           ),
//         ),
//
//         child: ListView.builder(
//           itemCount:
//               ?.length, // Replace with the actual number of parking lots
//           itemBuilder: (context, index) {
//             final parkingLotName = 'Parking Lot ${index + 1}';
//             return LotElement(
//               value: parkingLotName,
//               parkingSpaceName: widget.parkingSpaceName,
//               available: true,
//             );
//           },
//         ),
//       ),
//       bottomNavigationBar: BottomDashboardScreen(currentIndex: 1),
//     );
//   }
// }

class ParkingBookingScreen extends StatefulWidget {
  final String parkingSpaceName;

  ParkingBookingScreen(this.parkingSpaceName);

  @override
  _ParkingBookingScreenState createState() => _ParkingBookingScreenState();
}

class _ParkingBookingScreenState extends State<ParkingBookingScreen> {
  Future<List<dynamic>> getParkingLots() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Parking Spaces')
        .doc(widget.parkingSpaceName)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      if (data.containsKey('lots')) {
        final lots = data['lots'] as List<dynamic>;
        return lots;
      }
    } else {
      // Handle case when the document doesn't exist
    }

    return []; // Return an empty list if 'lots' array is not found
  }
  Future<int?> getCredits() async {
    final users =
    await FirebaseFirestore.instance.collection('users').doc('users').get();
    return users.data()?['credits'] as int;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Text(
              widget.parkingSpaceName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: <Widget>[
          Center(
            child: FutureBuilder<int?>(
                future: getCredits(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final credits = snapshot.data!;
                    return Text(
                      "$credits credits",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                }),
          )
        ],
      ),
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
        child: FutureBuilder<List<dynamic>>(
          future: getParkingLots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              final parkingLots = snapshot.data!;
              print(parkingLots.length);
              for (var item in parkingLots) {
                print(item);
              }
              return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  final parkingLotName = "Parking Lot ${index + 1}";

                  return LotElement(
                      value: parkingLotName,
                      parkingSpaceName: widget.parkingSpaceName,
                      available: true,
                      child: ListTile(
                        leading: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                        title: Text(parkingLotName),
                        trailing: const Icon(Icons.arrow_right),
                      ));
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return const Center(
                child: Text('No data available'),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: const BottomDashboardScreen(currentIndex: 1),
    );
  }
}

class LotElement extends StatefulWidget {
  final String value;
  final String parkingSpaceName;
  final bool available;
  final TextEditingController durationController =
      TextEditingController(text: '');
  int credits = 0;

  LotElement({
    Key? key,
    required this.value,
    required this.parkingSpaceName,
    required this.available,
    required ListTile child,
  }) : super(key: key);

  @override
  State<LotElement> createState() => _LotElementState();
}

class _LotElementState extends State<LotElement> {
  final int hourlyRate = 100;
  DateTime selectedTime = DateTime.now();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void getCredits(int hour) {
    setState(() {
      widget.credits = hour * hourlyRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.black, width: 0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.05),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: InkWell(
          onTap: widget.available
              ? () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xfff6dccb),
                              Colors.white,
                            ],
                          ),
                        ),
                        child: AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Nearest Available Time: 12:00 PM',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Text('Start Time:'),
                                  TimePickerSpinner(
                                    itemHeight:
                                        MediaQuery.of(context).size.height *
                                            0.039,
                                    is24HourMode: true,
                                    onTimeChange: (time) {
                                      setState(() {
                                        selectedTime = time;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              Row(
                                children: [
                                  const Text('Duration'),
                                  const SizedBox(
                                    width: 42,
                                  ),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2)),
                                    child: TextFormField(
                                      controller: widget.durationController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(2)
                                      ],
                                      onChanged: (value) {
                                        getCredits(int.parse(value));
                                      },
                                    ),
                                  ),
                                  const Text("hours"),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text("Cost: ${widget.credits} credits")
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                alignment: Alignment.center,
                                child: Container(
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
                                  child: ElevatedButton(
                                    child: const Text('Book Now'),
                                    onPressed: () async {
                                      int userCredits = 2;
                                      try {
                                        final users = await FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc('users')
                                            .get();
                                        final data = users.data();
                                        userCredits = data?['credits'];
                                      } catch (e) {
                                        print("Exception Occurred");
                                      }
                                      if (widget.credits <= userCredits) {
                                        final users = await FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc('users')
                                            .get();
                                        final data = users.data();
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc('users')
                                            .update({
                                          'credits': data?['credits'] -
                                              widget.credits
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              elevation: 1,
                                              title: const Text(
                                                "Your reservation has been made",
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: const Text('OK'),
                                                  onPressed: () {
                                                    DBUser.User
                                                        .activeReservations
                                                        .add(
                                                            ParkingReservation(
                                                      widget.parkingSpaceName,
                                                      int.parse(widget.value
                                                          .substring(12)),
                                                      selectedTime,
                                                    ));
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ActiveReservationsScreen(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                "You don't have enough balance",
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: null,
                                                    child: Text("OK"))
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              : () {
                  if (DBUser.User.getUserCredits() == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Your balance is 0, please top up your balance")));
                  }
                },
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                widget.value,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
              ),
            ),
            const Spacer(),
            const IconButton(
                onPressed: null, icon: Icon(Icons.arrow_right_outlined))
          ]),
        ),
      ),
    );
  }
}
