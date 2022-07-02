import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final code = '''
  TAF SEQM 231655Z 2318/2418 35012KT 9999 SCT030 BKN100
      TEMPO 2320/2323 TS FEW023CB BKN026 BKN080
      BECMG 2400/2401 02005KT FEW008 BKN026 BKN080
      BECMG 2404/2406 VRB03KT 4000 BCFG BKN003 BKN020
      BECMG 2412/2414 9999 SCT023 SCT100 TX20/2319Z TN11/2411Z
  ''';
  final taf = Taf(code);
  final station = taf.station;

  test('Test the TAF station', () {
    expect(station.code, 'SEQM');
    expect(station.name, 'QUITO/NEW INTL');
    expect(station.icao, 'SEQM');
    expect(station.iata, 'null');
    expect(station.synop, 'null');
    expect(station.country, 'Ecuador');
    expect(station.latitude, '00.07S');
    expect(station.longitude, '078.21W');
    expect(station.elevation, '2400');
    expect(
      station.toString(),
      'Name: QUITO/NEW INTL | Coordinates: 00.07S 078.21W | Elevation: 2400 m MSL | Country: Ecuador',
    );
    expect(
        station.asMap(),
        equals(<String, String?>{
          'code': 'SEQM',
          'name': 'QUITO/NEW INTL',
          'icao': 'SEQM',
          'iata': 'null',
          'synop': 'null',
          'latitude': '00.07S',
          'longitude': '078.21W',
          'elevation': '2400',
          'country': 'Ecuador'
        }));
  });
}
