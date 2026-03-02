class WiFiKeyCalculator {
  static const Map<String, String> _mapping = {
    '0': 'f', 'f': '0',
    '1': 'e', 'e': '1',
    '2': 'd', 'd': '2',
    '3': 'c', 'c': '3',
    '4': 'b', 'b': '4',
    '5': 'a', 'a': '5',
    '6': '9', '9': '6',
    '7': '8', '8': '7',
  };

  static bool isTargetSSID(String ssid) {
    return ssid.toLowerCase().contains('fh_');
  }

  static String? calculate(String ssid) {
    if (!isTargetSSID(ssid)) return null;

    // Normalisation : on retire les suffixes courants comme _5G ou _2G
    String normalizedSsid = ssid.toLowerCase().replaceAll(RegExp(r'_(5g|2g)$'), '');

    final parts = normalizedSsid.split('fh_');
    if (parts.length < 2) return null;

    final hexPart = parts[1].trim();
    if (hexPart.isEmpty) return null;

    final buffer = StringBuffer('wlan');
    for (int i = 0; i < hexPart.length; i++) {
      final char = hexPart[i];
      buffer.write(_mapping[char] ?? char);
    }
    return buffer.toString();
  }
}
