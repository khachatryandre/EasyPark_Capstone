import 'package:capstone_project/Databases/user/parking_reservation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String name;
  final String phone;
  final String email;
  final String password;
  int? credits;
  static List<ParkingReservation> activeReservations = [];

  User(this.name, this.phone, this.email, this.password);
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(fullName, phone, email, password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }


  String? getUserName() {
    return FirebaseAuth.instance.currentUser?.displayName;
  }

  String? getUserEmail() {
    return FirebaseAuth.instance.currentUser?.displayName;
  }

  String? getUserID() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static Future<int> getUserCredits() async{
    final users = await FirebaseFirestore.instance.collection('users').doc('users').get();
      return users.data()?['credits'] as int;
      }




}