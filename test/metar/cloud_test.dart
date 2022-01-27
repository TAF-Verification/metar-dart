import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test two layers of clouds in METAR', () {
    final code = 'METAR BIAR 190800Z 20015KT 9999 FEW049 BKN056 10/03 Q1016';
    final metar = Metar(code);
    final clouds = metar.clouds;

    expect(clouds.codes, <String>['FEW049', 'BKN056']);
    expect(clouds.toString(), 'a few at 4900.0 feet | broken at 5600.0 feet');
    expect(clouds.ceiling, false);

    expect(clouds[0].code, 'FEW049');
    expect(clouds[0].cover, 'a few');
    expect(clouds[0].oktas, '1-2');
    expect(clouds[0].heightInFeet, 4899.999999999999);
    expect(clouds[0].heightInMeters, 1493.52);
    expect(clouds[0].heightInKilometers, 1.49352);
    expect(clouds[0].heightInSeaMiles, 0.8064362850971921);
    expect(clouds[0].cloudType, null);

    expect(clouds[1].code, 'BKN056');
    expect(clouds[1].cover, 'broken');
    expect(clouds[1].oktas, '5-7');
    expect(clouds[1].heightInFeet, 5600.0);
    expect(clouds[1].heightInMeters, 1706.88);
    expect(clouds[1].heightInKilometers, 1.7068800000000002);
    expect(clouds[1].heightInSeaMiles, 0.9216414686825053);
    expect(clouds[1].cloudType, null);

    expect(
      () => clouds[2].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test three layers of clouds in METAR', () {
    final code =
        'METAR KMIA 191458Z 33006KT 5SM R09/1800V4500FT -TSRA BR FEW013 BKN021CB OVC040 23/21 A3003 RMK AO2 OCNL LTGICCG OHD TS OHD MOV SE P0007 T02280211';
    final metar = Metar(code);
    final clouds = metar.clouds;

    expect(clouds.codes, <String>['FEW013', 'BKN021CB', 'OVC040']);
    expect(clouds.toString(),
        'a few at 1300.0 feet | broken at 2100.0 feet of cumulonimbus | overcast at 4000.0 feet');
    expect(clouds.ceiling, false);

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

  test('Test no clouds in METAR', () {
    final code = 'METAR MROC 190700Z 11009KT CAVOK 22/19 A2997 NOSIG';
    final metar = Metar(code);
    final clouds = metar.clouds;

    expect(clouds.codes, <String>[]);
    expect(clouds.toString(), '');

    for (var i = 0; i < 4; i++) {
      expect(
        () => clouds[i].code,
        throwsA(isA<RangeError>()),
      );
    }
  });

  test('Test vertical visibility', () {
    final code = 'METAR BIHN 051900Z AUTO 33008KT 1000 +SN VV/// M02/M04 Q1006';
    final metar = Metar(code);
    final clouds = metar.clouds;

    expect(clouds.codes, <String>['VV///']);
    expect(clouds.toString(), 'indefinite ceiling');
    expect(clouds.ceiling, false);

    expect(clouds[0].code, 'VV///');
    expect(clouds[0].cover, 'indefinite ceiling');
    expect(clouds[0].oktas, 'undefined');
    expect(clouds[0].heightInFeet, null);
    expect(clouds[0].heightInMeters, null);
    expect(clouds[0].heightInKilometers, null);
    expect(clouds[0].heightInSeaMiles, null);
    expect(clouds[0].cloudType, null);

    for (var i = 1; i < 3; i++) {
      expect(
        () => clouds[i].code,
        throwsA(isA<RangeError>()),
      );
    }
  });

  test('Test vertical visibility with height', () {
    final code = 'METAR BIHN 051900Z AUTO 33008KT 1000 +SN VV005 M02/M04 Q1006';
    final metar = Metar(code);
    final clouds = metar.clouds;

    expect(clouds.codes, <String>['VV005']);
    expect(clouds.toString(), 'indefinite ceiling at 500.0 feet');
    expect(clouds.ceiling, false);

    expect(clouds[0].code, 'VV005');
    expect(clouds[0].cover, 'indefinite ceiling');
    expect(clouds[0].oktas, 'undefined');
    expect(clouds[0].heightInFeet, 499.99999999999994);
    expect(clouds[0].heightInMeters, 152.4);
    expect(clouds[0].heightInKilometers, 0.1524);
    expect(clouds[0].heightInSeaMiles, 0.08228941684665227);
    expect(clouds[0].cloudType, null);

    for (var i = 1; i < 3; i++) {
      expect(
        () => clouds[i].code,
        throwsA(isA<RangeError>()),
      );
    }
  });
}
