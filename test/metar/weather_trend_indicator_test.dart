import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final _year = 2022;
  final _month = 2;

  test('Test weather trend with NOSIG code', () {
    final code =
        'METAR SEQM 050400Z 04010KT 9999 BKN006 OVC030 14/12 Q1028 NOSIG RMK A3037';
    final metar = Metar(code, year: _year, month: _month);
    final trends = metar.weatherTrends;

    expect(trends.codes, <String>['NOSIG']);
    expect(trends.toString(),
        'no significant changes from 2022-02-05 04:00:00 until 2022-02-05 06:00:00');

    final first = trends[0];
    expect(first.code, 'NOSIG');
    expect(first.trendIndicator.code, 'NOSIG');
    expect(first.trendIndicator.translation, 'no significant changes');
    expect(first.trendIndicator.periodFrom.year, 2022);
    expect(first.trendIndicator.periodFrom.month, 2);
    expect(first.trendIndicator.periodFrom.day, 5);
    expect(first.trendIndicator.periodFrom.hour, 4);
    expect(first.trendIndicator.periodFrom.minute, 0);
    expect(first.trendIndicator.periodUntil.year, 2022);
    expect(first.trendIndicator.periodUntil.month, 2);
    expect(first.trendIndicator.periodUntil.day, 5);
    expect(first.trendIndicator.periodUntil.hour, 6);
    expect(first.trendIndicator.periodUntil.minute, 0);
    expect(first.trendIndicator.periodAt, null);
    expect(
        first.trendIndicator.asMap(),
        equals(<String, Object?>{
          'forecast_period': {
            'init': {'code': null, 'datetime': '2022-02-05 04:00:00'},
            'end': {'code': null, 'datetime': '2022-02-05 06:00:00'}
          },
          'from_': {'code': null, 'datetime': '2022-02-05 04:00:00'},
          'until': {'code': null, 'datetime': '2022-02-05 06:00:00'},
          'at': null,
          'code': 'NOSIG',
          'translation': 'no significant changes'
        }));

    expect(
      () => trends[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test weather trend with TEMPO code', () {
    final code =
        'SPECI MMMX 051347Z 07006KT 5SM SKC 05/02 A3044 TEMPO 3SM HZ RMK HZY ISOL SC LWR VSBY N';
    final metar = Metar(code, year: _year, month: _month);
    final trends = metar.weatherTrends;

    expect(trends.codes, <String>['TEMPO 3SM HZ']);
    expect(
        trends.toString(),
        'temporary from 2022-02-05 13:47:00 until 2022-02-05 15:47:00\n'
        '5.6 km\n'
        'haze');

    final first = trends[0];
    expect(first.code, 'TEMPO 3SM HZ');
    expect(first.trendIndicator.code, 'TEMPO');
    expect(first.trendIndicator.translation, 'temporary');
    expect(first.trendIndicator.periodFrom.year, 2022);
    expect(first.trendIndicator.periodFrom.month, 2);
    expect(first.trendIndicator.periodFrom.day, 5);
    expect(first.trendIndicator.periodFrom.hour, 13);
    expect(first.trendIndicator.periodFrom.minute, 47);
    expect(first.trendIndicator.periodUntil.year, 2022);
    expect(first.trendIndicator.periodUntil.month, 2);
    expect(first.trendIndicator.periodUntil.day, 5);
    expect(first.trendIndicator.periodUntil.hour, 15);
    expect(first.trendIndicator.periodUntil.minute, 47);
    expect(first.trendIndicator.periodAt, null);
    expect(
        first.trendIndicator.asMap(),
        equals(<String, Object?>{
          'forecast_period': {
            'init': {'code': null, 'datetime': '2022-02-05 13:47:00'},
            'end': {'code': null, 'datetime': '2022-02-05 15:47:00'}
          },
          'from_': {'code': null, 'datetime': '2022-02-05 13:47:00'},
          'until': {'code': null, 'datetime': '2022-02-05 15:47:00'},
          'at': null,
          'code': 'TEMPO',
          'translation': 'temporary'
        }));

    expect(
      () => trends[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test weather trend with BECMG code', () {
    final code = 'SPECI LYTV 040930Z VRB02KT CAVOK 12/M01 Q1023 BECMG 14005KT';
    final metar = Metar(code, year: _year, month: _month);
    final trends = metar.weatherTrends;

    expect(trends.codes, <String>['BECMG 14005KT']);
    expect(
        trends.toString(),
        'becoming from 2022-02-04 09:30:00 until 2022-02-04 11:30:00\n'
        'SE (140.0°) 5.0 kt');

    final first = trends[0];
    expect(first.code, 'BECMG 14005KT');
    expect(first.trendIndicator.code, 'BECMG');
    expect(first.trendIndicator.translation, 'becoming');
    expect(first.trendIndicator.periodFrom.year, 2022);
    expect(first.trendIndicator.periodFrom.month, 2);
    expect(first.trendIndicator.periodFrom.day, 4);
    expect(first.trendIndicator.periodFrom.hour, 9);
    expect(first.trendIndicator.periodFrom.minute, 30);
    expect(first.trendIndicator.periodUntil.year, 2022);
    expect(first.trendIndicator.periodUntil.month, 2);
    expect(first.trendIndicator.periodUntil.day, 4);
    expect(first.trendIndicator.periodUntil.hour, 11);
    expect(first.trendIndicator.periodUntil.minute, 30);
    expect(first.trendIndicator.periodAt, null);
    expect(
        first.trendIndicator.asMap(),
        equals(<String, Object?>{
          'forecast_period': {
            'init': {'code': null, 'datetime': '2022-02-04 09:30:00'},
            'end': {'code': null, 'datetime': '2022-02-04 11:30:00'}
          },
          'from_': {'code': null, 'datetime': '2022-02-04 09:30:00'},
          'until': {'code': null, 'datetime': '2022-02-04 11:30:00'},
          'at': null,
          'code': 'BECMG',
          'translation': 'becoming'
        }));

    expect(
      () => trends[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test weather trend BECMG code with `from` period', () {
    final code =
        'SPECI LTFG 061350Z 17004KT 120V240 9999 SCT030 16/09 Q1020 BECMG FM1410 22005KT';
    final metar = Metar(code, year: _year, month: _month);
    final trends = metar.weatherTrends;

    expect(trends.codes, <String>['BECMG FM1410 22005KT']);
    expect(
        trends.toString(),
        'becoming from 2022-02-06 14:10:00 until 2022-02-06 15:50:00\n'
        'SW (220.0°) 5.0 kt');

    final first = trends[0];
    expect(first.code, 'BECMG FM1410 22005KT');
    expect(first.trendIndicator.code, 'BECMG FM1410');
    expect(first.trendIndicator.translation, 'becoming');
    expect(first.trendIndicator.periodFrom.year, 2022);
    expect(first.trendIndicator.periodFrom.month, 2);
    expect(first.trendIndicator.periodFrom.day, 6);
    expect(first.trendIndicator.periodFrom.hour, 14);
    expect(first.trendIndicator.periodFrom.minute, 10);
    expect(first.trendIndicator.periodUntil.year, 2022);
    expect(first.trendIndicator.periodUntil.month, 2);
    expect(first.trendIndicator.periodUntil.day, 6);
    expect(first.trendIndicator.periodUntil.hour, 15);
    expect(first.trendIndicator.periodUntil.minute, 50);
    expect(first.trendIndicator.periodAt, null);
    expect(
        first.trendIndicator.asMap(),
        equals(<String, Object?>{
          'forecast_period': {
            'init': {'code': null, 'datetime': '2022-02-06 13:50:00'},
            'end': {'code': null, 'datetime': '2022-02-06 15:50:00'}
          },
          'from_': {'code': null, 'datetime': '2022-02-06 14:10:00'},
          'until': {'code': null, 'datetime': '2022-02-06 15:50:00'},
          'at': null,
          'code': 'BECMG FM1410',
          'translation': 'becoming'
        }));

    expect(
      () => trends[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test weather trend TEMPO code with `from` and `until` periods', () {
    final code =
        'KRWV 062335Z 00000KT 10SM SCT015 14/02 A3018 TEMPO FM0000 TL0100 BKN015 RMK AO2 T01380018';
    final metar = Metar(code, year: _year, month: _month);
    final trends = metar.weatherTrends;

    expect(trends.codes, <String>['TEMPO FM0000 TL0100 BKN015']);
    expect(
        trends.toString(),
        'temporary from 2022-02-07 00:00:00 until 2022-02-07 01:00:00\n'
        'broken at 1500.0 feet');

    final first = trends[0];
    expect(first.code, 'TEMPO FM0000 TL0100 BKN015');
    expect(first.trendIndicator.code, 'TEMPO FM0000 TL0100');
    expect(first.trendIndicator.translation, 'temporary');
    expect(first.trendIndicator.periodFrom.year, 2022);
    expect(first.trendIndicator.periodFrom.month, 2);
    expect(first.trendIndicator.periodFrom.day, 7);
    expect(first.trendIndicator.periodFrom.hour, 0);
    expect(first.trendIndicator.periodFrom.minute, 0);
    expect(first.trendIndicator.periodUntil.year, 2022);
    expect(first.trendIndicator.periodUntil.month, 2);
    expect(first.trendIndicator.periodUntil.day, 7);
    expect(first.trendIndicator.periodUntil.hour, 1);
    expect(first.trendIndicator.periodUntil.minute, 0);
    expect(first.trendIndicator.periodAt, null);
    expect(
        first.trendIndicator.asMap(),
        equals(<String, Object?>{
          'forecast_period': {
            'init': {'code': null, 'datetime': '2022-02-06 23:35:00'},
            'end': {'code': null, 'datetime': '2022-02-07 01:35:00'}
          },
          'from_': {'code': null, 'datetime': '2022-02-07 00:00:00'},
          'until': {'code': null, 'datetime': '2022-02-07 01:00:00'},
          'at': null,
          'code': 'TEMPO FM0000 TL0100',
          'translation': 'temporary'
        }));

    expect(
      () => trends[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test weather trend BECMG code with `at` period', () {
    final code =
        'LFPB 070000Z 28008KT 260V320 9999 SCT030 SCT039 BKN047 09/05 Q1017 BECMG AT0030 25020G30KT';
    final metar = Metar(code, year: _year, month: _month);
    final trends = metar.weatherTrends;

    expect(trends.codes, <String>['BECMG AT0030 25020G30KT']);
    expect(
        trends.toString(),
        'becoming at 2022-02-07 00:30:00\n'
        'WSW (250.0°) 20.0 kt gust of 30.0 kt');

    final first = trends[0];
    expect(first.code, 'BECMG AT0030 25020G30KT');
    expect(first.trendIndicator.code, 'BECMG AT0030');
    expect(first.trendIndicator.translation, 'becoming');
    expect(first.trendIndicator.periodFrom.year, 2022);
    expect(first.trendIndicator.periodFrom.month, 2);
    expect(first.trendIndicator.periodFrom.day, 7);
    expect(first.trendIndicator.periodFrom.hour, 0);
    expect(first.trendIndicator.periodFrom.minute, 0);
    expect(first.trendIndicator.periodUntil.year, 2022);
    expect(first.trendIndicator.periodUntil.month, 2);
    expect(first.trendIndicator.periodUntil.day, 7);
    expect(first.trendIndicator.periodUntil.hour, 2);
    expect(first.trendIndicator.periodUntil.minute, 0);
    expect(first.trendIndicator.periodAt?.year, 2022);
    expect(first.trendIndicator.periodAt?.month, 2);
    expect(first.trendIndicator.periodAt?.day, 7);
    expect(first.trendIndicator.periodAt?.hour, 0);
    expect(first.trendIndicator.periodAt?.minute, 30);
    expect(
        first.trendIndicator.asMap(),
        equals(<String, Object?>{
          'forecast_period': {
            'init': {'code': null, 'datetime': '2022-02-07 00:00:00'},
            'end': {'code': null, 'datetime': '2022-02-07 02:00:00'}
          },
          'from_': {'code': null, 'datetime': '2022-02-07 00:00:00'},
          'until': {'code': null, 'datetime': '2022-02-07 02:00:00'},
          'at': {'code': null, 'datetime': '2022-02-07 00:30:00'},
          'code': 'BECMG AT0030',
          'translation': 'becoming'
        }));

    expect(
      () => trends[1].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test weather trend with two changes', () {
    final code =
        'METAR UNOO 150100Z 36007MPS 2100 R07/2000N -SN BLSN BKN005 BKN020 M15/M18 Q1010 R07/492045 BECMG FM0130 5000 TEMPO FM0215 TL0245 BKN010 RMK OBST OBSC QFE749';
    final metar = Metar(code, year: _year, month: _month);
    final trends = metar.weatherTrends;

    expect(trends.codes,
        <String>['BECMG FM0130 5000', 'TEMPO FM0215 TL0245 BKN010']);
    expect(
        trends.toString(),
        'becoming from 2022-02-15 01:30:00 until 2022-02-15 03:00:00\n'
        '5.0 km\n'
        'temporary from 2022-02-15 02:15:00 until 2022-02-15 02:45:00\n'
        'broken at 1000.0 feet');

    final first = trends[0];
    expect(first.code, 'BECMG FM0130 5000');
    expect(first.trendIndicator.code, 'BECMG FM0130');
    expect(first.trendIndicator.translation, 'becoming');
    expect(first.trendIndicator.periodFrom.year, 2022);
    expect(first.trendIndicator.periodFrom.month, 2);
    expect(first.trendIndicator.periodFrom.day, 15);
    expect(first.trendIndicator.periodFrom.hour, 1);
    expect(first.trendIndicator.periodFrom.minute, 30);
    expect(first.trendIndicator.periodUntil.year, 2022);
    expect(first.trendIndicator.periodUntil.month, 2);
    expect(first.trendIndicator.periodUntil.day, 15);
    expect(first.trendIndicator.periodUntil.hour, 3);
    expect(first.trendIndicator.periodUntil.minute, 0);
    expect(first.trendIndicator.periodAt, null);
    expect(
        first.trendIndicator.asMap(),
        equals(<String, Object?>{
          'forecast_period': {
            'init': {'code': null, 'datetime': '2022-02-15 01:00:00'},
            'end': {'code': null, 'datetime': '2022-02-15 03:00:00'}
          },
          'from_': {'code': null, 'datetime': '2022-02-15 01:30:00'},
          'until': {'code': null, 'datetime': '2022-02-15 03:00:00'},
          'at': null,
          'code': 'BECMG FM0130',
          'translation': 'becoming'
        }));

    final second = trends[1];
    expect(second.code, 'TEMPO FM0215 TL0245 BKN010');
    expect(second.trendIndicator.code, 'TEMPO FM0215 TL0245');
    expect(second.trendIndicator.translation, 'temporary');
    expect(second.trendIndicator.periodFrom.year, 2022);
    expect(second.trendIndicator.periodFrom.month, 2);
    expect(second.trendIndicator.periodFrom.day, 15);
    expect(second.trendIndicator.periodFrom.hour, 2);
    expect(second.trendIndicator.periodFrom.minute, 15);
    expect(second.trendIndicator.periodUntil.year, 2022);
    expect(second.trendIndicator.periodUntil.month, 2);
    expect(second.trendIndicator.periodUntil.day, 15);
    expect(second.trendIndicator.periodUntil.hour, 2);
    expect(second.trendIndicator.periodUntil.minute, 45);
    expect(second.trendIndicator.periodAt, null);
    expect(
        second.trendIndicator.asMap(),
        equals(<String, Object?>{
          'forecast_period': {
            'init': {'code': null, 'datetime': '2022-02-15 01:00:00'},
            'end': {'code': null, 'datetime': '2022-02-15 03:00:00'}
          },
          'from_': {'code': null, 'datetime': '2022-02-15 02:15:00'},
          'until': {'code': null, 'datetime': '2022-02-15 02:45:00'},
          'at': null,
          'code': 'TEMPO FM0215 TL0245',
          'translation': 'temporary'
        }));

    expect(
      () => trends[2].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test no weather trend', () {
    final code = 'MRLM 072200Z 02006KT CAVOK 28/21 A2986';
    final metar = Metar(code, year: _year, month: _month);
    final trends = metar.weatherTrends;

    expect(trends.codes, <String>[]);
    expect(trends.toString(), '');
    expect(trends.asMap(), equals(<String, Object?>{}));

    expect(
      () => trends[0].code,
      throwsA(isA<RangeError>()),
    );
  });
}
