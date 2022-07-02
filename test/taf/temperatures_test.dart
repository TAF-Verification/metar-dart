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
    final maxTemps = taf.maxTemperatures;

    expect(maxTemps.codes, <String>['TX07/0305Z']);
    expect(maxTemps.toString(), '7.0°C at 2020-05-03 05:00:00');
    expect(
        maxTemps.asMap(),
        equals(<String, Object?>{
          'first': {
            'units': 'celsius',
            'temperature': 7.0,
            'code': null,
            'datetime': '2020-05-03 05:00:00.000'
          }
        }));

    final firstMax = maxTemps[0];
    expect(firstMax.code, 'TX07/0305Z');
    expect(firstMax.toString(), '7.0°C at 2020-05-03 05:00:00');
    expect(firstMax.inCelsius, 7.0);
    expect(firstMax.inKelvin, 280.15);
    expect(firstMax.inFahrenheit, 44.6);
    expect(firstMax.inRankine, closeTo(504.27, 0.001));

    expect(firstMax.time?.year, 2020);

    expect(() => maxTemps[1].code, throwsA(isA<RangeError>()));

    final minTemps = taf.minTemperatures;

    expect(minTemps.codes, <String>['TNM03/0321Z']);
    expect(minTemps.toString(), '-3.0°C at 2020-05-03 21:00:00');
    expect(
        minTemps.asMap(),
        equals(<String, Object?>{
          'first': {
            'units': 'celsius',
            'temperature': -3.0,
            'code': null,
            'datetime': '2020-05-03 21:00:00.000'
          }
        }));

    final firstMin = minTemps[0];
    expect(firstMin.code, 'TNM03/0321Z');
    expect(firstMin.toString(), '-3.0°C at 2020-05-03 21:00:00');
    expect(firstMin.inCelsius, -3.0);
    expect(firstMin.inKelvin, 270.15);
    expect(firstMin.inFahrenheit, 26.6);
    expect(firstMin.inRankine, closeTo(486.27, 0.001));

    expect(firstMin.time?.year, 2020);

    expect(() => minTemps[1].code, throwsA(isA<RangeError>()));
  });

  test('Test the temperatures of the TAF with two maximas', () {
    final code =
        'TAF DXNG 301700Z 3018/3118 VRB03KT 9999 FEW010 TX30/3019Z TN20/3110Z TX28/3117Z';
    final taf = Taf(code, year: _year, month: _month);
    final maxTemps = taf.maxTemperatures;

    expect(maxTemps.codes, <String>['TX30/3019Z', 'TX28/3117Z']);
    expect(maxTemps.toString(),
        '30.0°C at 2020-05-30 19:00:00 | 28.0°C at 2020-05-31 17:00:00');
    expect(
        maxTemps.asMap(),
        equals(<String, Object?>{
          'first': {
            'units': 'celsius',
            'temperature': 30.0,
            'code': null,
            'datetime': '2020-05-30 19:00:00.000'
          },
          'second': {
            'units': 'celsius',
            'temperature': 28.0,
            'code': null,
            'datetime': '2020-05-31 17:00:00.000'
          }
        }));

    final firstMax = maxTemps[0];
    expect(firstMax.code, 'TX30/3019Z');
    expect(firstMax.toString(), '30.0°C at 2020-05-30 19:00:00');
    expect(firstMax.inCelsius, 30.0);
    expect(firstMax.inKelvin, 303.15);
    expect(firstMax.inFahrenheit, 86.0);
    expect(firstMax.inRankine, closeTo(545.67, 0.001));

    final secondMax = maxTemps[1];
    expect(secondMax.code, 'TX28/3117Z');
    expect(secondMax.toString(), '28.0°C at 2020-05-31 17:00:00');
    expect(secondMax.inCelsius, 28.0);
    expect(secondMax.inKelvin, 301.15);
    expect(secondMax.inFahrenheit, 82.4);
    expect(secondMax.inRankine, 542.07);
  });
  test('Test no temperatures in the TAF', () {
    final code = '''
    TAF RPMD 021700Z 0218/0318 36006KT 9999 FEW016 SCT090
        TEMPO 0306/0312 13008KT -SHRA FEW014CB SCT015 BKN090
    ''';
    final taf = Taf(code, year: _year, month: _month);
    final maxTemps = taf.maxTemperatures;
    expect(maxTemps.asMap(), equals(<String, Object?>{}));

    final minTemps = taf.minTemperatures;
    expect(minTemps.asMap(), equals(<String, Object?>{}));

    expect(() => maxTemps[0].code, throwsA(isA<RangeError>()));
    expect(() => minTemps[0].code, throwsA(isA<RangeError>()));
  });
}
