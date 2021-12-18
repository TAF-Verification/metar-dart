part of models;

final _description = <String, String>{
  'METAR': 'Meteorological Aerodrome Report',
  'SPECI': 'Special Aerodrome Report',
  'TAF': 'Terminal Aerodrome Forecast',
};

/// Basic structure for type groups in reports from land stations.
class Type extends Group {
  late final String _type;

  Type(String code) : super(code) {
    _type = _description[code]!;
  }

  @override
  String toString() {
    return '$type ($code)';
  }

  /// Get the type of the report.
  String get type => _type;
}
