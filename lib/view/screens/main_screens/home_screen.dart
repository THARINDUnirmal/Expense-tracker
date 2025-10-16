import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.appPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Finance",
                      style: TextStyle(
                        fontSize: 30,
                        color: Color(0xfffdaa5d),
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: "Mate",
                          style: TextStyle(
                            fontSize: 30,
                            color: Color(0xff4ab7b6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffe8eff3),
                    ),
                    child: Icon(
                      Icons.notifications,
                      size: 30,
                      color: Color(0xffea7173),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        maxRadius: 40,
                        backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1557862921-37829c790f19?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzh8fHVzZXJ8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=600",
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Good Evening!",
                            style: AppTextStyles.miniTextStyle,
                          ),
                          Text(
                            "Tharindu Nirmal",
                            style: AppTextStyles.mainTopicTextStyle.copyWith(
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.keyboard_double_arrow_right, size: 30),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Weekly Expenses",
                        style: AppTextStyles.mainTopicTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "10 Expenses Pending",
                        style: AppTextStyles.subTopicTextStyle,
                      ),
                    ],
                  ),
                  Icon(Icons.add, size: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
