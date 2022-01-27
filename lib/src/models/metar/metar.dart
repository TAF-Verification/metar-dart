part of models;

/// Parser for METAR reports.
class Metar extends Report
    with
        ModifierMixin,
        MetarWindMixin,
        MetarPrevailingMixin,
        MetarWeatherMixin {
  late MetarTime _time;
  late final int? _year, _month;

  // Groups
  WindVariation _windVariation = WindVariation(null, null);
  MetarMinimumVisibility _minimumVisibility =
      MetarMinimumVisibility(null, null);
  final _runwayRanges = GroupList<MetarRunwayRange>(3);

  Metar(
    String code, {
    int? year,
    int? month,
    bool truncate = false,
  }) : super(code, truncate) {
    _handleSections();

    _year = year;
    _month = month;

    // Parse groups
    _parseBody();
  }

  /// Get the body part of the METAR.
  String get body => _sections[0];

  /// Get the trend part of the METAR.
  String get trend => _sections[1];

  /// Get the remark part of the METAR.
  String get remark => _sections[2];

  @override
  void _handleTime(String group) {
    final match = MetarRegExp.TIME.firstMatch(group);
    _time = MetarTime(group, match, year: _year, month: _month);

    _concatenateString(_time);
  }

  /// Get the time of the group.
  MetarTime get time => _time;

  void _handleWindVariation(String group) {
    final match = MetarRegExp.WIND_VARIATION.firstMatch(group);
    _windVariation = WindVariation(group, match);

    _concatenateString(_windVariation);
  }

  /// Get the wind variation directions of the METAR.
  WindVariation get windVariation => _windVariation;

  void _handleMinimumVisibility(String group) {
    final match = MetarRegExp.VISIBILITY.firstMatch(group);
    _minimumVisibility = MetarMinimumVisibility(group, match);

    _concatenateString(_minimumVisibility);
  }

  /// Get the minimum visibility data of the METAR.
  MetarMinimumVisibility get minimumVisibility => _minimumVisibility;

  void _handleRunwayRange(String group) {
    final match = MetarRegExp.RUNWAY_RANGE.firstMatch(group);
    final range = MetarRunwayRange(group, match);
    _runwayRanges.add(range);

    _concatenateString(range);
  }

  /// Get the runway ranges data of the METAR if provided.
  GroupList<MetarRunwayRange> get runwayRanges => _runwayRanges;

  void _parseBody() {
    final handlers = <GroupHandler>[
      GroupHandler(MetarRegExp.TYPE, _handleType),
      GroupHandler(MetarRegExp.STATION, _handleStation),
      GroupHandler(MetarRegExp.TIME, _handleTime),
      GroupHandler(MetarRegExp.MODIFIER, _handleModifier),
      GroupHandler(MetarRegExp.WIND, _handleWind),
      GroupHandler(MetarRegExp.WIND_VARIATION, _handleWindVariation),
      GroupHandler(MetarRegExp.VISIBILITY, _handlePrevailing),
      GroupHandler(MetarRegExp.VISIBILITY, _handleMinimumVisibility),
      GroupHandler(MetarRegExp.RUNWAY_RANGE, _handleRunwayRange),
      GroupHandler(MetarRegExp.RUNWAY_RANGE, _handleRunwayRange),
      GroupHandler(MetarRegExp.RUNWAY_RANGE, _handleRunwayRange),
      GroupHandler(MetarRegExp.WEATHER, _handleWeather),
      GroupHandler(MetarRegExp.WEATHER, _handleWeather),
      GroupHandler(MetarRegExp.WEATHER, _handleWeather),
    ];

    _parse(handlers, body);
  }

  @override
  void _parse(List<GroupHandler> handlers, String section,
      {String sectionType = 'body'}) {
    var index = 0;

    section = sanitizeVisibility(section);
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
