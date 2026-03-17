import 'package:supabase_flutter/supabase_flutter.dart';

class CommerceConfig {
  // Supabase table for products.
  // Override with: --dart-define=SUPABASE_PRODUCTS_TABLE=...
  static const String productsTable = String.fromEnvironment(
    'SUPABASE_PRODUCTS_TABLE',
    defaultValue: 'cctv_products',
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

    return Supabase.instance.client.storage
        .from(supabaseImagesBucket)
        .getPublicUrl(fullPath);
  }

  static String buildStoragePath(String rawPath) {
    var path = rawPath.startsWith('/') ? rawPath.substring(1) : rawPath;
    path = path.trim();
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
