import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final delta = 1e-5;

  group('Test the wind of the report', () {
    test('Test the wind of METAR with gust', () {
      final code =
          'METAR SEQM 162000Z 09012G22KT 310V020 9999 VCSH SCT030 BKN200 21/12 Q1022 NOSIG RMK A3018';
      final metar = Metar(code);
      final wind = metar.wind;

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
      expect(
          wind.asMap(),
          equals(<String, Object?>{
            'direction': {
              'cardinal': 'E',
              'variable': false,
              'units': 'degrees',
              'direction': 90.0
            },
            'speed': {'units': 'knot', 'speed': 12.0},
            'gust': {'units': 'knot', 'speed': 22.0},
            'code': '09012G22KT'
          }));
    });

    test('Test the wind of METAR without gust', () {
      final code =
          'METAR SEQM 162000Z 34012KT 310V020 9999 VCSH SCT030 BKN200 21/12 Q1022 NOSIG RMK A3018';
      final metar = Metar(code);
      final wind = metar.wind;

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
      expect(
          wind.asMap(),
          equals(<String, Object?>{
            'direction': {
              'cardinal': 'NNW',
              'variable': false,
              'units': 'degrees',
              'direction': 340.0
            },
            'speed': {'units': 'knot', 'speed': 12.0},
            'gust': {'units': 'knot', 'speed': null},
            'code': '34012KT'
          }));
    });

    test('Test the variable wind of METAR', () {
      final code =
          'METAR SEQM 162000Z VRB02KT 9999 VCSH SCT030 BKN200 21/12 Q1022 NOSIG RMK A3018';
      final metar = Metar(code);
      final wind = metar.wind;

      expect(wind.code, 'VRB02KT');
      expect(wind.cardinalDirection, null);
      expect(wind.directionInDegrees, null);
      expect(wind.directionInRadians, null);
      expect(wind.variable, true);
      expect(wind.speedInKnot, 2.0);
      expect(wind.speedInKph, 3.704);
      expect(wind.speedInMps, 1.02888888);
      expect(wind.gustInKnot, null);
      expect(wind.gustInMps, null);
      expect(wind.gustInMiph, null);
      expect(wind.toString(), 'variable wind 2.0 kt');
      expect(
          wind.asMap(),
          equals(<String, Object?>{
            'direction': {
              'cardinal': null,
              'variable': true,
              'units': 'degrees',
              'direction': null
            },
            'speed': {'units': 'knot', 'speed': 2.0},
            'gust': {'units': 'knot', 'speed': null},
            'code': 'VRB02KT'
          }));
    });

    test('Test more than 100 mps wind speed', () {
      final code =
          'SPECI KMIA 281410Z 170P149GP159MPS 10SM BKN022 BKN039 BKN055 OVC250 29/25 A2970 RMK AO2 PK WND 17031/1409 T02940250';
      final metar = Metar(code);
      final wind = metar.wind;

      expect(wind.code, '170P149GP159MPS');
      expect(wind.cardinalDirection, 'S');
      expect(wind.directionInDegrees, 170.0);
      expect(wind.directionInRadians, closeTo(2.96706, delta));
      expect(wind.variable, false);
      expect(wind.speedInKnot, closeTo(289.63283, delta));
      expect(wind.speedInMps, closeTo(149.0, delta));
      expect(wind.speedInKph, closeTo(536.4, delta));
      expect(wind.gustInKnot, closeTo(309.07128, delta));
      expect(wind.gustInMps, 159.0);
      expect(wind.gustInMiph, closeTo(355.67304, delta));
      expect(wind.toString(), 'S (170.0°) 289.6 kt gust of 309.1 kt');
      expect(
          wind.asMap(),
          equals(<String, Object?>{
            'direction': {
              'cardinal': 'S',
              'variable': false,
              'units': 'degrees',
              'direction': 170.0,
            },
            'speed': {'units': 'knot', 'speed': 289.6328318758776},
            'gust': {'units': 'knot', 'speed': 309.0712769682184},
            'code': '170P149GP159MPS'
          }));
    });

    test('Test no wind in METAR', () {
      final code =
          'METAR SEQM 162000Z ///\//KT 9999 VCSH SCT030 BKN200 21/12 Q1022 NOSIG RMK A3018';
      final metar = Metar(code);
      final wind = metar.wind;

      expect(wind.code, '///\//KT');
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
      expect(
          wind.asMap(),
          equals(<String, Object?>{
            'direction': {
              'cardinal': null,
              'variable': false,
              'units': 'degrees',
              'direction': null
            },
            'speed': {'units': 'knot', 'speed': null},
            'gust': {'units': 'knot', 'speed': null},
            'code': '///\//KT'
          }));
    });
  });

  group('Test the wind direction variation of the report', () {
    test('Wind variation present', () {
      final code =
          'METAR SEQM 162000Z 34012G22KT 310V020 9999 VCSH SCT030 BKN200 21/12 Q1022 NOSIG RMK A3018';
      final metar = Metar(code);
      final windVariation = metar.windVariation;

      expect(windVariation.code, '310V020');
      expect(windVariation.toString(), 'from NW (310.0°) to NNE (20.0°)');
      expect(windVariation.fromInDegrees, 310.0);
      expect(windVariation.fromInGradians, 344.4444441);
      expect(windVariation.fromInRadians, 5.410520681182422);
      expect(windVariation.fromCardinalDirection, 'NW');
      expect(windVariation.toInDegrees, 20.0);
      expect(windVariation.toInGradians, 22.222222199999997);
      expect(windVariation.toInRadians, 0.3490658503988659);
      expect(windVariation.toCardinalDirection, 'NNE');
      expect(
          windVariation.asMap(),
          equals(<String, Object?>{
            'code': '310V020',
            'from_': {
              'cardinal': 'NW',
              'variable': false,
              'units': 'degrees',
              'direction': 310.0
            },
            'to': {
              'cardinal': 'NNE',
              'variable': false,
              'units': 'degrees',
              'direction': 20.0
            }
          }));
    });

    test('Wind variation present', () {
      final code = 'GMMC 231900Z 32008KT 9999 FEW016 BKN100 22/18 Q1013';
      final metar = Metar(code);
      final windVariation = metar.windVariation;

      expect(windVariation.code, null);
      expect(windVariation.toString(), '');
      expect(windVariation.fromInDegrees, null);
      expect(windVariation.fromInGradians, null);
      expect(windVariation.fromInRadians, null);
      expect(windVariation.fromCardinalDirection, null);
      expect(windVariation.toInDegrees, null);
      expect(windVariation.toInGradians, null);
      expect(windVariation.toInRadians, null);
      expect(windVariation.toCardinalDirection, null);
      expect(
          windVariation.asMap(),
          equals(<String, Object?>{
            'code': null,
            'from_': {
              'cardinal': null,
              'variable': false,
              'units': 'degrees',
              'direction': null
            },
            'to': {
              'cardinal': null,
              'variable': false,
              'units': 'degrees',
              'direction': null
            }
          }));
    });
  });
}
