import 'package:metar_dart/src/models/descriptors.dart';

class Time extends Group {
  DateTime _time = DateTime.now().toUtc();

  Time(String code, RegExpMatch? match, int? year, int? month) : super(code) {
    year ??= _time.year;
    month ??= _time.month;

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
  int? get year => _time.year;
  int? get month => _time.month;
  int? get day => _time.day;
  int? get hour => _time.hour;
  int? get minute => _time.minute;
}
