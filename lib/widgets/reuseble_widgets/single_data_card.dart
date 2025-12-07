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
    final Color typeColor = isExpense ? Colors.redAccent : Colors.teal;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border(top: BorderSide(color: typeColor, width: 5)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 220,
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      "Rs. $cardAmount",
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(
                            fontWeight: FontWeight.bold,
                            color: typeColor,
                          ),
                    ),
                  ],
                ),

                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: typeColor.withOpacity(0.15),
                  ),
                  child: Center(
                    child: Icon(
                      isExpense
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: typeColor,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
