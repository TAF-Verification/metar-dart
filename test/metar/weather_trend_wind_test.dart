import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final _year = 2021;
  final _month = 5;
  test('Test the trend wind of METAR with gust', () {
    final code =
        'METAR SEQM 050400Z 04010KT 9999 BKN006 OVC030 14/12 Q1028 TEMPO 09012G22KT RMK A3037';
    final metar = Metar(code, year: _year, month: _month);
    final trends = metar.weatherTrends;

    expect(trends.codes, <String>['TEMPO 09012G22KT']);
    expect(
        trends.toString(),
        'temporary from 2021-05-05 04:00:00 until 2021-05-05 06:00:00\n'
        'E (90.0°) 12.0 kt gust of 22.0 kt');

    final first = trends[0];
    expect(first.code, 'TEMPO 09012G22KT');
    expect(first.wind.code, '09012G22KT');
    expect(first.wind.cardinalDirection, 'E');
    expect(first.wind.directionInDegrees, 90.0);
    expect(first.wind.directionInRadians, 1.5707963267948966);
    expect(first.wind.variable, false);
    expect(first.wind.speedInKnot, 12.0);
    expect(first.wind.speedInKph, 22.224);
    expect(first.wind.speedInMps, 6.17333328);
    expect(first.wind.gustInKnot, 22.0);
    expect(first.wind.gustInKph, 40.744);
    expect(first.wind.gustInMps, 11.31777768);

    expect(
      () => trends[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test the trend wind of METAR without gust', () {
    final code = 'METAR LPPT 082000Z 29003KT CAVOK 14/07 Q1026 BECMG 34012KT';
    final metar = Metar(code, year: _year, month: _month);
    final trends = metar.weatherTrends;

    expect(trends.codes, <String>['BECMG 34012KT']);
    expect(
        trends.toString(),
        'becoming from 2021-05-08 20:00:00 until 2021-05-08 22:00:00\n'
        'NNW (340.0°) 12.0 kt');

    final first = trends[0];
    expect(first.code, 'BECMG 34012KT');
    expect(first.wind.code, '34012KT');
    expect(first.wind.cardinalDirection, 'NNW');
    expect(first.wind.directionInDegrees, 340.0);
    expect(first.wind.directionInRadians, 5.934119456780721);
    expect(first.wind.variable, false);
    expect(first.wind.speedInKnot, 12.0);
    expect(first.wind.speedInKph, 22.224);
    expect(first.wind.speedInMps, 6.17333328);
    expect(first.wind.gustInKnot, null);
    expect(first.wind.gustInKnot, null);
    expect(first.wind.gustInMps, null);

    expect(
      () => trends[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test no trend wind in METAR', () {
    final code =
        'METAR SEQM 162000Z 08005KT 9999 VCSH SCT030 BKN200 21/12 Q1022 TEMPO RA RMK A3018';
    final metar = Metar(code, year: _year, month: _month);
    final trends = metar.weatherTrends;

    expect(trends.codes, <String>['TEMPO RA']);
    expect(
        trends.toString(),
        'temporary from 2021-05-16 20:00:00 until 2021-05-16 22:00:00\n'
        'rain');

    final first = trends[0];
    expect(first.code, 'TEMPO RA');
    expect(first.wind.code, null);
    expect(first.wind.cardinalDirection, null);
    expect(first.wind.directionInDegrees, null);
    expect(first.wind.directionInRadians, null);
    expect(first.wind.variable, false);
    expect(first.wind.speedInKnot, null);
    expect(first.wind.speedInKph, null);
    expect(first.wind.speedInMps, null);
    expect(first.wind.gustInKnot, null);
    expect(first.wind.gustInKnot, null);
    expect(first.wind.gustInMps, null);
    expect(first.wind.toString(), '');

    expect(
      () => trends[1].code,
      throwsA(isA<RangeError>()),
    );
  });
}
