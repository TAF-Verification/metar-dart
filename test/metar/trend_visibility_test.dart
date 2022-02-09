import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the trend prevailing visibility from meters', () {
    final code =
        'METAR SBBV 170400Z 08004KT 9999 SCT030 FEW035TCU BKN070 26/23 Q1012 BECMG 5000 +RA';
    final metar = Metar(code);
    final visibility = metar.trendPrevailingVisibility;

    expect(visibility.code, '5000');
    expect(visibility.inMeters, 5000.0);
    expect(visibility.inKilometers, 5.0);
    expect(visibility.inSeaMiles, 2.6997840172786174);
    expect(visibility.inFeet, 16404.199475065616);
    expect(visibility.cavok, false);
    expect(visibility.cardinalDirection, null);
    expect(visibility.directionInDegrees, null);
    expect(visibility.directionInRadians, null);
    expect(visibility.toString(), '5.0 km');
  });

  test('Test the trend prevailing visibility from sea miles', () {
    final code =
        'SPECI PALH 170933Z 00000KT 10SM FEW020 M14/M16 A2980 TEMPO FM1000 TL1100 1 1/4SM BR BKN002 RMK AO2 T11441156';
    final metar = Metar(code);
    final visibility = metar.trendPrevailingVisibility;

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
  });

  test('Test the trend prevailing visibility from sea miles only fractional',
      () {
    final code =
        'METAR PALH 170933Z 00000KT 2SM BR FEW002 M14/M16 A2980 BECMG AT1000 1/2SM RMK AO2 T11441156';
    final metar = Metar(code);
    final visibility = metar.trendPrevailingVisibility;

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
  });

  test('Test the trend prevailing visibility from kilometers', () {
    final code =
        'METAR SCAT 210900Z 18005KT 10KM OVC027/// 16/12 Q1013 BECMG 5KM';
    final metar = Metar(code);
    final visibility = metar.trendPrevailingVisibility;

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
  });

  test('Test the trend prevailing visibility from CAVOK', () {
    final code =
        'METAR SAAR 222000Z 13011KT 100V160 9999 FEW030 32/15 Q1012 BECMG AT2100 CAVOK RMK PP000';
    final metar = Metar(code);
    final visibility = metar.trendPrevailingVisibility;

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
  });

  test('Test no trend visibility in METAR', () {
    final code =
        'METAR PALH 170933Z 00000KT BR FEW002 M14/M16 A2980 NOSIG RMK AO2 T11441156';
    final metar = Metar(code);
    final visibility = metar.trendPrevailingVisibility;

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
  });
}
