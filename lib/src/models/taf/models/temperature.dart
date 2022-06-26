part of models;

/// Basic structure for temperature groups in TAF.
class TafTemperature extends Temperature with GroupMixin {
  late final Time? _time;

  TafTemperature(String? code, RegExpMatch? match, DateTime time)
      : super(null) {
    _code = code;
    time = DateTime(time.year, time.month, time.day, time.hour, 0, 0);

    if (match == null) {
      _time = null;
    } else {
      final _sign = match.namedGroup('sign');
      final _temp = match.namedGroup('temp');

      if (_sign != null) {
        _setTemperature('-$_temp');
      } else {
        _setTemperature(_temp);
      }

      final _day = int.parse(match.namedGroup('day')!);
      final _hour = int.parse(match.namedGroup('hour')!);

      time = DateTime(time.year, time.month, time.day, _hour, 0, 0);
      if (_day == time.day) {
        _time = Time(time: time);
      } else {
        time = time.add(const Duration(days: 1));
        _time = Time(time: time);
      }
    }
  }

  @override
  String toString() {
    if (_value == null) {
      return super.toString();
    }

    return super.toString() + ' at $_time';
  }

  /// Get the date and time the temperature is expected to happen.
  Time? get time => _time;

  @override
  Map<String, Object?> asMap() {
    final map = super.asMap();
    map.addAll({'code': _code});
    map.addAll(time == null ? {'datetime': null} : time!.asMap());
    return map;
  }
}

/// Basic structure for temperature lists in TAF.
class TafTemperatureList extends GroupList<TafTemperature> {
  TafTemperatureList() : super(2);
}
