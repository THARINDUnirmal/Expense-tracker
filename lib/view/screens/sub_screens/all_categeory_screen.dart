import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/widgets/reuseble_widgets/categeory_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AllCategeoryScreen extends StatefulWidget {
  final List<String> categeoryList;
  const AllCategeoryScreen({super.key, required this.categeoryList});

  @override
  State<AllCategeoryScreen> createState() => _AllCategeoryScreenState();
}

class _AllCategeoryScreenState extends State<AllCategeoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  BannerAd? _bannerAd;
  // Set to true to use Google's test ad (always use this during development)
  final bool _useTestAds = true;

  @override
  void initState() {
    super.initState();

    // Initialize banner ad
    final String adUnitId = _useTestAds
        ? 'ca-app-pub-3940256099942544/6300978111' // Google test ad
        : 'ca-app-pub-3718682109484928/3605287211'; //real ad unit

    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {}); // Refresh to display the ad
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();

    //animation
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
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: _bannerAd == null
          ? const SizedBox()
          : SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              width: _bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "All Ctegeory Data",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB3E5FC), Color(0xFFFFF59D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.appPadding),
            child: widget.categeoryList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "No Categories Yet!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Add a new category to get started.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: GridView.builder(
                      itemCount: widget.categeoryList.toSet().toList().length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 10 / 5,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        String indexValue = widget.categeoryList
                            .toSet()
                            .toList()[index];
                        return InkWell(
                          onTap: () {
                            AppRoutes.route.push(
                              "/SingleCategeoryScreen",
                              extra: indexValue,
                            );
                          },
                          child: CategoryCardWidget(title: indexValue),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
