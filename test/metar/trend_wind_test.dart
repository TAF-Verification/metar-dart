import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the trend wind of METAR with gust', () {
    final code =
        'METAR SEQM 050400Z 04010KT 9999 BKN006 OVC030 14/12 Q1028 BECMG 09012G22KT RMK A3037';
    final metar = Metar(code);
    final wind = metar.trendWind;

    expect(wind.code, '09012G22KT');
    expect(wind.cardinalDirection, 'E');
    expect(wind.directionInDegrees, 90.0);
    expect(wind.directionInRadians, 1.5707963267948966);
    expect(wind.variable, false);
    expect(wind.speedInKnot, 12.0);
    expect(wind.speedInKph, 22.224);
    expect(wind.speedInMps, 6.17333328);
    expect(wind.gustInKnot, 22.0);
    expect(wind.gustInKph, 40.744);
    expect(wind.gustInMps, 11.31777768);
    expect(wind.toString(), 'E (90.0°) 12.0 kt gust of 22.0 kt');
  });

  test('Test the trend wind of METAR without gust', () {
    final code = 'METAR LPPT 082000Z 29003KT CAVOK 14/07 Q1026 BECMG 34012KT';
    final metar = Metar(code);
    final wind = metar.trendWind;

    expect(wind.code, '34012KT');
    expect(wind.cardinalDirection, 'NNW');
    expect(wind.directionInDegrees, 340.0);
    expect(wind.directionInRadians, 5.934119456780721);
    expect(wind.variable, false);
    expect(wind.speedInKnot, 12.0);
    expect(wind.speedInKph, 22.224);
    expect(wind.speedInMps, 6.17333328);
    expect(wind.gustInKnot, null);
    expect(wind.gustInKnot, null);
    expect(wind.gustInMps, null);
    expect(wind.toString(), 'NNW (340.0°) 12.0 kt');
  });

  test('Test no trend wind in METAR', () {
    final code =
        'METAR SEQM 162000Z 08005KT 9999 VCSH SCT030 BKN200 21/12 Q1022 TEMPO RA RMK A3018';
    final metar = Metar(code);
    final wind = metar.trendWind;

    expect(wind.code, null);
    expect(wind.cardinalDirection, null);
    expect(wind.directionInDegrees, null);
    expect(wind.directionInRadians, null);
    expect(wind.variable, false);
    expect(wind.speedInKnot, null);
    expect(wind.speedInKph, null);
    expect(wind.speedInMps, null);
    expect(wind.gustInKnot, null);
    expect(wind.gustInKnot, null);
    expect(wind.gustInMps, null);
    expect(wind.toString(), '');
  });
}
