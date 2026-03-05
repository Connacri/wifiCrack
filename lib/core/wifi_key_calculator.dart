/// Obfuscated WiFiKeyCalculator for Fiber networks.
/// Utilise une indirection par index pour "cacher" la logique en cas de reverse engineering simple.
class WiFiKeyCalculator {
  // Mapping obfusqué via des constantes décalées ou réordonnées
  static const String _m = 'fedcba9876543210';
  static const String _r = '0123456789abcdef';

  static bool isTargetSSID(String s) {
    final l = s.toLowerCase();
    return l.contains('fh_') || l.contains('fiber_');
  }

  static String? calculate(String s) {
    if (!isTargetSSID(s)) return null;

    // Normalisation avancée
    String ns = s.toLowerCase()
        .replaceAll(RegExp(r'_(5g|2g|ghz)$'), '')
        .trim();

    final parts = ns.split('_');
    if (parts.length < 2) return null;

    // Extraction de la partie hexadécimale (souvent la dernière partie après le FH_)
    final hex = parts.last;
    if (hex.length < 4) return null;

    final buf = StringBuffer('wlan');
    for (int i = 0; i < hex.length; i++) {
      final char = hex[i];
      final idx = _r.indexOf(char);
      
      if (idx != -1) {
        // Logique miroir : On récupère le caractère opposé dans l'hexadécimal
        buf.write(_m[idx]);
      } else {
        buf.write(char);
      }
    }
    return buf.toString();
  }
}
