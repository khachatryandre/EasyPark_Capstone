import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';
import 'package:capstone_project/Databases/user/user.dart' as DBUser;

class UserLoginScreen extends StatelessWidget {
  UserLoginScreen({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  static late int userIndex;
  static UserCredential? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Login'),
          elevation: 1,
          backgroundColor: Colors.black,
          leading: BackButton(
            onPressed: () => Navigator.pushNamed(context, '/'),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                    ),
                    child: Center(
                      child: Image.asset('assets/logo-transparent.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email/phone',
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      user = await signInWithGoogle();
                      if (user != null) {
                        Navigator.pushNamed(context, '/home');
                      } else {
                        // Handle sign-in failure
                      }
                    },
                    icon: const Icon(Icons.settings_accessibility_rounded),
                    label: const Text('Sign in with Google'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        const Color(0xff8bc315).withOpacity(0.5),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        user = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                        Navigator.pushNamed(context, '/home');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("No account with that email")));
                        } else if (e.code == 'wrong-password') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Wrong password provided for that user.')));
                        }
                      }
                    },
                    child: const Text(
                      'Sign In',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot-password');
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xff907de1)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/user-registration');
                    },
                    child: const Text('Sign Up',
                        style: TextStyle(
                          color: Color(0xff907de1),
                        )),
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      return userCredential;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isEmailWritten = false;
  bool isSignUpButtonEnabled = false;
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Reset Password"),
            elevation: 1,
            backgroundColor: Colors.black,
            leading: BackButton(
              color: Colors.white,
              onPressed: () => Navigator.pushNamed(context, '/user-login'),
            ),
          ),
          body: Center(
              child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xfff6dccb),
                Colors.white,
              ],
            )),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                const Text(
                  "Please enter your email",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  onChanged: (value) {
                    setState(() {
                      isSignUpButtonEnabled = isValidEmail(value);
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: isSignUpButtonEnabled
                        ? MaterialStatePropertyAll(
                            const Color(0xff8bc315).withOpacity(0.5),
                          )
                        : const MaterialStatePropertyAll(null),
                  ),
                  onPressed: isSignUpButtonEnabled
                      ? () => showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Password reset'),
                                content: const Text(
                                    'Please check your email for resetting your password.'),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
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
                          )
                      : null,
                  child: const Text("Reset password"),
                ),
              ]),
            ),
          ))),
    );
  }

  bool isValidEmail(String email) {
    const pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }
}

void wrongCredentials(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: SizedBox(
              height: 60,
              width: 120,
              child: Center(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]);
      });
}
