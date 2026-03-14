class CctvProduct {
  final String id;
  final String name;
  final String? description;
  final double price;
  final double? promoPrice;
  final String? sku;
  final String? imageUrl;
  final String? category;
  final int? stock;
  final int popularity;
  final bool isActive;

  const CctvProduct({
    required this.id,
    required this.name,
    required this.price,
    this.promoPrice,
    this.sku,
    this.description,
    this.imageUrl,
    this.category,
    this.stock,
    this.popularity = 0,
    this.isActive = true,
  });

  factory CctvProduct.fromMap(Map<String, dynamic> map) {
    return CctvProduct(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Unknown',
      description: map['description']?.toString(),
      price: _toDouble(map['price']),
      promoPrice: _toNullableDouble(map['promo_price']),
      sku: map['sku']?.toString(),
      imageUrl: map['image_url']?.toString(),
      category: map['category']?.toString(),
      stock: _toInt(map['stock']),
      popularity: _toInt(map['popularity']) ?? 0,
      isActive: _toBool(map['is_active'], defaultValue: true),
    );
  }

  Map<String, dynamic> toMap({bool includeId = false}) {
    final data = <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'promo_price': promoPrice,
      'sku': sku,
      'image_url': imageUrl,
      'category': category,
      'stock': stock,
      'popularity': popularity,
      'is_active': isActive,
    };
    if (includeId && id.isNotEmpty) {
      data['id'] = id;
    }
    return data;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static double? _toNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
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

  double get effectivePrice {
    final promo = promoPrice;
    if (promo != null && promo > 0 && promo < price) {
      return promo;
    }
    return price;
  }

  bool get isOnPromo => promoPrice != null && promoPrice! > 0 && promoPrice! < price;
}
