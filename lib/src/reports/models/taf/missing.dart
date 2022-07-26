part of reports;

/// Basic structure for missing TAF.
class Missing extends Modifier {
  bool _missing = false;

  Missing(String? code) : super(code) {
    if (code != null) {
      _missing = true;
    }
  }

  /// Get if the TAF is missing.
  bool get isMissing => _missing;

  @override
  Map<String, Object?> asMap() {
    final map = <String, Object?>{
      'is_missing': isMissing,
    };
    map.addAll(super.asMap());
    return map;
  }
}
