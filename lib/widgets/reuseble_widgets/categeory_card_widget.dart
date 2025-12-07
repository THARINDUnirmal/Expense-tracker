import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:expenzes/utils/app_colors.dart';

class CategoryCardWidget extends StatelessWidget {
  final String title;
  const CategoryCardWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 160,
      height: 90,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Blur + Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.appBlueColor.withOpacity(0.6),
                    AppColors.appGreyColor.withOpacity(0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(),
              ),
            ),

            // Title
            Positioned(
              top: 18,
              left: 16,
              child: SizedBox(
                width: 100,
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Circle Arrow Button
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.appYellowColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
