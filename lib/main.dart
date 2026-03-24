import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '0-claude/app_provider.dart';
import 'commerce/providers/commerce_provider.dart';
import 'commerce/services/commerce_service.dart';
// ... (reste des imports)
import 'core/services/notification_service.dart'; // AJOUT
import 'core/theme/app_theme.dart';
import 'data/sources/ad_service.dart';
import 'data/sources/firebase_service.dart';
import 'data/sources/local_storage.dart';
import 'data/sources/message_service.dart';
import 'data/sources/p2p_transfer_service.dart';
import 'data/sources/supabase_service.dart';
import 'data/sources/user_data_service.dart';
import 'data/sources/wifi_service.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'presentation/providers/locale_provider.dart';
import 'presentation/providers/wifi_provider.dart';
import 'presentation/screens/home_screen.dart';

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
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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

  // 6. Notifications FCM
  await NotificationService.initialize();
  await NotificationService.requestPermissions();

  // 7. Initialisation Google Sign In (v7+)
  try {
    await GoogleSignIn.instance.initialize();
  } catch (e) {
    debugPrint("⚠️ GoogleSignIn Init Warning: $e");
  }

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

        // --- Locale Provider ---
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => LocaleProvider(storage),
        ),

        // --- NIVEAU 2 : UserDataService (Dépend du niveau 1) ---
        // Il doit être placé AVANT les services qui l'utilisent.
        ProxyProvider3<
          LocalStorageDataSource,
          SupabaseService,
          MessageService,
          UserDataService
        >(
          update: (_, storage, supabase, messenger, __) =>
              UserDataService(storage, supabase, messenger),
        ),

        // --- NIVEAU 3 : Services Dépendants de UserDataService ---
        ProxyProvider3<
          SupabaseService,
          UserDataService,
          MessageService,
          P2PTransferService
        >(
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
        ChangeNotifierProxyProvider3<
          WiFiService,
          LocalStorageDataSource,
          UserDataService,
          WiFiProvider
        >(
          create: (context) => WiFiProvider(
            context.read<WiFiService>(),
            context.read<LocalStorageDataSource>(),
            context.read<UserDataService>(),
          ),
          update: (_, wifi, storage, userData, previous) =>
              previous ?? WiFiProvider(wifi, storage, userData),
        ),

        // --- Claude's Project AppProvider (Global State) ---
        ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),

        // --- Commerce (Global) ---
        ChangeNotifierProxyProvider2<SupabaseService, MessageService, CommerceProvider>(
          create: (context) => CommerceProvider(
            CommerceService(),
            context.read<SupabaseService>(),
          )..loadProducts(),
          update: (_, supabase, messenger, previous) =>
              previous ?? CommerceProvider(CommerceService(), supabase),
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
    // Watch correctly to rebuild on change
    final localeProvider = context.watch<LocaleProvider>();
    final currentLocale = localeProvider.locale;

    return MaterialApp(
      title: 'WiFi Fiber Hack',
      debugShowCheckedModeBanner: false,
      locale: currentLocale,

      // --- THEME ---
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // --- LOCALIZATION ---
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fr'), // French
        Locale('ar'), // Arabic
        Locale('es'), // Spanish
        Locale('zh'), // Chinese
        Locale('ja'), // Japanese
        Locale('ru'), // Russian
        Locale('pt'), // Portuguese
        Locale('de'), // German
        Locale('id'), // Indonesian
      ],

      home: const HomeScreen(),
    );
  }
}
