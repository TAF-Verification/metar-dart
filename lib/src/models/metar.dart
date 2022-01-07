part of models;

/// Parser for METAR reports.
class Metar extends Report
    with ModifierMixin, WindMixin, VisibilityMixin, WeatherMixin, CloudMixin {
  final bool _truncate;

  // Body groups.
  WindVariation _windVariation = WindVariation(null, null);
  MinimumVisibility _minimumVisibility = MinimumVisibility(null, null);
  final _runwayRanges = GroupList<RunwayRange>(3);

  Metar(String code, {int? year, int? month, bool truncate = false})
      : _truncate = truncate,
        super(code, year: year, month: month) {
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
  @override
  void _handleTime(String group) {
    final match = RegularExpresions.TIME.firstMatch(group);
    _time = Time.fromMETAR(group, match: match, year: _year, month: _month);

    _string += 'Time: ${_time.toString()}\n';
  }

  void _handleWindVariation(String group) {
    final match = RegularExpresions.WIND_VARIATION.firstMatch(group);
    _windVariation = WindVariation(group, match);

    _concatenateString(_windVariation);
  }

  /// Get the wind variation data of the METAR.
  WindVariation get windVariation => _windVariation;

  void _handleMinimumVisibility(String group) {
    final match = RegularExpresions.VISIBILITY.firstMatch(group);
    _minimumVisibility = MinimumVisibility(group, match);

    _concatenateString(_minimumVisibility);
  }

  /// Get the minimum visibility data of the METAR.
  MinimumVisibility get minimumVisibility => _minimumVisibility;

  void _handleRunwayRange(String group) {
    final match = RegularExpresions.RUNWAY.firstMatch(group);
    final range = RunwayRange(group, match);

    _runwayRanges.add(range);

    _concatenateString(range);
  }

  /// Get the runway ranges data of the METAR if provided.
  GroupList<RunwayRange> get runwayRanges => _runwayRanges;

  void _parseBody() {
    final handlers = <GroupHandler>[
      GroupHandler(RegularExpresions.TYPE, _handleType),
      GroupHandler(RegularExpresions.STATION, _handleStation),
      GroupHandler(RegularExpresions.TIME, _handleTime),
      GroupHandler(RegularExpresions.MODIFIER, _handleModifier),
      GroupHandler(RegularExpresions.WIND, _handleWind),
      GroupHandler(RegularExpresions.WIND_VARIATION, _handleWindVariation),
      GroupHandler(RegularExpresions.VISIBILITY, _handleVisibility),
      GroupHandler(RegularExpresions.VISIBILITY, _handleMinimumVisibility),
      GroupHandler(RegularExpresions.RUNWAY, _handleRunwayRange),
      GroupHandler(RegularExpresions.RUNWAY, _handleRunwayRange),
      GroupHandler(RegularExpresions.RUNWAY, _handleRunwayRange),
      GroupHandler(RegularExpresions.WEATHER, _handleWeather),
      GroupHandler(RegularExpresions.WEATHER, _handleWeather),
      GroupHandler(RegularExpresions.WEATHER, _handleWeather),
      GroupHandler(RegularExpresions.CLOUD, _handleCloud),
      GroupHandler(RegularExpresions.CLOUD, _handleCloud),
      GroupHandler(RegularExpresions.CLOUD, _handleCloud),
      GroupHandler(RegularExpresions.CLOUD, _handleCloud),
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
