import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the prevailing visibility from meters', () {
    final code =
        'METAR SBBV 170400Z 08004KT 9999 SCT030 FEW035TCU BKN070 26/23 Q1012';
    final metar = Metar(code);
    final visibility = metar.prevailingVisibility;

    expect(visibility.code, '9999');
    expect(visibility.inMeters, 10000.0);
    expect(visibility.inKilometers, 10.0);
    expect(visibility.inSeaMiles, 5.399568034557235);
    expect(visibility.inFeet, 32808.39895013123);
    expect(visibility.cavok, false);
    expect(visibility.cardinalDirection, null);
    expect(visibility.directionInDegrees, null);
    expect(visibility.directionInRadians, null);
    expect(visibility.toString(), '10.0 km');
    expect(
        visibility.asMap(),
        equals(<String, Object?>{
          'code': '9999',
          'visibility': {'units': 'meters', 'distance': 10000.0},
          'direction': {
            'cardinal': null,
            'variable': false,
            'units': 'degrees',
            'direction': null
          },
          'cavok': false,
        }));
  });

  test('Test the prevailing visibility from sea miles', () {
    final code =
        'METAR PALH 170933Z 00000KT 1 1/4SM BR FEW002 M14/M16 A2980 RMK AO2 T11441156';
    final metar = Metar(code);
    final visibility = metar.prevailingVisibility;

    expect(visibility.code, '1 1/4SM');
    expect(visibility.inMeters, 2315.0);
    expect(visibility.inKilometers, 2.315);
    expect(visibility.inSeaMiles, 1.2499999999999998);
    expect(visibility.inFeet, 7595.144356955379);
    expect(visibility.cavok, false);
    expect(visibility.cardinalDirection, null);
    expect(visibility.directionInDegrees, null);
    expect(visibility.directionInRadians, null);
    expect(visibility.toString(), '2.3 km');
    expect(
        visibility.asMap(),
        equals(<String, Object?>{
          'code': '1 1/4SM',
          'visibility': {'units': 'meters', 'distance': 2315.0},
          'direction': {
            'cardinal': null,
            'variable': false,
            'units': 'degrees',
            'direction': null
          },
          'cavok': false,
        }));
  });

  test('Test the prevailing visibility from sea miles only fractional', () {
    final code =
        'METAR PALH 170933Z 00000KT 1/2SM BR FEW002 M14/M16 A2980 RMK AO2 T11441156';
    final metar = Metar(code);
    final visibility = metar.prevailingVisibility;

    expect(visibility.code, '1/2SM');
    expect(visibility.inMeters, 926.0);
    expect(visibility.inKilometers, 0.926);
    expect(visibility.inSeaMiles, 0.49999999999999994);
    expect(visibility.inFeet, 3038.0577427821518);
    expect(visibility.cavok, false);
    expect(visibility.cardinalDirection, null);
    expect(visibility.directionInDegrees, null);
    expect(visibility.directionInRadians, null);
    expect(visibility.toString(), '0.9 km');
    expect(
        visibility.asMap(),
        equals(<String, Object?>{
          'code': '1/2SM',
          'visibility': {'units': 'meters', 'distance': 926.0},
          'direction': {
            'cardinal': null,
            'variable': false,
            'units': 'degrees',
            'direction': null
          },
          'cavok': false,
        }));
  });

  test('Test the prevailing visibility from kilometers', () {
    final code = 'METAR SCAT 210900Z AUTO 18005KT 5KM OVC027/// 16/12 Q1013';
    final metar = Metar(code);
    final visibility = metar.prevailingVisibility;

    expect(visibility.code, '5KM');
    expect(visibility.inMeters, 5000.0);
    expect(visibility.inKilometers, 5.0);
    expect(visibility.inSeaMiles, 2.6997840172786174);
    expect(visibility.inFeet, 16404.199475065616);
    expect(visibility.cavok, false);
    expect(visibility.cardinalDirection, null);
    expect(visibility.directionInDegrees, null);
    expect(visibility.directionInRadians, null);
    expect(visibility.toString(), '5.0 km');
    expect(
        visibility.asMap(),
        equals(<String, Object?>{
          'code': '5KM',
          'visibility': {'units': 'meters', 'distance': 5000.0},
          'direction': {
            'cardinal': null,
            'variable': false,
            'units': 'degrees',
            'direction': null
          },
          'cavok': false,
        }));
  });

  test('Test the prevailing visibility from CAVOK', () {
    final code =
        'METAR SAAR 222000Z 13011KT 100V160 CAVOK 32/15 Q1012 RMK PP000';
    final metar = Metar(code);
    final visibility = metar.prevailingVisibility;

    expect(visibility.code, 'CAVOK');
    expect(visibility.inMeters, 10000.0);
    expect(visibility.inKilometers, 10.0);
    expect(visibility.inSeaMiles, 5.399568034557235);
    expect(visibility.inFeet, 32808.39895013123);
    expect(visibility.cavok, true);
    expect(visibility.cardinalDirection, null);
    expect(visibility.directionInDegrees, null);
    expect(visibility.directionInRadians, null);
    expect(visibility.toString(), 'Ceiling and Visibility OK');
    expect(
        visibility.asMap(),
        equals(<String, Object?>{
          'code': 'CAVOK',
          'visibility': {'units': 'meters', 'distance': 10000.0},
          'direction': {
            'cardinal': null,
            'variable': false,
            'units': 'degrees',
            'direction': null
          },
          'cavok': true,
        }));
  });

  test('Test no visibility in METAR', () {
    final code =
        'METAR PALH 170933Z 00000KT BR FEW002 M14/M16 A2980 RMK AO2 T11441156';
    final metar = Metar(code);
    final visibility = metar.prevailingVisibility;

    expect(visibility.code, null);
    expect(visibility.inMeters, null);
    expect(visibility.inKilometers, null);
    expect(visibility.inSeaMiles, null);
    expect(visibility.inFeet, null);
    expect(visibility.cavok, false);
    expect(visibility.cardinalDirection, null);
    expect(visibility.directionInDegrees, null);
    expect(visibility.directionInRadians, null);
    expect(visibility.toString(), '');
    expect(
        visibility.asMap(),
        equals(<String, Object?>{
          'code': null,
          'visibility': {'units': 'meters', 'distance': null},
          'direction': {
            'cardinal': null,
            'variable': false,
            'units': 'degrees',
            'direction': null
          },
          'cavok': false,
        }));
  });

  test('Test the minimum visibility of METAR', () {
    final code =
        'UUDD 180100Z 00000MPS 4800 2100NW -SN BR SCT025 M02/M03 Q1007 R32L/290042 NOSIG';
    final metar = Metar(code);
    final minimumVisibility = metar.minimumVisibility;

    expect(minimumVisibility.code, '2100NW');
    expect(minimumVisibility.inMeters, 2100.0);
    expect(minimumVisibility.inKilometers, 2.1);
    expect(minimumVisibility.inSeaMiles, 1.1339092872570193);
    expect(minimumVisibility.inFeet, 6889.763779527559);
    expect(minimumVisibility.cardinalDirection, 'NW');
    expect(minimumVisibility.directionInDegrees, 315.0);
    expect(minimumVisibility.directionInRadians, 5.497787143782138);
    expect(minimumVisibility.toString(), '2.1 km to NW (315.0°)');
    expect(
        minimumVisibility.asMap(),
        equals(<String, Object?>{
          'code': '2100NW',
          'visibility': {'units': 'meters', 'distance': 2100.0},
          'direction': {
            'cardinal': 'NW',
            'variable': false,
            'units': 'degrees',
            'direction': 315.0
          },
        }));
  });

  test('Test the no minimum visibility', () {
    final code =
        'METAR UUDD 180100Z 25005MPS 4800 -SN BR SCT025 M02/M03 Q1007 R32L/290042 NOSIG';
    final metar = Metar(code);
    final minimumVisibility = metar.minimumVisibility;

    expect(minimumVisibility.code, null);
    expect(minimumVisibility.inMeters, null);
    expect(minimumVisibility.inKilometers, null);
    expect(minimumVisibility.inSeaMiles, null);
    expect(minimumVisibility.inFeet, null);
    expect(minimumVisibility.cardinalDirection, null);
    expect(minimumVisibility.directionInDegrees, null);
    expect(minimumVisibility.directionInRadians, null);
    expect(minimumVisibility.toString(), '');
    expect(
        minimumVisibility.asMap(),
        equals(<String, Object?>{
          'code': null,
          'visibility': {'units': 'meters', 'distance': null},
          'direction': {
            'cardinal': null,
            'variable': false,
            'units': 'degrees',
            'direction': null
          }
        }));
  });
}
