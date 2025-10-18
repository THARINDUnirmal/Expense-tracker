import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppMessages {
  void appMessage(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 20),
                SvgPicture.asset(
                  "assets/icons/triangle-alert.svg",
                  width: 40,
                  colorFilter: ColorFilter.mode(
                    AppColors.appRedColor,
                    BlendMode.srcIn,
                  ),
                ),

                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    message,
                    style: AppTextStyles.subTopicTextStyle,
                  ),
                ),

                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    backgroundColor: AppColors.appBlueColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      "Ok",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.appWhiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
