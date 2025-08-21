import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/login-siginup/global/common/toast.dart';


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart'; // Ensure you have this imported

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(context, message: 'The email address is already in use.');
      } else if (e.code == 'invalid-email') {
        showToast(context, message: 'The email address is not valid.');
      } else if (e.code == 'weak-password') {
        showToast(context, message: 'The password is too weak.');
      } else {
        showToast(context, message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(context, message: 'Invalid email or password.');
      } else if (e.code == 'invalid-email') {
        showToast(context, message: 'The email address is not valid.');
      } else {
        showToast(context, message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  void showToast(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
