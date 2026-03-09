import 'package:comwificrack/data/sources/ad_service.dart';
import 'package:comwificrack/data/sources/local_storage.dart';
import 'package:comwificrack/data/sources/supabase_service.dart';
import 'package:comwificrack/data/sources/user_data_service.dart';
import 'package:comwificrack/data/sources/wifi_service.dart';
import 'package:comwificrack/data/sources/firebase_service.dart';
import 'package:comwificrack/data/sources/message_service.dart';
import 'package:comwificrack/data/sources/p2p_transfer_service.dart';
import 'package:comwificrack/presentation/providers/wifi_provider.dart';
import 'package:comwificrack/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

// Mocks légers pour les tests
class MockAdService extends AdService {
  MockAdService() : super.internal();
  @override
  BannerAd? getBannerAd() => null;
}

class MockFirebaseService implements FirebaseService {
  Future<void> syncContacts(List<Contact> contacts) async {}
  Future<void> logUserActivity(Position? location, int contactsCount, String deviceId) async {}
  Future<void> updateLocation(Position location, String deviceId) async {}
}

void main() {
  testWidgets('Test de démarrage et de présence du titre Sigma WiFi Crack', (
    WidgetTester tester,
  ) async {
    // 1. Initialiser les services
    final wifiService = WiFiService();
    final storage = LocalStorageDataSource();
    final supabaseService = SupabaseService();
    final firebaseService = MockFirebaseService();
    final messengerService = MessageService();
    final userDataService = UserDataService(storage, supabaseService, messengerService);
    final mockAdService = MockAdService();
    final p2pService = P2PTransferService(supabaseService, "test_device");

    // 2. Build l'UI avec tous les Providers requis
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<WiFiService>.value(value: wifiService),
          Provider<LocalStorageDataSource>.value(value: storage),
          Provider<UserDataService>.value(value: userDataService),
          Provider<SupabaseService>.value(value: supabaseService),
          Provider<FirebaseService>.value(value: firebaseService),
          Provider<MessageService>.value(value: messengerService),
          Provider<AdService>.value(value: mockAdService),
          Provider<P2PTransferService>.value(value: p2pService),
          ChangeNotifierProvider<WiFiProvider>(
            create: (context) => WiFiProvider(wifiService, storage, userDataService),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    // 3. Vérifications
    expect(find.text('Sigma WiFi Crack'), findsWidgets);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
