import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the prevailing visibility from meters', () {
    final code =
        'METAR SBBV 170400Z 08004KT 9999 SCT030 FEW035TCU BKN070 26/23 Q1012';
    final metar = Metar(code);

    test('Test the visibility in kilometers', () {
      final value = metar.visibility.inKilometers;
      expect(value, 10.0);
    });

    test('Test the visibility in meters', () {
      final value = metar.visibility.inMeters;
      expect(value, 10000.0);
    });

    test('Test the visibility in feet', () {
      final value = metar.visibility.inFeet;
      expect(value, 32808.4);
    });

    test('Test the visibility in miles', () {
      final value = metar.visibility.inMiles;
      expect(value, 6.21);
    });
  });

  group('Test the prevailing visibility from sea miles in fractional', () {
    final code =
        'PALH 170933Z 00000KT 1 1/4SM BR FEW002 M14/M16 A2980 RMK AO2 T11441156';
    final metar = Metar(code);

    test('Test the visibility in kilometers', () {
      final value = metar.visibility.inKilometers;
      expect(value, 2.01);
    });

    test('Test the visibility in meters', () {
      final value = metar.visibility.inMeters;
      expect(value, 2011.68);
    });

    test('Test the visibility in feet', () {
      final value = metar.visibility.inFeet;
      expect(value, 6600.0);
    });

    test('Test the visibility in miles', () {
      final value = metar.visibility.inMiles;
      expect(value, 1.25);
    });
  });

  group('Test the prevailing visibility from sea miles in integer', () {
    final code =
        'PALH 170936Z 00000KT 5SM BR CLR M14/M16 A2980 RMK AO2 T11441161';
    final metar = Metar(code);

    test('Test the visibility in kilometers', () {
      final value = metar.visibility.inKilometers;
      expect(value, 8.05);
    });

    test('Test the visibility in meters', () {
      final value = metar.visibility.inMeters;
      expect(value, 8046.72);
    });

    test('Test the visibility in feet', () {
      final value = metar.visibility.inFeet;
      expect(value, 26400.0);
    });

    test('Test the visibility in miles', () {
      final value = metar.visibility.inMiles;
      expect(value, 5.0);
    });
  });

  group('Test the minimum visibility of METAR', () {
    final code =
        'UUDD 180100Z 00000MPS 4800 2100NW -SN BR SCT025 M02/M03 Q1007 R32L/290042 NOSIG';
    final metar = Metar(code);

    test('Test the minimum visibility in kilometers', () {
      final value = metar.minimumVisibility.inKilometers;
      expect(value, 2.10);
    });

    test('Test the minimum visibility in meters', () {
      final value = metar.minimumVisibility.inMeters;
      expect(value, 2100.0);
    });

    test('Test the minimum visibility in feet', () {
      final value = metar.minimumVisibility.inFeet;
      expect(value, 6889.76);
    });

    test('Test the minimum visibility in miles', () {
      final value = metar.minimumVisibility.inMiles;
      expect(value, 1.3);
    });

    test('Test the minimum visibility direction in degrees', () {
      final value = metar.minimumVisibilityDirection.directionInDegrees;
      expect(value, 315.0);
    });

    test('Test the cardinal point minimum visibility direction', () {
      final value = metar.minimumVisibilityDirection.cardinalPoint;
      expect(value, 'NW');
    });

    test('Test the minimum visibility direction in radians', () {
      final value = metar.minimumVisibilityDirection.directionInRadians;
      expect(value, 5.497787);
    });
  });
}
