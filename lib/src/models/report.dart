part of models;

abstract class Report {
  String _rawCode = '';
  String _string = '';
  final _unparsedGroups = <String>[];
  final _sections = <String>[];

  Report(String code) : assert(code != '', 'code must be a non-empty string') {
    code = code.trim();

    _rawCode = code.replaceAll(RegExp(r'\s{2,}'), ' ');
    _rawCode = _rawCode.replaceAll('=', '');
  }

  @override
  String toString() {
    return _string;
  }

  void _concatenateString(Object obj) {
    _string += obj.toString() + '\n';
  }

  /// Parse the report groups to extract relevant data.
  void _parse();

  /// Handler to separate the sections of the report.
  void _handleSections();

  /// Get the raw code as its received in the instance.
  String get rawCode => _rawCode;

  /// Get the unparsed groups of the report.
  List<String> get unparsedGroups => _unparsedGroups;

  /// Get the report separated in its sections as a list of strings.
  List<String> get sections => _sections;
}
