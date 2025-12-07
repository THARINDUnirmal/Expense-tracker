import 'package:expenzes/models/user_model.dart';
import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/app_colors.dart';

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

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  //Loading state
  bool isLoading = false;
  bool isIconLoad = false;
  bool anonymusLoad = false;
  //form key
  final _formKey = GlobalKey<FormState>();
  //TextEditingControllers
  final TextEditingController _emailContraller = TextEditingController();
  final TextEditingController _passwordContraller = TextEditingController();

  //googleSign
  Future<void> googleSign() async {
    try {
      await FirebaseAuthServices().googleSignInMethord(context);
    } catch (error) {
      if (context.mounted) {
        AppMessages().appAlertMessage(error.toString(), context);
      }
    }
  }

  //Email login
  Future<void> emailSign(String userEmail, String userPassword) async {
    await FirebaseAuthServices().loginWIthEmail(
      context: context,
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
      backgroundColor: Colors.transparent,
      body: FadeTransition(
        opacity: _animation,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB3E5FC), Color(0xFFFFF59D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  /// App Title
                  Text(
                    "FinanceMate",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [Color(0xfffdaa5d), Color(0xff4ab7b6)],
                        ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Glassmorphism Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 1,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ],
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Sign in to continue",
                          style: TextStyle(fontSize: 15, color: Colors.black54),
                        ),
                        const SizedBox(height: 30),

                        /// Form
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
                                  }
                                  return null;
                                },
                                labaleTexts: "Email",
                                icon: Icons.email_outlined,
                              ),
                              const SizedBox(height: 20),

                              CustomTextField(
                                issecurText: true,
                                controller: _passwordContraller,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter password!";
                                  } else if (value.length < 6) {
                                    return "Password must have 6+ characters!";
                                  }
                                  return null;
                                },
                                labaleTexts: "Password",
                                icon: Icons.lock_outline,
                              ),

                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    AppRoutes.route.push("/ResetScreen");
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: AppColors.appBlueColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 25),

                              /// Modern Login Button
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    backgroundColor: const Color(0xff4ab7b6),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => isLoading = true);
                                      try {
                                        await emailSign(
                                          _emailContraller.text,
                                          _passwordContraller.text,
                                        );
                                        await Future.delayed(
                                          Duration(seconds: 1),
                                        );
                                        AppRoutes.route.go("/");
                                        setState(() {});
                                      } finally {
                                        setState(() => isLoading = false);
                                      }
                                    }
                                  },
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          "Login",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 25),

                              Text(
                                "Or continue with",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),

                        /// Social Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                AppMessages().appAlertMessage(
                                  "Apple sign-in is only available on iOS",
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
                                  userId: FirebaseAuthServices()
                                      .curruntUserData
                                      .uid,
                                  name: "",
                                  email: FirebaseAuthServices()
                                      .curruntUserData
                                      .email!,
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                );
                                if (context.mounted) {
                                  await FirebaseDatabaseServices().addUser(
                                    googleUser,
                                    context,
                                  );
                                }

                                if (context.mounted) {
                                  GoRouter.of(context).go("/");
                                }
                                setState(() {});
                              },
                              child: SmallCardWidget(
                                isLoading: false,
                                svgImage: "assets/icons/icons8-google.svg",
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  anonymusLoad = true;
                                });
                                await FirebaseAuthServices().logAsAnnonymus(
                                  context: context,
                                );

                                setState(() {
                                  anonymusLoad = false;
                                });
                                AppRoutes.route.go("/");
                                setState(() {});
                              },
                              child: SmallCardWidget(
                                isLoading: anonymusLoad,
                                svgImage: "assets/icons/annonymus.svg",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context).go("/RegisterScreen");
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Don’t have an account? ",
                                style: TextStyle(color: Colors.black87),
                                children: [
                                  TextSpan(
                                    text: "Tap to create",
                                    style: TextStyle(
                                      color: AppColors.appBlueColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
