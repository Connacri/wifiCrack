import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/sources/ad_service.dart';
import '../data/sources/local_storage.dart';
import '../data/sources/supabase_service.dart';
import '../data/sources/user_data_service.dart';
import '../data/sources/wifi_service.dart';
import '../data/sources/firebase_service.dart';
import '../data/sources/firebase_messenger_service.dart';
import '../presentation/providers/wifi_provider.dart';
import '../presentation/screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  // 1. Assurer que le moteur Flutter est prêt
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // 2. Initialisations critiques sécurisées
  try {
    // Initialisation Supabase (Silencieux en cas d'erreur réseau)
    await SupabaseService.initialize();

    // Initialisation AdMob (Doit avoir un ID valide dans le Manifest)
    await AdService.initialize();
  } catch (e) {
    debugPrint("⚠️ Erreur lors de l'initialisation système: $e");
  }

  // 3. Préparer les services
  final wifiService = WiFiService();
  final storage = LocalStorageDataSource();
  
  // Initialisation critique de SharedPreferences avant le lancement de l'UI
  await storage.initialize();

  final supabaseService = SupabaseService();
  final firebaseService = FirebaseService();
  final messengerService = FirebaseMessengerService();
  final userDataService = UserDataService(storage, supabaseService, firebaseService);
  final adService = AdService();

  runApp(
    MultiProvider(
      providers: [
        Provider<WiFiService>.value(value: wifiService),
        Provider<LocalStorageDataSource>.value(value: storage),
        Provider<UserDataService>.value(value: userDataService),
        Provider<SupabaseService>.value(value: supabaseService),
        Provider<FirebaseService>.value(value: firebaseService),
        Provider<FirebaseMessengerService>.value(value: messengerService),
        Provider<AdService>.value(value: adService),
        ChangeNotifierProvider<WiFiProvider>(
          create: (context) =>
              WiFiProvider(wifiService, storage, userDataService),
        ),
      ],
      child: const WiFiKeyScanner(),
    ),
  );
}

class WiFiKeyScanner extends StatelessWidget {
  const WiFiKeyScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiFi Key Tool',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: brightness,
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );
  }
}
