import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartScreen extends StatefulWidget {
  final Map<String, double> allTotalData;
  const PieChartScreen({super.key, required this.allTotalData});

  @override
  State<PieChartScreen> createState() => _PieChartScreenState();
}

class _PieChartScreenState extends State<PieChartScreen> {
  int touchedIndex = -1;

  // Automatically calculate percentages
  Map<String, double> calculatePercentages() {
    double totalIncome = widget.allTotalData["TotalIncomes"] ?? 0;
    double totalExpense = widget.allTotalData["TotalExpenses"] ?? 0;
    double total = totalIncome + totalExpense;

    if (total == 0) return {"income": 0, "expense": 0};

    return {
      "income": (totalIncome / total) * 100,
      "expense": (totalExpense / total) * 100,
    };
  }

  @override
  Widget build(BuildContext context) {
    final percentages = calculatePercentages();
    double incomePercent = percentages["income"]!;
    double expensePercent = percentages["expense"]!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xFFB3E5FC), // Sky Blue
              Color(0xFFFFF59D), // Soft Yellow
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Statistics",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Pie chart for income & expenses",
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // PIE CHART
            Center(
              child: Container(
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
                            value: incomePercent * value, // dynamic percentage
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
            ),

            const SizedBox(height: 30),

            // LEGEND LIST
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Category Breakdown",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    pieItem(
                      color: Colors.green,
                      title: "Income",
                      amount: "Rs. ${widget.allTotalData["TotalIncomes"] ?? 0}",
                    ),
                    const SizedBox(height: 14),
                    pieItem(
                      color: Colors.red,
                      title: "Expense",
                      amount:
                          "Rs. ${widget.allTotalData["TotalExpenses"] ?? 0}",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CATEGORY ROW
  Widget pieItem({
    required Color color,
    required String title,
    required String amount,
  }) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          amount,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
