import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the prevailing visibility from meters', () {
    final code =
        'METAR SBBV 170400Z 08004KT 9999 SCT030 FEW035TCU BKN070 26/23 Q1012';
    final metar = Metar(code);

    expect(metar.visibility.code, '9999');
    expect(metar.visibility.cardinalDirection, null);
    expect(metar.visibility.directionInDegrees, null);
    expect(metar.visibility.directionInGradians, null);
    expect(metar.visibility.directionInRadians, null);
    expect(metar.visibility.inKilometers, 10.0);
    expect(metar.visibility.inMeters, 10000.0);
    expect(metar.visibility.inFeet, 32808.39895);
    expect(metar.visibility.inSeaMiles, 5.39957);
    expect(metar.visibility.toString(), '10.0 km');
  });

  test('Test the prevailing visibility from sea miles in fractional', () {
    final code =
        'PALH 170933Z 00000KT 1 1/4SM BR FEW002 M14/M16 A2980 RMK AO2 T11441156';
    final metar = Metar(code);

    expect(metar.visibility.code, '1 1/4SM');
    expect(metar.visibility.cardinalDirection, null);
    expect(metar.visibility.directionInDegrees, null);
    expect(metar.visibility.directionInGradians, null);
    expect(metar.visibility.directionInRadians, null);
    expect(metar.visibility.inKilometers, 2.315);
    expect(metar.visibility.inMeters, 2315.0);
    expect(metar.visibility.inFeet, 7595.14436);
    expect(metar.visibility.inSeaMiles, 1.25);
    expect(metar.visibility.toString(), '2.315 km');
  });

  test('Test the prevailing visibility from sea miles in integer', () {
    final code =
        'PALH 170936Z 00000KT 5SM BR CLR M14/M16 A2980 RMK AO2 T11441161';
    final metar = Metar(code);

    expect(metar.visibility.code, '5SM');
    expect(metar.visibility.cardinalDirection, null);
    expect(metar.visibility.directionInDegrees, null);
    expect(metar.visibility.directionInGradians, null);
    expect(metar.visibility.directionInRadians, null);
    expect(metar.visibility.inKilometers, 9.26);
    expect(metar.visibility.inMeters, 9260.0);
    expect(metar.visibility.inFeet, 30380.57743);
    expect(metar.visibility.inSeaMiles, 5.0);
    expect(metar.visibility.toString(), '9.26 km');
  });

  test('Test the minimum visibility of METAR', () {
    final code =
        'UUDD 180100Z 00000MPS 4800 2100NW -SN BR SCT025 M02/M03 Q1007 R32L/290042 NOSIG';
    final metar = Metar(code);

    expect(metar.minimumVisibility.code, '2100NW');
    expect(metar.minimumVisibility.cardinalDirection, 'NW');
    expect(metar.minimumVisibility.directionInDegrees, 315.0);
    expect(metar.minimumVisibility.directionInGradians, 350.0);
    expect(metar.minimumVisibility.directionInRadians, 5.49779);
    expect(metar.minimumVisibility.inKilometers, 2.10);
    expect(metar.minimumVisibility.inMeters, 2100.0);
    expect(metar.minimumVisibility.inFeet, 6889.76378);
    expect(metar.minimumVisibility.inSeaMiles, 1.13391);
    expect(metar.minimumVisibility.toString(), '2.1 km to NW');
  });

  test('Test the METAR with one runway range', () {
    final code =
        'METAR SCFA 121300Z 21008KT 9999 3000W R07L/M0150V0600U TSRA FEW020 20/13 Q1014 NOSIG';
    final metar = Metar(code);

    expect(metar.runwayRanges.codes, ['R07L/M0150V0600U']);
    expect(
      metar.runwayRanges.toString(),
      'runway 07 left below of 150.0 meters varying to 600.0 meters increasing',
    );
    // First
    expect(metar.runwayRanges.first.name, '07 left');
    expect(metar.runwayRanges.first.low, 'below of 150.0 meters');
    expect(metar.runwayRanges.first.lowInMeters, 150.0);
    expect(metar.runwayRanges.first.lowInKilometers, 0.150);
    expect(metar.runwayRanges.first.lowInFeet, 492.12598);
    expect(metar.runwayRanges.first.high, '600.0 meters');
    expect(metar.runwayRanges.first.highInMeters, 600.0);
    expect(metar.runwayRanges.first.highInKilometers, 0.600);
    expect(metar.runwayRanges.first.highInFeet, 1968.50394);
    // Second
    expect(metar.runwayRanges.second.name, null);
    expect(metar.runwayRanges.second.low, '');
    expect(metar.runwayRanges.second.lowInMeters, null);
    expect(metar.runwayRanges.second.lowInKilometers, null);
    expect(metar.runwayRanges.second.lowInFeet, null);
    expect(metar.runwayRanges.second.high, '');
    expect(metar.runwayRanges.second.highInMeters, null);
    expect(metar.runwayRanges.second.highInKilometers, null);
    expect(metar.runwayRanges.second.highInFeet, null);
  });

  test('Test the METAR with two runway ranges', () {
    final code =
        'METAR SCFA 121300Z 21008KT 9999 3000W R07L/M0150V0600U R25C/P1000N TSRA FEW020 20/13 Q1014 NOSIG';
    final metar = Metar(code);

    expect(metar.runwayRanges.codes, ['R07L/M0150V0600U', 'R25C/P1000N']);
    expect(
      metar.runwayRanges.toString(),
      'runway 07 left below of 150.0 meters varying to 600.0 meters increasing | runway 25 center above of 1000.0 meters no change',
    );
    // First
    expect(metar.runwayRanges.first.name, '07 left');
    expect(metar.runwayRanges.first.low, 'below of 150.0 meters');
    expect(metar.runwayRanges.first.lowInMeters, 150.0);
    expect(metar.runwayRanges.first.lowInKilometers, 0.150);
    expect(metar.runwayRanges.first.lowInFeet, 492.12598);
    expect(metar.runwayRanges.first.high, '600.0 meters');
    expect(metar.runwayRanges.first.highInMeters, 600.0);
    expect(metar.runwayRanges.first.highInKilometers, 0.600);
    expect(metar.runwayRanges.first.highInFeet, 1968.50394);
    // Second
    expect(metar.runwayRanges.second.name, '25 center');
    expect(metar.runwayRanges.second.low, 'above of 1000.0 meters');
    expect(metar.runwayRanges.second.lowInMeters, 1000.0);
    expect(metar.runwayRanges.second.lowInKilometers, 1.0);
    expect(metar.runwayRanges.second.lowInFeet, 3280.8399);
    expect(metar.runwayRanges.second.high, '');
    expect(metar.runwayRanges.second.highInMeters, null);
    expect(metar.runwayRanges.second.highInKilometers, null);
    expect(metar.runwayRanges.second.highInFeet, null);
  });
}
