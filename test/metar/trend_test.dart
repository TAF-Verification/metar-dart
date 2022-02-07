import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final _year = 2022;
  final _month = 2;

  test('Test NOSIG code', () {
    final code =
        'METAR SEQM 050400Z 04010KT 9999 BKN006 OVC030 14/12 Q1028 NOSIG RMK A3037';
    final metar = Metar(code, year: _year, month: _month);
    final trend = metar.trend;

    expect(trend.code, 'NOSIG');
    expect(trend.translation, 'no significant changes');
    expect(trend.toString(),
        'no significant changes from 2022-02-05 04:00:00.000 until 2022-02-05 06:00:00.000');
    expect(trend.periodFrom.year, 2022);
    expect(trend.periodFrom.month, 2);
    expect(trend.periodFrom.day, 5);
    expect(trend.periodFrom.hour, 4);
    expect(trend.periodFrom.minute, 0);
    expect(trend.periodUntil.year, 2022);
    expect(trend.periodUntil.month, 2);
    expect(trend.periodUntil.day, 5);
    expect(trend.periodUntil.hour, 6);
    expect(trend.periodUntil.minute, 0);
    expect(trend.periodAt, null);
  });

  test('Test TEMPO code', () {
    final code =
        'SPECI MMMX 051347Z 07006KT 5SM SKC 05/02 A3044 TEMPO 3SM HZ RMK HZY ISOL SC LWR VSBY N';
    final metar = Metar(code, year: _year, month: _month);
    final trend = metar.trend;

    expect(trend.code, 'TEMPO');
    expect(trend.translation, 'temporary');
    expect(trend.toString(),
        'temporary from 2022-02-05 13:47:00.000 until 2022-02-05 15:47:00.000');
    expect(trend.periodFrom.year, 2022);
    expect(trend.periodFrom.month, 2);
    expect(trend.periodFrom.day, 5);
    expect(trend.periodFrom.hour, 13);
    expect(trend.periodFrom.minute, 47);
    expect(trend.periodUntil.year, 2022);
    expect(trend.periodUntil.month, 2);
    expect(trend.periodUntil.day, 5);
    expect(trend.periodUntil.hour, 15);
    expect(trend.periodUntil.minute, 47);
    expect(trend.periodAt, null);
  });

  test('Test BECMG code', () {
    final code = 'SPECI LYTV 040930Z VRB02KT CAVOK 12/M01 Q1023 BECMG 14005KT';
    final metar = Metar(code, year: _year, month: _month);
    final trend = metar.trend;

    expect(trend.code, 'BECMG');
    expect(trend.translation, 'becoming');
    expect(trend.toString(),
        'becoming from 2022-02-04 09:30:00.000 until 2022-02-04 11:30:00.000');
    expect(trend.periodFrom.year, 2022);
    expect(trend.periodFrom.month, 2);
    expect(trend.periodFrom.day, 4);
    expect(trend.periodFrom.hour, 9);
    expect(trend.periodFrom.minute, 30);
    expect(trend.periodUntil.year, 2022);
    expect(trend.periodUntil.month, 2);
    expect(trend.periodUntil.day, 4);
    expect(trend.periodUntil.hour, 11);
    expect(trend.periodUntil.minute, 30);
    expect(trend.periodAt, null);
  });

  test('Test BECMG code with `from` period', () {
    final code =
        'SPECI LTFG 061350Z 17004KT 120V240 9999 SCT030 16/09 Q1020 BECMG FM1410 22005KT';
    final metar = Metar(code, year: _year, month: _month);
    final trend = metar.trend;

    expect(trend.code, 'BECMG FM1410');
    expect(trend.translation, 'becoming');
    expect(trend.toString(),
        'becoming from 2022-02-06 14:10:00.000 until 2022-02-06 15:50:00.000');
    expect(trend.periodFrom.year, 2022);
    expect(trend.periodFrom.month, 2);
    expect(trend.periodFrom.day, 6);
    expect(trend.periodFrom.hour, 14);
    expect(trend.periodFrom.minute, 10);
    expect(trend.periodUntil.year, 2022);
    expect(trend.periodUntil.month, 2);
    expect(trend.periodUntil.day, 6);
    expect(trend.periodUntil.hour, 15);
    expect(trend.periodUntil.minute, 50);
    expect(trend.periodAt, null);
  });

  test('Test TEMPO code with `from` and `until` periods', () {
    final code =
        'KRWV 062335Z 00000KT 10SM SCT015 14/02 A3018 TEMPO FM0000 TL0100 BKN015 TL0RMK AO2 T01380018';
    final metar = Metar(code, year: _year, month: _month);
    final trend = metar.trend;

    expect(trend.code, 'TEMPO FM0000 TL0100');
    expect(trend.translation, 'temporary');
    expect(trend.toString(),
        'temporary from 2022-02-07 00:00:00.000 until 2022-02-07 01:00:00.000');
    expect(trend.periodFrom.year, 2022);
    expect(trend.periodFrom.month, 2);
    expect(trend.periodFrom.day, 7);
    expect(trend.periodFrom.hour, 0);
    expect(trend.periodFrom.minute, 0);
    expect(trend.periodUntil.year, 2022);
    expect(trend.periodUntil.month, 2);
    expect(trend.periodUntil.day, 7);
    expect(trend.periodUntil.hour, 1);
    expect(trend.periodUntil.minute, 0);
    expect(trend.periodAt, null);
  });

  test('Test BECMG code with `at` period', () {
    final code =
        'LFPB 070000Z 28008KT 260V320 9999 SCT030 SCT039 BKN047 09/05 Q1017 BECMG AT0030 25020G30KT';
    final metar = Metar(code, year: _year, month: _month);
    final trend = metar.trend;

    expect(trend.code, 'BECMG AT0030');
    expect(trend.translation, 'becoming');
    expect(trend.toString(), 'becoming at 2022-02-07 00:30:00.000');
    expect(trend.periodFrom.year, 2022);
    expect(trend.periodFrom.month, 2);
    expect(trend.periodFrom.day, 7);
    expect(trend.periodFrom.hour, 0);
    expect(trend.periodFrom.minute, 0);
    expect(trend.periodUntil.year, 2022);
    expect(trend.periodUntil.month, 2);
    expect(trend.periodUntil.day, 7);
    expect(trend.periodUntil.hour, 2);
    expect(trend.periodUntil.minute, 0);
    expect(trend.periodAt?.year, 2022);
    expect(trend.periodAt?.month, 2);
    expect(trend.periodAt?.day, 7);
    expect(trend.periodAt?.hour, 0);
    expect(trend.periodAt?.minute, 30);
  });

  test('Test no trend', () {
    final code = 'MRLM 072200Z 02006KT CAVOK 28/21 A2986';
    final metar = Metar(code, year: _year, month: _month);
    final trend = metar.trend;

    expect(trend.code, null);
    expect(trend.translation, null);
    expect(trend.toString(), '');
  });
}
