import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'add_friend_link.dart';
import 'contact.dart';
import 'contact_service.dart';

class QRScannerScreen extends StatefulWidget {
  final String myDeviceId;
  final ContactService contactService;

  const QRScannerScreen({
    super.key,
    required this.myDeviceId,
    required this.contactService,
  });

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  bool _processed = false;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_processed) return;

    final barcode = capture.barcodes.firstOrNull;
    final rawValue = barcode?.rawValue;

    if (rawValue == null || rawValue.isEmpty) {
      setState(() => _errorMessage = 'QR Code illisible, réessayez.');
      return;
    }

    if (!AddFriendLink.isValidUrl(rawValue)) {
      setState(
        () => _errorMessage = 'Ce QR Code ne provient pas de Mistral P2P.',
      );
      return;
    }

    AddFriendLink link;
    try {
      link = AddFriendLink.fromUrl(rawValue);
    } catch (e) {
      setState(() => _errorMessage = 'Lien invalide: $e');
      return;
    }

    if (link.deviceId == widget.myDeviceId) {
      setState(
        () => _errorMessage = '🚫 Vous ne pouvez pas vous ajouter vous-même !',
      );
      return;
    }

    if (widget.contactService.isContact(link.deviceId)) {
      setState(() => _errorMessage = 'ℹ️ Cet ami est déjà dans vos contacts.');
      return;
    }

    _processed = true;
    final added = widget.contactService.addContact(
      M2CContact(
        deviceId: link.deviceId,
        pseudo: link.pseudo,
        addedAt: DateTime.now(),
      ),
    );

    if (added && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner un QR Code'),
        actions: [
          // FIX finale pour mobile_scanner v5+ : le controller est lui-même un ValueNotifier<MobileScannerState>
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _controller,
            builder: (context, state, child) {
              final torchOn = state.torchState == TorchState.on;
              return IconButton(
                tooltip: 'Lampe torche',
                icon: Icon(
                  torchOn ? Icons.flash_on : Icons.flash_off,
                ),
                onPressed: () => _controller.toggleTorch(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _errorMessage != null ? 56 : 0,
            color: Theme.of(context).colorScheme.errorContainer,
            child: _errorMessage != null
                ? Center(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  )
                : null,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                MobileScanner(controller: _controller, onDetect: _onDetect),
                CustomPaint(
                  size: const Size(250, 250),
                  painter: _ScannerOverlayPainter(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Positioned(
                  bottom: 24,
                  child: Text(
                    'Placez le QR Code dans le cadre',
                    style: TextStyle(
                      color: Colors.white,
                      shadows: [const Shadow(blurRadius: 4, color: Colors.black54)],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                    _processed = false;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final Color color;
  const _ScannerOverlayPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLen = 30.0;

    final corners = [
      [Offset(0, cornerLen), Offset.zero, Offset(cornerLen, 0)],
      [
        Offset(size.width - cornerLen, 0),
        Offset(size.width, 0),
        Offset(size.width, cornerLen),
      ],
      [
        Offset(size.width, size.height - cornerLen),
        Offset(size.width, size.height),
        Offset(size.width - cornerLen, size.height),
      ],
      [
        Offset(cornerLen, size.height),
        Offset(0, size.height),
        Offset(0, size.height - cornerLen),
      ],
    ];

    for (final corner in corners) {
      final path = Path()
        ..moveTo(corner[0].dx, corner[0].dy)
        ..lineTo(corner[1].dx, corner[1].dy)
        ..lineTo(corner[2].dx, corner[2].dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
