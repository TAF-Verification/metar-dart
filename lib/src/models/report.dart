abstract class Report {
  String _raw_code = '';
  final _unparsed_groups = <String>[];

  Report(String code) {
    code = code.trim();
    _raw_code = code.replaceAll(RegExp(r'\s{2,}'), ' ');
  }

  void _parse();

  String get raw_code => _raw_code;
  List<String> get unparsed_groups => _unparsed_groups;
}
