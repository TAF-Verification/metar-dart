part of reports;

/// Basic structure for change periods and forecasts in METAR and TAF respectively.
class Forecast extends Group
    with
        StringAttributeMixin,
        MetarWindMixin,
        MetarPrevailingMixin,
        MetarWeatherMixin,
        MetarCloudMixin,
        FlightRulesMixin,
        ShouldBeCavokMixin {
  final _unparsedGroups = <String>[];
  Forecast(String code) : super(code);

  /// Get the unparsed groups of the change period.
  List<String> get unparsedGroups => _unparsedGroups;

  @override
  Map<String, Object?> asMap() {
    final map = {
      'wind': _wind.asMap(),
      'prevailing_visibility': _prevailing.asMap(),
      'weathers': weathers.items.map((weather) => weather.asMap()).toList(),
      'clouds': clouds.items.map((cloud) => cloud.asMap()).toList(),
      'flight_rules': flightRules,
    };
    map.addAll(super.asMap());
    return map;
  }
}

/// Basic structure for change period of trend in METAR.
class ChangePeriod extends Forecast {
  late final Time _time;
  late MetarTrendIndicator _changeIndicator;

  ChangePeriod(String code, DateTime time) : super(code) {
    _time = Time(time: time);
    // Groups
    _changeIndicator = MetarTrendIndicator(null, null, _time.time);

    // Parse the groups
    _parse();
  }

  void _handleTrendIndicator(String group) {
    final match = MetarRegExp.CHANGE_INDICATOR.firstMatch(group);
    _changeIndicator = MetarTrendIndicator(group, match, _time.time);

    _concatenateString(_changeIndicator);
  }

  /// Get the trend data of the METAR.
  MetarTrendIndicator get trendIndicator => _changeIndicator;

  void _handleTimePeriod(String group) {
    final oldChangeIndicator = _changeIndicator.toString();
    final match = MetarRegExp.TREND_TIME_PERIOD.firstMatch(group);
    _changeIndicator.addPeriod(group, match!);
    final newChangeIndicator = _changeIndicator.toString();

    _string = _string.replaceFirst(oldChangeIndicator, newChangeIndicator);
  }

  void _parse() {
    final handlers = <GroupHandler>[
      GroupHandler(MetarRegExp.CHANGE_INDICATOR, _handleTrendIndicator),
      GroupHandler(MetarRegExp.TREND_TIME_PERIOD, _handleTimePeriod),
      GroupHandler(MetarRegExp.TREND_TIME_PERIOD, _handleTimePeriod),
      GroupHandler(MetarRegExp.WIND, _handleWind),
      GroupHandler(MetarRegExp.VISIBILITY, _handlePrevailing),
      GroupHandler(MetarRegExp.WEATHER, _handleWeather),
      GroupHandler(MetarRegExp.WEATHER, _handleWeather),
      GroupHandler(MetarRegExp.WEATHER, _handleWeather),
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
    ];

    final sanitizedCode = sanitizeVisibility(_code!);
    final unparsed = parseSection(handlers, sanitizedCode);
    _unparsedGroups.addAll(unparsed);
  }
}

/// Basic structure for weather trends sections in METAR.
class MetarWeatherTrends extends GroupList<ChangePeriod> {
  MetarWeatherTrends() : super(2);

  @override
  String toString() {
    return _list.join('\n');
  }
}
