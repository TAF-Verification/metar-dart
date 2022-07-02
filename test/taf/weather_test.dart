import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test two TAF weathers', () {
    final code = '''
    TAF RKNY 282300Z 0100/0206 27010KT 5000 +RA BR BKN015 TX11/0105Z TN01/0121Z
        BECMG 0101/0102 28015G30KT SCT030
        BECMG 0105/0106 34010KT
        BECMG 0111/0112 27012KT
        BECMG 0123/0124 27015G25KT
        BECMG 0202/0203 27017G35KT
    ''';
    final taf = Taf(code);
    final weathers = taf.weathers;

    expect(weathers.codes, ['+RA', 'BR']);
    expect(weathers.toString(), 'heavy rain | mist');
    expect(
        weathers.asMap(),
        equals(<String, Object?>{
          'first': {
            'code': '+RA',
            'intensity': 'heavy',
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
          }
        }));

    expect(weathers[0].intensity, 'heavy');
    expect(weathers[0].description, null);
    expect(weathers[0].precipitation, 'rain');
    expect(weathers[0].obscuration, null);
    expect(weathers[0].other, null);

    expect(weathers[1].intensity, null);
    expect(weathers[1].description, null);
    expect(weathers[1].precipitation, null);
    expect(weathers[1].obscuration, 'mist');
    expect(weathers[1].other, null);

    expect(
      () => weathers[2].code,
      throwsA(isA<RangeError>()),
    );
  });
}
