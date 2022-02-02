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
    expect(seaState.toString(), 'temperature 20.0°C, rough');
    expect(seaState.temperatureInCelsius, 20.0);
    expect(seaState.temperatureInFahrenheit, 68.0);
    expect(seaState.temperatureInKelvin, 293.15);
    expect(seaState.temperatureInRankine, closeTo(527.67, delta));
  });

  test('Test the sea state of METAR. Negative temperature', () {
    final code =
        'METAR LXGB 201950Z AUTO 09012KT 9999 BKN080/// 14/07 Q1016 RERA WM01/S8';
    final metar = Metar(code);
    final seaState = metar.seaState;

    expect(seaState.code, 'WM01/S8');
    expect(seaState.state, 'very high');
    expect(seaState.toString(), 'temperature -1.0°C, very high');
    expect(seaState.temperatureInCelsius, -1.0);
    expect(seaState.temperatureInFahrenheit, 30.2);
    expect(seaState.temperatureInKelvin, 272.15);
    expect(seaState.temperatureInRankine, closeTo(489.87, delta));
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
  });
}
