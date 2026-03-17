import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../models/commerce_enums.dart';
import '../models/shipment.dart';
import '../providers/commerce_provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommerceProvider>();
    final order = provider.orders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => throw Exception('Order not found'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Commande #${order.id.substring(0, 8)}'),
        actions: [
          _RoleSelector(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OrderStatusCard(order: order),
            const SizedBox(height: 16),
            _OrderItemsCard(order: order),
            const SizedBox(height: 16),
            _ShipmentsCard(order: order),
            const SizedBox(height: 16),
            _ActionPanel(order: order),
          ],
        ),
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommerceProvider>();
    return PopupMenuButton<UserRole>(
      initialValue: provider.currentRole,
      onSelected: provider.setRole,
      icon: const Icon(Icons.badge_outlined),
      tooltip: 'Changer de rôle (Simulation)',
      itemBuilder: (context) => UserRole.values
          .map((r) => PopupMenuItem(
                value: r,
                child: Text(r.label),
              ))
          .toList(),
    );
  }
}

class _OrderStatusCard extends StatelessWidget {
  final Order order;

  const _OrderStatusCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = order.createdAt != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt!)
        : 'Inconnue';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Statut global', style: theme.textTheme.labelLarge),
                _StatusBadge(status: order.status),
              ],
            ),
            const Divider(height: 24),
            _InfoRow(label: 'Date', value: dateStr),
            _InfoRow(label: 'Client', value: order.userId),
            _InfoRow(label: 'Téléphone', value: order.phone),
            _InfoRow(label: 'Adresse', value: order.address),
            _InfoRow(
              label: 'Paiement',
              value: order.paymentStatus.name.toUpperCase(),
              valueColor: order.paymentStatus == PaymentStatus.captured
                  ? Colors.green
                  : Colors.orange,
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: theme.textTheme.titleMedium),
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
      ),
    );
  }
}

class _OrderItemsCard extends StatelessWidget {
  final Order order;

  const _OrderItemsCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Produits', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = order.items[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.name),
                  subtitle: Text('Prix: ${item.price.toStringAsFixed(2)} DZD'),
                  trailing: Text('x${item.quantity}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ShipmentsCard extends StatelessWidget {
  final Order order;

  const _ShipmentsCard({required this.order});

  @override
  Widget build(BuildContext context) {
    if (order.shipments.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Aucune expédition pour le moment.'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text('Expéditions (${order.shipments.length})',
              style: Theme.of(context).textTheme.titleMedium),
        ),
        ...order.shipments.map((s) => _ShipmentItem(shipment: s)),
      ],
    );
  }
}

class _ShipmentItem extends StatelessWidget {
  final Shipment shipment;

