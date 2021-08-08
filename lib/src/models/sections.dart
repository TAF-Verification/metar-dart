import 'package:metar_dart/src/utils/utils.dart';

final trend_pattern =
    REGEXP.TREND.pattern.replaceAll('^', '').replaceAll('\$', '');
final remark_pattern =
    REGEXP.REMARK.pattern.replaceAll('^', '').replaceAll('\$', '');

class MetarSections {
  String _body = '', _trend = '', _remark = '';
  List<String> _sections = <String>['', '', ''];

  MetarSections(String code) {
    _sections = _handler(code);
  }

  List<String> _handler(String code) {
    int? rmkIndex, trendIndex;
    final trend_re = RegExp(trend_pattern);
    final rmk_re = RegExp(remark_pattern);

    if (trend_re.hasMatch(code)) {
      trendIndex = trend_re.firstMatch(code)?.start;
    }

    if (rmk_re.hasMatch(code)) {
      rmkIndex = rmk_re.firstMatch(code)?.start;
    }

    if (trendIndex == null && rmkIndex != null) {
      _body = code.substring(0, rmkIndex - 1);
      _remark = code.substring(rmkIndex);
    } else if (trendIndex != null && rmkIndex == null) {
      _body = code.substring(0, trendIndex - 1);
      _trend = code.substring(trendIndex);
    } else if (trendIndex == null && rmkIndex == null) {
      _body = code;
    } else {
      if (trendIndex! > rmkIndex!) {
        _body = code.substring(0, rmkIndex - 1);
        _remark = code.substring(rmkIndex, trendIndex - 1);
        _trend = code.substring(trendIndex);
      } else {
        _body = code.substring(0, trendIndex - 1);
        _remark = code.substring(trendIndex, rmkIndex - 1);
        _trend = code.substring(rmkIndex);
      }
    }

    return <String>[_body, _trend, _remark];
  }

  @override
  String toString() => '$_sections';

  List<String> get sections => _sections;
  String get body => _body;
  String get trend => _trend;
  String get remark => _remark;
}
