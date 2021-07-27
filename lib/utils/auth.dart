import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopping_app/authenticate.dart';
import 'package:shopping_app/home.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String err = "";
  // Stream<User?> get user {
  //   return _auth.authStateChanges();
  //   // return FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //   //   if (user == null) {
  //   //     Authenticate();
  //   //   } else {
  //   //     Home();
  //   //   }
  //   // });
  // }
  //AuthService(this._auth);

  Stream<User?> get userState => _auth.authStateChanges();

  var userId;

  String getUser() {
    User? user = _auth.currentUser;
    userId = user!.uid;
    return userId.toString();
  }

  Future signUp(String email, String pass) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: pass);
      print(userCredential.user?.uid);
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        err = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        err = 'The account already exists for that email.';
      }
    } catch (e) {
      err = e.toString();
    }
  }

  Future signIn(String email, String pass) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      print(userCredential.user);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') err = "Email Id format is incorrect";
      if (e.code == 'user-not-found') {
        err =
            "Account does not exist, Please create a new account or Sign Up with Google";
      }
      if (e.code == 'wrong-password')
        err =
            'The password entered is incorrect, if you want to reset password click on Forgot Password';
    } catch (e) {
      err = e.toString();
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }

  Future signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      dynamic userCred = await _auth.signInWithCredential(credential);
      // Once signed in, return the UserCredential
      print("==========================" +
          userCred.user.uid.toString() +
          "=================================");
      return userCred.user;
    } catch (e) {
      err = e.toString();
    }
  }
}
