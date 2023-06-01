import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../dashboard/bottom.dart';


import '../login_registration/user_login.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0.2,
        backgroundColor: Colors.black,
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
            )),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SettingElement(
                value: 'Profile',
                path: '/profile',
              ),
              const SettingElement(
                value: 'Language',
                path: '/language',
              ),
              const SettingElement(
                value: 'Top up Account',
                path: '/top-up',
              ),
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 55),
                  child: TextButton(
                    onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        await UserLoginScreen.googleSignIn.signOut();
                        Navigator.pushNamed(context, '/');
                    },
                    child: const Text(
                      'Log out',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                          fontSize: 20),
                    ),
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomDashboardScreen(currentIndex: 2),
    );
  }
}

class SettingElement extends StatelessWidget {
  final String value;
  final String path;

  const SettingElement({
    Key? key,
    required this.value,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.black38,
              Color(0xff194aa4).withOpacity(0.5),
            ],
          ),
          color: const Color(0xffa45f24).withOpacity(0.5),
          border:
          Border.all(color: Colors.blueGrey, width: 0.07),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.05),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(
                  0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, path);
            },
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  value,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, path);
                  },
                  icon: const Icon(Icons.arrow_right_outlined))
            ]),
          ),
        ),
      ),
    );
  }
}

class LanguageList extends StatefulWidget {
  @override
  _LanguageListState createState() => _LanguageListState();
}

class _LanguageListState extends State<LanguageList> {
  String selectedLanguage = 'English';

  List<String> languages = [
    'English',
    'Armenian',
    'Russian',
  ];

  Widget buildLanguageItem(String language) {
    return RadioListTile(
      title: Text(language),
      value: language,
      groupValue: selectedLanguage,
      activeColor: Color(0xffa45f24).withOpacity(0.5), // Set the active color for the icon
      onChanged: (value) {
        setState(() {
          selectedLanguage = value.toString();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Language'),
        elevation: 0.2,
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return buildLanguageItem(languages[index]);
        },
      ),
    );
  }
}




class TopUpAccountScreen extends StatelessWidget {

  TopUpAccountScreen({Key? key}) : super(key: key);
  final TextEditingController creditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Top up your account'),
          elevation: 0.2,
          backgroundColor: Colors.black,
        ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Please insert number of credits you want to add"),
            Center(
              child: Container(
                height: 60,
                width: 100,
                child: TextFormField(
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  cursorColor: Colors.black,
                  controller: creditController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                  },
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xffa45f24).withOpacity(0.5)),
              ),
                onPressed: () async {
                  final users = await
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc('users')
                      .get();
                  final data = users.data();

                  FirebaseFirestore.instance.collection('users').doc('users').update({'credits':int.parse(creditController.text)+data?['credits']});
                  showDialog(
                      context: context,
                      builder: (context) {
                        return  AlertDialog(
                          title: const Text("Payment done successfully",),
                          actions: [
                            TextButton(
                              onPressed: () { Navigator.pushNamed(context, '/home');
                              }, child: Text("Ok"),


                            )
                          ],

                        );
                      });
                },
                child: const Text("Submit")
            )
          ],
        ),
      )
    );
  }
}
