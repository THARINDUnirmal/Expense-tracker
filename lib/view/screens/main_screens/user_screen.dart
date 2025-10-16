import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

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
                      "Tharindu Nirmal",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Id:0zzxx",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              userPageWidget(
                svg: "assets/icons/user.svg",
                subTitle: "Change profile image, name password",
                title: "User profile",
              ),
              Divider(endIndent: 30, indent: 30),
              SizedBox(height: 10),
              userPageWidget(
                svg: "assets/icons/user.svg",
                subTitle: "Monose acccunts and description",
                title: "Accounts",
              ),
              Divider(endIndent: 30, indent: 30),
              SizedBox(height: 10),
              userPageWidget(
                svg: "assets/icons/user.svg",
                subTitle: "Manage categories & add sub-categories",
                title: "Categories",
              ),
              Divider(endIndent: 30, indent: 30),
              SizedBox(height: 10),
              userPageWidget(
                svg: "assets/icons/user.svg",
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
                  onPressed: () {},
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
      padding: EdgeInsets.all(AppConstants.appPadding),
      child: Row(
        children: [
          SvgPicture.asset(svg),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: 14,
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
