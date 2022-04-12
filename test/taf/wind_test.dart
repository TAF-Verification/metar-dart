import 'dart:developer';
import 'dart:math';

import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the wind of the TAF', () {
    final code = '''
    TAF ULAA 281700Z 2818/0118 24004G09MPS 9999 SCT016
        TEMPO 2818/2823 23005G13MPS 6000 -SHSN FEW007 BKN016CB
        FM282300 22003G10MPS 6000 FEW005 BKN016
        TEMPO 0102/0115 18003MPS
    ''';
    final taf = Taf(code);
    final wind = taf.wind;

    expect(wind.code, '24004G09MPS');
    expect(wind.cardinalDirection, 'WSW');
    expect(wind.directionInDegrees, 240.0);
    expect(wind.directionInRadians, 4.1887902047863905);
    expect(wind.variable, false);
    expect(wind.speedInKnot, 7.775378036936312);
    expect(wind.speedInMps, 4.0);
    expect(wind.speedInKph, 14.40000012440605);
    expect(wind.gustInKnot, 17.494600583106703);
    expect(wind.gustInMps, closeTo(9.0, 2e-15));
    expect(wind.gustInMiph, 20.13243645902753);
    expect(wind.toString(), 'WSW (240.0°) 7.8 kt gust of 17.5 kt');
  });

  test('Test TAF Wind Shear', () {
    final code = '''
      KMEM 081503Z 0815/0912 20006KT P6SM SCT100 BKN250
      FM082100 21006KT P6SM VCSH SCT050 BKN200
      FM090000 18005KT P6SM -RA OVC015
      FM090200 18010KT 2SM -RA BR BKN008 OVC015 WS020/20045KT=
    ''';
    final taf = Taf(code);
    final wind = taf.wind;

    expect(wind.code, '20006KT');
    expect(wind.cardinalDirection, 'SSW');
    expect(wind.directionInDegrees, 200.0);
    expect(wind.directionInRadians, 3.490658503988659);
    expect(wind.variable, false);
    expect(wind.speedInKnot, 6.0);
    expect(wind.speedInMps, closeTo(3.08667, 2e-4));
    expect(wind.speedInKph, 11.112);
    expect(wind.gustInKnot, null);
    expect(wind.gustInMps, null);
    expect(wind.gustInMiph, null);
    expect(wind.toString(), 'SSW (200.0°) 6.0 kt');

    final forecasts = taf.changePeriods;
    expect(forecasts.length, 3);

    final forecast0 = forecasts[0];
    expect(forecast0.code, 'FM082100 21006KT P6SM VCSH SCT050 BKN200');
    expect(forecast0.wind.code, '21006KT');
    expect(forecast0.wind.cardinalDirection, 'SSW');
    expect(forecast0.wind.directionInDegrees, 210);
    expect(forecast0.wind.speedInKnot, 6.0);
    expect(forecast0.prevailingVisibility.inSeaMiles, closeTo(6.0, 2e-10));
    expect(forecast0.weathers.first.description, 'showers');
    expect(forecast0.weathers.first.intensity, 'nearby'); // in the vicinity
    expect(forecast0.weathers.first.toString(), 'nearby showers');
    expect(forecast0.clouds.first.cover, 'scattered');
    expect(forecast0.clouds.first.heightInFeet, closeTo(5000, 2e-10));
    expect(forecast0.clouds[1].cover, 'broken');
    expect(forecast0.clouds[1].heightInFeet, closeTo(20000, 2e-10));
    expect(forecast0.toString(),
        'from 2022-04-08 21:00:00 until 2022-04-08 23:00:00\n');

    final forecast2 = forecasts[2];
    expect(forecast2.code,
        'FM090200 18010KT 2SM -RA BR BKN008 OVC015 WS020/20045KT');
    expect(forecast2.changeIndicator.valid.periodFrom.day, 9);
    expect(forecast2.changeIndicator.valid.periodFrom.hour, 2);
    expect(forecast2.changeIndicator.valid.periodFrom.minute, 0);
    expect(forecast2.wind.code, '18010KT');
    expect(forecast2.wind.cardinalDirection, 'S');
    expect(forecast2.wind.directionInDegrees, 180);
    expect(forecast2.wind.speedInKnot, 10.0);

    expect(forecast2.prevailingVisibility.inSeaMiles, closeTo(2.0, 2e-10));
    final weatherf2 = forecast2.weathers.first;
    expect(weatherf2.precipitation, 'rain');
    expect(weatherf2.intensity, 'light');
    expect(forecast2.weathers[1].toString(), 'mist');

    expect(forecast2.clouds[0].toString(), 'broken at 800.0 feet');
    expect(forecast2.clouds[1].toString(), 'overcast at 1500.0 feet');
    final windshear = forecast2.windshears.first;
    expect(windshear.heightInFeet, 2000);
    expect(
        windshear.toString(), 'wind-shear at 2000 feet, SSW (200.0°) 45.0 kt');
    expect(forecast2.windshears.first.toString(),
        'wind-shear at 2000 feet, SSW (200.0°) 45.0 kt');
  });
}
