import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddCardWidget extends StatelessWidget {
  final String cardTitle;
  final String cardSvgUrl;
  final Color cardColor;

  const AddCardWidget({
    super.key,
    required this.cardTitle,
    required this.cardSvgUrl,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 100,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(cardSvgUrl, width: 30),
          SizedBox(height: 5),
          Text(
            cardTitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
