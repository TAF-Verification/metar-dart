import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final _year = 2018;
  final _month = 10;

  test('Test three changes', () {
    final code = '''
    TAF UNOO 061700Z 0618/0718 22007G13MPS 6000 -SHSN BKN010 BKN025CB
        TEMPO 0618/0706 1000 SHSN BLSN VV004
        BECMG 0700/0702 26006G12MPS
        BECMG 0708/0710 27007G13MPS
    ''';
    final taf = Taf(code);
    final changes = taf.changePeriods;

    expect(changes.length, 3);
    expect(changes.codes, <String>[
      'TEMPO 0618/0706 1000 SHSN BLSN VV004',
      'BECMG 0700/0702 26006G12MPS',
      'BECMG 0708/0710 27007G13MPS',
    ]);

    final leadingZero = (int value) => value < 10 ? '0$value' : '$value';
    final month = leadingZero(DateTime.now().month);

    final change0 = changes[0];
    expect(change0.code, 'TEMPO 0618/0706 1000 SHSN BLSN VV004');
    expect(change0.changeIndicator.code, 'TEMPO 0618/0706');
    expect(change0.changeIndicator.translation,
        'temporary from 2022-$month-06 18:00:00 until 2022-$month-07 06:00:00');

    final change1 = changes[1];
    expect(change1.code, 'BECMG 0700/0702 26006G12MPS');
    expect(change1.changeIndicator.code, 'BECMG 0700/0702');
    expect(change1.changeIndicator.translation,
        'becoming from 2022-$month-07 00:00:00 until 2022-$month-07 02:00:00');

    final change2 = changes[2];
    expect(change2.code, 'BECMG 0708/0710 27007G13MPS');
    expect(change2.changeIndicator.code, 'BECMG 0708/0710');
    expect(change2.changeIndicator.translation,
        'becoming from 2022-$month-07 08:00:00 until 2022-$month-07 10:00:00');

    expect(
      () => changes[3].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test six changes', () {
    final code = '''
    TAF KATL 062027Z 0620/0724 21010G20KT P6SM BKN050
        FM070000 17005KT P6SM FEW250
        FM070500 20010KT P6SM SCT050
        FM071700 22015G25KT P6SM BKN030
        PROB30 0717/0721 4SM -SHRA BR OVC015
        FM072200 24015G25KT 6SM -SHRA BR BKN035
        PROB30 TEMPO 0722/0724 4SM TSRA BR OVC025CB
    ''';
    final taf = Taf(code, year: _year, month: _month);
    final changes = taf.changePeriods;

    expect(changes.length, 6);
    expect(changes.codes, <String>[
      'FM070000 17005KT P6SM FEW250',
      'FM070500 20010KT P6SM SCT050',
      'FM071700 22015G25KT P6SM BKN030',
      'PROB30 0717/0721 4SM -SHRA BR OVC015',
      'FM072200 24015G25KT 6SM -SHRA BR BKN035',
      'PROB30 TEMPO 0722/0724 4SM TSRA BR OVC025CB',
    ]);

    final change0 = changes[0];
    expect(change0.code, 'FM070000 17005KT P6SM FEW250');
    expect(change0.changeIndicator.code, 'FM070000');
    expect(change0.changeIndicator.translation,
        'from 2018-10-07 00:00:00 until 2018-10-07 04:00:00');

    final change1 = changes[1];
    expect(change1.code, 'FM070500 20010KT P6SM SCT050');
    expect(change1.changeIndicator.code, 'FM070500');
    expect(change1.changeIndicator.translation,
        'from 2018-10-07 05:00:00 until 2018-10-07 16:00:00');

    final change2 = changes[2];
    expect(change2.code, 'FM071700 22015G25KT P6SM BKN030');
    expect(change2.changeIndicator.code, 'FM071700');
    expect(change2.changeIndicator.translation,
        'from 2018-10-07 17:00:00 until 2018-10-07 21:00:00');

    final change3 = changes[3];
    expect(change3.code, 'PROB30 0717/0721 4SM -SHRA BR OVC015');
    expect(change3.changeIndicator.code, 'PROB30 0717/0721');
    expect(change3.changeIndicator.translation,
        'probability 30% from 2018-10-07 17:00:00 until 2018-10-07 21:00:00');

    final change4 = changes[4];
    expect(change4.code, 'FM072200 24015G25KT 6SM -SHRA BR BKN035');
    expect(change4.changeIndicator.code, 'FM072200');
    expect(change4.changeIndicator.translation,
        'from 2018-10-07 22:00:00 until 2018-10-08 00:00:00');

    final change5 = changes[5];
    expect(change5.code, 'PROB30 TEMPO 0722/0724 4SM TSRA BR OVC025CB');
    expect(change5.changeIndicator.code, 'PROB30 TEMPO 0722/0724');
    expect(change5.changeIndicator.translation,
        'probability 30% temporary from 2018-10-07 22:00:00 until 2018-10-08 00:00:00');

    expect(
      () => changes[6].code,
      throwsA(isA<RangeError>()),
    );
  });

  test('Test no changes', () {
    final code = 'TAF KPHX 062100Z 0621/0724 27007KT P6SM FEW070';
    final taf = Taf(code);
    final changes = taf.changePeriods;

    expect(changes.length, 0);
    expect(changes.codes, <String>[]);

    expect(
      () => changes[0].code,
      throwsA(isA<RangeError>()),
    );
  });
}
