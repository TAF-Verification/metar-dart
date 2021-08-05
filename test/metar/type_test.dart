import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test METAR report type', () {
    final metar = Metar(
        'METAR UUDD 060000Z 18004MPS CAVOK M01/M04 Q1002 R14R/CLRD60 NOSIG');

    expect(metar.type.type, 'Meteorological Aerodrome Report');
  });

  test('Test SPECI report type', () {
    final metar = Metar(
        'SPECI UUDD 060030Z 18004MPS CAVOK M01/M04 Q1002 R14R/CLRD60 NOSIG');

    expect(metar.type.type, 'Special Aerodrome Report');
  });

  test('Test METAR report type default', () {
    final metar =
        Metar('UUDD 060030Z 18004MPS CAVOK M01/M04 Q1002 R14R/CLRD60 NOSIG');

    expect(metar.type.type, 'Meteorological Aerodrome Report');
  });
}
