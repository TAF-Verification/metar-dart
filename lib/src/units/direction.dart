import 'package:metar_dart/src/units/angle.dart';

class Direction {
  /*
   * The value of this direction from Metar report
  */
  final Map<String, double> _compassDirs = {
    'N': 0.0,
    'NNE': 22.5,
    'NE': 45.0,
    'ENE': 67.5,
    'E': 90.0,
    'ESE': 112.5,
    'SE': 135.0,
    'SSE': 157.5,
    'S': 180.0,
    'SSW': 202.5,
    'SW': 225.0,
    'WSW': 247.5,
    'W': 270.0,
    'WNW': 292.5,
    'NW': 315.0,
    'NNW': 337.5,
  };
  Angle _direction;
  String _directionStr;
  bool _variable = false;

  Direction.fromDegrees({String value = '000'}) {
    _direction = Angle.fromDegrees(value: double.parse(value));
    _directionStr = _cardinalPoint(value);
  }
  Direction.fromUndefined({String value = '///'}) {
    if (_compassDirs.keys.toList().contains(value)) {
      _direction = Angle.fromDegrees(value: _compassDirs[value]);
    } else {
      if (value == 'VRB') {
        _variable = true;
      }
      _direction = Angle.fromDegrees(value: 0.0);
    }
    _directionStr = _cardinalPoint(value);
  }

  double get directionInDegrees => _returnValue('degrees');
  double get directionInRadians => _returnValue('radians');
  double get directionInGradians => _returnValue('gradians');
  String get cardinalPoint => _directionStr;
  String get variable {
    if (_variable) {
      return 'variable';
    }
    return 'not variable';
  }

  String _cardinalPoint(String value) {
    String point;
    double angle;
    for (var dir in _compassDirs.keys.toList()) {
      if (value == dir) {
        point = value;
        break;
      } else if (RegExp(r'^\d{3}$').hasMatch(value)) {
        angle = double.parse(value);
        if (angle == _compassDirs[dir]) {
          point = dir;
          break;
        } else if (angle >= 348.75) {
          point = 'N';
          break;
        } else if (angle >= _compassDirs[dir] - 11.25 &&
            angle < _compassDirs[dir] + 11.25) {
          point = dir;
          break;
        } else {
          point = 'INVALID ANGLE';
        }
      } else {
        point = 'NO DATA';
        continue;
      }
    }
    return point;
  }

  double _returnValue(String format) {
    if (_directionStr == 'VRB' ||
        _directionStr == '///' ||
        _directionStr == 'MMM') {
      return null;
    }
    if (format == 'degrees') {
      return _direction.inDegrees;
    } else if (format == 'radians') {
      return _direction.inRadians;
    } else {
      return _direction.inGradians;
    }
  }
}
