import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the METAR with one runway range', () {
    final code =
        'METAR SCFA 121300Z 21008KT 9999 3000W R07L/M0150V0600U TSRA FEW020 20/13 Q1014 NOSIG';
    final metar = Metar(code);
    final ranges = metar.runwayRanges;

    expect(ranges.codes, ['R07L/M0150V0600U']);

    expect(ranges[0].code, 'R07L/M0150V0600U');
    expect(ranges[0].lowInMeters, 150.0);
    expect(ranges[0].lowInKilometers, 0.150);
    expect(ranges[0].lowInSeaMiles, 0.08099352051835852);
    expect(ranges[0].lowInFeet, 492.1259842519685);
    expect(ranges[0].highInMeters, 600.0);
    expect(ranges[0].highInKilometers, 0.600);
    expect(ranges[0].highInSeaMiles, 0.3239740820734341);
    expect(ranges[0].highInFeet, 1968.503937007874);
    expect(ranges[0].name, '07 left');
    expect(ranges[0].lowRange, 'below of 150.0 m');
    expect(ranges[0].highRange, '600.0 m');
    expect(
      ranges.toString(),
      'runway 07 left below of 150.0 m varying to 600.0 m, increasing',
    );
    expect(
        ranges[0].asMap(),
        equals(<String, Object?>{
          'name': '07 left',
          'rvr_low': 'below of',
          'low_range': {'units': 'meters', 'distance': 150.0},
          'rvr_high': null,
          'high_range': {'units': 'meters', 'distance': 600.0},
          'trend': 'increasing',
          'code': 'R07L/M0150V0600U',
        }));

    expect(
      () => ranges[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test the METAR with one runway range and no high range', () {
    final code =
        'METAR SCFA 121300Z 21008KT 9999 3000W R25C/P0150D TSRA FEW020 20/13 Q1014 NOSIG';
    final metar = Metar(code);
    final ranges = metar.runwayRanges;

    expect(ranges.codes, ['R25C/P0150D']);

    expect(ranges[0].code, 'R25C/P0150D');
    expect(ranges[0].lowInMeters, 150.0);
    expect(ranges[0].lowInKilometers, 0.150);
    expect(ranges[0].lowInSeaMiles, 0.08099352051835852);
    expect(ranges[0].lowInFeet, 492.1259842519685);
    expect(ranges[0].highInMeters, null);
    expect(ranges[0].highInKilometers, null);
    expect(ranges[0].highInSeaMiles, null);
    expect(ranges[0].highInFeet, null);
    expect(ranges[0].name, '25 center');
    expect(ranges[0].lowRange, 'above of 150.0 m');
    expect(ranges[0].highRange, '');
    expect(
      ranges.toString(),
      'runway 25 center above of 150.0 m, decreasing',
    );
    expect(
        ranges[0].asMap(),
        equals(<String, Object?>{
          'name': '25 center',
          'rvr_low': 'above of',
          'low_range': {'units': 'meters', 'distance': 150.0},
          'rvr_high': null,
          'high_range': {'units': 'meters', 'distance': null},
          'trend': 'decreasing',
          'code': 'R25C/P0150D',
        }));

    expect(
      () => ranges[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test the METAR with two runway ranges', () {
    final code =
        'METAR SCFA 121300Z 21008KT 9999 3000W R07L/M0150V0600U R25C/P0150D TSRA FEW020 20/13 Q1014 NOSIG';
    final metar = Metar(code);
    final ranges = metar.runwayRanges;

    expect(ranges.codes, ['R07L/M0150V0600U', 'R25C/P0150D']);

    expect(ranges[0].code, 'R07L/M0150V0600U');
    expect(ranges[0].lowInMeters, 150.0);
    expect(ranges[0].lowInKilometers, 0.150);
    expect(ranges[0].lowInSeaMiles, 0.08099352051835852);
    expect(ranges[0].lowInFeet, 492.1259842519685);
    expect(ranges[0].highInMeters, 600.0);
    expect(ranges[0].highInKilometers, 0.600);
    expect(ranges[0].highInSeaMiles, 0.3239740820734341);
    expect(ranges[0].highInFeet, 1968.503937007874);
    expect(ranges[0].name, '07 left');
    expect(ranges[0].lowRange, 'below of 150.0 m');
    expect(ranges[0].highRange, '600.0 m');
    expect(
      ranges[0].toString(),
      'runway 07 left below of 150.0 m varying to 600.0 m, increasing',
    );
    expect(
        ranges[0].asMap(),
        equals(<String, Object?>{
          'name': '07 left',
          'rvr_low': 'below of',
          'low_range': {'units': 'meters', 'distance': 150.0},
          'rvr_high': null,
          'high_range': {'units': 'meters', 'distance': 600.0},
          'trend': 'increasing',
          'code': 'R07L/M0150V0600U',
        }));

    expect(ranges[1].code, 'R25C/P0150D');
    expect(ranges[1].lowInMeters, 150.0);
    expect(ranges[1].lowInKilometers, 0.150);
    expect(ranges[1].lowInSeaMiles, 0.08099352051835852);
    expect(ranges[1].lowInFeet, 492.1259842519685);
    expect(ranges[1].highInMeters, null);
    expect(ranges[1].highInKilometers, null);
    expect(ranges[1].highInSeaMiles, null);
    expect(ranges[1].highInFeet, null);
    expect(ranges[1].name, '25 center');
    expect(ranges[1].lowRange, 'above of 150.0 m');
    expect(ranges[1].highRange, '');
    expect(
      ranges[1].toString(),
      'runway 25 center above of 150.0 m, decreasing',
    );
    expect(
        ranges[1].asMap(),
        equals(<String, Object?>{
          'name': '25 center',
          'rvr_low': 'above of',
          'low_range': {'units': 'meters', 'distance': 150.0},
          'rvr_high': null,
          'high_range': {'units': 'meters', 'distance': null},
          'trend': 'decreasing',
          'code': 'R25C/P0150D',
        }));

    expect(
      () => ranges[2].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test the METAR without runway ranges', () {
    final code =
        'METAR SCFA 121300Z 21008KT 9999 3000W TSRA FEW020 20/13 Q1014 NOSIG';
    final metar = Metar(code);
    final ranges = metar.runwayRanges;

    expect(ranges.codes, equals(<String>[]));
    expect(ranges.toString(), '');
    expect(ranges.asMap(), equals(<String, Object?>{}));

    for (var i = 0; i < 3; i++) {
      expect(
        () => ranges[i].code,
        throwsA(isA<RangeError>()),
      );
    }
  });

  test('Test the try to get item number 4 from runway ranges', () {
    final code =
        'METAR SCFA 121300Z 21008KT 9999 3000W R07L/M0150V0600U R25C/P0150D R25L/P0500N TSRA FEW020 20/13 Q1014 NOSIG';
    final metar = Metar(code);
    final ranges = metar.runwayRanges;

    expect(ranges.codes, ['R07L/M0150V0600U', 'R25C/P0150D', 'R25L/P0500N']);
    expect(
        ranges.toString(),
        'runway 07 left below of 150.0 m varying to 600.0 m, increasing '
        '| runway 25 center above of 150.0 m, decreasing '
        '| runway 25 left above of 500.0 m, no change');
    expect(
        ranges.asMap(),
        equals(<String, Object?>{
          'first': {
            'name': '07 left',
            'rvr_low': 'below of',
            'low_range': {'units': 'meters', 'distance': 150.0},
            'rvr_high': null,
            'high_range': {'units': 'meters', 'distance': 600.0},
            'trend': 'increasing',
            'code': 'R07L/M0150V0600U',
          },
          'second': {
            'name': '25 center',
            'rvr_low': 'above of',
            'low_range': {'units': 'meters', 'distance': 150.0},
            'rvr_high': null,
            'high_range': {'units': 'meters', 'distance': null},
            'trend': 'decreasing',
            'code': 'R25C/P0150D',
          },
          'third': {
            'name': '25 left',
            'rvr_low': 'above of',
            'low_range': {'units': 'meters', 'distance': 500.0},
            'rvr_high': null,
            'high_range': {'units': 'meters', 'distance': null},
            'trend': 'no change',
            'code': 'R25L/P0500N',
          }
        }));

    expect(
      () => ranges[3].code,
      throwsA(isA<RangeError>()),
    );
  });
}
