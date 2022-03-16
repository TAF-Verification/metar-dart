part of models;

/// Basic structure for significant change periods in TAF.
class ChangeForecast extends Forecast {
  late final Valid _valid;
  late TafChangeIndicator _changeIndicator;
  ChangeForecast(String code, Valid valid) : super(code) {
    // Initialize valid period of the forecasts
    _valid = valid;

    // Groups
    _changeIndicator = TafChangeIndicator(null, null, valid);

    // Parse groups
    _parse();
  }

  void _handleChangeIndicator(String group) {
    final match = TafRegExp.CHANGE_INDICATOR.firstMatch(group);
    _changeIndicator = TafChangeIndicator(group, match, _valid);
  }

  /// Get the change indicator data of the change period.
  TafChangeIndicator get changeIndicator => _changeIndicator;

  void _parse() {
    final handlers = <GroupHandler>[
      GroupHandler(TafRegExp.CHANGE_INDICATOR, _handleChangeIndicator),
    ];

    final sanitizedCode = sanitizeChangeIndicator(_code!);
    final unparsed = parseSection(handlers, sanitizedCode);
    _unparsedGroups.addAll(unparsed);
  }
}

/// Basic structure for weather change periods in TAF.
class TafChangePeriods extends GroupList<ChangeForecast> {
  TafChangePeriods() : super(8);

  @override
  String toString() {
    return _list.join('\n');
  }
}
