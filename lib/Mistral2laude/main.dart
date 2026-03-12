import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../data/sources/supabase_service.dart';
import '../firebase_options.dart';
import '../objectbox.g.dart';
import 'app_provider.dart';
import 'contacts_screen.dart';
import 'notification_service.dart';
import 'objectbox_service.dart';
import 'user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('[Firebase] Init ignorée: $e');
  }

  await SupabaseService.initialize();

  final objectBox = ObjectBoxService();
  await objectBox.init();

  await NotificationService().init();

  final deviceId = await _getOrCreateDeviceId();
  final deviceModel = await _getDeviceModel();

  final user = await _initUser(
    objectBox: objectBox,
    deviceId: deviceId,
    model: deviceModel,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(objectBox, user),
      child: const MistralApp(),
    ),
  );
}

Future<String> _getOrCreateDeviceId() async {
  final prefs = await SharedPreferences.getInstance();
  final existing = prefs.getString('device_id');
  if (existing != null && existing.isNotEmpty) return existing;

  final newId = const Uuid().v4();
  await prefs.setString('device_id', newId);
  debugPrint('[DeviceID] Nouveau ID généré: $newId');
  return newId;
}

Future<String> _getDeviceModel() async {
  try {
    final info = DeviceInfoPlugin();
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = await info.androidInfo;
      return '${android.manufacturer} ${android.model}'.trim();
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final ios = await info.iosInfo;
      return 'Apple ${ios.utsname.machine}'.trim();
    }
    if (defaultTargetPlatform == TargetPlatform.windows) {
      final windows = await info.windowsInfo;
      return windows.computerName;
    }
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      final mac = await info.macOsInfo;
      return mac.model;
    }
    if (defaultTargetPlatform == TargetPlatform.linux) {
      final linux = await info.linuxInfo;
      return linux.prettyName ?? linux.name;
    }
    return "Mobile Device";
  } catch (_) {
    return 'Unknown';
  }
}

Future<M2CUser> _initUser({
  required ObjectBoxService objectBox,
  required String deviceId,
  required String model,
}) async {
  final existing = objectBox.userBox
      .query(M2CUser_.deviceId.equals(deviceId))
      .build()
      .findFirst();

  if (existing != null) {
    existing.lastSeen = DateTime.now();
    existing.model = model;
    objectBox.userBox.put(existing);
    return existing;
  }

  final newUser = M2CUser(
    deviceId: deviceId,
    pseudo: 'Utilisateur M2C',
    model: model,
    lastSeen: DateTime.now(),
    coins: 0,
  );
  objectBox.userBox.put(newUser);
  return newUser;
}

class MistralApp extends StatelessWidget {
  const MistralApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mistral2laude P2P',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const ContactsScreen(),
    );
  }
}
