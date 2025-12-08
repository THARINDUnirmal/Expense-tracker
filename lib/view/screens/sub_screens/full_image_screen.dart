import 'dart:io';

import 'package:expenzes/provider/image_provider_services.dart';
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
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.appPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
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
              SizedBox(height: 30),
              imageUrl.isEmpty
                  ? SizedBox()
                  : TextButton(
                      onPressed: () {
                        Provider.of<ImageProviderServices>(
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
      ),
    );
  }
}
