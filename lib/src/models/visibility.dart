part of models;

class MinimumVisibility extends Group {
  Direction _direction = Direction(null);
  Distance _visibility = Distance(null);

  MinimumVisibility(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      final _vis = match.namedGroup('vis');
      final _dir = match.namedGroup('dir');
      final _integer = match.namedGroup('integer');
      final _fraction = match.namedGroup('fraction');
      final _units = match.namedGroup('units');

      if (_vis != null || _units == 'M') {
        _visibility = Distance(_vis);
      }

      if (_integer != null || _fraction != null) {
        if (_units == 'SM') {
          _fromSeaMiles(_integer, _fraction);
        }

        if (_units == 'KM') {
          final _in_meters = int.parse(_integer!) * 1000;
          _visibility = Distance('$_in_meters'.padLeft(4, '0'));
        }
      }

      if (_dir != null) {
        _direction = Direction.fromCardinal(_dir);
      }
    }
  }

  /// Helper to handle the visibility from sea miles.
  void _fromSeaMiles(String? integer, String? fraction) {
    late final double _fraction;
    if (fraction != null) {
      final _items = fraction.split('/');
      _fraction = int.parse(_items[0]) / int.parse(_items[1]);
    } else {
      _fraction = 0.0;
    }

    var _vis = _fraction;

    if (integer != null) {
      final _integer = double.parse(integer);
      _vis += _integer;
    }

    _visibility =
        Distance('${_vis * Conversions.SMI_TO_KM * Conversions.KM_TO_M}');
  }

  @override
  String toString() {
    if (_visibility.value == null) {
      return '';
    }

    final _directionAsStr = _direction.value != null
        ? ' to ${_direction.cardinal} ($_direction)'
        : '';

    return '${inKilometers!.toStringAsFixed(1)} km' '$_directionAsStr';
  }

  /// Get the visibility in meters.
  double? get inMeters => _visibility.value;

  /// Get the visibility in kilometers.
  double? get inKilometers =>
      _visibility.converted(conversionDouble: Conversions.M_TO_KM);

  /// Get the visibility in sea miles.
  double? get inSeaMiles =>
      _visibility.converted(conversionDouble: Conversions.M_TO_SMI);

  /// Get the visibility in feet.
  double? get inFeet =>
      _visibility.converted(conversionDouble: Conversions.M_TO_FT);

  /// Get the cardinal direction associated with the visibility.
  String? get cardinalDirection => _direction.cardinal;

  /// Get the visibility direction in degrees.
  double? get directionInDegrees => _direction.value;

  /// Get the visibility direction in radians.
  double? get directionInRadians =>
      _direction.converted(conversionDouble: Conversions.DEGREES_TO_RADIANS);

  /// Get the visibility direction in gradians.
  double? get directionInGradians =>
      _direction.converted(conversionDouble: Conversions.DEGREES_TO_GRADIANS);
}

class Prevailing extends MinimumVisibility {
  bool cavok = false;

  Prevailing(String? code, RegExpMatch? match) : super(code, match) {
    if (match != null) {
      final _cavok = match.namedGroup('cavok');
      if (_cavok != null) {
        cavok = true;
        _visibility = Distance('9999');
      }
    }
  }

  @override
  String toString() {
    if (cavok) {
      return 'Ceiling and Visibility OK';
    }

    return super.toString();
  }
}

class Distance extends Numeric {
  Distance(String? code) : super(null) {
    code ??= '//\//';

    if (code == '9999') code = '10000';

    final _visibility = double.tryParse(code);

    _value = _visibility;
  }

  @override
  String toString() {
    if (_value != null) {
      return super.toString() + ' m';
    }

    return super.toString();
  }
}
