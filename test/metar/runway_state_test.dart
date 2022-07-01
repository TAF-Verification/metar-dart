import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the runway state SNOCLO of METAR', () {
    final code =
        'METAR PANC 210353Z 01006KT 10SM FEW045 BKN070 OVC100 M05/M17 A2965 R09L/SNOCLO';
    final metar = Metar(code);
    final state = metar.runwayState;

    expect(state.code, 'R09L/SNOCLO');
    expect(state.name, '09 left');
    expect(state.deposits, null);
    expect(state.contamination, null);
    expect(state.depositsDepth, null);
    expect(state.surfaceFriction, null);
    expect(state.snoclo, true);
    expect(state.clrd, null);
    expect(
      state.toString(),
      'aerodrome is closed due to extreme deposit of snow',
    );
    expect(
        state.asMap(),
        equals(<String, Object?>{
          'name': '09 left',
          'deposits': null,
          'contamination': null,
          'deposits_depth': null,
          'surface_friction': null,
          'snoclo': true,
          'clrd': null,
          'code': 'R09L/SNOCLO',
        }));
  });

  test('Test the runway state CLRD of METAR', () {
    final code =
        'METAR PANC 210353Z 01006KT 10SM FEW045 BKN070 OVC100 M05/M17 A2965 R25C/CLRD//';
    final metar = Metar(code);
    final state = metar.runwayState;

    expect(state.code, 'R25C/CLRD//');
    expect(state.name, '25 center');
    expect(state.deposits, null);
    expect(state.contamination, null);
    expect(state.depositsDepth, null);
    expect(state.surfaceFriction, null);
    expect(state.snoclo, false);
    expect(
      state.clrd,
      'contaminations have ceased to exists on runway 25 center',
    );
    expect(
      state.toString(),
      'contaminations have ceased to exists on runway 25 center',
    );
    expect(
        state.asMap(),
        equals(<String, Object?>{
          'name': '25 center',
          'deposits': null,
          'contamination': null,
          'deposits_depth': null,
          'surface_friction': null,
          'snoclo': false,
          'clrd': 'contaminations have ceased to exists on runway 25 center',
          'code': 'R25C/CLRD//',
        }));
  });

  test('Test the runway state of METAR', () {
    final code =
        'METAR PANC 210353Z 01006KT 10SM FEW045 BKN070 OVC100 M05/M17 A2965 R09L/527650';
    final metar = Metar(code);
    final state = metar.runwayState;

    expect(state.code, 'R09L/527650');
    expect(state.name, '09 left');
    expect(state.deposits, 'wet snow');
    expect(state.contamination, '11%-25% of runway');
    expect(state.depositsDepth, '76 mm');
    expect(state.surfaceFriction, '0.50');
    expect(state.snoclo, false);
    expect(state.clrd, null);
    expect(
      state.toString(),
      '09 left, deposits of 76 mm of wet snow, contamination 11%-25% of runway, estimated surface friction 0.50',
    );
    expect(
        state.asMap(),
        equals(<String, Object?>{
          'name': '09 left',
          'deposits': 'wet snow',
          'contamination': '11%-25% of runway',
          'deposits_depth': '76 mm',
          'surface_friction': '0.50',
          'snoclo': false,
          'clrd': null,
          'code': 'R09L/527650',
        }));
  });

  test('Test no runway state', () {
    final code =
        'METAR PANC 210353Z 01006KT 10SM FEW045 BKN070 OVC100 M05/M17 A2965';
    final metar = Metar(code);
    final state = metar.runwayState;

    expect(state.code, null);
    expect(state.name, null);
    expect(state.deposits, null);
    expect(state.contamination, null);
    expect(state.depositsDepth, null);
    expect(state.surfaceFriction, null);
    expect(state.snoclo, false);
    expect(state.clrd, null);
    expect(state.toString(), '');
    expect(
        state.asMap(),
        equals(<String, Object?>{
          'name': null,
          'deposits': null,
          'contamination': null,
          'deposits_depth': null,
          'surface_friction': null,
          'snoclo': false,
          'clrd': null,
          'code': null,
        }));
  });
}
