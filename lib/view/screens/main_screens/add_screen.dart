import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/view/screens/sub_screens/add_data_screen.dart';
import 'package:expenzes/widgets/reuseble_widgets/add_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add", style: AppTextStyles.mainTopicTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.appPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddDataScreen(isExpense: false),
                      ),
                    );
                  },
                  child: AddCardWidget(
                    cardTitle: "Add Incomes",
                    cardSvgUrl: "assets/icons/Expeses.svg",
                    cardColor: AppColors.appBlue2Color,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddDataScreen(isExpense: true),
                      ),
                    );
                  },
                  child: AddCardWidget(
                    cardTitle: "Add Expenses",
                    cardSvgUrl: "assets/icons/income.svg",
                    cardColor: AppColors.appCream2Color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text("Last Added", style: AppTextStyles.mainTopicTextStyle),
            SizedBox(height: 50),
            Center(
              child: Text("No Items", style: AppTextStyles.subTopicTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}
