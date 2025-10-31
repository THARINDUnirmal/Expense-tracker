import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PageViewContent extends StatelessWidget {
  final String lottieAnimation;
  final String title;
  final String content;

  const PageViewContent({
    super.key,

    required this.lottieAnimation,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 150),
        Lottie.asset(lottieAnimation),
        Text(title, style: AppTextStyles.mainTopicTextStyle),
        Text(
          textAlign: TextAlign.center,
          content,
          style: AppTextStyles.subTopicTextStyle,
        ),
      ],
    );
  }
}
