import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final code_1 =
      'METAR SBBV 170400Z 08004KT 9999 SCT030 FEW035TCU BKN070 26/23 Q1012';
  final metar_1 = Metar(code_1);

  group('Test the prevailing visibility from meters', () {
    test('Test the visibility in kilometers', () {
      final value = metar_1.visibility.inKilometers;
      expect(value, 10.0);
    });

    test('Test the visibility in meters', () {
      final value = metar_1.visibility.inMeters;
      expect(value, 10000.0);
    });

    test('Test the visibility in feet', () {
      final value = metar_1.visibility.inFeet;
      expect(value, 32808.4);
    });

    test('Test the visibility in miles', () {
      final value = metar_1.visibility.inMiles;
      expect(value, 6.21);
    });
  });

  final code_2 =
      'PALH 170933Z 00000KT 1 1/4SM BR FEW002 M14/M16 A2980 RMK AO2 T11441156';
  final metar_2 = Metar(code_2);

  group('Test the prevailing visibility from sea miles in fractional', () {
    test('Test the visibility in kilometers', () {
      final value = metar_2.visibility.inKilometers;
      expect(value, 2.01);
    });

    test('Test the visibility in meters', () {
      final value = metar_2.visibility.inMeters;
      expect(value, 2011.68);
    });

    test('Test the visibility in feet', () {
      final value = metar_2.visibility.inFeet;
      expect(value, 6600.0);
    });

    test('Test the visibility in miles', () {
      final value = metar_2.visibility.inMiles;
      expect(value, 1.25);
    });
  });

  final code_3 =
      'PALH 170936Z 00000KT 5SM BR CLR M14/M16 A2980 RMK AO2 T11441161';
  final metar_3 = Metar(code_3);

  group('Test the prevailing visibility from sea miles in integer', () {
    test('Test the visibility in kilometers', () {
      final value = metar_3.visibility.inKilometers;
      expect(value, 8.05);
    });

    test('Test the visibility in meters', () {
      final value = metar_3.visibility.inMeters;
      expect(value, 8046.72);
    });

    test('Test the visibility in feet', () {
      final value = metar_3.visibility.inFeet;
      expect(value, 26400.0);
    });

    test('Test the visibility in miles', () {
      final value = metar_3.visibility.inMiles;
      expect(value, 5.0);
    });
  });
}
