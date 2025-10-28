import 'package:expenzes/view/screens/auth_view/auth_view_screen.dart';
import 'package:expenzes/view/screens/main_screen.dart';
import 'package:expenzes/view/screens/sub_screens/add_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/login/login_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/login/register_screen.dart';
import 'package:expenzes/view/screens/sub_screens/eddit_profile_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static GoRouter route = GoRouter(
    initialLocation: "/",
    routes: [
      //Login Route
      GoRoute(path: "/", builder: (context, state) => AuthViewScreen()),
      GoRoute(path: "/LoginScreen", builder: (context, state) => LoginScreen()),
      GoRoute(path: "/MainScreen", builder: (context, state) => MainScreen()),
      GoRoute(path: "/AddScreen", builder: (context, state) => AddScreen()),
      GoRoute(
        path: "/RegisterScreen",
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: "/EdditProfileScreen",
        builder: (context, state) => EdditProfileScreen(),
      ),
    ],
  );
}
