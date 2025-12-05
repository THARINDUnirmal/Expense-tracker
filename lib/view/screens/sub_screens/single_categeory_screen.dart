import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/widgets/reuseble_widgets/single_data_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SingleCategeoryScreen extends StatefulWidget {
  final String categeoryName;
  const SingleCategeoryScreen({super.key, required this.categeoryName});

  @override
  State<SingleCategeoryScreen> createState() => _SingleCategeoryScreenState();
}

class _SingleCategeoryScreenState extends State<SingleCategeoryScreen> {
  List<DataModel> allData = [];
  int touchedIndex = -1; // for tap animation

  @override
  void initState() {
    super.initState();
    getCategeoryData();
  }

  Future<void> getCategeoryData() async {
    List<DataModel> data = await FirebaseDatabaseServices()
        .directGetCatgeoryData(categeoryName: widget.categeoryName);
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
  Widget build(BuildContext context) {
    final percentages = calculateTotals();
    double incomePercent = percentages["incomePercent"]!;
    double expensePercent = percentages["expensePercent"]!;

    return Scaffold(
      extendBodyBehindAppBar: true,
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
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
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

                  const SizedBox(height: 50),
                  Text(
                    "Recent Added",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    itemCount: allData.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      DataModel indexData = allData[index];
                      return SingleDataCard(
                        title: indexData.title,
                        isExpense: indexData.isExpense,
                        cardAmount: indexData.amount,
                      );
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
