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
      expect(value, 32808.39895);
    });

    test('Test the visibility in sea miles', () {
      final value = metar.visibility.inSeaMiles;
      expect(value, 5.39957);
    });
  });

  group('Test the prevailing visibility from sea miles in fractional', () {
    final code =
        'PALH 170933Z 00000KT 1 1/4SM BR FEW002 M14/M16 A2980 RMK AO2 T11441156';
    final metar = Metar(code);

    test('Test the visibility in kilometers', () {
      final value = metar.visibility.inKilometers;
      expect(value, 2.315);
    });

    test('Test the visibility in meters', () {
      final value = metar.visibility.inMeters;
      expect(value, 2315.0);
    });

    test('Test the visibility in feet', () {
      final value = metar.visibility.inFeet;
      expect(value, 7595.14436);
    });

    test('Test the visibility in miles', () {
      final value = metar.visibility.inSeaMiles;
      expect(value, 1.25);
    });
  });

  group('Test the prevailing visibility from sea miles in integer', () {
    final code =
        'PALH 170936Z 00000KT 5SM BR CLR M14/M16 A2980 RMK AO2 T11441161';
    final metar = Metar(code);

    test('Test the visibility in kilometers', () {
      final value = metar.visibility.inKilometers;
      expect(value, 9.26);
    });

    test('Test the visibility in meters', () {
      final value = metar.visibility.inMeters;
      expect(value, 9260.0);
    });

    test('Test the visibility in feet', () {
      final value = metar.visibility.inFeet;
      expect(value, 30380.57743);
    });

    test('Test the visibility in miles', () {
      final value = metar.visibility.inSeaMiles;
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
      expect(value, 6889.76378);
    });

    test('Test the minimum visibility in miles', () {
      final value = metar.minimumVisibility.inSeaMiles;
      expect(value, 1.13391);
    });

    test('Test the minimum visibility direction in degrees', () {
      final value = metar.minimumVisibility.directionInDegrees;
      expect(value, 315.0);
    });

    test('Test the cardinal point minimum visibility direction', () {
      final value = metar.minimumVisibility.cardinalDirection;
      expect(value, 'NW');
    });

    test('Test the minimum visibility direction in radians', () {
      final value = metar.minimumVisibility.directionInRadians;
      expect(value, 5.49779);
    });
  });

  group('Test the METAR with one runway range', () {
    final code =
        'METAR SCFA 121300Z 21008KT 9999 3000W R07L/M0150V0600U TSRA FEW020 20/13 Q1014 NOSIG';
    final metar = Metar(code);

    test('Test the first runway name', () {
      final value = metar.runwayRanges.first.name;
      expect(value, '07 left');
    });

    test('Test the first runway low range', () {
      final value = metar.runwayRanges.first.low;
      expect(value, 'below of 150.0 meters');
    });

    test('Test the first runway low range in meters', () {
      final value = metar.runwayRanges.first.lowInMeters;
      expect(value, 150.0);
    });

    test('Test the first runway low range in kilometers', () {
      final value = metar.runwayRanges.first.lowInKilometers;
      expect(value, 0.150);
    });

    test('Test the first runway low range in feet', () {
      final value = metar.runwayRanges.first.lowInFeet;
      expect(value, 492.12598);
    });

    test('Test the first runway high range in meters', () {
      final value = metar.runwayRanges.first.highInMeters;
      expect(value, 600.0);
    });

    test('Test the first runway high range in kilometers', () {
      final value = metar.runwayRanges.first.highInKilometers;
      expect(value, 0.600);
    });

    test('Test the first runway high range in feet', () {
      final value = metar.runwayRanges.first.highInFeet;
      expect(value, 1968.50394);
    });
  });

  group('Test the METAR with two runway ranges', () {
    final code =
        'METAR SCFA 121300Z 21008KT 9999 3000W R07L/M0150V0600U R25C/P1000N TSRA FEW020 20/13 Q1014 NOSIG';
    final metar = Metar(code);

    test('Test the first runway name', () {
      final value = metar.runwayRanges.first.name;
      expect(value, '07 left');
    });

    test('Test the first runway low range', () {
      final value = metar.runwayRanges.first.low;
      expect(value, 'below of 150.0 meters');
    });

    test('Test the first runway low range in meters', () {
      final value = metar.runwayRanges.first.lowInMeters;
      expect(value, 150.0);
    });

    test('Test the first runway low range in kilometers', () {
      final value = metar.runwayRanges.first.lowInKilometers;
      expect(value, 0.150);
    });

    test('Test the first runway low range in feet', () {
      final value = metar.runwayRanges.first.lowInFeet;
      expect(value, 492.12598);
    });

    test('Test the first runway high range in meters', () {
      final value = metar.runwayRanges.first.highInMeters;
      expect(value, 600.0);
    });

    test('Test the first runway high range in kilometers', () {
      final value = metar.runwayRanges.first.highInKilometers;
      expect(value, 0.600);
    });

    test('Test the first runway high range in feet', () {
      final value = metar.runwayRanges.first.highInFeet;
      expect(value, 1968.50394);
    });

    test('Test the trend of first runway range', () {
      final value = metar.runwayRanges.first.trend;
      expect(value, 'increasing');
    });

    test('Test the second runway name', () {
      final value = metar.runwayRanges.second.name;
      expect(value, '25 center');
    });

    test('Test the second runway low range', () {
      final value = metar.runwayRanges.second.low;
      expect(value, 'above of 1000.0 meters');
    });

    test('Test the second runway low range in meters', () {
      final value = metar.runwayRanges.second.lowInMeters;
      expect(value, 1000.0);
    });

    test('Test the second runway low range in kilometers', () {
      final value = metar.runwayRanges.second.lowInKilometers;
      expect(value, 1.0);
    });

    test('Test the second runway low range in feet', () {
      final value = metar.runwayRanges.second.lowInFeet;
      expect(value, 3280.8399);
    });

    test('Test the second runway high range in meters', () {
      final value = metar.runwayRanges.second.highInMeters;
      expect(value, null);
    });

    test('Test the second runway high range in kilometers', () {
      final value = metar.runwayRanges.second.highInKilometers;
      expect(value, null);
    });

    test('Test the second runway high range in feet', () {
      final value = metar.runwayRanges.second.highInFeet;
      expect(value, null);
    });

    test('Test the trend of second runway range', () {
      final value = metar.runwayRanges.second.trend;
      expect(value, 'no change');
    });
  });
}
