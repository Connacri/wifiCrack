import '../../l10n/app_localizations.dart';

enum OrderStatus {
  created,
  pendingPayment,
  paid,
  paymentFailed,
  cancelRequested,
  cancelled,
  orderConfirmed,
  stockAllocated,
  backorder,
  picking,
  packed,
  readyToShip,
  partiallyShipped,
  shipped,
  partiallyDelivered,
  delivered,
  deliveryFailed,
  exception,
  returnRequested,
  returnInTransit,
  returnReceived,
  refundPending,
  refunded,
  closed;

  String toJson() => _toSnakeCase(name);

  static OrderStatus? tryParse(String? value) {
    if (value == null) return null;
    final normalized = _toCamelCase(value);
    try {
      return OrderStatus.values.firstWhere((e) => e.name == normalized);
    } catch (_) {
      try {
        return OrderStatus.values.firstWhere((e) => e.name == value);
      } catch (_) {
        return null;
      }
    }
  }

  static OrderStatus fromJson(String? value) {
    return tryParse(value) ?? OrderStatus.created;
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case OrderStatus.created:
        return l10n.orderStatusCreated;
      case OrderStatus.pendingPayment:
        return l10n.orderStatusPendingPayment;
      case OrderStatus.paid:
        return l10n.orderStatusPaid;
      case OrderStatus.paymentFailed:
        return l10n.orderStatusPaymentFailed;
      case OrderStatus.cancelRequested:
        return l10n.orderStatusCancelRequested;
      case OrderStatus.cancelled:
        return l10n.orderStatusCancelled;
      case OrderStatus.orderConfirmed:
        return l10n.orderStatusOrderConfirmed;
      case OrderStatus.stockAllocated:
        return l10n.orderStatusStockAllocated;
      case OrderStatus.backorder:
        return l10n.orderStatusBackorder;
      case OrderStatus.picking:
        return l10n.orderStatusPicking;
      case OrderStatus.packed:
        return l10n.orderStatusPacked;
      case OrderStatus.readyToShip:
        return l10n.orderStatusReadyToShip;
      case OrderStatus.partiallyShipped:
        return l10n.orderStatusPartiallyShipped;
      case OrderStatus.shipped:
        return l10n.orderStatusShipped;
      case OrderStatus.partiallyDelivered:
        return l10n.orderStatusPartiallyDelivered;
      case OrderStatus.delivered:
        return l10n.orderStatusDelivered;
      case OrderStatus.deliveryFailed:
        return l10n.orderStatusDeliveryFailed;
      case OrderStatus.exception:
        return l10n.orderStatusException;
      case OrderStatus.returnRequested:
        return l10n.orderStatusReturnRequested;
      case OrderStatus.returnInTransit:
        return l10n.orderStatusReturnInTransit;
      case OrderStatus.returnReceived:
        return l10n.orderStatusReturnReceived;
      case OrderStatus.refundPending:
        return l10n.orderStatusRefundPending;
      case OrderStatus.refunded:
        return l10n.orderStatusRefunded;
      case OrderStatus.closed:
        return l10n.orderStatusClosed;
    }
  }
}

enum ShipmentStatus {
  labelCreated,
  pickedUp,
  inTransit,
  arrivedAtHub,
  customsClearance,
  outForDelivery,
  delivered,
  deliveryFailed,
  exception,
  lost,
  damaged,
  returnToSender;

  String toJson() => _toSnakeCase(name);

  static ShipmentStatus fromJson(String? value) {
    if (value == null) return ShipmentStatus.labelCreated;
    final normalized = _toCamelCase(value);
    try {
      return ShipmentStatus.values.firstWhere((e) => e.name == normalized);
    } catch (_) {
      try {
        return ShipmentStatus.values.firstWhere((e) => e.name == value);
      } catch (_) {
        return ShipmentStatus.labelCreated;
      }
    }
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case ShipmentStatus.labelCreated:
        return l10n.shipmentStatusLabelCreated;
      case ShipmentStatus.pickedUp:
        return l10n.shipmentStatusPickedUp;
      case ShipmentStatus.inTransit:
        return l10n.shipmentStatusInTransit;
      case ShipmentStatus.arrivedAtHub:
        return l10n.shipmentStatusArrivedAtHub;
      case ShipmentStatus.customsClearance:
        return l10n.shipmentStatusCustomsClearance;
      case ShipmentStatus.outForDelivery:
        return l10n.shipmentStatusOutForDelivery;
      case ShipmentStatus.delivered:
        return l10n.shipmentStatusDelivered;
      case ShipmentStatus.deliveryFailed:
        return l10n.shipmentStatusDeliveryFailed;
      case ShipmentStatus.exception:
        return l10n.shipmentStatusException;
      case ShipmentStatus.lost:
        return l10n.shipmentStatusLost;
      case ShipmentStatus.damaged:
        return l10n.shipmentStatusDamaged;
      case ShipmentStatus.returnToSender:
        return l10n.shipmentStatusReturnToSender;
    }
  }
}

