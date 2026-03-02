import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/sources/supabase_service.dart';
import '../../data/sources/firebase_messenger_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SupabaseService _supabase = SupabaseService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sigma Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Stats'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.map), text: 'Carte'),
            Tab(icon: Icon(Icons.location_on), text: 'Activité'),
            Tab(icon: Icon(Icons.contacts), text: 'Contacts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _DashboardSummary(supabase: _supabase),
          _UserList(supabase: _supabase),
          _AdminMapView(supabase: _supabase),
          _DataList(fetcher: _supabase.fetchUserActivity, type: 'activity'),
          _DataList(fetcher: _supabase.fetchContacts, type: 'contacts', showSearch: true),
        ],
      ),
    );
  }
}

class _UserList extends StatefulWidget {
  final SupabaseService supabase;
  const _UserList({required this.supabase});

  @override
  State<_UserList> createState() => _UserListState();
}

class _UserListState extends State<_UserList> {
  final FirebaseMessengerService _firebaseMessenger = FirebaseMessengerService();
  bool _onlyOnline = false;

  bool _isOnline(String timestamp) {
    try {
      final lastSeen = DateTime.parse(timestamp);
      return DateTime.now().difference(lastSeen).inMinutes < 5;
    } catch (e) { return false; }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Tous'), icon: Icon(Icons.group)),
              ButtonSegment(value: true, label: Text('En ligne'), icon: Icon(Icons.bolt, color: Colors.green)),
            ],
            selected: {_onlyOnline},
            onSelectionChanged: (val) => setState(() => _onlyOnline = val.first),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: widget.supabase.fetchUniqueUsers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              
              var users = snapshot.data!;
              if (_onlyOnline) {
                users = users.where((u) => _isOnline(u['timestamp'])).toList();
              }

              if (users.isEmpty) return const Center(child: Text("Aucun utilisateur trouvé."));

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final online = _isOnline(user['timestamp']);
                  final userId = "User_${user['id'].toString().substring(0, 8)}";
                  
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: online ? Colors.green : Colors.grey,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(userId),
                      subtitle: Text("Dernier signe: ${user['timestamp']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.chat_bubble, color: Colors.orange),
                        onPressed: () => _openChat(context, userId),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _openChat(BuildContext context, String userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: _SigmaMessenger(messenger: _firebaseMessenger, userId: userId),
      ),
    );
  }
}

class _SigmaMessenger extends StatefulWidget {
  final FirebaseMessengerService messenger;
  final String userId;
  const _SigmaMessenger({required this.messenger, required this.userId});

  @override
  State<_SigmaMessenger> createState() => _SigmaMessengerState();
}

class _SigmaMessengerState extends State<_SigmaMessenger> {
  final TextEditingController _controller = TextEditingController();

  void _send() {
    if (_controller.text.trim().isEmpty) return;
    widget.messenger.sendMessage(widget.userId, _controller.text.trim());
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            children: [
              const Icon(Icons.bolt, color: Colors.white),
              const SizedBox(width: 10),
              Text("Messenger: ${widget.userId}", 
                   style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: widget.messenger.getMessagesStream(widget.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Aucun message."));
              }
              final docs = snapshot.data!.docs;
              return ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final msg = docs[index].data() as Map<String, dynamic>;
                  final bool isAdmin = msg['is_admin'] ?? false;
                  return Align(
                    alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isAdmin ? Colors.orange[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(msg['content'] ?? ""),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 8, 
              left: 15, 
              right: 15,
              top: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller, 
                    decoration: InputDecoration(
                      hintText: "Message...",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _send, 
                  icon: const Icon(Icons.send), 
                  style: IconButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AdminMapView extends StatelessWidget {
  final SupabaseService supabase;
  const _AdminMapView({required this.supabase});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: supabase.fetchAllUserActivities(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final activities = snapshot.data!;
        final markers = activities
            .where((a) => a['latitude'] != null && a['longitude'] != null)
            .map((a) {
          return Marker(
            point: LatLng(a['latitude'] as double, a['longitude'] as double),
            width: 40, height: 40,
            child: const Icon(Icons.location_on, color: Colors.red, size: 40),
          );
        }).toList();

        return FlutterMap(
          options: MapOptions(
            initialCenter: markers.isNotEmpty ? markers.first.point : const LatLng(36.75, 3.05), 
            initialZoom: 6
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'dz.sigma.wificrack.pro',
            ),
            MarkerLayer(markers: markers),
          ],
        );
      },
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
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        final stats = snapshot.data ?? {'wifi': 0, 'activity': 0, 'contacts': 0, 'messages': 0};

        return GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          children: [
            _statCard("WiFi", stats['wifi']!, Icons.wifi, Colors.blue),
            _statCard("Traces", stats['activity']!, Icons.history, Colors.orange),
            _statCard("Contacts", stats['contacts']!, Icons.contact_phone, Colors.green),
            _statCard("Messages", stats['messages']!, Icons.chat, Colors.purple),
          ],
        );
      },
    );
  }

  Widget _statCard(String label, int val, IconData icon, Color color) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 40),
          Text(val.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label),
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
  void initState() {
    super.initState();
    _loadMore(reset: true);
  }

  Future<void> _loadMore({bool reset = false}) async {
    if (_loading) return;
    if (reset) { _items.clear(); _offset = 0; }
    setState(() => _loading = true);
    final data = await widget.fetcher(_offset, query: _query);
    setState(() {
      _items.addAll(data);
      _offset += data.length;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showSearch)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(hintText: "Recherche Nom ou Numéro...", prefixIcon: Icon(Icons.search)),
              onChanged: (val) {
                _query = val;
                _loadMore(reset: true);
              },
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return ListTile(
                title: Text(widget.type == 'contacts' ? item['name'] : (item['ssid'] ?? item['id'])),
                subtitle: Text(widget.type == 'contacts' ? item['phone'] : item['timestamp']),
              );
            },
          ),
        ),
      ],
    );
  }
}
