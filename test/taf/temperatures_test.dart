import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final _year = 2020;
  final _month = 5;

  test('Test the temperatures of the TAF', () {
    final code = '''
    TAF AMD RKNY 021725Z 0218/0324 26017G35KT CAVOK TX07/0305Z TNM03/0321Z
        BECMG 0223/0224 27010KT
        BECMG 0302/0303 03006KT
        BECMG 0308/0309 23006KT
    ''';
    final taf = Taf(code, year: _year, month: _month);
    final maxTemp = taf.maxTemperature;
    final minTemp = taf.minTemperature;

    expect(maxTemp.code, 'TX07/0305Z');
    expect(maxTemp.toString(), '7.0°C at 2020-05-03 05:00:00');
    expect(maxTemp.inCelsius, 7.0);
    expect(maxTemp.inKelvin, 280.15);
    expect(maxTemp.inFahrenheit, 44.6);
    expect(maxTemp.inRankine, closeTo(504.27, 0.001));

    expect(minTemp.code, 'TNM03/0321Z');
    expect(minTemp.toString(), '-3.0°C at 2020-05-03 21:00:00');
    expect(minTemp.inCelsius, -3.0);
    expect(minTemp.inKelvin, 270.15);
    expect(minTemp.inFahrenheit, 26.6);
    expect(minTemp.inRankine, closeTo(486.27, 0.001));

    expect(maxTemp.time?.year, 2020);
  });

  test('Test no temperatures in the TAF', () {
    final code = '''
    TAF RPMD 021700Z 0218/0318 36006KT 9999 FEW016 SCT090
        TEMPO 0306/0312 13008KT -SHRA FEW014CB SCT015 BKN090
    ''';
    final taf = Taf(code, year: _year, month: _month);
    final maxTemp = taf.maxTemperature;
    final minTemp = taf.minTemperature;

    expect(maxTemp.code, null);
    expect(maxTemp.toString(), '');
    expect(maxTemp.inCelsius, null);
    expect(maxTemp.inKelvin, null);
    expect(maxTemp.inFahrenheit, null);
    expect(maxTemp.inRankine, null);

    expect(minTemp.code, null);
    expect(minTemp.toString(), '');
    expect(minTemp.inCelsius, null);
    expect(minTemp.inKelvin, null);
    expect(minTemp.inFahrenheit, null);
    expect(minTemp.inRankine, null);

    expect(maxTemp.time?.year, null);
  });
}
