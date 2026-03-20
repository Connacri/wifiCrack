import 'commerce_enums.dart';
import 'shipment.dart';
import 'order_return.dart';

class Order {
  final String id;
  final String userId;
  final String phone;
  final String address;
  final String? note;
  final double total;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final DateTime? createdAt;
  final List<OrderItem> items;
  final List<Shipment> shipments;
  final List<OrderReturn> returns;

  Order({
    required this.id,
    required this.userId,
    required this.phone,
    required this.address,
    required this.total,
    required this.status,
    required this.items,
    this.paymentStatus = PaymentStatus.pending,
    this.note,
    this.createdAt,
    this.shipments = const [],
    this.returns = const [],
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    final rawItems = map['items'];
    final items = <OrderItem>[];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map<String, dynamic>) {
          items.add(OrderItem.fromMap(item));
        } else if (item is Map) {
          items.add(OrderItem.fromMap(Map<String, dynamic>.from(item)));
        }
      }
    }

    final rawShipments = map['shipments'];
    final shipments = <Shipment>[];
    if (rawShipments is List) {
      for (final s in rawShipments) {
        if (s is Map<String, dynamic>) {
          shipments.add(Shipment.fromMap(s));
        }
      }
    }

    final rawReturns = map['returns'];
    final returns = <OrderReturn>[];
    if (rawReturns is List) {
      for (final r in rawReturns) {
        if (r is Map<String, dynamic>) {
          returns.add(OrderReturn.fromMap(r));
        }
      }
    }

    return Order(
      id: map['id']?.toString() ?? '',
      userId: (map['buyer_id'] ?? map['user_id'])?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      note: map['note']?.toString(),
      total: ((map['grand_total'] ?? map['total']) as num?)?.toDouble() ?? 0,
      status: OrderStatus.fromJson(map['status']?.toString()),
      paymentStatus: PaymentStatus.fromJson(map['payment_status']?.toString()),
      createdAt: _parseDate(map['created_at']),
      items: items,
      shipments: shipments,
      returns: returns,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}

class OrderItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final double subtotal;

  OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['product_id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0,
    );
  }
}
