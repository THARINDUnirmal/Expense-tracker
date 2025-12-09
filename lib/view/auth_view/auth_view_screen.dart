// import 'package:expenzes/services/auth/firebase_auth_services.dart';
// import 'package:expenzes/view/screens/main_screen.dart';
// import 'package:expenzes/view/screens/onbording_screens/onbording_screen.dart';
// import 'package:flutter/material.dart';

// class AuthViewScreen extends StatefulWidget {
//   const AuthViewScreen({super.key});

//   @override
//   State<AuthViewScreen> createState() => _AuthViewScreenState();
// }

// class _AuthViewScreenState extends State<AuthViewScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseAuthServices.firebaseAuth.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasData) {
//           return MainScreen();
//         } else {
//           return OnbordingScreen();
//         }
//       },
//     );
//   }
// }

import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/view/screens/main_screens/home_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/onbording_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewScreen extends StatefulWidget {
  const AuthViewScreen({super.key});

  @override
  State<AuthViewScreen> createState() => _AuthViewScreenState();
}

class _AuthViewScreenState extends State<AuthViewScreen> {
  bool? hasSeenOnboarding;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hasSeenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loader until SharedPreferences is loaded
    if (hasSeenOnboarding == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder(
      stream: FirebaseAuthServices.firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // User is logged in → go to MainScreen
          return HomeScreen();
        } else {
          // User is not logged in → decide between onboarding or login
          return hasSeenOnboarding! ? LoginScreen() : OnbordingScreen();
        }
      },
    );
  }
}
