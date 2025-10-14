import 'package:expenzes/screens/main_screen.dart';
import 'package:expenzes/screens/onbording_screens/login_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static GoRouter route = GoRouter(
    initialLocation: "/",
    routes: [
      //Login Route
      GoRoute(path: "/", builder: (context, state) => LoginScreen()),
      GoRoute(path: "/MainScreen", builder: (context, state) => MainScreen()),
    ],
  );
}
