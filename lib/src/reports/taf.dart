part of reports;

/// Parser for TAF reports.
class Taf extends Report
    with
        ModifierMixin,
        TafValidMixin,
        MetarWindMixin,
        MetarPrevailingMixin,
        MetarWeatherMixin,
        MetarCloudMixin,
        FlightRulesMixin {
  late final String _body;
  final List<String> _changesCodes = <String>[];
  int? _year, _month;

  // Body groups
  Missing _missing = Missing(null);
  Cancelled _cancelled = Cancelled(null);
  final _maxTemperatures = TafTemperatureList();
  final _minTemperatures = TafTemperatureList();

  // Change periods
  final _changesForecasted = TafChangesForecasted();

  Taf(String code, {int? year, int? month, bool truncate = false})
      : super(code, truncate, type: 'TAF') {
    _year = year;
    _month = month;

    _handleSections();

    _valid = Valid.fromTaf(null, null, _time.time);

    // Parse the body groups.
    _parseBody();

    // Parse the change periods
    _parseChangesForecasted();
  }

  /// Get the body part of the TAF.
  String get body => _body;

  /// Get the weather changes of the TAF.
  String get weatherChanges => _sections[1];

  @override
  void _handleTime(String group) {
    final match = MetarRegExp.TIME.firstMatch(group)!;
    _time =
        Time.fromMetar(code: group, match: match, year: _year, month: _month);

    _concatenateString(_time);
  }

  void _handleMissing(String group) {
    _missing = Missing(group);

    _concatenateString(_missing);
  }

  /// Get the missing data of the TAF.
  Missing get missing => _missing;

  void _handleCancelled(String group) {
    _cancelled = Cancelled(group);

    _concatenateString(_cancelled);
  }

  /// Get the cancelled group data of the TAF.
  Cancelled get cancelled => _cancelled;

  void _handleTemperature(String group) {
    final match = TafRegExp.TEMPERATURE.firstMatch(group);
    final temperature = TafTemperature(group, match, _time.time);

    if (match!.namedGroup('type') == 'X') {
      _maxTemperatures.add(temperature);
    } else {
      _minTemperatures.add(temperature);
    }

    _concatenateString(temperature);
  }

  /// Get the maximum temperature expected to happen.
  TafTemperatureList get maxTemperatures => _maxTemperatures;

  /// Get the minimum temperature expected to happen.
  TafTemperatureList get minTemperatures => _minTemperatures;

  void _handleChangeForecasted(String code) {
    final cf = ChangeForecasted(code, _valid);
    if (_changesForecasted.length > 0) {
      if (cf.code!.startsWith('FM') || cf.code!.startsWith('BECMG')) {
        _changesForecasted.last.changeIndicator
            .resetUntilPeriod(cf.changeIndicator.valid.periodUntil);
      }
    }
    _changesForecasted.add(cf);

    _concatenateString(cf);
  }

  /// Get the weather change periods data of the TAF if provided.
  TafChangesForecasted get changesForecasted => _changesForecasted;

  /// Parse the body section.
  void _parseBody() {
    final handlers = <GroupHandler>[
      GroupHandler(MetarRegExp.TYPE, _handleType),
      GroupHandler(TafRegExp.AMD_COR, _handleModifier),
      GroupHandler(MetarRegExp.STATION, _handleStation),
      GroupHandler(MetarRegExp.TIME, _handleTime),
      GroupHandler(TafRegExp.NIL, _handleMissing),
      GroupHandler(TafRegExp.VALID, _handleValidPeriod),
      GroupHandler(TafRegExp.CANCELLED, _handleCancelled),
      GroupHandler(TafRegExp.WIND, _handleWind),
      GroupHandler(TafRegExp.VISIBILITY, _handlePrevailing),
      GroupHandler(MetarRegExp.WEATHER, _handleWeather),
      GroupHandler(MetarRegExp.WEATHER, _handleWeather),
      GroupHandler(MetarRegExp.WEATHER, _handleWeather),
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
      GroupHandler(MetarRegExp.CLOUD, _handleCloud),
      GroupHandler(TafRegExp.TEMPERATURE, _handleTemperature),
      GroupHandler(TafRegExp.TEMPERATURE, _handleTemperature),
      GroupHandler(TafRegExp.TEMPERATURE, _handleTemperature),
      GroupHandler(TafRegExp.TEMPERATURE, _handleTemperature),
    ];

    final unparsed = parseSection(handlers, _body);
    _unparsedGroups.addAll(unparsed);
  }

  void _parseChangesForecasted() {
    for (final change in _changesCodes) {
      if (change != '') {
        _handleChangeForecasted(change);
      }
    }

    for (final cp in _changesForecasted.items) {
      _unparsedGroups.addAll(cp.unparsedGroups);
    }

    if (unparsedGroups.isNotEmpty && _truncate) {
      throw ParserError(
        'failed while processing ${unparsedGroups.join(" ")} from: $rawCode',
      );
    }
  }

  @override
  void _handleSections() {
    final keywords = <String>['FM', 'TEMPO', 'BECMG', 'PROB'];
    var sanitizedCode = sanitizeChangeIndicator(_rawCode);
    if (sanitizedCode.startsWith('TAF')) {
      sanitizedCode = sanitizedCode.replaceFirst('TAF ', 'TAF_');
    }
    final sections = splitSentence(
      sanitizedCode,
      keywords,
      space: 'left',
      all: true,
    );
    sections[0] = sections[0].replaceFirst('TAF_', 'TAF ');

    _body = sections[0];
    if (sections.length > 1) {
      _changesCodes.addAll(sections.sublist(1));
    }

    _sections.add(_body);
    _sections.add(_changesCodes
        .map((change) => change.replaceFirst('_', ' '))
        .toList()
        .join(' '));
  }

  @override
  Map<String, Object?> asMap() {
    final map = super.asMap();
    map.addAll({
      'modifier': modifier.asMap(),
      'missing': missing.asMap(),
      'valid': valid.asMap(),
      'cancelled': cancelled.asMap(),
      'wind': wind.asMap(),
      'prevailing_visibility': prevailingVisibility.asMap(),
      'weathers': weathers.asMap(),
      'clouds': clouds.asMap(),
      'max_temperatures': maxTemperatures.asMap(),
      'min_temperatures': minTemperatures.asMap(),
      'changes_forecasted': changesForecasted.asMap(),
    });
    return map;
  }
}
