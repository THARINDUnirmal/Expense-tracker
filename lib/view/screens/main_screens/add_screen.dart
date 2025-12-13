import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/services/adds/ad_manager.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/widgets/add_card_modern.dart';
import 'package:expenzes/widgets/reuseble_widgets/gredient_page.dart';
import 'package:expenzes/widgets/reuseble_widgets/single_data_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen>
    with SingleTickerProviderStateMixin {
  User? curruntUser;
  late AnimationController _controller;
  late Animation<double> _animation;
  BannerAd? _bannerAd;

  void userSet() {
    User? userData = FirebaseAuthServices().curruntUserData;
    setState(() {
      curruntUser = userData;
    });
  }

  @override
  void initState() {
    super.initState();
    userSet();

    // Banner load
    _bannerAd = AdManager.createBannerAd(() => setState(() {}))..load();

    // Interstitial preload
    AdManager.loadInterstitial();

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
    super.dispose();
    _bannerAd?.dispose();
    _controller.dispose();
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            GoRouter.of(
                              context,
                            ).push("/AddDataScreen", extra: false);
                          },
                          child: AddCardModern(
                            title: "Add Income",
                            svgPath: "assets/icons/income.svg",
                            isExpense: false,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            GoRouter.of(
                              context,
                            ).push("/AddDataScreen", extra: true);
                          },
                          child: AddCardModern(
                            title: "Add Expense",
                            svgPath: "assets/icons/Expeses.svg",
                            isExpense: true,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),
                    Text(
                      "Last Added",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),

                    StreamBuilder(
                      stream: FirebaseDatabaseServices().getAllDataStream(
                        curruntUserId: curruntUser!.uid,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              snapshot.error.toString(),
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.normal),
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

                                Text(
                                  "Add Now",
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        } else {
                          List<DataModel> allData = snapshot.data!;

                          return allData.isEmpty
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

                                      Text(
                                        "Add Now",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.52,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: ListView.builder(
                                      itemCount: allData.length,
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        DataModel singleData = allData[index];
                                        return GestureDetector(
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
                                  ),
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
