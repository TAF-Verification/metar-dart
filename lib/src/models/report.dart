part of models;

/// Basic structure for an aeronautical report from land stations.
abstract class Report {
  late List<String> sections;
  late String _rawCode;
  final _unparsedGroups = <String>[];

  var _string = '';
  Type _type = Type('METAR');
  Station _station = Station(null);
  late int _year, _month;
  Time _time = Time(null);

  Report(String code, {int? year, int? month})
      : assert(code != '', 'code must be a non-empty string') {
    code = code.trim();
    _rawCode = code.replaceAll(RegExp(r'\s{2,}'), ' ');
    if (year != null) {
      _year = year;
    }
    if (month != null) {
      _month = month;
    }
  }

  @override
  String toString() => _string;

  void _concatenateString(Object object) {
    _string += object.toString() + '\n';
  }

  void _handleType(String group) {
    _type = Type(group);

    _concatenateString(_type);
  }

  /// Get the type of the report.
  Type get type => _type;

  void _handleStation(String group) {
    _station = Station(group);

    _concatenateString(_station);
  }

  /// Get the station info of the report.
  Station get station => _station;

  void _handleTime(String group);

  /// Get the time of the report.
  Time get time => _time;

  /// Parse the report groups to extract relevant data.
  void _parse(List<GroupHandler> handlers, String section,
      {String sectionType = 'body'});

  /// Get the unparsed groups of the report.
  String get rawCode => _rawCode;

  /// Get the report separated in its sections as a list of strings.
  List<String> get unparsedGroups => _unparsedGroups;
}
