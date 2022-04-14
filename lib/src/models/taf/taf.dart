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
        MetarCloudMixin,
        TafWindshearMixin,
        PressureMixin,
        TafTemperatureMixin,
        MetarWindVariationMixin,
        TafTurbulenceMixin,
        TafIcingMixin,
        TafAmendmentsMixin {
  late final String _body;
  final List<String> _changesCodes = <String>[];
  int? _year, _month;

  // Body groups
  Missing _missing = Missing(null);
  Cancelled _cancelled = Cancelled(null);
  DateTime? _correctionTime, _amendedTime;
  AutomatedSensorMetwatch? _automatedSensorMetwatch;

  // Change periods
  final _changePeriods = TafChangePeriods();

  Taf(String code, {int? year, int? month, bool truncate = false})
      : super(removeUnnecessaryTokens(code), truncate, type: 'TAF') {
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

  /// Get correction time of the TAF
  DateTime? get correctionTime => _correctionTime;
  DateTime? get amendedTime => _amendedTime;
  void _handleCorrection(String group) {
    final match = TafRegExp.CORRECTION.firstMatch(group);

    if (match != null) {
      final mod = match.namedGroup('mod');
      final h = int.tryParse(match.namedGroup('h') ?? '');
      final m = int.tryParse(match.namedGroup('m') ?? '');
      final n = DateTime.now().toUtc();
      if (h == null || m == null) return;
      if (mod == 'COR') {
        _correctionTime = DateTime(n.year, n.month, n.day, h, m);
        _concatenateString('Corrected forecast at $_correctionTime\n');
      } else if (mod == 'AMD') {
        _amendedTime = DateTime(n.year, n.month, n.day, h, m);
        _concatenateString('Amended forecast at $_correctionTime\n');
      }
    }
  }

  /// Get Automated sensor metwatch times
  AutomatedSensorMetwatch? get automatedSensorMetwatch =>
      _automatedSensorMetwatch;
  void _handleAutomatedSensorMetwatch(String group) {
    final match = TafRegExp.AUTOMATED_SENSOR_METWATCH.firstMatch(group);

    if (match != null) {
      _automatedSensorMetwatch = AutomatedSensorMetwatch(group, match);
      _concatenateString(_automatedSensorMetwatch!);
    }
  }

  /// Get the cancelled group data of the TAF.
  Cancelled get cancelled => _cancelled;

  void _handleChangePeriod(String code) {
    final cf = ChangeForecast(code, _valid);
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
      GroupHandler(TafRegExp.TURBULENCE, _handleTurbulence),
      GroupHandler(TafRegExp.ICING, _handleIcing),
      GroupHandler(TafRegExp.TURBULENCE, _handleTurbulence),
      GroupHandler(TafRegExp.ICING, _handleIcing),
      GroupHandler(TafRegExp.TURBULENCE, _handleTurbulence),
      GroupHandler(TafRegExp.ICING, _handleIcing),
      GroupHandler(MetarRegExp.PRESSURE, _handlePressure),
      GroupHandler(MetarRegExp.PRESSURE, _handlePressure),
      GroupHandler(TafRegExp.WIND, _handleWind),
      GroupHandler(MetarRegExp.WIND_VARIATION, _handleWindVariation),
      GroupHandler(TafRegExp.TEMPERATURE,
          (e) => _handleTemperature(e, time: _time.time)),
      GroupHandler(TafRegExp.TEMPERATURE,
          (e) => _handleTemperature(e, time: _time.time)),
      GroupHandler(TafRegExp.TEMPERATURE,
          (e) => _handleTemperature(e, time: _time.time)),
      GroupHandler(TafRegExp.TEMPERATURE,
          (e) => _handleTemperature(e, time: _time.time)),
      GroupHandler(TafRegExp.WINDSHEAR, _handleWindshear),
      GroupHandler(TafRegExp.CORRECTION, _handleCorrection),
      GroupHandler(
          TafRegExp.AUTOMATED_SENSOR_METWATCH, _handleAutomatedSensorMetwatch),
      GroupHandler(TafRegExp.AMENDMENTS, _handleAmendment),
    ];

    var body = sanitizeWindToken(_body);
    body = sanitizeVisibility(body);
    body = sanitizeAmendments(body);

    final unparsed = parseSection(handlers, body);
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

    var b = '';
    if (sections.length > 1) {
      _changesCodes.addAll(sections.sublist(1));

      // Extract final info from the change periods and append it to the body
      b = _extractInfoFromChangePeriods(b, _changesCodes);
    }
    _body = '${sections[0]}$b';

    _sections.add(_body);
    _sections.add(_changesCodes
        .map((change) => change.replaceFirst('_', ' '))
        .toList()
        .join(' '));
  }

  static String removeUnnecessaryTokens(String code) {
    return code.replaceAll(RegExp(r' (FN|FS)\d{5}'), '');
  }

  String _extractInfoFromChangePeriods(String b, List<String> changesCodes) {
    final l = _changesCodes.length - 1;
    if (_changesCodes[l].contains(TafRegExp.CORRECTION_UNSANITIZED)) {
      final lastFor = _changesCodes[l];
      final match = TafRegExp.CORRECTION_UNSANITIZED.firstMatch(lastFor)!;
      b +=
          ' ${match.namedGroup('mod')}_${match.namedGroup('h')}${match.namedGroup('m')}';
      _changesCodes[l] = lastFor
          .replaceFirst(TafRegExp.CORRECTION_UNSANITIZED, '')
          .trimRight();
    }

    if (_changesCodes[l]
        .contains(TafRegExp.AUTOMATED_SENSOR_METWATCH_UNSANITIZED)) {
      final lastFor = _changesCodes[l];
      final match =
          TafRegExp.AUTOMATED_SENSOR_METWATCH_UNSANITIZED.firstMatch(lastFor)!;
      b +=
          ' AUTOMATED_SENSOR_METWATCH_${match.namedGroup('f')}_TIL_${match.namedGroup('t')}';
      _changesCodes[l] = lastFor
          .replaceFirst(TafRegExp.AUTOMATED_SENSOR_METWATCH_UNSANITIZED, '')
          .trimRight();
    }

    return b;
  }
}

String daySuffix(int day) {
  switch (day) {
    case 1:
    case 21:
    case 31:
      return 'st';
    case 2:
    case 22:
      return 'nd';
    case 3:
    case 23:
      return 'rd';
    default:
      return 'th';
  }
}
