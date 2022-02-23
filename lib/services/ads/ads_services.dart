import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Object
final AdsServices adsServices = AdsServices();

class AdsServices {
  // Singleton
  static final _instance = AdsServices._constructor();
  AdsServices._constructor();

  factory AdsServices() {
    return _instance;
  }

  // Process
  final int _maxFailedLoadAttempts = 3;
  // Rewarded
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  final _rewardedAdId = "ca-app-pub-5818697676197672/2121125718";
  // Interstitial
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  final _interstitialAdId = "ca-app-pub-5818697676197672/6799393865";
  // Banner
  BannerAd? _anchoredBanner;
  bool _loadAnchoredBanner = false;
  final _bannerAdId = "ca-app-pub-5818697676197672/5486312198";

  // Getter
  RewardedAd? get rewardedAd => _rewardedAd;
  InterstitialAd? get interstitialAd => _interstitialAd;
  BannerAd? get bannerAd => _anchoredBanner;
  bool get loadAnchoredBanner => _loadAnchoredBanner;

  //  Setter
  void createRewardedAd() {
    RewardedAd.load(
      adUnitId: _rewardedAdId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
          _numRewardedLoadAttempts += 1;
          if (_numRewardedLoadAttempts <= _maxFailedLoadAttempts) {
            createRewardedAd();
          }
        },
      ),
    );
  }

  void showRewardedAd() {
    if (_rewardedAd == null) {
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {},
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!
        .show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {});
    _rewardedAd = null;
  }

  void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts <= _maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {},
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void createAnchoredBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      debugPrint('Unable to get height of anchored banner.');
      return;
    }

    final BannerAd banner = BannerAd(
      size: size,
      adUnitId: _bannerAdId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('$BannerAd loaded.');
          _anchoredBanner = ad as BannerAd?;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => debugPrint('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => debugPrint('$BannerAd onAdClosed.'),
      ),
      request: const AdRequest(),
    );
    return banner.load();
  }

  void setLoadBanner(bool value) {
    _loadAnchoredBanner = value;
  }
}
