import 'package:metar_dart/src/models/report.dart';

class Metar extends Report {
  Metar(String code) : super(code) {
    sections = _handleSections(rawCode);
  }

  /// Returns the body section of the METAR report.
  String get body => sections[0];

  /// Returns the trend section of the METAR report.
  String get trend => sections[1];

  /// Returns the remark section of the METAR report.
  String get remark => sections[2];
}

List<String> _handleSections(String code) {
  final trendRe = RegExp(r'TEMPO|BECMG|NOSIG|FM\d{6}|PROB\d{2}');
  final rmkRe = RegExp(r'RMK(S)?');
  String body, trend, rmk;

  var trendPos = -1;
  var rmkPos = -1;

  final trendMatch = trendRe.firstMatch(code);
  if (trendMatch != null) {
    trendPos = trendMatch.start;
  }
  final rmkMatch = rmkRe.firstMatch(code);
  if (rmkMatch != null) {
    rmkPos = rmkMatch.start;
  }

  if (trendPos < 0 && rmkPos >= 0) {
    body = code.substring(0, rmkPos - 1);
    rmk = code.substring(rmkPos);
    trend = '';
  } else if (trendPos >= 0 && rmkPos < 0) {
    body = code.substring(0, trendPos - 1);
    trend = code.substring(trendPos);
    rmk = '';
  } else if (trendPos < 0 && rmkPos < 0) {
    body = code;
    trend = '';
    rmk = '';
  } else {
    if (trendPos > rmkPos) {
      body = code.substring(0, rmkPos - 1);
      rmk = code.substring(rmkPos, trendPos - 1);
      trend = code.substring(trendPos);
    } else {
      body = code.substring(0, rmkPos - 1);
      trend = code.substring(trendPos, rmkPos - 1);
      rmk = code.substring(rmkPos);
    }
  }

  return [body, trend, rmk];
}
