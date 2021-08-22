import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the temperatures of METAR', () {
    final code =
        'METAR LHBP 191530Z 17007KT 9999 VCSH FEW018CB SCT029 04/M03 Q1015 NOSIG';
    final metar = Metar(code);

    test('Test the absolute temperature in Celsius', () {
      final value = metar.temperatures.temperatureInCelsius;
      expect(value, 4.0);
    });

    test('Test the absolute temperature in Fahrenheit', () {
      final value = metar.temperatures.temperatureInFahrenheit;
      expect(value, 39.2);
    });

    test('Test the absolute temperature in Kelvin', () {
      final value = metar.temperatures.temperatureInKelvin;
      expect(value, 277.15);
    });

    test('Test the dewpoint temperature in Celsius', () {
      final value = metar.temperatures.dewpointInCelsius;
      expect(value, -3.0);
    });

    test('Test the dewpoint temperature in Fahrenheit', () {
      final value = metar.temperatures.dewpointInFahrenheit;
      expect(value, 26.6);
    });

    test('Test the dewpoint temperature in Kelvin', () {
      final value = metar.temperatures.dewpointInKelvin;
      expect(value, 270.15);
    });
  });

  group('Test the temperatures of METAR', () {
    final code = 'MSSS 182050Z 17011KT 130V220 9999 FEW060 31/19 Q1012 A2990';
    final metar = Metar(code);

    test('Test the absolute temperature in Celsius', () {
      final value = metar.temperatures.temperatureInCelsius;
      expect(value, 31.0);
    });

    test('Test the absolute temperature in Fahrenheit', () {
      final value = metar.temperatures.temperatureInFahrenheit;
      expect(value, 87.8);
    });

    test('Test the absolute temperature in Kelvin', () {
      final value = metar.temperatures.temperatureInKelvin;
      expect(value, 304.15);
    });

    test('Test the dewpoint temperature in Celsius', () {
      final value = metar.temperatures.dewpointInCelsius;
      expect(value, 19.0);
    });

    test('Test the dewpoint temperature in Fahrenheit', () {
      final value = metar.temperatures.dewpointInFahrenheit;
      expect(value, 66.2);
    });

    test('Test the dewpoint temperature in Kelvin', () {
      final value = metar.temperatures.dewpointInKelvin;
      expect(value, 292.15);
    });
  });

  group('Test the temperatures of METAR', () {
    final code = 'MSSS 182050Z 17011KT 130V220 9999 FEW060 //\/// Q1012 A2990';
    final metar = Metar(code);

    test('Test the absolute temperature in Celsius as null', () {
      final value = metar.temperatures.temperatureInCelsius;
      expect(value, null);
    });

    test('Test the dewpoint temperature in Celsius as null', () {
      final value = metar.temperatures.dewpointInCelsius;
      expect(value, null);
    });
  });
}
