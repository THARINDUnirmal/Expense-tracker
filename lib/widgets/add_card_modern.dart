import 'package:expenzes/utils/app_colors.dart';
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
    final color = isExpense ? AppColors.expense : AppColors.income;
    return Container(
      width: MediaQuery.sizeOf(context).width * .41,
      height: 126,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.10),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: color.withOpacity(.11),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SvgPicture.asset(svgPath, color: color),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: color, size: 19),
            ],
          ),
        ],
      ),
    );
  }
}
