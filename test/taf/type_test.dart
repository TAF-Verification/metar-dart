import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test TAF report type, first sample', () {
    final code = '''
    TAF UUDD 221352Z 2215/2321 22007MPS 9999 BKN016 TX04/2215Z TNM03/2321Z
        TEMPO 2215/2221 22012G17MPS 2000 SHSNRA FEW007 BKN016CB
        BECMG 2306/2308 28007MPS
        BECMG 2315/2317 28002MPS
    ''';
    final metar = Taf(code);

    expect(metar.type.code, 'TAF');
    expect(metar.type.type, 'Terminal Aerodrome Forecast');
    expect(metar.type.toString(), 'Terminal Aerodrome Forecast (TAF)');
  });

  test('Test TAF report type, second sample', () {
    final code = '''
    TAF MMPQ 221654Z 2218/2318 10015KT P6SM SCT020
        FM230300 13010KT P6SM BKN010
        TEMPO 2308/2312 3SM -RA BKN005
        FM231500 12010KT 4SM HZ SCT010
    ''';
    final metar = Taf(code);

    expect(metar.type.code, 'TAF');
    expect(metar.type.type, 'Terminal Aerodrome Forecast');
    expect(metar.type.toString(), 'Terminal Aerodrome Forecast (TAF)');
  });

  test('Test TAF report type by default', () {
    final code = '''
    MRLM 221100Z 2212/2312 24005KT 9999 FEW025 TX30/2221Z TN19/2311Z
        BECMG 2215/2217 07006KT
        BECMG 2300/2303 25004KT
    ''';
    final metar = Taf(code);

    expect(metar.type.code, 'TAF');
    expect(metar.type.type, 'Terminal Aerodrome Forecast');
    expect(metar.type.toString(), 'Terminal Aerodrome Forecast (TAF)');
  });
}
