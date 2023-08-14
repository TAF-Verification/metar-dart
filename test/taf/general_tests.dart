import 'dart:developer';

import 'package:metar_dart/metar_dart.dart';
import 'package:test/test.dart';

void main() {
  test('Test NWWW', (() {
    final metar = Metar(
        'NWWW 111130Z AUTO 18005KT 150V240 9999 -RA SCT008/// BKN019/// BKN041/// ///TCU 23/22 Q1011 TEMPO SHRA');
    log(metar.toString());
    expect(
        metar.toString(),
        'Name: LA TONTOUTA NLLE | Coordinates: 22.01S 166.13E | Elevation: 16 m MSL | Country: Samoa\n'
        '2022-04-11 11:30:00\n'
        'automatic report\n'
        'S (180.0°) 5.0 kt\n'
        'from SSE (150.0°) to WSW (240.0°)\n'
        '10.0 km\n'
        'light rain\n'
        'scattered at 800.0 feet\n'
        'broken at 1900.0 feet\n'
        'broken at 4100.0 feet\n'
        'undefined\n'
        'temperature: 23.0°C | dewpoint: 22.0°C\n'
        '1011.0 hPa\n'
        'temporary from 2022-04-11 11:30:00 until 2022-04-11 13:30:00\n'
        'showers rain');
  }));
}
