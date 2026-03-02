import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/wifi_network.dart';

class WiFiNetworkCard extends StatelessWidget {
  final WiFiNetwork network;
  final bool isConnecting;
  final bool isConnected;
  final void Function(WiFiNetwork)? onConnect;

  const WiFiNetworkCard({
    super.key,
    required this.network,
    this.isConnecting = false,
    this.isConnected = false,
    this.onConnect,
  });

  String _getFrequencyLabel(String? freq) {
    if (freq == null) return "Unknown";
    final val = int.tryParse(freq.replaceAll(RegExp(r'[^0-9]'), ''));
    if (val == null) return freq;
    if (val >= 5000) return "5.0 GHz";
    if (val >= 2400) return "2.4 GHz";
    return freq;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = network.signalPercentage;
    final frequencyLabel = _getFrequencyLabel(network.frequency);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isConnected 
            ? theme.colorScheme.primaryContainer.withOpacity(0.3) 
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isConnected 
              ? theme.colorScheme.primary.withOpacity(0.5) 
              : theme.colorScheme.outlineVariant.withOpacity(0.5),
          width: isConnected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _copyToClipboard(context, network.calculatedKey),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Signal Icon & SSID Column
                _buildSignalIcon(percentage, isConnected, theme),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        network.ssid,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isConnected ? theme.colorScheme.primary : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.speed,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            frequencyLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (network.lastConnectionSuccess == true)
                            Icon(Icons.verified, size: 14, color: Colors.green[600]),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action Button
                _buildActionButton(context, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, ThemeData theme) {
    if (isConnecting) {
      return Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.all(12),
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        ),
      );
    }

    return Material(
      color: isConnected ? Colors.red.withOpacity(0.1) : theme.colorScheme.primary.withOpacity(0.1),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: () => onConnect?.call(network),
        icon: Icon(
          isConnected ? Icons.link_off : Icons.bolt,
          color: isConnected ? Colors.red : theme.colorScheme.primary,
        ),
        tooltip: isConnected ? "Déconnecter" : "Calculer & Connecter",
      ),
    );
  }

  Widget _buildSignalIcon(int percentage, bool isConnected, ThemeData theme) {
    IconData icon;
    Color color;

    if (percentage >= 75) {
      icon = Icons.wifi_lock;
      color = Colors.green;
    } else if (percentage >= 50) {
      icon = Icons.wifi_lock;
      color = Colors.lightGreen;
    } else if (percentage >= 25) {
      icon = Icons.wifi_lock;
      color = Colors.orange;
    } else {
      icon = Icons.wifi_lock;
      color = Colors.red;
    }

    if (isConnected) color = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          // Indication visuelle de la force du signal (petits points ou barres)
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: Text(
                "$percentage%",
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.key, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text("Clé copiée : $text"),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
