import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'messaging_provider.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un ami'),
        actions: [
          // FIX: mobile_scanner ≥ 5 — MobileScannerController étend
          //      ValueNotifier<MobileScannerState>. torchState n'est plus un
          //      getter direct ; il faut écouter le controller lui-même.
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _scannerController,
            builder: (context, state, child) {
              final torchOn = state.torchState == TorchState.on;
              return IconButton(
                icon: Icon(torchOn ? Icons.flash_on : Icons.flash_off),
                onPressed: () => _scannerController.toggleTorch(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => _scannerController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),
          _buildOverlay(),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      // FIX: withOpacity() déprécié depuis Flutter 3.27 → withValues(alpha:)
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
      ),
      child: Column(
        children: [
          const Spacer(),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            // FIX: withValues(alpha:)
            color: Colors.black.withValues(alpha: 0.7),
            child: SafeArea(
              child: Text(
                'Scannez le QR code de votre ami',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final qrCode = barcodes.first.rawValue;
    if (qrCode == null || qrCode.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      final provider = context.read<MessagingProvider>();
      await provider.addFriendFromQR(qrCode);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ami ajouté avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isProcessing = false);
      }
    }
  }
}