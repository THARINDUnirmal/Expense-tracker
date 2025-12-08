import 'dart:async';
import 'dart:io';
import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/models/user_model.dart';
import 'package:expenzes/provider/image_provider_services.dart';
import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/connection/connection_service.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/utils/messages/app_messages.dart';
import 'package:expenzes/view/screens/sub_screens/single_data_screen.dart';
import 'package:expenzes/widgets/reuseble_widgets/categeory_card_widget.dart';
import 'package:expenzes/widgets/reuseble_widgets/modern_gredient_card.dart';
import 'package:expenzes/widgets/reuseble_widgets/single_data_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  //All veriables
  String currentCodition = "";
  late String? userName;
  UserModel currentUserInformation = UserModel(userId: "", name: "", email: "");
  Map<String, double> allDataMap = {};
  List<String> allCategeory = [];
  int expensesCount = 0;

  late AnimationController _controller;
  late Animation<double> _animation;

  //get user name form current user
  Future<void> getUser() async {
    User userData = FirebaseAuthServices().curruntUserData;
    userName = userData.isAnonymous ? "Anonymous User" : userData.email;

    currentUserInformation = await FirebaseDatabaseServices()
        .getCurrentUserData(userId: userData.uid);
  }

  //get Total Expenses & Incomes values
  Future<void> getAllTotalValues() async {
    //get current userId
    String uId = FirebaseAuthServices().curruntUserData.uid;

    //get total values
    Map<String, double> allData = await FirebaseDatabaseServices()
        .getTotalValues(currentUserId: uId, context: context);

    //get all data & add there categeorys in a list
    List<DataModel> allDataList = await FirebaseDatabaseServices().getAllData(
      curruntUserId: uId,
      context: context,
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
    DateTime now = DateTime.now();
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

  //
  late StreamSubscription<bool> _subscription;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    getUser();
    getAllTotalValues();
    timeTracker();
    _subscription = ConnectionService().connectionStream.listen((status) {
      setState(() {
        isConnected = status;
      });

      // Show snackbar on change
      isConnected
          ? null
          : AppMessages().appAlertMessage(
              "Please check your internet connection",
              context,
            );
    });

    //animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _animation,
        child: Container(
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
                            builder:
                                (
                                  context,
                                  ImageProviderServices provider,
                                  child,
                                ) {
                                  return Row(
                                    children: [
                                      Hero(
                                        tag: 1,
                                        child: CircleAvatar(
                                          maxRadius: 35,
                                          backgroundImage:
                                              provider.userImage.isEmpty
                                              ? NetworkImage(
                                                  "https://tse1.mm.bing.net/th/id/OIP.vmoycMUOmbcs0Vw-1iIdVAHaHa?rs=1&pid=ImgDetMain&o=7&rm=3",
                                                )
                                              : FileImage(
                                                  File(provider.userImage),
                                                ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.02,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentCodition,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          ),
                                          SizedBox(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.5,
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              currentUserInformation
                                                          .name
                                                          .isEmpty ||
                                                      currentUserInformation
                                                              .name ==
                                                          ""
                                                  ? userName!
                                                  : currentUserInformation.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
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
                          icon: Icon(
                            Icons.keyboard_double_arrow_right,
                            size: 25,
                          ),
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
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$expensesCount Expenses Pending",
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(fontWeight: FontWeight.normal),
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
                          child: ModernGredientCard(
                            cardGradient: LinearGradient(
                              colors: [
                                Color(0xFF4A90E2).withOpacity(0.85),
                                Color(0xFF50C9C3).withOpacity(0.85),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            cardIcon: Icons.summarize_rounded,
                            cardTitle: "Summary",
                          ),
                        ),

                        //Chart Card
                        GestureDetector(
                          onTap: () {
                            setState(() {});
                            AppRoutes.route.push(
                              "/PieChartScreen",
                              extra: allDataMap,
                            );
                          },
                          child: ModernGredientCard(
                            cardGradient: LinearGradient(
                              colors: [
                                Color(0xFFFFC857).withOpacity(0.95),
                                Color(0xFFFFA534).withOpacity(0.95),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            cardIcon: Icons.pie_chart_rounded,
                            cardTitle: "Charts",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    StreamBuilder(
                      stream: FirebaseDatabaseServices().getAllDataStream(
                        curruntUserId:
                            FirebaseAuthServices().curruntUserData.uid,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                SizedBox(height: 10),
                                Icon(
                                  Icons.inbox_rounded,
                                  size: 80,
                                  color: Colors.grey.shade400,
                                ),

                                SizedBox(height: 16),

                                Text(
                                  "No Data Found",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),

                                SizedBox(height: 8),

                                Text(
                                  "It looks empty here. Add your first item!",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(fontWeight: FontWeight.normal),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
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
                                      SizedBox(height: 10),
                                      Icon(
                                        Icons.inbox_rounded,
                                        size: 80,
                                        color: Colors.grey.shade400,
                                      ),

                                      SizedBox(height: 16),

                                      Text(
                                        "No Data Found",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),

                                      SizedBox(height: 8),

                                      Text(
                                        "It looks empty here. Add your first item!",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontWeight: FontWeight.normal,
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontWeight: FontWeight.normal,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(height: 20),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: dataList.length,
                                      itemBuilder: (context, index) {
                                        DataModel singleData = dataList[index];
                                        return InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SingleDataScreen(
                                                      singleData: singleData,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: SingleDataCard(
                                            title: singleData.title,
                                            isExpense: singleData.isExpense,
                                            cardAmount: singleData.amount,
                                          ),
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
      ),
    );
  }
}
