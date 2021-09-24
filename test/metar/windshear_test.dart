import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test one windshear', () {
    final code =
        'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS R07 NOSIG';
    final metar = Metar(code);
    final windshear = metar.windshear;

    expect(windshear.codes, ['WS R07']);
    expect(windshear.toString(), '07');
    expect(windshear.first.name, '07');
    expect(windshear.second.name, null);
    expect(windshear.third.name, null);
    expect(windshear.allRunways, false);
  });

  test('Test two windshears', () {
    final code =
        'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS R07L WS R25C NOSIG';
    final metar = Metar(code);
    final windshear = metar.windshear;

    expect(windshear.codes, ['WS R07L', 'WS R25C']);
    expect(windshear.toString(), '07 left | 25 center');
    expect(windshear.first.name, '07 left');
    expect(windshear.second.name, '25 center');
    expect(windshear.third.name, null);
    expect(windshear.allRunways, false);
  });

  test('Test all runways', () {
    final code =
        'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS ALL RWY NOSIG';
    final metar = Metar(code);
    final windshear = metar.windshear;

    expect(windshear.codes, ['WS ALL RWY']);
    expect(windshear.toString(), 'all runways');
    expect(windshear.first.name, null);
    expect(windshear.second.name, null);
    expect(windshear.third.name, null);
    expect(windshear.allRunways, true);
  });

  test('Test no windshear', () {
    final code =
        'LTAD 212106Z 25004KT 9999 SCT040 BKN100 16/14 Q1019 RESHRA NOSIG RMK RWY29 VRB02KT';
    final metar = Metar(code);
    final windshear = metar.windshear;

    expect(windshear.codes, []);
    expect(windshear.toString(), '');
    expect(windshear.first.name, null);
    expect(windshear.second.name, null);
    expect(windshear.third.name, null);
    expect(windshear.allRunways, false);
  });
}
