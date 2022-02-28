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
}
