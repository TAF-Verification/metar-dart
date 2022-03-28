import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test changes visibility from sea miles', () {
    final code = '''
    TAF KATL 282202Z 2822/0124 04006KT P6SM SKC
        FM010100 00000KT P6SM SKC
        TEMPO 0106/0112 33003KT 1 1/4SM BKN020
        BECMG 0117/0119 29005KT 1/2SM SN BKN010
    ''';
    final taf = Taf(code);
    final changes = taf.changePeriods;

    final visibility0 = changes[0].prevailingVisibility;
    expect(visibility0.code, 'P6SM');
    expect(visibility0.inMeters, 11112.0);
    expect(visibility0.inKilometers, 11.112);
    expect(visibility0.inSeaMiles, closeTo(6.0, 0.1));
    expect(visibility0.inFeet, closeTo(36456.7, 0.1));
    expect(visibility0.cavok, false);
    expect(visibility0.cardinalDirection, null);
    expect(visibility0.directionInDegrees, null);
    expect(visibility0.directionInRadians, null);
    expect(visibility0.toString(), '11.1 km');

    final visibility1 = changes[1].prevailingVisibility;
    expect(visibility1.code, '1 1/4SM');
    expect(visibility1.inMeters, 2315.0);
    expect(visibility1.inKilometers, 2.315);
    expect(visibility1.inSeaMiles, closeTo(1.25, 0.01));
    expect(visibility1.inFeet, closeTo(7595.14, 0.01));
    expect(visibility1.cavok, false);
    expect(visibility1.cardinalDirection, null);
    expect(visibility1.directionInDegrees, null);
    expect(visibility1.directionInRadians, null);
    expect(visibility1.toString(), '2.3 km');

    final visibility2 = changes[2].prevailingVisibility;
    expect(visibility2.code, '1/2SM');
    expect(visibility2.inMeters, 926.0);
    expect(visibility2.inKilometers, 0.926);
    expect(visibility2.inSeaMiles, closeTo(0.5, 0.01));
    expect(visibility2.inFeet, closeTo(3038.05, 0.01));
    expect(visibility2.cavok, false);
    expect(visibility2.cardinalDirection, null);
    expect(visibility2.directionInDegrees, null);
    expect(visibility2.directionInRadians, null);
    expect(visibility2.toString(), '0.9 km');
  });
}
