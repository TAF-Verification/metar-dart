import 'package:http/http.dart' as http;

import 'package:metar_dart/src/metar/regexp.dart';
import 'package:metar_dart/src/utils/parser_error.dart';

/// Divide the METAR in three parts (if possible):
/// * `body`
/// * `trend`
/// * `remark`
List<String> _divideCode(String code) {
  String body, trend, rmk;
  final regexp = METAR_REGEX();
  int rmkIndex, trendIndex;

  if (regexp.TREND_RE.hasMatch(code)) {
    trendIndex = regexp.TREND_RE.firstMatch(code).start;
  }

  if (regexp.REMARK_RE.hasMatch(code)) {
    rmkIndex = regexp.REMARK_RE.firstMatch(code).start;
  }

  if (trendIndex == null && rmkIndex != null) {
    body = code.substring(0, rmkIndex - 1);
    rmk = code.substring(rmkIndex);
  } else if (trendIndex != null && rmkIndex == null) {
    body = code.substring(0, trendIndex - 1);
    trend = code.substring(trendIndex);
  } else if (trendIndex == null && rmkIndex == null) {
    body = code;
  } else {
    if (trendIndex > rmkIndex) {
      body = code.substring(0, rmkIndex - 1);
      rmk = code.substring(rmkIndex, trendIndex - 1);
      trend = code.substring(trendIndex);
    } else {
      body = code.substring(0, trendIndex - 1);
      rmk = code.substring(trendIndex, rmkIndex - 1);
      trend = code.substring(rmkIndex);
    }
  }

  return <String>[body, trend, rmk];
}

/// Metar model to parse the code for every station
class Metar {
  String _body, _trend, _rmk;
  String _string = '### BODY ###\n';
  String _type = 'METAR';
  String _code, _errorMessage;
  int _month, _year;
  DateTime _time;

  Metar(String code, {int utcMonth, int utcYear}) {
    if (code.isEmpty || code == null) {
      _errorMessage = 'metar code must be not null or empty string';
      throw ParserError(_errorMessage);
    }

    _code = code.trim().replaceAll(RegExp(r'\s+'), ' ').replaceAll('=', '');
    final dividedCodeList = _divideCode(_code);

    // Parts of the METAR code
    _body = dividedCodeList[0];
    _trend = dividedCodeList[1];
    _rmk = dividedCodeList[2];

    final now = DateTime.now().toUtc();
    if (utcMonth != null) {
      _month = utcMonth;
    } else {
      _month = now.month;
    }

    if (utcYear != null) {
      _year = utcYear;
    } else {
      _year = now.year;
    }

    _bodyParser();
  }

  /// Static method to get the current METAR report for a given station
  static Future<Metar> current(String icaoCode) async {
    final url =
        'http://tgftp.nws.noaa.gov/data/observations/metar/stations/${icaoCode.toUpperCase()}.TXT';
    final response = await http.get(url);
    final data = response.body.split('\n');

    final dateString = data[0].replaceAll('/', '-') + ':00';
    final date = DateTime.parse(dateString);

    return Metar(data[1], utcMonth: date.month, utcYear: date.year);
  }

  /// Here begins the body group handlers
  void _handleType(RegExpMatch match) {
    _type = match.namedGroup('type');
    _string += '--- Type ---\n'
        ' * $_type';
  }

  void _handleTime(RegExpMatch match) {
    final day = int.parse(match.namedGroup('day'));
    final hour = int.parse(match.namedGroup('hour'));
    final minute = int.parse(match.namedGroup('minute'));

    if (minute != 0) {
      _type = 'SPECI';
    }

    _time = DateTime(_year, _month, day, hour, minute);
    _string += '--- Time ---\n'
        ' * $_time\n';
  }

  /// Method to parse the groups
  void _parseGroups(
    List<String> groups,
    List<List> handlers, {
    String section = 'body',
  }) {
    Iterable<RegExpMatch> matches;

    groups.forEach((group) {
      for (final handler in handlers) {
        if (handler[0].hasMatch(group) && !handler[2]) {
          matches = handler[0].allMatches(group);
          if (section == 'body') {
            handler[1](matches.elementAt(0));
          } else {
            handler[1](matches.elementAt(0), section: section);
          }

          handler[2] = true;
          break;
        }

        if (handlers.indexOf(handler) == handlers.length - 1) {
          _errorMessage = 'failed while processing "$group". Code: $_code';
          throw ParserError(_errorMessage);
        }
      }
    });
  }

  void _bodyParser() {
    final handlers = [
      [METAR_REGEX().TYPE_RE, _handleType, false],
      [METAR_REGEX().TIME_RE, _handleTime, false],
    ];

    _parseGroups(_body.split(' '), handlers);
  }

  String get body => _body;
  String get trend => _trend;
  String get remark => _rmk;
  DateTime get time => _time;
}
