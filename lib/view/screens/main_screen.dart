import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:expenzes/view/screens/main_screens/home_screen.dart';
import 'package:expenzes/view/screens/main_screens/user_screen.dart';
import 'package:expenzes/view/screens/main_screens/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: _curruntIndex,
        backgroundColor: Color(0xff73EC8B),
        onTap: (value) {
          setState(() {
            _pageController.jumpToPage(value);
          });
        },
        items: [
          SvgPicture.asset("assets/icons/house.svg"),
          SvgPicture.asset("assets/icons/circle-plus.svg"),
          SvgPicture.asset("assets/icons/user.svg"),
        ],
      ),
      body: PageView(
        onPageChanged: (value) {
          setState(() {
            _curruntIndex = value;
          });
        },
        controller: _pageController,
        children: [UserScreen(), HomeScreen(), AddScreen()],
      ),
    );
  }
}
