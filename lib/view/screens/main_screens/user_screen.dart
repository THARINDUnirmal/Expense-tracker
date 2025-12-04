import 'dart:io';
import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/local_storage/local_data.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late String? userName;
  late User userData;
  String userImageLocal = "";

  final ImagePicker pickImager = ImagePicker();

  @override
  void initState() {
    super.initState();
    getUser();
    getImageFromLocal(); // Load saved profile image
  }

  // Fetch user data
  Future<void> getUser() async {
    User userDataa = FirebaseAuthServices().curruntUserData;
    userName = userDataa.isAnonymous ? "Anonymous User" : userDataa.email;
    userData = userDataa;
    setState(() {});
  }

  // Fetch image from SharedPreferences
  Future<void> getImageFromLocal() async {
    String image = await LocalData().getImageData();
    setState(() {
      userImageLocal = image;
    });
  }

  // Pick image from camera/gallery
  Future<void> pickImage(ImageSource source) async {
    try {
      final picked = await pickImager.pickImage(source: source);

      if (picked == null) return;

      await LocalData().setImage(imageUrl: picked.path);

      setState(() {
        userImageLocal = picked.path;
      });
    } catch (error) {
      print("Image picker error: $error");
    }
  }

  // Bottom sheet for picking image
  void imagePickFunction() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 350,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Lottie.asset(
                "assets/lottei/Face scanning.json",
                width: 100,
                repeat: false,
              ),
              const SizedBox(height: 20),
              const Text(
                "Pick image",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Gallery button
                  GestureDetector(
                    onTap: () async {
                      await pickImage(ImageSource.gallery);
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: Container(
                      width: 150,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          "Gallery",
                          style: AppTextStyles.mainTopicTextStyle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Camera button
                  GestureDetector(
                    onTap: () async {
                      await pickImage(ImageSource.camera);
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: Container(
                      width: 150,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          "Camera",
                          style: AppTextStyles.mainTopicTextStyle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Logout function
  Future<void> logoutFunction() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 350,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Lottie.asset(
                "assets/lottei/Alert 1.json",
                width: 100,
                repeat: false,
              ),
              const SizedBox(height: 10),
              const Text(
                "Logout",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // YES & NO buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await FirebaseAuthServices().logOutAccount();
                      if (context.mounted) Navigator.pop(context);
                      AppRoutes.route.go("/");
                      setState(() {});
                    },
                    child: Container(
                      width: 120,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 120,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.appPadding),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: imagePickFunction,
                      child: Stack(
                        children: [
                          // Profile Image
                          CircleAvatar(
                            maxRadius: 70,
                            backgroundImage: userImageLocal.isEmpty
                                ? const NetworkImage(
                                        "https://tse1.mm.bing.net/th/id/OIP.vmoycMUOmbcs0Vw-1iIdVAHaHa?rs=1&pid=ImgDetMain&o=7&rm=3",
                                      )
                                      as ImageProvider
                                : FileImage(File(userImageLocal)),
                          ),

                          const Positioned(
                            bottom: 1,
                            right: 1,
                            child: Icon(
                              Icons.add_a_photo,
                              size: 32,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      "Email: ${userName ?? ""}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "ID: ${userData.uid}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              GestureDetector(
                onTap: () => GoRouter.of(context).push("/EdditProfileScreen"),
                child: userPageWidget(
                  svg: "assets/icons/user.svg",
                  title: "User profile",
                  subTitle: "Change profile image, name & password",
                ),
              ),

              Divider(indent: 30, endIndent: 30),
              userPageWidget(
                svg: "assets/icons/menu.svg",
                title: "Accounts",
                subTitle: "Manage accounts and descriptions",
              ),
              Divider(indent: 30, endIndent: 30),
              userPageWidget(
                svg: "assets/icons/message-circle-more.svg",
                title: "Categories",
                subTitle: "Manage categories & sub-categories",
              ),
              Divider(indent: 30, endIndent: 30),
              GestureDetector(
                onTap: () async {
                  await logoutFunction();
                  setState(() {});
                },
                child: userPageWidget(
                  svg: "assets/icons/log-out.svg",
                  title: "Log Out",
                  subTitle: "Log Out in current account",
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget userPageWidget({
    required String svg,
    required String title,
    required String subTitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          SvgPicture.asset(svg),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subTitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
