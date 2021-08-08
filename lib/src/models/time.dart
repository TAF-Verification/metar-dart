import 'package:metar_dart/src/models/descriptors.dart';

class TimeData extends Code {
  DateTime? _time;

  TimeData(String code, RegExpMatch? match, int? year, int? month)
      : super(code) {
    final today = DateTime.now();
    year ??= today.year;
    month ??= today.month;

    final dayStr = match?.namedGroup('day') ?? '00';
    final hourStr = match?.namedGroup('hour') ?? '00';
    final minuteStr = match?.namedGroup('minute') ?? '00';

    final day = int.parse(dayStr);
    final hour = int.parse(hourStr);
    final minute = int.parse(minuteStr);

    _time = DateTime(year, month, day, hour, minute);
  }

  @override
  String toString() {
    return '$_time';
  }

  DateTime? get time => _time;
}

class Time {
  TimeData? _time;

  Time(String group, RegExpMatch? match, int? year, int? month) {
    _time = TimeData(group, match, year, month);
  }

  @override
  String toString() {
    return _time.toString();
  }

  int? get year => _time?.time?.year;
  int? get month => _time?.time?.month;
  int? get day => _time?.time?.day;
  int? get hour => _time?.time?.hour;
  int? get minute => _time?.time?.minute;
  String? get code => _time?.code;
  DateTime? get time => _time?.time;
}
