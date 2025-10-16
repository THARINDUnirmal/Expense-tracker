import 'package:expenzes/view/screens/auth_view/auth_view_screen.dart';
import 'package:expenzes/view/screens/main_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/login_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/register_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static GoRouter route = GoRouter(
    initialLocation: "/MainScreen",
    routes: [
      //Login Route
      GoRoute(path: "/", builder: (context, state) => AuthViewScreen()),
      GoRoute(path: "/LoginScreen", builder: (context, state) => LoginScreen()),
      GoRoute(path: "/MainScreen", builder: (context, state) => MainScreen()),
      GoRoute(
        path: "/RegisterScreen",
        builder: (context, state) => RegisterScreen(),
      ),
    ],
  );
}
