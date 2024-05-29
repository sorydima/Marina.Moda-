import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:marinamoda/utils/constants.dart';

class AdHelper {
  static int interstialcnt = 0;
  static int rewardcnt = 0;

  int maxFailedLoadAttempts = 3;

  static InterstitialAd? _interstitialAd;
  static int _numInterstitialLoadAttempts = 0;

  static int _numRewardAttempts = 0;

  static RewardedAd? _rewardedAd;

  static AdRequest request = const AdRequest(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    nonPersonalizedAds: true,
  );

  static initialize() {
    MobileAds.instance.initialize();
  }

  static BannerAd createBannerAd() {
    BannerAd? ad;
    if (Platform.isAndroid && bannerAdIs == true) {
      ad = BannerAd(
          size: AdSize.banner,
          adUnitId: bannerAdUnitId,
          request: const AdRequest(),
          listener: BannerAdListener(
              onAdLoaded: (Ad ad) => log('Ad Loaded'),
              onAdClosed: (Ad ad) => log('Ad Closed'),
              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                ad.dispose();
              },
              onAdOpened: (Ad ad) => log('Ad Open')));
      return ad;
    }
    if (Platform.isIOS && iosBannerAdIs == true) {
      ad = BannerAd(
          size: AdSize.banner,
          adUnitId: bannerAdUnitId,
          request: const AdRequest(),
          listener: BannerAdListener(
              onAdLoaded: (Ad ad) => log('Ad Loaded'),
              onAdClosed: (Ad ad) => log('Ad Closed'),
              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                ad.dispose();
              },
              onAdOpened: (Ad ad) => log('Ad Open')));
      return ad;
    }
    return ad!;
  }

  static void createInterstitialAd() {
    if (Platform.isAndroid && interstialAdIs == true) {
      InterstitialAd.load(
          adUnitId: interstitialAdUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              log('====> inter ads $ad');
              _interstitialAd = ad;
              _numInterstitialLoadAttempts = 0;
              ad.setImmersiveMode(true);
            },
            onAdFailedToLoad: (LoadAdError error) {
              log('InterstitialAd failed to load: $error');
            },
          ));
    }
    if (Platform.isIOS && iosinterstialAdIs == true) {
      InterstitialAd.load(
          adUnitId: interstitialAdUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              log('====> inter ads $ad');
              _interstitialAd = ad;
              _numInterstitialLoadAttempts = 0;
              ad.setImmersiveMode(true);
            },
            onAdFailedToLoad: (LoadAdError error) {
              log('InterstitialAd failed to load: $error');
            },
          ));
    }
  }

  static showInterstitialAd() {
    log('===>$_numInterstitialLoadAttempts');
    log('===>$maxInterstitialAdclick');
    if (_numInterstitialLoadAttempts == maxInterstitialAdclick) {
      _numInterstitialLoadAttempts = 0;
      if (_interstitialAd == null) {
        log('Warning: attempt to show interstitial before loaded.');

        return false;
      }
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) =>
            log('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          log('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          log('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      return;
    }
    _numInterstitialLoadAttempts += 1;
  }

  static createRewardedAd() {
    RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            log('$ad loaded.');
            _rewardedAd = ad;
            _numRewardAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardAttempts += 1;
            if (_numRewardAttempts <= maxRewardAdclick) {
              createRewardedAd();
            }
          },
        ));
  }

  static showRewardedAd() {
    log('===>$_numRewardAttempts');
    log('===>$maxRewardAdclick');
    if (_numRewardAttempts == maxRewardAdclick) {
      if (_rewardedAd == null) {
        log('Warning: attempt to show rewarded before loaded.');
        return;
      }
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) =>
            log('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          log('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          log('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          createRewardedAd();
        },
      );

      _rewardedAd!.setImmersiveMode(true);
      _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        log('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
      });
      _rewardedAd = null;
    }
    _numRewardAttempts += 1;
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return bannerAdId.toString();
    } else if (Platform.isIOS) {
      return iosBannerAdId.toString();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return interstialAdId.toString();
    } else if (Platform.isIOS) {
      return iosinterstialAdId.toString();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return rewardAdId.toString();
    } else if (Platform.isIOS) {
      return iosrewardAdId.toString();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
