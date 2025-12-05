import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/widgets/reuseble_widgets/categeory_card_widget.dart';
import 'package:flutter/material.dart';

class AllCategeoryScreen extends StatelessWidget {
  final List<String> categeoryList;
  const AllCategeoryScreen({super.key, required this.categeoryList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "All Ctegeory Data",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 1,
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
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.appPadding),
          child: GridView.builder(
            itemCount: categeoryList.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 10 / 5,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              String indexValue = categeoryList[index];
              return InkWell(
                onTap: () {
                  AppRoutes.route.push(
                    "/SingleCategeoryScreen",
                    extra: indexValue,
                  );
                },
                child: CategoryCardWidget(title: indexValue),
              );
            },
          ),
        ),
      ),
    );
  }
}
