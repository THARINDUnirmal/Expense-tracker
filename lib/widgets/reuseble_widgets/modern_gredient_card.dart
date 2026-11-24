import 'package:expenzes/utils/app_colors.dart';
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
      width: MediaQuery.sizeOf(context).width * .41,
      height: 112,
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.appGreenColor.withOpacity(.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(cardIcon, size: 28, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            cardTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
