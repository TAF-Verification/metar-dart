part of models;

/// Parser for TAF reports.
class Taf extends Report {
  late final String _body;
  final List<String> _weatherChanges = <String>[];
  late MetarTime _time;

  Taf(String code, {bool truncate = false}) : super(code, truncate) {
    _handleSections();
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
    _time = MetarTime(group, match, year: 2021, month: 2);

    _concatenateString(_time);
  }

  /// Get the time of the TAF.
  MetarTime get time => _time;

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
