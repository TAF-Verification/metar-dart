import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the runway state SNOCLO of METAR', () {
    final code =
        'METAR PANC 210353Z 01006KT 10SM FEW045 BKN070 OVC100 M05/M17 A2965 R09L/SNOCLO';
    final metar = Metar(code);

    test('Test the runway state', () {
      final value = metar.runwayState.snoclo;
      final expected = 'aerodrome is closed due to extreme deposit of snow';
      expect(value, expected);
    });
  });

  group('Test the runway state CLRD of METAR', () {
    final code =
        'METAR PANC 210353Z 01006KT 10SM FEW045 BKN070 OVC100 M05/M17 A2965 R25C/CLRD//';
    final metar = Metar(code);

    test('Test the runway state', () {
      final value = metar.runwayState.clrd;
      final expected =
          'contaminations have ceased to exist on runway 25 center';
      expect(value, expected);
    });
  });

  group('Test the runway state of METAR', () {
    final code =
        'METAR PANC 210353Z 01006KT 10SM FEW045 BKN070 OVC100 M05/M17 A2965 R09L/527650';
    final metar = Metar(code);

    test('Test the runway state deposit', () {
      final value = metar.runwayState.deposits;
      final expected = 'wet snow';
      expect(value, expected);
    });

    test('Test the runway state contamination', () {
      final value = metar.runwayState.contamination;
      final expected = '11%-25% of runway';
      expect(value, expected);
    });

    test('Test the runway state deposits depth', () {
      final value = metar.runwayState.depositsDepth;
      expect(value, '76 mm');
    });

    test('Test the runway state surface friction', () {
      final value = metar.runwayState.surfaceFriction;
      final expected = '0.50';
      expect(value, expected);
    });
  });
}
