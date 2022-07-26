part of reports;

/// Basic structure for minimum visibility groups in reports from land stations.
class MetarMinimumVisibility extends Group {
  Direction _direction = Direction(null);
  Distance _visibility = Distance(null);

  MetarMinimumVisibility(String? code, RegExpMatch? match)
      : super(code?.replaceAll('_', ' ')) {
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
  double? get inMeters => _visibility.inMeters;

  /// Get the visibility in kilometers.
  double? get inKilometers => _visibility.inKilometers;

  /// Get the visibility in sea miles.
  double? get inSeaMiles => _visibility.inSeaMiles;

  /// Get the visibility in feet.
  double? get inFeet => _visibility.inFeet;

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

  @override
  Map<String, Object?> asMap() {
    final map = super.asMap();
    map.addAll({
      'visibility': _visibility.asMap(),
      'direction': _direction.asMap(),
    });
    return map;
  }
}

/// Basic structure for prevailing visibility in reports from land stations.
class MetarPrevailingVisibility extends MetarMinimumVisibility {
  bool cavok = false;

  MetarPrevailingVisibility(String? code, RegExpMatch? match)
      : super(code, match) {
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

  @override
  Map<String, Object?> asMap() {
    final map = super.asMap();
    map.addAll({'cavok': cavok});
    return map;
  }
}

/// Mixin to add prevailing visibility attribute to the report.
mixin MetarPrevailingMixin on StringAttributeMixin {
  MetarPrevailingVisibility _prevailing = MetarPrevailingVisibility(null, null);

  void _handlePrevailing(String group) {
    final match = MetarRegExp.VISIBILITY.firstMatch(group);
    _prevailing = MetarPrevailingVisibility(group, match);

    _concatenateString(_prevailing);
  }

  /// Get the prevailing visibility data of the report.
  MetarPrevailingVisibility get prevailingVisibility => _prevailing;
}
