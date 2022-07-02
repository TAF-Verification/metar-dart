import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test missing TAF', () {
    final code = 'TAF LFBE 231700Z NIL';
    final taf = Taf(code);
    final missing = taf.missing;

    expect(missing.code, 'NIL');
    expect(missing.modifier, 'Missing report');
    expect(missing.isMissing, true);
    expect(missing.toString(), 'missing report');
    expect(
        missing.asMap(),
        equals(<String, Object?>{
          'is_missing': true,
          'code': 'NIL',
          'modifier': 'Missing report'
        }));
  });

  test('Test no missing TAF', () {
    final code = '''
    TAF LFBE 231700Z 2318/2418 VRB03KT CAVOK
        PROB40
        TEMPO 2402/2407 3000 BR NSC
        BECMG 2412/2414 BKN020
        PROB30
        TEMPO 2414/2416 4000 -SHRA BKN020TCU
    ''';
    final taf = Taf(code);
    final missing = taf.missing;

    expect(missing.code, null);
    expect(missing.modifier, null);
    expect(missing.isMissing, false);
    expect(missing.toString(), '');
    expect(
        missing.asMap(),
        equals(<String, Object?>{
          'is_missing': false,
          'code': null,
          'modifier': null
        }));
  });
}
