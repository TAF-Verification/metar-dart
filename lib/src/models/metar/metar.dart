part of models;

/// Parser for METAR reports.
class Metar extends Report {
  Metar(String code) : super(code) {
    _handleSections();
  }

  @override
  void _handleSections() {
    final trendRe = RegExp(MetarRegExp.TREND.pattern
        .replaceFirst(
          RegExp(r'\^'),
          '',
        )
        .replaceFirst(
          RegExp(r'\$'),
          '',
        ));

    final remarkRe = RegExp(MetarRegExp.REMARK.pattern
        .replaceFirst(
          RegExp(r'\^'),
          '',
        )
        .replaceFirst(
          RegExp(r'\$'),
          '',
        ));

    int? trendPos, remarkPos;

    trendPos = trendRe.firstMatch(_rawCode)?.start;
    remarkPos = remarkRe.firstMatch(_rawCode)?.start;

    var body = '';
    var trend = '';
    var remark = '';

    print(trendPos);
    print(remarkPos);

    if (trendPos == null && remarkPos != null) {
      body = _rawCode.substring(0, remarkPos - 1);
      remark = _rawCode.substring(remarkPos);
    } else if (trendPos != null && remarkPos == null) {
      body = _rawCode.substring(0, trendPos - 1);
      trend = _rawCode.substring(trendPos);
    } else if (trendPos == null && remarkPos == null) {
      print('dentro de nulls');
      body = _rawCode;
    } else {
      if (trendPos! > remarkPos!) {
        body = _rawCode.substring(0, remarkPos - 1);
        remark = _rawCode.substring(remarkPos, trendPos - 1);
        trend = _rawCode.substring(trendPos);
      } else {
        body = _rawCode.substring(0, trendPos - 1);
        trend = _rawCode.substring(trendPos, remarkPos - 1);
        remark = _rawCode.substring(remarkPos);
      }
    }

    _sections.add(body);
    _sections.add(trend);
    _sections.add(remark);
  }

  @override
  void _parse() {
    print('');
  }

  /// Get the body part of the METAR.
  String get body => _sections[0];

  /// Get the trend part of the METAR.
  String get trend => _sections[1];

  /// Get the remark part of the METAR.
  String get remark => _sections[2];
}
