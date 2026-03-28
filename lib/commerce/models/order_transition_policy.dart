import 'commerce_enums.dart';

/// Matrice des transitions OrderStatus autorisées par UserRole.
/// Source unique de vérité — utilisée par le provider ET l'UI.
abstract final class OrderTransitionPolicy {
  /// Transitions autorisées depuis [current] pour [role].
  /// Retourne un Set vide si aucune action n'est permise.
  static Set<OrderStatus> allowedFrom({
    required UserRole role,
    required OrderStatus current,
  }) {
    if (role == UserRole.admin || role == UserRole.support) {
      return OrderStatus.values.where((s) => s != current).toSet();
    }
    return switch (role) {
      UserRole.warehouse => _warehouse[current] ?? {},
      UserRole.carrier => _carrier[current] ?? {},
      UserRole.driver => _driver[current] ?? {},
      UserRole.client => _client[current] ?? {},
      UserRole.wholesaler => {},
      _ => {},
    };
  }

  static bool canTransition({
    required UserRole role,
    required OrderStatus from,
    required OrderStatus to,
  }) => allowedFrom(role: role, current: from).contains(to);

  // ── Warehouse ──────────────────────────────────────────────
  static const _warehouse = <OrderStatus, Set<OrderStatus>>{
    OrderStatus.orderConfirmed: {OrderStatus.stockAllocated},
    OrderStatus.stockAllocated: {OrderStatus.picking, OrderStatus.backorder},
    OrderStatus.backorder: {OrderStatus.stockAllocated},
    OrderStatus.picking: {OrderStatus.packed},
    OrderStatus.packed: {OrderStatus.readyToShip},
  };

  // ── Carrier (déclenché par scan QR) ───────────────────────
  static const _carrier = <OrderStatus, Set<OrderStatus>>{
    OrderStatus.readyToShip: {OrderStatus.shipped},
    OrderStatus.shipped: {OrderStatus.partiallyShipped},
  };

  // ── Driver (déclenché par scan QR) ────────────────────────
  static const _driver = <OrderStatus, Set<OrderStatus>>{
    OrderStatus.shipped: {OrderStatus.delivered, OrderStatus.deliveryFailed},
    OrderStatus.partiallyDelivered: {
      OrderStatus.delivered,
      OrderStatus.deliveryFailed,
    },
    OrderStatus.deliveryFailed: {OrderStatus.shipped}, // nouvelle tentative
  };

  // ── Client ────────────────────────────────────────────────
  static const _client = <OrderStatus, Set<OrderStatus>>{
    OrderStatus.delivered: {OrderStatus.returnRequested},
    OrderStatus.partiallyDelivered: {OrderStatus.returnRequested},
    OrderStatus.shipped: {OrderStatus.exception},
  };
}

/// Matrice des transitions ShipmentStatus autorisées par UserRole.
abstract final class ShipmentTransitionPolicy {
  static Set<ShipmentStatus> allowedFrom({
    required UserRole role,
    required ShipmentStatus current,
  }) {
    if (role == UserRole.admin || role == UserRole.support) {
      return ShipmentStatus.values.where((s) => s != current).toSet();
    }
    return switch (role) {
      UserRole.carrier => _carrier[current] ?? {},
      UserRole.driver => _driver[current] ?? {},
      _ => {},
    };
  }

  static bool canTransition({
    required UserRole role,
    required ShipmentStatus from,
    required ShipmentStatus to,
  }) => allowedFrom(role: role, current: from).contains(to);

  // ── Carrier (scan à chaque hub) ───────────────────────────
  static const _carrier = <ShipmentStatus, Set<ShipmentStatus>>{
    ShipmentStatus.labelCreated: {ShipmentStatus.pickedUp},
    ShipmentStatus.pickedUp: {ShipmentStatus.inTransit},
    ShipmentStatus.inTransit: {
      ShipmentStatus.arrivedAtHub,
      ShipmentStatus.exception,
      ShipmentStatus.lost,
      ShipmentStatus.damaged,
    },
    ShipmentStatus.arrivedAtHub: {
      ShipmentStatus.customsClearance,
      ShipmentStatus.outForDelivery,
    },
    ShipmentStatus.customsClearance: {ShipmentStatus.outForDelivery},
  };

  // ── Driver (scan à la livraison) ──────────────────────────
  static const _driver = <ShipmentStatus, Set<ShipmentStatus>>{
    ShipmentStatus.outForDelivery: {
      ShipmentStatus.delivered,
      ShipmentStatus.deliveryFailed,
    },
    ShipmentStatus.deliveryFailed: {
      ShipmentStatus.outForDelivery,
      ShipmentStatus.returnToSender,
    },
  };
}
