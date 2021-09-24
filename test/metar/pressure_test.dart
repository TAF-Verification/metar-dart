import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the pressure of METAR from hPa', () {
    final code = 'METAR OESH 201700Z 06004KT CAVOK 31/00 Q1013 NOSIG';
    final metar = Metar(code);
    final pressure = metar.pressure;

    expect(pressure.inHectoPascals, 1013.0);
    expect(pressure.inMercuryInches, 29.91389);
    expect(pressure.inMilliBars, 1013.0);
    expect(pressure.inBars, 1.013);
    expect(pressure.inAtmospheres, 0.99975);
    expect(pressure.toString(), '1013.00 hPa');
  });

  test('Test the pressure of METAR from inHg', () {
    final code = 'METAR MMGL 201721Z 00000KT 7SM NSC 26/M07 A3025 RMK HZY CI';
    final metar = Metar(code);
    final pressure = metar.pressure;

    expect(pressure.inHectoPascals, 1024.38198);
    expect(pressure.inMercuryInches, 30.25);
    expect(pressure.inMilliBars, 1024.38198);
    expect(pressure.inBars, 1.02438);
    expect(pressure.inAtmospheres, 1.01099);
    expect(pressure.toString(), '1024.38 hPa');
  });

  test('Test no pressure data', () {
    final code =
        r'SPECI KMIA 152353Z 00000KT 10SM FEW024 BKN150 BKN250 27/23 A//// RMK AO2 RAB2254E04 SLP127 P0000 60029 T02670233 10317 20256 50004 $';
    final metar = Metar(code);
    final pressure = metar.pressure;

    expect(pressure.inHectoPascals, null);
    expect(pressure.inMercuryInches, null);
    expect(pressure.inMilliBars, null);
    expect(pressure.inBars, null);
    expect(pressure.inAtmospheres, null);
    expect(pressure.toString(), r'');
  });
}
