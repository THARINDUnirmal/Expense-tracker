import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final bool isLast;
  const CustomButton({super.key, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.appBlueColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          isLast ? "Login" : "Next",
          style: AppTextStyles.mainTopicTextStyle.copyWith(
            color: AppColors.appWhiteColor,
          ),
        ),
      ),
    );
  }
}
