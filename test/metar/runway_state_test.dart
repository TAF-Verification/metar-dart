import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the runway state SNOCLO of METAR', () {
    final code =
        'METAR PANC 210353Z 01006KT 10SM FEW045 BKN070 OVC100 M05/M17 A2965 R09L/SNOCLO';
    final metar = Metar(code);
    final runwayState = metar.runwayState;

    expect(runwayState.code, 'R09L/SNOCLO');
    expect(runwayState.name, '09 left');
    expect(runwayState.deposits, null);
    expect(runwayState.contamination, null);
    expect(runwayState.depositsDepth, null);
    expect(runwayState.surfaceFriction, null);
    expect(
      runwayState.snoclo,
      'aerodrome is closed due to extreme deposit of snow',
    );
    expect(runwayState.clrd, null);
    expect(
      runwayState.toString(),
      'aerodrome is closed due to extreme deposit of snow',
    );
  });

  test('Test the runway state CLRD of METAR', () {
    final code =
        'METAR PANC 210353Z 01006KT 10SM FEW045 BKN070 OVC100 M05/M17 A2965 R25C/CLRD//';
    final metar = Metar(code);
    final runwayState = metar.runwayState;

    expect(runwayState.code, 'R25C/CLRD//');
    expect(runwayState.name, '25 center');
    expect(runwayState.deposits, null);
    expect(runwayState.contamination, null);
    expect(runwayState.depositsDepth, null);
    expect(runwayState.surfaceFriction, null);
    expect(runwayState.snoclo, null);
    expect(
      runwayState.clrd,
      'contaminations have ceased to exist on runway 25 center',
    );
    expect(
      runwayState.toString(),
      'contaminations have ceased to exist on runway 25 center',
    );
  });

  test('Test the runway state of METAR', () {
    final code =
        'METAR PANC 210353Z 01006KT 10SM FEW045 BKN070 OVC100 M05/M17 A2965 R09L/527650';
    final metar = Metar(code);
    final runwayState = metar.runwayState;

    expect(runwayState.code, 'R09L/527650');
    expect(runwayState.name, '09 left');
    expect(runwayState.deposits, 'wet snow');
    expect(runwayState.contamination, '11%-25% of runway');
    expect(runwayState.depositsDepth, '76 mm');
    expect(runwayState.surfaceFriction, '0.50');
    expect(runwayState.snoclo, null);
    expect(runwayState.clrd, null);
    expect(
      runwayState.toString(),
      '09 left, deposits of 76 mm of wet snow, contamination 11%-25% of runway, estimated surface friction 0.50',
    );
  });

  test('Test no runway state', () {
    final code =
        'METAR PANC 210353Z 01006KT 10SM FEW045 BKN070 OVC100 M05/M17 A2965';
    final metar = Metar(code);
    final runwayState = metar.runwayState;

    expect(runwayState.code, null);
    expect(runwayState.name, null);
    expect(runwayState.deposits, null);
    expect(runwayState.contamination, null);
    expect(runwayState.depositsDepth, null);
    expect(runwayState.surfaceFriction, null);
    expect(runwayState.snoclo, null);
    expect(runwayState.clrd, null);
    expect(runwayState.toString(), '');
  });
}
