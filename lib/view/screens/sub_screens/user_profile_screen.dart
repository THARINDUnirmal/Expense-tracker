import 'dart:io';
import 'package:expenzes/models/user_model.dart';
import 'package:expenzes/provider/image_provider_services.dart';
import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
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

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    getCurruntUser();
    getUserData();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
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
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1,
          decoration: const BoxDecoration(
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
                    SizedBox(height: 20),
                    cardWidget(
                      Column(
                        children: [
                          SizedBox(height: 20),
                          Consumer(
                            builder:
                                (
                                  context,
                                  ImageProviderServices provider,
                                  child,
                                ) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          AppRoutes.route.push(
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
                                                : FileImage(
                                                    File(provider.userImage),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.7,
                                        child: Text(
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          userData.name.isEmpty
                                              ? "No Name"
                                              : userData.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.7,
                                        child: Text(
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          curruntUser.isAnonymous
                                              ? "Anonymous User"
                                              : curruntUser.email!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.normal,
                                              ),
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
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    cardWidget(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          rowWidget(
                            title: userData.name.isEmpty
                                ? "No Name"
                                : userData.name,
                            icon: Icons.account_circle_outlined,
                          ),
                          SizedBox(height: 15),
                          rowWidget(
                            title: curruntUser.isAnonymous
                                ? "No Email (Anonymous User)"
                                : curruntUser.email!,
                            icon: Icons.email_outlined,
                          ),
                          SizedBox(height: 15),
                          rowWidget(
                            title: "English",
                            icon: Icons.language_outlined,
                          ),
                          SizedBox(height: 15),
                          rowWidget(
                            title: "Sri Lanka",
                            icon: Icons.location_on_outlined,
                          ),
                          SizedBox(height: 15),
                          rowWidget(
                            title: userData.createdAt == null
                                ? "Date not avilable"
                                : userData.createdAt.toString(),
                            icon: Icons.date_range_outlined,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget rowWidget({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 30),
        SizedBox(width: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
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
