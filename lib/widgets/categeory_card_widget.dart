import 'package:expenzes/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CategeoryCardWidget extends StatelessWidget {
  final String title;
  const CategeoryCardWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 150,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.appGreyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: AppColors.appYellowColor,
              ),
              child: Center(child: Icon(Icons.keyboard_arrow_right, size: 30)),
            ),
          ),
          Positioned(
            top: 10,
            left: 20,
            child: Text(
              title,
              style: TextStyle(
                color: const Color.fromARGB(255, 7, 7, 7),
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
