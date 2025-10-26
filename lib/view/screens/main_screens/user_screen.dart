import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late String? userName;
  late User userData;
  Future<void> getUser() async {
    User userDataa = FirebaseAuthServices().curruntUserData;
    userName = userDataa.email ?? "No name";
    userData = userDataa;
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.appPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      maxRadius: 70,
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1557862921-37829c790f19?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzh8fHVzZXJ8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=600",
                      ),
                    ),
                    Text(
                      "Email:${userName!}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      maxLines: 2,
                      "Id:${userData.uid}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).push("/EdditProfileScreen");
                },
                child: userPageWidget(
                  svg: "assets/icons/user.svg",
                  subTitle: "Change profile image, name password",
                  title: "User profile",
                ),
              ),
              Divider(endIndent: 30, indent: 30),
              SizedBox(height: 10),
              userPageWidget(
                svg: "assets/icons/menu.svg",
                subTitle: "Monose acccunts and description",
                title: "Accounts",
              ),
              Divider(endIndent: 30, indent: 30),
              SizedBox(height: 10),
              userPageWidget(
                svg: "assets/icons/message-circle-more.svg",
                subTitle: "Manage categories & add sub-categories",
                title: "Categories",
              ),
              Divider(endIndent: 30, indent: 30),
              SizedBox(height: 10),
              userPageWidget(
                svg: "assets/icons/annonymus.svg",
                subTitle: "Protect your app with PIN or Fngerprint",
                title: "Security",
              ),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    backgroundColor: Color(0xfffde4e3),
                  ),
                  onPressed: () async {
                    await FirebaseAuthServices().logOutAccount();
                  },
                  child: Text(
                    "LogOut",
                    style: AppTextStyles.miniTextStyle.copyWith(
                      color: Color(0xffc65d57),
                    ),
                  ),
                ),
              ),
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
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          SvgPicture.asset(svg),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                maxLines: 2,
                subTitle,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
