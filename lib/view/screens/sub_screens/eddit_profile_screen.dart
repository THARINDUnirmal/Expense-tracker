import 'dart:io';
import 'package:expenzes/models/user_model.dart';
import 'package:expenzes/provider/provider_services.dart';
import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EdditProfileScreen extends StatefulWidget {
  const EdditProfileScreen({super.key});

  @override
  State<EdditProfileScreen> createState() => _EdditProfileScreenState();
}

class _EdditProfileScreenState extends State<EdditProfileScreen> {
  late User curruntUser;

  UserModel userData = UserModel(userId: "", name: "", email: "");

  //get currunt user Data from firebase auth
  Future<void> getCurruntUser() async {
    try {
      User getData = FirebaseAuthServices().curruntUserData;
      setState(() {
        curruntUser = getData;
      });
    } catch (error) {}
  }

  //get user data
  Future<void> getUserData() async {
    UserModel data = await FirebaseDatabaseServices().getCurrentUserData(
      userId: curruntUser.uid,
    );

    setState(() {
      userData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurruntUser();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "User Profile",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.appPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  cardWidget(
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Consumer(
                          builder: (context, ProviderServices provider, child) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    AppRoutes.route.go(
                                      "/FullImageScreen",
                                      extra: provider.userImage,
                                    );
                                  },
                                  child: Hero(
                                    tag: 1,
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          provider.userImage.isEmpty
                                          ? NetworkImage(
                                              "https://tse1.mm.bing.net/th/id/OIP.vmoycMUOmbcs0Vw-1iIdVAHaHa?rs=1&pid=ImgDetMain&o=7&rm=3",
                                            )
                                          : FileImage(File(provider.userImage)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  userData.name.isEmpty
                                      ? "No Name"
                                      : userData.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  curruntUser.isAnonymous
                                      ? "Anonymous User"
                                      : curruntUser.email!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Account Details",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  cardWidget(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.account_circle_outlined, size: 30),
                            SizedBox(width: 20),
                            Text(
                              userData.name.isEmpty ? "No Name" : userData.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.email_outlined, size: 30),
                            SizedBox(width: 20),
                            Text(
                              curruntUser.isAnonymous
                                  ? "No Email (Anonymous User)"
                                  : curruntUser.email!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.language_outlined, size: 30),
                            SizedBox(width: 20),
                            Text(
                              "English",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 30),
                            SizedBox(width: 20),
                            Text(
                              "Sri Lanka",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.date_range_outlined, size: 30),
                            SizedBox(width: 20),
                            Text(
                              userData.createdAt == null
                                  ? "Date not avilable"
                                  : userData.createdAt.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xff398bd3),
                    ),
                    child: Center(
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cardWidget(Widget childWidget) {
    return Container(
      padding: EdgeInsets.all(AppConstants.appPadding),
      decoration: BoxDecoration(
        color: Color(0xfff0f5f6),
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      child: childWidget,
    );
  }
}
