import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../data/sources/ad_service.dart';
import '../../data/sources/user_data_service.dart';
import '../../domain/entities/wifi_network.dart';
import '../../presentation/providers/wifi_provider.dart';
import '../../presentation/screens/admin_screen.dart';
import '../../presentation/screens/messenger_screen.dart';
import '../../presentation/screens/user_chat_screen.dart';
import '../../presentation/widgets/wifi_network_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WiFiProvider>().initialize().then((_) {
        if (!mounted) return;
        context.read<WiFiProvider>().startScan();
      });

      // Initialiser le cycle de vie des pubs
      AdService().startListeningToLifecycle();
      // Forcer le chargement et l'affichage immédiat au démarrage à froid
      AdService().loadAppOpenAd(showImmediately: true);

      // Charger la bannière
      if (!mounted) return;
      setState(() {
        _bannerAd = context.read<AdService>().getBannerAd();
      });
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    AdService().stopListeningToLifecycle();
    super.dispose();
  }

  void _onConnect(WiFiNetwork network) {
    // Maximisation : Afficher une pub récompensée avant de tenter la connexion/crack
    AdService().showRewardedAd(
      () {
        debugPrint("Récompense pub obtenue");
      },
      () {
        if (!mounted) return;
        context.read<WiFiProvider>().connect(network);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WiFiProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: _buildAppBar(context, provider),
          drawer: _buildDrawer(context),
          body: _buildBody(context, provider),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: provider.scanStatus == ScanStatus.scanning
                ? null
                : () {
                    provider.startScan();
                    // Afficher un interstitiel aléatoirement après un scan pour générer du profit
                    context.read<AdService>().showInterstitialAd();
                  },
            icon: provider.scanStatus == ScanStatus.scanning
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.wifi_find),
            label: Text(
              provider.scanStatus == ScanStatus.scanning
                  ? 'Scan en cours...'
                  : 'Scanner',
            ),
          ),
          bottomNavigationBar: _bannerAd != null
              ? SizedBox(
                  height: _bannerAd!.size.height.toDouble(),
                  width: _bannerAd!.size.width.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, WiFiProvider provider) {
    return AppBar(
      title: const Text('WiFi Key Scanner'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.bar_chart),
          tooltip: "Statistiques",
          onPressed: () => _showStats(context, provider),
        ),
        IconButton(
          icon: const Icon(Icons.cleaning_services),
          tooltip: "Nettoyer l'historique",
          onPressed: () => _cleanHistory(context, provider),
        ),
        IconButton(
          icon: const Icon(Icons.admin_panel_settings_outlined),
          tooltip: "Admin",
          onPressed: () => _showAdminLogin(context),
        ),
      ],
    );
  }

  void _showAdminLogin(BuildContext context) {
    AdService().showRewardedInterstitialAd(() {
      final TextEditingController passwordController = TextEditingController();
      bool obscurePassword = true;

      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Accès Restreint'),
            content: TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: 'Mot de passe Sigma',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => obscurePassword = !obscurePassword),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              FilledButton(
                onPressed: () {
                  if (passwordController.text == 'Sigma31311!') {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Accès refusé. Mot de passe incorrect.'),
                      ),
                    );
                  }
                },
                child: const Text('Entrer'),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.wifi_password, color: Colors.white, size: 48),
                SizedBox(height: 12),
                Text(
                  'WiFi Crack Pro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Version Clean Arch',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('À propos'),
            onTap: () => _showAboutDialog(context),
          ),
          ListTile(
            leading: const Icon(
              Icons.account_circle_outlined,
              color: Colors.green,
            ),
            title: const Text('Mon Profil Sigma'),
            onTap: () {
              Navigator.pop(context);
              _showProfileDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bolt, color: Colors.orange),
            title: const Text('Sigma Messenger'),
            onTap: () {
              Navigator.pop(context);
              AdService().showRewardedInterstitialAd(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MessengerScreen(),
                  ),
                );
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat_outlined, color: Colors.blue),
            title: const Text('Support Sigma'),
            onTap: () {
              Navigator.pop(context);
              AdService().showRewardedInterstitialAd(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserChatScreen(),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WiFiProvider provider) {
    // Cas de chargement initial ou scan vide
    if (provider.scanStatus == ScanStatus.scanning &&
        provider.networks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Recherche de réseaux..."),
          ],
        ),
      );
    }

    // Cas d'erreur avec liste vide
    if (provider.errorMessage != null && provider.networks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => provider.startScan(),
                icon: const Icon(Icons.refresh),
                label: const Text("Réessayer"),
              ),
            ],
          ),
        ),
      );
    }

    // Liste vide sans erreur (ex: pas de FH_ trouvés)
    if (provider.networks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            const Text("Aucun réseau compatible (FH_...) trouvé."),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => provider.startScan(),
              icon: const Icon(Icons.refresh),
              label: const Text("Lancer un nouveau scan"),
            ),
          ],
        ),
      );
    }

    // Liste des réseaux
    return RefreshIndicator(
      onRefresh: () => provider.startScan(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80, top: 8),
        itemCount: provider.networks.length,
        itemBuilder: (context, index) {
          final network = provider.networks[index];
          // Vérifie si CE réseau est en train de se connecter
          final isConnectingThis =
              provider.connectionStatus == ConnectionStatus.connecting &&
              provider.connectingSSID == network.ssid;

          // Vérifie si CE réseau est déjà connecté
          final isConnectedThis = provider.connectedSSID == network.ssid;

          return WiFiNetworkCard(
            network: network,
            isConnecting: isConnectingThis,
            isConnected: isConnectedThis,
            onConnect: _onConnect,
          );
        },
      ),
    );
  }

  void _showStats(BuildContext context, WiFiProvider provider) {
    final stats = provider.getStats();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Statistiques'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _statRow('Total de réseaux', stats['total']!),
            const SizedBox(height: 8),
            _statRow(
              'Connexions réussies',
              stats['successful']!,
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            _statRow('Échecs', stats['failed']!, color: Colors.red),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, int value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          '$value',
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  void _cleanHistory(BuildContext context, WiFiProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nettoyage"),
        content: const Text(
          "Voulez-vous supprimer les réseaux non vus depuis plus de 30 jours ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          FilledButton(
            onPressed: () {
              provider.cleanHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Historique nettoyé.")),
              );
            },
            child: const Text("Nettoyer"),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'WiFi Key Scanner',
      applicationVersion: '2.0.0 (Clean Arch)',
      applicationIcon: const Icon(Icons.wifi_password, size: 48),
      children: [
        const Text("Application de décodage et connexion WiFi automatique."),
        const SizedBox(height: 16),
        const Text(
          "Architecture: Clean Architecture + Provider + SharedPreferences.",
        ),
      ],
    );
  }

  void _showProfileDialog(BuildContext context) {
    final userDataService = context.read<UserDataService>();
    final TextEditingController pseudoController = TextEditingController(
      text: userDataService.getPseudo(),
    );
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Mon Profil Sigma'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Device ID: ${userDataService.deviceId}",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pseudoController,
                decoration: const InputDecoration(
                  labelText: 'Votre Pseudo',
                  border: OutlineInputBorder(),
                  hintText: 'Entrez un pseudo unique',
                ),
              ),
              if (isSaving)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: LinearProgressIndicator(),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      if (pseudoController.text.trim().isEmpty) return;

                      setState(() => isSaving = true);
                      final success = await userDataService.updatePseudo(
                        pseudoController.text.trim(),
                      );
                      setState(() => isSaving = false);

                      if (success) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Pseudo mis à jour !"),
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Ce pseudo est déjà pris."),
                            ),
                          );
                        }
                      }
                    },
              child: const Text('Sauvegarder'),
            ),
          ],
        ),
      ),
    );
  }
}
