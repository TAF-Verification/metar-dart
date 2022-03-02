import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  const delta = 0.0001;

  test('Test the cloud layers TAF', () {
    final code = '''
    TAF RPMD 021100Z 0212/0312 36008KT 9999 FEW016TCU SCT090 BKN260
        TEMPO 0212/0218 03011KT 9000 -RA SCT015CB BKN090
    ''';
    final taf = Taf(code);
    final clouds = taf.clouds;

    expect(clouds.codes, <String>['FEW016TCU', 'SCT090', 'BKN260']);
    expect(clouds.toString(),
        'a few at 1600.0 feet of towering cumulus | scattered at 9000.0 feet | broken at 26000.0 feet');
    expect(clouds.ceiling, false);

    expect(clouds[0].code, 'FEW016TCU');
    expect(clouds[0].cover, 'a few');
    expect(clouds[0].oktas, '1-2');
    expect(clouds[0].heightInFeet, closeTo(1600.0, delta));
    expect(clouds[0].heightInMeters, 487.68);
    expect(clouds[0].heightInKilometers, 0.48768);
    expect(clouds[0].heightInSeaMiles, 0.2633261339092872);
    expect(clouds[0].cloudType, 'towering cumulus');

    expect(clouds[1].code, 'SCT090');
    expect(clouds[1].cover, 'scattered');
    expect(clouds[1].oktas, '3-4');
    expect(clouds[1].heightInFeet, closeTo(9000.0, delta));
    expect(clouds[1].heightInMeters, 2743.2);
    expect(clouds[1].heightInKilometers, 2.7432);
    expect(clouds[1].heightInSeaMiles, 1.4812095032397405);
    expect(clouds[1].cloudType, null);

    expect(clouds[2].code, 'BKN260');
    expect(clouds[2].cover, 'broken');
    expect(clouds[2].oktas, '5-7');
    expect(clouds[2].heightInFeet, closeTo(26000.0, delta));
    expect(clouds[2].heightInMeters, 7924.8);
    expect(clouds[2].heightInKilometers, 7.9248);
    expect(clouds[2].heightInSeaMiles, 4.279049676025918);
    expect(clouds[2].cloudType, null);

    expect(
      () => clouds[3].code,
      throwsA(isA<RangeError>()),
    );
  });
}
