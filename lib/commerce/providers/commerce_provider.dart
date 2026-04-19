import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/sources/supabase_service.dart';
import '../models/cart_item.dart';
import '../models/commerce_enums.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/shipment.dart';
import '../services/commerce_service.dart';

class CommerceProvider extends ChangeNotifier {
  final CommerceService _service;
  final SupabaseService _supabaseService;
  StreamSubscription? _productsSub;
  Timer? _productsStreamRetry;
  RealtimeChannel? _ordersChannel;
  String? _ordersStreamUserId;

  CommerceProvider(this._service, this._supabaseService) {
    _initProductsStream();
  }

  void _initProductsStream() {
    _productsSub?.cancel();
    _productsSub = _service.watchProductsStream().listen(
      (data) {
        if ((_lastQuery == null || _lastQuery!.isEmpty) &&
            (_lastCategory == null || _lastCategory == 'All')) {
          final incoming = data.map(Product.fromMap).toList();
          _products = _mergeFavorites(incoming);
          _lastUnfilteredProducts = List<Product>.from(_products);
          _productsHasMore = false;
          notifyListeners();
        }
      },
      onError: (err, st) {
        debugPrint('[Commerce] Products stream error: $err');
        _scheduleProductsStreamRetry();
      },
      onDone: () {
        debugPrint('[Commerce] Products stream closed.');
        _scheduleProductsStreamRetry();
      },
      cancelOnError: false,
    );
  }

  List<Product> _mergeFavorites(List<Product> incoming) {
    if (_currentUserId == null || _currentUserId!.isEmpty) return incoming;
    if (_products.isEmpty) return incoming;
    final favoriteIds = <String>{};
    for (final product in _products) {
      if (product.isFavorite) favoriteIds.add(product.id);
    }
    if (favoriteIds.isEmpty) return incoming;
    return incoming
        .map(
          (product) => favoriteIds.contains(product.id)
              ? product.copyWith(isFavorite: true)
              : product,
        )
        .toList();
  }

  void _scheduleProductsStreamRetry() {
    if (_productsStreamRetry?.isActive ?? false) return;
    _productsStreamRetry = Timer(
      const Duration(seconds: 5),
      _initProductsStream,
    );
  }

  void _initOrdersStream(String? userId) {
    final normalizedUserId = (userId == null || userId.trim().isEmpty)
        ? null
        : userId.trim();
    if (_ordersChannel != null && _ordersStreamUserId == normalizedUserId)
      return;
    _ordersStreamUserId = normalizedUserId;
    _ordersChannel?.unsubscribe();
    _ordersChannel = null;

    final channelName = normalizedUserId == null
        ? 'orders:all'
        : 'orders:$normalizedUserId';
    final channel = Supabase.instance.client.channel(channelName);

    PostgresChangeFilter? filter;
    if (normalizedUserId != null) {
      filter = PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'buyer_id',
        value: normalizedUserId,
      );
    }

