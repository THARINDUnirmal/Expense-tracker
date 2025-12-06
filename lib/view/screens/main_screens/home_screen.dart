import 'dart:io';

import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/provider/provider_services.dart';
import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/widgets/reuseble_widgets/categeory_card_widget.dart';
import 'package:expenzes/widgets/reuseble_widgets/single_data_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //All veriables
  String currentCodition = "";
  late String? userName;
  Map<String, double> allDataMap = {};
  List<String> allCategeory = [];
  int expensesCount = 0;

  //get user name form current user
  Future<void> getUser() async {
    User userData = FirebaseAuthServices().curruntUserData;
    userName = userData.isAnonymous ? "Anonymous User" : userData.email;
  }

  //get Total Expenses & Incomes values
  Future<void> getAllTotalValues() async {
    //get current userId
    String uId = FirebaseAuthServices().curruntUserData.uid;

    //get total values
    Map<String, double> allData = await FirebaseDatabaseServices()
        .getTotalValues(currentUserId: uId);

    //get all data & add there categeorys in a list
    List<DataModel> allDataList = await FirebaseDatabaseServices().getAllData(
      curruntUserId: uId,
    );

    List<String> dataList = [];
    for (DataModel i in allDataList) {
      if (i.isExpense) {
        expensesCount += 1;
      }
    }

    for (DataModel i in allDataList) {
      if (!allCategeory.contains(i.category)) {
        dataList.add(i.category!);
      }
    }

    setState(() {
      allDataMap = allData;
      allCategeory = dataList;
    });
  }

  void timeTracker() {
    DateTime now = DateTime.now(); // current time
    String timeOfDay;

    if (now.hour >= 5 && now.hour < 12) {
      timeOfDay = "Good Morning";
    } else if (now.hour >= 12 && now.hour < 17) {
      timeOfDay = "Good Afternoon";
    } else if (now.hour >= 17 && now.hour < 20) {
      timeOfDay = "Good Evening";
    } else {
      timeOfDay = "Good Night";
    }
    setState(() {
      currentCodition = timeOfDay;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getAllTotalValues();
    timeTracker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFFFFF59D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
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
                        onLongPress: () {
                          AppRoutes.route.push("/AboutMeSreen");
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
                      TextButton(
                        onPressed: () {
                          AppRoutes.route.push("/NotificationScreen");
                        },

                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.white,
                          shadowColor: Colors.grey.withOpacity(0.3),
                          elevation: 4,
                        ),
                        child: ShaderMask(
                          shaderCallback: (bounds) =>
                              LinearGradient(
                                colors: [Colors.purple, Colors.blue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(
                                Rect.fromLTWH(
                                  0,
                                  0,
                                  bounds.width,
                                  bounds.height,
                                ),
                              ),
                          child: Icon(Icons.notifications, size: 20),
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
                          AppRoutes.route.push("/UserProfileScreen");
                        },
                        child: Consumer(
                          builder: (context, ProviderServices provider, child) {
                            return Row(
                              children: [
                                Hero(
                                  tag: 1,
                                  child: CircleAvatar(
                                    maxRadius: 40,
                                    backgroundImage: provider.userImage.isEmpty
                                        ? NetworkImage(
                                            "https://tse1.mm.bing.net/th/id/OIP.vmoycMUOmbcs0Vw-1iIdVAHaHa?rs=1&pid=ImgDetMain&o=7&rm=3",
                                          )
                                        : FileImage(File(provider.userImage)),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentCodition,
                                      style: AppTextStyles.miniTextStyle,
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.55,
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
                            );
                          },
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          AppRoutes.route.push("/UserProfileScreen");
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
                            "$expensesCount Expenses Pending",
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
                      //Summary Card
                      GestureDetector(
                        onTap: () {
                          setState(() {});
                          AppRoutes.route.push(
                            "/SummaryScreen",
                            extra: allDataMap,
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.42,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF4A90E2).withOpacity(0.85),
                                Color(0xFF50C9C3).withOpacity(0.85),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.summarize_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Summary",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // -------- Chart Card --------
                      GestureDetector(
                        onTap: () {
                          setState(() {});
                          AppRoutes.route.push(
                            "/PieChartScreen",
                            extra: allDataMap,
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.42,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFFC857).withOpacity(0.95),
                                Color(0xFFFFA534).withOpacity(0.95),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.pie_chart_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Charts",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  StreamBuilder(
                    stream: FirebaseDatabaseServices().getAllDataStream(
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
                                    SizedBox(height: 30),
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
                                        backgroundColor:
                                            AppColors.appBlue2Color,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 28,
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        "Category",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          AppRoutes.route.push(
                                            "/AllCtegeoryScreen",
                                            extra: allCategeory,
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
                                  SizedBox(height: 20),

                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.1,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: allCategeory.toSet().length,
                                      itemBuilder: (context, index) {
                                        String indexData = allCategeory
                                            .toSet()
                                            .toList()[index];
                                        return InkWell(
                                          onTap: () {
                                            AppRoutes.route.push(
                                              "/SingleCategeoryScreen",
                                              extra: indexData,
                                            );
                                          },
                                          child: CategoryCardWidget(
                                            title: indexData,
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  SizedBox(height: 20),
                                  Text(
                                    "Resent ",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: dataList.length,
                                    itemBuilder: (context, index) {
                                      DataModel singleData = dataList[index];
                                      return SingleDataCard(
                                        title: singleData.title,
                                        isExpense: singleData.isExpense,
                                        cardAmount: singleData.amount,
                                      );
                                    },
                                  ),
                                ],
                              );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
