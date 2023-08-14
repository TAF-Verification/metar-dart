part of models;

/// Basic structure for time code groups in reports from land stations.
class Time {
  late DateTime _time;

  Time(
      {String? day,
      String? hour,
      String? minute,
      int? year,
      int? month,
      DateTime? time}) {
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

  @override
  String toString() {
    return DateFormat('dd/MM/yyyy HH:mm').format((this).time);
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
}

mixin TimeMixin on Report {
  Time _time = Time();
}
