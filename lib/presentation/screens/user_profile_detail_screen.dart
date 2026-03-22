import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pseudo?.isNotEmpty == true ? widget.pseudo! : l10n.userProfileTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.tabInfo, icon: const Icon(Icons.badge_outlined)),
            Tab(text: l10n.tabActivity, icon: const Icon(Icons.timeline)),
            Tab(text: l10n.tabSecurity, icon: const Icon(Icons.shield_outlined)),
            Tab(text: l10n.tabNetwork, icon: const Icon(Icons.wifi_tethering_outlined)),
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
          final model = user['model']?.toString() ?? l10n.unknown;
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
                      subtitle: Text(isOnline ? l10n.online : l10n.offline),
                      trailing: Text(
                        '$coins ${l10n.coins}',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.orange),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: l10n.identity,
                    rows: [
                      _kv('Device ID', widget.userId),
                      _kv(l10n.pseudo, profilePseudo),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: l10n.deviceAndSession,
                    rows: [
                      _kv(l10n.model, model),
                      _kv(l10n.lastActivity, _formatDate(lastSeen)),
                      _kv(l10n.createdAt, _formatDate(createdAt)),
                    ],
                  ),
                ],
              ),
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionCard(
                    title: l10n.activitySummary,
                    rows: [
                      _kv(l10n.eventsCollected, '${activities.length}'),
                      _kv(l10n.validGpsPoints, '$points'),
                      _kv(l10n.maxContactsSeen, '$contactsMax'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.tabActivity,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 8),
                          if (activities.isEmpty)
                            Text(l10n.noActivityAvailable)
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
                    title: l10n.securityStatus,
                    rows: [
                      _kv('ID appareil', widget.userId),
                      _kv(l10n.activeSession, isOnline ? l10n.yes : l10n.no),
                      _kv(l10n.lastPing, ageMinutes == null ? '-' : l10n.agoMin(ageMinutes)),
                      _kv(l10n.anomalyDetected, l10n.none),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(l10n.securityNote),
                    ),
                  ),
                ],
              ),
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionCard(
                    title: l10n.networkStatus,
                    rows: [
                      _kv(l10n.mainChannel, 'WebRTC P2P'),
                      _kv(l10n.presence, isOnline ? l10n.available : l10n.unavailable),
                      _kv(l10n.lastActivity, _formatDate(lastSeen)),
                      _kv(l10n.geolocSamples, '$points'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ExpansionTile(
                    title: Text(l10n.rawDebugData),
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
