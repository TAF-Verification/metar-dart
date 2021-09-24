import 'package:metar_dart/src/models/descriptors.dart';
import 'package:metar_dart/src/utils/utils.dart' show Conversions, handleValue;

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

String? handleCardinal(double? value) {
  String? cardinal;

  if (value == null) {
    cardinal = null;
  } else if (value == 0.0) {
    return 'calm';
  } else if (value == 999.0) {
    return 'variable';
  } else {
    final dirs = COMPASS_DIRS['N'];
    if (value >= dirs![0] || value < dirs[1]) {
      cardinal = 'N';
    }

    COMPASS_DIRS.forEach((k, v) {
      if (value >= v[0] && value < v[1]) {
        cardinal = k;
        return;
      }
    });
  }

  return cardinal;
}

class Direction {
  double? _direction = 360.0;

  Direction(String? code) {
    code ??= '///';

    try {
      _direction = double.parse(code);
    } catch (e) {
      if (code == 'VRB') {
        _direction = 999.0;
      } else {
        _direction = null;
      }
    }
  }

  @override
  String toString() {
    return _direction.toString();
  }

  double? get direction => _direction;
}

class Speed {
  double? _speed = 0.0;

  Speed(String? code, String units) {
    code ??= '//';

    try {
      _speed = double.parse(code);
    } catch (e) {
      _speed = null;
    }

    if (units == 'MPS') {
      _speed = handleValue(_speed, Conversions.MPS_TO_KNOT);
    }
  }

  @override
  String toString() {
    return _speed.toString();
  }

  double? get speed => _speed;
}

class WindVariation extends Group {
  Direction? _from;
  Direction? _to;

  WindVariation(String? code, RegExpMatch? match) : super(code) {
    _from = Direction(match?.namedGroup('from'));
    _to = Direction(match?.namedGroup('to'));
  }

  @override
  String toString() {
    if (_from?.direction == null) {
      return '';
    }

    return 'from'
        ' $fromCardinalDirection ($fromInDegrees°)'
        ' to'
        ' $toCardinalDirection ($toInDegrees°)';
  }

  String? get fromCardinalDirection => handleCardinal(_from?.direction);
  double? get fromInDegrees => _from?.direction;
  double? get fromInRadians =>
      handleValue(_from?.direction, Conversions.DEGREES_TO_RADIANS);
  double? get fromInGradians =>
      handleValue(_from?.direction, Conversions.DEGREES_TO_GRADIANS);
  String? get toCardinalDirection => handleCardinal(_to?.direction);
  double? get toInDegrees => _to?.direction;
  double? get toInRadians =>
      handleValue(_to?.direction, Conversions.DEGREES_TO_RADIANS);
  double? get toInGradians =>
      handleValue(_to?.direction, Conversions.DEGREES_TO_GRADIANS);
}

class Wind extends Group {
  Direction? _direction;
  Speed? _speed;
  Speed? _gust;

  Wind(String? code, RegExpMatch? match) : super(code) {
    final units = match?.namedGroup('units');
    _direction = Direction(match?.namedGroup('dir'));
    _speed = Speed(match?.namedGroup('speed'), units.toString());
    _gust = Speed(match?.namedGroup('gust'), units.toString());
  }

  @override
  String toString() {
    final direction = _direction?.direction == null
        ? ''
        : '$cardinalDirection ($directionInDegrees°)';
    final speed = _speed?.speed == null ? '' : '$speedInKnot kt';
    final gust = _gust?.speed == null ? '' : 'gust of ${_gust?.speed} kt';

    final string = '$direction $speed $gust'.trim();

    return string;
  }

  String? get cardinalDirection => handleCardinal(_direction?.direction);
  double? get directionInDegrees => _direction?.direction;
  double? get directionInRadians =>
      handleValue(_direction?.direction, Conversions.DEGREES_TO_RADIANS);
  double? get directionInGradians =>
      handleValue(_direction?.direction, Conversions.DEGREES_TO_GRADIANS);
  double? get speedInKnot => _speed?.speed;
  double? get speedInMps => handleValue(_speed?.speed, Conversions.KNOT_TO_MPS);
  double? get speedInKph => handleValue(_speed?.speed, Conversions.KNOT_TO_KPH);
  double? get speedInMiph =>
      handleValue(_speed?.speed, Conversions.KNOT_TO_MIPH);
  double? get gustInKnot => _gust?.speed;
  double? get gustInMps => handleValue(_gust?.speed, Conversions.KNOT_TO_MPS);
  double? get gustInKph => handleValue(_gust?.speed, Conversions.KNOT_TO_KPH);
  double? get gustInMiph => handleValue(_gust?.speed, Conversions.KNOT_TO_MIPH);
}
