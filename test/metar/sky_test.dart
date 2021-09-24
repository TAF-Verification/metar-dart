import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the sky items of METAR: two layers', () {
    final code = 'METAR BIAR 190800Z 20015KT 9999 FEW049 BKN056 10/03 Q1016';
    final metar = Metar(code);
    final sky = metar.sky;

    test('Test toString() method', () {
      expect(sky.toString(), 'a few at 4900.0 feet | broken at 5600.0 feet');
    });

    test('Test the layer codes', () {
      expect(sky.first.code, 'FEW049');
      expect(sky.second.code, 'BKN056');
      expect(sky.third.code, null);
      expect(sky.fourth.code, null);
    });

    test('Test the cover of sky layers', () {
      expect(sky.first.cover, 'a few');
      expect(sky.second.cover, 'broken');
      expect(sky.third.cover, null);
      expect(sky.fourth.cover, null);
    });

    test('Test the length in feet of sky layers', () {
      expect(sky.first.heightInFeet, 4900.0);
      expect(sky.second.heightInFeet, 5600.0);
      expect(sky.third.heightInFeet, null);
      expect(sky.fourth.heightInFeet, null);
    });

    test('Test the length in kilometers of sky layers', () {
      expect(sky.first.heightInKilometers, 1.49352);
      expect(sky.second.heightInKilometers, 1.70688);
      expect(sky.third.heightInKilometers, null);
      expect(sky.fourth.heightInKilometers, null);
    });

    test('Test the length in sea miles of sky layers', () {
      expect(sky.first.heightInSeaMiles, 0.80644);
      expect(sky.second.heightInSeaMiles, 0.92164);
      expect(sky.third.heightInSeaMiles, null);
      expect(sky.fourth.heightInSeaMiles, null);
    });

    test('Test the cloud type of sky layers', () {
      expect(sky.first.cloud, null);
      expect(sky.second.cloud, null);
      expect(sky.third.cloud, null);
      expect(sky.fourth.cloud, null);
    });
  });

  group('Test the sky items of METAR: three layers', () {
    final code =
        'METAR KMIA 191458Z 33006KT 5SM R09/1800V4500FT -TSRA BR FEW013 BKN021CB OVC040 23/21 A3003 RMK AO2 OCNL LTGICCG OHD TS OHD MOV SE P0007 T02280211';
    final metar = Metar(code);
    final sky = metar.sky;

    test('Test toString() method', () {
      expect(
        sky.toString(),
        'a few at 1300.0 feet | broken at 2100.0 feet of cumulonimbus | overcast at 4000.0 feet',
      );
    });

    test('Test the layer codes', () {
      expect(sky.first.code, 'FEW013');
      expect(sky.second.code, 'BKN021CB');
      expect(sky.third.code, 'OVC040');
      expect(sky.fourth.code, null);
    });

    test('Test the cover of sky layers', () {
      expect(sky.first.cover, 'a few');
      expect(sky.second.cover, 'broken');
      expect(sky.third.cover, 'overcast');
      expect(sky.fourth.cover, null);
    });

    test('Test the length in feet of sky layers', () {
      expect(sky.first.heightInFeet, 1300.0);
      expect(sky.second.heightInFeet, 2100.0);
      expect(sky.third.heightInFeet, 4000.0);
      expect(sky.fourth.heightInFeet, null);
    });

    test('Test the length in kilometers of sky layers', () {
      expect(sky.first.heightInKilometers, 0.39624);
      expect(sky.second.heightInKilometers, 0.64008);
      expect(sky.third.heightInKilometers, 1.2192);
      expect(sky.fourth.heightInKilometers, null);
    });

    test('Test the length in sea miles of sky layers', () {
      expect(sky.first.heightInSeaMiles, 0.21395);
      expect(sky.second.heightInSeaMiles, 0.34562);
      expect(sky.third.heightInSeaMiles, 0.65832);
      expect(sky.fourth.heightInSeaMiles, null);
    });

    test('Test the cloud type of sky layers', () {
      expect(sky.first.cloud, null);
      expect(sky.second.cloud, 'cumulonimbus');
      expect(sky.third.cloud, null);
      expect(sky.fourth.cloud, null);
    });
  });

  group('Test the no sky items in METAR', () {
    final code = 'METAR MROC 190700Z 11009KT CAVOK 22/19 A2997 NOSIG';
    final metar = Metar(code);
    final sky = metar.sky;

    test('Test toString() method', () {
      expect(sky.toString(), '');
    });

    test('Test the layer codes', () {
      expect(sky.first.code, null);
      expect(sky.second.code, null);
      expect(sky.third.code, null);
      expect(sky.fourth.code, null);
    });

    test('Test the cover of sky layers', () {
      expect(sky.first.cover, null);
      expect(sky.second.cover, null);
      expect(sky.third.cover, null);
      expect(sky.fourth.cover, null);
    });

    test('Test the length in feet of sky layers', () {
      expect(sky.first.heightInFeet, null);
      expect(sky.second.heightInFeet, null);
      expect(sky.third.heightInFeet, null);
      expect(sky.fourth.heightInFeet, null);
    });

    test('Test the length in kilometers of sky layers', () {
      expect(sky.first.heightInKilometers, null);
      expect(sky.second.heightInKilometers, null);
      expect(sky.third.heightInKilometers, null);
      expect(sky.fourth.heightInKilometers, null);
    });

    test('Test the length in sea miles of sky layers', () {
      expect(sky.first.heightInSeaMiles, null);
      expect(sky.second.heightInSeaMiles, null);
      expect(sky.third.heightInSeaMiles, null);
      expect(sky.fourth.heightInSeaMiles, null);
    });

    test('Test the cloud type of sky layers', () {
      expect(sky.first.cloud, null);
      expect(sky.second.cloud, null);
      expect(sky.third.cloud, null);
      expect(sky.fourth.cloud, null);
    });
  });
}
