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
      wifi.startScan(AppLocalizations.of(context)!);

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

    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.chooseAdminRole),
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
    final l10n = AppLocalizations.of(context)!;
    if (status.containsValue(false)) {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(
              l10n.configRequiredTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            content: Text(
              "${l10n.configRequiredInfo}\n"
              "• ${l10n.scanWifi} (WiFi)\n"
              "• ${l10n.gps}\n"
              "• ${l10n.permissions}\n\n"
              "${l10n.configVisibleNote}",
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
                child: Text(l10n.configureNow),
              ),
            ],
          ),
        );
      }
    }
  }

  void _logoutAdmin() async {
    final storage = context.read<LocalStorageDataSource>();
    final l10n = AppLocalizations.of(context)!;
    await storage.setAdminLoggedIn(false);
    await storage.setAdminRole(null);
    if (mounted) {
      setState(() {
        _isAdmin = false;
        _adminRole = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.logoutSnackBar)));
    }
  }

  void _openAdmin(BuildContext context) async {
    final storage = context.read<LocalStorageDataSource>();
    final l10n = AppLocalizations.of(context)!;
    if (storage.isAdminLoggedIn()) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AdminScreen()),
      );
      if (mounted) {
        setState(() {
          _isAdmin = storage.isAdminLoggedIn();
          _adminRole = storage.getAdminRole();
        });
      }
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
          title: Text(l10n.adminDashboardTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl,
                obscureText: obscureText,
                decoration: InputDecoration(
                  labelText: l10n.password,
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
                title: Text(
                  l10n.activeSession,
                  style: const TextStyle(fontSize: 14),
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
              child: Text(l10n.cancel),
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
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminScreen(),
                            ),
                          );
                          if (mounted) {
                            setState(() {
                              _isAdmin = storage.isAdminLoggedIn();
                              _adminRole = storage.getAdminRole();
                            });
                          }
                        }
                      } else {
                        setDialogState(() => isValidating = false);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.accessDenied)),
                          );
                        }
                      }
                    },
              child: Text(l10n.login),
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
            icon: Icon(wifi.showHistory ? Icons.history : Icons.radar),
            tooltip: wifi.showHistory ? l10n.detected : l10n.scan,
            onPressed: () => wifi.setShowHistory(!wifi.showHistory),
          ),
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: l10n.language,
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const LanguageSelectorDialog(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: l10n.profileTooltip,
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
          _isAdmin
              ? PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.orange,
                  ),
                  tooltip: l10n.adminTooltip,
                  onSelected: (value) {
                    if (value == 'open') {
                      _openAdmin(context);
                    } else if (value == 'logout') {
                      _logoutAdmin();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'open',
                      child: ListTile(
                        leading: const Icon(Icons.dashboard),
                        title: Text(l10n.admin),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: Text(
                          l10n.logout,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                )
              : IconButton(
                  icon: const Icon(Icons.admin_panel_settings),
                  tooltip: l10n.adminTooltip,
                  onPressed: () => _openAdmin(context),
                ),
          IconButton(
            icon: const Icon(Icons.chat),
            tooltip: l10n.chatTooltip,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MessengerScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.rocket_launch, color: Colors.deepOrange),
            tooltip: l10n.p2pTooltip,
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
        onRefresh: () => wifi.startScan(l10n),
        child: Column(
          children: [
            if (_isAdmin) _buildStatusHeader(wifi, userData, supabase, l10n),
            const SizedBox(height: 10),
            if (_isAdmin) HomeBanner(supabase: supabase),
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
                      label: Text(l10n.admin),
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
                        "${l10n.admin}: ${_adminRole!.replaceAll('_', ' ').toUpperCase()}",
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
                      label: Text(l10n.p2pChat),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _selectRole,
                  child: Text(l10n.edit),
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
                    label: Text(l10n.commerce.toUpperCase()),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
            if (_isAdmin)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
                    label: Text(l10n.publishAd),
                  ),
                ),
              ),
            Expanded(
              child: wifi.networks.isEmpty
                  ? _buildEmptyState(wifi, l10n)
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
                wifi.startScan(l10n);
              },
        label: Text(
          wifi.scanStatus == ScanStatus.scanning
              ? l10n.scanning
              : l10n.scanWifi,
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
    AppLocalizations l10n,
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
                        "$coins ${l10n.coins}",
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
              _statItem("${wifi.networks.length}", l10n.detected, Colors.blue),
              _statItem(
                "${wifi.getStats()['successful']}",
                l10n.connected,
                Colors.green,
              ),
              _statItem("${wifi.getStats()['failed']}", l10n.failed, Colors.red),
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

  Widget _buildEmptyState(WiFiProvider wifi, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            wifi.errorMessage ?? l10n.noNetworks,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          if (wifi.scanStatus == ScanStatus.permissionDenied)
            TextButton(
              onPressed: wifi.fixPermissions,
              child: Text(l10n.fixPermissions),
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
              AppLocalizations.of(context)!.sigmaKey(network.calculatedKey),
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
                onPressed: () => wifi.connect(network, AppLocalizations.of(context)!),
              ),
      ),
    );
  }
}
