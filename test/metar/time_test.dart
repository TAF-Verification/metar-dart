import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the date of METAR', () {
    final code =
        'SPECI KJFK 122051Z 32004KT 10SM OVC065 M02/M15 A3031 RMK AO2 SLP264 T10171150 56004';
    final metar = Metar(code, year: 2021, month: 3);
    final time = metar.time;

    expect(time.code, '122051Z');
    expect(time.year, 2021);
    expect(time.month, 3);
    expect(time.day, 12);
    expect(time.hour, 20);
    expect(time.minute, 51);
    expect(time.toString(), '2021-03-12 20:51:00');
    expect(
        time.asMap(),
        equals(<String, String?>{
          'code': '122051Z',
          'datetime': '2021-03-12 20:51:00',
        }));
  });

  test('Test no date group in METAR', () {
    final code = 'METAR KJFK NIL';
    final metar = Metar(code, year: 2021, month: 3);
    final time = metar.time;

    final date2str = '2021-03-01 00:00:00';

    expect(time.code, null);
    expect(time.year, 2021);
    expect(time.month, 3);
    expect(time.day, 1);
    expect(time.hour, 0);
    expect(time.minute, 0);
    expect(time.toString(), date2str);
    expect(
        time.asMap(),
        equals(<String, String?>{
          'code': null,
          'datetime': date2str,
        }));
  });
}
