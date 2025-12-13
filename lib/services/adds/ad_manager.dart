import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

class AdManager {
  /// ================= SETTINGS =================
  static const bool _useTestAds = true;

  static String get bannerAdUnitId => _useTestAds
      ? 'ca-app-pub-3940256099942544/6300978111' // TEST BANNER
      : 'ca-app-pub-3718682109484928/3605287211'; // REAL BANNER

  static String get interstitialAdUnitId => _useTestAds
      ? 'ca-app-pub-3940256099942544/1033173712' // TEST INTERSTITIAL
      : 'ca-app-pub-3718682109484928/8739182446'; // REAL INTERSTITIAL

  /// ================= INTERSTITIAL =================
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialReady = false;

  /// Load Interstitial (call once)
  static void loadInterstitial() {
    if (_isInterstitialReady) return;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isInterstitialReady = false;
        },
      ),
    );
  }

  /// Show Interstitial (call from any page)
  static void showInterstitial() {
    if (_interstitialAd != null && _isInterstitialReady) {
      _interstitialAd!.show();
      _interstitialAd = null;
      _isInterstitialReady = false;
      loadInterstitial(); // preload next
    }
  }

  /// ================= BANNER =================
  static BannerAd createBannerAd(VoidCallback onLoaded) {
    return BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
  }
}
