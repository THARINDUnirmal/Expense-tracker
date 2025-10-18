import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SmallCardWidget extends StatelessWidget {
  final String svgImage;
  const SmallCardWidget({super.key, required this.svgImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.grey.withOpacity(0.5),
            offset: Offset(15, 10),
          ),
          BoxShadow(blurRadius: 1, color: Colors.white, offset: Offset(0, 0)),
        ],
      ),
      child: Center(child: SvgPicture.asset(svgImage, width: 30)),
    );
  }
}
