// lib/commerce/ui/qr_step_confirm_sheet.dart
//
// Affiché après détection du QR.
// Liste les transitions autorisées + bouton simuler si pas de scanner physique.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/commerce_enums.dart';
import '../providers/commerce_provider.dart';

class QrStepConfirmSheet extends StatefulWidget {
  final String shipmentId;
  final String orderId;
  final ShipmentStatus currentStatus;
  final Set<ShipmentStatus> allowedTransitions;

  const QrStepConfirmSheet({
    super.key,
    required this.shipmentId,
    required this.orderId,
    required this.currentStatus,
    required this.allowedTransitions,
  });

  static Future<void> show(
    BuildContext context, {
    required String shipmentId,
    required String orderId,
    required ShipmentStatus currentStatus,
    required Set<ShipmentStatus> allowedTransitions,
  }) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => QrStepConfirmSheet(
      shipmentId: shipmentId,
      orderId: orderId,
      currentStatus: currentStatus,
      allowedTransitions: allowedTransitions,
    ),
  );

  @override
  State<QrStepConfirmSheet> createState() => _QrStepConfirmSheetState();
}

class _QrStepConfirmSheetState extends State<QrStepConfirmSheet> {
  ShipmentStatus? _selected;
  bool _loading = false;

  Future<void> _confirm() async {
    final target = _selected;
    if (target == null) return;

    setState(() => _loading = true);
    final provider = context.read<CommerceProvider>();
    final l10n = /* AppLocalizations.of(context)! */ null;

    final ok = await provider.updateShipmentStatus(
      shipmentId: widget.shipmentId,
      status: target,
      orderId: widget.orderId,
      fromStatus: widget.currentStatus,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Étape mise à jour : ${target.name}'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.ordersError ?? 'Erreur lors de la mise à jour',
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final transitions = widget.allowedTransitions.toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
            child: Text('Valider l\'étape', style: theme.textTheme.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Text(
              'Statut actuel : ${widget.currentStatus.name}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Divider(height: 1),
          ...transitions.map((status) {
            final isSelected = _selected == status;
            return ListTile(
              leading: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
              ),
              title: Text(status.name),
              onTap: () => setState(() => _selected = status),
              selected: isSelected,
            );
          }),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: _selected == null || _loading ? null : _confirm,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Confirmer'),
            ),
          ),
        ],
      ),
    );
  }
}
