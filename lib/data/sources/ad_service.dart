import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService with WidgetsBindingObserver {
  // Vos IDs configurés (PRODUCTION)
  static const String bannerId = 'ca-app-pub-2282149611905342/2104770491';
  static const String interstitialId = 'ca-app-pub-2282149611905342/8821058363';
  static const String rewardedInterstitialId = 'ca-app-pub-2282149611905342/7507976697';
  static const String nativeId = 'ca-app-pub-2282149611905342/1638700781';
  static const String appOpenId = 'ca-app-pub-2282149611905342/5445608497';
  static const String rewardedId = 'ca-app-pub-2282149611905342/3805699127';

  AppOpenAd? _appOpenAd;
  bool _isShowingOpenAd = false;
  DateTime? _appOpenLoadTime;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;

  RewardedAd? _rewardedAd;
  bool _isRewardedLoading = false;

  // Singleton pattern via static instance
  static final AdService _instance = AdService.internal();
  static AdService get instance => _instance;
  
  // Constructeur interne rendu public pour les tests
  AdService.internal();
  
  // Constructeur par défaut qui retourne le singleton
  factory AdService() => _instance;

  /// Initialise le SDK Google Ads et prépare les pubs
  static Future<void> initialize() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      debugPrint("ℹ️ AdMob non supporté sur cette plateforme.");
      return;
    }

    try {
      await MobileAds.instance.initialize();
      _instance.startListeningToLifecycle(); // Ajout de l'écoute du cycle de vie
      _instance.loadAppOpenAd();
      _instance.loadInterstitialAd();
      _instance.loadRewardedAd();
      debugPrint("✅ AdMob Initialisé.");
    } catch (e) {
      debugPrint("⚠️ AdMob Initialization Warning: $e");
      // On ne fait pas planter l'app, on réessayera plus tard au premier besoin de pub
    }
  }

  void startListeningToLifecycle() {
    WidgetsBinding.instance.addObserver(this);
  }

  void stopListeningToLifecycle() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      showAppOpenAdIfAvailable();
    }
  }

  /// --- APP OPEN AD ---
  void loadAppOpenAd({bool showImmediately = false}) {
    AppOpenAd.load(
      adUnitId: appOpenId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenLoadTime = DateTime.now();
          debugPrint("✅ AppOpenAd chargée.");
          if (showImmediately) {
            showAppOpenAdIfAvailable();
          }
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ AppOpen failed to load: $error');
          // Tentative de rechargement après 30 secondes
          Future.delayed(const Duration(seconds: 30), () => loadAppOpenAd());
        },
      ),
    );
  }

  void showAppOpenAdIfAvailable() {
    if (_appOpenAd == null) {
      loadAppOpenAd();
      return;
    }
    
    if (_isShowingOpenAd) return;

    if (DateTime.now().difference(_appOpenLoadTime!) > const Duration(hours: 4)) {
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAppOpenAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => _isShowingOpenAd = true,
      onAdDismissedFullScreenContent: (ad) {
        _isShowingOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );
    _appOpenAd!.show();
  }

  /// --- INTERSTITIAL AD (Scan) ---
  void loadInterstitialAd() {
    if (_isInterstitialLoading || _interstitialAd != null) return;
    _isInterstitialLoading = true;
    
    InterstitialAd.load(
      adUnitId: interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed: $error');
          _isInterstitialLoading = false;
          _interstitialAd = null;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      loadInterstitialAd();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  /// --- REWARDED AD ---
  void loadRewardedAd() {
    if (_isRewardedLoading || _rewardedAd != null) return;
    _isRewardedLoading = true;

    RewardedAd.load(
      adUnitId: rewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded failed: $error');
          _isRewardedLoading = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  void showRewardedAd(Function onRewardEarned, Function onAdClosed) {
    if (_rewardedAd == null) {
      loadRewardedAd();
      onAdClosed();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        onAdClosed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        onAdClosed();
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      onRewardEarned();
    });
    _rewardedAd = null;
  }

  /// --- BANNER AD ---
  BannerAd? getBannerAd() {
    return BannerAd(
      adUnitId: bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Banner failed: $error');
        },
      ),
    )..load();
  }

  /// --- REWARDED INTERSTITIAL ---
  void showRewardedInterstitialAd(Function onRewardEarned) {
    RewardedInterstitialAd.load(
      adUnitId: rewardedInterstitialId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) => ad.dispose(),
            onAdFailedToShowFullScreenContent: (ad, error) => ad.dispose(),
          );
          ad.show(onUserEarnedReward: (ad, reward) => onRewardEarned());
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded Interstitial failed: $error');
          onRewardEarned();
        },
      ),
    );
  }

  /// --- NATIVE AD ---
  NativeAd getNativeAd(VoidCallback onLoaded) {
    return NativeAd(
      adUnitId: nativeId,
      factoryId: 'adFactoryExample',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) => onLoaded(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Native Ad failed: $error');
        },
      ),
    )..load();
  }
}
