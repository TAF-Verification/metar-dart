import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';
import 'package:metar_dart/src/utils/sanitize_windshear.dart';

void main() {
  test('Test the sanitize windshear method', () {
    final code =
        'METAR MROC 202300Z 12011KT 9999 FEW035 BKN100 23/15 A2998 WS R07 NOSIG';
    final sanitizedMetarBody =
        'METAR MROC 202300Z 12011KT 9999 FEW035 BKN100 23/15 A2998 WS_R07';
    final metar = Metar(code);

    expect(sanitizeWindshear(metar.body), sanitizedMetarBody);
  });

  test('Test the sanitize windshear method. With runway name', () {
    final code =
        'METAR MROC 202300Z 12011KT 9999 FEW035 BKN100 23/15 A2998 WS R07C NOSIG';
    final sanitizedMetarBody =
        'METAR MROC 202300Z 12011KT 9999 FEW035 BKN100 23/15 A2998 WS_R07C';
    final metar = Metar(code);

    expect(sanitizeWindshear(metar.body), sanitizedMetarBody);
  });

  test('Test the sanitize windshear method. All runways', () {
    final code =
        'METAR MROC 202300Z 12011KT 9999 FEW035 BKN100 23/15 A2998 WS ALL RWY NOSIG';
    final sanitizedMetarBody =
        'METAR MROC 202300Z 12011KT 9999 FEW035 BKN100 23/15 A2998 WS_ALL_RWY';
    final metar = Metar(code);

    expect(sanitizeWindshear(metar.body), sanitizedMetarBody);
  });
}
