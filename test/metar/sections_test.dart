import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final code =
      'METAR MROC 071200Z COR 10015G25KT 250V110 0500 R07/P2000N BR VV003 17/09 A2994 RESHRA RMK VIS TO E 5KM NOSIG';
  final metar = Metar(code, month: 8, year: 2021);

  test('Test the sections of METAR', () {
    expect(
      metar.body,
      'METAR MROC 071200Z COR 10015G25KT 250V110 0500 R07/P2000N BR VV003 17/09 A2994 RESHRA',
    );
    expect(metar.remark, 'RMK VIS TO E 5KM');
    expect(metar.trend, 'NOSIG');
  });
}
