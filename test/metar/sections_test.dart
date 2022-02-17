import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final code =
      '\t\t\tMETAR MROC 181500Z 09012G23KT 050V110 9999 FEW035 SCT130 BKN200 27/18 A3004 RMK TS TO S NOSIG\n\n';
  final metar = Metar(code);
  final sections = [
    'METAR MROC 181500Z 09012G23KT 050V110 9999 FEW035 SCT130 BKN200 27/18 A3004',
    'NOSIG',
    'RMK TS TO S',
  ];

  test('Test the sections of the METAR', () {
    expect(metar.sections, sections);
    expect(metar.body, sections[0]);
    expect(metar.trend, sections[1]);
    expect(metar.remark, sections[2]);
  });
}
