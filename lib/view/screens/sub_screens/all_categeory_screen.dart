import 'package:expenzes/services/adds/ad_manager.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/widgets/reuseble_widgets/categeory_card_widget.dart';
import 'package:expenzes/widgets/reuseble_widgets/gredient_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void initState() {
    super.initState();

    // Banner load
    _bannerAd = AdManager.createBannerAd(() => setState(() {}))..load();

    // Interstitial preload
    AdManager.loadInterstitial();

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
              width: double.infinity,
              child: AdWidget(ad: _bannerAd!),
            ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => GoRouter.of(context).pop(),
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
        child: GredientPage(
          childWidget: Padding(
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
                            GoRouter.of(
                              context,
                            ).push("/SingleCategeoryScreen", extra: indexValue);
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
