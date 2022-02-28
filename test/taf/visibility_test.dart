import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the prevailing visibility from meters', () {
    final code = '''
    KATL 282202Z 2822/0124 04006KT P6SM SKC
        FM010100 00000KT P6SM SKC
        FM010800 33003KT P6SM BKN250
        FM011700 29005KT P6SM SKC
    ''';
    final taf = Taf(code);
    final visibility = taf.prevailingVisibility;

    expect(visibility.code, 'P6SM');
    expect(visibility.inMeters, 11112.0);
    expect(visibility.inKilometers, 11.112);
    expect(visibility.inSeaMiles, closeTo(6.0, 0.1));
    expect(visibility.inFeet, closeTo(36456.7, 0.1));
    expect(visibility.cavok, false);
    expect(visibility.cardinalDirection, null);
    expect(visibility.directionInDegrees, null);
    expect(visibility.directionInRadians, null);
    expect(visibility.toString(), '11.1 km');
  });
}
