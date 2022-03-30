part of models;

class MetarTime extends Time with GroupMixin {
  MetarTime(String? code, RegExpMatch? match, {int? year, int? month})
      : super(year: year, month: month, minute: '00') {
    _code = code;

    if (match != null) {
      final _day = match.namedGroup('day');
      final _hour = match.namedGroup('hour');
      final _minute = match.namedGroup('min');

      final _month = '${_time.month}'.padLeft(2, '0');
      _time = DateTime.parse('${_time.year}$_month${_day}T$_hour${_minute}00');
    }
  }
}

mixin MetarTimeMixin on Report {
  MetarTime _time = MetarTime(null, null);
}
