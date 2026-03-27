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

  String toJson() => name;

  static OrderStatus? tryParse(String? value) {
    if (value == null) return null;
    try {
      return OrderStatus.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
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

  String toJson() => name;

  static ShipmentStatus fromJson(String? value) {
    return ShipmentStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ShipmentStatus.labelCreated,
    );
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

  String toJson() => name;

  static ReturnStatus fromJson(String? value) {
    return ReturnStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ReturnStatus.requested,
    );
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

  String toJson() => name;

  static PaymentStatus? tryParse(String? value) {
    if (value == null) return null;
    try {
      return PaymentStatus.values.firstWhere((e) => e.name == value);
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
