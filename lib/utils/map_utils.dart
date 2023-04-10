class MapUtils {
  static Map<String, dynamic> filterNullValues(Map<String, dynamic> map) {
    return map..removeWhere((_, value) => value == null);
  }

  static Map<String, String> convertToStringMap(Map<String, dynamic> map) =>
      Map<String, String>.fromEntries(map.entries
          .map((entry) => MapEntry(entry.key, entry.value?.toString() ?? "")));
}
