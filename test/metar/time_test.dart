import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final code =
      'KJFK 122051Z 32004KT 10SM OVC065 M02/M15 A3031 RMK AO2 SLP264 T10171150 56004';
  final metar = Metar(code, month: 3, year: 2021);

  test('Test the date of METAR', () {
    expect(metar.time.year, 2021);
    expect(metar.time.month, 3);
    expect(metar.time.day, 12);
    expect(metar.time.hour, 20);
    expect(metar.time.minute, 51);
    expect(metar.time.toString(), '2021-03-12 20:51:00.000');
  });
}
