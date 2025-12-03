import 'dart:io';

import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/services/local_storage/local_data.dart';
import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/view/screens/sub_screens/home_see_all_screen.dart';
import 'package:expenzes/widgets/categeory_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //All veriables
  String userImageLocal = "";
  late String? userName;
  Map<String, double> allDataMap = {};

  //get user image from local storage
  Future<void> getUserLocalUserImage() async {
    try {
      String userImage = await LocalData().getImageData();
      setState(() {
        userImageLocal = userImage;
      });
    } catch (error) {}
  }

  //get user name form current user
  Future<void> getUser() async {
    User userData = FirebaseAuthServices().curruntUserData;
    userName = userData.isAnonymous ? "Anonymous User" : userData.email;
  }

  //get Total Expenses & Incomes values
  Future<void> getAllTotalValues() async {
    Map<String, double> allData = await FirebaseDatabaseServices()
        .getTotalValues(
          currentUserId: FirebaseAuthServices().curruntUserData.uid,
        );

    setState(() {
      allDataMap = allData;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getUserLocalUserImage();
    getAllTotalValues();
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
                    GestureDetector(
                      onTap: () {
                        AppRoutes.route.push("/FinanceMateScreen");
                      },
                      child: RichText(
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
                    GestureDetector(
                      onTap: () {
                        AppRoutes.route.push("/EdditProfileScreen");
                      },
                      child: Row(
                        children: [
                          Hero(
                            tag: 1,
                            child: CircleAvatar(
                              maxRadius: 40,
                              backgroundImage: userImageLocal.isEmpty
                                  ? NetworkImage(
                                      "https://tse1.mm.bing.net/th/id/OIP.vmoycMUOmbcs0Vw-1iIdVAHaHa?rs=1&pid=ImgDetMain&o=7&rm=3",
                                    )
                                  : FileImage(File(userImageLocal)),
                            ),
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
                    ),

                    IconButton(
                      onPressed: () {
                        AppRoutes.route.push("/EdditProfileScreen");
                      },
                      icon: Icon(Icons.keyboard_double_arrow_right, size: 25),
                    ),
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
                    GestureDetector(
                      onTap: () {
                        AppRoutes.route.push(
                          "/SummaryScreen",
                          extra: allDataMap,
                        );
                      },
                      child: Container(
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
                    ),
                    GestureDetector(
                      onTap: () {
                        AppRoutes.route.push(
                          "/PieChartScreen",
                          extra: allDataMap,
                        );
                      },
                      child: Container(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.appBlue2Color,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                              ),
                              onPressed: () {
                                AppRoutes.route.push("/AddScreen");
                              },
                              child: Text(
                                "Add Now",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      List<DataModel> dataList = snapshot.data ?? [];
                      return dataList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.appBlue2Color,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 28,
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 3,
                                    ),
                                    onPressed: () {
                                      AppRoutes.route.push("/AddScreen");
                                    },
                                    child: Text(
                                      "Add Now",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
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
