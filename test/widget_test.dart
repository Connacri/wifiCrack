import 'package:comwificrack/data/sources/ad_service.dart';
import 'package:comwificrack/data/sources/local_storage.dart';
import 'package:comwificrack/data/sources/supabase_service.dart';
import 'package:comwificrack/data/sources/user_data_service.dart';
import 'package:comwificrack/data/sources/wifi_service.dart';
import 'package:comwificrack/data/sources/firebase_service.dart';
import 'package:comwificrack/presentation/providers/wifi_provider.dart';
import 'package:comwificrack/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

// Mock pour AdService pour éviter les appels natifs dans les tests
class MockAdService extends AdService {
  MockAdService() : super.internal();

  @override
  BannerAd? getBannerAd() => null;
  @override
  void showInterstitialAd() {}
  @override
  void loadAppOpenAd({bool showImmediately = false}) {}
  @override
  void loadInterstitialAd() {}
  @override
  void loadRewardedAd() {}
  @override
  void showAppOpenAdIfAvailable() {}
  @override
  void showRewardedAd(Function onRewardEarned, Function onAdClosed) { onAdClosed(); }
  @override
  void startListeningToLifecycle() {}
  @override
  void stopListeningToLifecycle() {}
  @override
  void showRewardedInterstitialAd(Function onRewardEarned) { onRewardEarned(); }
  @override
  NativeAd getNativeAd(VoidCallback onLoaded) { throw UnimplementedError(); }
}

class MockFirebaseService implements FirebaseService {
  @override
  Future<void> syncContacts(List<Contact> contacts) async {}
  @override
  Future<void> logUserActivity(Position? location, int contactsCount, String deviceId) async {}
  @override
  Future<void> updateLocation(Position location, String deviceId) async {}
}

void main() {
  testWidgets('Test de démarrage et de présence du titre WiFi Key Scanner', (
    WidgetTester tester,
  ) async {
    final wifiService = WiFiService();
    final storage = LocalStorageDataSource();
    final supabaseService = SupabaseService();
    final firebaseService = MockFirebaseService();
    final userDataService = UserDataService(storage, supabaseService, firebaseService);
    final mockAdService = MockAdService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<WiFiService>.value(value: wifiService),
          Provider<LocalStorageDataSource>.value(value: storage),
          Provider<UserDataService>.value(value: userDataService),
          Provider<SupabaseService>.value(value: supabaseService),
          Provider<FirebaseService>.value(value: firebaseService),
          Provider<AdService>.value(value: mockAdService),
          ChangeNotifierProvider<WiFiProvider>(
            create: (context) =>
                WiFiProvider(wifiService, storage, userDataService),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pump();
    expect(find.text('WiFi Key Scanner'), findsWidgets);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