  const _ShipmentItem({required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text('Colis: ${shipment.trackingNumber}'),
        subtitle: Text('Transporteur: ${shipment.carrierName}'),
        trailing: _ShipmentStatusBadge(status: shipment.status),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(label: 'ID', value: shipment.id),
                if (shipment.shippedAt != null)
                  _InfoRow(
                    label: 'Expédié le',
                    value: DateFormat('dd/MM/yyyy HH:mm').format(shipment.shippedAt!),
                  ),
                const SizedBox(height: 8),
                Text('Articles dans ce colis:',
                    style: Theme.of(context).textTheme.labelLarge),
                ...shipment.items.map((i) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('• ${i.name} (x${i.quantity})'),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPanel extends StatelessWidget {
  final Order order;

  const _ActionPanel({required this.order});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommerceProvider>();
    final role = provider.currentRole;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (role == UserRole.wholesaler) ..._buildWholesalerActions(context, provider),
        if (role == UserRole.warehouse) ..._buildWarehouseActions(context, provider),
        if (role == UserRole.carrier) ..._buildCarrierActions(context, provider),
        if (role == UserRole.driver) ..._buildDriverActions(context, provider),
        if (role == UserRole.client) ..._buildClientActions(context, provider),
      ],
    );
  }

  List<Widget> _buildWholesalerActions(BuildContext context, CommerceProvider provider) {
    return [
      if (order.status == OrderStatus.created)
        ElevatedButton.icon(
          onPressed: () => provider.updateOrderStatus(
            orderId: order.id,
            status: OrderStatus.orderConfirmed,
          ),
          icon: const Icon(Icons.check_circle),
          label: const Text('Confirmer la commande'),
        ),
      if (order.status == OrderStatus.orderConfirmed)
        ElevatedButton.icon(
          onPressed: () => provider.updateOrderStatus(
            orderId: order.id,
            status: OrderStatus.stockAllocated,
          ),
          icon: const Icon(Icons.inventory),
          label: const Text('Allouer le stock'),
        ),
    ];
  }

  List<Widget> _buildWarehouseActions(BuildContext context, CommerceProvider provider) {
    return [
      if (order.status == OrderStatus.stockAllocated)
        ElevatedButton.icon(
          onPressed: () => provider.updateOrderStatus(
            orderId: order.id,
            status: OrderStatus.picking,
          ),
          icon: const Icon(Icons.shopping_basket),
          label: const Text('Démarrer le Picking'),
        ),
      if (order.status == OrderStatus.picking)
        ElevatedButton.icon(
          onPressed: () => provider.updateOrderStatus(
            orderId: order.id,
            status: OrderStatus.packed,
          ),
          icon: const Icon(Icons.inventory_2),
          label: const Text('Emballage terminé (Packed)'),
        ),
      if (order.status == OrderStatus.packed)
        ElevatedButton.icon(
          onPressed: () => _showCreateShipmentDialog(context, provider),
          icon: const Icon(Icons.local_shipping),
          label: const Text('Générer étiquette & Expédier'),
        ),
    ];
  }

  List<Widget> _buildCarrierActions(BuildContext context, CommerceProvider provider) {
    // For each shipment, carrier can update status
    return order.shipments.map((s) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: OutlinedButton.icon(
          onPressed: () => provider.updateShipmentStatus(
            shipmentId: s.id,
            status: ShipmentStatus.inTransit,
          ),
          icon: const Icon(Icons.route),
          label: Text('Mettre en Transit (${s.trackingNumber})'),
        ),
      );
    }).toList();
  }

  List<Widget> _buildDriverActions(BuildContext context, CommerceProvider provider) {
    return order.shipments.where((s) => s.status != ShipmentStatus.delivered).map((s) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: FilledButton.icon(
          onPressed: () => provider.updateShipmentStatus(
            shipmentId: s.id,
            status: ShipmentStatus.delivered,
          ),
          icon: const Icon(Icons.done_all),
          label: Text('Confirmer Livraison (${s.trackingNumber})'),
        ),
      );
    }).toList();
  }

  List<Widget> _buildClientActions(BuildContext context, CommerceProvider provider) {
    return [
      if (order.status == OrderStatus.delivered)
        TextButton.icon(
          onPressed: () {
            // Logic for return request
          },
          icon: const Icon(Icons.keyboard_return),
          label: const Text('Demander un retour'),
        ),
    ];
  }

  void _showCreateShipmentDialog(BuildContext context, CommerceProvider provider) {
    final trackingCtrl = TextEditingController(text: 'TRK-${DateTime.now().millisecondsSinceEpoch}');
    final carrierCtrl = TextEditingController(text: 'DHL');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle Expédition'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: carrierCtrl, decoration: const InputDecoration(labelText: 'Transporteur')),
            TextField(controller: trackingCtrl, decoration: const InputDecoration(labelText: 'N° de suivi')),
            const SizedBox(height: 12),
            const Text('Tous les articles seront inclus dans ce colis pour cet exemple.'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          FilledButton(
            onPressed: () {
              provider.createShipment(
                orderId: order.id,
                trackingNumber: trackingCtrl.text,
                carrierName: carrierCtrl.text,
                items: order.items,
              );
              Navigator.pop(context);
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case OrderStatus.created: color = Colors.blue; break;
      case OrderStatus.paid: color = Colors.green; break;
      case OrderStatus.delivered: color = Colors.purple; break;
      case OrderStatus.shipped: color = Colors.orange; break;
      case OrderStatus.cancelled: color = Colors.red; break;
      default: color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

class _ShipmentStatusBadge extends StatelessWidget {
  final ShipmentStatus status;

  const _ShipmentStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.label,
        style: const TextStyle(color: Colors.blue, fontSize: 11),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: valueColor,
            fontWeight: valueColor != null ? FontWeight.bold : null,
          )),
        ],
      ),
    );
  }
}

