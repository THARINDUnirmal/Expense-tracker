import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:expenzes/view/screens/main_screens/home_screen.dart';
import 'package:expenzes/view/screens/main_screens/user_screen.dart';
import 'package:expenzes/view/screens/main_screens/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  final int? index;
  const MainScreen({super.key, this.index});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _curruntIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        animationCurve: Curves.ease,
        height: 65,
        index: _curruntIndex,
        backgroundColor: Color(0xff73EC8B),
        onTap: (value) {
          setState(() {
            _pageController.jumpToPage(value);
          });
        },
        items: [
          Icon(FontAwesomeIcons.house, size: 22),
          Icon(FontAwesomeIcons.circlePlus, size: 22),
          Icon(FontAwesomeIcons.user, size: 22),
        ],
      ),
      body: PageView(
        onPageChanged: (value) {
          setState(() {
            _curruntIndex = value;
          });
        },
        controller: _pageController,
        children: [HomeScreen(), AddScreen(), UserScreen()],
      ),
    );
  }
}
