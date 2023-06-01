import 'package:capstone_project/main.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Databases/user/user.dart' as DBUser;

class UserRegistrationScreen extends StatefulWidget {
  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isSignUpButtonEnabled = false;
  bool isEmailValid = true;

  String selectedCountryCode = '+374'; // Default country code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        elevation: 1,
        backgroundColor: Colors.black,
        leading: BackButton(
          onPressed: () => Navigator.pushNamed(context, '/'),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: Center(
                    child: Image.asset('assets/logo-transparent.png'),
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  onChanged: (value) {
                    setState(() {
                      isSignUpButtonEnabled = value.isNotEmpty &&
                          phoneController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          isEmailValid;
                    });
                  },
                ),
                Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (value) {
                        setState(() {
                          selectedCountryCode = value.dialCode!;
                        });
                      },
                      initialSelection: selectedCountryCode,
                      showCountryOnly: false,
                      showFlagDialog: true,
                      favorite: const [
                        '+1',
                        '+91'
                      ], // Add your favorite country codes
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                        ),
                        onChanged: (value) {
                          setState(() {
                            isSignUpButtonEnabled =
                                nameController.text.isNotEmpty &&
                                    value.isNotEmpty &&
                                    emailController.text.isNotEmpty &&
                                    isEmailValid;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  onChanged: (value) {
                    setState(() {
                      isEmailValid = isValidEmail(value);
                      isSignUpButtonEnabled = nameController.text.isNotEmpty &&
                          phoneController.text.isNotEmpty &&
                          value.isNotEmpty &&
                          isEmailValid;
                    });
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      isSignUpButtonEnabled = value.isNotEmpty &&
                          phoneController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          isEmailValid;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: isSignUpButtonEnabled
                        ? MaterialStatePropertyAll(
                            const Color(0xff8bc315).withOpacity(0.5),
                          )
                        : const MaterialStatePropertyAll(null),
                  ),
                  onPressed: isSignUpButtonEnabled
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Registration Successful'),
                                content: const Text(
                                    'Please check your email for verification.'),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      var acs = ActionCodeSettings(
                                          // URL you want to redirect back to. The domain (www.example.com) for this
                                          // URL must be whitelisted in the Firebase Console.
                                          url:
                                              'https://www.example.com/finishSignUp?cartId=1234',
                                          // This must be true
                                          handleCodeInApp: true,
                                          androidPackageName:
                                              'com.example.android',
                                          // installIfNotAvailable
                                          androidInstallApp: true,
                                          // minimumVersion
                                          androidMinimumVersion: '12');
                                      var emailAuth = emailController.text;
                                      FirebaseAuth.instance
                                          .sendSignInLinkToEmail(
                                              email: emailAuth,
                                              actionCodeSettings: acs)
                                          .catchError((onError) => print(
                                              'Error sending email verification $onError'))
                                          .then((value) => print(
                                              'Successfully sent email verification'));
                                      DBUser.User user = DBUser.User(
                                          nameController.text,
                                          phoneController.text,
                                          emailController.text,
                                          passwordController.text);
                                      user.addUser(
                                        nameController.text,
                                        phoneController.text,
                                        emailController.text,
                                        passwordController.text,
                                      );
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyApp()),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      : null,
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          )),
    );
  }

  // Add your email validation logic here
  bool isValidEmail(String email) {
    const pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }
}
