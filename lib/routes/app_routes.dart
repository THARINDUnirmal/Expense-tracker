import 'package:expenzes/view/auth_view/auth_view_screen.dart';
import 'package:expenzes/view/screens/main_screen.dart';
import 'package:expenzes/view/screens/main_screens/add_screen.dart';
import 'package:expenzes/view/screens/main_screens/home_screen.dart';
import 'package:expenzes/view/screens/main_screens/user_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/login/login_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/login/register_screen.dart';
import 'package:expenzes/view/screens/sub_screens/add_data_screen.dart';
import 'package:expenzes/view/screens/sub_screens/eddit_profile_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _navigatorState = GlobalKey<NavigatorState>();

class AppRoutes {
  static GoRouter route = GoRouter(
    navigatorKey: _navigatorState,
    initialLocation: "/",
    routes: [
      // StatefulShellRoute.indexedStack(
      //   builder: (context, state, navigationShell) => MainScreen(),
      //   branches: [
      //     StatefulShellBranch(
      //       routes: [
      //         GoRoute(
      //           path: "/MainScreen",
      //           builder: (context, state) => MainScreen(),
      //           routes: [
      //             GoRoute(
      //               path: "HomeScreen",
      //               builder: (context, state) => HomeScreen(),
      //             ),
      //             GoRoute(
      //               path: "AddScreen",
      //               builder: (context, state) => AddScreen(),
      //               routes: [
      //                 GoRoute(
      //                   path: "AddDataScreen",
      //                   builder: (context, state) {
      //                     final bool value = state.extra! as bool;
      //                     return AddDataScreen(isExpense: value);
      //                   },
      //                 ),
      //               ],
      //             ),
      //             GoRoute(
      //               path: "ProfileScreen",
      //               builder: (context, state) => UserScreen(),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ],
      // ),

      //Login Route
      GoRoute(path: "/", builder: (context, state) => AuthViewScreen()),
      GoRoute(path: "/LoginScreen", builder: (context, state) => LoginScreen()),

      //Min screen route
      GoRoute(
        path: "/MainScreen",
        builder: (context, state) => MainScreen(),
        routes: [
          GoRoute(
            path: "HomeScreen",
            builder: (context, state) => HomeScreen(),
          ),

          GoRoute(
            path: "ProfileScreen",
            builder: (context, state) => UserScreen(),
          ),
        ],
      ),
      GoRoute(
        path: "/AddScreen",
        builder: (context, state) => AddScreen(),
        routes: [
          GoRoute(
            path: "AddDataScreen",
            builder: (context, state) {
              final bool value = state.extra! as bool;
              return AddDataScreen(isExpense: value);
            },
          ),
        ],
      ),
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
