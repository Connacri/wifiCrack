class Product {
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
  final bool isFavorite;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Product({
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
    this.isFavorite = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
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
      isFavorite: _toBool(
        map['is_favorite'] ?? 
        (map['product_favorites'] != null && (map['product_favorites'] as List).isNotEmpty), 
        defaultValue: false
      ),
      createdAt: _toDateTime(map['created_at']),
      updatedAt: _toDateTime(map['updated_at']),
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? promoPrice,
    String? sku,
    String? imageUrl,
    String? category,
    int? stock,
    int? popularity,
    bool? isActive,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      promoPrice: promoPrice ?? this.promoPrice,
      sku: sku ?? this.sku,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      popularity: popularity ?? this.popularity,
      isActive: isActive ?? this.isActive,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    // Note: createdAt and updatedAt are usually handled by the database
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

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
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
