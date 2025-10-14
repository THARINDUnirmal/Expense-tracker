import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:expenzes/screens/main_screens/home_screen.dart';
import 'package:expenzes/screens/main_screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int curruntIndex = 0;
  List<Widget> pageList = [HomeScreen(), UserScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: curruntIndex,
        onTap: (value) {
          setState(() {
            curruntIndex = value;
          });
        },
        items: [
          SvgPicture.asset("assets/icons/house.svg"),

          SvgPicture.asset("assets/icons/user.svg"),
        ],
      ),
      body: pageList[curruntIndex],
    );
  }
}
