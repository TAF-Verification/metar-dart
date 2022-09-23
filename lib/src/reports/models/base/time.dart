part of reports;

/// Basic structure for time code groups in reports from land stations.
class Time extends Group {
  late DateTime _time;

  Time(
      {String? code,
      String? day,
      String? hour,
      String? minute,
      int? year,
      int? month,
      DateTime? time})
      : super(code) {
    if (time != null) {
      _time = time;
    } else {
      final today = DateTime.now().toUtc();

      year ??= today.year;
      month ??= today.month;
      day ??= '01';
      hour ??= '00';
      minute ??= '00';

      final _month = '$month'.padLeft(2, '0');

      final generatedDate = '$year$_month${day}T$hour${minute}00';
      _time = DateTime.parse(generatedDate);
    }
  }

  factory Time.fromMetar({
    String? code,
    RegExpMatch? match,
    int? year,
    int? month,
  }) {
    String? minute;
    String? hour;
    String? day;

    if (match != null) {
      minute = match.namedGroup('min');
      hour = match.namedGroup('hour');
      day = match.namedGroup('day');
    }

    return Time(
      code: code,
      minute: minute,
      hour: hour,
      day: day,
      month: month,
      year: year,
    );
  }

  @override
  String toString() {
    return _time.toString().replaceFirst('.000', '');
  }

  /// Get the time of the report.
  DateTime get time => _time;

  /// Get the year of the report.
  int get year => _time.year;

  /// Get the month of the report.
  int get month => _time.month;

  /// Get the day of the report.
  int get day => _time.day;

  /// Get the hour of the report.
  int get hour => _time.hour;

  /// Get the minute of the report.
  int get minute => _time.minute;

  @override
  Map<String, String?> asMap() {
    final map = super.asMap();
    map.addAll({'datetime': toString()});
    return map.cast<String, String?>();
  }
}

mixin TimeMixin {
  // ignore: prefer_final_fields
  Time _time = Time();
}
