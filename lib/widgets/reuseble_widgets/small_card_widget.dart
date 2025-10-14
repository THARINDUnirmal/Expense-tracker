import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SmallCardWidget extends StatelessWidget {
  final String svgImage;
  const SmallCardWidget({super.key, required this.svgImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.grey.withOpacity(0.5),
            offset: Offset(15, 15),
          ),
          BoxShadow(blurRadius: 1, color: Colors.white, offset: Offset(-5, 0)),
        ],
      ),
      child: Center(
        child: SvgPicture.asset(
          svgImage,
          width: MediaQuery.of(context).size.width * 0.085,
        ),
      ),
    );
  }
}
