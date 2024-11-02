import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdManager {
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9214589741'
      : 'ca-app-pub-3940256099942544/2435281174';
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  void initializeBannerAd(Function(BannerAd?) onAdLoaded) {
    _loadAd(onAdLoaded);
  }

  void _loadAd(Function(BannerAd?) onAdLoaded) {
    final ad = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isLoaded = true;
          onAdLoaded(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onAdLoaded(null);
        },
      ),
    );
    ad.load();
  }

  void dispose() {
    _bannerAd?.dispose();
  }
}

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  final BannerAdManager _adManager = BannerAdManager();
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _adManager.initializeBannerAd((ad) {
      setState(() {
        _bannerAd = ad;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _bannerAd != null
        ? SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : const SizedBox.shrink(); // Show an empty widget if no ad is loaded
  }

  @override
  void dispose() {
    _adManager.dispose();
    super.dispose();
  }
}
