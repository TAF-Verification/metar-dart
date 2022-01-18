import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
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
      expect(wind.gustInKnot, null);
      expect(wind.gustInMps, null);
      expect(wind.toString(), 'variable wind 2.0 kt');
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
    });
  });

  // group('Test the wind direction variation of the report', () {
  //   test('Wind variation present', () {
  //     final code =
  //         'METAR SEQM 162000Z 34012G22KT 310V020 9999 VCSH SCT030 BKN200 21/12 Q1022 NOSIG RMK A3018';
  //     final metar = Metar(code);
  //     final windVariation = metar.windVariation;

  //     expect(windVariation.code, '310V020');
  //     expect(windVariation.toString(), 'from NW (310.0°) to NNE (20.0°)');
  //     expect(windVariation.fromInDegrees, 310.0);
  //     expect(windVariation.fromInGradians, 344.4444441);
  //     expect(windVariation.fromInRadians, 5.410520681182422);
  //     expect(windVariation.fromCardinalDirection, 'NW');
  //     expect(windVariation.toInDegrees, 20.0);
  //     expect(windVariation.toInGradians, 22.222222199999997);
  //     expect(windVariation.toInRadians, 0.3490658503988659);
  //     expect(windVariation.toCardinalDirection, 'NNE');
  //   });

  //   test('Wind variation present', () {
  //     final code = 'GMMC 231900Z 32008KT 9999 FEW016 BKN100 22/18 Q1013';
  //     final metar = Metar(code);
  //     final windVariation = metar.windVariation;

  //     expect(windVariation.code, null);
  //     expect(windVariation.toString(), '');
  //     expect(windVariation.fromInDegrees, null);
  //     expect(windVariation.fromInGradians, null);
  //     expect(windVariation.fromInRadians, null);
  //     expect(windVariation.fromCardinalDirection, null);
  //     expect(windVariation.toInDegrees, null);
  //     expect(windVariation.toInGradians, null);
  //     expect(windVariation.toInRadians, null);
  //     expect(windVariation.toCardinalDirection, null);
  //   });
  // });
}
