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
      print(exceptions(e.code));
    } catch (error) {
      print(error.toString());
    }
  }

  // get currunt user
  User get curruntUserData => firebaseAuth.currentUser!;

  //login using email and password
  Future<void> loginWIthEmail({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(FirebaseAuthException(code: e.code));
    } catch (error) {
      print(error.toString());
    }
  }

  //log out
  Future<void> logOutAccount() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (error) {
      print(FirebaseAuthException(code: error.code));
    } catch (e) {
      print(e.toString());
    }
  }

  //Register user with email & password
  Future<void> registerEmail({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      print(FirebaseAuthException(code: error.code));
      throw exceptions(error.code);
    } catch (e) {
      print(e.toString());
    }
  }

  //login as a annonymus
  Future<void> logAsAnnonymus() async {
    try {
      await firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (error) {
      print(FirebaseAuthException(code: error.code));
      throw exceptions(error.code);
    } catch (e) {
      print(e.toString());
    }
  }

  //reset password
  Future<void> resetPassword({required String userEmail}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: userEmail);
    } catch (error) {}
  }
}
