import 'commerce_enums.dart';
import 'order.dart';

class OrderReturn {
  final String id;
  final String orderId;
  final String reason;
  final ReturnStatus status;
  final List<OrderItem> items;
  final double refundAmount;
  final DateTime? createdAt;

  OrderReturn({
    required this.id,
    required this.orderId,
    required this.reason,
    required this.status,
    required this.items,
    required this.refundAmount,
    this.createdAt,
  });

  factory OrderReturn.fromMap(Map<String, dynamic> map) {
    final rawItems = map['items'];
    final items = <OrderItem>[];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map<String, dynamic>) {
          items.add(OrderItem.fromMap(item));
        }
      }
    }

    return OrderReturn(
      id: map['id']?.toString() ?? '',
      orderId: map['order_id']?.toString() ?? '',
      reason: map['reason']?.toString() ?? '',
      status: ReturnStatus.fromJson(map['status']?.toString()),
      items: items,
      refundAmount: (map['refund_amount'] as num?)?.toDouble() ?? 0,
      createdAt: _parseDate(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order_id': orderId,
      'reason': reason,
      'status': status.toJson(),
      'items': items.map((i) => {
        'product_id': i.productId,
        'name': i.name,
        'price': i.price,
        'quantity': i.quantity,
        'subtotal': i.subtotal,
      }).toList(),
      'refund_amount': refundAmount,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
