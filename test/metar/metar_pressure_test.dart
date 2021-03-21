import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the pressure of METAR from hPa', () {
    final code = 'METAR OESH 201700Z 06004KT CAVOK 31/00 Q1013 NOSIG';
    final metar = Metar(code);
    final pressure = metar.pressure;

    test('Test the pressure in hPa', () {
      final value = pressure.inHPa;
      expect(value, 1013.0);
    });

    test('Test the pressure in inHg', () {
      final value = pressure.inInHg;
      expect(value, 29.91);
    });

    test('Test the pressure in mb', () {
      final value = pressure.inMb;
      expect(value, 1013.0);
    });
  });

  group('Test the pressure of METAR from inHg', () {
    final code = 'METAR MMGL 201721Z 00000KT 7SM NSC 26/M07 A3025 RMK HZY CI';
    final metar = Metar(code);
    final pressure = metar.pressure;

    test('Test the pressure in hPa', () {
      final value = pressure.inHPa;
      expect(value, 1024.39);
    });

    test('Test the pressure in inHg', () {
      final value = pressure.inInHg;
      expect(value, 30.25);
    });

    test('Test the pressure in mb', () {
      final value = pressure.inMb;
      expect(value, 1024.39);
    });
  });
}
