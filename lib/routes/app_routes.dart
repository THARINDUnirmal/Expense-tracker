import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/view/auth_view/auth_view_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/login/reset_screen.dart';
import 'package:expenzes/view/screens/sub_screens/about_me_image_screen.dart';
import 'package:expenzes/view/screens/sub_screens/all_categeory_screen.dart';
import 'package:expenzes/view/screens/sub_screens/empty_notifications_Screen.dart';
import 'package:expenzes/view/screens/sub_screens/about_me_screen.dart';
import 'package:expenzes/view/screens/main_screen.dart';
import 'package:expenzes/view/screens/main_screens/add_screen.dart';
import 'package:expenzes/view/screens/main_screens/user_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/login/login_screen.dart';
import 'package:expenzes/view/screens/onbording_screens/login/register_screen.dart';
import 'package:expenzes/view/screens/sub_screens/add_data_screen.dart';
import 'package:expenzes/view/screens/sub_screens/no_connection_screen.dart';
import 'package:expenzes/view/screens/sub_screens/single_data_screen.dart';
import 'package:expenzes/view/screens/sub_screens/user_profile_screen.dart';
import 'package:expenzes/view/screens/sub_screens/full_image_screen.dart';
import 'package:expenzes/view/screens/sub_screens/pie_chart_screen.dart';
import 'package:expenzes/view/screens/sub_screens/single_categeory_screen.dart';
import 'package:expenzes/view/screens/sub_screens/summary_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _navigatorState = GlobalKey<NavigatorState>();

class AppRoutes {
  static GoRouter route = GoRouter(
    errorBuilder: (context, state) => NoConnectionScreen(),
    navigatorKey: _navigatorState,
    initialLocation: "/",
    routes: [
      // Login routes
      GoRoute(path: "/", builder: (context, state) => AuthViewScreen()),
      GoRoute(path: "/LoginScreen", builder: (context, state) => LoginScreen()),
      GoRoute(path: "/ResetScreen", builder: (context, state) => ResetScreen()),
      GoRoute(
        path: "/RegisterScreen",
        builder: (context, state) => RegisterScreen(),
      ),

      // MainScreen with tab parameter
      GoRoute(
        path: "/MainScreen/:tab", // tab parameter: 0=Home, 1=Add, 2=User
        builder: (context, state) {
          final tab = int.tryParse(state.pathParameters['tab'] ?? '0') ?? 0;
          return MainScreen(initialIndex: tab);
        },
      ),

      // Other screens (example: AddScreen, ProfileScreen etc.)
      GoRoute(path: "/AddScreen", builder: (context, state) => AddScreen()),
      GoRoute(
        path: "/ProfileScreen",
        builder: (context, state) => UserScreen(),
      ),
      GoRoute(
        path: "/UserProfileScreen",
        builder: (context, state) => UserProfileScreen(),
      ),
      GoRoute(
        path: "/AboutMeScreen",
        builder: (context, state) => AboutMeScreen(),
      ),
      GoRoute(
        path: "/AboutMeImageScreen",
        builder: (context, state) {
          final image = state.extra as String;
          return AboutMeImageScreen(imageUrl: image);
        },
      ),
      GoRoute(
        path: "/SummaryScreen",
        builder: (context, state) {
          final allData = state.extra as Map<String, double>;
          return SummaryScreen(allTotalData: allData);
        },
      ),
      GoRoute(
        path: "/PieChartScreen",
        builder: (context, state) {
          final allData = state.extra as Map<String, double>;
          return PieChartScreen(allTotalData: allData);
        },
      ),
      GoRoute(
        path: "/AddDataScreen",
        builder: (context, state) {
          final isExpense = state.extra as bool;
          return AddDataScreen(isExpense: isExpense);
        },
      ),
      GoRoute(
        path: "/FullImageScreen",
        builder: (context, state) {
          final userImage = state.extra as String;
          return FullImageScreen(imageUrl: userImage);
        },
      ),
      GoRoute(
        path: "/SingleCategeoryScreen",
        builder: (context, state) {
          final categoryName = state.extra as String;
          return SingleCategeoryScreen(categeoryName: categoryName);
        },
      ),
      GoRoute(
        path: "/AllCtegeoryScreen",
        builder: (context, state) {
          final allCategory = state.extra as List<String>;
          return AllCategeoryScreen(categeoryList: allCategory);
        },
      ),
      GoRoute(
        path: "/NotificationScreen",
        builder: (context, state) => EmptyNotificationsScreen(),
      ),
      GoRoute(
        path: "/SingleDataScreen",
        builder: (context, state) {
          final data = state.extra as DataModel;
          return SingleDataScreen(singleData: data);
        },
      ),
    ],
  );
}
