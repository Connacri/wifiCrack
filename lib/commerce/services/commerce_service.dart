import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cart_item.dart';
import '../models/cctv_order.dart';
import '../models/cctv_product.dart';

class CommerceService {
  final SupabaseClient _client;

  CommerceService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<CctvProduct>> fetchProducts({
    String? query,
    String? category,
    bool includeInactive = false,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      var builder = _client.from('cctv_products').select();

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
      return list.map(CctvProduct.fromMap).toList();
    } catch (e) {
      debugPrint('[Commerce] fetchProducts error: $e');
      rethrow;
    }
  }

  Future<CctvProduct?> createProduct(CctvProduct product) async {
    try {
      final res = await _client
          .from('cctv_products')
          .insert(product.toMap())
          .select()
          .maybeSingle();
      if (res == null) return null;
      return CctvProduct.fromMap(res);
    } catch (e) {
      debugPrint('[Commerce] createProduct error: $e');
      rethrow;
    }
  }

  Future<CctvProduct?> updateProduct(CctvProduct product) async {
    if (product.id.isEmpty) return null;
    try {
      final res = await _client
          .from('cctv_products')
          .update(product.toMap())
          .eq('id', product.id)
          .select()
          .maybeSingle();
      if (res == null) return null;
      return CctvProduct.fromMap(res);
    } catch (e) {
      debugPrint('[Commerce] updateProduct error: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    if (productId.isEmpty) return;
    try {
      await _client.from('cctv_products').delete().eq('id', productId);
    } catch (e) {
      debugPrint('[Commerce] deleteProduct error: $e');
      rethrow;
    }
  }

  Future<String?> createOrder({
    required String userId,
    required List<CartItem> items,
    required double total,
    required String phone,
    required String address,
    String? note,
  }) async {
    if (items.isEmpty) return null;
    try {
      final payload = <String, dynamic>{
        'user_id': userId,
        'phone': phone,
        'address': address,
        'note': note,
        'total': total,
        'status': 'pending',
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

      await _client.from('cctv_orders').insert(payload);
      return '';
    } catch (e) {
      debugPrint('[Commerce] createOrder error: $e');
      rethrow;
    }
  }

  Future<List<CctvOrder>> fetchOrders({
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final data = await _client
          .from('cctv_orders')
          .select()
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
      final list = List<Map<String, dynamic>>.from(data as List);
      return list.map(CctvOrder.fromMap).toList();
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
          .from('cctv_orders')
          .update({'status': status})
          .eq('id', orderId);
      return true;
    } catch (e) {
      debugPrint('[Commerce] updateOrderStatus error: $e');
      rethrow;
    }
  }
}
