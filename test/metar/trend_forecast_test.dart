import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test the trend forecast of METAR', () {
    final metar = Metar(
        'METAR MRPV 091700Z COR 07005KT 9999 BKN045 27/17 A3003 BECMG 29005KT');
    final trend = metar.trendForecast;

    expect(trend.codes, ['BECMG', null, null, null]);
    expect(trend.trend, 'becoming');
    expect(trend.from_time, null);
    expect(trend.until_time, null);
    expect(trend.at_time, null);
    expect(trend.toString(), 'becoming');
  });

  test('Test the trend forecast of METAR with from time group', () {
    final metar = Metar(
        'METAR LFOT 090330Z AUTO 04006KT 360V070 CAVOK 11/09 Q1023 BECMG FM0400 1400 BR OVC003');
    final trend = metar.trendForecast;

    expect(trend.codes, ['BECMG', 'FM0400', null, null]);
    expect(trend.trend, 'becoming');
    expect(trend.from_time, '04:00Z');
    expect(trend.until_time, null);
    expect(trend.at_time, null);
    expect(trend.toString(), 'becoming from 04:00Z');
  });

  test('Test the trend forecast of METAR with from and until time groups', () {
    final metar = Metar(
        'METAR LFOT 090330Z AUTO 04006KT 360V070 CAVOK 11/09 Q1023 TEMPO FM0400 TL0630 1400 BR OVC003');
    final trend = metar.trendForecast;

    expect(trend.codes, ['TEMPO', 'FM0400', 'TL0630', null]);
    expect(trend.trend, 'temporary');
    expect(trend.from_time, '04:00Z');
    expect(trend.until_time, '06:30Z');
    expect(trend.at_time, null);
    expect(trend.toString(), 'temporary from 04:00Z until 06:30Z');
  });

  test('Test the trend forecast of METAR with at group', () {
    final metar = Metar(
        'METAR LFOT 090330Z AUTO 04006KT 360V070 CAVOK 11/09 Q1023 BECMG AT0400 1400 BR OVC003');
    final trend = metar.trendForecast;

    expect(trend.codes, ['BECMG', null, null, 'AT0400']);
    expect(trend.trend, 'becoming');
    expect(trend.from_time, null);
    expect(trend.until_time, null);
    expect(trend.at_time, '04:00Z');
    expect(trend.toString(), 'becoming at 04:00Z');
  });
}
