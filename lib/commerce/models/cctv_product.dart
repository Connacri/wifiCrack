class CctvProduct {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final String? category;
  final int? stock;
  final bool isActive;

  const CctvProduct({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.imageUrl,
    this.category,
    this.stock,
    this.isActive = true,
  });

  factory CctvProduct.fromMap(Map<String, dynamic> map) {
    return CctvProduct(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Unknown',
      description: map['description']?.toString(),
      price: _toDouble(map['price']),
      imageUrl: map['image_url']?.toString(),
      category: map['category']?.toString(),
      stock: _toInt(map['stock']),
      isActive: _toBool(map['is_active'], defaultValue: true),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static bool _toBool(dynamic value, {required bool defaultValue}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final str = value.toString().toLowerCase().trim();
    if (str == 'true' || str == '1' || str == 'yes') return true;
    if (str == 'false' || str == '0' || str == 'no') return false;
    return defaultValue;
  }
}
