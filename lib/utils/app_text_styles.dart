import 'package:expenzes/utils/app_colors.dart';
import 'package:flutter/widgets.dart';

class AppTextStyles {
  static TextStyle mainTopicTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.appBlackColor,
  );

  static TextStyle subTopicTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.appBlackColor.withOpacity(0.3),
  );

  static TextStyle miniTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.appBlackColor.withOpacity(0.5),
  );
}
