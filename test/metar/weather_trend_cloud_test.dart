import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test two trend layers of clouds in METAR', () {
    final code =
        'METAR BIAR 190800Z 20015KT 9999 FEW049 BKN056 10/03 Q1016 BECMG 5000 RA SCT010 BKN015';
    final metar = Metar(code);
    final trends = metar.weatherTrends;

    final first = trends[0];
    expect(first.code, 'BECMG 5000 RA SCT010 BKN015');

    final clouds = first.clouds;
    expect(clouds.codes, <String>['SCT010', 'BKN015']);
    expect(
        clouds.toString(), 'scattered at 1000.0 feet | broken at 1500.0 feet');
    expect(clouds.ceiling, true);
    expect(
        clouds.asMap(),
        equals(<String, Object?>{
          'first': {
            'cover': 'scattered',
            'oktas': '3-4',
            'height_units': 'meters',
            'height': 304.8,
            'type': null,
            'code': 'SCT010'
          },
          'second': {
            'cover': 'broken',
            'oktas': '5-7',
            'height_units': 'meters',
            'height': 457.2,
            'type': null,
            'code': 'BKN015'
          }
        }));

    expect(clouds[0].code, 'SCT010');
    expect(clouds[0].cover, 'scattered');
    expect(clouds[0].oktas, '3-4');
    expect(clouds[0].heightInFeet, 999.9999999999999);
    expect(clouds[0].heightInMeters, 304.8);
    expect(clouds[0].heightInKilometers, 0.3048);
    expect(clouds[0].heightInSeaMiles, 0.16457883369330453);
    expect(clouds[0].cloudType, null);

    expect(clouds[1].code, 'BKN015');
    expect(clouds[1].cover, 'broken');
    expect(clouds[1].oktas, '5-7');
    expect(clouds[1].heightInFeet, 1499.9999999999998);
    expect(clouds[1].heightInMeters, 457.2);
    expect(clouds[1].heightInKilometers, 0.4572);
    expect(clouds[1].heightInSeaMiles, 0.24686825053995676);
    expect(clouds[1].cloudType, null);

    expect(
      () => clouds[2].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test three trend layers of clouds in METAR', () {
    final code =
        'METAR KMIA 191458Z 33006KT CAVOK 23/21 A3003 BECMG 5SM -TSRA BR FEW013 BKN021CB OVC040 RMK AO2 OCNL LTGICCG OHD TS OHD MOV SE P0007 T02280211';
    final metar = Metar(code);
    final trends = metar.weatherTrends;

    final first = trends[0];
    expect(first.code, 'BECMG 5SM -TSRA BR FEW013 BKN021CB OVC040');

    final clouds = first.clouds;
    expect(clouds.codes, <String>['FEW013', 'BKN021CB', 'OVC040']);
    expect(clouds.toString(),
        'a few at 1300.0 feet | broken at 2100.0 feet of cumulonimbus | overcast at 4000.0 feet');
    expect(clouds.ceiling, false);
    expect(
        clouds.asMap(),
        equals(<String, Object?>{
          'first': {
            'cover': 'a few',
            'oktas': '1-2',
            'height_units': 'meters',
            'height': 396.24,
            'type': null,
            'code': 'FEW013'
          },
          'second': {
            'cover': 'broken',
            'oktas': '5-7',
            'height_units': 'meters',
            'height': 640.08,
            'type': 'cumulonimbus',
            'code': 'BKN021CB'
          },
          'third': {
            'cover': 'overcast',
            'oktas': '8',
            'height_units': 'meters',
            'height': 1219.2,
            'type': null,
            'code': 'OVC040'
          }
        }));

    expect(clouds[0].code, 'FEW013');
    expect(clouds[0].cover, 'a few');
    expect(clouds[0].oktas, '1-2');
    expect(clouds[0].heightInFeet, 1300.0);
    expect(clouds[0].heightInMeters, 396.24);
    expect(clouds[0].heightInKilometers, 0.39624000000000004);
    expect(clouds[0].heightInSeaMiles, 0.21395248380129586);
    expect(clouds[0].cloudType, null);

    expect(clouds[1].code, 'BKN021CB');
    expect(clouds[1].cover, 'broken');
    expect(clouds[1].oktas, '5-7');
    expect(clouds[1].heightInFeet, 2100.0);
    expect(clouds[1].heightInMeters, 640.08);
    expect(clouds[1].heightInKilometers, 0.6400800000000001);
    expect(clouds[1].heightInSeaMiles, 0.34561555075593947);
    expect(clouds[1].cloudType, 'cumulonimbus');

    expect(clouds[2].code, 'OVC040');
    expect(clouds[2].cover, 'overcast');
    expect(clouds[2].oktas, '8');
    expect(clouds[2].heightInFeet, 3999.9999999999995);
    expect(clouds[2].heightInMeters, 1219.2);
    expect(clouds[2].heightInKilometers, 1.2192);
    expect(clouds[2].heightInSeaMiles, 0.6583153347732181);
    expect(clouds[2].cloudType, null);

    expect(
      () => clouds[3].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test no trend clouds in METAR', () {
    final code = 'METAR MROC 190700Z 11009KT CAVOK 22/19 A2997 TEMPO 9999 RA';
    final metar = Metar(code);
    final trends = metar.weatherTrends;

    final first = trends[0];
    expect(first.code, 'TEMPO 9999 RA');

    final clouds = first.clouds;
    expect(clouds.codes, <String>[]);
    expect(clouds.toString(), '');
    expect(clouds.asMap(), equals(<String, Object?>{}));

    for (var i = 0; i < 4; i++) {
      expect(
        () => clouds[i].code,
        throwsA(isA<RangeError>()),
      );
    }
  });
}
