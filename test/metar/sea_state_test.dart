import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the sea state of METAR. Positive temperature', () {
    final code =
        'METAR LXGB 201950Z AUTO 09012KT 9999 BKN080/// 14/07 Q1016 RERA W20/S5';
    final metar = Metar(code);
    final seaState = metar.seaState;

    test('Test the temperature', () {
      final value = seaState.temperatureInCelsius;
      expect(value, 20.0);
    });

    test('Test the temperature', () {
      final value = seaState.temperatureInFahrenheit;
      expect(value, 68.0);
    });

    test('Test the temperature', () {
      final value = seaState.temperatureInKelvin;
      expect(value, 293.15);
    });

    test('Test the temperature', () {
      final value = seaState.temperatureInRankine;
      expect(value, 527.67);
    });

    test('Test the state', () {
      final value = seaState.state;
      expect(value, 'rough');
    });
  });

  group('Test the sea state of METAR. Negative temperature', () {
    final code =
        'METAR LXGB 201950Z AUTO 09012KT 9999 BKN080/// 14/07 Q1016 RERA WM01/S8';
    final metar = Metar(code);
    final seaState = metar.seaState;

    test('Test the temperature', () {
      final value = seaState.temperatureInCelsius;
      expect(value, -1.0);
    });

    test('Test the temperature', () {
      final value = seaState.temperatureInFahrenheit;
      expect(value, 30.2);
    });

    test('Test the temperature', () {
      final value = seaState.temperatureInKelvin;
      expect(value, 272.15);
    });

    test('Test the temperature', () {
      final value = seaState.temperatureInRankine;
      expect(value, 489.87);
    });

    test('Test the state', () {
      final value = seaState.state;
      expect(value, 'very high');
    });
  });
}
