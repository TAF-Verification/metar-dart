part of models;

final Map<String, String> TYPES = <String, String>{
  'METAR': 'Meteorological Aerodrome Report',
  'SPECI': 'Special Aerodrome Report',
  'TAF': 'Terminal Aerodrome Forecast',
};

class Type extends Group {
  late final String _type;

  Type(String code) : super(code) {
    _type = TYPES[code]!;
  }

  @override
  String toString() {
    return '$_type ($_code)';
  }

  /// Get the type of the report.
  String get type => _type;

  @override
  Map<String, String?> toMap() {
    final map = super.toMap();
    map.addAll({'type': type});
    return map.cast<String, String?>();
  }
}
