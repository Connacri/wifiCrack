import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/cctv_product.dart';
import '../services/commerce_service.dart';

class CommerceProvider extends ChangeNotifier {
  final CommerceService _service;

  CommerceProvider(this._service);

  List<CctvProduct> _products = [];
  bool _loading = false;
  String? _error;

  final Map<String, CartItem> _cart = {};

  List<CctvProduct> get products => _products;
  bool get isLoading => _loading;
  String? get error => _error;

  List<CartItem> get cartItems {
    final items = _cart.values.toList();
    items.sort((a, b) => a.product.name.compareTo(b.product.name));
    return items;
  }

  int get totalItems =>
      _cart.values.fold(0, (sum, item) => sum + item.quantity);

  double get total =>
      _cart.values.fold(0, (sum, item) => sum + item.subtotal);

  Future<void> loadProducts({String? query, String? category}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await _service.fetchProducts(
        query: query,
        category: category,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void addToCart(CctvProduct product) {
    final existing = _cart[product.id];
    final nextQty = (existing?.quantity ?? 0) + 1;
    _cart[product.id] = CartItem(product: product, quantity: nextQty);
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      _cart.remove(productId);
    } else {
      final existing = _cart[productId];
      if (existing != null) {
        _cart[productId] = existing.copyWith(quantity: quantity);
      }
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Future<String?> placeOrder({
    required String phone,
    required String address,
    String? note,
    String? userId,
  }) async {
    if (_cart.isEmpty) return null;
    final safeUserId =
        (userId == null || userId.trim().isEmpty) ? 'guest' : userId.trim();

    final orderId = await _service.createOrder(
      userId: safeUserId,
      items: cartItems,
      total: total,
      phone: phone,
      address: address,
      note: note,
    );

    if (orderId != null) {
      clearCart();
    }

    return orderId;
  }
}
