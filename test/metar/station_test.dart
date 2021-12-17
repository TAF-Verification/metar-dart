import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final code =
      'KJFK 122051Z 32004KT 10SM OVC065 M02/M15 A3031 RMK AO2 SLP264 T10171150 56004';
  final metar = Metar(code);
  final station = metar.station;

  test('Test the IATA code of station', () {
    expect(station.code, 'KJFK');
    expect(station.name, 'NY NYC/JFK ARPT');
    expect(station.icao, 'KJFK');
    expect(station.iata, 'JFK');
    expect(station.synop, '74486');
    expect(station.country, 'United States of America (the)');
    expect(station.latitude, '40.38N');
    expect(station.longitude, '073.46W');
    expect(station.elevation, '9');
    expect(
      station.toString(),
      'Name: NY NYC/JFK ARPT | Coordinates: 40.38N - 073.46W | Elevation: 9 m MSL | Country: United States of America (the)',
    );
  });
}
