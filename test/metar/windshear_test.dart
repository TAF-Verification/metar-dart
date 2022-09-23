import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test one windshears group', () {
    final code =
        'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS R07 NOSIG';
    final metar = Metar(code);
    final windshears = metar.windshears;

    expect(windshears.codes, <String>['WS R07']);
    expect(windshears.toString(), '07');
    expect(windshears.allRunways, false);
    expect(windshears[0].code, 'WS R07');
    expect(windshears[0].name, '07');
    expect(windshears[0].all, false);
    expect(
        windshears[0].asMap(),
        equals(<String, Object?>{
          'all': false,
          'name': '07',
          'code': 'WS R07',
        }));

    expect(
      () => windshears[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test two windshears groups', () {
    final code =
        'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS R07L WS R25C NOSIG';
    final metar = Metar(code);
    final windshears = metar.windshears;

    expect(windshears.codes, <String>['WS R07L', 'WS R25C']);
    expect(windshears.toString(), '07 left | 25 center');
    expect(windshears.allRunways, false);
    expect(windshears[0].code, 'WS R07L');
    expect(windshears[0].name, '07 left');
    expect(windshears[0].all, false);
    expect(
        windshears[0].asMap(),
        equals(<String, Object?>{
          'all': false,
          'name': '07 left',
          'code': 'WS R07L',
        }));

    expect(windshears[1].code, 'WS R25C');
    expect(windshears[1].name, '25 center');
    expect(windshears[1].all, false);
    expect(
        windshears[1].asMap(),
        equals(<String, Object?>{
          'all': false,
          'name': '25 center',
          'code': 'WS R25C',
        }));

    expect(
      () => windshears[2].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test all windshears group', () {
    final code =
        'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS ALL RWY NOSIG';
    final metar = Metar(code);
    final windshears = metar.windshears;

    expect(windshears.codes, <String>['WS ALL RWY']);
    expect(windshears.toString(), 'all runways');
    expect(windshears.allRunways, true);
    expect(windshears[0].code, 'WS ALL RWY');
    expect(windshears[0].name, null);
    expect(windshears[0].all, true);
    expect(
        windshears[0].asMap(),
        equals(<String, Object?>{
          'all': true,
          'name': null,
          'code': 'WS ALL RWY',
        }));

    expect(
      () => windshears[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test no windshears groups', () {
    final code =
        'LTAD 212106Z 25004KT 9999 SCT040 BKN100 16/14 Q1019 RESHRA NOSIG RMK RWY29 VRB02KT';
    final metar = Metar(code);
    final windshears = metar.windshears;

    expect(windshears.codes, <String>[]);
    expect(windshears.toString(), '');
    expect(windshears.allRunways, false);
    expect(windshears.asMap(), equals(<String, Object?>{}));

    for (var i = 0; i < 3; i++) {
      expect(
        () => windshears[i].code,
        throwsA(isA<RangeError>()),
      );
    }
  });
}
