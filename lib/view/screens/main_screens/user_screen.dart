import 'dart:io';
import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/provider/provider_services.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late String? userName;
  late User userData;
  List<String> allCategeory = [];

  final ImagePicker pickImager = ImagePicker();

  @override
  void initState() {
    super.initState();
    getUser();
    getAllcategeoryList();
  }

  //get all categeory list
  Future<void> getAllcategeoryList() async {
    //get current userId
    String uId = FirebaseAuthServices().curruntUserData.uid;

    //get all data & add there categeorys in a list
    List<DataModel> allDataList = await FirebaseDatabaseServices().getAllData(
      curruntUserId: uId,
    );

    List<String> dataList = [];

    for (DataModel i in allDataList) {
      if (!allCategeory.contains(i.category)) {
        dataList.add(i.category!);
      }
    }

    setState(() {
      allCategeory = dataList;
    });
  }

  Future<void> getUser() async {
    User userDataa = FirebaseAuthServices().curruntUserData;
    userName = userDataa.isAnonymous ? "Anonymous User" : userDataa.email;
    userData = userDataa;
    setState(() {});
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final picked = await pickImager.pickImage(source: source);
      if (picked == null) return;
      await Provider.of<ProviderServices>(
        context,
        listen: false,
      ).setUserImage(imageUrl: picked.path);
    } catch (error) {
      print("Image picker error: $error");
    }
  }

  void imagePickFunction() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: 350,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                pickOptionButton("Gallery", ImageSource.gallery),
                pickOptionButton("Camera", ImageSource.camera),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget pickOptionButton(String title, ImageSource source) {
    return GestureDetector(
      onTap: () async {
        await pickImage(source);
        if (context.mounted) Navigator.pop(context);
      },
      child: Container(
        width: 140,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade600],
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppConstants.appPadding),
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
                children: [
                  //Profile Section
                  Center(
                    child: Column(
                      children: [
                        Consumer(
                          builder: (context, ProviderServices provider, child) {
                            return GestureDetector(
                              onTap: imagePickFunction,
                              child: Stack(
                                children: [
                                  // Profile Image with shadow
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 70,
                                      backgroundImage:
                                          provider.userImage.isEmpty
                                          ? const NetworkImage(
                                                  "https://tse1.mm.bing.net/th/id/OIP.vmoycMUOmbcs0Vw-1iIdVAHaHa?rs=1&pid=ImgDetMain&o=7&rm=3",
                                                )
                                                as ImageProvider
                                          : FileImage(File(provider.userImage)),
                                    ),
                                  ),

                                  // Camera icon overlay
                                  const Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.add_a_photo,
                                        size: 28,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Email: ${userName ?? ""}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "ID: ${userData.uid}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Menu Items
                  Column(
                    children: [
                      menuCardModern(
                        svg: "assets/icons/user.svg",
                        title: "User profile",
                        subTitle: "Change profile image, name & password",
                        onTap: () =>
                            GoRouter.of(context).push("/EdditProfileScreen"),
                      ),
                      menuCardModern(
                        svg: "assets/icons/menu.svg",
                        title: "Accounts",
                        subTitle: "Manage accounts and descriptions",
                      ),
                      menuCardModern(
                        svg: "assets/icons/message-circle-more.svg",
                        title: "Categories",
                        subTitle: "Manage categories & sub-categories",
                        onTap: () => AppRoutes.route.push(
                          "/AllCtegeoryScreen",
                          extra: allCategeory,
                        ),
                      ),
                      menuCardModern(
                        svg: "assets/icons/log-out.svg",
                        title: "Log Out",
                        subTitle: "Log Out in current account",
                        onTap: logoutFunction,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Modern Menu Card
  Widget menuCardModern({
    required String svg,
    required String title,
    required String subTitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                svg,
                width: 28,
                height: 28,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 20),

            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subTitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget menuCard({
    required String iconPath,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 30,
              height: 30,
              color: Colors.blue,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
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
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<void> logoutFunction() async {
    // Simple modern alert using bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: 370,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.redAccent,
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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Are you sure you want to logout?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                logoutButton("Yes", Colors.red, true),
                logoutButton("No", Colors.white, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget logoutButton(String text, Color color, bool isYes) {
    return GestureDetector(
      onTap: () async {
        if (isYes) {
          await FirebaseAuthServices().logOutAccount();
          if (context.mounted) Navigator.pop(context);
          AppRoutes.route.go("/");
        } else {
          Navigator.pop(context);
        }
      },
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
          color: isYes ? color : Colors.white,
          border: Border.all(color: Colors.red, width: isYes ? 0 : 2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isYes ? Colors.white : Colors.red,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
