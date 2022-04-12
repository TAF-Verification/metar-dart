part of models;

/// Parser for TAF reports.
class Taf extends Report
    with
        ModifierMixin,
        MetarTimeMixin,
        TafValidMixin,
        MetarWindMixin,
        MetarPrevailingMixin,
        MetarWeatherMixin,
        MetarCloudMixin {
  late final String _body;
  final List<String> _changesCodes = <String>[];
  int? _year, _month;

  // Body groups
  Missing _missing = Missing(null);
  Cancelled _cancelled = Cancelled(null);
  final _maxTemperatures = TafTemperatureList();
  final _minTemperatures = TafTemperatureList();

  List<String> warnings = [];

  // Change periods
  final _changePeriods = TafChangePeriods();

  Taf(String code, {int? year, int? month, bool truncate = false})
      : super(code, truncate, type: 'TAF') {
    _year = year;
    _month = month;

    _handleSections();

    _valid = Valid.fromTaf(null, null, _time.time);

    // Parse the body groups.
    _parseBody();

    // Parse the change periods
    _parseChangePeriods();
  }

  /// Get the body part of the TAF.
  String get body => _body;

  /// Get the weather changes of the TAF.
  String get weatherChanges => _sections[1];

  @override
  void _handleTime(String group) {
    final match = MetarRegExp.TIME.firstMatch(group);
    _time = MetarTime(group, match, year: _year, month: _month);

    _concatenateString(_time);
  }

  /// Get the time of the TAF.
  MetarTime get time => _time;

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

  void _handleChangePeriod(String code) {
    final cf = ChangeForecast(
      code,
      _valid,
      onWarning: (warning) {
        warnings.add(warning);
      },
    );
    if (_changePeriods.length > 0) {
      if (cf.code!.startsWith('FM') || cf.code!.startsWith('BECMG')) {
        _changePeriods.last.changeIndicator
            .resetUntilPeriod(cf.changeIndicator.valid.periodUntil);
      }
    }
    _changePeriods.add(cf);

    _concatenateString(cf);
  }

  /// Get the weather change periods data of the TAF if provided.
  TafChangePeriods get changePeriods => _changePeriods;

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

    final unparsed = parseSection(handlers, _body, onWarning: (warning) {
      warnings.add(warning);
    });
    _unparsedGroups.addAll(unparsed);
  }

  void _parseChangePeriods() {
    for (final change in _changesCodes) {
      if (change != '') {
        _handleChangePeriod(change);
      }
    }

    for (final cp in _changePeriods.items) {
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
}
