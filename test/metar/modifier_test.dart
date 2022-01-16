import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test AUTO report modifier', () {
    final code =
        'METAR KJST 060154Z AUTO 05007KT 10SM OVC085 13/01 A3004 RMK AO2 SLP174 T01280006';
    final metar = Metar(code);
    final modifier = metar.modifier;

    expect(modifier.code, 'AUTO');
    expect(modifier.modifier, 'Automatic report');
    expect(modifier.toString(), 'automatic report');
  });

  test('Test NIL report modifier', () {
    final code = 'METAR KJST 060100Z NIL';
    final metar = Metar(code);
    final modifier = metar.modifier;

    expect(modifier.code, 'NIL');
    expect(modifier.modifier, 'Missing report');
    expect(modifier.toString(), 'missing report');
  });

  test('Test COR report modifier', () {
    final code =
        'METAR MROC 202200Z COR 08011KT 9999 FEW045 SCT200 29/17 A2989 NOSIG';
    final metar = Metar(code);
    final modifier = metar.modifier;

    expect(modifier.code, 'COR');
    expect(modifier.modifier, 'Correction');
    expect(modifier.toString(), 'correction');
  });

  test('Test no modifier', () {
    final code =
        'SPECI UUDD 152330Z 29005MPS 9999 SCT019 07/04 Q1014 R32L/290042 NOSIG';
    final metar = Metar(code);
    final modifier = metar.modifier;

    expect(modifier.code, null);
    expect(modifier.modifier, null);
    expect(modifier.toString(), '');
  });
}
