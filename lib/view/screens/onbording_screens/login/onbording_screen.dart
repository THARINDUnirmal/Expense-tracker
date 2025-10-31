import 'package:animated_gradient_text/animated_gradient_text.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/widgets/custom_button.dart';
import 'package:expenzes/widgets/page_view_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

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
      backgroundColor: Color(0xffffffff),
      body: Padding(
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    Lottie.asset("assets/lottei/Welcome.json"),
                  ],
                ),
                SizedBox(height: 100),
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
                    colors: [Color.fromARGB(31, 99, 97, 97), Colors.white],
                    textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    text: "> > >",
                  ),
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
        pageIndex == 0
            ? GestureDetector(
                onTap: () {
                  isLastPage
                      ? GoRouter.of(context).go("/LoginScreen")
                      : _contraller.nextPage(
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInOut,
                        );
                },
                child: CustomButton(title: ">>>"),
              )
            : GestureDetector(
                onTap: () {
                  isLastPage
                      ? GoRouter.of(context).go("/LoginScreen")
                      : _contraller.nextPage(
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInOut,
                        );
                },
                child: CustomButton(title: isLastPage ? "GetStared" : "Next"),
              ),
      ],
    );
  }
}
