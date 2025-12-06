import 'package:expenzes/utils/exceptions/app_exceptions.dart';
import 'package:expenzes/utils/messages/app_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthServices {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //google sign in method
  Future<void> googleSignInMethord(BuildContext context) async {
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        AppMessages().showSnackBarMessage(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          context: context,
          message: "Signed in with Google unsuccessfully!",
        );
        return;
      }

      final GoogleSignInAuthentication authAcc = await account.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authAcc.accessToken,
        idToken: authAcc.idToken,
      );

      await firebaseAuth.signInWithCredential(credential);

      AppMessages().showSnackBarMessage(
        context: context,
        message: "Signed in with Google successfully!",
      );
    } on FirebaseAuthException catch (e) {
      AppMessages().showSnackBarMessage(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        context: context,
        message: "Signed in with Google unsuccessfully!",
      );
    } catch (error) {
      AppMessages().showSnackBarMessage(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        context: context,
        message: "Signed in with Google unsuccessfully!",
      );
    }
  }

  // get currunt user
  User get curruntUserData => firebaseAuth.currentUser!;

  //login using email and password
  Future<void> loginWIthEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      AppMessages().showSnackBarMessage(
        context: context,
        message: "Welcome back 👋 Login successful!",
      );
    } on FirebaseAuthException catch (e) {
      print(FirebaseAuthException(code: e.code));
      AppMessages().showSnackBarMessage(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        context: context,
        message: "Login failed",
      );
    } catch (error) {
      print(error.toString());
    }
  }

  //log out
  Future<void> logOutAccount({required BuildContext context}) async {
    try {
      await firebaseAuth.signOut();
      AppMessages().showSnackBarMessage(
        context: context,
        message: "You are now signed out",
      );
    } on FirebaseAuthException catch (error) {
      print(FirebaseAuthException(code: error.code));
      AppMessages().showSnackBarMessage(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        context: context,
        message: "Sign out failed. Please try again",
      );
    } catch (e) {
      print(e.toString());
    }
  }

  //Register user with email & password
  Future<void> registerEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppMessages().showSnackBarMessage(
        context: context,
        message: "Welcome aboard! Your registration is complete",
      );
    } on FirebaseAuthException catch (error) {
      print(FirebaseAuthException(code: error.code));
      AppMessages().showSnackBarMessage(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        context: context,
        message: "Registration failed. Please try again",
      );
      throw exceptions(error.code);
    } catch (e) {
      print(e.toString());
    }
  }

  //login as a annonymus
  Future<void> logAsAnnonymus({required BuildContext context}) async {
    try {
      await firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (error) {
      print(FirebaseAuthException(code: error.code));
      throw exceptions(error.code);
    } catch (e) {
      print(e.toString());
      AppMessages().showSnackBarMessage(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        context: context,
        message: "Anonymous sign-in failed",
      );
    }
  }
}
