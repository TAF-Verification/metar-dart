import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final delta = 0.001;

  test('Test the sea state of METAR. Positive temperature', () {
    final code =
        'METAR LXGB 201950Z AUTO 09012KT 9999 BKN080/// 14/07 Q1016 RERA W20/S5';
    final metar = Metar(code);
    final seaState = metar.seaState;

    expect(seaState.code, 'W20/S5');
    expect(seaState.state, 'rough');
    expect(seaState.toString(),
        'temperature 20.0°C, no significant wave height, rough');
    expect(seaState.temperatureInCelsius, 20.0);
    expect(seaState.temperatureInFahrenheit, 68.0);
    expect(seaState.temperatureInKelvin, 293.15);
    expect(seaState.temperatureInRankine, closeTo(527.67, delta));
    expect(seaState.heightInMeters, null);
    expect(seaState.heightInCentimeters, null);
    expect(seaState.heightInDecimeters, null);
    expect(seaState.heightInFeet, null);
    expect(seaState.heightInInches, null);
  });

  test('Test the sea state of METAR. Negative temperature', () {
    final code =
        'METAR LXGB 201950Z AUTO 09012KT 9999 BKN080/// 14/07 Q1016 RERA WM01/S8';
    final metar = Metar(code);
    final seaState = metar.seaState;

    expect(seaState.code, 'WM01/S8');
    expect(seaState.state, 'very high');
    expect(seaState.toString(),
        'temperature -1.0°C, no significant wave height, very high');
    expect(seaState.temperatureInCelsius, -1.0);
    expect(seaState.temperatureInFahrenheit, 30.2);
    expect(seaState.temperatureInKelvin, 272.15);
    expect(seaState.temperatureInRankine, closeTo(489.87, delta));
    expect(seaState.heightInMeters, null);
    expect(seaState.heightInCentimeters, null);
    expect(seaState.heightInDecimeters, null);
    expect(seaState.heightInFeet, null);
    expect(seaState.heightInInches, null);
  });

  test('Test the sea state of METAR. With significant wave height', () {
    final code =
        'METAR LXGB 032250Z 25006KT CAVOK 16/07 Q1022 W15/H008 NOSIG RMK BLU BLU';
    final metar = Metar(code);
    final seaState = metar.seaState;

    expect(seaState.code, 'W15/H008');
    expect(seaState.state, null);
    expect(seaState.toString(),
        'temperature 15.0°C, significant wave height 0.8 m, no sea state');
    expect(seaState.temperatureInCelsius, 15.0);
    expect(seaState.temperatureInFahrenheit, 59.0);
    expect(seaState.temperatureInKelvin, 288.15);
    expect(seaState.temperatureInRankine, closeTo(518.67, delta));
    expect(seaState.heightInMeters, 0.8);
    expect(seaState.heightInCentimeters, 80.0);
    expect(seaState.heightInDecimeters, 8.0);
    expect(seaState.heightInFeet, closeTo(2.62467, 0.000002));
    expect(seaState.heightInInches, closeTo(31.49608, 0.000001));
  });

  test('Test no sea state', () {
    final code =
        'METAR LXGB 201950Z AUTO 09012KT 9999 BKN080/// 14/07 Q1016 RERA';
    final metar = Metar(code);
    final seaState = metar.seaState;

    expect(seaState.code, null);
    expect(seaState.state, null);
    expect(seaState.toString(), '');
    expect(seaState.temperatureInCelsius, null);
    expect(seaState.temperatureInFahrenheit, null);
    expect(seaState.temperatureInKelvin, null);
    expect(seaState.temperatureInRankine, null);
    expect(seaState.heightInMeters, null);
    expect(seaState.heightInCentimeters, null);
    expect(seaState.heightInDecimeters, null);
    expect(seaState.heightInFeet, null);
    expect(seaState.heightInInches, null);
  });
}
