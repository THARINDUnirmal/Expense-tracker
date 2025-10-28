import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/utils/messages/app_messages.dart';
import 'package:expenzes/widgets/reuseble_widgets/custom_text_field.dart';
import 'package:expenzes/widgets/reuseble_widgets/small_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //Loading state
  bool isLoading = false;
  bool isIconLoad = false;
  //form key
  final _formKey = GlobalKey<FormState>();
  //TextEditingControllers
  final TextEditingController _emailContraller = TextEditingController();
  final TextEditingController _nameContraller = TextEditingController();
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

  //Email login
  Future<void> registerUser(String userEmail, String userPassword) async {
    await FirebaseAuthServices().registerEmail(
      email: userEmail,
      password: userPassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.appPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: AppConstants.appPadding * 1.5),
                Container(
                  padding: EdgeInsets.all(AppConstants.appPadding + 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.appCreamColor,
                    borderRadius: BorderRadius.circular(15),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppConstants.appPadding),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Finance",
                            style: TextStyle(
                              fontSize: 40,
                              color: Color(0xfffdaa5d),
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: "Mate",
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Color(0xff4ab7b6),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppConstants.appPadding + 10),
                      Text(
                        "Sign Up For Free",
                        style: AppTextStyles.mainTopicTextStyle,
                      ),
                      Text(
                        "Sign Up to your account",
                        style: AppTextStyles.subTopicTextStyle,
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              issecurText: false,
                              controller: _nameContraller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter User name";
                                } else {
                                  return null;
                                }
                              },
                              labaleTexts: "User name",
                              icon: Icons.people,
                            ),
                            SizedBox(height: AppConstants.appPadding),
                            CustomTextField(
                              issecurText: false,
                              controller: _emailContraller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter an email";
                                } else if (!RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                ).hasMatch(value)) {
                                  return "Please enter valid email";
                                } else {
                                  return null;
                                }
                              },
                              labaleTexts: "Email",
                              icon: Icons.email_outlined,
                            ),
                            SizedBox(height: AppConstants.appPadding),
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
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8,
                                    color: Colors.grey.withOpacity(0.5),
                                    offset: Offset(15, 15),
                                  ),
                                  BoxShadow(
                                    blurRadius: 1,
                                    color: Colors.white,
                                    offset: Offset(-1, 0),
                                  ),
                                ],
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await registerUser(
                                        _emailContraller.text,
                                        _passwordContraller.text,
                                      );

                                      await Future.delayed(
                                        Duration(seconds: 2),
                                      );
                                    } catch (error) {
                                      print(error.toString());
                                    } finally {
                                      setState(() {
                                        isLoading = false;
                                      });

                                      GoRouter.of(context).go("/");
                                    }
                                  }
                                },
                                child: isLoading
                                    ? CircularProgressIndicator()
                                    : Text(
                                        "Register",
                                        style: AppTextStyles.mainTopicTextStyle,
                                      ),
                              ),
                            ),
                            SizedBox(height: AppConstants.appPadding + 5),
                            Text(
                              "Or continue with",
                              style: AppTextStyles.subTopicTextStyle,
                            ),
                            SizedBox(height: AppConstants.appPadding + 5),
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
                              isLoading: false,
                              svgImage: "assets/icons/icons8-apple.svg",
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await googleSign();
                            },
                            child: SmallCardWidget(
                              isLoading: false,
                              svgImage: "assets/icons/icons8-google.svg",
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              try {
                                setState(() {
                                  isIconLoad = true;
                                });
                                await FirebaseAuthServices().logAsAnnonymus();
                              } catch (e) {
                                AppMessages().appMessage(e.toString(), context);
                              } finally {
                                setState(() {
                                  isIconLoad = false;
                                });
                                GoRouter.of(context).go("/");
                              }
                            },
                            child: SmallCardWidget(
                              isLoading: isIconLoad,
                              svgImage: "assets/icons/annonymus.svg",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppConstants.appPadding + 5),
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(context).go("/LoginScreen");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: AppTextStyles.subTopicTextStyle,
                            ),
                            Text(
                              "Sign In",
                              style: AppTextStyles.subTopicTextStyle.copyWith(
                                color: AppColors.appBlueColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppConstants.appPadding),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
