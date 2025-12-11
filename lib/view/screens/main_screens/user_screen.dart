import 'dart:io';
import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/provider/image_provider_services.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/utils/messages/app_messages.dart';
import 'package:expenzes/widgets/reuseble_widgets/gredient_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
    with SingleTickerProviderStateMixin {
  late String? userName;
  late User userData;
  List<String> allCategeory = [];

  late AnimationController _controller;
  late Animation<double> _animation;

  final ImagePicker pickImager = ImagePicker();

  @override
  void initState() {
    super.initState();
    getUser();
    getAllcategeoryList();

    //animation

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  //get all categeory list
  Future<void> getAllcategeoryList() async {
    //get current userId
    String uId = FirebaseAuthServices().curruntUserData.uid;

    //get all data & add there categeorys in a list
    List<DataModel> allDataList = await FirebaseDatabaseServices().getAllData(
      context: context,
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

  Future<void> pickImage(ImageSource source, BuildContext context) async {
    try {
      final picked = await pickImager.pickImage(source: source);
      if (picked == null) return;
      await Provider.of<ImageProviderServices>(
        context,
        listen: false,
      ).setUserImage(imageUrl: picked.path, context: context);
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
                pickOptionButton("Gallery", ImageSource.gallery, context),
                pickOptionButton("Camera", ImageSource.camera, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget pickOptionButton(
    String title,
    ImageSource source,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () async {
        await pickImage(source, context);
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Profile",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _animation,
        child: GredientPage(
          childWidget: SafeArea(
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
                            builder:
                                (
                                  context,
                                  ImageProviderServices provider,
                                  child,
                                ) {
                                  return GestureDetector(
                                    onTap: imagePickFunction,
                                    child: Stack(
                                      children: [
                                        // Profile Image
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
                                            radius: 60,
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
                                  );
                                },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              "Email: ${userName ?? ""}",
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "ID: ${userData.uid}",
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Menu Items
                    Column(
                      children: [
                        menuCardModern(
                          icon: FontAwesomeIcons.user,
                          title: "User profile",
                          subTitle: "Change profile image, name & password",
                          onTap: () =>
                              GoRouter.of(context).push("/UserProfileScreen"),
                        ),
                        menuCardModern(
                          icon: FontAwesomeIcons.bank,
                          title: "Accounts",
                          subTitle: "Manage accounts and descriptions",
                          onTap: () {
                            AppMessages().showSnackBarMessage(
                              context: context,
                              message:
                                  "Sorry, this link isn’t available right now.",
                            );
                          },
                        ),
                        menuCardModern(
                          icon: FontAwesomeIcons.message,
                          title: "Categories",
                          subTitle: "Manage categories & sub-categories",
                          onTap: () => GoRouter.of(
                            context,
                          ).push("/AllCtegeoryScreen", extra: allCategeory),
                        ),
                        menuCardModern(
                          icon: FontAwesomeIcons.signOut,
                          title: "Log Out",
                          subTitle: "Log Out in current account",
                          onTap: () async {
                            await logoutFunction();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Modern Menu Card
  Widget menuCardModern({
    required IconData icon,
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
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 20),

            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subTitle,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
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
                InkWell(
                  onTap: () async {
                    if (context.mounted) {
                      Navigator.pop(context);
                      GoRouter.of(context).go("/");
                    }
                    await FirebaseAuthServices().logOutAccount(
                      context: context,
                    );
                  },
                  child: logoutButton("Yes", Colors.red, true),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: logoutButton("No", Colors.white, false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget logoutButton(String text, Color color, bool isYes) {
    return Container(
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
    );
  }
}
