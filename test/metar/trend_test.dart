import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test NOSIG code', () {
    final code =
        'METAR SEQM 050400Z 04010KT 9999 BKN006 OVC030 14/12 Q1028 NOSIG RMK A3037';
    final metar = Metar(code);
    final trend = metar.trend;

    expect(trend.code, 'NOSIG');
    expect(trend.translation, 'no significant changes');
  });

  test('Test TEMPO code', () {
    final code =
        'SPECI MMMX 051347Z 07006KT 5SM SKC 05/02 A3044 TEMPO 3SM HZ RMK HZY ISOL SC LWR VSBY N';
    final metar = Metar(code);
    final trend = metar.trend;

    expect(trend.code, 'TEMPO');
    expect(trend.translation, 'temporary');
  });

  test('Test BECMG code', () {
    final code = 'SPECI LYTV 040930Z VRB02KT CAVOK 12/M01 Q1023 BECMG 14005KT';
    final metar = Metar(code);
    final trend = metar.trend;

    expect(trend.code, 'BECMG');
    expect(trend.translation, 'becoming');
  });
}
