import 'package:flutter/material.dart';

class ModernGredientCard extends StatelessWidget {
  final String cardTitle;
  final Gradient cardGradient;
  final IconData cardIcon;
  const ModernGredientCard({
    super.key,
    required this.cardTitle,
    required this.cardGradient,
    required this.cardIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.41,
      height: 105,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: cardGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(cardIcon, size: 30, color: Colors.white),
            SizedBox(height: 6),
            Text(
              cardTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
