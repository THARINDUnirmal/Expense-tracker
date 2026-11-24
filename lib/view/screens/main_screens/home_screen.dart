import 'dart:async';
import 'dart:io';
import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/models/user_model.dart';
import 'package:expenzes/provider/image_provider_services.dart';
import 'package:expenzes/services/adds/ad_manager.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/connection/connection_service.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/utils/messages/app_messages.dart';
import 'package:expenzes/widgets/reuseble_widgets/categeory_card_widget.dart';
import 'package:expenzes/widgets/reuseble_widgets/gredient_page.dart';
import 'package:expenzes/widgets/reuseble_widgets/modern_gredient_card.dart';
import 'package:expenzes/widgets/reuseble_widgets/single_data_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // ------------------ USER DATA ------------------
  String currentCodition = "";
  late String? userName;
  UserModel currentUserInformation = UserModel(userId: "", name: "", email: "");
  Map<String, double> allDataMap = {};
  int expensesCount = 0;

  // ------------------ ADS ------------------
  BannerAd? _bannerAd;

  // ------------------ ANIMATION ------------------
  late AnimationController _controller;
  late Animation<double> _animation;

  // ------------------ CONNECTION ------------------
  late StreamSubscription<bool> _subscription;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();

    // Banner load
    _bannerAd = AdManager.createBannerAd(() => setState(() {}))..load();

    // Interstitial preload
    AdManager.loadInterstitial();

    // Auto-show after first frame
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   AdManager.showInterstitial(); // first-time interstitial
    // });

    // Other methods
    getUser();
    getAllTotalValues();
    timeTracker();

    _subscription = ConnectionService().connectionStream.listen((status) {
      isConnected = status;
      if (!status) {
        AppMessages().appAlertMessage(
          "Please check your internet connection",
          context,
        );
      }
    });

    // Animation
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
    _bannerAd?.dispose();
    super.dispose();
  }

  // ------------------ USER FUNCTIONS ------------------
  Future<void> getUser() async {
    User userData = FirebaseAuthServices().curruntUserData;
    userName = userData.isAnonymous ? "Anonymous User" : userData.email;

    currentUserInformation = await FirebaseDatabaseServices()
        .getCurrentUserData(userId: userData.uid);
  }

  Future<void> getAllTotalValues() async {
    String uId = FirebaseAuthServices().curruntUserData.uid;

    Map<String, double> allData = await FirebaseDatabaseServices()
        .getTotalValues(currentUserId: uId, context: context);

    List<DataModel> allDataList = await FirebaseDatabaseServices().getAllData(
      curruntUserId: uId,
      context: context,
    );

    expensesCount = allDataList.where((e) => e.isExpense).length;

    setState(() {
      allDataMap = allData;
    });
  }

  void timeTracker() {
    DateTime now = DateTime.now();
    if (now.hour >= 5 && now.hour < 12) {
      currentCodition = "Good Morning";
    } else if (now.hour >= 12 && now.hour < 17) {
      currentCodition = "Good Afternoon";
    } else if (now.hour >= 17 && now.hour < 20) {
      currentCodition = "Good Evening";
    } else {
      currentCodition = "Good Night";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _bannerAd == null
          ? const SizedBox()
          : SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              width: double.infinity,
              child: AdWidget(ad: _bannerAd!),
            ),
      body: FadeTransition(
        opacity: _animation,
        child: GredientPage(
          childWidget: SafeArea(
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
                            GoRouter.of(context).push("/AboutMeScreen");
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Finance",
                              style: TextStyle(
                                fontSize: 30,
                                color: AppColors.appGreenColor,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "Mate",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: AppColors.appBlueColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).push("/NotificationScreen");
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
                            GoRouter.of(context).go("/MainScreen/2");
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
                            GoRouter.of(context).go("/MainScreen/2");
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
                            GoRouter.of(context).go("/MainScreen/1");
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
                            AdManager.showInterstitial();

                            GoRouter.of(
                              context,
                            ).push("/SummaryScreen", extra: allDataMap);
                          },
                          child: ModernGredientCard(
                            cardGradient: LinearGradient(
                              colors: [
                                AppColors.appGreenColor,
                                const Color(0xFF43BFA0),
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
                            AdManager.showInterstitial();

                            GoRouter.of(
                              context,
                            ).push("/PieChartScreen", extra: allDataMap);
                          },
                          child: ModernGredientCard(
                            cardGradient: LinearGradient(
                              colors: [
                                AppColors.appBlueColor,
                                const Color(0xFF6F8DEB),
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
                                    GoRouter.of(context).push("/AddScreen");
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
                                          GoRouter.of(
                                            context,
                                          ).push("/AddScreen");
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

                                    //todo secon builder
                                    StreamBuilder(
                                      stream: FirebaseDatabaseServices()
                                          .getAllCategoryNameStream(
                                            curruntUserId:
                                                FirebaseAuthServices()
                                                    .curruntUserData
                                                    .uid,
                                          ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "No Data Found",
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          List<String> categeoryNames =
                                              snapshot.data ?? [];
                                          return Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    "Category",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      AdManager.showInterstitial();
                                                      GoRouter.of(context).push(
                                                        "/AllCtegeoryScreen",
                                                        extra: categeoryNames,
                                                      );
                                                    },
                                                    child: Text(
                                                      "See All >>",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 20),
                                              SizedBox(
                                                height:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.1,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: categeoryNames
                                                      .toSet()
                                                      .length,
                                                  itemBuilder: (context, index) {
                                                    String indexData =
                                                        categeoryNames
                                                            .toSet()
                                                            .toList()[index];
                                                    return InkWell(
                                                      onTap: () {
                                                        GoRouter.of(
                                                          context,
                                                        ).push(
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
                                            ],
                                          );
                                        }
                                      },
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
                                            GoRouter.of(context).push(
                                              "/SingleDataScreen",
                                              extra: singleData,
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
                                    SizedBox(height: 50),
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
