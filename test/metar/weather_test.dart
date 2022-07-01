import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the weather of METAR, one weather', () {
    final code =
        'METAR UUDD 190430Z 35004MPS 8000 -SN FEW012 M01/M03 Q1009 R32L/590240 NOSIG';
    final metar = Metar(code);
    final weathers = metar.weathers;

    expect(weathers.codes, ['-SN']);
    expect(weathers.toString(), 'light snow');

    expect(weathers[0].intensity, 'light');
    expect(weathers[0].description, null);
    expect(weathers[0].precipitation, 'snow');
    expect(weathers[0].obscuration, null);
    expect(weathers[0].other, null);
    expect(
        weathers[0].asMap(),
        equals(<String, String?>{
          'code': '-SN',
          'intensity': 'light',
          'description': null,
          'precipitation': 'snow',
          'obscuration': null,
          'other': null
        }));

    expect(
      () => weathers[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test the weather of METAR, two weathers', () {
    final code =
        'METAR MRLM 191300Z 22005KT 6000 DZ VCSH FEW010TCU OVC070 24/23 A2991 RERA';
    final metar = Metar(code);
    final weathers = metar.weathers;

    expect(weathers.codes, ['DZ', 'VCSH']);
    expect(weathers.toString(), 'drizzle | nearby showers');

    expect(weathers[0].intensity, null);
    expect(weathers[0].description, null);
    expect(weathers[0].precipitation, 'drizzle');
    expect(weathers[0].obscuration, null);
    expect(weathers[0].other, null);
    expect(
        weathers[0].asMap(),
        equals(<String, String?>{
          'code': 'DZ',
          'intensity': null,
          'description': null,
          'precipitation': 'drizzle',
          'obscuration': null,
          'other': null
        }));

    expect(weathers[1].intensity, 'nearby');
    expect(weathers[1].description, 'showers');
    expect(weathers[1].precipitation, null);
    expect(weathers[1].obscuration, null);
    expect(weathers[1].other, null);
    expect(
        weathers[1].asMap(),
        equals(<String, String?>{
          'code': 'VCSH',
          'intensity': 'nearby',
          'description': 'showers',
          'precipitation': null,
          'obscuration': null,
          'other': null
        }));

    expect(
      () => weathers[2].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test the weather of METAR, three weathers', () {
    final code =
        'METAR BIBD 191100Z 03002KT 8000 RA BR VCTS SCT008CB OVC020 04/03 Q1013';
    final metar = Metar(code);
    final weathers = metar.weathers;

    expect(weathers.codes, ['RA', 'BR', 'VCTS']);
    expect(weathers.toString(), 'rain | mist | nearby thunderstorm');

    expect(weathers[0].intensity, null);
    expect(weathers[0].description, null);
    expect(weathers[0].precipitation, 'rain');
    expect(weathers[0].obscuration, null);
    expect(weathers[0].other, null);
    expect(
        weathers[0].asMap(),
        equals(<String, String?>{
          'code': 'RA',
          'intensity': null,
          'description': null,
          'precipitation': 'rain',
          'obscuration': null,
          'other': null
        }));

    expect(weathers[1].intensity, null);
    expect(weathers[1].description, null);
    expect(weathers[1].precipitation, null);
    expect(weathers[1].obscuration, 'mist');
    expect(weathers[1].other, null);
    expect(
        weathers[1].asMap(),
        equals(<String, String?>{
          'code': 'BR',
          'intensity': null,
          'description': null,
          'precipitation': null,
          'obscuration': 'mist',
          'other': null
        }));

    expect(weathers[2].intensity, 'nearby');
    expect(weathers[2].description, 'thunderstorm');
    expect(weathers[2].precipitation, null);
    expect(weathers[2].obscuration, null);
    expect(weathers[2].other, null);
    expect(
        weathers[2].asMap(),
        equals(<String, String?>{
          'code': 'VCTS',
          'intensity': 'nearby',
          'description': 'thunderstorm',
          'precipitation': null,
          'obscuration': null,
          'other': null
        }));
  });

  test('Test no weathers', () {
    final code =
        'METAR LIRG 211755Z 27003KT CAVOK 24/14 Q1020 RMK FEW FEW200 MON NE LIB NC VIS MIN 9999 BLU';
    final metar = Metar(code);
    final weathers = metar.weathers;

    expect(weathers.codes, <String>[]);
    expect(weathers.toString(), '');
    expect(weathers.asMap(), equals(<String, Object?>{}));

    for (var i = 0; i < 3; i++) {
      expect(
        () => weathers[i].code,
        throwsA(isA<RangeError>()),
      );
    }
  });

  test('Test try to get the 4th item from weathers', () {
    final code =
        'METAR SCVM 060000Z 28007KT 250V310 9999 RA BR VCTS SCT016CB 16/13 Q1014';
    final metar = Metar(code);
    final weathers = metar.weathers;

    expect(weathers.codes, <String>['RA', 'BR', 'VCTS']);
    expect(weathers.toString(), 'rain | mist | nearby thunderstorm');
    expect(
        weathers.asMap(),
        equals(<String, Object?>{
          'first': {
            'code': 'RA',
            'intensity': null,
            'description': null,
            'precipitation': 'rain',
            'obscuration': null,
            'other': null
          },
          'second': {
            'code': 'BR',
            'intensity': null,
            'description': null,
            'precipitation': null,
            'obscuration': 'mist',
            'other': null
          },
          'third': {
            'code': 'VCTS',
            'intensity': 'nearby',
            'description': 'thunderstorm',
            'precipitation': null,
            'obscuration': null,
            'other': null
          }
        }));

    expect(
      () => weathers[3].code,
      throwsA(isA<RangeError>()),
    );
  });
}
