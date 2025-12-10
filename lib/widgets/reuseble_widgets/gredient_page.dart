import 'package:expenzes/utils/app_colors.dart';
import 'package:flutter/material.dart';

class GredientPage extends StatelessWidget {
  final Widget childWidget;
  const GredientPage({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 1,
      decoration: BoxDecoration(gradient: AppColors.backgroudColor),
      child: childWidget,
    );
  }
}
