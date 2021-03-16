import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final code =
      'SEQM 162000Z 34012G22KT 310V020 9999 VCSH SCT030 BKN200 21/12 Q1022 NOSIG RMK A3018';
  final metar = Metar(code);

  group('Test the wind direction of METAR', () {
    test('Test the direction in degrees', () {
      final value = metar.windDirection.directionInDegrees;
      expect(value, 340.0);
    });

    test('Test the cardinal point of wind direction', () {
      final value = metar.windDirection.cardinalPoint;
      expect(value, 'NNW');
    });
  });

  group('Test the wind speed of METAR', () {
    test('Test the wind speedn in knots', () {
      final value = metar.windSpeed.inKnot;
      expect(value, 12.0);
    });

    test('Test the wind speed in km/h', () {
      final value = metar.windSpeed.inKilometerPerHour;
      expect(value, 22.224);
    });

    test('Test the wind speed in m/s', () {
      final value = metar.windSpeed.inMeterPerSecond;
      expect(value, 6.173333);
    });
  });

  group('Test the wind gust of METAR', () {
    test('Test the wind gust in knots', () {
      final value = metar.windGust.inKnot;
      expect(value, 22.0);
    });

    test('Test the wind gust in km/h', () {
      final value = metar.windGust.inKilometerPerHour;
      expect(value, 40.744);
    });

    test('Test the wind gust in m/s', () {
      final value = metar.windGust.inMeterPerSecond;
      expect(value, 11.317778);
    });
  });
}
