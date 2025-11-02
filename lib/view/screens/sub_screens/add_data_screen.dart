import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddDataScreen extends StatefulWidget {
  final bool isExpense;
  const AddDataScreen({super.key, required this.isExpense});

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(AppConstants.appPadding),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                child: RichText(
                  text: TextSpan(
                    text: "Add Your\n",
                    style: TextStyle(
                      fontSize: 40,
                      color: AppColors.appBlackColor,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: widget.isExpense ? "Expences" : "Incomes",
                        style: TextStyle(
                          fontSize: 40,
                          color: widget.isExpense
                              ? Color.fromARGB(255, 237, 89, 81)
                              : AppColors.appGreenColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.appBlueColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.appPadding + 5,
                  vertical: AppConstants.appPadding * 2,
                ),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expenses",
                      style: AppTextStyles.mainTopicTextStyle.copyWith(
                        color: AppColors.appWhiteColor,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
