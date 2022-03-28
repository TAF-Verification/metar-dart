import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test changes weathers', () {
    final code = '''
    TAF OMDB 281700Z 2818/3000 26010KT CAVOK
        BECMG 2818/2820 20005KT 5000 DS
        BECMG 2904/2906 29012KT
        BECMG 2916/2918 18005KT
    ''';
    final taf = Taf(code);
    final changes = taf.changePeriods;

    final weathers0 = changes[0].weathers;
    expect(weathers0.codes, ['DS']);
    expect(weathers0.toString(), 'dust storm');

    expect(weathers0[0].intensity, null);
    expect(weathers0[0].description, null);
    expect(weathers0[0].precipitation, null);
    expect(weathers0[0].obscuration, null);
    expect(weathers0[0].other, 'dust storm');

    expect(
      () => weathers0[1].code,
      throwsA(isA<RangeError>()),
    );

    final weathers1 = changes[1].weathers;
    expect(
      () => weathers1[0].code,
      throwsA(isA<RangeError>()),
    );
  });
}
