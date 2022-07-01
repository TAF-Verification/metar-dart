import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final _year = 2020;
  final _month = 8;

  test('Test the trend prevailing visibility from meters', () {
    final code =
        'METAR SBBV 170400Z 08004KT 9999 SCT030 FEW035TCU BKN070 26/23 Q1012 BECMG 5000 +RA';
    final metar = Metar(code, year: _year, month: _month);
    final trends = metar.weatherTrends;

    final first = trends[0];
    expect(first.code, 'BECMG 5000 +RA');
    expect(first.prevailingVisibility.code, '5000');
    expect(first.prevailingVisibility.inMeters, 5000.0);
    expect(first.prevailingVisibility.inKilometers, 5.0);
    expect(first.prevailingVisibility.inSeaMiles, 2.6997840172786174);
    expect(first.prevailingVisibility.inFeet, 16404.199475065616);
    expect(first.prevailingVisibility.cavok, false);
    expect(first.prevailingVisibility.cardinalDirection, null);
    expect(first.prevailingVisibility.directionInDegrees, null);
    expect(first.prevailingVisibility.directionInRadians, null);
    expect(first.prevailingVisibility.toString(), '5.0 km');
    expect(
        first.prevailingVisibility.asMap(),
        equals(<String, Object?>{
          'code': '5000',
          'visibility': {'units': 'meters', 'distance': 5000.0},
          'direction': {
            'cardinal': null,
            'variable': false,
            'units': 'degrees',
            'direction': null
          },
          'cavok': false
        }));

    expect(
      () => trends[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test the trend prevailing visibility from sea miles', () {
    final code =
        'SPECI PALH 170933Z 00000KT 10SM FEW020 M14/M16 A2980 TEMPO FM1000 TL1100 1 1/4SM BR BKN002 RMK AO2 T11441156';
    final metar = Metar(code, year: _year, month: _month);
    final trends = metar.weatherTrends;

    final first = trends[0];
    expect(first.code, 'TEMPO FM1000 TL1100 1 1/4SM BR BKN002');
    expect(first.prevailingVisibility.code, '1 1/4SM');
    expect(first.prevailingVisibility.inMeters, 2315.0);
    expect(first.prevailingVisibility.inKilometers, 2.315);
    expect(first.prevailingVisibility.inSeaMiles, 1.2499999999999998);
    expect(first.prevailingVisibility.inFeet, 7595.144356955379);
    expect(first.prevailingVisibility.cavok, false);
    expect(first.prevailingVisibility.cardinalDirection, null);
    expect(first.prevailingVisibility.directionInDegrees, null);
    expect(first.prevailingVisibility.directionInRadians, null);
    expect(first.prevailingVisibility.toString(), '2.3 km');
    expect(
        first.prevailingVisibility.asMap(),
        equals(<String, Object?>{
          'code': '1 1/4SM',
          'visibility': {'units': 'meters', 'distance': 2315.0},
          'direction': {
            'cardinal': null,
            'variable': false,
            'units': 'degrees',
            'direction': null
          },
          'cavok': false
        }));

    expect(
      () => trends[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test the trend prevailing visibility from sea miles only fractional',
      () {
    final code =
        'METAR PALH 170933Z 00000KT 2SM BR FEW002 M14/M16 A2980 BECMG AT1000 1/2SM RMK AO2 T11441156';
    final metar = Metar(code);
    final trends = metar.weatherTrends;

    final first = trends[0];
    expect(first.code, 'BECMG AT1000 1/2SM');
    expect(first.prevailingVisibility.code, '1/2SM');
    expect(first.prevailingVisibility.inMeters, 926.0);
    expect(first.prevailingVisibility.inKilometers, 0.926);
    expect(first.prevailingVisibility.inSeaMiles, 0.49999999999999994);
    expect(first.prevailingVisibility.inFeet, 3038.0577427821518);
    expect(first.prevailingVisibility.cavok, false);
    expect(first.prevailingVisibility.cardinalDirection, null);
    expect(first.prevailingVisibility.directionInDegrees, null);
    expect(first.prevailingVisibility.directionInRadians, null);
    expect(first.prevailingVisibility.toString(), '0.9 km');
    expect(
        first.prevailingVisibility.asMap(),
        equals(<String, Object?>{
          'code': '1/2SM',
          'visibility': {'units': 'meters', 'distance': 926.0},
          'direction': {
            'cardinal': null,
            'variable': false,
            'units': 'degrees',
            'direction': null
          },
          'cavok': false
        }));

    expect(
      () => trends[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test the trend prevailing visibility from kilometers', () {
    final code =
        'METAR SCAT 210900Z 18005KT 10KM OVC027/// 16/12 Q1013 BECMG 5KM';
    final metar = Metar(code);
    final trends = metar.weatherTrends;

    final first = trends[0];
    expect(first.code, 'BECMG 5KM');
    expect(first.prevailingVisibility.code, '5KM');
    expect(first.prevailingVisibility.inMeters, 5000.0);
    expect(first.prevailingVisibility.inKilometers, 5.0);
    expect(first.prevailingVisibility.inSeaMiles, 2.6997840172786174);
    expect(first.prevailingVisibility.inFeet, 16404.199475065616);
    expect(first.prevailingVisibility.cavok, false);
    expect(first.prevailingVisibility.cardinalDirection, null);
    expect(first.prevailingVisibility.directionInDegrees, null);
    expect(first.prevailingVisibility.directionInRadians, null);
    expect(first.prevailingVisibility.toString(), '5.0 km');
    expect(
        first.prevailingVisibility.asMap(),
        equals(<String, Object?>{
          'code': '5KM',
          'visibility': {'units': 'meters', 'distance': 5000.0},
          'direction': {
            'cardinal': null,
            'variable': false,
            'units': 'degrees',
            'direction': null
          },
          'cavok': false
        }));

    expect(
      () => trends[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test the trend prevailing visibility from CAVOK', () {
    final code =
        'METAR SAAR 222000Z 13011KT 100V160 9999 FEW030 32/15 Q1012 BECMG AT2100 CAVOK RMK PP000';
    final metar = Metar(code);
    final trends = metar.weatherTrends;

    final first = trends[0];
    expect(first.code, 'BECMG AT2100 CAVOK');
    expect(first.prevailingVisibility.code, 'CAVOK');
    expect(first.prevailingVisibility.inMeters, 10000.0);
    expect(first.prevailingVisibility.inKilometers, 10.0);
    expect(first.prevailingVisibility.inSeaMiles, 5.399568034557235);
    expect(first.prevailingVisibility.inFeet, 32808.39895013123);
    expect(first.prevailingVisibility.cavok, true);
    expect(first.prevailingVisibility.cardinalDirection, null);
    expect(first.prevailingVisibility.directionInDegrees, null);
    expect(first.prevailingVisibility.directionInRadians, null);
    expect(first.prevailingVisibility.toString(), 'Ceiling and Visibility OK');
    expect(
        first.prevailingVisibility.asMap(),
        equals(<String, Object?>{
          'code': 'CAVOK',
          'visibility': {'units': 'meters', 'distance': 10000.0},
          'direction': {
            'cardinal': null,
            'variable': false,
            'units': 'degrees',
            'direction': null
          },
          'cavok': true
        }));

    expect(
      () => trends[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test no trend visibility in METAR', () {
    final code =
        'METAR PALH 170933Z 00000KT BR FEW002 M14/M16 A2980 NOSIG RMK AO2 T11441156';
    final metar = Metar(code);
    final trends = metar.weatherTrends;

    final first = trends[0];
    expect(first.code, 'NOSIG');
    expect(first.prevailingVisibility.code, null);
    expect(first.prevailingVisibility.inMeters, null);
    expect(first.prevailingVisibility.inKilometers, null);
    expect(first.prevailingVisibility.inSeaMiles, null);
    expect(first.prevailingVisibility.inFeet, null);
    expect(first.prevailingVisibility.cavok, false);
    expect(first.prevailingVisibility.cardinalDirection, null);
    expect(first.prevailingVisibility.directionInDegrees, null);
    expect(first.prevailingVisibility.directionInRadians, null);
    expect(first.prevailingVisibility.toString(), '');
    expect(
        first.prevailingVisibility.asMap(),
        equals(<String, Object?>{
          'code': null,
          'visibility': {'units': 'meters', 'distance': null},
          'direction': {
            'cardinal': null,
            'variable': false,
            'units': 'degrees',
            'direction': null
          },
          'cavok': false
        }));

    expect(
      () => trends[1].code,
      throwsA(isA<RangeError>()),
    );
  });
}
