import 'package:expenzes/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  const CustomButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      width: 300,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.appBlueColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
