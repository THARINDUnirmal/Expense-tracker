import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/utils/messages/app_messages.dart';
import 'package:expenzes/widgets/reuseble_widgets/custom_text_field.dart';
import 'package:expenzes/widgets/reuseble_widgets/small_card_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();
  //TextEditingControllers
  final TextEditingController _emailContraller = TextEditingController();
  final TextEditingController _passwordContraller = TextEditingController();

  //googleSign
  Future<void> googleSign() async {
    try {
      await FirebaseAuthServices().googleSignInMethord();
    } catch (error) {
      if (context.mounted) {
        AppMessages().appMessage(error.toString(), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.appPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(AppConstants.appPadding + 5),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.appCreamColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(15, 15),
                    ),
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.white,
                      offset: Offset(-15, -12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: AppConstants.appPadding * 2),
                    Text(
                      "Welcome Back",
                      style: AppTextStyles.mainTopicTextStyle,
                    ),
                    SizedBox(height: AppConstants.appPadding / 2),
                    Text(
                      "Sign In to your account",
                      style: AppTextStyles.subTopicTextStyle,
                    ),
                    SizedBox(height: AppConstants.appPadding * 3),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            issecurText: false,
                            controller: _emailContraller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter email!";
                              } else {
                                return null;
                              }
                            },
                            labaleTexts: "Email",
                            icon: Icons.email_outlined,
                          ),
                          SizedBox(height: AppConstants.appPadding * 2),
                          CustomTextField(
                            issecurText: true,
                            controller: _passwordContraller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter password!";
                              } else if (value.length < 6) {
                                return "Password mus have 7 or more char!";
                              } else {
                                return null;
                              }
                            },
                            labaleTexts: "Password",
                            icon: Icons.lock_outline,
                          ),
                          SizedBox(height: AppConstants.appPadding * 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //todo - Forgot Password action !
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: AppTextStyles.subTopicTextStyle
                                      .copyWith(color: AppColors.appBlueColor),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppConstants.appPadding * 2),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.07,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 15,
                                  // ignore: deprecated_member_use
                                  color: Colors.grey.withOpacity(0.5),
                                  offset: Offset(15, 15),
                                ),
                                BoxShadow(
                                  blurRadius: 1,
                                  color: Colors.white,
                                  offset: Offset(-5, 0),
                                ),
                              ],
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {}
                              },
                              child: Text(
                                "Login",
                                style: AppTextStyles.subTopicTextStyle.copyWith(
                                  color: AppColors.appBlackColor,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: AppConstants.appPadding * 2),
                          Text(
                            "Or continue with",
                            style: AppTextStyles.subTopicTextStyle,
                          ),
                          SizedBox(height: AppConstants.appPadding * 2),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            AppMessages().appMessage(
                              "This function not valid this time!",
                              context,
                            );
                          },
                          child: SmallCardWidget(
                            svgImage: "assets/icons/icons8-apple.svg",
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await googleSign();
                          },
                          child: SmallCardWidget(
                            svgImage: "assets/icons/icons8-google.svg",
                          ),
                        ),
                        SmallCardWidget(
                          svgImage: "assets/icons/icons8-facebook.svg",
                        ),
                      ],
                    ),
                    SizedBox(height: AppConstants.appPadding * 2),
                    GestureDetector(
                      onTap: () {
                        //todo - sign up
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: AppTextStyles.subTopicTextStyle,
                          ),
                          Text(
                            "Sign up",
                            style: AppTextStyles.subTopicTextStyle.copyWith(
                              color: AppColors.appBlueColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppConstants.appPadding * 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
