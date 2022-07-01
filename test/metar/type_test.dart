import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test METAR report type', () {
    final metar = Metar(
        'METAR UUDD 060000Z 18004MPS CAVOK M01/M04 Q1002 R14R/CLRD60 NOSIG');

    expect(metar.type_.code, 'METAR');
    expect(metar.type_.type, 'Meteorological Aerodrome Report');
    expect(metar.type_.toString(), 'Meteorological Aerodrome Report (METAR)');
    expect(
        metar.type_.asMap(),
        equals(<String, String?>{
          'code': 'METAR',
          'type': 'Meteorological Aerodrome Report',
        }));
  });

  test('Test SPECI report type', () {
    final metar = Metar(
        'SPECI UUDD 060030Z 18004MPS CAVOK M01/M04 Q1002 R14R/CLRD60 NOSIG');

    expect(metar.type_.code, 'SPECI');
    expect(metar.type_.type, 'Special Aerodrome Report');
    expect(metar.type_.toString(), 'Special Aerodrome Report (SPECI)');
    expect(
        metar.type_.asMap(),
        equals(<String, String?>{
          'code': 'SPECI',
          'type': 'Special Aerodrome Report',
        }));
  });

  test('Test METAR report type default', () {
    final metar =
        Metar('UUDD 060030Z 18004MPS CAVOK M01/M04 Q1002 R14R/CLRD60 NOSIG');

    expect(metar.type_.code, 'METAR');
    expect(metar.type_.type, 'Meteorological Aerodrome Report');
    expect(metar.type_.toString(), 'Meteorological Aerodrome Report (METAR)');
    expect(
        metar.type_.asMap(),
        equals(<String, String?>{
          'code': 'METAR',
          'type': 'Meteorological Aerodrome Report',
        }));
  });
}
