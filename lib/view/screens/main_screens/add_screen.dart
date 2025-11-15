import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/view/screens/sub_screens/add_data_screen.dart';
import 'package:expenzes/widgets/reuseble_widgets/add_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  User? curruntUser;

  @override
  void initState() {
    super.initState();
    userSet();
  }

  void userSet() {
    User? userData = FirebaseAuthServices().curruntUserData;
    setState(() {
      curruntUser = userData;
    });
  }

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
            FutureBuilder(
              future: FirebaseDatabaseServices().getAllData(
                curruntUserId: curruntUser!.uid,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      snapshot.error.toString(),
                      style: AppTextStyles.subTopicTextStyle,
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      "No Items",
                      style: AppTextStyles.subTopicTextStyle,
                    ),
                  );
                } else {
                  List<DataModel> allData = snapshot.data!;
                  return ListView.builder(
                    itemCount: allData.length,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DataModel singleData = allData[index];
                      return ListTile(title: Text(singleData.title));
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
