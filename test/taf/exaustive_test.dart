import 'package:metar_dart/metar_dart.dart';
import 'package:test/test.dart';

void main() {
  test('warnings test', () {
    final code =
        '''TAF MMPQ 221654Z 2218/2318 10015KT P6SM SCT020 FM230300 13010KT P6SM BKN010 TEMPO 2308/2312 3SM -RA BKN005 D2DS FM231500 12010KT 4SM HZ SCT010 333''';
    final taf = Taf(code);
    expect(taf.warnings.first, 'TAF Group not found: D2DS');
    expect(taf.warnings[1], 'TAF Group not found: 333');
  });
}
