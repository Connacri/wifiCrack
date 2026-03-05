import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WiFiProvider>().initialize();
    });
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
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen())),
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
