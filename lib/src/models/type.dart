part of models;

final _description = <String, String>{
  'METAR': 'Meteorological Aerodrome Report',
  'SPECI': 'Special Aerodrome Report',
  'TAF': 'Terminal Aerodrome Forecast',
};

class Type {
  late String _code, _type;

  Type(String code) {
    _code = code;
    _type = _description[code]!;
  }

  @override
  String toString() {
    return '$type ($code)';
  }

  /// Returns the code of the type group.
  String get code => _code;

  /// Returns the type of the report.
  String get type => _type;
}
