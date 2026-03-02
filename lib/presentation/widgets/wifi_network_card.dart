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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = network.signalPercentage;

    return Card(
      elevation: isConnected ? 8 : 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isConnected
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _copyToClipboard(context, network.calculatedKey),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icone Signal + SSID + Status
              Row(
                children: [
                  _buildSignalIcon(percentage),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          network.ssid,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (network.frequency != null)
                          Text(
                            network.frequency!,
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  isConnected
                      ? const SizedBox.shrink()
                      : Expanded(
                          child: FilledButton.icon(
                            onPressed: (isConnecting || isConnected)
                                ? null
                                : () => onConnect?.call(network),
                            icon: isConnecting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.wifi_password),
                            label: Text(
                              isConnecting
                                  ? "Connexion..."
                                  : (isConnected ? "" : "Link"),
                            ),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                  if (isConnected)
                    Chip(
                      label: const Text('Connecté'),
                      backgroundColor: theme.colorScheme.primaryContainer,
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // // Key Section
              // Container(
              //   padding: const EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: theme.colorScheme.surfaceContainerHighest.withValues(
              //       alpha: 0.5,
              //     ),
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Row(
              //     children: [
              //       const Icon(Icons.key, size: 20, color: Colors.amber),
              //       const SizedBox(width: 12),
              //       Expanded(
              //         child: Text(
              //           network.calculatedKey,
              //           style: const TextStyle(
              //             fontFamily: 'monospace',
              //             fontWeight: FontWeight.w600,
              //             fontSize: 16,
              //           ),
              //         ),
              //       ),
              //       IconButton(
              //         icon: const Icon(Icons.copy, size: 20),
              //         tooltip: "Copier la clé",
              //         onPressed: () =>
              //             _copyToClipboard(context, network.calculatedKey),
              //       ),
              //     ],
              //   ),
              // ),

              // Footer: Last attempt status
              if (network.lastConnectionAttempt != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      network.lastConnectionSuccess == true
                          ? Icons.check_circle_outline
                          : Icons.error_outline,
                      size: 14,
                      color: network.lastConnectionSuccess == true
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      network.lastConnectionSuccess == true
                          ? "Dernière connexion réussie"
                          : "Dernier échec de connexion",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: network.lastConnectionSuccess == true
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignalIcon(int percentage) {
    IconData icon;
    Color color;

    if (percentage >= 75) {
      icon = Icons.signal_wifi_4_bar;
      color = Colors.green;
    } else if (percentage >= 50) {
      icon = Icons.network_wifi_3_bar;
      color = Colors.lightGreen;
    } else if (percentage >= 25) {
      icon = Icons.network_wifi_2_bar;
      color = Colors.amber;
    } else {
      icon = Icons.network_wifi_1_bar;
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Clé copiée : $text"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
