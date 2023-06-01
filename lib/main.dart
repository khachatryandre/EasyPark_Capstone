import 'package:capstone_project/parking_space/parking_booking.dart';
import 'package:capstone_project/parking_space/parking_cancellation.dart';
import 'package:capstone_project/settings/payment.dart';
import 'package:capstone_project/settings/profile.dart';
import 'package:capstone_project/settings/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'admin/admin-page.dart';
import 'parking_space/parking_history.dart';
import 'active_reservation/active_reservations.dart';
import 'home/home_page.dart';
import 'login_registration/user_login.dart';
import 'login_registration/user_registration.dart';
import 'login_registration/welcome_page.dart';
import 'settings/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runApp(MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking Reservation App',
      theme: ThemeData(
        primaryColor: Colors.lightBlue[800],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/user-login': (context) => UserLoginScreen(),
        '/admin': (context) => AdminScreen(),
        '/user-registration': (context) => UserRegistrationScreen(),
        '/profile': (context) => ProfileScreen(),
        '/parking-history': (context) => ParkingHistoryScreen(),
        '/parking-booking': (context) => ParkingBookingScreen("Null"),
        '/parking-cancellation': (context) => ParkingCancellationScreen(),
        '/active-reservations': (context) => ActiveReservationsScreen(),
        '/settings': (context) => SettingsScreen(),
        '/home': (context) => HomePage(),
        '/forgot-password': (context) => ForgotPassword(),
        '/payment': (context) => PaymentScreen(),
        '/update-profile': (context) => UpdateProfileScreen(),
        '/language': (context) => LanguageList(),
        '/top-up': (context) => TopUpAccountScreen(),
      },
    );
  }
}
