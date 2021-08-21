import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the sky items of METAR: two layers', () {
    final code = 'METAR BIAR 190800Z 20015KT 9999 FEW049 BKN056 10/03 Q1016';
    final metar = Metar(code);
    final layer_1 = metar.sky.first;
    final layer_2 = metar.sky.second;

    test('Test the cover of sky layers', () {
      final value_1 = layer_1.cover;
      final value_2 = layer_2.cover;
      expect(value_1, 'a few');
      expect(value_2, 'broken');
    });

    test('Test the length in feet of sky layers', () {
      final value_1 = layer_1.heightInFeet;
      final value_2 = layer_2.heightInFeet;
      expect(value_1, 4900.0);
      expect(value_2, 5600.0);
    });

    test('Test the length in kilometers of sky layers', () {
      final value_1 = layer_1.heightInKilometers;
      final value_2 = layer_2.heightInKilometers;
      expect(value_1, 1.49352);
      expect(value_2, 1.70688);
    });

    test('Test the length in sea miles of sky layers', () {
      final value_1 = layer_1.heightInSeaMiles;
      final value_2 = layer_2.heightInSeaMiles;
      expect(value_1, 0.80644);
      expect(value_2, 0.92164);
    });

    test('Test the cloud type of sky layers', () {
      final value_1 = layer_1.cloud;
      final value_2 = layer_2.cloud;
      expect(value_1, null);
      expect(value_2, null);
    });
  });

  group('Test the sky items of METAR: three layers', () {
    final code =
        'METAR KMIA 191458Z 33006KT 5SM R09/1800V4500FT -TSRA BR FEW013 BKN021CB OVC040 23/21 A3003 RMK AO2 OCNL LTGICCG OHD TS OHD MOV SE P0007 T02280211';
    final metar = Metar(code);
    final layer_1 = metar.sky.first;
    final layer_2 = metar.sky.second;
    final layer_3 = metar.sky.third;

    test('Test the cover of sky layers', () {
      final value_1 = layer_1.cover;
      final value_2 = layer_2.cover;
      final value_3 = layer_3.cover;
      expect(value_1, 'a few');
      expect(value_2, 'broken');
      expect(value_3, 'overcast');
    });

    test('Test the length in feet of sky layers', () {
      final value_1 = layer_1.heightInFeet;
      final value_2 = layer_2.heightInFeet;
      final value_3 = layer_3.heightInFeet;
      expect(value_1, 1300.0);
      expect(value_2, 2100.0);
      expect(value_3, 4000.0);
    });

    test('Test the length in kilometers of sky layers', () {
      final value_1 = layer_1.heightInKilometers;
      final value_2 = layer_2.heightInKilometers;
      final value_3 = layer_3.heightInKilometers;
      expect(value_1, 0.39624);
      expect(value_2, 0.64008);
      expect(value_3, 1.2192);
    });

    test('Test the length in sea miles of sky layers', () {
      final value_1 = layer_1.heightInSeaMiles;
      final value_2 = layer_2.heightInSeaMiles;
      final value_3 = layer_3.heightInSeaMiles;
      expect(value_1, 0.21395);
      expect(value_2, 0.34562);
      expect(value_3, 0.65832);
    });

    test('Test the cloud type of sky layers', () {
      final value_1 = layer_1.cloud;
      final value_2 = layer_2.cloud;
      final value_3 = layer_3.cloud;
      expect(value_1, null);
      expect(value_2, 'cumulonimbus');
      expect(value_3, null);
    });
  });
}
