import 'package:metar_dart/src/models/models.dart';
import 'package:metar_dart/src/utils/utils.dart';

class Metar extends Report {
  //Type _type;
  MetarSections _sections;

  Metar(String code, {int year, int month}) : super(code) {
    if (code.isEmpty || code == null) {
      throw ParserError('METAR code must be not null or not empty string');
    }

    _sections = MetarSections(raw_code);
  }

  List<String> get sections => _sections.sections;
  String get body => _sections.body;
  String get trend => _sections.trend;
  String get remark => _sections.remark;
}
