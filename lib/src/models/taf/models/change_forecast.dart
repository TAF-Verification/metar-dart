part of models;

/// Basic structure for significant change periods in TAF.
class ChangeForecast extends Forecast {
  late final Valid _valid;
  late TafChangeIndicator _changeIndicator;
  final Null Function(String warning) onWarning;
  ChangeForecast(String code, Valid valid, {required this.onWarning})
      : super(code) {
    // Initialize valid period of the forecasts
    _valid = valid;
    _code = code;

    // Groups
    _changeIndicator = TafChangeIndicator(null, null, valid);

    // Parse groups
    _parse();
  }

  @override
  String toString() {
    _string = '';
    _concatenateString(_changeIndicator);

    return _string;
  }

  void _handleChangeIndicator(String group) {
    final match = TafRegExp.CHANGE_INDICATOR.firstMatch(group);
    _changeIndicator = TafChangeIndicator(group, match, _valid);
  }

  /// Get the change indicator data of the change period.
  TafChangeIndicator get changeIndicator => _changeIndicator;

  void _handleValidPeriod(String group) {
    final match = TafRegExp.VALID.firstMatch(group);
    _changeIndicator.setValidPeriod(group, match!, _valid.periodFrom);
  }

  void _parse() {
    final handlers = <GroupHandler>[
      GroupHandler(TafRegExp.CHANGE_INDICATOR, _handleChangeIndicator),
      GroupHandler(TafRegExp.VALID, _handleValidPeriod),
      GroupHandler(TafRegExp.WIND, _handleWind),
      GroupHandler(MetarRegExp.VISIBILITY, _handlePrevailing),
      GroupHandler(MetarRegExp.WEATHER, _handleWeather),
      GroupHandler(MetarRegExp.WEATHER, _handleWeather),
      GroupHandler(MetarRegExp.WEATHER, _handleWeather),
      GroupHandler(MetarRegExp.VISIBILITY, _handlePrevailing),
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
      GroupHandler(TafRegExp.WINDSHEAR, _handleWindshear),
      GroupHandler(TafRegExp.TURBULENCE, _handleTurbulence),
      GroupHandler(TafRegExp.ICING, _handleIcing),
      GroupHandler(MetarRegExp.PRESSURE, _handlePressure),
      GroupHandler(MetarRegExp.PRESSURE, _handlePressure),
      GroupHandler(TafRegExp.WIND, _handleWind),
      GroupHandler(TafRegExp.AMMENDMENTS, _handleAmmendment),
      GroupHandler(TafRegExp.TEMPERATURE,
          (e) => _handleTemperature(e, time: _valid.periodFrom.time)),
      GroupHandler(TafRegExp.TEMPERATURE,
          (e) => _handleTemperature(e, time: _valid.periodFrom.time)),
      GroupHandler(TafRegExp.TEMPERATURE,
          (e) => _handleTemperature(e, time: _valid.periodFrom.time)),
      GroupHandler(TafRegExp.TEMPERATURE,
          (e) => _handleTemperature(e, time: _valid.periodFrom.time)),
      GroupHandler(TafRegExp.WINDSHEAR, _handleWindshear),
    ];

    var sanitizedCode = sanitizeChangeIndicator(_code!);
    sanitizedCode = sanitizeVisibility(sanitizedCode);
    sanitizedCode = sanitizeWindToken(sanitizedCode);
    sanitizedCode = sanitizeAmmendments(sanitizedCode);
    final unparsed =
        parseSection(handlers, sanitizedCode, onWarning: onWarning);
    _unparsedGroups.addAll(unparsed);
  }
}

/// Basic structure for weather change periods in TAF.
class TafChangePeriods extends GroupList<ChangeForecast> {
  TafChangePeriods() : super(20);

  @override
  String toString() {
    return _list.join('\n');
  }

  /// Adds weather changes to the list.
  @override
  void add(ChangeForecast newChange) {
    if (_list.isNotEmpty) {
      if (newChange.code!.startsWith('FM') ||
          newChange.code!.startsWith('BECMG')) {
        final tempChanges = <ChangeForecast>[];

        var lastChange = _list.removeLast();
        while (true) {
          if (lastChange.changeIndicator.code!.startsWith('PROB') ||
              lastChange.changeIndicator.code!.startsWith('TEMPO')) {
            tempChanges.add(lastChange);
            try {
              lastChange = _list.removeLast();
            } catch (e) {
              break;
            }
          } else if (lastChange.changeIndicator.code!.startsWith('FM')) {
            lastChange.changeIndicator
                .resetUntilPeriod(newChange.changeIndicator.valid.periodFrom);
            tempChanges.add(lastChange);
            break;
          } else {
            tempChanges.add(lastChange);
            break;
          }
        }

        for (final tempChange in tempChanges.reversed) {
          super.add(tempChange);
        }
      }
    }

    super.add(newChange);
  }
}
