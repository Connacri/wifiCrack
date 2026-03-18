import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'add_friend_link.dart';
import 'user.dart';

class QRGeneratorScreen extends StatelessWidget {
  final M2CUser user;

  const QRGeneratorScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final link = AddFriendLink(
      deviceId: user.deviceId,
      pseudo: user.pseudo,
    ).toUrl();

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon QR Code'),
        actions: [
          IconButton(
            tooltip: 'Partager le lien',
            icon: const Icon(Icons.share),
            onPressed: () => SharePlus.instance.share(
              ShareParams(
                text: 'Ajoute-moi sur Mistral2laude P2P !\n$link',
                subject: 'Invitation Mistral2laude P2P',
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  (user.pseudo ?? 'U')[0].toUpperCase(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user.pseudo ?? 'Utilisateur',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: QrImageView(
                    data: link,
                    version: QrVersions.auto,
                    size: 220,
                    backgroundColor: Colors.white,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Faites scanner ce QR Code\npour vous ajouter en contact',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 32),

              OutlinedButton.icon(
                onPressed: () => SharePlus.instance.share(
                  ShareParams(
                    text: 'Ajoute-moi sur Mistral2laude P2P !\n$link',
                  ),
                ),
                icon: const Icon(Icons.link),
                label: const Text('Partager le lien'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
