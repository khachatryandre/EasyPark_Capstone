import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../dashboard/bottom.dart';

class ProfileScreen extends StatelessWidget {
  Future<int?> getCredits() async {
    final users =
        await FirebaseFirestore.instance.collection('users').doc('users').get();
    return users.data()?['credits'] as int;
  }

  @override
  Widget build(BuildContext context) {
    final double paddingValue = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          children: [
            Text(
              'Profile',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(paddingValue),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FirebaseAuth.instance.currentUser?.photoURL != null
                    ? Image.network(
                        FirebaseAuth.instance.currentUser?.photoURL ??
                            'assets/user-logo.jpg')
                    : Image.asset('assets/user-logo.jpg'),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText:
                      FirebaseAuth.instance.currentUser?.displayName ?? "Name",
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: FirebaseAuth.instance.currentUser?.phoneNumber ??
                      "Phone Number",
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: FirebaseAuth.instance.currentUser?.email ??
                      "Email address",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.black,
                  ),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: const Text(
                              "Your cards",
                              style: TextStyle(fontSize: 25),
                            ),
                            content: Container(
                              height: 70,
                              child: Column(
                                children: [
                                  const Text("VISA Card ****9481"),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/payment');
                                      },
                                      child: const Text("Add card")),
                                ],
                              ),
                            ));
                      });
                },
                child: const Text("Cards"),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/update-profile');
                },
                child: const Text('Update profile'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomDashboardScreen(currentIndex: 2),
    );
  }
}
