import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/view/screens/sub_screens/single_data_screen.dart';
import 'package:expenzes/widgets/reuseble_widgets/single_data_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

class SingleCategeoryScreen extends StatefulWidget {
  final String categeoryName;
  const SingleCategeoryScreen({super.key, required this.categeoryName});

  @override
  State<SingleCategeoryScreen> createState() => _SingleCategeoryScreenState();
}

class _SingleCategeoryScreenState extends State<SingleCategeoryScreen> {
  double totalExpenses = 0;
  double totalIncomes = 0;
  List<DataModel> allData = [];
  int touchedIndex = -1; // for tap animation

  BannerAd? _bannerAd;
  // Set to true to use Google's test ad (always use this during development)
  final bool _useTestAds = true;

  @override
  void initState() {
    super.initState();
    // Initialize banner ad
    final String adUnitId = _useTestAds
        ? 'ca-app-pub-3940256099942544/6300978111' // Google test ad
        : 'ca-app-pub-3718682109484928/3605287211'; //real ad unit

    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {}); // Refresh to display the ad
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();

    //other
    getCategeoryData();
  }

  Future<void> getCategeoryData() async {
    List<DataModel> data = await FirebaseDatabaseServices()
        .directGetCatgeoryData(
          categeoryName: widget.categeoryName,
          context: context,
        );
    setState(() {
      allData = data;
    });
  }

  // Automatically calculate income and expense totals
  Map<String, double> calculateTotals() {
    double totalIncome = 0;
    double totalExpense = 0;

    for (var item in allData) {
      if (item.isExpense) {
        totalExpense += item.amount;
      } else {
        totalIncome += item.amount;
      }
    }
    setState(() {
      totalExpenses = totalExpense;
      totalIncomes = totalIncome;
    });

    double total = totalIncome + totalExpense;
    if (total == 0) {
      return {"incomePercent": 0, "expensePercent": 0};
    }

    return {
      "incomePercent": (totalIncome / total) * 100,
      "expensePercent": (totalExpense / total) * 100,
    };
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentages = calculateTotals();
    double incomePercent = percentages["incomePercent"]!;
    double expensePercent = percentages["expensePercent"]!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: _bannerAd == null
          ? const SizedBox()
          : SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              width: _bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
      appBar: AppBar(
        title: Text(widget.categeoryName),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: IconButton(
                onPressed: () async {
                  await deleteFunction(categeory: widget.categeoryName);
                },
                icon: Icon(Icons.delete_outline, size: 30),
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
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
                  // PIE CHART
                  Container(
                    padding: EdgeInsets.all(AppConstants.appPadding),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return PieChart(
                          PieChartData(
                            sectionsSpace: 5,
                            centerSpaceRadius: 60,
                            pieTouchData: PieTouchData(
                              touchCallback: (event, pieTouchResponse) {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse?.touchedSection == null) {
                                  setState(() {
                                    touchedIndex = -1;
                                  });
                                  return;
                                }
                                setState(() {
                                  touchedIndex = pieTouchResponse!
                                      .touchedSection!
                                      .touchedSectionIndex;
                                });
                              },
                            ),
                            sections: [
                              PieChartSectionData(
                                color: Colors.green,
                                value: incomePercent * value,
                                radius: touchedIndex == 0 ? 70 : 55,
                                title: touchedIndex == 0
                                    ? "${incomePercent.toStringAsFixed(1)}%"
                                    : "Income",
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PieChartSectionData(
                                color: Colors.red,
                                value: expensePercent * value,
                                radius: touchedIndex == 1 ? 70 : 55,
                                title: touchedIndex == 1
                                    ? "${expensePercent.toStringAsFixed(1)}%"
                                    : "Expense",
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Icon
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/income.svg",
                                width: 28,
                                height: 28,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 20),

                            // Texts
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Incomes",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    " Rs.${totalIncomes.toString()}",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.appGreenColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "${incomePercent.toStringAsFixed(1)}%",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.appGreenColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            // Icon
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/Expeses.svg",
                                width: 28,
                                height: 28,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 20),

                            // Texts
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Expenses",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    " Rs.${totalExpenses.toString()}",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.appRedColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "${expensePercent.toStringAsFixed(1)}%",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.appSheetRedColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Recent Added",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder(
                    stream: FirebaseDatabaseServices().getAllCtegeoryDataStream(
                      categoryName: widget.categeoryName,
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
                                  style: Theme.of(context).textTheme.bodyLarge!
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

                                  SizedBox(height: 20),
                                  Text(
                                    "Resent ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
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
                                          Navigator.push(
                                            context,
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
    );
  }

  Future<void> deleteFunction({required String categeory}) async {
    // Simple modern alert using bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: 370,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Lottie.asset(
              "assets/lottei/Alert 1.json",
              width: 100,
              repeat: false,
            ),
            const SizedBox(height: 10),
            const Text(
              "Delete",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Are you sure you want to delete\nall data under this category?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                logoutButton("Yes", Colors.red, true, categeory),
                logoutButton("No", Colors.white, false, categeory),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget logoutButton(String text, Color color, bool isYes, String categeory) {
    return GestureDetector(
      onTap: () async {
        if (isYes) {
          await FirebaseDatabaseServices().deleteDataUsingCategeory(
            context: context,
            categeory: categeory,
          );
          if (context.mounted) Navigator.pop(context);
          AppRoutes.route.go("/MainScreen");
        } else {
          Navigator.pop(context);
        }
      },
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
          color: isYes ? color : Colors.white,
          border: Border.all(color: Colors.red, width: isYes ? 0 : 2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isYes ? Colors.white : Colors.red,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
