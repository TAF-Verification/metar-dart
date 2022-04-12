part of models;

/// Parser for METAR reports.
class Metar extends Report
    with
        ModifierMixin,
        MetarTimeMixin,
        MetarWindMixin,
        MetarPrevailingMixin,
        MetarWeatherMixin,
        MetarCloudMixin {
  late final int? _year, _month;

  // Body groups
  MetarWindVariation _windVariation = MetarWindVariation(null, null);
  MetarMinimumVisibility _minimumVisibility =
      MetarMinimumVisibility(null, null);
  final _runwayRanges = GroupList<MetarRunwayRange>(3);
  MetarTemperatures _temperatures = MetarTemperatures(null, null);
  MetarPressure _pressure = MetarPressure(null, null);
  MetarRecentWeather _recentWeather = MetarRecentWeather(null, null);
  final _windshear = MetarWindshearList();
  MetarSeaState _seaState = MetarSeaState(null, null);
  MetarRunwayState _runwayState = MetarRunwayState(null, null);

  // Trend groups
  final MetarWeatherTrends _weatherTrends = MetarWeatherTrends();

  Metar(
    String code, {
    int? year,
    int? month,
    bool truncate = false,
  }) : super(code, truncate) {
    _handleSections();

    _year = year;
    _month = month;

    // Parse body groups
    _parseBody();

    // Parse trend groups
    _parseWeatherTrend();
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

  /// Get the time of the METAR.
  MetarTime get time => _time;

  void _handleWindVariation(String group) {
    final match = MetarRegExp.WIND_VARIATION.firstMatch(group);
    _windVariation = MetarWindVariation(group, match);

    _concatenateString(_windVariation);
  }

  /// Get the wind variation directions of the METAR.
  MetarWindVariation get windVariation => _windVariation;

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

  void _handleTemperatures(String group) {
    final match = MetarRegExp.TEMPERATURES.firstMatch(group);
    _temperatures = MetarTemperatures(group, match);

    _concatenateString(_temperatures);
  }

  /// Get the temperatures data of the METAR.
  MetarTemperatures get temperatures => _temperatures;

  void _handlePressure(String group) {
    final match = MetarRegExp.PRESSURE.firstMatch(group);
    _pressure = MetarPressure(group, match);

    _concatenateString(_pressure);
  }

  /// Get the pressure of the METAR.
  MetarPressure get pressure => _pressure;

  void _handleRecentWeather(String group) {
    final match = MetarRegExp.RECENT_WEATHER.firstMatch(group);
    _recentWeather = MetarRecentWeather(group, match);

    _concatenateString(_recentWeather);
  }

  /// Get the recent weather data of the METAR.
  MetarRecentWeather get recentWeather => _recentWeather;

  void _handleWindshearRunway(String group) {
    final match = MetarRegExp.WINDSHEAR_RUNWAY.firstMatch(group);
    final windshear = MetarWindshearRunway(group, match);
    _windshear.add(windshear);

    _concatenateString(windshear);
  }

  /// Get the windshear data of the METAR.
  MetarWindshearList get windshear => _windshear;

  void _handleSeaState(String group) {
    final match = MetarRegExp.SEA_STATE.firstMatch(group);
    _seaState = MetarSeaState(group, match);

    _concatenateString(_seaState);
  }

  /// Get the sea state data of the METAR.
  MetarSeaState get seaState => _seaState;

  void _handleRunwayState(String group) {
    final match = MetarRegExp.RUNWAY_STATE.firstMatch(group);
    _runwayState = MetarRunwayState(group, match);

    _concatenateString(_runwayState);
  }

  /// Get the runway state data of the METAR.
  MetarRunwayState get runwayState => _runwayState;

  void _handleWeatherTrend(String code) {
    final wt = ChangePeriod(code, _time.time);
    _weatherTrends.add(wt);

    _concatenateString(wt);
  }

  /// Get the weather trends of the METAR if provided.
  MetarWeatherTrends get weatherTrends => _weatherTrends;

  /// Parse the body section.
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
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
      GroupHandler(MetarRegExp.TEMPERATURES, _handleTemperatures),
      GroupHandler(MetarRegExp.PRESSURE, _handlePressure),
      GroupHandler(MetarRegExp.RECENT_WEATHER, _handleRecentWeather),
      GroupHandler(MetarRegExp.WINDSHEAR_RUNWAY, _handleWindshearRunway),
      GroupHandler(MetarRegExp.WINDSHEAR_RUNWAY, _handleWindshearRunway),
      GroupHandler(MetarRegExp.WINDSHEAR_RUNWAY, _handleWindshearRunway),
      GroupHandler(MetarRegExp.SEA_STATE, _handleSeaState),
      GroupHandler(MetarRegExp.RUNWAY_STATE, _handleRunwayState),
    ];

    var sanitizedBody = sanitizeVisibility(body);
    sanitizedBody = sanitizeWindshear(sanitizedBody);

    final unparsed = parseSection(handlers, sanitizedBody);
    _unparsedGroups.addAll(unparsed);
  }

  /// Parse the weather trend section.
  ///
  /// Raises:
  ///     ParserError: if self.unparser_groups has items and self._truncate is True,
  ///     raises the error.
  void _parseWeatherTrend() {
    final _trends = splitSentence(trend, ['TEMPO', 'BECMG'], space: 'both');

    for (final trend in _trends) {
      if (trend != '') {
        _handleWeatherTrend(trend);
      }
    }

    for (final wt in _weatherTrends.items) {
      _unparsedGroups.addAll(wt.unparsedGroups);
    }

    if (unparsedGroups.isNotEmpty && _truncate) {
      throw ParserError(
        'failed while processing ${unparsedGroups.join(" ")} from: $rawCode',
      );
    }
  }

  @override
  void _handleSections() {
    final sections = splitSentence(
      _rawCode,
      <String>[
        'NOSIG',
        'TEMPO',
        'BECMG',
        'RMK',
      ],
      space: 'left',
    );

    var trend = '';
    var remark = '';
    var body = '';
    for (final section in sections) {
      if (section.startsWith('TEMPO') ||
          section.startsWith('BECMG') ||
          section.startsWith('NOSIG')) {
        trend += section + ' ';
      } else if (section.startsWith('RMK')) {
        remark = section;
      } else {
        body = section;
      }
    }

    _sections.add(body);
    _sections.add(trend.trim());
    _sections.add(remark);
  }
}
