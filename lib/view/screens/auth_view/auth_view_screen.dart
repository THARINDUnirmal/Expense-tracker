import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/view/screens/main_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/login/login_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/login/onbording_screen.dart';
import 'package:flutter/material.dart';

class AuthViewScreen extends StatefulWidget {
  const AuthViewScreen({super.key});

  @override
  State<AuthViewScreen> createState() => _AuthViewScreenState();
}

class _AuthViewScreenState extends State<AuthViewScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuthServices.firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return MainScreen();
        } else {
          return OnbordingScreen();
        }
      },
    );
  }
}
