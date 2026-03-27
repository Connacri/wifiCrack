import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../models/commerce_enums.dart';
import '../models/order.dart';
import '../models/shipment.dart';
import '../providers/commerce_provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommerceProvider>();
    final l10n = AppLocalizations.of(context)!;
    final order = provider.orders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => throw Exception(l10n.orderNotFound),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.orderNumber(order.id.substring(0, 8))),
        actions: [_RoleSelector()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OrderStatusCard(order: order),
              const SizedBox(height: 16),
              if (provider.currentRole == UserRole.admin)
                _AdminStatusEditCard(order: order, provider: provider),
              const SizedBox(height: 16),
              _OrderItemsCard(order: order),
              const SizedBox(height: 16),
              _ShipmentsCard(order: order),
              const SizedBox(height: 16),
              _ActionPanel(order: order),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommerceProvider>();
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<UserRole>(
      initialValue: provider.currentRole,
      onSelected: provider.setRole,
      icon: const Icon(Icons.badge_outlined),
      tooltip: l10n.changeRoleTooltip,
      itemBuilder: (context) => UserRole.values
          .map((r) => PopupMenuItem(value: r, child: Text(r.label(l10n))))
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
    final l10n = AppLocalizations.of(context)!;
    final dateStr = order.createdAt != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt!)
        : l10n.unknownDate;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.globalStatus, style: theme.textTheme.labelLarge),
                _StatusBadge(status: order.status),
              ],
            ),
            const Divider(height: 24),
            _InfoRow(label: l10n.dateLabel, value: dateStr),
            _InfoRow(label: l10n.customerLabel, value: order.userId),
            _InfoRow(label: l10n.phoneLabel, value: order.phone),
            _InfoRow(label: l10n.addressLabel, value: order.address),
            _InfoRow(
              label: l10n.paymentLabel,
              value: PaymentStatus.fromJson(order.paymentStatus).label(l10n),
              valueColor:
                  order.paymentStatus == PaymentStatus.captured.name ||
                      order.paymentStatus == 'captured'
                  ? Colors.green
                  : Colors.orange,
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.totalLabel, style: theme.textTheme.titleMedium),
                Text(
                  l10n.amountWithCurrency(order.total.toStringAsFixed(2)),
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
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.productsLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
                  subtitle: Text(
                    l10n.priceXQuantity(
                      item.price.toStringAsFixed(2),
                      item.quantity,
                    ),
                  ),
                  trailing: Text(
                    l10n.amountWithCurrency(item.subtotal.toStringAsFixed(2)),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
    final l10n = AppLocalizations.of(context)!;
    if (order.shipments.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(l10n.noShipmentsYet),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            l10n.shipmentsCount(order.shipments.length),
            style: Theme.of(context).textTheme.titleMedium,
          ),
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
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(l10n.packageNumber(shipment.trackingNumber)),
        subtitle: Text(l10n.carrierLabel(shipment.carrierName)),
        trailing: _ShipmentStatusBadge(status: shipment.status),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(label: l10n.packageId, value: shipment.id),
                if (shipment.shippedAt != null)
                  _InfoRow(
                    label: l10n.shippedOn,
                    value: DateFormat(
                      'dd/MM/yyyy HH:mm',
                    ).format(shipment.shippedAt!),
                  ),
                const SizedBox(height: 8),
                Text(
                  l10n.itemsInPackage,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                ...shipment.items.map(
                  (i) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(l10n.shipmentItemLine(i.name, i.quantity)),
                  ),
                ),
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
        if (role == UserRole.wholesaler)
          ..._buildWholesalerActions(context, provider),
        if (role == UserRole.warehouse)
          ..._buildWarehouseActions(context, provider),
        if (role == UserRole.carrier)
          ..._buildCarrierActions(context, provider),
        if (role == UserRole.driver) ..._buildDriverActions(context, provider),
        if (role == UserRole.client) ..._buildClientActions(context, provider),
      ],
    );
  }

  List<Widget> _buildWholesalerActions(
    BuildContext context,
    CommerceProvider provider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return [
      if (order.status == OrderStatus.created.name || order.status == 'created')
        ElevatedButton.icon(
          onPressed: () => provider.updateOrderStatus(
            orderId: order.id,
            status: OrderStatus.orderConfirmed.name,
          ),
          icon: const Icon(Icons.check_circle),
          label: Text(l10n.confirmOrderButton),
        ),
      if (order.status == OrderStatus.orderConfirmed.name || order.status == 'order_confirmed')
        ElevatedButton.icon(
          onPressed: () => provider.updateOrderStatus(
            orderId: order.id,
            status: OrderStatus.stockAllocated.name,
          ),
          icon: const Icon(Icons.inventory),
          label: Text(l10n.allocateStockButton),
        ),
    ];
  }

  List<Widget> _buildWarehouseActions(
    BuildContext context,
    CommerceProvider provider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return [
      if (order.status == OrderStatus.stockAllocated.name ||
          order.status == 'stock_allocated')
        ElevatedButton.icon(
          onPressed: () => provider.updateOrderStatus(
            orderId: order.id,
            status: OrderStatus.picking.name,
          ),
          icon: const Icon(Icons.shopping_basket),
          label: Text(l10n.startPickingButton),
        ),
      if (order.status == OrderStatus.picking.name || order.status == 'picking')
        ElevatedButton.icon(
          onPressed: () => provider.updateOrderStatus(
            orderId: order.id,
            status: OrderStatus.packed.name,
          ),
          icon: const Icon(Icons.inventory_2),
          label: Text(l10n.packingFinishedButton),
        ),
      if (order.status == OrderStatus.packed.name || order.status == 'packed')
        ElevatedButton.icon(
          onPressed: () => _showCreateShipmentDialog(context, provider),
          icon: const Icon(Icons.local_shipping),
          label: Text(l10n.shipButton),
        ),
    ];
  }

  List<Widget> _buildCarrierActions(
    BuildContext context,
    CommerceProvider provider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return order.shipments.map((s) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: OutlinedButton.icon(
          onPressed: () => provider.updateShipmentStatus(
            shipmentId: s.id,
            status: ShipmentStatus.inTransit,
          ),
          icon: const Icon(Icons.route),
          label: Text(l10n.setInTransitButton(s.trackingNumber)),
        ),
      );
    }).toList();
  }

  List<Widget> _buildDriverActions(
    BuildContext context,
    CommerceProvider provider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return order.shipments
        .where((s) => s.status != ShipmentStatus.delivered)
        .map((s) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: FilledButton.icon(
              onPressed: () => provider.updateShipmentStatus(
                shipmentId: s.id,
                status: ShipmentStatus.delivered,
              ),
              icon: const Icon(Icons.done_all),
              label: Text(l10n.confirmDeliveryButton(s.trackingNumber)),
            ),
          );
        })
        .toList();
  }

  List<Widget> _buildClientActions(
    BuildContext context,
    CommerceProvider provider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return [
      if (order.status == OrderStatus.delivered.name ||
          order.status == 'delivered')
        TextButton.icon(
          onPressed: () {
            // Logic for return request
          },
          icon: const Icon(Icons.keyboard_return),
          label: Text(l10n.requestReturnButton),
        ),
    ];
  }

  void _showCreateShipmentDialog(
    BuildContext context,
    CommerceProvider provider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final trackingCtrl = TextEditingController(
      text: 'TRK-${DateTime.now().millisecondsSinceEpoch}',
    );
    final carrierCtrl = TextEditingController(text: 'DHL');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.newShipmentTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: carrierCtrl,
              decoration: InputDecoration(labelText: l10n.carrierLabel('')),
            ),
            TextField(
              controller: trackingCtrl,
              decoration: InputDecoration(labelText: l10n.trackingNumberLabel),
            ),
            const SizedBox(height: 12),
            Text(l10n.allItemIncludedNote),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
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
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = OrderStatus.tryParse(status);
    final label = s != null ? s.label(l10n) : status;
    final color = s != null ? _getColorForStatus(s) : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getColorForStatus(OrderStatus s) {
    switch (s) {
      case OrderStatus.created:
        return Colors.blue;
      case OrderStatus.paid:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.purple;
      case OrderStatus.shipped:
        return Colors.orange;
      case OrderStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _ShipmentStatusBadge extends StatelessWidget {
  final ShipmentStatus status;

  const _ShipmentStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.label(l10n),
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
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: valueColor,
              fontWeight: valueColor != null ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminStatusEditCard extends StatefulWidget {
  final Order order;
  final CommerceProvider provider;

  const _AdminStatusEditCard({required this.order, required this.provider});

  @override
  State<_AdminStatusEditCard> createState() => _AdminStatusEditCardState();
}

class _AdminStatusEditCardState extends State<_AdminStatusEditCard> {
  late final TextEditingController _statusCtrl;
  late final TextEditingController _paymentStatusCtrl;

  @override
  void initState() {
    super.initState();
    _statusCtrl = TextEditingController(text: widget.order.status);
    _paymentStatusCtrl = TextEditingController(
      text: widget.order.paymentStatus,
    );
  }

  @override
  void dispose() {
    _statusCtrl.dispose();
    _paymentStatusCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.admin_panel_settings, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  l10n.adminStatusTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _statusCtrl,
              decoration: InputDecoration(
                labelText: l10n.globalStatus,
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    widget.provider.updateOrderStatus(
                      orderId: widget.order.id,
                      status: _statusCtrl.text.trim(),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _paymentStatusCtrl,
              decoration: InputDecoration(
                labelText: l10n.paymentLabel,
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    widget.provider.updatePaymentStatus(
                      orderId: widget.order.id,
                      paymentStatus: _paymentStatusCtrl.text.trim(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
