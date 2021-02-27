import 'package:metar_dart/metar.dart';
import 'package:test/test.dart';

void main() {
  final code =
      'METAR MROC 071200Z COR 10015G25KT 250V110 0500 R07/P2000N BR VV003 17/09 A2994 RESHRA RMK VIS TO E 5KM NOSIG';
  final metar = Metar(code, utcMonth: 2, utcYear: 2021);

  group('Test the parts divided of METAR', () {
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

  group('Test the date of METAR', () {
    test('Test the month', () {
      final value = metar.month;
      expect(value, 2);
    });

    test('Test the year', () {
      final value = metar.year;
      expect(value, 2021);
    });
  });
}
