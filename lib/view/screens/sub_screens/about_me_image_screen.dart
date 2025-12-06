import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';

class AboutMeImageScreen extends StatelessWidget {
  final String imageUrl;
  const AboutMeImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff080c14),
      appBar: AppBar(
        backgroundColor: Color(0xff080c14),

        title: Text(
          "Developer Preview",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => AppRoutes.route.go("/AboutMeScreen"),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.appPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Hero(
                tag: 1,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: Image.asset(imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
