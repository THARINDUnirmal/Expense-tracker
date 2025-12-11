import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:expenzes/view/screens/main_screens/add_screen.dart';
import 'package:expenzes/view/screens/main_screens/home_screen.dart';
import 'package:expenzes/view/screens/main_screens/user_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex; // NEW
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _curruntIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _curruntIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
            _curruntIndex = value;
            _pageController.jumpToPage(value);
          });
        },
        items: const [
          Icon(Icons.home, size: 22),
          Icon(Icons.add_circle, size: 22),
          Icon(Icons.person, size: 22),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() => _curruntIndex = value);
        },
        children: const [HomeScreen(), AddScreen(), UserScreen()],
      ),
    );
  }
}
