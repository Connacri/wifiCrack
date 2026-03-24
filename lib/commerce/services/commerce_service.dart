import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../commerce_config.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/commerce_enums.dart';
import '../models/shipment.dart';

class CommerceService {
  final SupabaseClient _client;

  CommerceService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<Product>> fetchProducts({
    String? query,
    String? category,
    bool includeInactive = false,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      final table = CommerceConfig.productsTable;
      var builder = _client.from(table).select();

      if (!includeInactive) {
        builder = builder.eq('is_active', true);
      }

      if (category != null && category.trim().isNotEmpty) {
        builder = builder.eq('category', category.trim());
      }

      if (query != null && query.trim().isNotEmpty) {
        final q = query.trim();
        builder = builder.or(
          'name.ilike.%$q%,description.ilike.%$q%,sku.ilike.%$q%',
        );
      }

      final data = await builder
          .order('name')
          .range(offset, offset + limit - 1);
      final list = List<Map<String, dynamic>>.from(data as List);
      return list.map(Product.fromMap).toList();
    } catch (e) {
      debugPrint('[Commerce] fetchProducts error: $e');
      rethrow;
    }
  }

  /// Écoute les changements en temps réel sur la table des produits
  Stream<List<Map<String, dynamic>>> watchProductsStream() {
    return _client
        .from(CommerceConfig.productsTable)
        .stream(primaryKey: ['id'])
        .order('name');
  }

  Future<Product?> createProduct(Product product) async {
    try {
      final res = await _client
          .from(CommerceConfig.productsTable)
          .insert(product.toMap())
          .select()
          .maybeSingle();
      if (res == null) return null;
      return Product.fromMap(res);
    } catch (e) {
      debugPrint('[Commerce] createProduct error: $e');
      rethrow;
    }
  }

  Future<Product?> updateProduct(Product product) async {
    if (product.id.isEmpty) return null;
    try {
      final res = await _client
          .from(CommerceConfig.productsTable)
          .update(product.toMap())
          .eq('id', product.id)
          .select()
          .maybeSingle();
      if (res == null) return null;
      return Product.fromMap(res);
    } catch (e) {
      debugPrint('[Commerce] updateProduct error: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    if (productId.isEmpty) return;
    try {
      // 1. Fetch product to get image path
      final productRes = await _client
          .from(CommerceConfig.productsTable)
          .select('image_url')
          .eq('id', productId)
          .maybeSingle();
      
      final imageUrl = productRes?['image_url']?.toString();

      // 2. Delete product from database
      await _client
          .from(CommerceConfig.productsTable)
          .delete()
          .eq('id', productId);

      // 3. Delete image from storage if it belongs to our bucket
      if (imageUrl != null && imageUrl.isNotEmpty) {
        await deleteImage(imageUrl);
      }
    } catch (e) {
      debugPrint('[Commerce] deleteProduct error: $e');
      rethrow;
    }
  }

  Future<void> deleteImage(String path) async {
    if (path.isEmpty) return;
    // Only delete if it's a relative path (not an external URL)
    if (path.startsWith('http://') || path.startsWith('https://')) return;
    
    try {
      final bucket = CommerceConfig.supabaseImagesBucket.trim();
      if (bucket.isEmpty) return;
      
      await _client.storage.from(bucket).remove([path]);
      debugPrint('[Commerce] Image deleted: $path');
    } catch (e) {
      debugPrint('[Commerce] deleteImage error: $e');
      // We don't rethrow here to avoid failing the whole operation if image delete fails
    }
  }

  Future<String?> createOrder({
    required String userId,
    required List<CartItem> items,
    required double total,
    required String phone,
    required String address,
    String? note,
    String? clientName,
  }) async {
    if (items.isEmpty) return null;
    try {
      final payload = <String, dynamic>{
        'buyer_id': userId,
        'order_number': 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        'note': note,
        'phone': phone,
        'address': address,
        'grand_total': total,
        'status': 'created',
        'client_name': clientName,
        'items': items
            .map(
              (item) => {
                'product_id': item.product.id,
                'name': item.product.name,
                'price': item.product.effectivePrice,
                'quantity': item.quantity,
                'subtotal': item.subtotal,
              },
            )
            .toList(),
      };

      final res = await _client.from('orders').insert(payload).select('id').single();
      final id = res['id']?.toString();
      if (id == null) throw Exception("L'ordre a été créé mais l'ID n'a pas été retourné.");
      return id;
    } catch (e) {
      debugPrint('[Commerce] createOrder error: $e');
      rethrow;
    }
  }

  Future<List<Order>> fetchOrders({
    String? userId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      var builder = _client.from('orders').select();

      if (userId != null && userId.trim().isNotEmpty) {
        builder = builder.eq('buyer_id', userId.trim());
      }

      final data = await builder
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
      final list = List<Map<String, dynamic>>.from(data as List);
      return list.map(Order.fromMap).toList();
    } catch (e) {
      debugPrint('[Commerce] fetchOrders error: $e');
      rethrow;
    }
  }

  Future<bool> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    if (orderId.trim().isEmpty) return false;
    try {
      await _client
          .from('orders')
          .update({'status': status})
          .eq('id', orderId);
      return true;
    } catch (e) {
      debugPrint('[Commerce] updateOrderStatus error: $e');
      rethrow;
    }
  }

  Future<Shipment?> createShipment({
    required String orderId,
    required String trackingNumber,
    required String carrierName,
    required List<OrderItem> items,
  }) async {
    try {
      final payload = {
        'order_id': orderId,
        'tracking_number': trackingNumber,
        'carrier_name': carrierName,
        'status': ShipmentStatus.labelCreated.toJson(),
        'items': items.map((i) => {
          'product_id': i.productId,
          'name': i.name,
          'price': i.price,
          'quantity': i.quantity,
          'subtotal': i.subtotal,
        }).toList(),
        'shipped_at': DateTime.now().toIso8601String(),
      };

      final res = await _client
          .from('shipments')
          .insert(payload)
          .select()
          .maybeSingle();
      
      if (res == null) return null;
      return Shipment.fromMap(res);
    } catch (e) {
      debugPrint('[Commerce] createShipment error: $e');
      rethrow;
    }
  }

  Future<bool> updateShipmentStatus({
    required String shipmentId,
    required String status,
  }) async {
    try {
      final payload = <String, dynamic>{'status': status};
      if (status == ShipmentStatus.delivered.toJson()) {
        payload['actual_delivery'] = DateTime.now().toIso8601String();
      }
      await _client.from('shipments').update(payload).eq('id', shipmentId);
      return true;
    } catch (e) {
      debugPrint('[Commerce] updateShipmentStatus error: $e');
      rethrow;
    }
  }
}