enum ReturnStatus {
  requested,
  authorized,
  labelIssued,
  inTransit,
  received,
  rejected,
  refundPending,
  refunded;

  String toJson() => _toSnakeCase(name);

  static ReturnStatus fromJson(String? value) {
    if (value == null) return ReturnStatus.requested;
    final normalized = _toCamelCase(value);
    try {
      return ReturnStatus.values.firstWhere((e) => e.name == normalized);
    } catch (_) {
      return ReturnStatus.requested;
    }
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case ReturnStatus.requested:
        return l10n.returnStatusRequested;
      case ReturnStatus.authorized:
        return l10n.returnStatusAuthorized;
      case ReturnStatus.labelIssued:
        return l10n.returnStatusLabelIssued;
      case ReturnStatus.inTransit:
        return l10n.returnStatusInTransit;
      case ReturnStatus.received:
        return l10n.returnStatusReceived;
      case ReturnStatus.rejected:
        return l10n.returnStatusRejected;
      case ReturnStatus.refundPending:
        return l10n.returnStatusRefundPending;
      case ReturnStatus.refunded:
        return l10n.returnStatusRefunded;
    }
  }
}

enum PaymentStatus {
  pending,
  authorized,
  captured,
  voided,
  refunded,
  failed;

  String toJson() => _toSnakeCase(name);

  static PaymentStatus? tryParse(String? value) {
    if (value == null) return null;
    final normalized = _toCamelCase(value);
    try {
      return PaymentStatus.values.firstWhere((e) => e.name == normalized);
    } catch (_) {
      return null;
    }
  }

  static PaymentStatus fromJson(String? value) {
    return tryParse(value) ?? PaymentStatus.pending;
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case PaymentStatus.pending:
        return l10n.paymentStatusPending;
      case PaymentStatus.authorized:
        return l10n.paymentStatusAuthorized;
      case PaymentStatus.captured:
        return l10n.paymentStatusCaptured;
      case PaymentStatus.voided:
        return l10n.paymentStatusVoided;
      case PaymentStatus.refunded:
        return l10n.paymentStatusRefunded;
      case PaymentStatus.failed:
        return l10n.paymentStatusFailed;
    }
  }
}

enum UserRole {
  client,
  wholesaler,
  warehouse,
  carrier,
  driver,
  support,
  admin;

