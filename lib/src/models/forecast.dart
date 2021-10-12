import 'package:metar_dart/src/models/descriptors.dart';
import 'package:metar_dart/src/models/weather.dart' show Item;

final TREND = <String, String>{
  'NOSIG': 'no significant changes',
  'BECMG': 'becoming',
  'TEMPO': 'temporary',
  'PROB30': 'probability 30%',
  'PROB40': 'probability 40%',
};

final PERIOD = <String, String>{
  'FM': 'from',
  'TL': 'until',
  'AT': 'at',
};

class TrendGroup extends Item {
  TrendGroup(String? code) : super(TREND[code]);
}

class PeriodPrefix extends Item {
  PeriodPrefix(String? code) : super(PERIOD[code]);
}

class PeriodTime {
  String? _time;

  PeriodTime(String? code) {
    if (code != null) {
      if (code.substring(0, 2) == '24') {
        _time = '00:${code.substring(2)}Z';
      } else {
        _time = '${code.substring(0, 2)}:${code.substring(2)}Z';
      }
    }
  }

  @override
  String toString() {
    if (_time != null) {
      return _time!;
    }

    return '';
  }

  String? get time => _time;
}

class Period extends Group {
  PeriodPrefix _prefix = PeriodPrefix(null);
  PeriodTime _time = PeriodTime(null);

  Period(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      _prefix = PeriodPrefix(match.namedGroup('prefix'));
      _time = PeriodTime(match.namedGroup('time'));
    }
  }

  @override
  String toString() {
    if (_prefix.value != null && _time.time != null) {
      return '${_prefix.value} ${_time.time}';
    }

    return '';
  }

  String? get prefix => _prefix.value;
  String? get time => _time.time;
}

class TrendForecast extends Group {
  TrendGroup _trend = TrendGroup(null);
  Period _from = Period(null, null);
  Period _until = Period(null, null);
  Period _at = Period(null, null);

  TrendForecast(String? code) : super(code) {
    _trend = TrendGroup(code);
  }

  @override
  String toString() {
    if (_trend.value != null) {
      var s = '$_trend '
          '$_from '
          '$_until '
          '$_at';
      s = s.replaceAll(RegExp(r'\s{2,}'), ' ');

      return s.trim();
    }

    return '';
  }

  List<String?> get codes {
    final list = [code] +
        [
          _from,
          _until,
          _at,
        ].map((e) => e.code).toList();

    return list;
  }

  String? get trend => _trend.value;
  String? get from_time => _from.time;
  String? get until_time => _until.time;
  String? get at_time => _at.time;

  set from_period(Period period) {
    _from = period;
  }

  set until_period(Period period) {
    _until = period;
  }

  set at_period(Period period) {
    _at = period;
  }
}
