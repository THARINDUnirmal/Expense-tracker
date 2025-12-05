import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddCardModern extends StatelessWidget {
  final String title;
  final String svgPath;
  final bool isExpense;

  const AddCardModern({
    super.key,
    required this.title,
    required this.svgPath,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: isExpense
              ? [
                  const Color(0xFFFFA953), // orange gradient
                  const Color(0xFFFF7A32),
                ]
              : [
                  const Color(0xFF4A90E2), // blue gradient
                  const Color(0xFF50C9C3),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
              width: 34,
              height: 34,
              color: Colors.white,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
