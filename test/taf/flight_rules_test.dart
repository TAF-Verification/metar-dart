import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test TAF flight rules', () {
    final code = '''
    TAF UUDD 061958Z 0621/0803 22003MPS 9999 SCT016 TX09/0712Z TNM03/0621Z
        BECMG 0703/0704 18008G14MPS 5000 -SNRA
        TEMPO 0704/0709 0700 +SHSN FEW007 BKN016CB
        PROB40
        TEMPO 0704/0709 -FZRA OVC007
    ''';
    final taf = Taf(code);

    expect(taf.flightRules, 'VFR');

    final changes = taf.changePeriods;
    expect(changes[0].flightRules, equals('MVFR'));
    expect(changes[1].flightRules, 'VLIFR');
    expect(changes[2].flightRules, 'IFR');
  });
}