  String label(AppLocalizations l10n) {
    switch (this) {
      case UserRole.client:
        return l10n.client;
      case UserRole.wholesaler:
        return l10n.wholesaler;
      case UserRole.warehouse:
        return l10n.warehouseRole;
      case UserRole.carrier:
        return l10n.carrierRole;
      case UserRole.driver:
        return l10n.deliveryPerson;
      case UserRole.support:
        return l10n.supportRole;
      case UserRole.admin:
        return l10n.admin;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS CASSE
// ─────────────────────────────────────────────────────────────────────────────

String _toSnakeCase(String name) {
  return name.replaceAllMapped(
    RegExp(r'([A-Z])'),
    (match) => '_${match.group(1)!.toLowerCase()}',
  );
}

String _toCamelCase(String snake) {
  final parts = snake.split('_');
  if (parts.length == 1) return snake;
  return parts[0] +
      parts.sublist(1).map((p) => p[0].toUpperCase() + p.substring(1)).join('');
}

// ─────────────────────────────────────────────────────────────────────────────
// MATRICE DES TRANSITIONS — SOURCE UNIQUE DE VÉRITÉ
// Utilisée par CommerceProvider (allowedOrderTransitions / allowedShipmentTransitions)
// ─────────────────────────────────────────────────────────────────────────────

class OrderTransitionPolicy {
  OrderTransitionPolicy._();

  static Set<OrderStatus> allowedTransitions({
    required UserRole role,
    required OrderStatus current,
  }) {
    switch (role) {
      case UserRole.admin:
      case UserRole.support:
        return OrderStatus.values.where((s) => s != current).toSet();
      case UserRole.wholesaler:
        return _wholesalerTransitions[current] ?? {};
      case UserRole.warehouse:
        return _warehouseTransitions[current] ?? {};
      case UserRole.carrier:
        return _carrierTransitions[current] ?? {};
      case UserRole.driver:
        return _driverTransitions[current] ?? {};
      case UserRole.client:
        return _clientTransitions[current] ?? {};
    }
  }

  static bool canTransition({
    required UserRole role,
    required OrderStatus from,
    required OrderStatus to,
  }) {
    return allowedTransitions(role: role, current: from).contains(to);
  }

  // ── Grossiste ──────────────────────────────────────────────────────────────
  static const _wholesalerTransitions = <OrderStatus, Set<OrderStatus>>{
    OrderStatus.created: {OrderStatus.orderConfirmed, OrderStatus.cancelled},
    OrderStatus.orderConfirmed: {
      OrderStatus.stockAllocated,
      OrderStatus.cancelled,
    },
    // Le grossiste peut aussi annuler une demande d'annulation client
    OrderStatus.cancelRequested: {OrderStatus.cancelled},
  };

  // ── Entrepôt ───────────────────────────────────────────────────────────────
  // FIX : ajout de backorder → stockAllocated (manquait — entrepôt bloqué en rupture)
  static const _warehouseTransitions = <OrderStatus, Set<OrderStatus>>{
    OrderStatus.orderConfirmed: {OrderStatus.stockAllocated},
    OrderStatus.stockAllocated: {OrderStatus.picking, OrderStatus.backorder},
    // ↓ CRITIQUE : sans cette ligne, l'entrepôt ne pouvait plus reprendre
    //   un article mis en rupture une fois le stock reconstitué
    OrderStatus.backorder: {OrderStatus.stockAllocated},
    OrderStatus.picking: {OrderStatus.packed},
    OrderStatus.packed: {OrderStatus.readyToShip},
  };

  // ── Transporteur ───────────────────────────────────────────────────────────
  static const _carrierTransitions = <OrderStatus, Set<OrderStatus>>{
    OrderStatus.readyToShip: {OrderStatus.shipped},
    OrderStatus.shipped: {OrderStatus.partiallyShipped},
  };

  // ── Livreur ────────────────────────────────────────────────────────────────
  static const _driverTransitions = <OrderStatus, Set<OrderStatus>>{
    OrderStatus.shipped: {OrderStatus.delivered, OrderStatus.deliveryFailed},
    OrderStatus.partiallyDelivered: {
      OrderStatus.delivered,
      OrderStatus.deliveryFailed,
    },
    OrderStatus.deliveryFailed: {OrderStatus.shipped}, // nouvelle tentative
  };

  // ── Client ─────────────────────────────────────────────────────────────────
  static const _clientTransitions = <OrderStatus, Set<OrderStatus>>{
    OrderStatus.delivered: {OrderStatus.returnRequested},
    OrderStatus.partiallyDelivered: {OrderStatus.returnRequested},
    OrderStatus.shipped: {OrderStatus.exception},
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// MATRICE DES TRANSITIONS EXPÉDITION
// ─────────────────────────────────────────────────────────────────────────────

class ShipmentTransitionPolicy {
  ShipmentTransitionPolicy._();

  static Set<ShipmentStatus> allowedTransitions({
    required UserRole role,
    required ShipmentStatus current,
  }) {
    switch (role) {
      case UserRole.admin:
      case UserRole.support:
        return ShipmentStatus.values.where((s) => s != current).toSet();
      case UserRole.carrier:
        return _carrierShipmentTransitions[current] ?? {};
      case UserRole.driver:
        return _driverShipmentTransitions[current] ?? {};
      case UserRole.client:
      case UserRole.warehouse:
      case UserRole.wholesaler:
        return {};
    }
  }

  static bool canTransition({
    required UserRole role,
    required ShipmentStatus from,
    required ShipmentStatus to,
  }) {
    return allowedTransitions(role: role, current: from).contains(to);
  }

  // ── Transporteur (scan à chaque hub) ──────────────────────────────────────
  static const _carrierShipmentTransitions =
      <ShipmentStatus, Set<ShipmentStatus>>{
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

  // ── Livreur (scan à la livraison) ─────────────────────────────────────────
  static const _driverShipmentTransitions =
      <ShipmentStatus, Set<ShipmentStatus>>{
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
