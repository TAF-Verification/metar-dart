part of reports;

final NAMES = <String, String>{
  'R': 'right',
  'L': 'left',
  'C': 'center',
};

final RVR_LIMITS = <String, String>{
  'M': 'below of',
  'P': 'above of',
};

final TRENDS = <String, String>{
  'N': 'no change',
  'U': 'increasing',
  'D': 'decreasing',
};

/// Helper to set the name of the runway.
String? setRunwayName(String? code) {
  if (code == null) {
    return null;
  }

  if (code.length == 3) {
    final nameChar = code[2];
    final nameStr = NAMES[nameChar];
    return code.replaceFirst(nameChar, ' $nameStr');
  }

  if (code == '88') {
    return 'all runways';
  }

  if (code == '99') {
    return 'repeated';
  }

  return code;
}

///Basic structure of a groups list from groups found in a aeronautical
/// report from land stations.
class MetarRunwayRange extends Group {
  String? _name;
  String? _rvrLow;
  Distance _lowRange = Distance(null);
  String? _rvrHigh;
  Distance _highRange = Distance(null);
  String? _trend;

  MetarRunwayRange(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      _rvrLow = RVR_LIMITS[match.namedGroup('rvrlow')];
      _rvrHigh = RVR_LIMITS[match.namedGroup('rvrhigh')];
      _trend = TRENDS[match.namedGroup('trend')];

      final _units = match.namedGroup('units');
      final lowRange = match.namedGroup('low');
      final highRange = match.namedGroup('high');

      _name = setRunwayName(match.namedGroup('name')!);
      _lowRange = _setRange(lowRange, _units);
      _highRange = _setRange(highRange, _units);
    }
  }

  @override
  String toString() {
    if (_lowRange.value == null) return '';

    return 'runway $_name '
        '$lowRange'
        '${_highRange.value != null ? " varying to $highRange" : ""}'
        '${_trend != null ? ", $_trend" : ""}';
  }

  /// Helper to set the visual range of the runway.
  Distance _setRange(String? code, String? units) {
    if (code == null) {
      return Distance(null);
    }

    if (units == 'FT') {
      var _range = double.parse(code);
      _range = _range * Conversions.FT_TO_M;
      return Distance('$_range');
    }

    return Distance(code);
  }

  /// Helper to represent the visual range as a String.
  String _rangeToString(Distance range, String? rvr) {
    if (range.value == null) {
      return '';
    }

    if (rvr != null) {
      return '$rvr $range';
    }

    return '$range';
  }

  /// Get the runway name.
  String? get name => _name;

  /// Get the runway low range as a String.
  String get lowRange => _rangeToString(_lowRange, _rvrLow);

  /// Get the runway low range in meters.
  double? get lowInMeters => _lowRange.inMeters;

  /// Get the runway low range in kilometers.
  double? get lowInKilometers => _lowRange.inKilometers;

  /// Get the runway low range in sea miles.
  double? get lowInSeaMiles => _lowRange.inSeaMiles;

  /// Get the runway low range in feet.
  double? get lowInFeet => _lowRange.inFeet;

  /// Get the runway high range as a String.
  String get highRange => _rangeToString(_highRange, _rvrHigh);

  /// Get the runway high range in meters.
  double? get highInMeters => _highRange.inMeters;

  /// Get the runway high range in kilometers.
  double? get highInKilometers => _highRange.inKilometers;

  /// Get the runway high range in sea miles.
  double? get highInSeaMiles => _highRange.inSeaMiles;

  /// Get the runway high range in feet.
  double? get highInFeet => _highRange.inFeet;

  /// Get the runway range trend.
  String? get trend => _trend;

  @override
  Map<String, Object?> asMap() {
    final map = {
      'name': name,
      'rvr_low': _rvrLow,
      'low_range': _lowRange.asMap(),
      'rvr_high': _rvrHigh,
      'high_range': _highRange.asMap(),
      'trend': trend,
    };
    map.addAll(super.asMap());
    return map;
  }
}
