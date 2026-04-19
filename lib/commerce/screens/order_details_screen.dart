import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../models/commerce_enums.dart';
import '../models/order.dart';
import '../models/shipment.dart';
import '../providers/commerce_provider.dart';
import '../services/qr_scan_sheet.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommerceProvider>();
    final l10n = AppLocalizations.of(context)!;

    final order = provider.orders.cast<Order?>().firstWhere(
      (o) => o?.id == orderId,
      orElse: () => null,
    );

    if (order == null) {
      final safeId = orderId.length >= 8 ? orderId.substring(0, 8) : orderId;
      return Scaffold(
        appBar: AppBar(title: Text(l10n.orderNumber(safeId))),
        body: Center(
          child:
              provider.ordersLoading
                  ? const CircularProgressIndicator()
                  : Text(l10n.orderNotFound),
        ),
      );
    }

    final theme = Theme.of(context);
    final statusColor = _getStatusColor(order.status);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.orderNumber(order.id.substring(0, 8).toUpperCase()),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              order.createdAt != null
                  ? DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt!)
                  : '',
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
        actions: [
          _StatusChip(status: order.status, color: statusColor),
          PopupMenuButton<UserRole>(
            tooltip: l10n.changeRoleTooltip,
            icon: const Icon(Icons.person_outline),
            onSelected: (role) => provider.setRole(role),
            itemBuilder: (context) => UserRole.values.map((role) {
              final isSelected = provider.currentRole == role;
              return PopupMenuItem(
                value: role,
                child: Row(
                  children: [
                    Icon(
                      _getRoleIcon(role),
                      size: 20,
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      role.toString().split('.').last.toUpperCase(),
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : null,
                        color: isSelected ? Colors.blue : null,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.loadOrders(reset: true),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. TIMELINE EXPERTE (DHL STYLE) ---
              _ExpertTimeline(order: order),
              const SizedBox(height: 16),

              // --- 2. ACTIONS PRIORITAIRES (DYNAMIQUE) ---
              _PriorityActionCard(order: order, provider: provider),
              const SizedBox(height: 16),

              // --- 3. INFOS LIVRAISON ---
              _InfoSection(
                title: l10n.deliveryInfo,
                icon: Icons.local_shipping_outlined,
                children: [
                  _InfoRow(label: l10n.customerLabel, value: order.userId), // Simulation
                  _InfoRow(label: l10n.phoneLabel, value: order.phone),
                  _InfoRow(label: l10n.addressLabel, value: order.address, isBold: true),
                  if (order.note != null) 
                    _InfoRow(label: l10n.noteLabel, value: order.note!),
                ],
              ),
              const SizedBox(height: 16),

              // --- 4. SUIVI DES COLIS (SHIPMENTS) ---
              if (order.shipments.isNotEmpty) ...[
                _ShipmentsSection(shipments: order.shipments),
                const SizedBox(height: 16),
              ],

              // --- 5. RÉSUMÉ DES ARTICLES ---
              _InfoSection(
                title: l10n.itemsLabel,
                icon: Icons.inventory_2_outlined,
                children: order.items.map((item) => _OrderItemRow(item: item)).toList(),
              ),
              const SizedBox(height: 16),

              // --- 6. PAIEMENT ---
              _InfoSection(
                title: l10n.paymentLabel,
                icon: Icons.payments_outlined,
                children: [
                  _InfoRow(
                    label: l10n.globalStatus,
                    value: PaymentStatus.tryParse(order.paymentStatus)?.label(l10n) ?? order.paymentStatus,
                    valueColor: _getPaymentStatusColor(order.paymentStatus),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.totalLabel, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(
                        '${order.total.toStringAsFixed(2)} DZD',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    final s = OrderStatus.fromJson(status);
    switch (s) {
      case OrderStatus.delivered: return Colors.green;
      case OrderStatus.shipped: return Colors.blue;
      case OrderStatus.readyToShip: return Colors.orange;
      case OrderStatus.cancelled: return Colors.red;
      case OrderStatus.picking:
      case OrderStatus.packed: return Colors.purple;
      default: return Colors.grey;
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status) {
      case 'paid': return Colors.green;
      case 'pending': return Colors.orange;
      case 'failed': return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.admin: return Icons.admin_panel_settings;
      case UserRole.support: return Icons.support_agent;
      case UserRole.warehouse: return Icons.inventory_2;
      case UserRole.carrier: return Icons.local_shipping;
      case UserRole.driver: return Icons.delivery_dining;
      case UserRole.wholesaler: return Icons.business;
      case UserRole.client: return Icons.person;
    }
  }
}

class _ExpertTimeline extends StatelessWidget {
  final Order order;
  const _ExpertTimeline({required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = OrderStatus.fromJson(order.status);
    
    final steps = [
      {'label': l10n.orderStatusConfirmed, 'icon': Icons.check_circle, 'active': true},
      {'label': l10n.orderStatusPrepared, 'icon': Icons.inventory_2, 'active': _isAtLeast(status, OrderStatus.packed)},
      {'label': l10n.orderStatusReady, 'icon': Icons.label_important, 'active': _isAtLeast(status, OrderStatus.readyToShip)},
      {'label': l10n.orderStatusShipped, 'icon': Icons.local_shipping, 'active': _isAtLeast(status, OrderStatus.shipped)},
      {'label': l10n.orderStatusDelivered, 'icon': Icons.home, 'active': _isAtLeast(status, OrderStatus.delivered)},
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (index) {
            final s = steps[index];
            final isActive = s['active'] as bool;
            final isLast = index == steps.length - 1;

            return Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 3,
                          color: index == 0 ? Colors.transparent : (isActive ? Colors.green : Colors.grey.shade200),
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isActive ? Colors.green : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: isActive ? Colors.green : Colors.grey.shade300, width: 2),
                        ),
                        child: Icon(
                          s['icon'] as IconData,
                          size: 16,
                          color: isActive ? Colors.white : Colors.grey.shade400,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 3,
                          color: isLast ? Colors.transparent : (_nextIsActive(steps, index) ? Colors.green : Colors.grey.shade200),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s['label'] as String,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? Colors.black : Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  bool _isAtLeast(OrderStatus current, OrderStatus target) {
    const seq = [
      OrderStatus.created,
      OrderStatus.orderConfirmed,
      OrderStatus.stockAllocated,
      OrderStatus.picking,
      OrderStatus.packed,
      OrderStatus.readyToShip,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];
    return seq.indexOf(current) >= seq.indexOf(target);
  }

  bool _nextIsActive(List<Map<String, dynamic>> steps, int index) {
    if (index >= steps.length - 1) return false;
    return steps[index + 1]['active'] as bool;
  }
}

class _PriorityActionCard extends StatelessWidget {
  final Order order;
  final CommerceProvider provider;
  const _PriorityActionCard({required this.order, required this.provider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final role = provider.currentRole;
    final status = OrderStatus.fromJson(order.status);
    final isUpdating = provider.isUpdatingOrder(order.id);

    Widget? action;

    // Logique Entrepot
    if (role == UserRole.warehouse || role == UserRole.admin) {
      if (status == OrderStatus.orderConfirmed || status == OrderStatus.stockAllocated) {
        action = _ActionButton(
          label: l10n.startPickingButton,
          icon: Icons.play_arrow,
          onPressed: () => provider.updateOrderStatus(orderId: order.id, status: OrderStatus.picking.toJson()),
          isLoading: isUpdating,
        );
      } else if (status == OrderStatus.picking) {
        action = _ActionButton(
          label: l10n.packingFinishedButton,
          icon: Icons.check,
          onPressed: () => provider.updateOrderStatus(orderId: order.id, status: OrderStatus.packed.toJson()),
          isLoading: isUpdating,
        );
      } else if (status == OrderStatus.packed) {
        action = _ActionButton(
          label: l10n.generateLabel,
          icon: Icons.label,
          color: Colors.blue,
          onPressed: () => _showShipmentDialog(context),
        );
      }
    }

    // Logique Transporteur (À RAMASSER)
    if (role == UserRole.carrier || role == UserRole.admin) {
      if (status == OrderStatus.readyToShip) {
        action = _ActionButton(
          label: l10n.scanForPickup,
          icon: Icons.qr_code_scanner,
          color: Colors.orange,
          onPressed: () => QrScanSheet.show(context, order.id),
          isLoading: isUpdating,
        );
      }
    }

    // Logique Livreur (À LIVRER)
    if (role == UserRole.driver || role == UserRole.admin) {
      if (status == OrderStatus.shipped) {
        action = _ActionButton(
          label: l10n.scanForDelivery,
          icon: Icons.verified,
          color: Colors.green,
          onPressed: () => QrScanSheet.show(context, order.id),
          isLoading: isUpdating,
        );
      }
    }

    if (action == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Action requise", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontSize: 12)),
          const SizedBox(height: 12),
          action,
        ],
      ),
    );
  }

  void _showShipmentDialog(BuildContext context) {
    final carrierCtrl = TextEditingController(text: 'DHL Express');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.newShipmentTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: carrierCtrl,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.carrier, border: const OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(context)!.cancel)),
          FilledButton(
            onPressed: () async {
              final carrier = carrierCtrl.text.trim();
              if (carrier.isEmpty) return;
              Navigator.pop(ctx);
              await provider.createShipment(
                orderId: order.id,
                carrierName: carrier,
                trackingNumber: 'AWB-${DateTime.now().millisecondsSinceEpoch}',
                items: order.items,
              );
            },
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InfoSection({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _InfoRow({required this.label, required this.value, this.valueColor, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey))),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: valueColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final OrderItem item;
  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.inventory_2, size: 16, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('Qté: ${item.quantity}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Text('${item.subtotal.toStringAsFixed(2)} DZD', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ShipmentsSection extends StatelessWidget {
  final List<Shipment> shipments;
  const _ShipmentsSection({required this.shipments});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return _InfoSection(
      title: l10n.trackMore, // Or generic tracking title
      icon: Icons.track_changes,
      children: shipments.map((s) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(s.carrierName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue)),
                _StatusBadge(status: s.status.toJson(), color: Colors.blue),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.qr_code, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(s.trackingNumber, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                const Spacer(),
                const Icon(Icons.copy, size: 14, color: Colors.blue),
              ],
            ),
          ],
        ),
      )).toList(),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  final Color color;
  const _StatusChip({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.2))),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;
  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final bool isLoading;

  const _ActionButton({required this.label, required this.icon, required this.onPressed, this.color, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        icon: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
