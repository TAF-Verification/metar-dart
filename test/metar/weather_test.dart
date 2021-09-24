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
    // First
    expect(weathers.first.intensity, 'light');
    expect(weathers.first.description, null);
    expect(weathers.first.precipitation, 'snow');
    expect(weathers.first.obscuration, null);
    expect(weathers.first.other, null);
    // Second
    expect(weathers.second.intensity, null);
    expect(weathers.second.description, null);
    expect(weathers.second.precipitation, null);
    expect(weathers.second.obscuration, null);
    expect(weathers.second.other, null);
    // Third
    expect(weathers.third.intensity, null);
    expect(weathers.third.description, null);
    expect(weathers.third.precipitation, null);
    expect(weathers.third.obscuration, null);
    expect(weathers.third.other, null);
  });

  test('Test the weather of METAR. Sample No. 2', () {
    final code =
        'METAR MRLM 191300Z 22005KT 6000 DZ VCSH FEW010TCU OVC070 24/23 A2991 RERA';
    final metar = Metar(code);
    final weathers = metar.weathers;

    expect(weathers.codes, ['DZ', 'VCSH']);
    expect(weathers.toString(), 'drizzle | nearby showers');
    // First
    expect(weathers.first.intensity, null);
    expect(weathers.first.description, null);
    expect(weathers.first.precipitation, 'drizzle');
    expect(weathers.first.obscuration, null);
    expect(weathers.first.other, null);
    // Second
    expect(weathers.second.intensity, 'nearby');
    expect(weathers.second.description, 'showers');
    expect(weathers.second.precipitation, null);
    expect(weathers.second.obscuration, null);
    expect(weathers.second.other, null);
    // Third
    expect(weathers.third.intensity, null);
    expect(weathers.third.description, null);
    expect(weathers.third.precipitation, null);
    expect(weathers.third.obscuration, null);
    expect(weathers.third.other, null);
  });

  test('Test the weather of METAR. Sample No. 3', () {
    final code =
        'METAR BIBD 191100Z 03002KT 8000 RA BR VCTS SCT008CB OVC020 04/03 Q1013';
    final metar = Metar(code);
    final weathers = metar.weathers;

    expect(weathers.codes, ['RA', 'BR', 'VCTS']);
    expect(weathers.toString(), 'rain | mist | nearby thunderstorm');
    // First
    expect(weathers.first.intensity, null);
    expect(weathers.first.description, null);
    expect(weathers.first.precipitation, 'rain');
    expect(weathers.first.obscuration, null);
    expect(weathers.first.other, null);
    // Second
    expect(weathers.second.intensity, null);
    expect(weathers.second.description, null);
    expect(weathers.second.precipitation, null);
    expect(weathers.second.obscuration, 'mist');
    expect(weathers.second.other, null);
    // Third
    expect(weathers.third.intensity, 'nearby');
    expect(weathers.third.description, 'thunderstorm');
    expect(weathers.third.precipitation, null);
    expect(weathers.third.obscuration, null);
    expect(weathers.third.other, null);
  });
}
