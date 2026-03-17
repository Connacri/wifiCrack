import 'commerce_enums.dart';
import 'order.dart';

class Shipment {
  final String id;
  final String orderId;
  final String trackingNumber;
  final String carrierName;
  final ShipmentStatus status;
  final List<OrderItem> items;
  final DateTime? shippedAt;
  final DateTime? estimatedDelivery;
  final DateTime? actualDelivery;

  Shipment({
    required this.id,
    required this.orderId,
    required this.trackingNumber,
    required this.carrierName,
    required this.status,
    required this.items,
    this.shippedAt,
    this.estimatedDelivery,
    this.actualDelivery,
  });

  factory Shipment.fromMap(Map<String, dynamic> map) {
    final rawItems = map['items'];
    final items = <OrderItem>[];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map<String, dynamic>) {
          items.add(OrderItem.fromMap(item));
        }
      }
    }

    return Shipment(
      id: map['id']?.toString() ?? '',
      orderId: map['order_id']?.toString() ?? '',
      trackingNumber: map['tracking_number']?.toString() ?? '',
      carrierName: map['carrier_name']?.toString() ?? '',
      status: ShipmentStatus.fromJson(map['status']?.toString()),
      items: items,
      shippedAt: _parseDate(map['shipped_at']),
      estimatedDelivery: _parseDate(map['estimated_delivery']),
      actualDelivery: _parseDate(map['actual_delivery']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order_id': orderId,
      'tracking_number': trackingNumber,
      'carrier_name': carrierName,
      'status': status.toJson(),
      'items': items.map((i) => {
        'product_id': i.productId,
        'name': i.name,
        'price': i.price,
        'quantity': i.quantity,
        'subtotal': i.subtotal,
      }).toList(),
      'shipped_at': shippedAt?.toIso8601String(),
      'estimated_delivery': estimatedDelivery?.toIso8601String(),
      'actual_delivery': actualDelivery?.toIso8601String(),
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
