import 'package:expenzes/utils/app_colors.dart';
import 'package:flutter/material.dart';

/// Shared neutral canvas used by every screen for a consistent visual system.
class GredientPage extends StatelessWidget {
  final Widget childWidget;
  const GredientPage({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height,
      decoration: const BoxDecoration(gradient: AppColors.backgroudColor),
      child: childWidget,
    );
  }
}
