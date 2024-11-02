// services/admobs/banner_ad_manager.dart
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdManager {
  final String adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9214589741'
      : 'ca-app-pub-3940256099942544/2435281174';

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print('Ad loaded: ${ad.adUnitId}'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: ${error.message}');
          ad.dispose();
        },
      ),
    );
  }
}
