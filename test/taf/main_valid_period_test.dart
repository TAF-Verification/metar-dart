import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final _year = 2019;
  final _month = 3;

  test('Test 0606 valid period', () {
    final code = '''
    TAF KATL 250357Z 2506/2606 21006KT P6SM FEW045
        FM251000 23008KT P6SM BKN020
        FM251300 27009KT P6SM VCSH SCT010 BKN015
        FM251800 31011G18KT P6SM BKN025
        FM252100 31012G18KT P6SM FEW035 FEW150
        FM260000 32009KT P6SM FEW060
    ''';
    final taf = Taf(code, year: _year, month: _month);
    final valid = taf.valid;

    expect(valid.code, '2506/2606');
    expect(
        valid.toString(), 'from 2019-03-25 06:00:00 until 2019-03-26 06:00:00');
    expect(valid.periodFrom.year, 2019);
    expect(valid.periodFrom.month, 3);
    expect(valid.periodFrom.day, 25);
    expect(valid.periodFrom.hour, 6);
    expect(valid.periodFrom.minute, 0);
    expect(valid.periodUntil.year, 2019);
    expect(valid.periodUntil.month, 3);
    expect(valid.periodUntil.day, 26);
    expect(valid.periodUntil.hour, 6);
    expect(valid.periodUntil.minute, 0);
    expect(
        valid.asMap(),
        equals(<String, Object?>{
          'code': '2506/2606',
          'from_': {'code': null, 'datetime': '2019-03-25 06:00:00'},
          'until': {'code': null, 'datetime': '2019-03-26 06:00:00'}
        }));
  });

  test('Test 0024 valid period', () {
    final code = '''
    TAF MROC 302300Z 3100/3124 09015KT CAVOK TX29/2519Z TN19/2511Z
        TEMPO 3112/3120 08015G28KT
    ''';
    final taf = Taf(code, year: _year, month: _month);
    final valid = taf.valid;

    expect(valid.code, '3100/3124');
    expect(
        valid.toString(), 'from 2019-03-31 00:00:00 until 2019-04-01 00:00:00');
    expect(valid.periodFrom.year, 2019);
    expect(valid.periodFrom.month, 3);
    expect(valid.periodFrom.day, 31);
    expect(valid.periodFrom.hour, 0);
    expect(valid.periodFrom.minute, 0);
    expect(valid.periodUntil.year, 2019);
    expect(valid.periodUntil.month, 4);
    expect(valid.periodUntil.day, 1);
    expect(valid.periodUntil.hour, 0);
    expect(valid.periodUntil.minute, 0);
    expect(
        valid.asMap(),
        equals(<String, Object?>{
          'code': '3100/3124',
          'from_': {'code': null, 'datetime': '2019-03-31 00:00:00'},
          'until': {'code': null, 'datetime': '2019-04-01 00:00:00'}
        }));
  });

  test('Test 0306 valid period', () {
    final code = '''
    KBWI 250258Z 2503/2606 08006KT 2SM -RA BR OVC008
        TEMPO 2503/2507 2SM -FZRA BKN005
        FM250700 10005KT 2SM RA BR OVC008
        FM250900 00000KT 1SM -RA BR OVC005
        FM251300 00000KT 3SM -RA BR OVC015
        FM251600 27013G25KT 6SM BR FEW015 SCT250
        FM252200 31016G25KT P6SM FEW250
    ''';
    final taf = Taf(code, year: _year, month: _month);
    final valid = taf.valid;

    expect(valid.code, '2503/2606');
    expect(
        valid.toString(), 'from 2019-03-25 03:00:00 until 2019-03-26 06:00:00');
    expect(valid.periodFrom.year, 2019);
    expect(valid.periodFrom.month, 3);
    expect(valid.periodFrom.day, 25);
    expect(valid.periodFrom.hour, 3);
    expect(valid.periodFrom.minute, 0);
    expect(valid.periodUntil.year, 2019);
    expect(valid.periodUntil.month, 3);
    expect(valid.periodUntil.day, 26);
    expect(valid.periodUntil.hour, 6);
    expect(valid.periodUntil.minute, 0);
    expect(
        valid.asMap(),
        equals(<String, Object?>{
          'code': '2503/2606',
          'from_': {'code': null, 'datetime': '2019-03-25 03:00:00'},
          'until': {'code': null, 'datetime': '2019-03-26 06:00:00'}
        }));
  });

  test('Test 1806 valid period', () {
    final code = '''
    KSEA 021730Z 0218/0306 VRB03KT P6SM SKC
        FM022000 35006KT P6SM SKC
    ''';
    final taf = Taf(code, year: _year, month: _month);
    final valid = taf.valid;

    expect(valid.code, '0218/0306');
    expect(
        valid.toString(), 'from 2019-03-02 18:00:00 until 2019-03-03 06:00:00');
    expect(valid.periodFrom.year, 2019);
    expect(valid.periodFrom.month, 3);
    expect(valid.periodFrom.day, 2);
    expect(valid.periodFrom.hour, 18);
    expect(valid.periodFrom.minute, 0);
    expect(valid.periodUntil.year, 2019);
    expect(valid.periodUntil.month, 3);
    expect(valid.periodUntil.day, 3);
    expect(valid.periodUntil.hour, 6);
    expect(valid.periodUntil.minute, 0);
    expect(
        valid.asMap(),
        equals(<String, Object?>{
          'code': '0218/0306',
          'from_': {'code': null, 'datetime': '2019-03-02 18:00:00'},
          'until': {'code': null, 'datetime': '2019-03-03 06:00:00'}
        }));
  });

  test('Test 0012 valid period', () {
    final code = '''
    KFLL 052312Z 0600/0612 10009KT P6SM FEW025
        FM060800 10011KT P6SM FEW025 SCT050
    ''';
    final taf = Taf(code, year: _year, month: _month);
    final valid = taf.valid;

    expect(valid.code, '0600/0612');
    expect(
        valid.toString(), 'from 2019-03-06 00:00:00 until 2019-03-06 12:00:00');
    expect(valid.periodFrom.year, 2019);
    expect(valid.periodFrom.month, 3);
    expect(valid.periodFrom.day, 6);
    expect(valid.periodFrom.hour, 0);
    expect(valid.periodFrom.minute, 0);
    expect(valid.periodUntil.year, 2019);
    expect(valid.periodUntil.month, 3);
    expect(valid.periodUntil.day, 6);
    expect(valid.periodUntil.hour, 12);
    expect(valid.periodUntil.minute, 0);
    expect(
        valid.asMap(),
        equals(<String, Object?>{
          'code': '0600/0612',
          'from_': {'code': null, 'datetime': '2019-03-06 00:00:00'},
          'until': {'code': null, 'datetime': '2019-03-06 12:00:00'}
        }));
  });

  test('Test 0024 valid period', () {
    final code = '''
    TAF FKKD 302300Z 3100/3124 VRB05KT 8000 BKN013 FEW016CB
        TEMPO 3105/3107 2000 BR
        BECMG 3106/3108 BKN016 FEW020CB
    ''';
    final taf = Taf(code, year: _year, month: 12);
    final valid = taf.valid;

    expect(valid.code, '3100/3124');
    expect(
        valid.toString(), 'from 2019-12-31 00:00:00 until 2020-01-01 00:00:00');
    expect(valid.periodFrom.year, 2019);
    expect(valid.periodFrom.month, 12);
    expect(valid.periodFrom.day, 31);
    expect(valid.periodFrom.hour, 0);
    expect(valid.periodFrom.minute, 0);
    expect(valid.periodUntil.year, 2020);
    expect(valid.periodUntil.month, 1);
    expect(valid.periodUntil.day, 1);
    expect(valid.periodUntil.hour, 0);
    expect(valid.periodUntil.minute, 0);
    expect(
        valid.asMap(),
        equals(<String, Object?>{
          'code': '3100/3124',
          'from_': {'code': null, 'datetime': '2019-12-31 00:00:00'},
          'until': {'code': null, 'datetime': '2020-01-01 00:00:00'}
        }));
  });
}
