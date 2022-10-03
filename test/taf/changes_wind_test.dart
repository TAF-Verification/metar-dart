import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test three changes', () {
    final code = '''
    TAF OPRK 262145Z 2700/2718 23005KT 3000 FU NSC TN18/2701Z TX40/2710Z
        FM270700 23010KT 5000 HZ NSC
        FM271200 11005KT 9999 SCT020
        PROB30 RA
    ''';
    final taf = Taf(code);
    final changes = taf.changesForecasted;

    final wind0 = changes[0].wind;
    expect(wind0.code, '23010KT');
    expect(wind0.cardinalDirection, 'SW');
    expect(wind0.directionInDegrees, 230.0);
    expect(wind0.directionInRadians, 4.014257279586958);
    expect(wind0.variable, false);
    expect(wind0.speedInKnot, 10.0);
    expect(wind0.speedInMps, 5.1444444);
    expect(wind0.speedInKph, 18.52);
    expect(wind0.gustInKnot, null);
    expect(wind0.gustInMps, null);
    expect(wind0.gustInMiph, null);
    expect(wind0.toString(), 'SW (230.0°) 10.0 kt');
    expect(
        wind0.asMap(),
        equals(<String, Object?>{
          'direction': {
            'cardinal': 'SW',
            'variable': false,
            'units': 'degrees',
            'direction': 230.0
          },
          'speed': {'units': 'knot', 'speed': 10.0},
          'gust': {'units': 'knot', 'speed': null},
          'code': '23010KT'
        }));

    final wind1 = changes[1].wind;
    expect(wind1.code, '11005KT');
    expect(wind1.cardinalDirection, 'ESE');
    expect(wind1.directionInDegrees, 110.0);
    expect(wind1.directionInRadians, 1.9198621771937625);
    expect(wind1.variable, false);
    expect(wind1.speedInKnot, 5.0);
    expect(wind1.speedInMps, 2.5722222);
    expect(wind1.speedInKph, 9.26);
    expect(wind1.gustInKnot, null);
    expect(wind1.gustInMps, null);
    expect(wind1.gustInMiph, null);
    expect(wind1.toString(), 'ESE (110.0°) 5.0 kt');
    expect(
        wind0.asMap(),
        equals(<String, Object?>{
          'direction': {
            'cardinal': 'SW',
            'variable': false,
            'units': 'degrees',
            'direction': 230.0
          },
          'speed': {'units': 'knot', 'speed': 10.0},
          'gust': {'units': 'knot', 'speed': null},
          'code': '23010KT'
        }));

    final wind2 = changes[2].wind;
    expect(wind2.code, null);
    expect(wind2.cardinalDirection, null);
    expect(wind2.directionInDegrees, null);
    expect(wind2.directionInRadians, null);
    expect(wind2.variable, false);
    expect(wind2.speedInKnot, null);
    expect(wind2.speedInMps, null);
    expect(wind2.speedInKph, null);
    expect(wind2.gustInKnot, null);
    expect(wind2.gustInMps, null);
    expect(wind2.gustInMiph, null);
    expect(wind2.toString(), '');
    expect(
        wind0.asMap(),
        equals(<String, Object?>{
          'direction': {
            'cardinal': 'SW',
            'variable': false,
            'units': 'degrees',
            'direction': 230.0
          },
          'speed': {'units': 'knot', 'speed': 10.0},
          'gust': {'units': 'knot', 'speed': null},
          'code': '23010KT'
        }));
  });
}
