// lib/commerce/ui/qr_scan_sheet.dart

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../models/commerce_enums.dart';
import '../models/shipment.dart';
import '../providers/commerce_provider.dart';
import 'qr_step_confirm_sheet.dart';

/// Sheet de scan QR pour un livreur/transporteur.
/// Après détection du QR (= shipmentId), propose les transitions autorisées.
class QrScanSheet extends StatefulWidget {
  final String orderId;

  const QrScanSheet({super.key, required this.orderId});

  static Future<void> show(BuildContext context, String orderId) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => QrScanSheet(orderId: orderId),
      );

  @override
  State<QrScanSheet> createState() => _QrScanSheetState();
}

class _QrScanSheetState extends State<QrScanSheet> {
  final MobileScannerController _scannerCtrl = MobileScannerController();
  bool _detected = false;

  @override
  void dispose() {
    _scannerCtrl.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_detected) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || raw.isEmpty) return;

    // Convention QR : "shipment:<shipmentId>"
    if (!raw.startsWith('shipment:')) return;
    final shipmentId = raw.replaceFirst('shipment:', '').trim();
    if (shipmentId.isEmpty) return;

    _detected = true;
    await _scannerCtrl.stop();

    if (!mounted) return;
    final provider = context.read<CommerceProvider>();

    // Chercher l'expédition correspondante
    final order = provider.orders.cast<dynamic>().firstWhere(
      (o) => o.id == widget.orderId,
      orElse: () => null,
    );
    if (order == null) return;

    final Shipment? shipment = (order.shipments as List<dynamic>)
        .cast<Shipment?>()
        .firstWhere((s) => s?.id == shipmentId, orElse: () => null);

    if (shipment == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expédition introuvable pour ce colis')),
        );
      }
      return;
    }

    final currentStatus = ShipmentStatus.fromJson(shipment.status as String?);
    final allowed = provider.allowedShipmentTransitions(currentStatus);

    if (!mounted) return;

    if (allowed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune transition disponible pour votre rôle'),
        ),
      );
      Navigator.pop(context);
      return;
    }

    // Affiche le sélecteur d'étape
    Navigator.pop(context); // ferme le scanner
    await QrStepConfirmSheet.show(
      context,
      shipmentId: shipmentId,
      orderId: widget.orderId,
      currentStatus: currentStatus,
      allowedTransitions: allowed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Text(
              'Scanner le code du colis',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: MobileScanner(
                controller: _scannerCtrl,
                onDetect: _onDetect,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Pointez le QR code figurant sur l\'étiquette',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
