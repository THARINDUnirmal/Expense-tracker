import 'dart:io';

import 'package:expenzes/models/user_model.dart';
import 'package:expenzes/provider/provider_services.dart';
import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/widgets/reuseble_widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
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

  //Text Editing Controllers
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //image piker instanse
  final ImagePicker pickImager = ImagePicker();

  //iamge pick function
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Eddit User Profile",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
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
            child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.appPadding),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFFFFF59D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.center,
                "Add Your Details",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              menuCard(
                childWidget: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Consumer(
                            builder: (context, ProviderServices provider, child) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: imagePickFunction,
                                    child: Stack(
                                      children: [
                                        // Profile Image with shadow
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.15,
                                                ),
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
                                                : FileImage(
                                                    File(provider.userImage),
                                                  ),
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
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      Provider.of<ProviderServices>(
                                        context,
                                        listen: false,
                                      ).deleteUserImageFromLocal();
                                      AppRoutes.route.go("/UserProfileScreen");
                                    },
                                    child: Text(
                                      "Delete Photo",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              menuCard(
                childWidget: Form(
                  child: Column(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuCard({required Widget childWidget}) {
    return Container(
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
      child: childWidget,
    );
  }
}
