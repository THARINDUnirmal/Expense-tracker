import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:expenzes/view/screens/main_screens/home_screen.dart';
import 'package:expenzes/view/screens/main_screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends StatefulWidget {
  final int? index;
  const MainScreen({super.key, this.index});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> pageList = [HomeScreen(), UserScreen()];
  int curruntIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xff73EC8B),
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
