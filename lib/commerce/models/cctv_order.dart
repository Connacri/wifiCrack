class CctvOrder {
  final String id;
  final String userId;
  final String phone;
  final String address;
  final String? note;
  final double total;
  final String status;
  final DateTime? createdAt;
  final List<CctvOrderItem> items;

  CctvOrder({
    required this.id,
    required this.userId,
    required this.phone,
    required this.address,
    required this.total,
    required this.status,
    required this.items,
    this.note,
    this.createdAt,
  });

  factory CctvOrder.fromMap(Map<String, dynamic> map) {
    final rawItems = map['items'];
    final items = <CctvOrderItem>[];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map<String, dynamic>) {
          items.add(CctvOrderItem.fromMap(item));
        } else if (item is Map) {
          items.add(CctvOrderItem.fromMap(Map<String, dynamic>.from(item)));
        }
      }
    }

    return CctvOrder(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      note: map['note']?.toString(),
      total: (map['total'] as num?)?.toDouble() ?? 0,
      status: map['status']?.toString() ?? 'pending',
      createdAt: _parseDate(map['created_at']),
      items: items,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}

class CctvOrderItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final double subtotal;

  CctvOrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory CctvOrderItem.fromMap(Map<String, dynamic> map) {
    return CctvOrderItem(
      productId: map['product_id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0,
    );
  }
}
