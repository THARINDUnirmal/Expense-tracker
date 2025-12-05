import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/widgets/reuseble_widgets/categeory_card_widget.dart';
import 'package:flutter/material.dart';

class AllCategeoryScreen extends StatelessWidget {
  final List<String> categeoryList;
  const AllCategeoryScreen({super.key, required this.categeoryList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "All Ctegeory Data",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: GridView.builder(
        itemCount: categeoryList.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          String indexValue = categeoryList[index];

          return InkWell(
            onTap: () {
              AppRoutes.route.push("/SingleCategeoryScreen", extra: indexValue);
            },
            child: CategoryCardWidget(title: indexValue),
          );
        },
      ),
    );
  }
}
