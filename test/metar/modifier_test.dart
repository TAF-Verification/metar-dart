import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test AUTO report modifier', () {
    final code =
        'METAR KJST 060154Z AUTO 05007KT 10SM OVC085 13/01 A3004 RMK AO2 SLP174 T01280006';
    final metar = Metar(code);

    expect(metar.modifier.modifier, 'Automatic report');
  });

  test('Test NIL report modifier', () {
    final code = 'METAR KJST 060100Z NIL';
    final metar = Metar(code);

    expect(metar.modifier.modifier, 'Missing report');
  });

  test('Test COR report modifier', () {
    final code =
        'METAR MROC 202200Z COR 08011KT 9999 FEW045 SCT200 29/17 A2989 NOSIG';
    final metar = Metar(code);

    expect(metar.modifier.modifier, 'Correction');
  });
}
