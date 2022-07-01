import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the recent weather of METAR. Sample No. 1', () {
    final code =
        'METAR MRLM 192300Z 05010KT 5000 +DZ FEW010 OVC080 24/23 A2987 RERA';
    final metar = Metar(code);
    final recentWeather = metar.recentWeather;

    expect(recentWeather.code, 'RERA');
    expect(recentWeather.description, null);
    expect(recentWeather.precipitation, 'rain');
    expect(recentWeather.obscuration, null);
    expect(recentWeather.other, null);
    expect(recentWeather.toString(), 'rain');
    expect(
        recentWeather.asMap(),
        equals(<String, String?>{
          'code': 'RERA',
          'description': null,
          'obscuration': null,
          'other': null,
          'precipitation': 'rain',
        }));
  });

  test('Test the recent weather of METAR. Sample No. 1', () {
    final code =
        'METAR SKBO 200800Z 36004KT 5000 RA FEW017 SCT070 10/09 Q1025 RETSGR NOSIG RMK A3029';
    final metar = Metar(code);
    final recentWeather = metar.recentWeather;

    expect(recentWeather.code, 'RETSGR');
    expect(recentWeather.description, 'thunderstorm');
    expect(recentWeather.precipitation, 'hail');
    expect(recentWeather.obscuration, null);
    expect(recentWeather.other, null);
    expect(recentWeather.toString(), 'thunderstorm hail');
    expect(
        recentWeather.asMap(),
        equals(<String, String?>{
          'code': 'RETSGR',
          'description': 'thunderstorm',
          'obscuration': null,
          'other': null,
          'precipitation': 'hail',
        }));
  });

  test('Test no recent weather.', () {
    final code =
        'METAR MRPV 160000Z 32006KT 4000 TSRA OVC008CB 20/20 A3002 NOSIG';
    final metar = Metar(code);
    final recentWeather = metar.recentWeather;

    expect(recentWeather.code, null);
    expect(recentWeather.description, null);
    expect(recentWeather.precipitation, null);
    expect(recentWeather.obscuration, null);
    expect(recentWeather.other, null);
    expect(recentWeather.toString(), '');
    expect(
        recentWeather.asMap(),
        equals(<String, String?>{
          'code': null,
          'description': null,
          'obscuration': null,
          'other': null,
          'precipitation': null,
        }));
  });
}
