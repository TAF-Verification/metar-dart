import 'dart:math';

import 'package:metar_dart/src/units/angle.dart';
import 'package:metar_dart/src/units/length.dart';

class UnitsException implements Exception {
  String _message = 'UnitsException: ';

  UnitsException(message) {
    _message += message;
  }

  @override
  String toString() {
    return _message;
  }
}

double toRadians(double value) {
  final angle = Angle.fromDegrees(value: value);
  return angle.inRadians;
}

// ignore: valid_regexps
RegExp FRACTIONS_RE = RegExp(r'^((?P<int>\d+)\s*)?(?P<num>\d)/(?P<den>\d+)$');

class Position {
  Angle _latitude;
  Angle _longitude;

  Position(double latitude, double longitude) {
    _latitude = Angle.fromDegrees(value: latitude);
    _longitude = Angle.fromDegrees(value: longitude);
  }

  @override
  String toString() {
    return 'Longitude: ${_longitude.inDegrees}, Latitude: ${_latitude.inDegrees}';
  }

  Angle get longitude => _longitude;
  Angle get latitude => _latitude;

  /// Calculate the great-circle distance to another location using the Haversine
  /// formula.  See <http://www.movable-type.co.uk/scripts/LatLong.html>
  /// and <http://mathforum.org/library/drmath/sets/select/dm_lat_long.html>
  Length getDistanceFrom(Position position) {
    var earthRadius = 637100.0;
    var lat1 = _latitude.inRadians;
    var long1 = _longitude.inRadians;
    var lat2 = position.latitude.inRadians;
    var long2 = position.longitude.inRadians;
    var a = pow(sin(0.5 * (lat2 - lat1)), 2) +
        cos(lat1) * cos(lat2) * pow(sin(0.5 * (long2 - long1)), 2);
    var c = 2.0 * atan(sqrt(a) * sqrt(1.0 - a));
    return Length.fromMeters(value: earthRadius * c);
  }

  /// Calculate the initial direction to another location.  (The direction
  /// typically changes as you trace the great circle path to that location.)
  /// See <http://www.movable-type.co.uk/scripts/LatLong.html>.
  Angle getDirectionFrom(Position position) {
    var s = -sin(_longitude.inRadians - position.longitude.inRadians) *
        cos(position.latitude.inRadians);
    var c = cos(_latitude.inRadians) * sin(position.latitude.inRadians) -
        sin(_latitude.inRadians) *
            cos(position.latitude.inRadians) *
            cos(_longitude.inRadians - position.longitude.inRadians);
    var d = atan(s / c) * 180 / pi;
    if (d < 0.0) {
      d += 360.0;
    }
    return Angle.fromDegrees(value: d);
  }
}
