import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  const delta = 0.0001;

  test('Test changes clouds', () {
    final code = '''
    TAF FMEE 281700Z 2818/2924 14006KT 9999 FEW030 BKN060
        PROB40
        TEMPO 2818/2921 4000 SHRA SCT020TCU BKN030
        BECMG 2922/2924 RA BKN010
    ''';
    final taf = Taf(code);
    final changes = taf.changePeriods;

    final clouds0 = changes[0].clouds;
    expect(clouds0.codes, ['SCT020TCU', 'BKN030']);
    expect(clouds0.toString(),
        'scattered at 2000.0 feet of towering cumulus | broken at 3000.0 feet');
    expect(clouds0.ceiling, false);
    expect(
        clouds0.asMap(),
        equals(<String, Object?>{
          'first': {
            'cover': 'scattered',
            'oktas': '3-4',
            'height_units': 'meters',
            'height': 609.6,
            'type': 'towering cumulus',
            'code': 'SCT020TCU'
          },
          'second': {
            'cover': 'broken',
            'oktas': '5-7',
            'height_units': 'meters',
            'height': 914.4,
            'type': null,
            'code': 'BKN030'
          }
        }));

    expect(clouds0[0].code, 'SCT020TCU');
    expect(clouds0[0].cover, 'scattered');
    expect(clouds0[0].oktas, '3-4');
    expect(clouds0[0].heightInFeet, closeTo(2000.0, delta));
    expect(clouds0[0].heightInMeters, 609.6);
    expect(clouds0[0].heightInKilometers, 0.6096);
    expect(clouds0[0].heightInSeaMiles, 0.32915766738660907);
    expect(clouds0[0].cloudType, 'towering cumulus');

    expect(clouds0[1].code, 'BKN030');
    expect(clouds0[1].cover, 'broken');
    expect(clouds0[1].oktas, '5-7');
    expect(clouds0[1].heightInFeet, closeTo(3000.0, delta));
    expect(clouds0[1].heightInMeters, 914.4);
    expect(clouds0[1].heightInKilometers, 0.9144);
    expect(clouds0[1].heightInSeaMiles, 0.4937365010799135);
    expect(clouds0[1].cloudType, null);

    expect(
      () => clouds0[2].code,
      throwsA(isA<RangeError>()),
    );

    final clouds1 = changes[1].clouds;
    expect(clouds1.codes, ['BKN010']);
    expect(clouds1.toString(), 'broken at 1000.0 feet');
    expect(clouds1.ceiling, true);
    expect(
        clouds1.asMap(),
        equals(<String, Object?>{
          'first': {
            'cover': 'broken',
            'oktas': '5-7',
            'height_units': 'meters',
            'height': 304.8,
            'type': null,
            'code': 'BKN010'
          }
        }));

    expect(clouds1[0].code, 'BKN010');
    expect(clouds1[0].cover, 'broken');
    expect(clouds1[0].oktas, '5-7');
    expect(clouds1[0].heightInFeet, closeTo(1000.0, delta));
    expect(clouds1[0].heightInMeters, 304.8);
    expect(clouds1[0].heightInKilometers, 0.3048);
    expect(clouds1[0].heightInSeaMiles, 0.16457883369330453);
    expect(clouds1[0].cloudType, null);

    expect(
      () => clouds1[1].code,
      throwsA(isA<RangeError>()),
    );
  });
}
