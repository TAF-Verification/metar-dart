import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final code =
      'SPECI KJFK 122051Z 32004KT 10SM OVC065 M02/M15 A3031 RMK AO2 SLP264 T10171150 56004';
  final metar = Metar(code, year: 2021, month: 3);
  final time = metar.time;

  test('Test the date of METAR', () {
    expect(time.code, '122051Z');
    expect(time.year, 2021);
    expect(time.month, 3);
    expect(time.day, 12);
    expect(time.hour, 20);
    expect(time.minute, 51);
    expect(time.toString(), '2021-03-12 20:51:00');
  });
}
