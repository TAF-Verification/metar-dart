import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final delta = 0.001;
  test('Test the positive temperatures of METAR', () {
    final code =
        'METAR LHBP 191530Z 17007KT 9999 VCSH FEW018CB SCT029 04/02 Q1015 NOSIG';
    final metar = Metar(code);
    final temperatures = metar.temperatures;

    expect(temperatures.code, '04/02');
    expect(temperatures.temperatureInCelsius, 4.0);
    expect(temperatures.temperatureInKelvin, 277.15);
    expect(temperatures.temperatureInFahrenheit, 39.2);
    expect(temperatures.temperatureInRankine, 498.87);
    expect(temperatures.dewpointInCelsius, 2.0);
    expect(temperatures.dewpointInKelvin, 275.15);
    expect(temperatures.dewpointInFahrenheit, 35.6);
    expect(temperatures.dewpointInRankine, closeTo(495.27, delta));
    expect(temperatures.toString(), 'temperature: 4.0°C | dewpoint: 2.0°C');
    expect(
        temperatures.asMap(),
        equals(<String, Object?>{
          'code': '04/02',
          'temperature': {'units': 'celsius', 'temperature': 4.0},
          'dewpoint': {'units': 'celsius', 'temperature': 2.0},
        }));
  });

  test('Test the negative temperatures of METAR', () {
    final code =
        'METAR LHBP 191530Z 17007KT 9999 VCSH FEW018CB SCT029 M01/M04 Q1015 NOSIG';
    final metar = Metar(code);
    final temperatures = metar.temperatures;

    expect(temperatures.code, 'M01/M04');
    expect(temperatures.temperatureInCelsius, -1.0);
    expect(temperatures.temperatureInKelvin, 272.15);
    expect(temperatures.temperatureInFahrenheit, closeTo(30.2, delta));
    expect(temperatures.temperatureInRankine, closeTo(489.87, delta));
    expect(temperatures.dewpointInCelsius, -4.0);
    expect(temperatures.dewpointInKelvin, 269.15);
    expect(temperatures.dewpointInFahrenheit, closeTo(24.8, delta));
    expect(temperatures.dewpointInRankine, closeTo(484.47, delta));
    expect(temperatures.toString(), 'temperature: -1.0°C | dewpoint: -4.0°C');
    expect(
        temperatures.asMap(),
        equals(<String, Object?>{
          'code': 'M01/M04',
          'temperature': {'units': 'celsius', 'temperature': -1.0},
          'dewpoint': {'units': 'celsius', 'temperature': -4.0},
        }));
  });

  test('Test no temperatures in METAR', () {
    final code =
        'METAR MSSS 182050Z 17011KT 130V220 9999 FEW060 ///\// Q1012 A2990';
    final metar = Metar(code);
    final temperatures = metar.temperatures;

    expect(temperatures.code, '///\//');
    expect(temperatures.temperatureInCelsius, null);
    expect(temperatures.temperatureInKelvin, null);
    expect(temperatures.temperatureInFahrenheit, null);
    expect(temperatures.temperatureInRankine, null);
    expect(temperatures.dewpointInCelsius, null);
    expect(temperatures.dewpointInKelvin, null);
    expect(temperatures.dewpointInFahrenheit, null);
    expect(temperatures.dewpointInRankine, null);
    expect(temperatures.toString(), '');
    expect(
        temperatures.asMap(),
        equals(<String, Object?>{
          'code': '/////',
          'temperature': {'units': 'celsius', 'temperature': null},
          'dewpoint': {'units': 'celsius', 'temperature': null},
        }));
  });
}
