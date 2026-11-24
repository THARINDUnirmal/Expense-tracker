import 'package:expenzes/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SingleDataCard extends StatelessWidget {
  final String title;
  final bool isExpense;
  final double cardAmount;

  const SingleDataCard({
    super.key,
    required this.title,
    required this.isExpense,
    required this.cardAmount,
  });

  @override
  Widget build(BuildContext context) {
    final color = isExpense ? AppColors.expense : AppColors.income;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(.11),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              isExpense ? Icons.north_east_rounded : Icons.south_west_rounded,
              color: color,
              size: 23,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${isExpense ? '-' : '+'} Rs. ${cardAmount.toStringAsFixed(2)}',
            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
