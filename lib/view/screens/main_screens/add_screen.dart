import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/view/screens/sub_screens/add_data_screen.dart';
import 'package:expenzes/view/screens/sub_screens/single_data_screen.dart';
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
      body: SingleChildScrollView(
        child: Padding(
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
              SizedBox(height: 30),
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
                    return allData.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 100),
                                Icon(
                                  Icons.inbox_rounded,
                                  size: 80,
                                  color: Colors.grey.shade400,
                                ),

                                SizedBox(height: 16),

                                Text(
                                  "No Data Found",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                SizedBox(height: 8),

                                Text(
                                  "It looks empty here. Add your first item!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                ),

                                SizedBox(height: 24),

                                Text(
                                  "Add Now",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: allData.length,
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              DataModel singleData = allData[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SingleDataScreen(
                                        singleData: singleData,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.all(15),
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        width: 8,
                                        color: singleData.isExpense
                                            ? AppColors.appRedColor
                                            : AppColors.appGreenColor,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 2,
                                        offset: Offset(3, 2),
                                        color: const Color.fromARGB(
                                          255,
                                          236,
                                          236,
                                          237,
                                        ),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 250,
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              singleData.title,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          SizedBox(
                                            width: 250,
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              "Rs.${singleData.amount}",
                                              style: TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            singleData.isExpense
                                                ? Icons.arrow_circle_up_outlined
                                                : Icons
                                                      .arrow_circle_down_outlined,
                                            color: singleData.isExpense
                                                ? AppColors.appRedColor
                                                : AppColors.appGreenColor,
                                            size: 30,
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
