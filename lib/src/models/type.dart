part of models;

final _description = <String, String>{
  'METAR': 'Meteorological Aerodrome Report',
  'SPECI': 'Special Aerodrome Report',
  'TAF': 'Terminal Aerodrome Forecast',
};

class Type extends Group {
  late String _type;

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
