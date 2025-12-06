import 'dart:io';

import 'package:expenzes/provider/provider_services.dart';
import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FullImageScreen extends StatelessWidget {
  final String imageUrl;
  const FullImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff080c14),
      appBar: AppBar(
        backgroundColor: Color(0xff080c14),

        title: Text(
          "Preview",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => AppRoutes.route.go("/UserProfileScreen"),
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
                  child: imageUrl.isEmpty
                      ? Text(
                          "No Photo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Image.file(File(imageUrl), fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: 50),
            imageUrl.isEmpty
                ? SizedBox()
                : TextButton(
                    onPressed: () {
                      Provider.of<ProviderServices>(
                        context,
                        listen: false,
                      ).deleteUserImageFromLocal(context: context);
                      AppRoutes.route.go("/UserProfileScreen");
                    },
                    child: Text(
                      "Delete Photo",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
