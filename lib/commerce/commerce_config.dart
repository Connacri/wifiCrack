import 'package:supabase_flutter/supabase_flutter.dart';

class CommerceConfig {
  // Supabase Storage bucket for product images.
  // Override with: --dart-define=SUPABASE_IMAGES_BUCKET=...
  static const String supabaseImagesBucket = String.fromEnvironment(
    'SUPABASE_IMAGES_BUCKET',
    defaultValue: 'cctv-images',
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
    final path = rawPath.startsWith('/') ? rawPath.substring(1) : rawPath;
    final prefix = _trimSlashes(supabaseImagesPrefix.trim());
    return prefix.isEmpty ? path : '$prefix/$path';
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
