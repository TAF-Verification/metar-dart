part of models;

final COMPASS_DIRS = {
  'NNE': [11.25, 33.75],
  'NE': [33.75, 56.25],
  'ENE': [56.25, 78.75],
  'E': [78.75, 101.25],
  'ESE': [101.25, 123.75],
  'SE': [123.75, 146.25],
  'SSE': [146.25, 168.75],
  'S': [168.75, 191.25],
  'SSW': [191.25, 213.75],
  'SW': [213.75, 236.25],
  'WSW': [236.25, 258.75],
  'W': [258.75, 281.25],
  'WNW': [281.25, 303.75],
  'NW': [303.75, 326.25],
  'NNW': [326.25, 348.75],
  'N': [348.75, 11.25],
};

class Wind extends Group {
  Direction _direction = Direction(null);
  Speed _speed = Speed(null);
  Speed _gust = Speed(null);

  Wind(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      _direction = Direction(match.namedGroup('dir'));
      final units = match.namedGroup('units');

      if (units == 'KT') {
        _speed = Speed(match.namedGroup('speed'));
        _gust = Speed(match.namedGroup('gust'));
      }

      if (units == 'MPS') {
        var speed = match.namedGroup('speed');
        var gust = match.namedGroup('gust');

        speed = _speedInMpsToKt(speed.toString());
        gust = _speedInMpsToKt(gust.toString());

        _speed = Speed(speed);
        _gust = Speed(gust);
      }
    }
  }

  @override
  String toString() {
    final cardinal = cardinalDirection ?? '';

    var direction = _direction.toString();
    direction = _direction.value != null ? '($_direction)' : direction;

    final gust = _gust.value != null ? 'gust of $_gust' : '';

    var s = '$cardinal $direction $_speed $gust';
    s = s.replaceAll(RegExp(r'\s{2,}'), ' ');
    s = s.trim();

    return s;
  }

  /// Helper to convert wind speed in meters per second to knots.
  String _speedInMpsToKt(String value) {
    final valueFloat = double.tryParse(value);

    if (valueFloat == null) {
      return '///';
    }

    final valueIntAsString = valueFloat.toStringAsFixed(0).padLeft(3, '0');

    return valueIntAsString;
  }

  /// Get the cardinal direction associated to the wind direction.
  String? get cardinalDirection => _direction.cardinal;

  /// Get if the wind direction is variable in report.
  bool get variable => _direction.variable;

  /// Get the wind direction in degrees.
  double? get directionInDegrees => _direction.value;

  /// Get the wind direction in radians.
  double? get directionInRadians =>
      _direction.converted(conversionDouble: Conversions.DEGREES_TO_RADIANS);

  /// Get the wind direction in gradians.
  double? get directionInGradians =>
      _direction.converted(conversionDouble: Conversions.DEGREES_TO_RADIANS);

  /// Get the wind speed in knots.
  double? get speedInKnot => _speed.value;

  /// Get the wind speed in meters per second.
  double? get speedInMps =>
      _speed.converted(conversionDouble: Conversions.KNOT_TO_MPS);

  /// Get the wind speed in kilometers per hour.
  double? get speedInKph =>
      _speed.converted(conversionDouble: Conversions.KNOT_TO_KPH);

  /// Get the wind speed in miles per hour.
  double? get speedInMiph =>
      _speed.converted(conversionDouble: Conversions.KNOT_TO_MIPH);

  /// Get the wind gusts in knots.
  double? get gustInKnot => _gust.value;

  /// Get the wind gusts in meters per second.
  double? get gustInMps =>
      _gust.converted(conversionDouble: Conversions.KNOT_TO_MPS);

  /// Get the wind gusts in kilometers per hour.
  double? get gustInKph =>
      _gust.converted(conversionDouble: Conversions.KNOT_TO_KPH);

  // Get the wind gusts in miles per hour.
  double? get gustInMiph =>
      _gust.converted(conversionDouble: Conversions.KNOT_TO_MIPH);
}

class Direction extends Numeric {
  late final bool _variable;

  Direction(String? code) : super(null) {
    code ??= '///';

    if (code.length == 2) {
      code = code + '0';
    }

    assert(
        code.length == 3, 'wind direction code must have 3 or 2 digits length');

    late double? _direction;
    try {
      _direction = double.parse(code);
      _variable = false;
    } catch (e) {
      if (code == 'VRB') {
        _variable = true;
      } else {
        _variable = false;
      }
      _direction = null;
    } finally {
      _value = _direction;
    }
  }

  factory Direction.fromCardinal(String code) {
    if (code == 'N') {
      return Direction('360');
    }

    final keys = COMPASS_DIRS.keys;
    for (var key in keys) {
      if (key == code) {
        final dirs = COMPASS_DIRS[key];
        final meanDir = dirs!.reduce((a, b) => a + b) / 2;
        final strDir = '${meanDir.toInt()}'.padLeft(3, '0');
        return Direction(strDir);
      }
    }

    throw AssertionError(
        'invalid cardinal direction code, use one of the following: ${COMPASS_DIRS.keys}');
  }

  @override
  String toString() {
    if (_variable) {
      return 'variable wind';
    }

    if (_value != null) {
      return '${super.toString()}°';
    }

    return super.toString();
  }

  /// Get the cardinal direction associated to the wind direction.
  /// e.g. "NW" (north west).
  String? get cardinal {
    String? _cardinal;
    final value = converted(conversionDouble: 1);

    if (value != null) {
      final northDirs = COMPASS_DIRS['N'];

      if (value >= northDirs![0] || value < northDirs[1]) {
        _cardinal = 'N';
      }

      COMPASS_DIRS.forEach((k, v) {
        if (value >= v[0] && value < v[1]) {
          _cardinal = k;
          return;
        }
      });
    }

    return _cardinal;
  }

  /// Get True if direction is `VRB` in the report. False otherwise.
  bool get variable => _variable;
}

class Speed extends Numeric {
  Speed(String? code) : super(null) {
    code ??= '///';

    if (code.length == 2) {
      code = '0' + code;
    }

    assert(code.length == 3, 'wind speed code must have 2 or 3 digits length');

    _value = double.tryParse(code);
  }

  @override
  String toString() {
    if (_value != null) {
      return '${super.toString()} kt';
    }

    return super.toString();
  }
}
