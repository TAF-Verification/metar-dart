part of models;

/// Parser for TAF reports.
class Taf extends Report with ModifierMixin, MetarTimeMixin, TafValidMixin {
  late final String _body;
  final List<String> _weatherChanges = <String>[];
  int? _year, _month;

  // Body groups
  Missing _missing = Missing(null);
  Cancelled _cancelled = Cancelled(null);

  Taf(String code, {int? year, int? month, bool truncate = false})
      : super(code, truncate, type: 'TAF') {
    _year = year;
    _month = month;

    _handleSections();

    // Parse the body groups.
    _parseBody();
  }

  /// Get the body part of the TAF.
  String get body => _body;

  /// Get the weather changes of the TAF.
  String get weatherChanges {
    if (_weatherChanges.isNotEmpty) {
      return _weatherChanges.join(' ');
    }

    return '';
  }

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
    ];

    final unparsed = parseSection(handlers, _body);
    _unparsedGroups.addAll(unparsed);
  }

  @override
  void _handleSections() {
    final keywords = <String>['FM', 'TEMPO', 'BECMG', 'PROB'];
    final sections = splitSentence(
      _rawCode,
      keywords,
      space: 'left',
      all: true,
    );

    _body = sections[0];
    if (sections.length > 1) {
      _weatherChanges.addAll(sections.sublist(1));
    }

    _sections.add(_body);
    _sections.add(_weatherChanges.join(' '));
  }
}
