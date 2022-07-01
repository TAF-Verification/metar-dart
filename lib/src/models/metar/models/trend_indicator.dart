part of models;

/// Basic structure for trend codes in METAR.
class MetarTrendIndicator extends ChangeIndicator {
  late final Time _initPeriod;
  late final Time _endPeriod;
  late Time _from;
  late Time _until;
  Time? _at;

  MetarTrendIndicator(String? code, RegExpMatch? match, DateTime time)
      : super(code, match) {
    // Init period and end period of forecast
    _initPeriod = Time(time: time);
    _endPeriod = Time(time: time.add(const Duration(hours: 2)));

    _from = _initPeriod;
    _until = _endPeriod;
  }

  @override
  String toString() {
    if (_at != null) {
      return super.toString() + ' at $_at';
    }

    if (_translation != null) {
      return super.toString() + ' from $_from until $_until';
    }

    return super.toString();
  }

  /// Helper to add periods of time to the change indicator.
  void addPeriod(String code, RegExpMatch match) {
    _code = _code! + ' $code';

    // The middle time between self._init_period and self._end_period
    final middleTime = _initPeriod.time.add(const Duration(hours: 1));

    final prefix = match.namedGroup('prefix');
    final hour = match.namedGroup('hour');
    final minute = match.namedGroup('min');

    final hourAsInt = int.parse(hour!);
    final minAsInt = int.parse(minute!);

    late final DateTime _time;
    late final int minutes;

    if (hourAsInt == _initPeriod.hour) {
      minutes = minAsInt - _initPeriod.minute;
      _time = _initPeriod.time.add(Duration(minutes: minutes));
    } else if (hourAsInt == middleTime.hour) {
      minutes = minAsInt - middleTime.minute;
      _time = middleTime.add(Duration(minutes: minutes));
    } else {
      minutes = minAsInt - _endPeriod.minute;
      _time = _endPeriod.time.add(Duration(minutes: minutes));
    }

    if (prefix == 'FM') {
      _from = Time(time: _time);
    } else if (prefix == 'TL') {
      _until = Time(time: _time);
    } else {
      _at = Time(time: _time);
    }
  }

  /// Get the forcast period, i.e. initial forecast time and end forecast time.
  Tuple2<Time, Time> get forecastPeriod => Tuple2(_initPeriod, _endPeriod);

  /// Get the `from` forecast period.
  Time get periodFrom => _from;

  /// Get the `until` forecast period.
  Time get periodUntil => _until;

  /// Get the `at` forecast period.
  Time? get periodAt => _at;

  @override
  Map<String, Object?> asMap() {
    final map = <String, Object?>{
      'forecast_period': {
        'init': forecastPeriod.item1.asMap(),
        'end': forecastPeriod.item2.asMap(),
      },
      'from_': periodFrom.asMap(),
      'until': periodUntil.asMap(),
      'at': periodAt != null ? periodAt!.asMap() : null,
    };
    map.addAll(super.asMap());
    return map;
  }
}
