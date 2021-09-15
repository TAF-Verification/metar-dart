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

class MinimumVisibility extends Group {
  Direction _direction = Direction(null);
  Distance _distance = Distance(null);

  MinimumVisibility(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      final vis = match.namedGroup('vis');
      if (vis == '9999') {
        _distance = Distance('10000');
      } else {
        _distance = Distance(vis);
      }
      _direction = Direction(match.namedGroup('dir'));
    }
  }

  @override
  String toString() {
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

  String? get cardinalDirection => _direction.direction;
  double? get directionInDegrees => handleDirection(_direction.direction, 1.0);
  double? get directionInRadians =>
      handleDirection(_direction.direction, Conversions.DEGREES_TO_RADIANS);
  double? get directionInGradians =>
      handleDirection(_direction.direction, Conversions.DEGREES_TO_GRADIANS);
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

final NAMES = {
  'R': 'right',
  'L': 'left',
  'C': 'center',
};

class RunwayName {
  String? _name;

  RunwayName(String? code) {
    if (code != null) {
      if (code.length == 3) {
        final nameChar = code[2];
        final nameStr = NAMES[nameChar];

        _name = code.replaceFirst(nameChar, ' $nameStr');
      } else if (code == '88') {
        _name = 'all runways';
      } else if (code == '99') {
        _name = 'repeated';
      } else {
        _name = code;
      }
    }
  }

  @override
  String toString() {
    return _name.toString();
  }

  String? get name => _name;
}

final LIMITS = {
  'M': 'below of',
  'P': 'above of',
};

class RVRLimits {
  String? _limit;

  RVRLimits(String? code) {
    _limit = LIMITS[code];
  }

  @override
  String toString() {
    return _limit.toString();
  }

  String? get limit => _limit;
}

final TRENDS = {
  'N': 'no change',
  'U': 'increasing',
  'D': 'decreasing',
};

class Trend {
  String? _trend;

  Trend(String? code) {
    _trend = TRENDS[code];
  }

  @override
  String toString() {
    return _trend.toString();
  }

  String? get trend => _trend;
}

class RunwayRange extends Group {
  RunwayName _name = RunwayName(null);
  RVRLimits _rvrlow = RVRLimits(null);
  Distance _low = Distance(null);
  RVRLimits _rvrhigh = RVRLimits(null);
  Distance _high = Distance(null);
  Trend _trend = Trend(null);

  RunwayRange(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      final units = match.namedGroup('units');
      _name = RunwayName(match.namedGroup('name'));
      _rvrlow = RVRLimits(match.namedGroup('rvrlow'));
      _rvrhigh = RVRLimits(match.namedGroup('rvrhigh'));
      _trend = Trend(match.namedGroup('trend'));

      final low = match.namedGroup('low');
      final high = match.namedGroup('high');
      if (units == 'FT') {
        _low = Distance(
            '${double.tryParse(low.toString())! * Conversions.FT_TO_M}');

        _high = Distance(
            '${double.tryParse(high.toString())! * Conversions.FT_TO_M}');
      } else {
        _low = Distance(low);
        _high = Distance(high);
      }
    }
  }

  String _highAsString() {
    if (_high.distance != null && _rvrhigh.limit != null) {
      return ' varying to $_rvrhigh $_high meters';
    } else if (_high.distance != null) {
      return ' varying to $_high meters';
    } else {
      return '';
    }
  }

  @override
  String toString() {
    if (_low.distance != null) {
      return 'runway $name'
          ' $low'
          '${_highAsString()}'
          "${trend != null ? ' $trend' : ''}";
    }

    return 'no data';
  }

  String? get name => _name.name;
  String? get low {
    if (_rvrlow.limit != null) {
      return '$_rvrlow $_low meters';
    }

    return '$_low meters';
  }

  String? get high =>
      _highAsString().replaceFirst(RegExp(r'\svarying\sto\s'), '');
  String? get trend => _trend.trend;

  double? get lowInMeters => _low.distance;
  double? get lowInKilometers =>
      handleValue(_low.distance, Conversions.M_TO_KM);
  double? get lowInSeaMiles => handleValue(_low.distance, Conversions.M_TO_SMI);
  double? get lowInFeet => handleValue(_low.distance, Conversions.M_TO_FT);

  double? get highInMeters => _high.distance;
  double? get highInKilometers =>
      handleValue(_high.distance, Conversions.M_TO_KM);
  double? get highInSeaMiles =>
      handleValue(_high.distance, Conversions.M_TO_SMI);
  double? get highInFeet => handleValue(_high.distance, Conversions.M_TO_FT);
}

class RunwayRanges {
  RunwayRange _first = RunwayRange(null, null);
  RunwayRange _second = RunwayRange(null, null);
  RunwayRange _third = RunwayRange(null, null);
  final List<RunwayRange> _rangesList = <RunwayRange>[];
  int _count = 0;

  RunwayRanges();

  void add(RunwayRange range) {
    if (_count >= 3) {
      throw RangeError("Can't set more than three runway ranges");
    }

    if (_count == 0) {
      _first = range;
    } else if (_count == 1) {
      _second = range;
    } else {
      _third = range;
    }

    _rangesList.add(range);
    _count++;
  }

  @override
  String toString() {
    return _rangesList.join(' | ');
  }

  int get length => _rangesList.length;
  List<String> get codes {
    final list = _rangesList.map((e) => e.code.toString()).toList();

    return list;
  }

  Iterable<RunwayRange> get iter => _rangesList.map((e) => e);
  List<RunwayRange> get toList => _rangesList;
  RunwayRange get first => _first;
  RunwayRange get second => _second;
  RunwayRange get third => _third;
}
