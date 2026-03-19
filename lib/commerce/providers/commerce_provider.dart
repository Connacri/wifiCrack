import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/commerce_enums.dart';
import '../services/commerce_service.dart';

class CommerceProvider extends ChangeNotifier {
  final CommerceService _service;
  StreamSubscription? _productsSub;

  CommerceProvider(this._service) {
    _initProductsStream();
  }

  void _initProductsStream() {
    _productsSub?.cancel();
    _productsSub = _service.watchProductsStream().listen((data) {
      // Uniquement si on n'est pas en train de filtrer ou de chercher spécifiquement
      if ((_lastQuery == null || _lastQuery!.isEmpty) && 
          (_lastCategory == null || _lastCategory == 'All')) {
        _products = data.map(Product.fromMap).toList();
        _productsHasMore = false; // Le stream donne tout par défaut
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _productsSub?.cancel();
    super.dispose();
  }

  List<Product> _products = [];
  bool _loading = false;
  bool _loadingMore = false;
  bool _productsHasMore = true;
  int _productsOffset = 0;
  static const int _productsPageSize = 30;
  bool _includeInactive = true;
  String? _lastQuery;
  String? _lastCategory;
  String? _error;
  String? _ordersError;
  bool _ordersLoading = false;
  bool _ordersLoadingMore = false;
  bool _ordersHasMore = true;
  int _ordersOffset = 0;
  static const int _ordersPageSize = 20;
  final Set<String> _updatingOrderIds = {};

  final Map<String, CartItem> _cart = {};
  List<Order> _orders = [];

  UserRole _currentRole = UserRole.client;
  UserRole get currentRole => _currentRole;

  void setRole(UserRole role) {
    if (_currentRole == role) return;
    _currentRole = role;
    notifyListeners();
  }

  List<Product> get products => _products;
  bool get isLoading => _loading;
  bool get isLoadingMore => _loadingMore;
  bool get productsHasMore => _productsHasMore;
  bool get includeInactive => _includeInactive;
  String? get error => _error;
  List<Order> get orders => _orders;
  bool get ordersLoading => _ordersLoading;
  bool get ordersLoadingMore => _ordersLoadingMore;
  bool get ordersHasMore => _ordersHasMore;
  String? get ordersError => _ordersError;
  bool isUpdatingOrder(String orderId) =>
      _updatingOrderIds.contains(orderId);

  List<CartItem> get cartItems {
    final items = _cart.values.toList();
    items.sort((a, b) => a.product.name.compareTo(b.product.name));
    return items;
  }

  int get totalItems =>
      _cart.values.fold(0, (sum, item) => sum + item.quantity);

  double get total =>
      _cart.values.fold(0, (sum, item) => sum + item.subtotal);

  Future<void> loadProducts({
    String? query,
    String? category,
    bool? includeInactive,
    bool reset = true,
  }) async {
    _lastQuery = query;
    _lastCategory = category;
    if (includeInactive != null) {
      _includeInactive = includeInactive;
    }
    if (_loading || _loadingMore) return;
    if (reset) {
      _productsOffset = 0;
      _productsHasMore = true;
      _products = [];
    }

    _error = null;
    if (_products.isEmpty) {
      _loading = true;
    } else {
      _loadingMore = true;
    }
    notifyListeners();

    try {
      final fetched = await _service.fetchProducts(
        query: query,
        category: category,
        includeInactive: _includeInactive,
        offset: _productsOffset,
        limit: _productsPageSize,
      );
      if (reset) {
        _products = fetched;
      } else {
        _products.addAll(fetched);
      }
      _productsOffset += fetched.length;
      if (fetched.length < _productsPageSize) {
        _productsHasMore = false;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      _loadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreProducts() async {
    if (!_productsHasMore) return;
    await loadProducts(
      query: _lastQuery,
      category: _lastCategory,
      reset: false,
    );
  }

  String? _lastOrdersUserId;

  Future<void> loadOrders({String? userId, bool reset = false}) async {
    if (_ordersLoading || _ordersLoadingMore) return;
    _lastOrdersUserId = userId;
    if (reset) {
      _ordersOffset = 0;
      _ordersHasMore = true;
      _orders = [];
    }

    _ordersError = null;
    if (_orders.isEmpty) {
      _ordersLoading = true;
    } else {
      _ordersLoadingMore = true;
    }
    notifyListeners();

    try {
      final fetched = await _service.fetchOrders(
        userId: userId,
        offset: _ordersOffset,
        limit: _ordersPageSize,
      );
      if (reset) {
        _orders = fetched;
      } else {
        _orders.addAll(fetched);
      }
      _ordersOffset += fetched.length;
      if (fetched.length < _ordersPageSize) {
        _ordersHasMore = false;
      }
    } catch (e) {
      _ordersError = e.toString();
    } finally {
      _ordersLoading = false;
      _ordersLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreOrders() async {
    if (!_ordersHasMore) return;
    await loadOrders(userId: _lastOrdersUserId);
  }

  void setIncludeInactive(bool value) {
    if (_includeInactive == value) return;
    _includeInactive = value;
    loadProducts(query: _lastQuery, category: _lastCategory);
  }

  Future<bool> saveProduct(Product product) async {
    try {
      final isNew = product.id.isEmpty;
      String? oldImageUrl;

      // Si c'est une mise à jour, on identifie l'ancienne image à supprimer
      if (!isNew) {
        final oldProduct = _products.cast<Product?>().firstWhere(
          (p) => p?.id == product.id,
          orElse: () => null,
        );
        if (oldProduct != null &&
            oldProduct.imageUrl != null &&
            oldProduct.imageUrl!.isNotEmpty &&
            oldProduct.imageUrl != product.imageUrl) {
          oldImageUrl = oldProduct.imageUrl;
        }
      }

      final saved = isNew
          ? await _service.createProduct(product)
          : await _service.updateProduct(product);
      
      if (saved == null) return false;

      // Nettoyage de l'ancienne image SEULEMENT après succès de l'opération en base
      if (oldImageUrl != null) {
        await _service.deleteImage(oldImageUrl);
      }

      await loadProducts(query: _lastQuery, category: _lastCategory, reset: true);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await _service.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
      _cart.remove(productId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void addToCart(Product product) {
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

  Future<bool> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    if (orderId.trim().isEmpty) return false;
    _updatingOrderIds.add(orderId);
    notifyListeners();
    try {
      final ok = await _service.updateOrderStatus(
        orderId: orderId,
        status: status.toJson(),
      );
      if (ok) {
        final index = _orders.indexWhere((o) => o.id == orderId);
        if (index != -1) {
          final current = _orders[index];
          _orders[index] = Order(
            id: current.id,
            userId: current.userId,
            phone: current.phone,
            address: current.address,
            total: current.total,
            status: status,
            items: current.items,
            note: current.note,
            createdAt: current.createdAt,
            paymentStatus: current.paymentStatus,
            shipments: current.shipments,
            returns: current.returns,
          );
        }
      }
      return ok;
    } catch (_) {
      return false;
    } finally {
      _updatingOrderIds.remove(orderId);
      notifyListeners();
    }
  }

  // New methods for logistics
  Future<bool> createShipment({
    required String orderId,
    required String trackingNumber,
    required String carrierName,
    required List<OrderItem> items,
  }) async {
    try {
      final shipment = await _service.createShipment(
        orderId: orderId,
        trackingNumber: trackingNumber,
        carrierName: carrierName,
        items: items,
      );
      if (shipment != null) {
        await loadOrders(userId: _lastOrdersUserId, reset: true);
        return true;
      }
      return false;
    } catch (e) {
      _ordersError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateShipmentStatus({
    required String shipmentId,
    required ShipmentStatus status,
  }) async {
    try {
      final ok = await _service.updateShipmentStatus(
        shipmentId: shipmentId,
        status: status.toJson(),
      );
      if (ok) {
        await loadOrders(userId: _lastOrdersUserId, reset: true);
      }
      return ok;
    } catch (e) {
      _ordersError = e.toString();
      notifyListeners();
      return false;
    }
  }
}
