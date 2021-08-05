import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final code =
      'METAR MROC 071200Z COR 10015G25KT 250V110 0500 R07/P2000N BR VV003 17/09 A2994 RESHRA RMK VIS TO E 5KM NOSIG';
  final metar = Metar(code, month: 8, year: 2021);

  group('Test the sections of METAR', () {
    test('Test the body', () {
      final value = metar.body;
      final expected =
          'METAR MROC 071200Z COR 10015G25KT 250V110 0500 R07/P2000N BR VV003 17/09 A2994 RESHRA';
      expect(value, expected);
    });

    test('Test the remark', () {
      final value = metar.remark;
      final expected = 'RMK VIS TO E 5KM';
      expect(value, expected);
    });

    test('Test the trend', () {
      final value = metar.trend;
      final expected = 'NOSIG';
      expect(value, expected);
    });
  });
}
