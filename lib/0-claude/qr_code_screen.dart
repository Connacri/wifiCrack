import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'messaging_provider.dart';

class MyQRCodeScreen extends StatelessWidget {
  const MyQRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon QR Code'),
      ),
      body: Consumer<MessagingProvider>(
        builder: (context, provider, child) {
          final qrData = provider.generateMyQRCode();

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Partagez ce QR code',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vos amis peuvent le scanner pour vous ajouter',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 280,
                      backgroundColor: Colors.white,
                      errorCorrectionLevel: QrErrorCorrectLevel.H,
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () {
                      // TODO: Partager le QR code via Share plugin si nécessaire
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Faites une capture d\'écran pour partager'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Partager'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
