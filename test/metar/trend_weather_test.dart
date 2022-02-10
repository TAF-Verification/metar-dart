import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the trend weather of METAR, one weather', () {
    final code =
        'METAR UUDD 190430Z 35004MPS 9999 FEW020 M01/M03 Q1009 R32L/590240 TEMPO TL0600 5000 +SN SCT012';
    final metar = Metar(code);
    final weathers = metar.trendWeathers;

    expect(weathers.codes, ['+SN']);
    expect(weathers.toString(), 'heavy snow');

    expect(weathers[0].intensity, 'heavy');
    expect(weathers[0].description, null);
    expect(weathers[0].precipitation, 'snow');
    expect(weathers[0].obscuration, null);
    expect(weathers[0].other, null);

    expect(
      () => weathers[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test the trend weather of METAR, two weathers', () {
    final code =
        'METAR MRLM 191300Z 22005KT 6000 +DZ VCSH FEW010TCU OVC070 24/23 A2991 RERA BECMG 3000 TSRA BR SCT010CB';
    final metar = Metar(code);
    final weathers = metar.trendWeathers;

    expect(weathers.codes, ['TSRA', 'BR']);
    expect(weathers.toString(), 'thunderstorm rain | mist');

    expect(weathers[0].intensity, null);
    expect(weathers[0].description, 'thunderstorm');
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

  test('Test the trend weather of METAR, three weathers', () {
    final code =
        'METAR BIBD 191100Z 03002KT 9999 SCT008CB OVC020 04/03 Q1013 TEMPO 5000 -RA BR VCTS';
    final metar = Metar(code);
    final weathers = metar.trendWeathers;

    expect(weathers.codes, ['-RA', 'BR', 'VCTS']);
    expect(weathers.toString(), 'light rain | mist | nearby thunderstorm');

    expect(weathers[0].intensity, 'light');
    expect(weathers[0].description, null);
    expect(weathers[0].precipitation, 'rain');
    expect(weathers[0].obscuration, null);
    expect(weathers[0].other, null);

    expect(weathers[1].intensity, null);
    expect(weathers[1].description, null);
    expect(weathers[1].precipitation, null);
    expect(weathers[1].obscuration, 'mist');
    expect(weathers[1].other, null);

    expect(weathers[2].intensity, 'nearby');
    expect(weathers[2].description, 'thunderstorm');
    expect(weathers[2].precipitation, null);
    expect(weathers[2].obscuration, null);
    expect(weathers[2].other, null);
  });

  test('Test no trend weathers', () {
    final code =
        'METAR LIRG 211755Z 27003KT CAVOK 24/14 Q1020 NOSIG RMK FEW FEW200 MON NE LIB NC VIS MIN 9999 BLU';
    final metar = Metar(code);
    final weathers = metar.trendWeathers;

    expect(weathers.codes, <String>[]);
    expect(weathers.toString(), '');

    for (var i = 0; i < 3; i++) {
      expect(
        () => weathers[i].code,
        throwsA(isA<RangeError>()),
      );
    }
  });

  test('Test try to get the 4th item from trend weathers', () {
    final code =
        'METAR SCVM 060000Z 28007KT 250V310 9999 SCT016CB 16/13 Q1014 BECMG 5000 TSRA BR VCFG';
    final metar = Metar(code);
    final weathers = metar.trendWeathers;

    expect(weathers.codes, <String>['TSRA', 'BR', 'VCFG']);
    expect(weathers.toString(), 'thunderstorm rain | mist | nearby fog');

    expect(
      () => weathers[3].code,
      throwsA(isA<RangeError>()),
    );
  });
}
