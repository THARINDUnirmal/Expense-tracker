import 'package:flutter/material.dart';

class AppColors {
  static Color appBlackColor = Colors.black;
  static Color appWhiteColor = Color(0xffe7f4fd);
  static Color appCreamColor = Color(0xffeeedf1);
  static Color appBlueColor = Color(0xff1d96e4);
  static Color appRedColor = Color(0xffFF2E63);
  static Color appBlue2Color = Color(0xfff3ebfe);
  static Color appGreenColor = Color(0xff08CB00);
  static Color appGreen2Color = Color(0xffE0FBE2);
  static Color appCream3Color = Color(0xffD6F4ED);
  static Color appCream2Color = Color.fromARGB(255, 255, 195, 177);

  //botosheet colors
  static const Color appSheetBlueColor = Color(0xff489eff);
  static const Color appSheetRedColor = Color(0xffff1b2b);
  static const Color appSheetBlackColor = Color(0xff00001c);
  //card colors
  static const Color appYellowColor = Color(0xffFEEE91);
  static const Color appGreyColor = Color(0xff91C4C3);
  static const Color appcardBlueColor = Color(0xFF4A90E2);

  //backgraound gredient color
  static const Gradient backgroudColor = LinearGradient(
    colors: [Color(0xFFB3E5FC), Color(0xFFFFF59D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
