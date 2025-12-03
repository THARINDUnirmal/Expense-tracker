import 'package:expenzes/routes/app_routes.dart';
import 'package:flutter/material.dart';

class HomeSeeAllScreen extends StatelessWidget {
  const HomeSeeAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "All Data",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            AppRoutes.route.go("/MainScreen");
          },
          icon: Icon(Icons.arrow_back_ios, size: 30),
        ),
      ),
    );
  }
}
