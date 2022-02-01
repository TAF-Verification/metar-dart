import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test one windshear group', () {
    final code =
        'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS R07 NOSIG';
    final metar = Metar(code);
    final windshear = metar.windshear;

    expect(windshear.codes, <String>['WS R07']);
    expect(windshear.toString(), '07');
    expect(windshear.all_runways, false);
    expect(windshear[0].code, 'WS R07');
    expect(windshear[0].name, '07');
    expect(windshear[0].all, false);

    expect(
      () => windshear[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test two windshear groups', () {
    final code =
        'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS R07L WS R25C NOSIG';
    final metar = Metar(code);
    final windshear = metar.windshear;

    expect(windshear.codes, <String>['WS R07L', 'WS R25C']);
    expect(windshear.toString(), '07 left | 25 center');
    expect(windshear.all_runways, false);
    expect(windshear[0].code, 'WS R07L');
    expect(windshear[0].name, '07 left');
    expect(windshear[0].all, false);
    expect(windshear[1].code, 'WS R25C');
    expect(windshear[1].name, '25 center');
    expect(windshear[1].all, false);

    expect(
      () => windshear[2].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test all windshear group', () {
    final code =
        'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS ALL RWY NOSIG';
    final metar = Metar(code);
    final windshear = metar.windshear;

    expect(windshear.codes, <String>['WS ALL RWY']);
    expect(windshear.toString(), 'all runways');
    expect(windshear.all_runways, true);
    expect(windshear[0].code, 'WS ALL RWY');
    expect(windshear[0].name, null);
    expect(windshear[0].all, true);

    expect(
      () => windshear[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test no windshear groups', () {
    final code =
        'LTAD 212106Z 25004KT 9999 SCT040 BKN100 16/14 Q1019 RESHRA NOSIG RMK RWY29 VRB02KT';
    final metar = Metar(code);
    final windshear = metar.windshear;

    expect(windshear.codes, <String>[]);
    expect(windshear.toString(), '');
    expect(windshear.all_runways, false);

    for (var i = 0; i < 3; i++) {
      expect(
        () => windshear[i].code,
        throwsA(isA<RangeError>()),
      );
    }
  });
}
