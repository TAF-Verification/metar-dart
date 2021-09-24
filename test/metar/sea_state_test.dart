import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the sea state of METAR. Positive temperature', () {
    final code =
        'METAR LXGB 201950Z AUTO 09012KT 9999 BKN080/// 14/07 Q1016 RERA W20/S5';
    final metar = Metar(code);
    final seaState = metar.seaState;

    expect(seaState.code, 'W20/S5');
    expect(seaState.temperatureInCelsius, 20.0);
    expect(seaState.temperatureInFahrenheit, 68.0);
    expect(seaState.temperatureInKelvin, 293.15);
    expect(seaState.temperatureInRankine, 527.67);
    expect(seaState.state, 'rough');
    expect(seaState.toString(), 'temperature 20.0°, rough');
  });

  test('Test the sea state of METAR. Negative temperature', () {
    final code =
        'METAR LXGB 201950Z AUTO 09012KT 9999 BKN080/// 14/07 Q1016 RERA WM01/S8';
    final metar = Metar(code);
    final seaState = metar.seaState;

    expect(seaState.code, 'WM01/S8');
    expect(seaState.temperatureInCelsius, -1.0);
    expect(seaState.temperatureInFahrenheit, 30.2);
    expect(seaState.temperatureInKelvin, 272.15);
    expect(seaState.temperatureInRankine, 489.87);
    expect(seaState.state, 'very high');
    expect(seaState.toString(), 'temperature -1.0°, very high');
  });

  test('Test no sea state', () {
    final code =
        'METAR LXGB 201950Z AUTO 09012KT 9999 BKN080/// 14/07 Q1016 RERA';
    final metar = Metar(code);
    final seaState = metar.seaState;

    expect(seaState.code, null);
    expect(seaState.temperatureInCelsius, null);
    expect(seaState.temperatureInFahrenheit, null);
    expect(seaState.temperatureInKelvin, null);
    expect(seaState.temperatureInRankine, null);
    expect(seaState.state, null);
    expect(seaState.toString(), '');
  });
}
