part of models;

class Metar extends Report {
  final bool _truncate;

  Metar(String code, {truncate = false})
      : _truncate = truncate,
        super(code) {
    sections = _handleSections(rawCode);

    // Parsers
    _parseBody();
  }

  /// Returns the body section of the METAR report.
  String get body => sections[0];

  /// Returns the trend section of the METAR report.
  String get trend => sections[1];

  /// Returns the remark section of the METAR report.
  String get remark => sections[2];

  // Handlers

  void _parseBody() {
    final handlers = <GroupHandler>[
      GroupHandler(RegularExpresions.TYPE, _handleType),
      GroupHandler(RegularExpresions.STATION, _handleStation),
    ];

    _parse(handlers, body);
  }

  @override
  void _parse(List<GroupHandler> handlers, String section,
      {String sectionType = 'body'}) {
    var index = 0;

    section = sanitizeVisibility(section);
    if (sectionType == 'body') {
      section = sanitizeWindshear(section);
    }
    section.split(' ').forEach((group) {
      unparsedGroups.add(group);

      for (var i = index; i < handlers.length; i++) {
        var handler = handlers[i];

        index++;

        if (handler.regexp.hasMatch(group)) {
          handler.func(group);
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
