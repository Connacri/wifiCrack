import 'package:flutter/foundation.dart';

import '../data/sources/supabase_service.dart';

class CommerceConfig {
  // Supabase table for products.
  // Override with: --dart-define=SUPABASE_PRODUCTS_TABLE=...
  static const String productsTable = String.fromEnvironment(
    'SUPABASE_PRODUCTS_TABLE',
    defaultValue: 'products',
  );

  // Supabase Storage bucket for product images.
  // Override with: --dart-define=SUPABASE_IMAGES_BUCKET=...
  static const String supabaseImagesBucket = String.fromEnvironment(
    'SUPABASE_IMAGES_BUCKET',
    defaultValue: 'product-images',
  );

  // Optional folder prefix inside the bucket (e.g. "products").
  // Override with: --dart-define=SUPABASE_IMAGES_PREFIX=...
  static const String supabaseImagesPrefix = String.fromEnvironment(
    'SUPABASE_IMAGES_PREFIX',
    defaultValue: '',
  );

  static String? resolveImageUrl(String? raw) {
    if (raw == null) return null;
    final value = raw.trim();
    if (value.isEmpty) return null;
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    if (supabaseImagesBucket.trim().isEmpty) {
      return null;
    }

    final fullPath = buildStoragePath(value);
    final baseUrl = SupabaseService.storageBaseUrl;
    final publicUrl =
        '$baseUrl/object/public/$supabaseImagesBucket/$fullPath';
    // Debug helper to verify path resolution during development.
    debugPrint(
      '[Commerce] resolveImageUrl: raw="$raw" -> fullPath="$fullPath" -> url="$publicUrl"',
    );
    return publicUrl;
  }

  static String buildStoragePath(String rawPath) {
    var path = rawPath.trim();
    if (path.isEmpty) return path;
    if (path.startsWith('/')) path = path.substring(1);
    final queryIndex = path.indexOf('?');
    if (queryIndex != -1) {
      path = path.substring(0, queryIndex);
    }
    final hashIndex = path.indexOf('#');
    if (hashIndex != -1) {
      path = path.substring(0, hashIndex);
    }

    final bucket = _trimSlashes(supabaseImagesBucket.trim());
    if (bucket.isNotEmpty) {
      if (path.startsWith('$bucket/')) {
        path = path.substring(bucket.length + 1);
      } else if (path.startsWith('public/$bucket/')) {
        path = path.substring('public/'.length + bucket.length + 1);
      } else if (path.startsWith('sign/$bucket/')) {
        path = path.substring('sign/'.length + bucket.length + 1);
      }
    }
    final prefix = _trimSlashes(supabaseImagesPrefix.trim());
    if (prefix.isEmpty) return path;
    if (path.isEmpty) return prefix;
    if (path.startsWith('$prefix/')) return path;
    return '$prefix/$path';
  }

  static String _trimSlashes(String value) {
    var trimmed = value;
    while (trimmed.startsWith('/')) {
      trimmed = trimmed.substring(1);
    }
    while (trimmed.endsWith('/')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }
}
