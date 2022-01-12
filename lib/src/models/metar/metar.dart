part of models;

/// Parser for METAR reports.
class Metar extends Report {
  Metar(String code, {bool truncate = false}) : super(code, truncate) {
    _handleSections();

    // Parse groups
    _parseBody();
  }

  /// Get the body part of the METAR.
  String get body => _sections[0];

  /// Get the trend part of the METAR.
  String get trend => _sections[1];

  /// Get the remark part of the METAR.
  String get remark => _sections[2];

  void _parseBody() {
    final handlers = <GroupHandler>[
      GroupHandler(MetarRegExp.TYPE, _handleType),
    ];

    _parse(handlers, body);
  }

  @override
  void _parse(List<GroupHandler> handlers, String section,
      {String sectionType = 'body'}) {
    var index = 0;

    // section = sanitizeVisibility(section);
    // if (sectionType == 'body') {
    //   section = sanitizeWindshear(section);
    // }
    section.split(' ').forEach((group) {
      unparsedGroups.add(group);

      for (var i = index; i < handlers.length; i++) {
        var handler = handlers[i];

        index++;

        if (handler.regexp.hasMatch(group)) {
          handler.handler(group);
          unparsedGroups.remove(group);
          break;
        }
      }
    });

    if (unparsedGroups.isNotEmpty && _truncate) {
      throw ParserError(
        'failed while processing ${unparsedGroups.join(" ")} from: $rawCode',
      );
    }
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

    if (trendPos == null && remarkPos != null) {
      body = _rawCode.substring(0, remarkPos - 1);
      remark = _rawCode.substring(remarkPos);
    } else if (trendPos != null && remarkPos == null) {
      body = _rawCode.substring(0, trendPos - 1);
      trend = _rawCode.substring(trendPos);
    } else if (trendPos == null && remarkPos == null) {
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
}
