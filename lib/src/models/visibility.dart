import 'package:metar_dart/src/models/descriptors.dart';
import 'package:metar_dart/src/models/wind.dart' show COMPASS_DIRS;
import 'package:metar_dart/src/utils/utils.dart' show handleValue, Conversions;

class Direction {
  String? _direction;

  Direction(String? code) {
    _direction = code;
  }

  @override
  String toString() {
    return _direction.toString();
  }

  String? get direction => _direction;
}

double? handleDirection(String? direction, double conversion) {
  if (direction == null) {
    return null;
  }

  if (direction == 'N') {
    return 360.0 * conversion;
  }

  final values = COMPASS_DIRS[direction]!;
  final value =
      ((values.first + values.last) / 2 * conversion).toStringAsFixed(5);

  return double.parse(value);
}

class Distance {
  double? _distance = 0.0;

  Distance(String? code) {
    if (code == null) {
      _distance = null;
    } else {
      _distance = double.tryParse(code);
    }
  }

  @override
  String toString() {
    return _distance.toString();
  }

  double? get distance => _distance;
}

class Visibility extends Group {
  Direction _direction = Direction(null);
  Distance _distance = Distance(null);
  bool _cavok = false;

  Visibility(String? code, RegExpMatch? match)
      : super(code?.replaceFirst('_', ' ')) {
    List<String> items;
    double visextreme;

    if (match != null) {
      final visextremeGroup = match.namedGroup('visextreme');
      if (visextremeGroup != null) {
        if (visextremeGroup.contains('/')) {
          items = visextremeGroup.split('/');
          visextreme = int.parse(items[0]) / int.parse(items[1]);
        } else {
          visextreme = double.parse(visextremeGroup);
        }
      } else {
        visextreme = 0.0;
      }

      final visGroup = match.namedGroup('vis');
      final optGroup = match.namedGroup('opt');
      if (visGroup != null) {
        if (visGroup == '9999') {
          _distance = Distance('10000');
        } else {
          _distance = Distance(visGroup);
        }
      } else if (optGroup != null) {
        final opt = double.parse(optGroup);
        final vis =
            (opt + visextreme) * Conversions.SMI_TO_KM * Conversions.KM_TO_M;

        _distance = Distance('$vis');
      } else if (visextremeGroup != null) {
        final vis = visextreme * Conversions.SMI_TO_KM * Conversions.KM_TO_M;
        _distance = Distance('$vis');
      } else {
        _distance = Distance('10000');
      }

      _direction = Direction(match.namedGroup('dir'));
      _cavok = match.namedGroup('cavok') == 'CAVOK' ? true : false;
    }
  }

  @override
  String toString() {
    if (cavok) {
      return 'Ceiling and Visibility OK';
    }

    return cardinalDirection != null
        ? '$inKilometers km to $cardinalDirection'
        : '$inKilometers km';
  }

  double? get inMeters => _distance.distance;
  double? get inKilometers =>
      handleValue(_distance.distance, Conversions.M_TO_KM);
  double? get inSeaMiles =>
      handleValue(_distance.distance, Conversions.M_TO_SMI);
  double? get inFeet => handleValue(_distance.distance, Conversions.M_TO_FT);

  bool get cavok => _cavok;
  set cavok(bool value) {
    _cavok = value;
  }

  String? get cardinalDirection => _direction.direction;
  double? get directionInDegrees => handleDirection(_direction.direction, 1.0);
  double? get directionInRadians =>
      handleDirection(_direction.direction, Conversions.DEGREES_TO_RADIANS);
  double? get directionInGradians =>
      handleDirection(_direction.direction, Conversions.DEGREES_TO_GRADIANS);
}
