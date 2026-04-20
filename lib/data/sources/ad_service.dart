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

  // Singleton pattern via static instance
  static final AdService _instance = AdService.internal();
  static AdService get instance => _instance;
  AdService.internal();
  factory AdService() => _instance;

  AppOpenAd? _appOpenAd;
  bool _isShowingOpenAd = false;
  DateTime? _appOpenLoadTime;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;
  int _interstitialRetryAttempt = 0;

  RewardedAd? _rewardedAd;
  bool _isRewardedLoading = false;
  int _rewardedRetryAttempt = 0;

  bool _isInitialized = false;

  /// Initialise le SDK Google Ads avec gestion du consentement (UMP)
  static Future<void> initialize() async {
    if (!isSupportedPlatform) {
      debugPrint("ℹ️ AdMob non supporté sur cette plateforme.");
      return;
    }

    final params = ConsentRequestParameters();

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.canRequestAds()) {
          _initializeAds();
        }
        
        // Même si on peut déjà demander des pubs, on vérifie si un formulaire est dispo (RGPD)
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          _loadConsentForm();
        }
      },
      (FormError error) {
        debugPrint("⚠️ Consent Info Error: ${error.message}");
        _initializeAds(); // On tente quand même l'initialisation
      },
    );
  }

  static void _loadConsentForm() {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) {
        consentForm.show((FormError? formError) {
          if (formError != null) {
            debugPrint("⚠️ Consent Form Show Error: ${formError.message}");
          }
          // Si le statut a changé et qu'on peut maintenant diffuser, on init
          ConsentInformation.instance.canRequestAds().then((canRequest) {
            if (canRequest) _initializeAds();
          });
        });
      },
      (FormError formError) {
        debugPrint("⚠️ Consent Form Load Error: ${formError.message}");
        _initializeAds();
      },
    );
  }

  static void _initializeAds() async {
    if (_instance._isInitialized) return;

    try {
      // Configuration pour respecter la vie privée et les politiques Google
      MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
          testDeviceIds: [], // Liste vide pour la prod, à remplir en dev si besoin
        ),
      );

      await MobileAds.instance.initialize();
      _instance._isInitialized = true;
      _instance.startListeningToLifecycle();
      _instance.loadAppOpenAd();
      _instance.loadInterstitialAd();
      _instance.loadRewardedAd();
      debugPrint("✅ AdMob Initialisé avec succès (UMP inclus).");
    } catch (e) {
      debugPrint("❌ Erreur AdMob Init: $e");
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
    if (!_isInitialized) return;
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

  /// --- INTERSTITIAL AD ---
  void loadInterstitialAd() {
    if (!isSupportedPlatform || !_isInitialized) return;
    if (_isInterstitialLoading || _interstitialAd != null) return;
    _isInterstitialLoading = true;
    
    InterstitialAd.load(
      adUnitId: interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          _interstitialRetryAttempt = 0;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed: $error');
          _isInterstitialLoading = false;
          _interstitialAd = null;
          _interstitialRetryAttempt++;
          if (_interstitialRetryAttempt < 5) {
            Future.delayed(Duration(seconds: _interstitialRetryAttempt * 15), () => loadInterstitialAd());
          }
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (!isSupportedPlatform) return;
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
    if (!isSupportedPlatform || !_isInitialized) return;
    if (_isRewardedLoading || _rewardedAd != null) return;
    _isRewardedLoading = true;

    RewardedAd.load(
      adUnitId: rewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoading = false;
          _rewardedRetryAttempt = 0;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded failed: $error');
          _isRewardedLoading = false;
          _rewardedAd = null;
          _rewardedRetryAttempt++;
          if (_rewardedRetryAttempt < 5) {
            Future.delayed(Duration(seconds: _rewardedRetryAttempt * 15), () => loadRewardedAd());
          }
        },
      ),
    );
  }

  void showRewardedAd(Function onRewardEarned, Function onAdClosed) {
    if (!isSupportedPlatform) {
      onAdClosed();
      return;
    }
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
    if (!isSupportedPlatform || !_isInitialized) return null;
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
    if (!isSupportedPlatform || !_isInitialized) {
      onRewardEarned();
      return;
    }
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
  NativeAd? getNativeAd(VoidCallback onLoaded) {
    if (!isSupportedPlatform || !_isInitialized) return null;
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

  static bool get isSupportedPlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);
}
