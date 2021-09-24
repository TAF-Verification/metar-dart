import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the temperatures of METAR, negative dewpoint', () {
    final code =
        'METAR LHBP 191530Z 17007KT 9999 VCSH FEW018CB SCT029 04/M03 Q1015 NOSIG';
    final metar = Metar(code);

    expect(metar.temperatures.code, '04/M03');
    expect(metar.temperatures.toString(), 'temperature 4.0° | dewpoint -3.0°');
    // Temperature
    expect(metar.temperatures.temperatureInCelsius, 4.0);
    expect(metar.temperatures.temperatureInFahrenheit, 39.2);
    expect(metar.temperatures.temperatureInKelvin, 277.15);
    // Dewpoint
    expect(metar.temperatures.dewpointInCelsius, -3.0);
    expect(metar.temperatures.dewpointInFahrenheit, 26.6);
    expect(metar.temperatures.dewpointInKelvin, 270.15);
  });

  test('Test the temperatures of METAR, both positives', () {
    final code = 'MSSS 182050Z 17011KT 130V220 9999 FEW060 31/19 Q1012 A2990';
    final metar = Metar(code);

    expect(metar.temperatures.code, '31/19');
    expect(metar.temperatures.toString(), 'temperature 31.0° | dewpoint 19.0°');
    // Temperature
    expect(metar.temperatures.temperatureInCelsius, 31.0);
    expect(metar.temperatures.temperatureInFahrenheit, 87.8);
    expect(metar.temperatures.temperatureInKelvin, 304.15);
    // Dewpoint
    expect(metar.temperatures.dewpointInCelsius, 19.0);
    expect(metar.temperatures.dewpointInFahrenheit, 66.2);
    expect(metar.temperatures.dewpointInKelvin, 292.15);
  });

  test('Test no temperatures in METAR', () {
    final code = 'MSSS 182050Z 17011KT 130V220 9999 FEW060 //\/// Q1012 A2990';
    final metar = Metar(code);

    expect(metar.temperatures.code, '//\///');
    expect(metar.temperatures.toString(), '');
    // Temperature
    expect(metar.temperatures.temperatureInCelsius, null);
    expect(metar.temperatures.temperatureInFahrenheit, null);
    expect(metar.temperatures.temperatureInKelvin, null);
    // Dewpoint
    expect(metar.temperatures.dewpointInCelsius, null);
    expect(metar.temperatures.dewpointInFahrenheit, null);
    expect(metar.temperatures.dewpointInKelvin, null);
  });
}
