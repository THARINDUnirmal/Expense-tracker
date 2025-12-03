import 'package:expenzes/utils/app_colors.dart';
import 'package:flutter/material.dart';

class FinanceMateScreen extends StatefulWidget {
  const FinanceMateScreen({super.key});

  @override
  State<FinanceMateScreen> createState() => _FinanceMateScreenState();
}

class _FinanceMateScreenState extends State<FinanceMateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Finance page")),
      body: Column(
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 3),
            width: 200,
            height: 200,
            curve: Curves.linear,
            decoration: BoxDecoration(color: AppColors.appSheetRedColor),
            transformAlignment: Alignment(8, 10),
          ),
        ],
      ),
    );
  }
}
