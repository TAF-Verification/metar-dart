import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final delta = 0.001;
  test('Test the pressure of METAR from hPa', () {
    final code = 'METAR OESH 201700Z 06004KT CAVOK 31/00 Q1013 NOSIG';
    final metar = Metar(code);
    final pressure = metar.pressure;

    expect(pressure.code, 'Q1013');
    expect(pressure.inHPa, 1013.0);
    expect(pressure.inInHg, closeTo(29.91, 0.004));
    expect(pressure.inMbar, 1013.0);
    expect(pressure.inBar, closeTo(1.013, delta));
    expect(pressure.inAtm, closeTo(0.99975, 0.00001));
    expect(pressure.toString(), '1013.0 hPa');
    expect(
        pressure.asMap(),
        equals(<String, Object?>{
          'units': 'hectopascals',
          'pressure': 1013.0,
        }));
  });

  test('Test the pressure of METAR from inHg', () {
    final code = 'METAR MMGL 201721Z 00000KT 7SM NSC 26/M07 A3025 RMK HZY CI';
    final metar = Metar(code);
    final pressure = metar.pressure;

    expect(pressure.code, 'A3025');
    expect(pressure.inHPa, closeTo(1024.38, 0.002));
    expect(pressure.inInHg, closeTo(30.25, 0.001));
    expect(pressure.inMbar, closeTo(1024.38198, 0.002));
    expect(pressure.inBar, closeTo(1.02438, 0.00001));
    expect(pressure.inAtm, closeTo(1.01099, 0.00001));
    expect(pressure.toString(), '1024.4 hPa');
    expect(
        pressure.asMap(),
        equals(<String, Object?>{
          'units': 'hectopascals',
          'pressure': 1024.381984422621,
        }));
  });

  test('Test no pressure data', () {
    final code =
        r'SPECI KMIA 152353Z 00000KT 10SM FEW024 BKN150 BKN250 27/23 A//// RMK AO2 RAB2254E04 SLP127 P0000 60029 T02670233 10317 20256 50004 $';
    final metar = Metar(code);
    final pressure = metar.pressure;

    expect(pressure.code, 'A//\//');
    expect(pressure.inHPa, null);
    expect(pressure.inInHg, null);
    expect(pressure.inMbar, null);
    expect(pressure.inBar, null);
    expect(pressure.inAtm, null);
    expect(pressure.toString(), '');
    expect(
        pressure.asMap(),
        equals(<String, Object?>{
          'units': 'hectopascals',
          'pressure': null,
        }));
  });
}
