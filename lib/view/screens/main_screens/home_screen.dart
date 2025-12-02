import 'dart:io';

import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/services/local_storage/local_data.dart';
import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/view/screens/home_see_all_screen.dart';
import 'package:expenzes/widgets/categeory_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userImageLocal = "";
  late String? userName;

  Future<void> getUserLocalUserImage() async {
    try {
      String userImage = await LocalData().getImageData();
      setState(() {
        userImageLocal = userImage;
      });
    } catch (error) {}
  }

  Future<void> getUser() async {
    User userData = FirebaseAuthServices().curruntUserData;
    userName = userData.isAnonymous ? "Anonymous User" : userData.email;
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getUserLocalUserImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                        size: 25,
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
                          backgroundImage: userImageLocal.isEmpty
                              ? NetworkImage(
                                  "https://images.unsplash.com/photo-1557862921-37829c790f19?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzh8fHVzZXJ8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=600",
                                )
                              : FileImage(File(userImageLocal)),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Good Evening!",
                              style: AppTextStyles.miniTextStyle,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                userName!,
                                style: AppTextStyles.mainTopicTextStyle
                                    .copyWith(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.keyboard_double_arrow_right, size: 25),
                  ],
                ),
                SizedBox(height: 30),
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
                    IconButton(
                      onPressed: () {
                        AppRoutes.route.push("/AddScreen");
                      },
                      icon: Icon(Icons.add, size: 25),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.appCreamColor,
                      ),
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "Total Expenses or\nIncomes",
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.appCreamColor,
                      ),
                      child: Center(
                        child: Text(textAlign: TextAlign.center, "Chart"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  textAlign: TextAlign.center,
                  "Category ",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeSeeAllScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "See All >>",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CategeoryCardWidget(title: "Data 1"),
                      CategeoryCardWidget(title: "Data 2"),
                      CategeoryCardWidget(title: "Data 3"),
                      CategeoryCardWidget(title: "Data 4"),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Resent ",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 20),
                FutureBuilder(
                  future: FirebaseDatabaseServices().getAllData(
                    curruntUserId: FirebaseAuthServices().curruntUserData.uid,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "Error : ${snapshot.error}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "No Data !",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      );
                    } else {
                      List<DataModel> dataList = snapshot.data ?? [];
                      return dataList.isEmpty
                          ? Center(
                              child: Text(
                                textAlign: TextAlign.center,
                                "No Data !",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: dataList.length,
                              itemBuilder: (context, index) {
                                DataModel singleData = dataList[index];
                                return Container(
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
      ),
    );
  }
}
