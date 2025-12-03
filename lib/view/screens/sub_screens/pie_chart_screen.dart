import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartScreen extends StatelessWidget {
  const PieChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- HEADER ----------
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
              children: const [
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

          // ---------- PIE CHART ----------
          Center(
            child: Container(
              height: 260,
              width: 260,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 45,
                  sections: [
                    PieChartSectionData(
                      color: Colors.green,
                      value: 65,
                      radius: 55,
                      title: "Income",
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.red,
                      value: 35,
                      radius: 55,
                      title: "Expense",
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ---------- LEGEND LIST ----------
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 18),

                  // CATEGORY ITEMS
                  pieItem(
                    color: Colors.green,
                    title: "Income",
                    amount: "Rs. 75,000",
                  ),
                  const SizedBox(height: 14),
                  pieItem(
                    color: Colors.red,
                    title: "Expense",
                    amount: "Rs. 32,500",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- CATEGORY ROW ----------
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
