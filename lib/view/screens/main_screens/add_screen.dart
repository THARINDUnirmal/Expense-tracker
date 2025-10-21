import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Placeholder(
              child: Container(
                padding: EdgeInsets.all(AppConstants.appPadding),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                child: RichText(
                  text: TextSpan(
                    text: "Add Your\n",
                    style: TextStyle(
                      fontSize: 40,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "Expences",
                        style: TextStyle(
                          fontSize: 40,
                          color: Color.fromARGB(255, 237, 89, 81),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Placeholder(
              child: Container(
                padding: EdgeInsets.all(AppConstants.appPadding),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Expenses", style: AppTextStyles.mainTopicTextStyle),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
