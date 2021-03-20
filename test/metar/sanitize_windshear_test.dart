import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the sanitize windshear method', () {
    final code =
        'METAR MROC 202300Z 12011KT 9999 FEW035 BKN100 23/15 A2998 WS R07 NOSIG';
    final sanitizedMetarBody =
        'METAR MROC 202300Z 12011KT 9999 FEW035 BKN100 23/15 A2998 WSR07';
    final metar = Metar(code);

    test('First sample', () {
      expect(metar.body, sanitizedMetarBody);
    });
  });

  group('Test the sanitize windshear method. With runway name', () {
    final code =
        'METAR MROC 202300Z 12011KT 9999 FEW035 BKN100 23/15 A2998 WS R07C NOSIG';
    final sanitizedMetarBody =
        'METAR MROC 202300Z 12011KT 9999 FEW035 BKN100 23/15 A2998 WSR07C';
    final metar = Metar(code);

    test('Second sample', () {
      expect(metar.body, sanitizedMetarBody);
    });
  });

  group('Test the sanitize windshear method. All runways', () {
    final code =
        'METAR MROC 202300Z 12011KT 9999 FEW035 BKN100 23/15 A2998 WS ALL RWY NOSIG';
    final sanitizedMetarBody =
        'METAR MROC 202300Z 12011KT 9999 FEW035 BKN100 23/15 A2998 WSALLRWY';
    final metar = Metar(code);

    test('Third sample', () {
      expect(metar.body, sanitizedMetarBody);
    });
  });
}
