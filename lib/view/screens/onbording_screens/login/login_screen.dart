import 'package:expenzes/models/user_model.dart';
import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/utils/messages/app_messages.dart';
import 'package:expenzes/widgets/reuseble_widgets/custom_text_field.dart';
import 'package:expenzes/widgets/reuseble_widgets/small_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Loading state
  bool isLoading = false;
  bool isIconLoad = false;
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

  //Email login
  Future<void> emailSign(String userEmail, String userPassword) async {
    await FirebaseAuthServices().loginWIthEmail(
      email: userEmail,
      password: userPassword,
    );
  }

  @override
  void dispose() {
    _emailContraller.dispose();
    _passwordContraller.dispose();
    super.dispose();
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
                        "Welcome Back",
                        style: AppTextStyles.mainTopicTextStyle,
                      ),
                      Text(
                        "Sign In to your account",
                        style: AppTextStyles.subTopicTextStyle,
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
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
                            SizedBox(height: AppConstants.appPadding + 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    AppRoutes.route.push("/ResetScreen");
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: AppTextStyles.subTopicTextStyle
                                        .copyWith(
                                          color: AppColors.appBlueColor,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppConstants.appPadding),
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
                                      await emailSign(
                                        _emailContraller.text,
                                        _passwordContraller.text,
                                      );

                                      await Future.delayed(
                                        Duration(seconds: 2),
                                      );
                                      GoRouter.of(context).go("/");
                                    } catch (error) {
                                      print(error.toString());
                                    } finally {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  }
                                },
                                child: isLoading
                                    ? CircularProgressIndicator()
                                    : Text(
                                        "Login",
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
                              UserModel googleUser = UserModel(
                                userId: "",
                                name: "",
                                email: FirebaseAuthServices()
                                    .curruntUserData
                                    .email!,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                              );
                              await FirebaseDatabaseServices().addUser(
                                googleUser,
                              );
                              GoRouter.of(context).go("/");
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
                                setState(() {});
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
                          GoRouter.of(context).go("/RegisterScreen");
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
      ),
    );
  }
}
