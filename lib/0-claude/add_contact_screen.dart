import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../l10n/app_localizations.dart';
import 'app_provider.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  bool _showScanner = false;
  String? _myQRCode;

  @override
  void initState() {
    super.initState();
    _loadMyQRCode();
  }

  Future<void> _loadMyQRCode() async {
    final provider = context.read<AppProvider>();
    final qrCode = await provider.qrCode.generateMyQRCodeString();
    setState(() => _myQRCode = qrCode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addContactTitle)),
      body: _showScanner ? _buildScanner() : _buildMyQRCode(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _showScanner = !_showScanner),
        icon: Icon(_showScanner ? Icons.qr_code : Icons.qr_code_scanner),
        label: Text(_showScanner ? l10n.myQrCode : l10n.scan),
      ),
    );
  }

  Widget _buildMyQRCode() {
    if (_myQRCode == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final provider = context.read<AppProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.yourQrCodeTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.yourQrCodeSubtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // QR Code
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    // FIX: withOpacity() déprécié → withValues(alpha:)
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: QrImageView(
                data: _myQRCode!,
                version: QrVersions.auto,
                size: 250,
                errorCorrectionLevel: QrErrorCorrectLevel.H,
              ),
            ),

            const SizedBox(height: 32),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.person,
                      label: l10n.pseudo,
                      value: provider.pseudo ?? l10n.notAvailable,
                    ),
                    const Divider(height: 24),
                    _InfoRow(
                      icon: Icons.fingerprint,
                      label: l10n.deviceIdLabel,
                      value:
                          provider.deviceId?.substring(0, 8) ??
                          l10n.notAvailable,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanner() {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      children: [
        MobileScanner(
          onDetect: (capture) {
            final barcodes = capture.barcodes;
            if (barcodes.isEmpty) return;

            final barcode = barcodes.first;
            if (barcode.rawValue == null) return;

            _handleScannedQRCode(barcode.rawValue!);
          },
        ),

        // Overlay avec cadre
        CustomPaint(painter: _ScannerOverlayPainter(), child: Container()),

        // Instructions
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // FIX: withValues(alpha:)
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              l10n.placeQrInFrame,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleScannedQRCode(String qrCode) async {
    final provider = context.read<AppProvider>();
    final l10n = AppLocalizations.of(context)!;

    try {
      await provider.addContact(qrCode);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.contactAddedSuccess),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorWithDetails(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      // FIX: withValues(alpha:) partout
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final centerSquareSize = size.width * 0.7;
    final left = (size.width - centerSquareSize) / 2;
    final top = (size.height - centerSquareSize) / 2;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(Rect.fromLTWH(left, top, centerSquareSize, centerSquareSize))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    final cornerPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    const cornerLength = 30.0;

    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left, top + cornerLength),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(left + centerSquareSize, top),
      Offset(left + centerSquareSize - cornerLength, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + centerSquareSize, top),
      Offset(left + centerSquareSize, top + cornerLength),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(left, top + centerSquareSize),
      Offset(left + cornerLength, top + centerSquareSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + centerSquareSize),
      Offset(left, top + centerSquareSize - cornerLength),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(left + centerSquareSize, top + centerSquareSize),
      Offset(left + centerSquareSize - cornerLength, top + centerSquareSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + centerSquareSize, top + centerSquareSize),
      Offset(left + centerSquareSize, top + centerSquareSize - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
