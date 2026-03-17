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

  static OrderStatus fromJson(String? value) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => OrderStatus.created,
    );
  }

  String get label {
    switch (this) {
      case OrderStatus.created: return 'Créée';
      case OrderStatus.pendingPayment: return 'Paiement en attente';
      case OrderStatus.paid: return 'Payée';
      case OrderStatus.paymentFailed: return 'Échec du paiement';
      case OrderStatus.cancelRequested: return 'Annulation demandée';
      case OrderStatus.cancelled: return 'Annulée';
      case OrderStatus.orderConfirmed: return 'Confirmée';
      case OrderStatus.stockAllocated: return 'Stock alloué';
      case OrderStatus.backorder: return 'Reliquat';
      case OrderStatus.picking: return 'En préparation';
      case OrderStatus.packed: return 'Emballée';
      case OrderStatus.readyToShip: return 'Prête à expédier';
      case OrderStatus.partiallyShipped: return 'Partiellement expédiée';
      case OrderStatus.shipped: return 'Expédiée';
      case OrderStatus.partiallyDelivered: return 'Partiellement livrée';
      case OrderStatus.delivered: return 'Livrée';
      case OrderStatus.deliveryFailed: return 'Échec de livraison';
      case OrderStatus.exception: return 'Exception';
      case OrderStatus.returnRequested: return 'Retour demandé';
      case OrderStatus.returnInTransit: return 'Retour en transit';
      case OrderStatus.returnReceived: return 'Retour reçu';
      case OrderStatus.refundPending: return 'Remboursement en attente';
      case OrderStatus.refunded: return 'Remboursée';
      case OrderStatus.closed: return 'Clôturée';
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

  String get label {
    switch (this) {
      case ShipmentStatus.labelCreated: return 'Étiquette créée';
      case ShipmentStatus.pickedUp: return 'Récupérée';
      case ShipmentStatus.inTransit: return 'En transit';
      case ShipmentStatus.arrivedAtHub: return 'Arrivée au hub';
      case ShipmentStatus.customsClearance: return 'Dédouanement';
      case ShipmentStatus.outForDelivery: return 'En cours de livraison';
      case ShipmentStatus.delivered: return 'Livrée';
      case ShipmentStatus.deliveryFailed: return 'Échec de livraison';
      case ShipmentStatus.exception: return 'Exception';
      case ShipmentStatus.lost: return 'Perdue';
      case ShipmentStatus.damaged: return 'Endommagée';
      case ShipmentStatus.returnToSender: return 'Retour à l\'expéditeur';
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

  String get label {
    switch (this) {
      case ReturnStatus.requested: return 'Demandé';
      case ReturnStatus.authorized: return 'Autorisé';
      case ReturnStatus.labelIssued: return 'Étiquette émise';
      case ReturnStatus.inTransit: return 'En transit';
      case ReturnStatus.received: return 'Reçu';
      case ReturnStatus.rejected: return 'Refusé';
      case ReturnStatus.refundPending: return 'Remboursement en attente';
      case ReturnStatus.refunded: return 'Remboursé';
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

  static PaymentStatus fromJson(String? value) {
    return PaymentStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PaymentStatus.pending,
    );
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

  String get label {
    switch (this) {
      case UserRole.client: return 'Client';
      case UserRole.wholesaler: return 'Grossiste';
      case UserRole.warehouse: return 'Entrepôt';
      case UserRole.carrier: return 'Transporteur';
      case UserRole.driver: return 'Livreur';
      case UserRole.support: return 'Support';
      case UserRole.admin: return 'Admin';
    }
  }
}