    channel
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'orders',
        filter: filter,
        callback: (payload) => _upsertOrderFromRealtime(payload.newRecord),
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'orders',
        filter: filter,
        callback: (payload) => _upsertOrderFromRealtime(payload.newRecord),
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.delete,
        schema: 'public',
        table: 'orders',
        filter: filter,
        callback: (payload) => _removeOrderFromRealtime(payload.oldRecord),
      )
      ..subscribe();

    _ordersChannel = channel;
  }

  Map<String, dynamic>? _normalizeOrderRecord(Map<dynamic, dynamic>? record) {
    if (record == null || record.isEmpty) return null;
    return Map<String, dynamic>.from(record);
  }

  void _upsertOrderFromRealtime(Map<dynamic, dynamic>? record) {
    final map = _normalizeOrderRecord(record);
    if (map == null) return;
    final incoming = Order.fromMap(map);
    if (incoming.id.isEmpty) return;

    final index = _orders.indexWhere((o) => o.id == incoming.id);
    if (index == -1) {
      _orders.insert(0, incoming);
    } else {
      // Le payload Realtime ne contient pas les relations (shipments/returns).
      // On préserve celles déjà en mémoire pour ne pas les effacer.
      final existing = _orders[index];
      _orders[index] = Order(
        id: incoming.id,
        userId: incoming.userId,
        phone: incoming.phone,
        address: incoming.address,
        total: incoming.total,
        status: incoming.status,
        paymentStatus: incoming.paymentStatus,
        note: incoming.note,
        createdAt: incoming.createdAt ?? existing.createdAt,
        items: incoming.items.isNotEmpty ? incoming.items : existing.items,
        // CRITIQUE : on garde les shipments existants si le payload n'en a pas
        shipments: incoming.shipments.isNotEmpty
            ? incoming.shipments
            : existing.shipments,
        returns: incoming.returns.isNotEmpty
            ? incoming.returns
            : existing.returns,
      );
    }
    _sortOrders();
    notifyListeners();
  }

  void _removeOrderFromRealtime(Map<dynamic, dynamic>? record) {
    final map = _normalizeOrderRecord(record);
    if (map == null) return;
    final id = map['id']?.toString();
    if (id == null || id.isEmpty) return;
    final before = _orders.length;
    _orders.removeWhere((o) => o.id == id);
    if (_orders.length != before) notifyListeners();
  }

  void _sortOrders() {
    _orders.sort((a, b) {
      final aDate = a.createdAt ?? DateTime(0);
      final bDate = b.createdAt ?? DateTime(0);
      return bDate.compareTo(aDate);
    });
  }

  // ─────────────────────────────────────────────────────────
  // PERMISSION HELPERS
  // ─────────────────────────────────────────────────────────

  Set<OrderStatus> allowedOrderTransitions(OrderStatus current) =>
      OrderTransitionPolicy.allowedTransitions(
        role: _currentRole,
        current: current,
      );

  Set<ShipmentStatus> allowedShipmentTransitions(ShipmentStatus current) =>
      ShipmentTransitionPolicy.allowedTransitions(
        role: _currentRole,
        current: current,
      );

  // ─────────────────────────────────────────────────────────
  // ORDER STATUS
  // ─────────────────────────────────────────────────────────

  Future<bool> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    if (orderId.trim().isEmpty) return false;

    final targetStatus = OrderStatus.tryParse(status);
    final isAdmin =
        _currentRole == UserRole.admin || _currentRole == UserRole.support;

    if (targetStatus == null && !isAdmin) {
      debugPrint('[Commerce] updateOrderStatus: statut inconnu "$status"');
      return false;
    }

    final Order? order = _orders.cast<Order?>().firstWhere(
      (o) => o?.id == orderId,
      orElse: () => null,
    );
    if (order == null) {
      debugPrint('[Commerce] updateOrderStatus: ordre $orderId introuvable');
      return false;
    }

    if (targetStatus != null && !isAdmin) {
      final currentStatus = OrderStatus.fromJson(order.status);
      if (!OrderTransitionPolicy.canTransition(
        role: _currentRole,
        from: currentStatus,
        to: targetStatus,
      )) {
        debugPrint(
          '[Commerce] Transition refusée [$_currentRole] '
          '$currentStatus → $targetStatus',
        );
        _ordersError =
            'Transition non autorisée : $_currentRole '
            'ne peut pas passer de $currentStatus à $targetStatus';
        notifyListeners();
        return false;
      }
    }

    _updatingOrderIds.add(orderId);
    notifyListeners();
    try {
      final ok = await _service.updateOrderStatus(
        orderId: orderId,
        status: status,
      );
      if (ok) _syncOrderStatusLocal(orderId, status);
      return ok;
    } catch (e) {
      _ordersError = e.toString();
      return false;
    } finally {
      _updatingOrderIds.remove(orderId);
      notifyListeners();
    }
  }

  // ─────────────────────────────────────────────────────────
  // SHIPMENT STATUS
  // ─────────────────────────────────────────────────────────

  Future<bool> updateShipmentStatus({
    required String shipmentId,
    required ShipmentStatus status,
    String? orderId,
    ShipmentStatus? fromStatus,
  }) async {
    final isAdmin =
        _currentRole == UserRole.admin || _currentRole == UserRole.support;

    if (!isAdmin &&
        fromStatus != null &&
        !ShipmentTransitionPolicy.canTransition(
          role: _currentRole,
          from: fromStatus,
          to: status,
        )) {
      debugPrint(
        '[Commerce] Shipment transition refusée [$_currentRole] '
        '$fromStatus → $status',
      );
      _ordersError = 'Expédition : transition non autorisée pour $_currentRole';
      notifyListeners();
      return false;
    }

    try {
      final ok = await _service.updateShipmentStatus(
        shipmentId: shipmentId,
        status: status.toJson(),
      );

      if (ok) {
        // BUG #2/#3 FIX : mise à jour locale immédiate du shipment en mémoire
        // AVANT : loadOrders(reset:true) écrasait tout → race condition
        //         si Supabase FK pas encore propagée, order.shipments redevenait []
        // APRÈS : _syncShipmentStatusLocal met à jour le shipment en place
        //         sans toucher aux autres données en mémoire
        _syncShipmentStatusLocal(shipmentId, status);

        if (orderId != null && orderId.trim().isNotEmpty) {
          final corresponding = _shipmentToOrderStatus(status);
          if (corresponding != null) {
            await _service.updateOrderStatus(
              orderId: orderId,
              status: corresponding.name,
            );
            _syncOrderStatusLocal(orderId, corresponding.name);
          }
          notifyListeners();
        }
      }
      return ok;
    } catch (e) {
      _ordersError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePaymentStatus({
    required String orderId,
    required String paymentStatus,
  }) async {
    if (orderId.trim().isEmpty) return false;
    _updatingOrderIds.add(orderId);
    notifyListeners();
    try {
      final ok = await _service.updatePaymentStatus(
        orderId: orderId,
        paymentStatus: paymentStatus,
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
            status: current.status,
            paymentStatus: paymentStatus,
            items: current.items,
            note: current.note,
            createdAt: current.createdAt,
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

  // ─────────────────────────────────────────────────────────
  // SHIPMENTS
  // ─────────────────────────────────────────────────────────

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
        await _service.updateOrderStatus(
          orderId: orderId,
          status: OrderStatus.readyToShip.name,
        );

        _syncOrderStatusLocal(
          orderId,
          OrderStatus.readyToShip.name,
          newShipment: shipment,
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _ordersError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Met à jour le statut d'un shipment localement sans reset des données.
  ///
  /// FIX Bug #2/#3 : remplace l'ancien loadOrders(reset:true) qui causait
  /// une race condition — si Supabase n'avait pas encore propagé la FK
  /// shipments→orders, le reload retournait order.shipments = [] et
  /// tous les rôles se retrouvaient avec le message "En attente de préparation".
  void _syncShipmentStatusLocal(String shipmentId, ShipmentStatus newStatus) {
    for (int i = 0; i < _orders.length; i++) {
      final order = _orders[i];
      final shipmentIndex = order.shipments.indexWhere(
        (s) => s.id == shipmentId,
      );
      if (shipmentIndex == -1) continue;

      final old = order.shipments[shipmentIndex];
      final updatedShipment = Shipment(
        id: old.id,
        orderId: old.orderId,
        trackingNumber: old.trackingNumber,
        carrierName: old.carrierName,
        status: newStatus,
        items: old.items,
        shippedAt: old.shippedAt,
        estimatedDelivery: old.estimatedDelivery,
        actualDelivery: newStatus == ShipmentStatus.delivered
            ? DateTime.now()
            : old.actualDelivery,
      );

      final updatedShipments = List<Shipment>.from(order.shipments);
      updatedShipments[shipmentIndex] = updatedShipment;

      _orders[i] = Order(
        id: order.id,
        userId: order.userId,
        phone: order.phone,
        address: order.address,
        total: order.total,
        status: order.status,
        paymentStatus: order.paymentStatus,
        note: order.note,
        createdAt: order.createdAt,
        items: order.items,
        shipments: updatedShipments,
        returns: order.returns,
      );
      return; // shipmentId est unique → on sort dès qu'on l'a trouvé
    }
    debugPrint(
      '[Commerce] _syncShipmentStatusLocal: shipment $shipmentId introuvable en mémoire',
    );
  }

  void _syncOrderStatusLocal(
    String orderId,
    String status, {
    Shipment? newShipment,
  }) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index == -1) return;
    final current = _orders[index];
    _orders[index] = Order(
      id: current.id,
      userId: current.userId,
      phone: current.phone,
      address: current.address,
      total: current.total,
      status: status,
      paymentStatus: current.paymentStatus,
      items: current.items,
      note: current.note,
      createdAt: current.createdAt,
      shipments: newShipment != null
          ? [...current.shipments, newShipment]
          : current.shipments,
      returns: current.returns,
    );
  }

  OrderStatus? _shipmentToOrderStatus(ShipmentStatus shipmentStatus) {
    switch (shipmentStatus) {
      case ShipmentStatus.pickedUp:
      case ShipmentStatus.inTransit:
      case ShipmentStatus.arrivedAtHub:
      case ShipmentStatus.customsClearance:
      case ShipmentStatus.outForDelivery:
        return OrderStatus.shipped;
      case ShipmentStatus.delivered:
        return OrderStatus.delivered;
      case ShipmentStatus.deliveryFailed:
        return OrderStatus.deliveryFailed;
      case ShipmentStatus.returnToSender:
        return OrderStatus.returnInTransit;
      default:
        return null;
    }
  }

  @override
  void dispose() {
    _productsSub?.cancel();
    _productsStreamRetry?.cancel();
    _ordersChannel?.unsubscribe();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────
  // STATE
  // ─────────────────────────────────────────────────────────

  List<Product> _products = [];
  bool _loading = false;
  bool _loadingMore = false;
  bool _productsHasMore = true;
  int _productsOffset = 0;
  static const int _productsPageSize = 30;
  bool _includeInactive = true;
  String? _lastQuery;
  String? _lastCategory;
  String? _currentUserId;
  bool _pendingProductsReload = false;
  List<Product> _lastUnfilteredProducts = [];

  void setCurrentUserId(String? userId) {
    if (_currentUserId == userId) return;
    _currentUserId = userId;
    _pendingProductsReload = true;
    if (!_loading && !_loadingMore) {
      loadProducts(query: _lastQuery, category: _lastCategory, reset: true);
    }
  }

  String? get currentUserId => _currentUserId;
  String? get lastQuery => _lastQuery;

  Future<void> toggleFavorite(String productId) async {
    if (_currentUserId == null || _currentUserId!.isEmpty) return;
    final index = _products.indexWhere((p) => p.id == productId);
    if (index == -1) return;
    final product = _products[index];
    final nextState = !product.isFavorite;
    _products[index] = product.copyWith(isFavorite: nextState);
    notifyListeners();
    try {
      await _service.toggleFavorite(_currentUserId!, productId, nextState);
    } catch (e) {
      _products[index] = product;
      _error = e.toString();
      notifyListeners();
    }
  }

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
  bool isUpdatingOrder(String orderId) => _updatingOrderIds.contains(orderId);

  List<CartItem> get cartItems {
    final items = _cart.values.toList();
    items.sort((a, b) => a.product.name.compareTo(b.product.name));
    return items;
  }

  int get totalItems =>
      _cart.values.fold(0, (sum, item) => sum + item.quantity);
  double get total => _cart.values.fold(0, (sum, item) => sum + item.subtotal);

  // ─────────────────────────────────────────────────────────
  // PRODUCTS
  // ─────────────────────────────────────────────────────────

  Future<void> loadProducts({
    String? query,
    String? category,
    bool? includeInactive,
    bool reset = true,
  }) async {
    final normalizedQuery = query?.trim();
    final isQueryEmpty = normalizedQuery == null || normalizedQuery.isEmpty;
    _lastQuery = isQueryEmpty ? null : normalizedQuery;
    _lastCategory = category;
    if (includeInactive != null) _includeInactive = includeInactive;
    if (_loading || _loadingMore) {
      _pendingProductsReload = _pendingProductsReload || reset;
      return;
    }
    _pendingProductsReload = false;
    if (reset) {
      _productsOffset = 0;
      _productsHasMore = true;
      if (isQueryEmpty) {
        _products = _lastUnfilteredProducts.isNotEmpty
            ? List<Product>.from(_lastUnfilteredProducts)
            : [];
      }
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
        query: normalizedQuery,
        category: category,
        includeInactive: _includeInactive,
        offset: _productsOffset,
        limit: _productsPageSize,
        userId: _currentUserId,
      );
      if (reset) {
        _products = fetched;
        if (isQueryEmpty) _lastUnfilteredProducts = fetched;
      } else {
        _products.addAll(fetched);
      }
      _productsOffset += fetched.length;
      if (fetched.length < _productsPageSize) _productsHasMore = false;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      _loadingMore = false;
      notifyListeners();
      if (_pendingProductsReload) {
        _pendingProductsReload = false;
        await loadProducts(
          query: _lastQuery,
          category: _lastCategory,
          reset: true,
        );
      }
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

  // ─────────────────────────────────────────────────────────
  // ORDERS
  // ─────────────────────────────────────────────────────────

  String? _lastOrdersUserId;

  Future<void> loadOrders({String? userId, bool reset = false}) async {
    final normalizedUserId = (userId == null || userId.trim().isEmpty)
        ? null
        : userId.trim();
    _lastOrdersUserId = normalizedUserId;
    _initOrdersStream(normalizedUserId);
    if (_ordersLoading || _ordersLoadingMore) return;
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
        userId: normalizedUserId,
        offset: _ordersOffset,
        limit: _ordersPageSize,
      );
      if (reset) {
        _orders = fetched;
      } else {
        final existingIds = _orders.map((o) => o.id).toSet();
        for (final order in fetched) {
          if (order.id.isEmpty || existingIds.contains(order.id)) continue;
          _orders.add(order);
        }
      }
      _ordersOffset += fetched.length;
      if (fetched.length < _ordersPageSize) _ordersHasMore = false;
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

  // ─────────────────────────────────────────────────────────
  // PRODUCTS CRUD
  // ─────────────────────────────────────────────────────────

  void setIncludeInactive(bool value) {
    if (_includeInactive == value) return;
    _includeInactive = value;
    loadProducts(query: _lastQuery, category: _lastCategory);
  }

  Future<bool> saveProduct(Product product) async {
    try {
      final isNew = product.id.isEmpty;
      String? oldImageUrl;
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
      if (oldImageUrl != null) await _service.deleteImage(oldImageUrl);
      await loadProducts(
        query: _lastQuery,
        category: _lastCategory,
        reset: true,
      );
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

  // ─────────────────────────────────────────────────────────
  // CART
  // ─────────────────────────────────────────────────────────

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

  // ─────────────────────────────────────────────────────────
  // PLACE ORDER
  // ─────────────────────────────────────────────────────────

  Future<String?> placeOrder({
    required String phone,
    required String address,
    String? note,
    String? userId,
    String? clientName,
  }) async {
    if (_cart.isEmpty) return null;
    final buyerId = (userId == null || userId.trim().isEmpty)
        ? null
        : userId.trim();
    if (buyerId == null) {
      debugPrint('[Commerce] placeOrder blocked: userId missing');
      _ordersError =
          "Impossible de passer commande : utilisateur non identifié.";
      notifyListeners();
      return null;
    }

    try {
      await _supabaseService.registerUser(
        device_id: buyerId,
        model: "Commerce User",
        pseudo: clientName,
      );
      final orderId = await _service.createOrder(
        userId: buyerId,
        items: cartItems,
        total: total,
        phone: phone,
        address: address,
        note: note,
        clientName: clientName,
      );
      if (orderId != null) {
        clearCart();
      } else {
        _ordersError =
            "Erreur inconnue : la commande n'a pas retourné d'identifiant.";
        notifyListeners();
      }
      return orderId;
    } catch (e) {
      debugPrint('[Commerce] placeOrder error: $e');
      _ordersError = e.toString();
      notifyListeners();
      return null;
    }
  }
}
