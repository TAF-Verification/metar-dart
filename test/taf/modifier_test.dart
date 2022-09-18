import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test AMD report modifier', () {
    final code = '''
    TAF AMD MGPB 231700Z 2318/2418 07008KT 9999 SCT018 TX30/2320Z TN21/2412Z
        PROB40
        TEMPO 2322/2412 8000 VCSH BKN016
        BECMG 2400/2402 00000KT SCT016
        BECMG 2416/2418 06008KT SCT018
    ''';
    final taf = Taf(code);
    final modifier = taf.modifier;

    expect(modifier.code, 'AMD');
    expect(modifier.description, 'Amendment');
    expect(modifier.toString(), 'amendment');
    expect(
        modifier.asMap(),
        equals(<String, Object?>{
          'code': 'AMD',
          'modifier': 'Amendment',
        }));
  });

  test('Test COR report modifier', () {
    final code = '''
    TAF COR SKBO 231630Z 2318/2418 28010KT 9999 SCT023
        TEMPO 2319/2323 5000 TSRA SCT018CB
        BECMG 2400/2402 VRB02KT
        PROB40
        TEMPO 2410/2412 5000 BCFG SCT010 TX21/2318Z TN09/2410Z
    ''';
    final taf = Taf(code);
    final modifier = taf.modifier;

    expect(modifier.code, 'COR');
    expect(modifier.description, 'Correction');
    expect(modifier.toString(), 'correction');
    expect(
        modifier.asMap(),
        equals(<String, Object?>{
          'code': 'COR',
          'modifier': 'Correction',
        }));
  });

  test('Test no modifier', () {
    final code = '''
    TAF SKCG 231630Z 2318/2418 35015KT 9999 FEW020
        TX33/2319Z TN23/2410Z
        BECMG 2402/2404 VRB02KT
  AMD''';
    final taf = Taf(code);
    final modifier = taf.modifier;

    expect(modifier.code, null);
    expect(modifier.description, null);
    expect(modifier.toString(), '');
    expect(
        modifier.asMap(),
        equals(<String, Object?>{
          'code': null,
          'modifier': null,
        }));
  });
}
