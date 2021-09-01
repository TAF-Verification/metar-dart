import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test one windshear.', () {
    final code =
        'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS R07 NOSIG';
    final metar = Metar(code);
    final windshear = metar.windshear;

    test('First test.', () {
      final value = windshear.first.name;
      expect(value, '07');
    });

    test('Second test.', () {
      final value = windshear.second.name;
      expect(value, null);
    });

    test('Third test.', () {
      final value = windshear.third.name;
      expect(value, null);
    });

    test('All test.', () {
      final value = windshear.allRunways;
      expect(value, false);
    });
  });

  group('Test two windshears.', () {
    final code =
        'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS R07L WS R25C NOSIG';
    final metar = Metar(code);
    final windshear = metar.windshear;

    test('First test.', () {
      final value = windshear.first.name;
      expect(value, '07 left');
    });

    test('Second test.', () {
      final value = windshear.second.name;
      expect(value, '25 center');
    });

    test('Third test.', () {
      final value = windshear.third.name;
      expect(value, null);
    });

    test('All test.', () {
      final value = windshear.allRunways;
      expect(value, false);
    });
  });

  group('Test all runways.', () {
    final code =
        'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS ALL RWY NOSIG';
    final metar = Metar(code);
    final windshear = metar.windshear;

    test('First test.', () {
      final value = windshear.first.name;
      expect(value, null);
    });

    test('Second test.', () {
      final value = windshear.second.name;
      expect(value, null);
    });

    test('Third test.', () {
      final value = windshear.third.name;
      expect(value, null);
    });
    test('All test.', () {
      final value = windshear.allRunways;
      expect(value, true);
    });
  });
}
