import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/sources/ad_service.dart';
import 'data/sources/local_storage.dart';
import 'data/sources/supabase_service.dart';
import 'data/sources/user_data_service.dart';
import 'data/sources/wifi_service.dart';
import 'data/sources/firebase_service.dart';
import 'data/sources/message_service.dart';
import 'data/sources/p2p_transfer_service.dart';
import 'presentation/providers/wifi_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'firebase_options.dart';

/// Gestionnaire obligatoire pour les notifications quand l'app est fermée (Android)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("📩 Message reçu en arrière-plan: ${message.messageId}");
}

void main() async {
  // 1. Initialisation vitale du framework
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. INITIALISATION BLOQUANTE DE FIREBASE
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint("❌ Erreur critique Firebase: $e");
  }

  // 3. INITIALISATION BLOQUANTE DE SUPABASE (Crucial pour l'enregistrement user)
  await SupabaseService.initialize();

  // 4. Stockage local
  final storage = LocalStorageDataSource();
  await storage.initialize(); 

  // 5. Initialisation AdMob
  await AdService.initialize();

  runApp(
    MultiProvider(
      providers: [
        // --- NIVEAU 1 : Services Indépendants ---
        Provider<WiFiService>(create: (_) => WiFiService()),
        Provider<LocalStorageDataSource>.value(value: storage),
        Provider<SupabaseService>(create: (_) => SupabaseService()),
        Provider<FirebaseService>(create: (_) => FirebaseService()),
        Provider<MessageService>(create: (_) => MessageService()),
        Provider<AdService>(create: (_) => AdService()),
        
        // --- NIVEAU 2 : UserDataService (Dépend du niveau 1) ---
        // Il doit être placé AVANT les services qui l'utilisent.
        ProxyProvider3<LocalStorageDataSource, SupabaseService, MessageService, UserDataService>(
          update: (_, storage, supabase, messenger, __) => 
              UserDataService(storage, supabase, messenger),
        ),

        // --- NIVEAU 3 : Services Dépendants de UserDataService ---
        ProxyProvider3<SupabaseService, UserDataService, MessageService, P2PTransferService>(
          update: (_, supabase, userData, messenger, previous) {
            if (previous != null && previous.myDeviceId == userData.deviceId) {
              messenger.bindP2PService(previous);
              return previous;
            }
            previous?.dispose();
            final service = P2PTransferService(supabase, userData.deviceId);
            messenger.bindP2PService(service);
            return service;
          },
          dispose: (_, service) => service.dispose(),
        ),

        // Provider de l'UI (Dépend du WiFiService et UserDataService)
        ChangeNotifierProxyProvider3<WiFiService, LocalStorageDataSource, UserDataService, WiFiProvider>(
          create: (context) => WiFiProvider(
            context.read<WiFiService>(),
            context.read<LocalStorageDataSource>(),
            context.read<UserDataService>(),
          ),
          update: (_, wifi, storage, userData, previous) => 
              previous ?? WiFiProvider(wifi, storage, userData),
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
      title: 'Sigma WiFi Crack',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    const primaryColor = Colors.deepPurple;
    const accentColor = Colors.orangeAccent;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
        primary: primaryColor,
        secondary: accentColor,
        surface: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      ),
      scaffoldBackgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F5F7),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF252525) : Colors.white,
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.black,
      ),
    );
  }
}
