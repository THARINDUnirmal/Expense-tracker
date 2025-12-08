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
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          textAlign: TextAlign.center,
          content,
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
