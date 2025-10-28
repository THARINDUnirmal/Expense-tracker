import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/widgets/reuseble_widgets/add_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddDataScreen extends StatelessWidget {
  const AddDataScreen({super.key});

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
                    GoRouter.of(context).push("/AddScreen", extra: false);
                  },
                  child: AddCardWidget(
                    cardTitle: "Add Incomes",
                    cardSvgUrl: "assets/icons/Expeses.svg",
                    cardColor: AppColors.appBlue2Color,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push("/AddScreen", extra: true);
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
