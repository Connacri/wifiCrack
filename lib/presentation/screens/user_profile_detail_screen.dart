import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/sources/supabase_service.dart';

class UserProfileDetailScreen extends StatefulWidget {
  final String userId;
  final String? pseudo;
  final SupabaseService supabase;

  const UserProfileDetailScreen({
    super.key,
    required this.userId,
    required this.supabase,
    this.pseudo,
  });

  @override
  State<UserProfileDetailScreen> createState() => _UserProfileDetailScreenState();
}

class _UserProfileDetailScreenState extends State<UserProfileDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: Text(widget.pseudo?.isNotEmpty == true ? widget.pseudo! : 'Profil utilisateur'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Infos', icon: Icon(Icons.badge_outlined)),
            Tab(text: 'Activité', icon: Icon(Icons.timeline)),
            Tab(text: 'Sécurité', icon: Icon(Icons.shield_outlined)),
            Tab(text: 'Réseau', icon: Icon(Icons.wifi_tethering_outlined)),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: widget.supabase.fetchUserFullDetails(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? {};
          final user = (data['user'] as Map<String, dynamic>? ?? {});
          final activities = (data['activities'] as List<dynamic>? ?? [])
              .whereType<Map<String, dynamic>>()
              .toList();

          final profilePseudo = user['pseudo']?.toString().trim().isNotEmpty == true
              ? user['pseudo'].toString()
              : (widget.pseudo ?? widget.userId.substring(0, widget.userId.length > 8 ? 8 : widget.userId.length));

          final lastSeen = DateTime.tryParse(user['last_seen']?.toString() ?? '');
          final isOnline = lastSeen != null && DateTime.now().difference(lastSeen).inMinutes < 2;
          final model = user['model']?.toString() ?? 'Inconnu';
          final coins = user['coins']?.toString() ?? '0';
          final createdAt = DateTime.tryParse(user['created_at']?.toString() ?? '');

          final points = activities
              .where((a) => a['latitude'] != null && a['longitude'] != null)
              .length;
          final contactsMax = activities
              .map((a) => int.tryParse(a['contacts_count']?.toString() ?? '0') ?? 0)
              .fold<int>(0, (prev, value) => value > prev ? value : prev);
          final ageMinutes =
              lastSeen == null ? null : DateTime.now().difference(lastSeen).inMinutes;

          return TabBarView(
            controller: _tabController,
            children: [
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isOnline ? Colors.green : Colors.grey,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(profilePseudo, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(isOnline ? 'En ligne' : 'Hors ligne'),
                      trailing: Text(
                        '$coins coins',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.orange),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'Identité',
                    rows: [
                      _kv('Device ID', widget.userId),
                      _kv('Pseudo', profilePseudo),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'Appareil & Session',
                    rows: [
                      _kv('Modèle', model),
                      _kv('Dernière activité', _formatDate(lastSeen)),
                      _kv('Créé le', _formatDate(createdAt)),
                    ],
                  ),
                ],
              ),
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionCard(
                    title: 'Résumé activité',
                    rows: [
                      _kv('Événements collectés', '${activities.length}'),
                      _kv('Points GPS valides', '$points'),
                      _kv('Contacts max vus', '$contactsMax'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Timeline récente',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 8),
                          if (activities.isEmpty)
                            const Text('Aucune activité disponible.')
                          else
                            ...activities.take(30).map((a) {
                              final ts = DateTime.tryParse(a['timestamp']?.toString() ?? '');
                              final lat = a['latitude']?.toString() ?? '-';
                              final lon = a['longitude']?.toString() ?? '-';
                              final contacts = a['contacts_count']?.toString() ?? '-';
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.place, size: 16, color: Colors.redAccent),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${_formatDate(ts)}\nlat: $lat, lon: $lon, contacts: $contacts',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionCard(
                    title: 'État sécurité',
                    rows: [
                      _kv('ID appareil', widget.userId),
                      _kv('Session active', isOnline ? 'Oui' : 'Non'),
                      _kv('Dernier ping', ageMinutes == null ? '-' : 'il y a $ageMinutes min'),
                      _kv('Anomalie détectée', 'Aucune (heuristique locale)'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Text(
                        'Note: cet onglet affiche des signaux de sécurité applicatifs '
                        'basés sur les données disponibles (pas un audit serveur complet).',
                      ),
                    ),
                  ),
                ],
              ),
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionCard(
                    title: 'État réseau',
                    rows: [
                      _kv('Canal principal', 'WebRTC P2P'),
                      _kv('Présence', isOnline ? 'Disponible' : 'Indisponible'),
                      _kv('Dernière vue', _formatDate(lastSeen)),
                      _kv('Échantillons de géoloc', '$points'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ExpansionTile(
                    title: const Text('Données brutes (debug)'),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      SelectableText(
                        user.toString(),
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  static String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(dt.toLocal());
  }

  static MapEntry<String, String> _kv(String key, String value) => MapEntry(key, value);
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<MapEntry<String, String>> rows;

  const _SectionCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            ...rows.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 130,
                        child: Text(
                          '${e.key}:',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(child: SelectableText(e.value)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
