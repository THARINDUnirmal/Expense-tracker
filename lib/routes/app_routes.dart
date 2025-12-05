import 'package:expenzes/view/auth_view/auth_view_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/login/reset_screen.dart';
import 'package:expenzes/view/screens/sub_screens/finance_mate_screen.dart';
import 'package:expenzes/view/screens/main_screen.dart';
import 'package:expenzes/view/screens/main_screens/add_screen.dart';
import 'package:expenzes/view/screens/main_screens/home_screen.dart';
import 'package:expenzes/view/screens/main_screens/user_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/login/login_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/login/register_screen.dart';
import 'package:expenzes/view/screens/sub_screens/add_data_screen.dart';
import 'package:expenzes/view/screens/sub_screens/eddit_profile_screen.dart';
import 'package:expenzes/view/screens/sub_screens/full_image_screen.dart';
import 'package:expenzes/view/screens/sub_screens/pie_chart_screen.dart';
import 'package:expenzes/view/screens/sub_screens/single_categeory_screen.dart';
import 'package:expenzes/view/screens/sub_screens/summary_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _navigatorState = GlobalKey<NavigatorState>();

class AppRoutes {
  static GoRouter route = GoRouter(
    navigatorKey: _navigatorState,
    initialLocation: "/",
    routes: [
      //Login Route
      GoRoute(path: "/", builder: (context, state) => AuthViewScreen()),
      GoRoute(path: "/LoginScreen", builder: (context, state) => LoginScreen()),
      GoRoute(path: "/ResetScreen", builder: (context, state) => ResetScreen()),

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
      GoRoute(
        path: "/FinanceMateScreen",
        builder: (context, state) => FinanceMateScreen(),
      ),
      GoRoute(
        path: "/FullImageScreen",
        builder: (context, state) {
          String userImage = state.extra as String;
          return FullImageScreen(imageUrl: userImage);
        },
      ),
      GoRoute(
        path: "/SummaryScreen",
        builder: (context, state) {
          Map<String, double> allData = state.extra as Map<String, double>;
          return SummaryScreen(allTotalData: allData);
        },
      ),
      GoRoute(
        path: "/PieChartScreen",
        builder: (context, state) {
          Map<String, double> allData = state.extra as Map<String, double>;
          return PieChartScreen(allTotalData: allData);
        },
      ),
      GoRoute(
        path: "/SingleCategeoryScreen",
        builder: (context, state) {
          String categeoryName = state.extra as String;
          return SingleCategeoryScreen(categeoryName: categeoryName);
        },
      ),
    ],
  );
}
