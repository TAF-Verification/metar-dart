import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the recent weather of METAR. Sample No. 1', () {
    final code =
        'METAR MRLM 192300Z 05010KT 5000 +DZ FEW010 OVC080 24/23 A2987 RERA';
    final metar = Metar(code);

    expect(metar.recentWeather.description, null);
    expect(metar.recentWeather.precipitation, 'rain');
    expect(metar.recentWeather.obscuration, null);
    expect(metar.recentWeather.other, null);
    expect(metar.recentWeather.toString(), 'rain');
  });

  test('Test the recent weather of METAR. Sample No. 1', () {
    final code =
        'METAR SKBO 200800Z 36004KT 5000 RA FEW017 SCT070 10/09 Q1025 RETSGR NOSIG RMK A3029';
    final metar = Metar(code);

    expect(metar.recentWeather.description, 'thunderstorm');
    expect(metar.recentWeather.precipitation, 'hail');
    expect(metar.recentWeather.obscuration, null);
    expect(metar.recentWeather.other, null);
    expect(metar.recentWeather.toString(), 'thunderstorm hail');
  });

  test('Test no recent weather.', () {
    final code =
        'METAR MRPV 160000Z 32006KT 4000 TSRA OVC008CB 20/20 A3002 NOSIG';
    final metar = Metar(code);

    expect(metar.recentWeather.description, null);
    expect(metar.recentWeather.precipitation, null);
    expect(metar.recentWeather.obscuration, null);
    expect(metar.recentWeather.other, null);
    expect(metar.recentWeather.toString(), '');
  });
}
