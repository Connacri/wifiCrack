import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../objectbox.g.dart';
import 'app_provider.dart';
import 'contacts_screen.dart';
import 'notification_service.dart';
import 'objectbox_service.dart';
import 'user.dart';

class Mistral2laudeEntryScreen extends StatefulWidget {
  final String? deviceIdOverride;

  const Mistral2laudeEntryScreen({super.key, this.deviceIdOverride});

  @override
  State<Mistral2laudeEntryScreen> createState() =>
      _Mistral2laudeEntryScreenState();
}

class _Mistral2laudeEntryScreenState extends State<Mistral2laudeEntryScreen> {
  late Future<_M2CInitData> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initialize();
  }

  Future<_M2CInitData> _initialize() async {
    final objectBox = ObjectBoxService();
    await objectBox.init();
    await NotificationService().init();

    final deviceId = await _getOrCreateDeviceId(widget.deviceIdOverride);
    final deviceModel = await _getDeviceModel();

    final user = await _initUser(
      objectBox: objectBox,
      deviceId: deviceId,
      model: deviceModel,
    );

    return _M2CInitData(objectBox, user);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_M2CInitData>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _M2CLoadingScreen();
        }
        if (snapshot.hasError || snapshot.data == null) {
          return _M2CErrorScreen(
            onRetry: () => setState(() => _initFuture = _initialize()),
          );
        }

        final data = snapshot.data!;
        return ChangeNotifierProvider(
          create: (_) => AppProvider(data.objectBox, data.user),
          child: const ContactsScreen(),
        );
      },
    );
  }
}

class _M2CInitData {
  final ObjectBoxService objectBox;
  final M2CUser user;

  const _M2CInitData(this.objectBox, this.user);
}

class _M2CLoadingScreen extends StatelessWidget {
  const _M2CLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _M2CErrorScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const _M2CErrorScreen({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mistral2laude')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
              const SizedBox(height: 12),
              const Text(
                "Echec d'initialisation",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> _getOrCreateDeviceId(String? override) async {
  final prefs = await SharedPreferences.getInstance();
  final normalized = override?.trim();
  if (normalized != null &&
      normalized.isNotEmpty &&
      normalized != 'Sigma_Unknown') {
    await prefs.setString('device_id', normalized);
    return normalized;
  }

  final existing = prefs.getString('device_id');
  if (existing != null && existing.isNotEmpty) return existing;

  final newId = const Uuid().v4();
  await prefs.setString('device_id', newId);
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
  } catch (_) {}
  return 'Mobile Device';
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
