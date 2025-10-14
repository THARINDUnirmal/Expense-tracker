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
                  Row(
                    children: [
                      CircleAvatar(
                        maxRadius: 30,
                        backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=600",
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
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.notifications, size: 30),
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
                  IconButton(onPressed: () {}, icon: Icon(Icons.add, size: 30)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
