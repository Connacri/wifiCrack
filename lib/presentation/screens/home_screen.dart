import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/sources/local_storage.dart';
import '../../data/sources/wifi_service.dart';
import '../providers/wifi_provider.dart';
import '../../domain/entities/wifi_network.dart';
import '../../data/sources/supabase_service.dart';
import '../../data/sources/user_data_service.dart';
import '../widgets/home_carousel.dart';
import 'admin_screen.dart';
import 'messenger_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userData = context.read<UserDataService>();
      final wifiService = context.read<WiFiService>();
      
      // 1. Initialisation forcée (User Registration, Contacts Sync, Messaging)
      await userData.initializeDataSync();
      
      // 2. Vérification matérielle forcée
      if (mounted) {
        await _checkHardware(context, wifiService);
      }
      
      // 3. Init WiFi scan
      if (mounted) {
        context.read<WiFiProvider>().initialize();
      }
    });
  }

  Future<void> _checkHardware(BuildContext context, WiFiService service) async {
    final status = await service.checkHardwareAndPermissions();
    if (status.containsValue(false)) {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("Configuration Requise", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            content: const Text(
              "Pour fonctionner, Sigma a besoin de : \n"
              "• WiFi Activé\n"
              "• GPS Activé\n"
              "• Permissions de Localisation\n\n"
              "Sans cela, vous ne serez pas visible sur la carte Sigma."
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
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen()));
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
                    icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setDialogState(() => obscureText = !obscureText),
                  ),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text("Rester connecté", style: TextStyle(fontSize: 14)),
                value: keepLoggedIn,
                onChanged: (v) => setDialogState(() => keepLoggedIn = v ?? false),
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
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
            FilledButton(
              onPressed: isValidating ? null : () async {
                setDialogState(() => isValidating = true);
                
                final dbPassword = await context.read<SupabaseService>().getAdminPassword();
                
                if (ctrl.text == dbPassword) {
                  if (keepLoggedIn) {
                    await storage.setAdminLoggedIn(true);
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen()));
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sigma WiFi Crack', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () => _openAdmin(context),
          ),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MessengerScreen())),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AdSubmissionDialog(userId: userData.deviceId, supabase: supabase),
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
                      itemCount: wifi.networks.length,
                      itemBuilder: (context, index) => _NetworkTile(network: wifi.networks[index]),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: wifi.scanStatus == ScanStatus.scanning ? null : () => wifi.startScan(),
        label: Text(wifi.scanStatus == ScanStatus.scanning ? "Scan en cours..." : "Scanner WiFi"),
        icon: wifi.scanStatus == ScanStatus.scanning 
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.search),
      ),
    );
  }

  Widget _buildStatusHeader(WiFiProvider wifi, UserDataService userData, SupabaseService supabase) {
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
                      const Icon(Icons.monetization_on, color: Colors.orange, size: 24),
                      const SizedBox(width: 8),
                      Text("$coins Coins", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
              _statItem("${wifi.getStats()['successful']}", "Connectés", Colors.green),
              _statItem("${wifi.getStats()['failed']}", "Échecs", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String val, String label, Color color) {
    return Column(children: [
      Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
    ]);
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
            TextButton(onPressed: wifi.fixPermissions, child: const Text("Donner les permissions")),
        ],
      ),
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
          color: network.signalStrength > -60 ? Colors.green : (network.signalStrength > -80 ? Colors.orange : Colors.red),
        ),
        title: Text(network.ssid, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Clé Sigma: ${network.calculatedKey}", style: const TextStyle(color: Colors.deepPurple, fontSize: 12, fontWeight: FontWeight.bold)),
            Text("${network.signalStrength} dBm | ${network.frequency}", style: const TextStyle(fontSize: 10)),
          ],
        ),
        trailing: isConnecting
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
            : IconButton(
                icon: Icon(isConnected ? Icons.check_circle : Icons.link, color: isConnected ? Colors.green : null),
                onPressed: () => wifi.connect(network),
              ),
      ),
    );
  }
}
