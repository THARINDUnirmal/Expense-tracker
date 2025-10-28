import 'package:expenzes/widgets/page_view_content.dart';
import 'package:flutter/material.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  final PageController _contraller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: PageView(
          controller: _contraller,
          children: [
            PageViewContent(
              title: "Meet Your Money Buddy 💰",
              content:
                  "Say goodbye to lost receipts and forgotten expenses. We’ll help you track every rupee, effortlessly!",
              lottieAnimation:
                  "assets/lottei/Wallet Essentials_ Money & Savings.json",
              isLast: false,
            ),
            PageViewContent(
              title: "Be the Boss of Your Bucks 💸",
              content:
                  "Set budgets, get friendly alerts, and make sure your money goes where it matters most.",
              lottieAnimation:
                  "assets/lottei/Growth Investment. Flat, Modern, Gradient..json",
              isLast: false,
            ),
            PageViewContent(
              title: "Hit Your Goals 🎯",
              content:
                  "Track your progress, save smartly, and celebrate every milestone. Your financial wins, big and small!",
              lottieAnimation:
                  "assets/lottei/Event Budgeting Breakdown - Hero.json",
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}
