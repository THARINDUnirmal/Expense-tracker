import 'package:animated_gradient_text/animated_gradient_text.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/widgets/custom_button.dart';
import 'package:expenzes/widgets/page_view_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  bool isLastPage = false;
  int pageIndex = 0;

  final PageController _contraller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFFFFF59D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.appPadding),
          child: PageView(
            controller: _contraller,
            onPageChanged: (index) {
              setState(() {
                pageIndex = index;
                isLastPage = index == 3;
              });
            },
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      Lottie.asset("assets/lottei/Welcome.json"),
                    ],
                  ),
                  SizedBox(height: 100),
                  Column(
                    children: [
                      Dismissible(
                        key: GlobalKey(),
                        onDismissed: (direction) {
                          _contraller.nextPage(
                            duration: Duration(seconds: 2),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: AnimatedGradientText(
                          animationDuration: 2,
                          colors: [
                            Color.fromARGB(31, 99, 97, 97),
                            Colors.white,
                          ],
                          textStyle: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                          text: "> > >",
                        ),
                      ),
                      Text(
                        "Slide to the right",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              pageContentColum(
                title: "Meet Your Money Buddy 💰",
                content:
                    "Say goodbye to lost receipts and forgotten expenses. We’ll help you track every rupee, effortlessly!",
                lottieAnimation:
                    "assets/lottei/Wallet Essentials_ Money & Savings.json",
              ),

              pageContentColum(
                title: "Be the Boss of Your Bucks 💸",
                content:
                    "Set budgets, get friendly alerts, and make sure your money goes where it matters most.",
                lottieAnimation:
                    "assets/lottei/Growth Investment. Flat, Modern, Gradient..json",
              ),
              pageContentColum(
                title: "Hit Your Goals 🎯",
                content:
                    "Track your progress, save smartly, and celebrate every milestone. Your financial wins, big and small!",
                lottieAnimation:
                    "assets/lottei/Event Budgeting Breakdown - Hero.json",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pageContentColum({
    required String title,
    required String content,
    required String lottieAnimation,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PageViewContent(
          lottieAnimation: lottieAnimation,
          title: title,
          content: content,
        ),

        GestureDetector(
          onTap: () async {
            // isLastPage
            //     ? GoRouter.of(context).go("/LoginScreen")
            //     : _contraller.nextPage(
            //         duration: Duration(seconds: 1),
            //         curve: Curves.easeInOut,
            //       );

            if (isLastPage) {
              // Mark onboarding as completed
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('seenOnboarding', true);

              // Navigate to login screen
              GoRouter.of(context).go("/LoginScreen");
            } else {
              _contraller.nextPage(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              );
            }
          },
          child: CustomButton(title: isLastPage ? "GetStared" : "Next"),
        ),
      ],
    );
  }
}
