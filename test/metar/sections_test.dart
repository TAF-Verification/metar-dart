import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final TEXT = '\t\t\tVAR\n\n';
  final toReplace = 'VAR';

  test('Test the sections of the METAR with weather trend NOSIG', () {
    final code =
        'METAR MROC 181500Z 09012G23KT 050V110 9999 FEW035 SCT130 BKN200 27/18 A3004 RMK TS TO S NOSIG';
    final metar = Metar(TEXT.replaceFirst(toReplace, code));
    final sections = [
      'METAR MROC 181500Z 09012G23KT 050V110 9999 FEW035 SCT130 BKN200 27/18 A3004',
      'NOSIG',
      'RMK TS TO S',
    ];
    expect(metar.sections, sections);
    expect(metar.body, sections[0]);
    expect(metar.trend, sections[1]);
    expect(metar.remark, sections[2]);
  });

  test('Test the sections of the METAR with weather trend TEMPO', () {
    final code =
        'METAR MMTJ 180842Z 12006KT 7SM SKC 11/M04 A3027\tTEMPO 25005KT 5SM HZ\tRMK SLP258 54000 941';
    final metar = Metar(TEXT.replaceFirst(toReplace, code));
    final sections = [
      'METAR MMTJ 180842Z 12006KT 7SM SKC 11/M04 A3027',
      'TEMPO 25005KT 5SM HZ',
      'RMK SLP258 54000 941',
    ];
    expect(metar.sections, sections);
    expect(metar.body, sections[0]);
    expect(metar.trend, sections[1]);
    expect(metar.remark, sections[2]);
  });

  test('Test the sections of the METAR with two weather trends', () {
    final code =
        'SPECI LTBG 181003Z VRB02KT 9999 -SHRA BKN030 BKN100 09/09 Q1013 RESHRA\nBECMG TL1045 RA TEMPO FM1100 DZ RMK RWY18 04006KT 360V070';
    final metar = Metar(TEXT.replaceFirst(toReplace, code));
    final sections = [
      'SPECI LTBG 181003Z VRB02KT 9999 -SHRA BKN030 BKN100 09/09 Q1013 RESHRA',
      'BECMG TL1045 RA TEMPO FM1100 DZ',
      'RMK RWY18 04006KT 360V070',
    ];
    expect(metar.sections, sections);
    expect(metar.body, sections[0]);
    expect(metar.trend, sections[1]);
    expect(metar.remark, sections[2]);
  });
}
