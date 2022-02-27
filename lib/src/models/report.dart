part of models;

abstract class Report with StringAttributeMixin {
  final bool _truncate;
  String _rawCode = '';
  final _unparsedGroups = <String>[];
  final _sections = <String>[];

  // Type group
  late Type _type;

  // Station group
  Station _station = Station(null, null);

  Report(String code, this._truncate, {String type = 'METAR'})
      : assert(code != '', 'code must be a non-empty string') {
    code = code.trim();

    _type = Type(type);

    _rawCode = code.replaceAll(RegExp(r'\s{2,}|\n+|\t+'), ' ');
    _rawCode = _rawCode.replaceAll('=', '');
  }

  /// Handler to separate the sections of the report.
  void _handleSections();

  void _handleType(String group) {
    _type = Type(group);

    _concatenateString(_type);
  }

  /// Get the type of the report.
  Type get type => _type;

  void _handleStation(String group) {
    _station = Station(group, 'ICAO');

    _concatenateString(_station);
  }

  /// Get the station data of the report.
  Station get station => _station;

  void _handleTime(String group);

  /// Get the raw code as its received in the instance.
  String get rawCode => _rawCode;

  /// Get the unparsed groups of the report.
  List<String> get unparsedGroups => _unparsedGroups;

  /// Get the report separated in its sections as a list of strings.
  List<String> get sections => _sections;
}
