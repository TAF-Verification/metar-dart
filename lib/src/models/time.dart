part of models;

/// Basic structure for time groups in reports from land stations.
class Time extends Group {
  late final DateTime _time;
  late final int _year, _month;

  Time(String? code) : super(code) {
    final currentTime = _verifyNull(null, null);
    _time = currentTime;
  }

  Time.fromMETAR(String? code, {RegExpMatch? match, int? year, int? month})
      : super(code) {
    final currentTime = _verifyNull(year, month);

    if (match != null) {
      final dayStr = match.namedGroup('day') ?? '00';
      final hourStr = match.namedGroup('hour') ?? '00';
      final minuteStr = match.namedGroup('minute') ?? '00';

      final day = int.parse(dayStr);
      final hour = int.parse(hourStr);
      final minute = int.parse(minuteStr);

      _time = DateTime(_year, _month, day, hour, minute);
    } else {
      _time = currentTime;
    }
  }

  /// Private method to verify if year and month are both null. In case of
  /// some of them are null, it is reassigned to current year or month.
  DateTime _verifyNull(int? year, int? month) {
    final currentTime = DateTime.now().toUtc();

    year ??= currentTime.year;
    month ??= currentTime.month;

    _year = year;
    _month = month;

    return currentTime;
  }

  @override
  String toString() {
    return '$_time';
  }

  /// Get the time of the report.
  DateTime get time => _time;

  /// Get the year of the report.
  int get year => _time.year;

  /// Get the month of the report.
  int get month => _time.month;

  /// Get the dayof the month of the report.
  int get day => _time.day;

  /// Get the UTC hour of the report.
  int get hour => _time.hour;

  /// Get the minute of the report.
  int get minute => _time.minute;
}
