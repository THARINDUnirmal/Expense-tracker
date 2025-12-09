import 'package:expenzes/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({super.key});

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen>
    with SingleTickerProviderStateMixin {
  // Social URLs
  final String githubUrl = 'https://github.com/THARINDUnirmal';
  final String linkedinUrl =
      'https://www.linkedin.com/in/tharindu-nirmal-b15379338';
  final String instagramUrl = 'https://instagram.com/tharindu_nirmal__';

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url.trim());
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not open link")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Developer Information",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => AppRoutes.route.go("/HomeScreen"),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4AB7B6), Color(0xFFFDAA5D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      AppRoutes.route.push(
                        "/AboutMeImageScreen",
                        extra: "assets/images/userr.jpg",
                      );
                    },
                    child: Hero(
                      tag: 1,
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: AssetImage('assets/images/user.jpg'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Tharindu Nirmal",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Flutter & Full Stack Developer\nBuilding beautiful and functional apps.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _animatedSocialButton(
                      icon: FontAwesomeIcons.github,
                      color: Colors.black,
                      onTap: () => _launchURL(githubUrl),
                    ),
                    const SizedBox(width: 20),
                    _animatedSocialButton(
                      icon: FontAwesomeIcons.linkedin,
                      color: Colors.blue.shade700,
                      onTap: () => _launchURL(linkedinUrl),
                    ),
                    const SizedBox(width: 20),
                    _animatedSocialButton(
                      icon: FontAwesomeIcons.instagram,
                      color: Colors.pink,
                      onTap: () => _launchURL(instagramUrl),
                    ),
                  ],
                ),
                const Spacer(),
                // Footer
                const Text(
                  "© 2025 Tharindu Nirmal",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _animatedSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
