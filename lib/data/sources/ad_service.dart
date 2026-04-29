import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService with WidgetsBindingObserver {
  static const String bannerId = 'ca-app-pub-2282149611905342/2104770491';
  static const String interstitialId = 'ca-app-pub-2282149611905342/8821058363';
  static const String rewardedInterstitialId = 'ca-app-pub-2282149611905342/7507976697';
  static const String nativeId = 'ca-app-pub-2282149611905342/1638700781';
  static const String appOpenId = 'ca-app-pub-2282149611905342/5445608497';
  static const String rewardedId = 'ca-app-pub-2282149611905342/3805699127';

  static final AdService _instance = AdService.internal();
  static AdService get instance => _instance;
  static Completer<void>? _initializationCompleter;

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

  static Future<void> initialize() async {
    if (!isSupportedPlatform) {
      debugPrint('AdMob unsupported on this platform.');
      return;
    }

    if (_instance._isInitialized) return;
    if (_initializationCompleter != null) {
      return _initializationCompleter!.future;
    }

    _initializationCompleter = Completer<void>();
    final params = ConsentRequestParameters();

    try {
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        _handleConsentInfoUpdated,
        (FormError error) {
          debugPrint('Consent info error: ${error.message}');
          _finishInitialization();
        },
      );
    } catch (e) {
      debugPrint('UMP initialization error: $e');
      _completeInitialization();
    }

    return _initializationCompleter!.future;
  }

  static void _handleConsentInfoUpdated() {
    _loadAndShowConsentForm();
  }

  static Future<void> _loadAndShowConsentForm() async {
    try {
      await ConsentForm.loadAndShowConsentFormIfRequired((FormError? formError) {
        if (formError != null) {
          debugPrint('Consent form error: ${formError.message}');
        }
        _finishInitialization();
      });
    } catch (e) {
      debugPrint('Consent form flow error: $e');
      _finishInitialization();
    }
  }

  static Future<void> _finishInitialization() async {
    try {
      if (await ConsentInformation.instance.canRequestAds()) {
        await _initializeAds();
      } else {
        debugPrint('Ads cannot be requested yet.');
      }
    } catch (e) {
      debugPrint('AdMob finalization error: $e');
    } finally {
      _completeInitialization();
    }
  }

  static void _completeInitialization() {
    final completer = _initializationCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
  }

  static Future<void> _initializeAds() async {
    if (_instance._isInitialized) return;

    try {
      MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
          testDeviceIds: const [],
        ),
      );

      await MobileAds.instance.initialize();
      _instance._isInitialized = true;
      _instance.startListeningToLifecycle();
      _instance.loadAppOpenAd();
      _instance.loadInterstitialAd();
      _instance.loadRewardedAd();
      debugPrint('AdMob initialized successfully.');
    } catch (e) {
      debugPrint('AdMob init error: $e');
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

  void loadAppOpenAd({bool showImmediately = false}) {
    if (!_isInitialized) return;
    AppOpenAd.load(
      adUnitId: appOpenId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenLoadTime = DateTime.now();
          debugPrint('AppOpenAd loaded.');
          if (showImmediately) {
            showAppOpenAdIfAvailable();
          }
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpen failed to load: $error');
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
            Future.delayed(
              Duration(seconds: _interstitialRetryAttempt * 15),
              () => loadInterstitialAd(),
            );
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
            Future.delayed(
              Duration(seconds: _rewardedRetryAttempt * 15),
              () => loadRewardedAd(),
            );
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

  NativeAd? getNativeAd(VoidCallback onLoaded) {
    if (!Platform.isAndroid || !_isInitialized) return null;
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
