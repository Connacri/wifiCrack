import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../0-claude/main.dart' as claude;
import '../../Mistral2laude/entry_screen.dart';
import '../../commerce/screens/auth_screen.dart';
import '../../commerce/screens/commerce_screen.dart';
import '../../core/services/permission_service.dart';
import '../../data/sources/ad_service.dart';
import '../../data/sources/local_storage.dart';
import '../../data/sources/supabase_service.dart';
import '../../data/sources/user_data_service.dart';
import '../../data/sources/wifi_service.dart';
import '../../domain/entities/wifi_network.dart';
import '../../l10n/app_localizations.dart';
import '../providers/wifi_provider.dart';
import '../widgets/home_carousel.dart';
import '../widgets/language_selector_dialog.dart';
import 'admin_screen.dart';
import 'messenger_screen.dart';
import 'user_profile_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAdmin = false;
  String? _adminRole;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final wifi = context.read<WiFiProvider>();
      final storage = context.read<LocalStorageDataSource>();

      // 1. Vérification stricte des permissions
      bool allGranted = await PermissionService.areAllPermissionsGranted();
      bool hardwareOk = await PermissionService.isHardwareEnabled();

      if (!allGranted || !hardwareOk) {
        if (mounted) {
          PermissionService.showPermissionDialog(
            context,
            onRetry: () async {
              await PermissionService.requestAllPermissions();
              _initialize(); // Relancer la vérification
            },
          );
        }
        return;
      }

      // 2. Scan automatique si tout est OK
      wifi.startScan();

      if (mounted) {
        setState(() {
          _isAdmin = storage.isAdminLoggedIn();
          _adminRole = storage.getAdminRole();
        });
      }
    });
  }

  void _selectRole() {
    final storage = context.read<LocalStorageDataSource>();
    final roles = [
      'wholesaler_admin',
      'wholesaler_ops',
      'delivery_admin',
      'delivery_driver',
      'customer_service',
      'admin',
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Choisissez votre rôle Admin"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: roles
              .map(
                (role) => ListTile(
                  title: Text(role.replaceAll('_', ' ').toUpperCase()),
                  onTap: () async {
                    await storage.setAdminRole(role);
                    if (mounted) {
                      setState(() {
                        _adminRole = role;
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<void> _checkHardware(BuildContext context, WiFiService service) async {
    final status = await service.checkHardwareAndPermissions();
    if (status.containsValue(false)) {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text(
              "Configuration Requise",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            content: const Text(
              "Pour fonctionner, Sigma a besoin de : \n"
              "• WiFi Activé\n"
              "• GPS Activé\n"
              "• Permissions de Localisation\n\n"
              "Sans cela, vous ne serez pas visible sur la carte Sigma.",
            ),
            actions: [
              FilledButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await service.forceEnableHardware(context);
                  // On relance la vérification après retour des paramètres
                  Future.delayed(const Duration(seconds: 2), () {
                    if (context.mounted) _checkHardware(context, service);
                  });
                },
                child: const Text("Configurer Maintenant"),
              ),
            ],
          ),
        );
      }
    }
  }

  void _openAdmin(BuildContext context) {
    final storage = context.read<LocalStorageDataSource>();
    if (storage.isAdminLoggedIn()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AdminScreen()),
      );
      return;
    }

    final ctrl = TextEditingController();
    bool obscureText = true;
    bool keepLoggedIn = false;
    bool isValidating = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Accès Admin Sigma"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl,
                obscureText: obscureText,
                decoration: InputDecoration(
                  labelText: "Mot de passe Sigma",
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setDialogState(() => obscureText = !obscureText),
                  ),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text(
                  "Rester connecté",
                  style: TextStyle(fontSize: 14),
                ),
                value: keepLoggedIn,
                onChanged: (v) =>
                    setDialogState(() => keepLoggedIn = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              if (isValidating)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: LinearProgressIndicator(),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            FilledButton(
              onPressed: isValidating
                  ? null
                  : () async {
                      setDialogState(() => isValidating = true);

                      final dbPassword = await context
                          .read<SupabaseService>()
                          .getAdminPassword();

                      if (ctrl.text == dbPassword) {
                        if (keepLoggedIn) {
                          await storage.setAdminLoggedIn(true);
                        }
                        if (context.mounted) {
                          setState(() {
                            _isAdmin = true;
                          });
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminScreen(),
                            ),
                          );
                        }
                      } else {
                        setDialogState(() => isValidating = false);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Accès refusé.")),
                          );
                        }
                      }
                    },
              child: const Text("Entrer"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wifi = context.watch<WiFiProvider>();
    final supabase = context.read<SupabaseService>();
    final userData = context.read<UserDataService>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'Change language',
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const LanguageSelectorDialog(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Mon profil',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserProfileDetailScreen(
                  userId: userData.deviceId,
                  pseudo: userData.getPseudo(),
                  supabase: supabase,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () => _openAdmin(context),
          ),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MessengerScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.rocket_launch, color: Colors.deepOrange),
            tooltip: 'Claude Project',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const claude.InitializationScreen(),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => wifi.startScan(),
        child: Column(
          children: [
            _buildStatusHeader(wifi, userData, supabase),
            const SizedBox(height: 10),
            HomeBanner(supabase: supabase),
            if (_isAdmin) ...[
              if (_adminRole == null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _selectRole,
                      icon: const Icon(Icons.admin_panel_settings),
                      label: const Text("Choisir mon rôle Admin"),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ),
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Mode Admin: ${_adminRole!.replaceAll('_', ' ').toUpperCase()}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CommerceScreen(userId: userData.deviceId),
                            ),
                          ),
                          icon: const Icon(Icons.storefront),
                          label: Text("${l10n.commerce} (${_adminRole})"),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Mistral2laudeEntryScreen(
                            deviceIdOverride: userData.deviceId,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.forum),
                      label: const Text("Mistral2laude P2P"),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _selectRole,
                  child: const Text("Changer de rôle"),
                ),
              ],
            ],
            if (_isAdmin)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {
                      // Récupération de l'utilisateur actuel
                      User? user = FirebaseAuth.instance.currentUser;

                      // Si null (souvent au premier clic sur Windows), on attend brièvement l'initialisation
                      if (user == null) {
                        user = await FirebaseAuth.instance
                            .authStateChanges()
                            .first
                            .timeout(
                              const Duration(milliseconds: 500),
                              onTimeout: () => null,
                            );
                      }

                      if (!mounted) return;

                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommerceScreen(userId: user!.uid),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AuthScreen()),
                        );
                      }
                    },
                    icon: const Icon(Icons.storefront),
                    label: const Text("ACCÉDER AU COMMERCE (Google Auth)"),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AdSubmissionDialog(
                      userId: userData.deviceId,
                      supabase: supabase,
                    ),
                  ),
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text("Publier une annonce & Gagner des Coins"),
                ),
              ),
            ),
            Expanded(
              child: wifi.networks.isEmpty
                  ? _buildEmptyState(wifi)
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount:
                          wifi.networks.length + (wifi.networks.length ~/ 5),
                      itemBuilder: (context, index) {
                        // Insérer une pub native tous les 5 items
                        if (index > 0 && index % 6 == 0) {
                          return _NativeAdItem();
                        }

                        // Calculer l'index réel du réseau
                        final networkIndex = index - (index ~/ 6);
                        if (networkIndex >= wifi.networks.length)
                          return const SizedBox.shrink();

                        return _NetworkTile(
                          network: wifi.networks[networkIndex],
                        );
                      },
                    ),
            ),
            // AJOUT DE LA BANNIÈRE PUBLICITAIRE
            _buildAdBanner(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: wifi.scanStatus == ScanStatus.scanning
            ? null
            : () {
                // AFFICHER UN INTERSTITIEL AVANT LE SCAN
                context.read<AdService>().showInterstitialAd();
                wifi.startScan();
              },
        label: Text(
          wifi.scanStatus == ScanStatus.scanning
              ? "Scan en cours..."
              : "Scanner WiFi",
        ),
        icon: wifi.scanStatus == ScanStatus.scanning
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.search),
      ),
    );
  }

  Widget _buildAdBanner(BuildContext context) {
    final adService = context.read<AdService>();
    final banner = adService.getBannerAd();
    if (banner == null) return const SizedBox.shrink();

    return Container(
      alignment: Alignment.center,
      width: banner.size.width.toDouble(),
      height: banner.size.height.toDouble(),
      child: AdWidget(ad: banner),
    );
  }

  Widget _buildStatusHeader(
    WiFiProvider wifi,
    UserDataService userData,
    SupabaseService supabase,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.deepPurple.withValues(alpha: 0.1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<int>(
                future: supabase.getUserCoins(userData.deviceId),
                builder: (context, snapshot) {
                  final coins = snapshot.data ?? 0;
                  return Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.orange,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "$coins Coins",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Icon(Icons.verified, color: Colors.blue, size: 24),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem("${wifi.networks.length}", "Détectés", Colors.blue),
              _statItem(
                "${wifi.getStats()['successful']}",
                "Connectés",
                Colors.green,
              ),
              _statItem("${wifi.getStats()['failed']}", "Échecs", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String val, String label, Color color) {
    return Column(
      children: [
        Text(
          val,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildEmptyState(WiFiProvider wifi) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            wifi.errorMessage ?? "Aucun réseau détecté",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          if (wifi.scanStatus == ScanStatus.permissionDenied)
            TextButton(
              onPressed: wifi.fixPermissions,
              child: const Text("Donner les permissions"),
            ),
        ],
      ),
    );
  }
}

class _NativeAdItem extends StatefulWidget {
  @override
  State<_NativeAdItem> createState() => _NativeAdItemState();
}

class _NativeAdItemState extends State<_NativeAdItem> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_nativeAd == null) {
      _nativeAd = context.read<AdService>().getNativeAd(() {
        if (mounted) setState(() => _isLoaded = true);
      });
    }
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _nativeAd == null) return const SizedBox.shrink();

    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.2)),
      ),
      child: AdWidget(ad: _nativeAd!),
    );
  }
}

class _NetworkTile extends StatelessWidget {
  final WiFiNetwork network;
  const _NetworkTile({required this.network});

  @override
  Widget build(BuildContext context) {
    final wifi = context.read<WiFiProvider>();
    final isConnecting = wifi.connectingSSID == network.ssid;
    final isConnected = wifi.connectedSSID == network.ssid;

    return Card(
      child: ListTile(
        leading: Icon(
          Icons.wifi,
          color: network.signalStrength > -60
              ? Colors.green
              : (network.signalStrength > -80 ? Colors.orange : Colors.red),
        ),
        title: Text(
          network.ssid,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Clé Sigma: ${network.calculatedKey}",
              style: const TextStyle(
                color: Colors.deepPurple,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${network.signalStrength} dBm | ${network.frequency}",
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
        trailing: isConnecting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : IconButton(
                icon: Icon(
                  isConnected ? Icons.check_circle : Icons.link,
                  color: isConnected ? Colors.green : null,
                ),
                onPressed: () => wifi.connect(network),
              ),
      ),
    );
  }
}
